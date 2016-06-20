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

library altera_mf;
use altera_mf.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.all;

entity pll is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal c0 : OUT STD_LOGIC;
                 signal c1 : OUT STD_LOGIC;
                 signal c2 : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal resetrequest : OUT STD_LOGIC
              );
end entity pll;


architecture europa of pll is
  component altpllpll is
PORT (
    signal c0 : OUT STD_LOGIC;
        signal c2 : OUT STD_LOGIC;
        signal c1 : OUT STD_LOGIC;
        signal inclk0 : IN STD_LOGIC
      );
  end component altpllpll;
                signal always_one :  STD_LOGIC;
                signal areset_n :  STD_LOGIC;
                signal control_reg_en :  STD_LOGIC;
                signal control_reg_in :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal control_reg_out :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal count_done :  STD_LOGIC;
                signal countup :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal inclk0 :  STD_LOGIC;
                signal internal_c0 :  STD_LOGIC;
                signal internal_c1 :  STD_LOGIC;
                signal internal_c2 :  STD_LOGIC;
                signal not_areset :  STD_LOGIC;
                signal reset_input :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal reset_input1 :  STD_LOGIC;
                signal rtmp :  STD_LOGIC;
                signal status_reg_in :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal status_reg_out :  STD_LOGIC_VECTOR (15 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of not_areset : signal is "PRESERVE_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of rtmp : signal is "PRESERVE_REGISTER=ON";

begin

  status_reg_in(15 DOWNTO 1) <= std_logic_vector'("000000000000000");
  resetrequest <= NOT count_done;
  --Up counter that stops counting when it reaches max value
  process (clk, areset_n)
  begin
    if areset_n = '0' then
      countup <= std_logic_vector'("000000");
    elsif clk'event and clk = '1' then
      if std_logic'(count_done) /= std_logic'(std_logic'('1')) then 
        countup <= A_EXT (((std_logic_vector'("000000000000000000000000000") & (countup)) + std_logic_vector'("000000000000000000000000000000001")), 6);
      end if;
    end if;

  end process;

  --Count_done signal, which is also the resetrequest_n
  process (clk, areset_n)
  begin
    if areset_n = '0' then
      count_done <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if countup = std_logic_vector'("111111") then 
        count_done <= std_logic'('1');
      end if;
    end if;

  end process;

  always_one <= std_logic'('1');
  status_reg_in(0) <= std_logic'('0');
  areset_n <= not_areset;
  inclk0 <= clk;
  --Mux status and control registers to the readdata output using address as select
  readdata <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(address(0)))) = std_logic_vector'("00000000000000000000000000000000"))), status_reg_out, (Std_Logic_Vector'(control_reg_out(15 DOWNTO 2) & A_ToStdLogicVector(NOT control_reg_out(1)) & A_ToStdLogicVector(control_reg_out(0)))));
  --Status register - Read-Only
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      status_reg_out <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      status_reg_out <= status_reg_in;
    end if;

  end process;

  --Control register - R/W
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      control_reg_out <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(control_reg_en) = '1' then 
        control_reg_out <= Std_Logic_Vector'(control_reg_in(15 DOWNTO 2) & A_ToStdLogicVector(NOT control_reg_in(1)) & A_ToStdLogicVector(control_reg_in(0)));
      end if;
    end if;

  end process;

  control_reg_in <= writedata;
  control_reg_en <= (to_std_logic(((address = std_logic_vector'("001")))) AND write) AND chipselect;
  --s1, which is an e_avalon_slave
  the_pll : altpllpll
    port map(
            c0 => internal_c0,
            c1 => internal_c1,
            c2 => internal_c2,
            inclk0 => inclk0
    );

  --vhdl renameroo for output signals
  c0 <= internal_c0;
  --vhdl renameroo for output signals
  c1 <= internal_c1;
  --vhdl renameroo for output signals
  c2 <= internal_c2;
--synthesis translate_off
    --mux for init value
    not_areset <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rtmp))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000000"), std_logic_vector'("00000000000000000000000000000001")));
    --rtmp register
    process (clk)
    begin
      if clk'event and clk = '1' then
        rtmp <= std_logic'('1');
      end if;

    end process;

reset_input <= std_logic_vector'("00000000000000000000000000000000");
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    
--    process (clk)
--    begin
--      if reset_input1 = '0' then
--        not_areset <= std_logic'('0');
--      elsif clk'event and clk = '1' then
--        not_areset <= always_one;
--      end if;
--
--    end process;
--
--reset_input1 <= std_logic'('1');
--synthesis read_comments_as_HDL off

end europa;

