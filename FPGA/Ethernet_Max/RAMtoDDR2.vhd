--
-- Brief: Controls the Avalon MM-Master Write Module, which is very similar to a normal FIFO buffer.
--

-- Libraries --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE my_incl.v;

--  Entity Declaration
ENTITY RAMtoDDR2 IS
	GENERIC(
		ADDRESS_WIDTH : NATURAL := 30;
		ADDRESS_TOTAL : NATURAL := 1073741824;
		BYTES_PER_TRANSFER : NATURAL := 32; --256BITS/8
		NBYTES_PER_ALINE : NATURAL := 2368 --1170*2=2340 (Must be a multiple of 32 bytes)
	);
	
	PORT
	(
		RSTn : IN STD_LOGIC;
		CLK50MHZ : IN STD_LOGIC;
		
		-- Control signals to the Avalon MM-Master.
		control_go : BUFFER STD_LOGIC; -- Empties FIFO data in the DDR2.
		control_write_base : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes.									
		control_write_length : BUFFER UNSIGNED(ADDRESS_WIDTH-1 DOWNTO 0); -- In bytes. Don't transfer more data than length, otherwise there will be an overflow.
		control_done : IN STD_LOGIC; -- Only used to make sure the transfer is done before starting a new one.
		
		-- FIFO signals to the Avalon MM-Master.
		user_buffer_data : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
		user_buffer_full : IN STD_LOGIC;
		user_write_buffer : BUFFER STD_LOGIC;
		
		-- Signals from RAM
		RAM_dataOut : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
		--RAM_readAddress : BUFFER UNSIGNED(10 DOWNTO 0);
		RAM_readAddress : BUFFER UNSIGNED(6 DOWNTO 0);
		acq_done : IN STD_LOGIC;
		
		-- LED for debugging
		stateLED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
	
END RAMtoDDR2;

--  Architecture Body 
ARCHITECTURE RAMtoDDR2_architecture OF RAMtoDDR2 IS

	-- State machine declaration.
	--TYPE stateMachine IS (State_CheckAcqDone, State_CheckAcqDone2, State_CheckControllerReady, State_CheckFIFOFull, State_Writing, State_Done);
	--SIGNAL state : stateMachine;
	CONSTANT S_Check1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	CONSTANT S_Check2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT S_Ready : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
	CONSTANT S_Full : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT S_Writing : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
	CONSTANT S_Delay : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
	SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0) := S_Check1;
	
	-- Internal value of user_write_buffer.
	SIGNAL user_write_buffer_internal : STD_LOGIC;
	
    -- Index corresponding to the byte that is being written.
    SIGNAL idxByte : INTEGER RANGE 0 TO 400000;	
    
    SIGNAL counterDelay : INTEGER RANGE 0 TO 100;	

BEGIN

PROCESS(RSTn, CLK50MHZ)

BEGIN
IF (RSTn = '0') THEN
	control_go <= '0';
	control_write_base <= TO_UNSIGNED(0,ADDRESS_WIDTH);
	control_write_length <= TO_UNSIGNED(0,ADDRESS_WIDTH);
	state <= S_Check1;
	user_write_buffer_internal <= '0';
    idxByte <= 0;
    RAM_readAddress <= (OTHERS => '0');
    stateLED <= "0000001"; -- reset indicator
    counterDelay <= 0;
    
ELSIF (CLK50MHZ'EVENT AND CLK50MHZ = '1') THEN
	control_go <= '0';
	user_write_buffer_internal <= '0';
						
	CASE state IS
        
        WHEN S_Check1 => -- Make sure the DDR2 is not full.
        stateLED <= "0000010"; -- state indicator
        
			IF acq_done = '0' AND control_done = '1' AND user_buffer_full = '0' THEN --Modif temporaire**********************************************
				state <= S_Check2;
			END IF;

        WHEN S_Check2 => -- Make sure the DDR2 is not full.
        stateLED <= "0000100"; -- state indicator
			IF acq_done = '1' THEN
				RAM_readAddress <= (OTHERS => '0');
				idxByte <= 0;
				state <= S_Ready;
			END IF;
            			
		WHEN S_Ready => -- Make sure the controller is ready to receive data.
		stateLED <= "0001000"; -- state indicator
		
			IF control_done = '1' AND user_buffer_full = '0' THEN
				state <= S_Full;
				control_write_base <= control_write_base + control_write_length; -- In bytes.
                control_write_length <= TO_UNSIGNED(NBYTES_PER_ALINE,ADDRESS_WIDTH); -- In bytes.         
			END IF;
			
		WHEN S_Full => 
		stateLED <= "0010000"; -- state indicator
		
			IF user_buffer_full = '0' THEN -- Not full.
				state <= S_Writing;		
			END IF;
		
		WHEN S_Writing =>
		stateLED <= "0100000"; -- state indicator
		
            -- One go pulse just after we begin the transfer. At least one data must be written before asserting this signal.
			IF idxByte = BYTES_PER_TRANSFER THEN
				control_go <= '1';
			END IF;	
            
            -- Check if buffer is full. If it is, the last data was not written, so we need to decrement the counter.
            IF user_buffer_full = '0' THEN
                -- The last data was written correctly. Now we check if we are done writing. If not, we write and increment the counter.
                IF idxByte < NBYTES_PER_ALINE THEN
                    RAM_readAddress <= RAM_readAddress + 1;
                            
                    user_buffer_data <= RAM_dataOut;
                    idxByte <= idxByte + BYTES_PER_TRANSFER; -- In bytes.
                    user_write_buffer_internal <= '1';
                    
                    counterDelay <= 0;
                    state <= S_Delay;
                ELSE
                    state <= S_Check1;
                END IF;
            ELSE 
                state <= S_Full;
                idxByte <= idxByte - BYTES_PER_TRANSFER; -- In bytes.
                RAM_readAddress <= RAM_readAddress - 1;					
            END IF;		
		
		WHEN S_Delay =>
			counterDelay <= counterDelay + 1;
			IF counterDelay = 0 THEN
				IF user_buffer_full = '1' THEN
				    idxByte <= idxByte - BYTES_PER_TRANSFER; -- In bytes.
					RAM_readAddress <= RAM_readAddress - 1;	
				END IF;
			ELSIF counterDelay >= 1 THEN
				counterDelay <= 0;
				state <= S_Full;
			END IF;
			
		WHEN OTHERS =>
		
			state <= S_Check1;
				
	END CASE;	
END IF;

END PROCESS;

-- user_write_buffer must be in combinational logic.
user_write_buffer <= '1' WHEN (user_buffer_full = '0' AND user_write_buffer_internal = '1') ELSE '0';

END RAMtoDDR2_architecture;
