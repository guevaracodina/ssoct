--
-- Brief: Controls the Avalon MM-Master Write Module, which is very similar to a normal FIFO buffer.
--

-- Libraries --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--  Entity Declaration
ENTITY TestWrite IS
	GENERIC(
		ADDRESS_WIDTH : NATURAL := 30;
		ADDRESS_TOTAL : NATURAL := 1073741824;
		BYTES_PER_TRANSFER : NATURAL := 32 --256BITS/8
	);
	
	PORT
	(
		RSTn : IN STD_LOGIC;
		CLK48MHZ : IN STD_LOGIC;
		
		-- Control signals to the Avalon MM-Master.
		control_go : BUFFER STD_LOGIC; -- Empties FIFO data in the SDRAM.
		control_write_base : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes.									
		control_write_length : OUT UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes. Don't transfer more data than length, otherwise there will be an overflow.
		control_done : IN STD_LOGIC; -- Only used to make sure the transfer is done before starting a new one.
		
		-- FIFO signals to the Avalon MM-Master.
		user_buffer_data : OUT UNSIGNED(31 DOWNTO 0); -- UNSIGNED only for test purpose, should be STD_LOGIC_VECTOR.
		user_buffer_full : IN STD_LOGIC;
		user_write_buffer : BUFFER STD_LOGIC;
		
		-- Pointers used to keep track of the location of the data in the SDRAM.
        addressLastCompleteWrite : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- Pointer corresponding to the last data written on the SDRAM. Must be available to the read module.
        addressLastCompleteRead : IN UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- Pointer corresponding to the last data read on the SDRAM. Used to make sure the SDRAM is not full.
		
		-- Used for debugging.
		writingDone : OUT STD_LOGIC;
        debugOut : OUT UNSIGNED(31 DOWNTO 0);
        errorFull : OUT STD_LOGIC

	);
	
END TestWrite;

--  Architecture Body 
ARCHITECTURE TestWrite_architecture OF TestWrite IS

	-- State machine declaration.
	TYPE stateMachine IS (State_CheckSDRAMFull, State_CheckControllerReady, State_CheckFIFOFull, State_Writing, State_Done, State_AllDone);
	SIGNAL state : stateMachine;
	
	-- Internal value of user_write_buffer.
	SIGNAL user_write_buffer_internal : STD_LOGIC;
	
	-- Data transferred to the FIFO. It is modified during the transfer for the test.
	SIGNAL dataToWrite : UNSIGNED(31 DOWNTO 0);
    
    -- Number of groups of data to write on the SDRAM.
    CONSTANT GROUP_QUANTITY : INTEGER := 100000;
    
    -- Index corresponding to the group that is being written.
    SIGNAL idxGroup : INTEGER RANGE 0 TO 100000;
    
    -- Increment between a word and the next one in a group. The value changes for each group.
    SIGNAL incrementData : INTEGER RANGE 0 TO 40000;
    
    -- Number of bytes in a group. The value changes for each group.
    SIGNAL groupLength : INTEGER RANGE 0 TO 40000; -- Up to 20000 words.
    
    -- Index corresponding to the byte that is being written.
    SIGNAL idxByte : INTEGER RANGE 0 TO 400000;

BEGIN

PROCESS(RSTn, CLK48MHZ)
	-- Variable to test if the SDRAM is full.
	VARIABLE TestFull : INTEGER RANGE 0 TO 2000000000;
BEGIN
IF (RSTn = '0') THEN
	dataToWrite <= TO_UNSIGNED(1,32);
	writingDone <= '0';
	control_go <= '0';
	control_write_base <= TO_UNSIGNED(0,ADDRESS_WIDTH);
	control_write_length <= TO_UNSIGNED(0,ADDRESS_WIDTH);
    addressLastCompleteWrite <= TO_UNSIGNED(0,ADDRESS_WIDTH);
	state <= State_CheckSDRAMFull;
	idxByte <= 0;
	user_write_buffer_internal <= '0';
    addressLastCompleteWrite <= TO_UNSIGNED(0,ADDRESS_WIDTH);
    idxGroup <= 0;
    incrementData <= 30000; -- The first group has an increment of 30 000 between each word.
    groupLength <= 40000; -- The first group has a length of 40 000 bytes.
	debugOut <= TO_UNSIGNED(0,32);
    errorFull <= '0';
    
ELSIF (CLK48MHZ'EVENT AND CLK48MHZ = '1') THEN
	writingDone <= '0';
	control_go <= '0';
	user_write_buffer_internal <= '0';
    debugOut <= TO_UNSIGNED(TO_INTEGER(addressLastCompleteRead),32);
						
	CASE state IS
        
        WHEN State_CheckSDRAMFull => -- Make sure the SDRAM is not full. In this example we wait, but normally this should be an error.
		
            state <= State_CheckControllerReady;
			
			-- Verify if writing loops around the SDRAM (one part at the end of the SDRAM and the rest at the beginning).
            TestFull := TO_INTEGER(control_write_base);
            TestFull := TestFull + groupLength;
            IF TestFull < ADDRESS_TOTAL  THEN
                -- Verify if the read pointer is in the range where we want to write data. If it is, we wait.
                IF (addressLastCompleteRead > control_write_base AND addressLastCompleteRead < TestFull) THEN
                    state <= State_CheckSDRAMFull;
                    errorFull <= '1';
                END IF;
            ELSE
                -- Verify if the read pointer is in the range where we want to write data. If it is, we wait.
                IF (addressLastCompleteRead > control_write_base) OR (addressLastCompleteRead < TestFull - ADDRESS_TOTAL) THEN
                    state <= State_CheckSDRAMFull;
                    errorFull <= '1';
                END IF;
            END IF;   
			
		WHEN State_CheckControllerReady => -- Make sure the controller is ready to receive data.
		
			IF control_done = '1' AND user_buffer_full = '0' THEN
				state <= State_CheckFIFOFull;
				idxByte <= 0;
				dataToWrite <= TO_UNSIGNED(1,32); -- The first data to write in a group is always 1.
                idxGroup <= idxGroup + 1;
                control_write_length <= TO_UNSIGNED(groupLength,ADDRESS_WIDTH); -- In bytes.           
			END IF;
			
		WHEN State_CheckFIFOFull => 
		
			IF user_buffer_full = '0' THEN -- Not full.
				state <= State_Writing;		
			END IF;
		
		WHEN State_Writing =>
		
            -- One go pulse just after we begin the transfer. At least one data must be written before asserting this signal.
			IF idxByte = BYTES_PER_TRANSFER THEN
				control_go <= '1';
			END IF;	
            
            -- Check if buffer is full. If it is, the last data was not written, so we need to decrement the counter.
            IF user_buffer_full = '0' THEN
                -- The last data was written correctly. Now we check if we are done writing. If not, we write and increment the counter.
                IF idxByte < groupLength THEN
                    user_buffer_data <= dataToWrite;
                    idxByte <= idxByte + BYTES_PER_TRANSFER; -- In bytes.
                    user_write_buffer_internal <= '1';
                    dataToWrite <= dataToWrite + incrementData;

                    -- We intentionally put 3 errors in the data (6 errors should be detected, because two increments will be invalid for 3 wrong data).
                    IF idxGroup = 1000 AND idxByte = 192 THEN
                        user_buffer_data <= dataToWrite - 100;
                    ELSIF idxGroup = 9500 AND idxByte = 1920 THEN
                        user_buffer_data <= dataToWrite - 100;     
                    ELSIF idxGroup = 15000 AND idxByte = 384 THEN
                        user_buffer_data <= dataToWrite - 100;               
                    END IF;                    
                    
                ELSE
                    state <= State_Done;
                END IF;
            ELSE 
                state <= State_CheckFIFOFull;
                idxByte <= idxByte - BYTES_PER_TRANSFER; -- In bytes.
                dataToWrite <= dataToWrite - incrementData;							
            END IF;		
            
		WHEN State_Done =>
		
            addressLastCompleteWrite <= addressLastCompleteWrite + groupLength;
            
            -- Check if all groups of data has been written.
            IF idxGroup < GROUP_QUANTITY THEN
                state <= State_CheckSDRAMFull;
                
                -- For each group, the increment data between two words changes.
                incrementData <= incrementData + 1;
                
                -- Each group of data contains one more word than the last group.
                groupLength <= groupLength + BYTES_PER_TRANSFER; -- In bytes

                -- The base address of the next write must be changed.
                control_write_base <= addressLastCompleteWrite + groupLength + BYTES_PER_TRANSFER; -- In bytes. The sum wraps around if there is an overflow.
            ELSE
                state <= State_AllDone;
            END IF;
        
        WHEN State_AllDone =>
		
            writingDone <= '1';
																	
		WHEN OTHERS =>
		
			state <= State_CheckSDRAMFull;
				
	END CASE;	
END IF;

END PROCESS;

-- user_write_buffer must be in combinational logic.
user_write_buffer <= '1' WHEN (user_buffer_full = '0' AND user_write_buffer_internal = '1') ELSE '0';

END TestWrite_architecture;
