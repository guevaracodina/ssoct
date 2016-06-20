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

entity dma_read_data_mux is 
        port (
              -- inputs:
                 signal byte_access : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal dma_ctl_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal dma_ctl_chipselect : IN STD_LOGIC;
                 signal dma_ctl_write_n : IN STD_LOGIC;
                 signal dma_ctl_writedata : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal hw : IN STD_LOGIC;
                 signal read_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal read_readdatavalid : IN STD_LOGIC;
                 signal readaddress : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal readaddress_inc : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal word : IN STD_LOGIC;

              -- outputs:
                 signal fifo_wr_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity dma_read_data_mux;


architecture europa of dma_read_data_mux is
                signal control_write :  STD_LOGIC;
                signal length_write :  STD_LOGIC;
                signal read_data_mux_input :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal readdata_mux_select :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  control_write <= (dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000110"))) OR (((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000111"))))));
  length_write <= (dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011"))));
  read_data_mux_input <= A_EXT (A_WE_StdLogicVector((std_logic'((((control_write AND dma_ctl_writedata(3)) OR length_write))) = '1'), (std_logic_vector'("0000") & (readaddress(1 DOWNTO 0))), A_WE_StdLogicVector((std_logic'((read_readdatavalid)) = '1'), (((std_logic_vector'("0000") & (readdata_mux_select)) + (std_logic_vector'("0") & (readaddress_inc)))), (std_logic_vector'("0000") & (readdata_mux_select)))), 2);
  -- Reset value: the transaction size bits of the read address reset value.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      readdata_mux_select <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        readdata_mux_select <= read_data_mux_input(1 DOWNTO 0);
      end if;
    end if;

  end process;

  fifo_wr_data(31 DOWNTO 16) <= read_readdata(31 DOWNTO 16);
  fifo_wr_data(15 DOWNTO 8) <= (((A_REP(((hw AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(readdata_mux_select(1)))) = std_logic_vector'("00000000000000000000000000000000")))))) , 8) AND read_readdata(15 DOWNTO 8))) OR ((A_REP(((hw AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(readdata_mux_select(1)))) = std_logic_vector'("00000000000000000000000000000001")))))) , 8) AND read_readdata(31 DOWNTO 24)))) OR ((A_REP(word, 8) AND read_readdata(15 DOWNTO 8)));
  fifo_wr_data(7 DOWNTO 0) <= (((((((A_REP(((byte_access AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (readdata_mux_select(1 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000000")))))) , 8) AND read_readdata(7 DOWNTO 0))) OR ((A_REP(((byte_access AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (readdata_mux_select(1 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000001")))))) , 8) AND read_readdata(15 DOWNTO 8)))) OR ((A_REP(((byte_access AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (readdata_mux_select(1 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000010")))))) , 8) AND read_readdata(23 DOWNTO 16)))) OR ((A_REP(((byte_access AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (readdata_mux_select(1 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000011")))))) , 8) AND read_readdata(31 DOWNTO 24)))) OR ((A_REP(((hw AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(readdata_mux_select(1)))) = std_logic_vector'("00000000000000000000000000000000")))))) , 8) AND read_readdata(7 DOWNTO 0)))) OR ((A_REP(((hw AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(readdata_mux_select(1)))) = std_logic_vector'("00000000000000000000000000000001")))))) , 8) AND read_readdata(23 DOWNTO 16)))) OR ((A_REP(word, 8) AND read_readdata(7 DOWNTO 0)));

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

entity dma_byteenables is 
        port (
              -- inputs:
                 signal byte_access : IN STD_LOGIC;
                 signal hw : IN STD_LOGIC;
                 signal word : IN STD_LOGIC;
                 signal write_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);

              -- outputs:
                 signal write_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
              );
end entity dma_byteenables;


architecture europa of dma_byteenables is
                signal wa_1_is_0 :  STD_LOGIC;
                signal wa_1_is_1 :  STD_LOGIC;
                signal wa_1_to_0_is_0 :  STD_LOGIC;
                signal wa_1_to_0_is_1 :  STD_LOGIC;
                signal wa_1_to_0_is_2 :  STD_LOGIC;
                signal wa_1_to_0_is_3 :  STD_LOGIC;

begin

  wa_1_to_0_is_3 <= to_std_logic((write_address(1 DOWNTO 0) = std_logic_vector'("11")));
  wa_1_to_0_is_2 <= to_std_logic((write_address(1 DOWNTO 0) = std_logic_vector'("10")));
  wa_1_to_0_is_1 <= to_std_logic((write_address(1 DOWNTO 0) = std_logic_vector'("01")));
  wa_1_to_0_is_0 <= to_std_logic((write_address(1 DOWNTO 0) = std_logic_vector'("00")));
  wa_1_is_1 <= to_std_logic((std_logic'(write_address(1)) = std_logic'(std_logic'('1'))));
  wa_1_is_0 <= to_std_logic((std_logic'(write_address(1)) = std_logic'(std_logic'('0'))));
  write_byteenable <= (((A_REP(byte_access, 4) AND Std_Logic_Vector'(A_ToStdLogicVector(wa_1_to_0_is_3) & A_ToStdLogicVector(wa_1_to_0_is_2) & A_ToStdLogicVector(wa_1_to_0_is_1) & A_ToStdLogicVector(wa_1_to_0_is_0)))) OR ((A_REP(hw, 4) AND Std_Logic_Vector'(A_ToStdLogicVector(wa_1_is_1) & A_ToStdLogicVector(wa_1_is_1) & A_ToStdLogicVector(wa_1_is_0) & A_ToStdLogicVector(wa_1_is_0))))) OR ((A_REP(word, 4) AND std_logic_vector'("1111")));

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dma_fifo_module_fifo_ram_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal rdclken : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal wrclock : IN STD_LOGIC;
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity dma_fifo_module_fifo_ram_module;


architecture europa of dma_fifo_module_fifo_ram_module is
              signal internal_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
              TYPE mem_array is ARRAY( 15 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
              signal read_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin
   process (wrclock, clk) -- MG
        VARIABLE rd_address_internal : STD_LOGIC_VECTOR (3 DOWNTO 0) := (others => '0');

    VARIABLE wr_address_internal : STD_LOGIC_VECTOR (3 DOWNTO 0) := (others => '0');
    variable Marc_Gaucherons_Memory_Variable : mem_array; -- MG
    
    begin
      -- Write data
      if wrclock'event and wrclock = '1' then
        wr_address_internal := wraddress;
        if wren = '1' then 
          Marc_Gaucherons_Memory_Variable(CONV_INTEGER(UNSIGNED(wr_address_internal))) := data;
        end if;
      end if;

      -- read data
      q <= Marc_Gaucherons_Memory_Variable(CONV_INTEGER(UNSIGNED(rd_address_internal)));
      
			 IF clk'event AND clk = '1' AND rdclken = '1' THEN
                            rd_address_internal := rdaddress;

                         END IF;
                        


    end process;
end europa;

--synthesis translate_on


--synthesis read_comments_as_HDL on
--library altera;
--use altera.altera_europa_support_lib.all;
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
--
--entity dma_fifo_module_fifo_ram_module is 
--        port (
--              
--                 signal clk : IN STD_LOGIC;
--                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--                 signal rdaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
--                 signal rdclken : IN STD_LOGIC;
--                 signal reset_n : IN STD_LOGIC;
--                 signal wraddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
--                 signal wrclock : IN STD_LOGIC;
--                 signal wren : IN STD_LOGIC;
--
--              
--                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
--              );
--end entity dma_fifo_module_fifo_ram_module;
--
--
--architecture europa of dma_fifo_module_fifo_ram_module is
--  component lpm_ram_dp is
--GENERIC (
--      lpm_file : STRING;
--        lpm_hint : STRING;
--        lpm_indata : STRING;
--        lpm_outdata : STRING;
--        lpm_rdaddress_control : STRING;
--        lpm_width : NATURAL;
--        lpm_widthad : NATURAL;
--        lpm_wraddress_control : STRING;
--        suppress_memory_conversion_warnings : STRING
--      );
--    PORT (
--    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
--        signal rdaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
--        signal wren : IN STD_LOGIC;
--        signal rdclock : IN STD_LOGIC;
--        signal wrclock : IN STD_LOGIC;
--        signal wraddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
--        signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--        signal rdclken : IN STD_LOGIC
--      );
--  end component lpm_ram_dp;
--                signal internal_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
--                TYPE mem_array is ARRAY( 15 DOWNTO 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
--                signal read_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
--
--begin
--
--  process (rdaddress)
--  begin
--      read_address <= rdaddress;
--
--  end process;
--
--  lpm_ram_dp_component : lpm_ram_dp
--    generic map(
--      lpm_file => "UNUSED",
--      lpm_hint => "USE_EAB=OFF",
--      lpm_indata => "REGISTERED",
--      lpm_outdata => "UNREGISTERED",
--      lpm_rdaddress_control => "REGISTERED",
--      lpm_width => 32,
--      lpm_widthad => 4,
--      lpm_wraddress_control => "REGISTERED",
--      suppress_memory_conversion_warnings => "ON"
--    )
--    port map(
--            data => data,
--            q => internal_q,
--            rdaddress => read_address,
--            rdclken => rdclken,
--            rdclock => clk,
--            wraddress => wraddress,
--            wrclock => wrclock,
--            wren => wren
--    );
--
--  
--  q <= internal_q;
--end europa;
--
--synthesis read_comments_as_HDL off


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dma_fifo_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal fifo_read : IN STD_LOGIC;
                 signal fifo_wr_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal fifo_write : IN STD_LOGIC;
                 signal flush_fifo : IN STD_LOGIC;
                 signal inc_pending_data : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal fifo_datavalid : OUT STD_LOGIC;
                 signal fifo_empty : OUT STD_LOGIC;
                 signal fifo_rd_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal p1_fifo_full : OUT STD_LOGIC
              );
end entity dma_fifo_module;


architecture europa of dma_fifo_module is
component dma_fifo_module_fifo_ram_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal rdclken : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal wrclock : IN STD_LOGIC;
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component dma_fifo_module_fifo_ram_module;

                signal estimated_rdaddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal estimated_wraddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal fifo_dec :  STD_LOGIC;
                signal fifo_full :  STD_LOGIC;
                signal fifo_inc :  STD_LOGIC;
                signal fifo_ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_fifo_empty :  STD_LOGIC;
                signal internal_p1_fifo_full :  STD_LOGIC;
                signal last_write_collision :  STD_LOGIC;
                signal last_write_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal p1_estimated_wraddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p1_fifo_empty :  STD_LOGIC;
                signal p1_wraddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal rdaddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal rdaddress_reg :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal wraddress :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal write_collision :  STD_LOGIC;

begin

  p1_wraddress <= A_EXT (A_WE_StdLogicVector((std_logic'((fifo_write)) = '1'), ((std_logic_vector'("00000000000000000000000000000") & (wraddress)) - std_logic_vector'("000000000000000000000000000000001")), (std_logic_vector'("00000000000000000000000000000") & (wraddress))), 4);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      wraddress <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(flush_fifo) = '1' then 
          wraddress <= std_logic_vector'("0000");
        else
          wraddress <= p1_wraddress;
        end if;
      end if;
    end if;

  end process;

  rdaddress <= A_EXT (A_WE_StdLogicVector((std_logic'(flush_fifo) = '1'), std_logic_vector'("000000000000000000000000000000000"), A_WE_StdLogicVector((std_logic'(fifo_read) = '1'), (((std_logic_vector'("00000000000000000000000000000") & (rdaddress_reg)) - std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("00000000000000000000000000000") & (rdaddress_reg)))), 4);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rdaddress_reg <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      rdaddress_reg <= rdaddress;
    end if;

  end process;

  fifo_datavalid <= NOT internal_fifo_empty;
  fifo_inc <= fifo_write AND NOT fifo_read;
  fifo_dec <= fifo_read AND NOT fifo_write;
  estimated_rdaddress <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (rdaddress_reg)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  p1_estimated_wraddress <= A_EXT (A_WE_StdLogicVector((std_logic'((inc_pending_data)) = '1'), ((std_logic_vector'("00000000000000000000000000000") & (estimated_wraddress)) - std_logic_vector'("000000000000000000000000000000001")), (std_logic_vector'("00000000000000000000000000000") & (estimated_wraddress))), 4);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      estimated_wraddress <= A_REP(std_logic'('1'), 4);
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(flush_fifo) = '1' then 
          estimated_wraddress <= A_REP(std_logic'('1'), 4);
        else
          estimated_wraddress <= p1_estimated_wraddress;
        end if;
      end if;
    end if;

  end process;

  p1_fifo_empty <= flush_fifo OR ((((NOT fifo_inc AND internal_fifo_empty)) OR ((fifo_dec AND to_std_logic(((wraddress = estimated_rdaddress)))))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_fifo_empty <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        internal_fifo_empty <= p1_fifo_empty;
      end if;
    end if;

  end process;

  internal_p1_fifo_full <= NOT flush_fifo AND ((((NOT fifo_dec AND fifo_full)) OR ((inc_pending_data AND to_std_logic(((estimated_wraddress = rdaddress)))))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_full <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        fifo_full <= internal_p1_fifo_full;
      end if;
    end if;

  end process;

  write_collision <= fifo_write AND to_std_logic(((wraddress = rdaddress)));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_write_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(write_collision) = '1' then 
        last_write_data <= fifo_wr_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_write_collision <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(write_collision) = '1' then 
        last_write_collision <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      elsif std_logic'(fifo_read) = '1' then 
        last_write_collision <= std_logic'('0');
      end if;
    end if;

  end process;

  fifo_rd_data <= A_WE_StdLogicVector((std_logic'(last_write_collision) = '1'), last_write_data, fifo_ram_q);
  --dma_fifo_module_fifo_ram, which is an e_ram
  dma_fifo_module_fifo_ram : dma_fifo_module_fifo_ram_module
    port map(
      q => fifo_ram_q,
      clk => clk,
      data => fifo_wr_data,
      rdaddress => rdaddress,
      rdclken => module_input,
      reset_n => reset_n,
      wraddress => wraddress,
      wrclock => clk,
      wren => fifo_write
    );

  module_input <= std_logic'('1');

  --vhdl renameroo for output signals
  fifo_empty <= internal_fifo_empty;
  --vhdl renameroo for output signals
  p1_fifo_full <= internal_p1_fifo_full;

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

entity dma_mem_read is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal clk_en : IN STD_LOGIC;
                 signal go : IN STD_LOGIC;
                 signal p1_done_read : IN STD_LOGIC;
                 signal p1_fifo_full : IN STD_LOGIC;
                 signal read_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal inc_read : OUT STD_LOGIC;
                 signal mem_read_n : OUT STD_LOGIC
              );
end entity dma_mem_read;


architecture europa of dma_mem_read is
                signal dma_mem_read_access :  STD_LOGIC;
                signal dma_mem_read_idle :  STD_LOGIC;
                signal p1_read_select :  STD_LOGIC;
                signal read_select :  STD_LOGIC;

begin

  mem_read_n <= NOT read_select;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      read_select <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        read_select <= p1_read_select;
      end if;
    end if;

  end process;

  inc_read <= read_select AND NOT read_waitrequest;
  -- Transitions into state 'idle'.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dma_mem_read_idle <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        dma_mem_read_idle <= to_std_logic((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_idle))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(go))) = std_logic_vector'("00000000000000000000000000000000"))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_idle))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000001")))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_idle))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000001")))))) OR ((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_access))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000001")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000000")))))) OR ((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_access))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000001")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000000")))))));
      end if;
    end if;

  end process;

  -- Transitions into state 'access'.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dma_mem_read_access <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        dma_mem_read_access <= to_std_logic((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_idle))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000000")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000000")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(go))) = std_logic_vector'("00000000000000000000000000000001"))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_access))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000001")))))) OR (((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dma_mem_read_access))) = std_logic_vector'("00000000000000000000000000000001"))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000000")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000000")))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000000")))))));
      end if;
    end if;

  end process;

  p1_read_select <= Vector_To_Std_Logic((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((dma_mem_read_access AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000001"))))))))) AND std_logic_vector'("00000000000000000000000000000001"))) OR (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((dma_mem_read_access AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(read_waitrequest))) = std_logic_vector'("00000000000000000000000000000000"))))))))) AND std_logic_vector'("00000000000000000000000000000001")))) OR (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((dma_mem_read_idle AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(go))) = std_logic_vector'("00000000000000000000000000000001"))))) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_done_read))) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(p1_fifo_full))) = std_logic_vector'("00000000000000000000000000000000"))))))))) AND std_logic_vector'("00000000000000000000000000000001")))));

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

entity dma_mem_write is 
        port (
              -- inputs:
                 signal d1_enabled_write_endofpacket : IN STD_LOGIC;
                 signal fifo_datavalid : IN STD_LOGIC;
                 signal write_waitrequest : IN STD_LOGIC;

              -- outputs:
                 signal fifo_read : OUT STD_LOGIC;
                 signal inc_write : OUT STD_LOGIC;
                 signal mem_write_n : OUT STD_LOGIC;
                 signal write_select : OUT STD_LOGIC
              );
end entity dma_mem_write;


architecture europa of dma_mem_write is
                signal internal_fifo_read :  STD_LOGIC;
                signal internal_write_select :  STD_LOGIC;

begin

  internal_write_select <= fifo_datavalid AND NOT d1_enabled_write_endofpacket;
  mem_write_n <= NOT internal_write_select;
  internal_fifo_read <= internal_write_select AND NOT write_waitrequest;
  inc_write <= internal_fifo_read;
  --vhdl renameroo for output signals
  fifo_read <= internal_fifo_read;
  --vhdl renameroo for output signals
  write_select <= internal_write_select;

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

-- DMA peripheral dma
--Mastered by:
--cpu/data_master; 
--Read slaves:
--ext_ssram/s1; ext_flash/s1; ddr_sdram_0/s1; tightly_coupled_data_memory/s2; 
--Write slaves:
--ext_ssram/s1; ext_flash/s1; ddr_sdram_0/s1; tightly_coupled_data_memory/s2; 


entity dma is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal dma_ctl_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal dma_ctl_chipselect : IN STD_LOGIC;
                 signal dma_ctl_write_n : IN STD_LOGIC;
                 signal dma_ctl_writedata : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal read_endofpacket : IN STD_LOGIC;
                 signal read_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal read_readdatavalid : IN STD_LOGIC;
                 signal read_waitrequest : IN STD_LOGIC;
                 signal system_reset_n : IN STD_LOGIC;
                 signal write_endofpacket : IN STD_LOGIC;
                 signal write_waitrequest : IN STD_LOGIC;

              -- outputs:
                 signal dma_ctl_irq : OUT STD_LOGIC;
                 signal dma_ctl_readdata : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal dma_ctl_readyfordata : OUT STD_LOGIC;
                 signal read_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal read_chipselect : OUT STD_LOGIC;
                 signal read_flush : OUT STD_LOGIC;
                 signal read_read_n : OUT STD_LOGIC;
                 signal write_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal write_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal write_chipselect : OUT STD_LOGIC;
                 signal write_write_n : OUT STD_LOGIC;
                 signal write_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity dma;


architecture europa of dma is
component dma_read_data_mux is 
           port (
                 -- inputs:
                    signal byte_access : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal dma_ctl_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal dma_ctl_chipselect : IN STD_LOGIC;
                    signal dma_ctl_write_n : IN STD_LOGIC;
                    signal dma_ctl_writedata : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal hw : IN STD_LOGIC;
                    signal read_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal read_readdatavalid : IN STD_LOGIC;
                    signal readaddress : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal readaddress_inc : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal word : IN STD_LOGIC;

                 -- outputs:
                    signal fifo_wr_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component dma_read_data_mux;

component dma_byteenables is 
           port (
                 -- inputs:
                    signal byte_access : IN STD_LOGIC;
                    signal hw : IN STD_LOGIC;
                    signal word : IN STD_LOGIC;
                    signal write_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);

                 -- outputs:
                    signal write_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                 );
end component dma_byteenables;

component dma_fifo_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal fifo_read : IN STD_LOGIC;
                    signal fifo_wr_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal fifo_write : IN STD_LOGIC;
                    signal flush_fifo : IN STD_LOGIC;
                    signal inc_pending_data : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal fifo_datavalid : OUT STD_LOGIC;
                    signal fifo_empty : OUT STD_LOGIC;
                    signal fifo_rd_data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal p1_fifo_full : OUT STD_LOGIC
                 );
end component dma_fifo_module;

component dma_mem_read is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal clk_en : IN STD_LOGIC;
                    signal go : IN STD_LOGIC;
                    signal p1_done_read : IN STD_LOGIC;
                    signal p1_fifo_full : IN STD_LOGIC;
                    signal read_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal inc_read : OUT STD_LOGIC;
                    signal mem_read_n : OUT STD_LOGIC
                 );
end component dma_mem_read;

component dma_mem_write is 
           port (
                 -- inputs:
                    signal d1_enabled_write_endofpacket : IN STD_LOGIC;
                    signal fifo_datavalid : IN STD_LOGIC;
                    signal write_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal fifo_read : OUT STD_LOGIC;
                    signal inc_write : OUT STD_LOGIC;
                    signal mem_write_n : OUT STD_LOGIC;
                    signal write_select : OUT STD_LOGIC
                 );
end component dma_mem_write;

                signal busy :  STD_LOGIC;
                signal byte_access :  STD_LOGIC;
                signal clk_en :  STD_LOGIC;
                signal control :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal d1_done_transaction :  STD_LOGIC;
                signal d1_enabled_write_endofpacket :  STD_LOGIC;
                signal d1_read_got_endofpacket :  STD_LOGIC;
                signal d1_softwarereset :  STD_LOGIC;
                signal done :  STD_LOGIC;
                signal done_transaction :  STD_LOGIC;
                signal done_write :  STD_LOGIC;
                signal doubleword :  STD_LOGIC;
                signal enabled_write_endofpacket :  STD_LOGIC;
                signal fifo_datavalid :  STD_LOGIC;
                signal fifo_empty :  STD_LOGIC;
                signal fifo_rd_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal fifo_rd_data_as_byte_access :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal fifo_rd_data_as_hw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal fifo_rd_data_as_word :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal fifo_read :  STD_LOGIC;
                signal fifo_wr_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal fifo_write :  STD_LOGIC;
                signal fifo_write_data_valid :  STD_LOGIC;
                signal flush_fifo :  STD_LOGIC;
                signal go :  STD_LOGIC;
                signal hw :  STD_LOGIC;
                signal i_en :  STD_LOGIC;
                signal inc_read :  STD_LOGIC;
                signal inc_write :  STD_LOGIC;
                signal internal_read_read_n :  STD_LOGIC;
                signal internal_write_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_write_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal leen :  STD_LOGIC;
                signal len :  STD_LOGIC;
                signal length :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal length_eq_0 :  STD_LOGIC;
                signal mem_read_n :  STD_LOGIC;
                signal mem_write_n :  STD_LOGIC;
                signal p1_control :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal p1_dma_ctl_readdata :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal p1_done_read :  STD_LOGIC;
                signal p1_done_write :  STD_LOGIC;
                signal p1_fifo_full :  STD_LOGIC;
                signal p1_length :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal p1_length_eq_0 :  STD_LOGIC;
                signal p1_read_got_endofpacket :  STD_LOGIC;
                signal p1_readaddress :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal p1_write_got_endofpacket :  STD_LOGIC;
                signal p1_writeaddress :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal p1_writelength :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal p1_writelength_eq_0 :  STD_LOGIC;
                signal quadword :  STD_LOGIC;
                signal rcon :  STD_LOGIC;
                signal read_got_endofpacket :  STD_LOGIC;
                signal readaddress :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal readaddress_inc :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal reen :  STD_LOGIC;
                signal reop :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal set_software_reset_bit :  STD_LOGIC;
                signal software_reset_request :  STD_LOGIC;
                signal softwarereset :  STD_LOGIC;
                signal status :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal status_register_write :  STD_LOGIC;
                signal wcon :  STD_LOGIC;
                signal ween :  STD_LOGIC;
                signal weop :  STD_LOGIC;
                signal word :  STD_LOGIC;
                signal write_got_endofpacket :  STD_LOGIC;
                signal write_select :  STD_LOGIC;
                signal writeaddress :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal writeaddress_inc :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal writelength :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal writelength_eq_0 :  STD_LOGIC;

begin

  clk_en <= std_logic'('1');
  --control_port_slave, which is an e_avalon_slave
  --read_master, which is an e_avalon_master
  --the_dma_read_data_mux, which is an e_instance
  the_dma_read_data_mux : dma_read_data_mux
    port map(
      fifo_wr_data => fifo_wr_data,
      byte_access => byte_access,
      clk => clk,
      clk_en => clk_en,
      dma_ctl_address => dma_ctl_address,
      dma_ctl_chipselect => dma_ctl_chipselect,
      dma_ctl_write_n => dma_ctl_write_n,
      dma_ctl_writedata => dma_ctl_writedata,
      hw => hw,
      read_readdata => read_readdata,
      read_readdatavalid => read_readdatavalid,
      readaddress => readaddress,
      readaddress_inc => readaddress_inc,
      reset_n => reset_n,
      word => word
    );


  --write_master, which is an e_avalon_master
  --the_dma_byteenables, which is an e_instance
  the_dma_byteenables : dma_byteenables
    port map(
      write_byteenable => internal_write_byteenable,
      byte_access => byte_access,
      hw => hw,
      word => word,
      write_address => internal_write_address
    );


  dma_ctl_readyfordata <= NOT busy;
  internal_read_read_n <= mem_read_n;
  status_register_write <= (dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000000"))));
  -- read address
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      readaddress <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        readaddress <= p1_readaddress;
      end if;
    end if;

  end process;

  p1_readaddress <= A_EXT (A_WE_StdLogicVector((std_logic'((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000001"))))))) = '1'), (std_logic_vector'("0") & (dma_ctl_writedata)), A_WE_StdLogicVector((std_logic'((inc_read)) = '1'), (((std_logic_vector'("0") & (readaddress)) + (std_logic_vector'("000000000000000000000000") & (readaddress_inc)))), (std_logic_vector'("0") & (readaddress)))), 28);
  -- write address
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      writeaddress <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        writeaddress <= p1_writeaddress;
      end if;
    end if;

  end process;

  p1_writeaddress <= A_EXT (A_WE_StdLogicVector((std_logic'((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000010"))))))) = '1'), (std_logic_vector'("0") & (dma_ctl_writedata)), A_WE_StdLogicVector((std_logic'((inc_write)) = '1'), (((std_logic_vector'("0") & (writeaddress)) + (std_logic_vector'("000000000000000000000000") & (writeaddress_inc)))), (std_logic_vector'("0") & (writeaddress)))), 28);
  -- length in bytes
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      length <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        length <= p1_length;
      end if;
    end if;

  end process;

  p1_length <= A_EXT (A_WE_StdLogicVector((std_logic'((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011"))))))) = '1'), dma_ctl_writedata, (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(((inc_read AND (NOT(length_eq_0))))) = '1'), ((std_logic_vector'("0") & (length)) - (std_logic_vector'("0000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access))))), (std_logic_vector'("0") & (length)))))), 26);
  -- control register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      control <= std_logic_vector'("0000010000100");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        control <= p1_control;
      end if;
    end if;

  end process;

  p1_control <= A_EXT (A_WE_StdLogicVector((std_logic'((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000110"))) OR (((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000111"))))))))) = '1'), dma_ctl_writedata, (std_logic_vector'("000000000000000") & (control))), 13);
  -- write master length
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      writelength <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        writelength <= p1_writelength;
      end if;
    end if;

  end process;

  p1_writelength <= A_EXT (A_WE_StdLogicVector((std_logic'((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011"))))))) = '1'), dma_ctl_writedata, (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(((inc_write AND (NOT(writelength_eq_0))))) = '1'), ((std_logic_vector'("0") & (writelength)) - (std_logic_vector'("0000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access))))), (std_logic_vector'("0") & (writelength)))))), 26);
  p1_writelength_eq_0 <= (inc_write AND (NOT(writelength_eq_0))) AND to_std_logic((((std_logic_vector'("00000") & ((((std_logic_vector'("0") & (writelength)) - (std_logic_vector'("0000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access)))))))) = std_logic_vector'("00000000000000000000000000000000"))));
  p1_length_eq_0 <= (inc_read AND (NOT(length_eq_0))) AND to_std_logic((((std_logic_vector'("00000") & ((((std_logic_vector'("0") & (length)) - (std_logic_vector'("0000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access)))))))) = std_logic_vector'("00000000000000000000000000000000"))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      length_eq_0 <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011")))))) = '1' then 
          length_eq_0 <= std_logic'('0');
        elsif std_logic'(p1_length_eq_0) = '1' then 
          length_eq_0 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      writelength_eq_0 <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011")))))) = '1' then 
          writelength_eq_0 <= std_logic'('0');
        elsif std_logic'(p1_writelength_eq_0) = '1' then 
          writelength_eq_0 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  writeaddress_inc <= A_EXT (A_WE_StdLogicVector((std_logic'((wcon)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access))))), 5);
  readaddress_inc <= A_EXT (A_WE_StdLogicVector((std_logic'((rcon)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000") & (Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(word) & A_ToStdLogicVector(hw) & A_ToStdLogicVector(byte_access))))), 5);
  p1_dma_ctl_readdata <= (((((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000000")))), 28) AND (std_logic_vector'("00000000000000000000000") & (status)))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000001")))), 28) AND readaddress))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000010")))), 28) AND writeaddress))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000011")))), 28) AND (std_logic_vector'("00") & (writelength))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000110")))), 28) AND (std_logic_vector'("000000000000000") & (control))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dma_ctl_readdata <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        dma_ctl_readdata <= p1_dma_ctl_readdata;
      end if;
    end if;

  end process;

  done_transaction <= go AND done_write;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      done <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_register_write) = '1' then 
          done <= std_logic'('0');
        elsif std_logic'((done_transaction AND NOT d1_done_transaction)) = '1' then 
          done <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_done_transaction <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_done_transaction <= done_transaction;
      end if;
    end if;

  end process;

  busy <= go AND NOT done_write;
  status(0) <= done;
  status(1) <= busy;
  status(2) <= reop;
  status(3) <= weop;
  status(4) <= len;
  byte_access <= control(0);
  hw <= control(1);
  word <= control(2);
  go <= control(3);
  i_en <= control(4);
  reen <= control(5);
  ween <= control(6);
  leen <= control(7);
  rcon <= control(8);
  wcon <= control(9);
  doubleword <= control(10);
  quadword <= control(11);
  softwarereset <= control(12);
  dma_ctl_irq <= i_en AND done;
  p1_read_got_endofpacket <= NOT status_register_write AND ((read_got_endofpacket OR ((read_endofpacket AND reen))));
  p1_write_got_endofpacket <= NOT status_register_write AND ((write_got_endofpacket OR (((inc_write AND write_endofpacket) AND ween))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      read_got_endofpacket <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        read_got_endofpacket <= p1_read_got_endofpacket;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      write_got_endofpacket <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        write_got_endofpacket <= p1_write_got_endofpacket;
      end if;
    end if;

  end process;

  flush_fifo <= NOT d1_done_transaction AND done_transaction;
  --the_dma_fifo_module, which is an e_instance
  the_dma_fifo_module : dma_fifo_module
    port map(
      fifo_datavalid => fifo_datavalid,
      fifo_empty => fifo_empty,
      fifo_rd_data => fifo_rd_data,
      p1_fifo_full => p1_fifo_full,
      clk => clk,
      clk_en => clk_en,
      fifo_read => fifo_read,
      fifo_wr_data => fifo_wr_data,
      fifo_write => fifo_write,
      flush_fifo => flush_fifo,
      inc_pending_data => inc_read,
      reset_n => reset_n
    );


  --the_dma_mem_read, which is an e_instance
  the_dma_mem_read : dma_mem_read
    port map(
      inc_read => inc_read,
      mem_read_n => mem_read_n,
      clk => clk,
      clk_en => clk_en,
      go => go,
      p1_done_read => p1_done_read,
      p1_fifo_full => p1_fifo_full,
      read_waitrequest => read_waitrequest,
      reset_n => reset_n
    );


  fifo_write <= fifo_write_data_valid;
  enabled_write_endofpacket <= write_endofpacket AND ween;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_enabled_write_endofpacket <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_enabled_write_endofpacket <= enabled_write_endofpacket;
      end if;
    end if;

  end process;

  --the_dma_mem_write, which is an e_instance
  the_dma_mem_write : dma_mem_write
    port map(
      fifo_read => fifo_read,
      inc_write => inc_write,
      mem_write_n => mem_write_n,
      write_select => write_select,
      d1_enabled_write_endofpacket => d1_enabled_write_endofpacket,
      fifo_datavalid => fifo_datavalid,
      write_waitrequest => write_waitrequest
    );


  p1_done_read <= (((leen AND ((p1_length_eq_0 OR (length_eq_0))))) OR p1_read_got_endofpacket) OR p1_done_write;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      len <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_register_write) = '1' then 
          len <= std_logic'('0');
        elsif std_logic'(((NOT d1_done_transaction AND done_transaction) AND (writelength_eq_0))) = '1' then 
          len <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      reop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_register_write) = '1' then 
          reop <= std_logic'('0');
        elsif std_logic'(((fifo_empty AND read_got_endofpacket) AND d1_read_got_endofpacket)) = '1' then 
          reop <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      weop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'(status_register_write) = '1' then 
          weop <= std_logic'('0');
        elsif std_logic'(write_got_endofpacket) = '1' then 
          weop <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  p1_done_write <= (((leen AND ((p1_writelength_eq_0 OR writelength_eq_0)))) OR p1_write_got_endofpacket) OR (fifo_empty AND d1_read_got_endofpacket);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_read_got_endofpacket <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_read_got_endofpacket <= read_got_endofpacket;
      end if;
    end if;

  end process;

  -- Write has completed when the length goes to 0, or
  --the write source said end-of-packet, or
  --the read source said end-of-packet and the fifo has emptied.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      done_write <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        done_write <= p1_done_write;
      end if;
    end if;

  end process;

  read_address <= readaddress;
  internal_write_address <= writeaddress;
  write_chipselect <= write_select;
  read_chipselect <= NOT internal_read_read_n;
  write_write_n <= mem_write_n;
  read_flush <= flush_fifo;
  fifo_rd_data_as_byte_access <= Std_Logic_Vector'(fifo_rd_data(7 DOWNTO 0) & fifo_rd_data(7 DOWNTO 0) & fifo_rd_data(7 DOWNTO 0) & fifo_rd_data(7 DOWNTO 0));
  fifo_rd_data_as_hw <= Std_Logic_Vector'(fifo_rd_data(15 DOWNTO 0) & fifo_rd_data(15 DOWNTO 0));
  fifo_rd_data_as_word <= fifo_rd_data(31 DOWNTO 0);
  write_writedata <= (((A_REP(byte_access, 32) AND fifo_rd_data_as_byte_access)) OR ((A_REP(hw, 32) AND fifo_rd_data_as_hw))) OR ((A_REP(word, 32) AND fifo_rd_data_as_word));
  fifo_write_data_valid <= read_readdatavalid;
  set_software_reset_bit <= ((((dma_ctl_chipselect AND NOT dma_ctl_write_n) AND to_std_logic((((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000110"))) OR (((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) = std_logic_vector'("00000000000000000000000000000111")))))))) AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (dma_ctl_address)) /= std_logic_vector'("00000000000000000000000000000111"))))) AND dma_ctl_writedata(12);
  process (clk, system_reset_n)
  begin
    if system_reset_n = '0' then
      d1_softwarereset <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((set_software_reset_bit OR software_reset_request)) = '1' then 
        d1_softwarereset <= softwarereset AND NOT software_reset_request;
      end if;
    end if;

  end process;

  process (clk, system_reset_n)
  begin
    if system_reset_n = '0' then
      software_reset_request <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((set_software_reset_bit OR software_reset_request)) = '1' then 
        software_reset_request <= d1_softwarereset AND NOT software_reset_request;
      end if;
    end if;

  end process;

  reset_n <= NOT ((NOT system_reset_n OR software_reset_request));
  --vhdl renameroo for output signals
  read_read_n <= internal_read_read_n;
  --vhdl renameroo for output signals
  write_address <= internal_write_address;
  --vhdl renameroo for output signals
  write_byteenable <= internal_write_byteenable;

end europa;

