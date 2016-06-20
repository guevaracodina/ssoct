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

library stratixii;
use stratixii.all;

entity ddr_sdram_0_auk_ddr_dll is 
        port (
              -- inputs:
                 signal addnsub : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal offset : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal stratix_dll_control : IN STD_LOGIC;

              -- outputs:
                 signal delayctrlout : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal dqsupdate : OUT STD_LOGIC
              );
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of ddr_sdram_0_auk_ddr_dll : entity is "MESSAGE_DISABLE=14130;MESSAGE_DISABLE=14110";
end entity ddr_sdram_0_auk_ddr_dll;


architecture europa of ddr_sdram_0_auk_ddr_dll is

	component stratixii_dll
	    generic ( 
	    input_frequency          : string := "10000ps";
	    delay_chain_length       : integer := 16;
	    delay_buffer_mode        : string := "low";
	    delayctrlout_mode        : string := "normal";
	    static_delay_ctrl        : integer := 0;
	    offsetctrlout_mode       : string := "static";
	    static_offset            : string := "0";
	    jitter_reduction         : string := "false";
	    use_upndnin              : string := "false";
	    use_upndninclkena        : string := "false";
	    sim_valid_lock           : integer := 1;
	    sim_loop_intrinsic_delay : integer := 1000;
	    sim_loop_delay_increment : integer := 100;
	    sim_valid_lockcount      : integer := 90;
	    lpm_type                 : string := "stratixii_dll"
	    );
	    port    ( 
	    	      clk                      : in std_logic := '0';
		      aload                    : in std_logic := '0';
		      offset                   : in std_logic_vector(5 DOWNTO 0) := "000000";
		      upndnin                  : in std_logic := '0';
		      upndninclkena            : in std_logic := '1';
		      addnsub                  : in std_logic := '0';
		      delayctrlout             : out std_logic_vector(5 DOWNTO 0);
		      offsetctrlout            : out std_logic_vector(5 DOWNTO 0);
		      dqsupdate                : out std_logic;
		      upndnout                 : out std_logic;	
		      devclrn                  : in std_logic := '1';
		      devpor                   : in std_logic := '1'
		    );
	
	end component;
		                signal internal_delayctrlout :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal internal_dqsupdate :  STD_LOGIC;

begin

  --------------------------------------------------------------
  --Instantiate Stratix II DLL
  --------------------------------------------------------------

  dll : stratixii_dll
    generic map(
      delay_buffer_mode => "low",
      delay_chain_length => 12,
      delayctrlout_mode => "normal",
      input_frequency => "6667ps",
      jitter_reduction => "false",
      lpm_type => "stratixii_dll",
      offsetctrlout_mode => "dynamic_addnsub",
      sim_loop_delay_increment => 144,
      sim_loop_intrinsic_delay => 3600,
      sim_valid_lock => 1,
      sim_valid_lockcount => 27,
      static_delay_ctrl => 0,
      static_offset => "0",
      use_upndnin => "false",
      use_upndninclkena => "false"
    )
    port map(
            addnsub => addnsub,
            aload => open,
            clk => clk,
            delayctrlout => internal_delayctrlout,
            devclrn => open,
            devpor => open,
            dqsupdate => internal_dqsupdate,
            offset => offset,
            offsetctrlout => open,
            upndnin => open,
            upndninclkena => open,
            upndnout => open
    );

  --vhdl renameroo for output signals
  delayctrlout <= internal_delayctrlout;
  --vhdl renameroo for output signals
  dqsupdate <= internal_dqsupdate;

end europa;

