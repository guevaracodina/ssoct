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

------------------------------------------------------------------------------------
--Parameters:
--Number of memory clock output pairs    : 1
------------------------------------------------------------------------------------

entity ddr_sdram_0_auk_ddr_clk_gen is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal clk_to_sdram : OUT STD_LOGIC;
                 signal clk_to_sdram_n : OUT STD_LOGIC
              );
end entity ddr_sdram_0_auk_ddr_clk_gen;


architecture europa of ddr_sdram_0_auk_ddr_clk_gen is

		component altddio_out
		 generic (
			width                  : positive;  
			power_up_high          : string := "OFF";
			oe_reg                 : string := "UNUSED";
			extend_oe_disable      : string := "UNUSED";
			invert_output          : string := "OFF";
			intended_device_family : string := "MERCURY";
			lpm_hint               : string := "UNUSED";
			lpm_type               : string := "altddio_out" 
		);
		 port (
			datain_h   : in std_logic_vector(width-1 downto 0);
			datain_l   : in std_logic_vector(width-1 downto 0);
			outclock   : in std_logic;
			outclocken : in std_logic := '1';
			aset       : in std_logic := '0';
			aclr       : in std_logic := '0';
			oe         : in std_logic := '1';
			dataout    : out std_logic_vector(width-1 downto 0) 
		 );
		end component;
		                signal clk_n :  STD_LOGIC;
                signal gnd_signal :  STD_LOGIC;
                signal internal_clk_to_sdram :  STD_LOGIC;
                signal internal_clk_to_sdram_n :  STD_LOGIC;
                signal vcc_signal :  STD_LOGIC;

begin

  clk_n <= NOT clk;
  vcc_signal <= std_logic'('1');
  gnd_signal <= std_logic'('0');
  --------------------------------------------------------------
  --Stratix/Cyclone can drive clocks out on normal pins using
  --ALTDDIO_OUT megafunction
  --------------------------------------------------------------
  --Instantiate DDR IOs for driving the SDRAM clock off-chip

  ddr_clk_out_p : altddio_out
    generic map(
      extend_oe_disable => "UNUSED",
      intended_device_family => "Stratix II",
      invert_output => "OFF",
      lpm_hint => "UNUSED",
      lpm_type => "altddio_out",
      oe_reg => "UNUSED",
      power_up_high => "OFF",
      width => 1
    )
    port map(
            aclr => open,
            aset => open,
            datain_h => A_TOSTDLOGICVECTOR(gnd_signal),
            datain_l => A_TOSTDLOGICVECTOR(vcc_signal),
            dataout(0) => internal_clk_to_sdram,
            oe => open,
            outclock => clk_n,
            outclocken => open
    );

  ddr_clk_out_n : altddio_out
    generic map(
      extend_oe_disable => "UNUSED",
      intended_device_family => "Stratix II",
      invert_output => "OFF",
      lpm_hint => "UNUSED",
      lpm_type => "altddio_out",
      oe_reg => "UNUSED",
      power_up_high => "OFF",
      width => 1
    )
    port map(
            aclr => open,
            aset => open,
            datain_h => A_TOSTDLOGICVECTOR(gnd_signal),
            datain_l => A_TOSTDLOGICVECTOR(vcc_signal),
            dataout(0) => internal_clk_to_sdram_n,
            oe => open,
            outclock => clk,
            outclocken => open
    );

  --vhdl renameroo for output signals
  clk_to_sdram <= internal_clk_to_sdram;
  --vhdl renameroo for output signals
  clk_to_sdram_n <= internal_clk_to_sdram_n;

end europa;

