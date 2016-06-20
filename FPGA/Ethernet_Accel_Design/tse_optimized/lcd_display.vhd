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

entity lcd_display is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- outputs:
                 signal LCD_E : OUT STD_LOGIC;
                 signal LCD_RS : OUT STD_LOGIC;
                 signal LCD_RW : OUT STD_LOGIC;
                 signal LCD_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity lcd_display;


architecture europa of lcd_display is

begin

  LCD_RW <= address(0);
  LCD_RS <= address(1);
  LCD_E <= read OR write;
  LCD_data <= A_WE_StdLogicVector((std_logic'((address(0))) = '1'), std_logic_vector'("ZZZZZZZZ"), writedata);
  readdata <= LCD_data;
  --control_slave, which is an e_avalon_slave

end europa;

