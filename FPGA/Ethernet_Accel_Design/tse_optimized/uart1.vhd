--Legal Notice: (C)2009 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity uart1_log_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal strobe : IN STD_LOGIC;
                 signal valid : IN STD_LOGIC
              );
end entity uart1_log_module;


architecture europa of uart1_log_module is
  
  file text_handle : TEXT ;
                           
  -- synthesis translate_off
  -- purpose: convert 8 bit signal data to 8 bit string
  FUNCTION bin_to_char(vec_to_convert : STD_LOGIC_VECTOR (7 downto 0))
    RETURN CHARACTER IS
    VARIABLE result: CHARACTER;
  BEGIN
    CASE vec_to_convert IS      -- cover basic ascii printable characters...
      when X"0a" => result := lf; -- \n, linefeed
      when X"0d" => result := nul; -- \r, Ctrl-M
      when X"09" => result := ht; -- \t, Ctrl-I, TAB
      when X"20" => result := ' ' ;
      when X"21" => result := '!' ;
      when X"22" => result := '"' ;
      when X"23" => result := '#' ;
      when X"24" => result := '$' ;
      when X"25" => result := '%' ;
      when X"26" => result := '&' ;
      when X"27" => result := ''' ; -- sync ' char for hilighting txt editors
      when X"28" => result := '(' ;
      when X"29" => result := ')' ;
      when X"2a" => result := '*' ;
      when X"2b" => result := '+' ;
      when X"2c" => result := ',' ;
      when X"2d" => result := '-' ;
      when X"2e" => result := '.' ;
      when X"2f" => result := '/' ;
      when X"30" => result := '0' ;
      when X"31" => result := '1' ;
      when X"32" => result := '2' ;
      when X"33" => result := '3' ;
      when X"34" => result := '4' ;
      when X"35" => result := '5' ;
      when X"36" => result := '6' ;
      when X"37" => result := '7' ;
      when X"38" => result := '8' ;
      when X"39" => result := '9' ;
      when X"3a" => result := ':' ;
      when X"3b" => result := ';' ;
      when X"3c" => result := '<' ;
      when X"3d" => result := '=' ;
      when X"3e" => result := '>' ;
      when X"3f" => result := '?' ;
      when X"40" => result := '@' ;
      when X"41" => result := 'A' ;
      when X"42" => result := 'B' ;
      when X"43" => result := 'C' ;
      when X"44" => result := 'D' ;
      when X"45" => result := 'E' ;
      when X"46" => result := 'F' ;
      when X"47" => result := 'G' ;
      when X"48" => result := 'H' ;
      when X"49" => result := 'I' ;
      when X"4a" => result := 'J' ;
      when X"4b" => result := 'K' ;
      when X"4c" => result := 'L' ;
      when X"4d" => result := 'M' ;
      when X"4e" => result := 'N' ;
      when X"4f" => result := 'O' ;
      when X"50" => result := 'P' ;
      when X"51" => result := 'Q' ;
      when X"52" => result := 'R' ;
      when X"53" => result := 'S' ;
      when X"54" => result := 'T' ;
      when X"55" => result := 'U' ;
      when X"56" => result := 'V' ;
      when X"57" => result := 'W' ;
      when X"58" => result := 'X' ;
      when X"59" => result := 'Y' ;
      when X"5a" => result := 'Z' ;
      when X"5b" => result := '[' ;
      when X"5c" => result := '\' ;
      when X"5d" => result := ']' ;
      when X"5e" => result := '^' ;
      when X"5f" => result := '_' ;
      when X"60" => result := '`' ;
      when X"61" => result := 'a' ;
      when X"62" => result := 'b' ;
      when X"63" => result := 'c' ;
      when X"64" => result := 'd' ;
      when X"65" => result := 'e' ;
      when X"66" => result := 'f' ;
      when X"67" => result := 'g' ;
      when X"68" => result := 'h' ;
      when X"69" => result := 'i' ;
      when X"6a" => result := 'j' ;
      when X"6b" => result := 'k' ;
      when X"6c" => result := 'l' ;
      when X"6d" => result := 'm' ;
      when X"6e" => result := 'n' ;
      when X"6f" => result := 'o' ;
      when X"70" => result := 'p' ;
      when X"71" => result := 'q' ;
      when X"72" => result := 'r' ;
      when X"73" => result := 's' ;
      when X"74" => result := 't' ;
      when X"75" => result := 'u' ;
      when X"76" => result := 'v' ;
      when X"77" => result := 'w' ;
      when X"78" => result := 'x' ;
      when X"79" => result := 'y' ;
      when X"7a" => result := 'z' ;
      when X"7b" => result := '{' ;
      when X"7c" => result := '|' ;
      when X"7d" => result := '}' ;
      when X"7e" => result := '~' ;
      when X"7f" => result := '_' ;
      WHEN others =>
        ASSERT False REPORT "data contains a non-printable character" SEVERITY Warning;
        result := nul;
    END case;
    RETURN result;
  end bin_to_char;
  -- synthesis translate_on
                             

begin

--synthesis translate_off


  -- purpose: simulate verilog initial function to open file in write mode
  -- type   : combinational
  -- inputs : initial
  -- outputs: <none>
  process is
    variable initial : boolean := true; -- not initialized yet
    variable status : file_open_status; -- status for fopen
  begin  -- process
    if initial = true then
      file_open (status, text_handle, "/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_log_module.txt", WRITE_MODE);
      initial := false;                 -- done!
    end if;
    wait;                               -- wait forever
  end process;

  process (clk)
    variable data_string : LINE;        -- for line buffer to file
    variable status : file_open_status; -- status for fopen
                        
  begin  -- process clk
    if clk'event and clk = '1' then -- sync ' chars for hilighting txt editors
      if (valid and strobe) = '1' then
                        
        write (data_string,bin_to_char(data));
        if data = X"0a" or data = X"0d" then -- \n or \r will flush line
          writeline (text_handle,data_string);
          file_close (text_handle);     -- flush buffer
          file_open (status, text_handle, "/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_log_module.txt", APPEND_MODE);
        end if;
                           
      end if;
    end if;
  end process;
                       --synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart1_tx is 
        port (
              -- inputs:
                 signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal do_force_break : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal status_wr_strobe : IN STD_LOGIC;
                 signal tx_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal tx_wr_strobe : IN STD_LOGIC;

              -- outputs:
                 signal tx_overrun : OUT STD_LOGIC;
                 signal tx_ready : OUT STD_LOGIC;
                 signal tx_shift_empty : OUT STD_LOGIC;
                 signal txd : OUT STD_LOGIC
              );
end entity uart1_tx;


architecture europa of uart1_tx is
                signal baud_clk_en :  STD_LOGIC;
                signal baud_rate_counter :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal baud_rate_counter_is_zero :  STD_LOGIC;
                signal do_load_shifter :  STD_LOGIC;
                signal do_shift :  STD_LOGIC;
                signal internal_tx_ready :  STD_LOGIC;
                signal pre_txd :  STD_LOGIC;
                signal shift_done :  STD_LOGIC;
                signal tx_load_val :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal tx_shift_reg_out :  STD_LOGIC;
                signal tx_shift_register_contents :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal tx_wr_strobe_onset :  STD_LOGIC;
                signal unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_in :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out :  STD_LOGIC_VECTOR (9 DOWNTO 0);

begin

  tx_wr_strobe_onset <= tx_wr_strobe AND begintransfer;
  tx_load_val <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('1')) & tx_data & A_ToStdLogicVector(std_logic'('0')));
  shift_done <= NOT (or_reduce(tx_shift_register_contents));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      do_load_shifter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        do_load_shifter <= (NOT internal_tx_ready) AND shift_done;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_tx_ready <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(tx_wr_strobe_onset) = '1' then 
          internal_tx_ready <= std_logic'('0');
        elsif std_logic'(do_load_shifter) = '1' then 
          internal_tx_ready <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      tx_overrun <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_wr_strobe) = '1' then 
          tx_overrun <= std_logic'('0');
        elsif std_logic'((NOT internal_tx_ready AND tx_wr_strobe_onset)) = '1' then 
          tx_overrun <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      tx_shift_empty <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        tx_shift_empty <= internal_tx_ready AND shift_done;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      baud_rate_counter <= std_logic_vector'("00000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((baud_rate_counter_is_zero OR do_load_shifter)) = '1' then 
          baud_rate_counter <= baud_divisor;
        else
          baud_rate_counter <= A_EXT (((std_logic_vector'("0000000000000000000000") & (baud_rate_counter)) - std_logic_vector'("000000000000000000000000000000001")), 11);
        end if;
      end if;
    end if;

  end process;

  baud_rate_counter_is_zero <= to_std_logic(((std_logic_vector'("000000000000000000000") & (baud_rate_counter)) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      baud_clk_en <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        baud_clk_en <= baud_rate_counter_is_zero;
      end if;
    end if;

  end process;

  do_shift <= (baud_clk_en AND (NOT shift_done)) AND (NOT do_load_shifter);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pre_txd <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(NOT shift_done) = '1' then 
        pre_txd <= tx_shift_reg_out;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      txd <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        txd <= pre_txd AND NOT do_force_break;
      end if;
    end if;

  end process;

  --_reg, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out <= unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_in;
      end if;
    end if;

  end process;

  unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_in <= A_WE_StdLogicVector((std_logic'((do_load_shifter)) = '1'), tx_load_val, A_WE_StdLogicVector((std_logic'((do_shift)) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out(9 DOWNTO 1)), unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out));
  tx_shift_register_contents <= unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out;
  tx_shift_reg_out <= unxshiftxtx_shift_register_contentsxtx_shift_reg_outxx5_out(0);
  --vhdl renameroo for output signals
  tx_ready <= internal_tx_ready;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity uart1_rx_stimulus_source_character_source_rom_module is 
        generic (
                 POLL_RATE : integer := 100
                 );
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal incr_addr : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal new_rom : OUT STD_LOGIC;
                 signal q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal safe : OUT STD_LOGIC
              );
end entity uart1_rx_stimulus_source_character_source_rom_module;


architecture europa of uart1_rx_stimulus_source_character_source_rom_module is
                signal address :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal d1_pre :  STD_LOGIC;
                signal d2_pre :  STD_LOGIC;
                signal d3_pre :  STD_LOGIC;
                signal d4_pre :  STD_LOGIC;
                signal d5_pre :  STD_LOGIC;
                signal d6_pre :  STD_LOGIC;
                signal d7_pre :  STD_LOGIC;
                signal d8_pre :  STD_LOGIC;
                signal d9_pre :  STD_LOGIC;
                TYPE mem_type is ARRAY( 1023 DOWNTO 0) of STD_LOGIC_VECTOR(7 DOWNTO 0);
              signal mem_array : mem_type;
                TYPE mem_type1 is ARRAY( 1 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
              signal mutex : mem_type1;
                signal pre :  STD_LOGIC;
  
          signal safe_wire : STD_LOGIC; -- deal with bogus VHDL type casting
          signal safe_delay : STD_LOGIC; 
          FILE mutex_handle : TEXT ;  -- open this for read and write manually.
          -- stream can be opened simply for read...
          FILE stream_handle : TEXT open READ_MODE is "/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_input_data_stream.dat";

-- synthesis translate_off
-- convert functions deadlifted from e_rom.pm

FUNCTION convert_string_to_number(string_to_convert : STRING;
                                  final_char_index : NATURAL := 0)
  RETURN NATURAL IS
  VARIABLE result: NATURAL := 0;
  VARIABLE current_index : NATURAL := 1;
  VARIABLE the_char : CHARACTER;
  
BEGIN
  IF final_char_index = 0 THEN
    result := 0;
  ELSE
    WHILE current_index <= final_char_index LOOP
      the_char := string_to_convert(current_index);
      IF    '0' <= the_char AND the_char <= '9' THEN
        result := result * 16 + character'pos(the_char) - character'pos('0');
      ELSIF 'A' <= the_char AND the_char <= 'F' THEN
        result := result * 16 + character'pos(the_char) - character'pos('A') + 10;
      ELSIF 'a' <= the_char AND the_char <= 'f' THEN
        result := result * 16 + character'pos(the_char) - character'pos('a') + 10;
      ELSE
        report "convert_string_to_number: Ack, a formatting error!";
      END IF;
      current_index := current_index + 1;
    END LOOP;
  END IF; 
  RETURN result;
END convert_string_to_number;


FUNCTION convert_string_to_std_logic(value : STRING; num_chars : INTEGER; mem_width_chars : INTEGER)
  RETURN STD_LOGIC_VECTOR is                       
  VARIABLE num_bits: integer := mem_width_chars * 4;
  VARIABLE result: std_logic_vector(num_bits-1 downto 0);
  VARIABLE curr_char : integer;
  VARIABLE min_width : integer := mem_width_chars;
  VARIABLE num_nibbles : integer := 0;
  
BEGIN
  result := (others => '0');
  num_nibbles := mem_width_chars;
  IF (mem_width_chars > num_chars) THEN
    num_nibbles := num_chars;
  END IF;
  
  FOR I IN 1 TO num_nibbles LOOP
    curr_char := num_nibbles - (I-1);
    
    CASE value(I) IS
      WHEN '0' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0000";
      WHEN '1' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0001";
      WHEN '2' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0010";
      WHEN '3' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0011";
      WHEN '4' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0100";
      WHEN '5' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0101";
      WHEN '6' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0110";
      WHEN '7' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0111";
      WHEN '8' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1000";
      WHEN '9' =>  result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1001";
      WHEN 'A' | 'a' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1010";
      WHEN 'B' | 'b' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1011";
      WHEN 'C' | 'c' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1100";
      WHEN 'D' | 'd' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1101";
      WHEN 'E' | 'e' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1110";
      WHEN 'F' | 'f' => result((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1111";
      WHEN ' ' => EXIT;
      WHEN HT  => exit;
      WHEN others =>
        ASSERT False
          REPORT "function From_Hex: string """ & value & """ contains non-hex character"
          severity Error;
        EXIT;
    END case;
  END loop;
  RETURN result;
END convert_string_to_std_logic;

-- purpose: open mutex/discard @address/convert value to std_logic_vector
function get_mutex_val (file_name : string)
  return STD_LOGIC_VECTOR is
  VARIABLE result : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
  FILE handle : TEXT ;
  VARIABLE status : file_open_status; -- status for fopen
  VARIABLE data_line : LINE;
  VARIABLE the_character_from_data_line : CHARACTER;
  VARIABLE converted_number : NATURAL := 0;
  VARIABLE found_string_array : STRING(1 TO 128);
  VARIABLE string_index : NATURAL := 0;
  VARIABLE line_length : NATURAL := 0; 
 
begin  -- get_mutex_val

  file_open (status, handle, file_name, READ_MODE);

  WHILE NOT(endfile(handle)) LOOP
    readline(handle, data_line);
    line_length := data_line'LENGTH; -- match ' for emacs font-lock
    
    WHILE line_length > 0 LOOP
      read(data_line, the_character_from_data_line);
      -- check for the @ character indicating a new address wad
      -- if found, ignore the line!  This is just protection
      IF '@' = the_character_from_data_line THEN
        exit;                           -- bail out of this line
      end if;
      -- process the hex address, character by character ...
      IF NOT(' ' = the_character_from_data_line) THEN
        string_index := string_index + 1;
        found_string_array(string_index) := the_character_from_data_line;
      END IF;
      line_length := line_length - 1; 
    end loop;                           -- read characters

  end loop;                             -- read lines

  file_close (handle);
  
  if string_index /= 0 then
    result := convert_string_to_std_logic(found_string_array, string_index, 8);
  end if;

  return result;
  
end get_mutex_val;

-- purpose: emulate verilogs readmemh function (mostly)
-- in verilog you say: $readmemh ("file", array);
-- in VHDL, we say: array <= readmemh("file"); -- which makes more sense.
function readmemh (file_name : string)
  return mem_type is
  VARIABLE result : mem_type;
  FILE handle : TEXT ;
  VARIABLE status : file_open_status; -- status for fopen
  VARIABLE data_line : LINE;
  VARIABLE b_address : BOOLEAN := FALSE; -- distinguish between addrs and data
  VARIABLE the_character_from_data_line : CHARACTER;
  VARIABLE converted_number : NATURAL := 0;
  VARIABLE found_string_array : STRING(1 TO 128);
  VARIABLE string_index : NATURAL := 0;
  VARIABLE line_length : NATURAL := 0; 
  VARIABLE load_address : NATURAL := 0;
  VARIABLE mem_index : NATURAL := 0;
begin  -- readmemh

  file_open (status, handle, file_name, READ_MODE);

  WHILE NOT(endfile(handle)) LOOP
    readline(handle, data_line);
    line_length := data_line'LENGTH; -- match ' for emacs font-lock
    b_address := false;

    WHILE line_length > 0 LOOP
      read(data_line, the_character_from_data_line);
      -- check for the @ character indicating a new address wad
      -- if found, ignore the line!  This is just protection
      IF '@' = the_character_from_data_line and not b_address then -- is addr
        b_address := true;
      end if;
      -- process the hex address, character by character ...
      IF NOT((' ' = the_character_from_data_line) or
	     ('@' = the_character_from_data_line) or
             (lf = the_character_from_data_line) or
	     (cr = the_character_from_data_line)) THEN
        string_index := string_index + 1;
        found_string_array(string_index) := the_character_from_data_line;
      END IF;
      line_length := line_length - 1;
    end loop;                           -- read characters

    if b_address then
      mem_index := convert_string_to_number(found_string_array, string_index);
      b_address := FALSE;
    else
      result(mem_index) := convert_string_to_std_logic(found_string_array, string_index, 2);
    end if;

    string_index := 0;

  end loop;                             -- read lines

  file_close (handle);
  
  return result;
  
end readmemh;
                           
-- synthesis translate_on
                      

begin

--synthesis translate_off
    q <= mem_array(CONV_INTEGER(UNSIGNED((address))));
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        d1_pre <= std_logic'('0');
        d2_pre <= std_logic'('0');
        d3_pre <= std_logic'('0');
        d4_pre <= std_logic'('0');
        d5_pre <= std_logic'('0');
        d6_pre <= std_logic'('0');
        d7_pre <= std_logic'('0');
        d8_pre <= std_logic'('0');
        d9_pre <= std_logic'('0');
        new_rom <= std_logic'('0');
      elsif clk'event and clk = '1' then
        d1_pre <= pre;
        d2_pre <= d1_pre;
        d3_pre <= d2_pre;
        d4_pre <= d3_pre;
        d5_pre <= d4_pre;
        d6_pre <= d5_pre;
        d7_pre <= d6_pre;
        d8_pre <= d7_pre;
        d9_pre <= d8_pre;
        new_rom <= d9_pre;
      end if;

    end process;


    safe <= safe_wire;
    safe_wire <= to_std_logic( address < mutex(1) );

    process (clk, reset_n)
    begin
      if reset_n = '0' then
        safe_delay <= '0';
      elsif clk'event and clk = '1' then -- balance ' for emacs quoting
        safe_delay <= safe_wire;
      end if;
    end process;

    process (clk, reset_n)
      variable poll_count : integer := POLL_RATE; -- STD_LOGIC_VECTOR (31:0);
      variable status : file_open_status; -- status for fopen
      variable mutex_string : LINE;  -- temp space for read/write data
      variable stream_string : LINE;  -- temp space for read data
      variable init_done : BOOLEAN; -- only used if non-interactive
      variable interactive : BOOLEAN := FALSE;
    begin
      if reset_n /= '1' then
        address <= "00000000000";
        mem_array(0) <= X"00";
        mutex(0) <= X"00000000";
        mutex(1) <= X"00000000";
        pre <= '0';
        init_done := FALSE;
      elsif clk'event and clk = '1' then -- balance ' for emacs quoting
        pre <= '0';
        if incr_addr = '1' and safe_wire = '1' then
          address <= address + "00000000001";
        end if;
        -- blast mutex via textio after falling edge of safe
        if mutex(0) /= X"00000000" and safe_wire = '0' and safe_delay = '1' then
	  if interactive then           -- bash mutex
            file_open (status, mutex_handle, "/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_input_data_mutex.dat", WRITE_MODE);
            write (mutex_string, string'("0")); -- balance ' for emacs quoting
            writeline (mutex_handle, mutex_string);
            file_close (mutex_handle);
            mutex(0) <= X"00000000";
	  else -- non-nteractive does not bash mutex: it stops poll counter
	    init_done := TRUE;
          end if;
        end if;
        if poll_count < POLL_RATE then  -- wait
          if not init_done then         -- stop counting if init_done is TRUE
            poll_count := poll_count + 1;
          end if;
        else                            -- do the real work
          poll_count := 0;
          -- get mutex via textio ...
          mutex(0) <= get_mutex_val ("/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_input_data_mutex.dat");
          if mutex(0) /= X"00000000" and safe_wire = '0' then
            -- read stream into array after previous stream is complete
            mutex (1) <= mutex (0); -- save mutex value for address compare
            -- get mem_array via textio ...
            mem_array <= readmemh("/net/sj-itnas01b/vol/vol1/abg/home/home/users/holiu/Ethernet_Project/90/May20_32k32k_timing/May7_startfromFeb22_Working90Tse/NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_sim/uart1_input_data_stream.dat");
            -- prep address and pre-pulse to alert world to new contents
            address <= "00000000000";
            pre <= '1';
          end if; -- poll_count
        end if;   -- clock
      end if;     -- reset
    end process;
                         --synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart1_rx_stimulus_source is 
        port (
              -- inputs:
                 signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rx_char_ready : IN STD_LOGIC;
                 signal rxd : IN STD_LOGIC;

              -- outputs:
                 signal source_rxd : OUT STD_LOGIC
              );
end entity uart1_rx_stimulus_source;


architecture europa of uart1_rx_stimulus_source is
--synthesis translate_off
component uart1_tx is 
           port (
                 -- inputs:
                    signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal do_force_break : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal status_wr_strobe : IN STD_LOGIC;
                    signal tx_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal tx_wr_strobe : IN STD_LOGIC;

                 -- outputs:
                    signal tx_overrun : OUT STD_LOGIC;
                    signal tx_ready : OUT STD_LOGIC;
                    signal tx_shift_empty : OUT STD_LOGIC;
                    signal txd : OUT STD_LOGIC
                 );
end component uart1_tx;

component uart1_rx_stimulus_source_character_source_rom_module is 
           generic (
                    POLL_RATE : integer := 100
                    );
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal incr_addr : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal new_rom : OUT STD_LOGIC;
                    signal q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal safe : OUT STD_LOGIC
                 );
end component uart1_rx_stimulus_source_character_source_rom_module;

--synthesis translate_on
                signal d1_stim_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal delayed_unxrx_char_readyxx0 :  STD_LOGIC;
                signal do_send_stim_data :  STD_LOGIC;
                signal internal_source_rxd :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal module_input3 :  STD_LOGIC;
                signal new_rom_pulse :  STD_LOGIC;
                signal pickup_pulse :  STD_LOGIC;
                signal safe :  STD_LOGIC;
                signal unused_empty :  STD_LOGIC;
                signal unused_overrun :  STD_LOGIC;
                signal unused_ready :  STD_LOGIC;

--synthesis translate_off
                signal stim_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);

--synthesis translate_on

begin

  --vhdl renameroo for output signals
  source_rxd <= internal_source_rxd;
--synthesis translate_off
    --stimulus_transmitter, which is an e_instance
    stimulus_transmitter : uart1_tx
      port map(
        tx_overrun => unused_overrun,
        tx_ready => unused_ready,
        tx_shift_empty => unused_empty,
        txd => internal_source_rxd,
        baud_divisor => baud_divisor,
        begintransfer => do_send_stim_data,
        clk => clk,
        clk_en => clk_en,
        do_force_break => module_input1,
        reset_n => reset_n,
        status_wr_strobe => module_input2,
        tx_data => d1_stim_data,
        tx_wr_strobe => module_input3
      );

    module_input1 <= std_logic'('0');
    module_input2 <= std_logic'('0');
    module_input3 <= std_logic'('1');

    process (clk, reset_n)
    begin
      if reset_n = '0' then
        d1_stim_data <= std_logic_vector'("00000000");
      elsif clk'event and clk = '1' then
        if std_logic'(do_send_stim_data) = '1' then 
          d1_stim_data <= stim_data;
        end if;
      end if;

    end process;

    --uart1_rx_stimulus_source_character_source_rom, which is an e_drom
    uart1_rx_stimulus_source_character_source_rom : uart1_rx_stimulus_source_character_source_rom_module
      port map(
        new_rom => new_rom_pulse,
        q => stim_data,
        safe => safe,
        clk => clk,
        incr_addr => do_send_stim_data,
        reset_n => reset_n
      );


    --delayed_unxrx_char_readyxx0, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        delayed_unxrx_char_readyxx0 <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if std_logic'(clk_en) = '1' then 
          delayed_unxrx_char_readyxx0 <= rx_char_ready;
        end if;
      end if;

    end process;

    pickup_pulse <= NOT (rx_char_ready) AND (delayed_unxrx_char_readyxx0);
    do_send_stim_data <= ((pickup_pulse OR new_rom_pulse)) AND safe;
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    internal_source_rxd <= rxd;
--synthesis read_comments_as_HDL off

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart1_rx is 
        port (
              -- inputs:
                 signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rx_rd_strobe : IN STD_LOGIC;
                 signal rxd : IN STD_LOGIC;
                 signal status_wr_strobe : IN STD_LOGIC;

              -- outputs:
                 signal break_detect : OUT STD_LOGIC;
                 signal framing_error : OUT STD_LOGIC;
                 signal parity_error : OUT STD_LOGIC;
                 signal rx_char_ready : OUT STD_LOGIC;
                 signal rx_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal rx_overrun : OUT STD_LOGIC
              );
end entity uart1_rx;


architecture europa of uart1_rx is
component uart1_rx_stimulus_source is 
           port (
                 -- inputs:
                    signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rx_char_ready : IN STD_LOGIC;
                    signal rxd : IN STD_LOGIC;

                 -- outputs:
                    signal source_rxd : OUT STD_LOGIC
                 );
end component uart1_rx_stimulus_source;

  component altera_std_synchronizer is
GENERIC (
      depth : NATURAL
      );
    PORT (
    signal dout : OUT STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal din : IN STD_LOGIC
      );
  end component altera_std_synchronizer;
                signal baud_clk_en :  STD_LOGIC;
                signal baud_load_value :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal baud_rate_counter :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal baud_rate_counter_is_zero :  STD_LOGIC;
                signal delayed_unxrx_in_processxx3 :  STD_LOGIC;
                signal delayed_unxsync_rxdxx1 :  STD_LOGIC;
                signal delayed_unxsync_rxdxx2 :  STD_LOGIC;
                signal do_start_rx :  STD_LOGIC;
                signal got_new_char :  STD_LOGIC;
                signal half_bit_cell_divisor :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_rx_char_ready :  STD_LOGIC;
                signal is_break :  STD_LOGIC;
                signal is_framing_error :  STD_LOGIC;
                signal raw_data_in :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal rx_in_process :  STD_LOGIC;
                signal rx_rd_strobe_onset :  STD_LOGIC;
                signal rxd_edge :  STD_LOGIC;
                signal rxd_falling :  STD_LOGIC;
                signal rxd_shift_reg :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal sample_enable :  STD_LOGIC;
                signal shift_reg_start_bit_n :  STD_LOGIC;
                signal source_rxd :  STD_LOGIC;
                signal stop_bit :  STD_LOGIC;
                signal sync_rxd :  STD_LOGIC;
                signal unused_start_bit :  STD_LOGIC;
                signal unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_in :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out :  STD_LOGIC_VECTOR (9 DOWNTO 0);

begin

  --the_uart1_rx_stimulus_source, which is an e_instance
  the_uart1_rx_stimulus_source : uart1_rx_stimulus_source
    port map(
      source_rxd => source_rxd,
      baud_divisor => baud_divisor,
      clk => clk,
      clk_en => clk_en,
      reset_n => reset_n,
      rx_char_ready => internal_rx_char_ready,
      rxd => rxd
    );


  the_altera_std_synchronizer : altera_std_synchronizer
    generic map(
      depth => 2
    )
    port map(
            clk => clk,
            din => source_rxd,
            dout => sync_rxd,
            reset_n => reset_n
    );

  --delayed_unxsync_rxdxx1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      delayed_unxsync_rxdxx1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        delayed_unxsync_rxdxx1 <= sync_rxd;
      end if;
    end if;

  end process;

  rxd_falling <= NOT (sync_rxd) AND (delayed_unxsync_rxdxx1);
  --delayed_unxsync_rxdxx2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      delayed_unxsync_rxdxx2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        delayed_unxsync_rxdxx2 <= sync_rxd;
      end if;
    end if;

  end process;

  rxd_edge <= (sync_rxd) XOR (delayed_unxsync_rxdxx2);
  rx_rd_strobe_onset <= rx_rd_strobe AND begintransfer;
  half_bit_cell_divisor <= baud_divisor(10 DOWNTO 1);
  baud_load_value <= A_WE_StdLogicVector((std_logic'((rxd_edge)) = '1'), (std_logic_vector'("0") & (half_bit_cell_divisor)), baud_divisor);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      baud_rate_counter <= std_logic_vector'("00000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((baud_rate_counter_is_zero OR rxd_edge)) = '1' then 
          baud_rate_counter <= baud_load_value;
        else
          baud_rate_counter <= A_EXT (((std_logic_vector'("0000000000000000000000") & (baud_rate_counter)) - std_logic_vector'("000000000000000000000000000000001")), 11);
        end if;
      end if;
    end if;

  end process;

  baud_rate_counter_is_zero <= to_std_logic(((std_logic_vector'("000000000000000000000") & (baud_rate_counter)) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      baud_clk_en <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(rxd_edge) = '1' then 
          baud_clk_en <= std_logic'('0');
        else
          baud_clk_en <= baud_rate_counter_is_zero;
        end if;
      end if;
    end if;

  end process;

  sample_enable <= baud_clk_en AND rx_in_process;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      do_start_rx <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((NOT rx_in_process AND rxd_falling)) = '1' then 
          do_start_rx <= std_logic'('1');
        else
          do_start_rx <= std_logic'('0');
        end if;
      end if;
    end if;

  end process;

  rx_in_process <= shift_reg_start_bit_n;
  (stop_bit, raw_data_in(7), raw_data_in(6), raw_data_in(5), raw_data_in(4), raw_data_in(3), raw_data_in(2), raw_data_in(1), raw_data_in(0), unused_start_bit) <= rxd_shift_reg;
  is_break <= NOT (or_reduce(rxd_shift_reg));
  is_framing_error <= NOT stop_bit AND NOT is_break;
  --delayed_unxrx_in_processxx3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      delayed_unxrx_in_processxx3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        delayed_unxrx_in_processxx3 <= rx_in_process;
      end if;
    end if;

  end process;

  got_new_char <= NOT (rx_in_process) AND (delayed_unxrx_in_processxx3);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rx_data <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(got_new_char) = '1' then 
        rx_data <= raw_data_in;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      framing_error <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_wr_strobe) = '1' then 
          framing_error <= std_logic'('0');
        elsif std_logic'((got_new_char AND is_framing_error)) = '1' then 
          framing_error <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      break_detect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_wr_strobe) = '1' then 
          break_detect <= std_logic'('0');
        elsif std_logic'((got_new_char AND is_break)) = '1' then 
          break_detect <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rx_overrun <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_wr_strobe) = '1' then 
          rx_overrun <= std_logic'('0');
        elsif std_logic'((got_new_char AND internal_rx_char_ready)) = '1' then 
          rx_overrun <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_rx_char_ready <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(rx_rd_strobe_onset) = '1' then 
          internal_rx_char_ready <= std_logic'('0');
        elsif std_logic'(got_new_char) = '1' then 
          internal_rx_char_ready <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  parity_error <= std_logic'('0');
  --_reg, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out <= unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_in;
      end if;
    end if;

  end process;

  unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_in <= A_WE_StdLogicVector((std_logic'((do_start_rx)) = '1'), A_REP(std_logic'('1'), 10), A_WE_StdLogicVector((std_logic'((sample_enable)) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(sync_rxd) & unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out(9 DOWNTO 1)), unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out));
  rxd_shift_reg <= unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out;
  shift_reg_start_bit_n <= unxshiftxrxd_shift_regxshift_reg_start_bit_nxx6_out(0);
  --vhdl renameroo for output signals
  rx_char_ready <= internal_rx_char_ready;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity uart1_regs is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal break_detect : IN STD_LOGIC;
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal framing_error : IN STD_LOGIC;
                 signal parity_error : IN STD_LOGIC;
                 signal read_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rx_char_ready : IN STD_LOGIC;
                 signal rx_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal rx_overrun : IN STD_LOGIC;
                 signal tx_overrun : IN STD_LOGIC;
                 signal tx_ready : IN STD_LOGIC;
                 signal tx_shift_empty : IN STD_LOGIC;
                 signal write_n : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal baud_divisor : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal dataavailable : OUT STD_LOGIC;
                 signal do_force_break : OUT STD_LOGIC;
                 signal irq : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal readyfordata : OUT STD_LOGIC;
                 signal rx_rd_strobe : OUT STD_LOGIC;
                 signal status_wr_strobe : OUT STD_LOGIC;
                 signal tx_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal tx_wr_strobe : OUT STD_LOGIC
              );
end entity uart1_regs;


architecture europa of uart1_regs is
                signal any_error :  STD_LOGIC;
                signal control_reg :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal control_wr_strobe :  STD_LOGIC;
                signal cts_status_bit :  STD_LOGIC;
                signal d1_rx_char_ready :  STD_LOGIC;
                signal d1_tx_ready :  STD_LOGIC;
                signal dcts_status_bit :  STD_LOGIC;
                signal delayed_unxtx_readyxx4 :  STD_LOGIC;
                signal divisor_constant :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal do_write_char :  STD_LOGIC;
                signal eop_status_bit :  STD_LOGIC;
                signal ie_any_error :  STD_LOGIC;
                signal ie_break_detect :  STD_LOGIC;
                signal ie_framing_error :  STD_LOGIC;
                signal ie_parity_error :  STD_LOGIC;
                signal ie_rx_char_ready :  STD_LOGIC;
                signal ie_rx_overrun :  STD_LOGIC;
                signal ie_tx_overrun :  STD_LOGIC;
                signal ie_tx_ready :  STD_LOGIC;
                signal ie_tx_shift_empty :  STD_LOGIC;
                signal internal_tx_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_tx_wr_strobe :  STD_LOGIC;
                signal qualified_irq :  STD_LOGIC;
                signal selected_read_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal status_reg :  STD_LOGIC_VECTOR (12 DOWNTO 0);

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      readdata <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        readdata <= selected_read_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      irq <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        irq <= qualified_irq;
      end if;
    end if;

  end process;

  rx_rd_strobe <= (chipselect AND NOT read_n) AND to_std_logic(((address = std_logic_vector'("000"))));
  internal_tx_wr_strobe <= (chipselect AND NOT write_n) AND to_std_logic(((address = std_logic_vector'("001"))));
  status_wr_strobe <= (chipselect AND NOT write_n) AND to_std_logic(((address = std_logic_vector'("010"))));
  control_wr_strobe <= (chipselect AND NOT write_n) AND to_std_logic(((address = std_logic_vector'("011"))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_tx_data <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(internal_tx_wr_strobe) = '1' then 
        internal_tx_data <= writedata(7 DOWNTO 0);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      control_reg <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(control_wr_strobe) = '1' then 
        control_reg <= writedata(9 DOWNTO 0);
      end if;
    end if;

  end process;

  baud_divisor <= divisor_constant;
  cts_status_bit <= std_logic'('0');
  dcts_status_bit <= std_logic'('0');
  (do_force_break, ie_any_error, ie_rx_char_ready, ie_tx_ready, ie_tx_shift_empty, ie_tx_overrun, ie_rx_overrun, ie_break_detect, ie_framing_error, ie_parity_error) <= control_reg;
  any_error <= (((tx_overrun OR rx_overrun) OR parity_error) OR framing_error) OR break_detect;
  status_reg <= Std_Logic_Vector'(A_ToStdLogicVector(eop_status_bit) & A_ToStdLogicVector(cts_status_bit) & A_ToStdLogicVector(dcts_status_bit) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(any_error) & A_ToStdLogicVector(rx_char_ready) & A_ToStdLogicVector(tx_ready) & A_ToStdLogicVector(tx_shift_empty) & A_ToStdLogicVector(tx_overrun) & A_ToStdLogicVector(rx_overrun) & A_ToStdLogicVector(break_detect) & A_ToStdLogicVector(framing_error) & A_ToStdLogicVector(parity_error));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_rx_char_ready <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_rx_char_ready <= rx_char_ready;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_tx_ready <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_tx_ready <= tx_ready;
      end if;
    end if;

  end process;

  dataavailable <= d1_rx_char_ready;
  readyfordata <= d1_tx_ready;
  eop_status_bit <= std_logic'('0');
  selected_read_data <= ((((A_REP(to_std_logic(((address = std_logic_vector'("000")))), 16) AND (std_logic_vector'("00000000") & (rx_data)))) OR ((A_REP(to_std_logic(((address = std_logic_vector'("001")))), 16) AND (std_logic_vector'("00000000") & (internal_tx_data))))) OR ((A_REP(to_std_logic(((address = std_logic_vector'("010")))), 16) AND (std_logic_vector'("000") & (status_reg))))) OR ((A_REP(to_std_logic(((address = std_logic_vector'("011")))), 16) AND (std_logic_vector'("000000") & (control_reg))));
  qualified_irq <= (((((((((ie_any_error AND any_error)) OR ((ie_tx_shift_empty AND tx_shift_empty))) OR ((ie_tx_overrun AND tx_overrun))) OR ((ie_rx_overrun AND rx_overrun))) OR ((ie_break_detect AND break_detect))) OR ((ie_framing_error AND framing_error))) OR ((ie_parity_error AND parity_error))) OR ((ie_rx_char_ready AND rx_char_ready))) OR ((ie_tx_ready AND tx_ready));
  --vhdl renameroo for output signals
  tx_data <= internal_tx_data;
  --vhdl renameroo for output signals
  tx_wr_strobe <= internal_tx_wr_strobe;
--synthesis translate_off
    --delayed_unxtx_readyxx4, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        delayed_unxtx_readyxx4 <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if std_logic'(clk_en) = '1' then 
          delayed_unxtx_readyxx4 <= tx_ready;
        end if;
      end if;

    end process;

    do_write_char <= (tx_ready) AND NOT (delayed_unxtx_readyxx4);
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(do_write_char) = '1' then 
          write(write_line, character'val(CONV_INTEGER(internal_tx_data)));
          write(write_line, string'(""));
          write(output, write_line.all);
          deallocate (write_line);
        end if;
      end if;

    end process;

    divisor_constant <= std_logic_vector'("00000000100");
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    divisor_constant <= std_logic_vector'("10100010110");
--synthesis read_comments_as_HDL off

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart1 is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal read_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rxd : IN STD_LOGIC;
                 signal write_n : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal dataavailable : OUT STD_LOGIC;
                 signal irq : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal readyfordata : OUT STD_LOGIC;
                 signal txd : OUT STD_LOGIC
              );
attribute altera_attribute : string;
attribute altera_attribute of uart1 : entity is "-name SYNCHRONIZER_IDENTIFICATION OFF";
end entity uart1;


architecture europa of uart1 is
component uart1_tx is 
           port (
                 -- inputs:
                    signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal do_force_break : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal status_wr_strobe : IN STD_LOGIC;
                    signal tx_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal tx_wr_strobe : IN STD_LOGIC;

                 -- outputs:
                    signal tx_overrun : OUT STD_LOGIC;
                    signal tx_ready : OUT STD_LOGIC;
                    signal tx_shift_empty : OUT STD_LOGIC;
                    signal txd : OUT STD_LOGIC
                 );
end component uart1_tx;

component uart1_rx is 
           port (
                 -- inputs:
                    signal baud_divisor : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rx_rd_strobe : IN STD_LOGIC;
                    signal rxd : IN STD_LOGIC;
                    signal status_wr_strobe : IN STD_LOGIC;

                 -- outputs:
                    signal break_detect : OUT STD_LOGIC;
                    signal framing_error : OUT STD_LOGIC;
                    signal parity_error : OUT STD_LOGIC;
                    signal rx_char_ready : OUT STD_LOGIC;
                    signal rx_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal rx_overrun : OUT STD_LOGIC
                 );
end component uart1_rx;

component uart1_regs is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal break_detect : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal framing_error : IN STD_LOGIC;
                    signal parity_error : IN STD_LOGIC;
                    signal read_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rx_char_ready : IN STD_LOGIC;
                    signal rx_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal rx_overrun : IN STD_LOGIC;
                    signal tx_overrun : IN STD_LOGIC;
                    signal tx_ready : IN STD_LOGIC;
                    signal tx_shift_empty : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal baud_divisor : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal dataavailable : OUT STD_LOGIC;
                    signal do_force_break : OUT STD_LOGIC;
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal readyfordata : OUT STD_LOGIC;
                    signal rx_rd_strobe : OUT STD_LOGIC;
                    signal status_wr_strobe : OUT STD_LOGIC;
                    signal tx_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal tx_wr_strobe : OUT STD_LOGIC
                 );
end component uart1_regs;

--synthesis translate_off
component uart1_log_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal strobe : IN STD_LOGIC;
                    signal valid : IN STD_LOGIC
                 );
end component uart1_log_module;

--synthesis translate_on
                signal baud_divisor :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal break_detect :  STD_LOGIC;
                signal clk_en :  STD_LOGIC;
                signal do_force_break :  STD_LOGIC;
                signal framing_error :  STD_LOGIC;
                signal internal_dataavailable :  STD_LOGIC;
                signal internal_irq :  STD_LOGIC;
                signal internal_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_readyfordata :  STD_LOGIC;
                signal internal_txd :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal parity_error :  STD_LOGIC;
                signal rx_char_ready :  STD_LOGIC;
                signal rx_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal rx_overrun :  STD_LOGIC;
                signal rx_rd_strobe :  STD_LOGIC;
                signal status_wr_strobe :  STD_LOGIC;
                signal tx_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal tx_overrun :  STD_LOGIC;
                signal tx_ready :  STD_LOGIC;
                signal tx_shift_empty :  STD_LOGIC;
                signal tx_wr_strobe :  STD_LOGIC;

begin

  clk_en <= std_logic'('1');
  --the_uart1_tx, which is an e_instance
  the_uart1_tx : uart1_tx
    port map(
      tx_overrun => tx_overrun,
      tx_ready => tx_ready,
      tx_shift_empty => tx_shift_empty,
      txd => internal_txd,
      baud_divisor => baud_divisor,
      begintransfer => begintransfer,
      clk => clk,
      clk_en => clk_en,
      do_force_break => do_force_break,
      reset_n => reset_n,
      status_wr_strobe => status_wr_strobe,
      tx_data => tx_data,
      tx_wr_strobe => tx_wr_strobe
    );


  --the_uart1_rx, which is an e_instance
  the_uart1_rx : uart1_rx
    port map(
      break_detect => break_detect,
      framing_error => framing_error,
      parity_error => parity_error,
      rx_char_ready => rx_char_ready,
      rx_data => rx_data,
      rx_overrun => rx_overrun,
      baud_divisor => baud_divisor,
      begintransfer => begintransfer,
      clk => clk,
      clk_en => clk_en,
      reset_n => reset_n,
      rx_rd_strobe => rx_rd_strobe,
      rxd => rxd,
      status_wr_strobe => status_wr_strobe
    );


  --the_uart1_regs, which is an e_instance
  the_uart1_regs : uart1_regs
    port map(
      baud_divisor => baud_divisor,
      dataavailable => internal_dataavailable,
      do_force_break => do_force_break,
      irq => internal_irq,
      readdata => internal_readdata,
      readyfordata => internal_readyfordata,
      rx_rd_strobe => rx_rd_strobe,
      status_wr_strobe => status_wr_strobe,
      tx_data => tx_data,
      tx_wr_strobe => tx_wr_strobe,
      address => address,
      break_detect => break_detect,
      chipselect => chipselect,
      clk => clk,
      clk_en => clk_en,
      framing_error => framing_error,
      parity_error => parity_error,
      read_n => read_n,
      reset_n => reset_n,
      rx_char_ready => rx_char_ready,
      rx_data => rx_data,
      rx_overrun => rx_overrun,
      tx_overrun => tx_overrun,
      tx_ready => tx_ready,
      tx_shift_empty => tx_shift_empty,
      write_n => write_n,
      writedata => writedata
    );


  --s1, which is an e_avalon_slave
  --vhdl renameroo for output signals
  dataavailable <= internal_dataavailable;
  --vhdl renameroo for output signals
  irq <= internal_irq;
  --vhdl renameroo for output signals
  readdata <= internal_readdata;
  --vhdl renameroo for output signals
  readyfordata <= internal_readyfordata;
  --vhdl renameroo for output signals
  txd <= internal_txd;
--synthesis translate_off
    --uart1_log, which is an e_log
    uart1_log : uart1_log_module
      port map(
        clk => clk,
        data => tx_data,
        strobe => tx_wr_strobe,
        valid => module_input
      );

    module_input <= NOT tx_ready;

--synthesis translate_on

end europa;

