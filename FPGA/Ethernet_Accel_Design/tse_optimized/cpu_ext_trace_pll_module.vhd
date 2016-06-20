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

entity cpu_ext_trace_pll_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal clkx2 : OUT STD_LOGIC
              );
end entity cpu_ext_trace_pll_module;


architecture europa of cpu_ext_trace_pll_module is
--synthesis read_comments_as_HDL on
--component altclklock is 
--           generic (
--                    clock1_boost : NATURAL := 2;
--                    clock1_divide : NATURAL := 1;
--                    inclock_period : NATURAL := 6666;
--                    intended_device_family : STRING := "STRATIXII";
--                    invalid_lock_cycles : NATURAL := 5;
--                    invalid_lock_multiplier : NATURAL := 5;
--                    lpm_type : STRING := "altclklock";
--                    operation_mode : STRING := "NORMAL";
--                    outclock_phase_shift : NATURAL := 0;
--                    valid_lock_cycles : NATURAL := 1;
--                    valid_lock_multiplier : NATURAL := 1
--                    );
--           port (
--                 
--                    signal inclock : IN STD_LOGIC;
--
--                 
--                    signal clock1 : OUT STD_LOGIC
--                 );
--end component altclklock;
--
--synthesis read_comments_as_HDL off
                signal internal_clkx2 :  STD_LOGIC;

begin

  --vhdl renameroo for output signals
  clkx2 <= internal_clkx2;
--synthesis translate_off
    process
    begin
      internal_clkx2 <= '0';
      loop
         if (internal_clkx2 = '1') then
            wait for 1 ns;
            internal_clkx2 <= not internal_clkx2;
         else
            wait for 2 ns;
            internal_clkx2 <= not internal_clkx2;
         end if;
      end loop;
    end process;
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    
--    cpu_nios2_oci_altclklock : altclklock
--      generic map(
--        clock1_boost => 2,
--        clock1_divide => 1,
--        inclock_period => 6666,
--        intended_device_family => "STRATIXII",
--        invalid_lock_cycles => 5,
--        invalid_lock_multiplier => 5,
--        lpm_type => "altclklock",
--        operation_mode => "NORMAL",
--        outclock_phase_shift => 0,
--        valid_lock_cycles => 1,
--        valid_lock_multiplier => 1
--      )
--      port map(
--        clock1 => internal_clkx2,
--        inclock => clk
--      );
--
--
--synthesis read_comments_as_HDL off

end europa;

