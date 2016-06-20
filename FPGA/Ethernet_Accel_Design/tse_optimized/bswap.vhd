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

entity bswap is 
        port (
              -- inputs:
                 signal dataa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal datab : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity bswap;


architecture europa of bswap is

begin

  --s1, which is an e_custom_instruction_slave
  result(31) <= dataa(0);
  result(30) <= dataa(1);
  result(29) <= dataa(2);
  result(28) <= dataa(3);
  result(27) <= dataa(4);
  result(26) <= dataa(5);
  result(25) <= dataa(6);
  result(24) <= dataa(7);
  result(23) <= dataa(8);
  result(22) <= dataa(9);
  result(21) <= dataa(10);
  result(20) <= dataa(11);
  result(19) <= dataa(12);
  result(18) <= dataa(13);
  result(17) <= dataa(14);
  result(16) <= dataa(15);
  result(15) <= dataa(16);
  result(14) <= dataa(17);
  result(13) <= dataa(18);
  result(12) <= dataa(19);
  result(11) <= dataa(20);
  result(10) <= dataa(21);
  result(9) <= dataa(22);
  result(8) <= dataa(23);
  result(7) <= dataa(24);
  result(6) <= dataa(25);
  result(5) <= dataa(26);
  result(4) <= dataa(27);
  result(3) <= dataa(28);
  result(2) <= dataa(29);
  result(1) <= dataa(30);
  result(0) <= dataa(31);

end europa;

