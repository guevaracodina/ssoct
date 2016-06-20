--
-- Brief: Controls the Avalon MM-Master Read Module, which is very similar to a normal FIFO buffer.
--

-- Libraries --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--  Entity Declaration
ENTITY TestRead IS
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
		control_go : OUT STD_LOGIC; -- Insert data in the FIFO from the SDRAM.
		control_read_base : OUT UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes.											
		control_read_length : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes.
		control_done : IN STD_LOGIC; -- Only used to make sure the transfer is done before starting a new one.
		
		-- FIFO signals to the Avalon MM-Master.
		user_buffer_data : IN UNSIGNED(31 DOWNTO 0); -- UNSIGNED only for test purpose, should be STD_LOGIC_VECTOR.
		user_read_buffer : OUT STD_LOGIC;
		user_data_available : IN STD_LOGIC;
        
		-- Pointers used to keep track of the location of the data in the SDRAM.
        addressLastCompleteWrite : IN UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- Pointer corresponding to the last data written on the SDRAM. If this is different than the address of the last read, it triggers a reading.
		addressLastCompleteRead : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0);
		
		-- Used for debugging.
		readingDone : OUT STD_LOGIC;
        debugOut : BUFFER UNSIGNED(31 DOWNTO 0);
        errorData : BUFFER UNSIGNED(2 DOWNTO 0)

	);
	
END TestRead;

--  Architecture Body 
ARCHITECTURE TestRead_architecture OF TestRead IS
	
	-- State machine declaration.
	TYPE stateMachine IS (State_CheckReadyAndDataAvailable, READING, DONE);
	SIGNAL state : stateMachine;
	
	-- Data transferred from the FIFO.
	SIGNAL dataRead : UNSIGNED(31 DOWNTO 0);
    
	-- Index of the data being read. Used to check if all the data has been read.
    SIGNAL idxDataRead : UNSIGNED(31 DOWNTO 0);
    
    -- Increment between a word and the next one in a group. This is calculated from the first data of a group and used to verify the integrity of the data.
    SIGNAL incrementData : INTEGER RANGE 0 TO 400000;

BEGIN

PROCESS(RSTn, CLK48MHZ)

BEGIN
IF (RSTn = '0') THEN
	control_go <= '0';
	readingDone <= '0';
	state <= State_CheckReadyAndDataAvailable;
	idxDataRead <= TO_UNSIGNED(0,32);
	control_read_base <= TO_UNSIGNED(0,ADDRESS_WIDTH); -- In bytes
	control_read_length <= TO_UNSIGNED(0,ADDRESS_WIDTH); -- In bytes	
    addressLastCompleteRead <= TO_UNSIGNED(0,ADDRESS_WIDTH); -- In bytes
    incrementData <= 0;
    debugOut <= TO_UNSIGNED(0,32);
    errorData <= (OTHERS => '0'); 
    dataRead <= TO_UNSIGNED(0,32);
	
ELSIF (CLK48MHZ'EVENT AND CLK48MHZ = '1') THEN
	control_go <= '0';
    readingDone <= '0';
	
	CASE state IS
	                
		WHEN State_CheckReadyAndDataAvailable => 
            -- Make sure the last transfer is finished.
			IF control_done = '1' AND user_data_available = '0' THEN 
                -- Verify if data is available by using the read and write pointers.
                IF addressLastCompleteRead /= addressLastCompleteWrite THEN
                    -- Verify if the write address had an overflow, which means that a part of the data is at the end of the SDRAM and the rest is at the beginning.
					-- In either case, the quantity of data to read is calculated with the difference of the read and write pointers.
                    IF addressLastCompleteWrite > addressLastCompleteRead THEN
                        control_read_length <= addressLastCompleteWrite - addressLastCompleteRead; -- In bytes
                    ELSE
                        control_read_length <= (TO_UNSIGNED(ADDRESS_TOTAL,ADDRESS_WIDTH) - addressLastCompleteRead) + addressLastCompleteWrite; -- In bytes
                    END IF;
                    -- After the reading, the read pointer will be equal to the current write pointer. The write pointer might have changed by that time.
                    addressLastCompleteRead <= addressLastCompleteWrite;
                    control_go <= '1';
                    idxDataRead <= TO_UNSIGNED(0,32);
                    state <= READING;
                ELSE
					-- No data available from the SDRAM.
                    readingDone <= '1';
                END IF;
			END IF;
			
		WHEN READING =>
			IF user_data_available = '1' THEN -- Data is available from the FIFO.
				dataRead <= user_buffer_data; -- Read data.
                
                -- Verify data integrity.
                IF dataRead = 1 THEN
                    -- The second data of a group is being read, we can calculate the increment.
                    incrementData <= TO_INTEGER(user_buffer_data - 1);
                ELSIF dataRead = 0 AND user_buffer_data = 1 THEN
                    -- Do nothing, this is the first reading ever.
                ELSIF user_buffer_data = 1 THEN
                    -- Do nothing, this is the first data of a group.
                ELSE
                    -- Make sure the increment is valid.
                    IF user_buffer_data /= dataRead + incrementData THEN
                        -- There is a problem with the data.
                        IF errorData < 7 THEN -- Stop counting at 7, because we use only 3 LEDs for the display.
                            errorData <= errorData + 1;
                        END IF;
                    END IF;
                END IF;            
                    
				idxDataRead <= idxDataRead + BYTES_PER_TRANSFER; -- In bytes.
                debugOut <= debugOut + BYTES_PER_TRANSFER;
                
                -- Verify if all data has been read.
				IF idxDataRead + BYTES_PER_TRANSFER >= control_read_length THEN
					state <= DONE;
				END IF;
			END IF;
		
		WHEN DONE =>
			readingDone <= '1';
            control_read_base <= addressLastCompleteRead + BYTES_PER_TRANSFER; -- In bytes. Next read will start there.
            state <= State_CheckReadyAndDataAvailable;
			
		WHEN OTHERS =>
			state <= State_CheckReadyAndDataAvailable;
				
	END CASE;	
END IF;

END PROCESS;

-- user_read_buffer must be in combinational logic.
user_read_buffer <= '1' WHEN (user_data_available = '1' AND state = READING) ELSE '0';

END TestRead_architecture;
