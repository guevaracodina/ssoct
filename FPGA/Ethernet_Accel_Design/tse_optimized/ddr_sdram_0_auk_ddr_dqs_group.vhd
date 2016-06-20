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

--------------------------------------------------------------------------------
--Parameters:
--Device Family                      : Stratix II
--DQ_PER_DQS                         : 8
--NON-DQS MODE                       : false
--use Resynch clock                  : true
--Resynch clock edge                 : falling
--Postamble Clock Edge               : rising
--Postamble Clock Cycle              : 1
--Intermediate Resynch               : false
--Intermediate Postamble             : false
--Pipeline read Data                 : true
--Enable Postamble Logic             : true
--Postamble Regs Per DQS             : 1
--Stratix Insert DQS delay buffers   : 0
--------------------------------------------------------------------------------
entity ddr_sdram_0_auk_ddr_dqs_group is 
        generic (
                 gDLL_INPUT_FREQUENCY : string := "6667ps";
                 gSTRATIXII_DLL_DELAY_BUFFER_MODE : string := "low";
                 gSTRATIXII_DQS_OUT_MODE : string := "delay_chain2";
                 gSTRATIXII_DQS_PHASE : natural := 6000
                 );
        port (
              -- inputs:
                 signal capture_clk : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal control_be : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal control_doing_rd : IN STD_LOGIC;
                 signal control_doing_wr : IN STD_LOGIC;
                 signal control_dqs_burst : IN STD_LOGIC;
                 signal control_wdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal control_wdata_valid : IN STD_LOGIC;
                 signal dqs_delay_ctrl : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal dqsupdate : IN STD_LOGIC;
                 signal postamble_clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal resynch_clk : IN STD_LOGIC;
                 signal write_clk : IN STD_LOGIC;

              -- outputs:
                 signal control_rdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal ddr_dm : OUT STD_LOGIC;
                 signal ddr_dq : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal ddr_dqs : INOUT STD_LOGIC
              );
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of ddr_sdram_0_auk_ddr_dqs_group : entity is "MESSAGE_DISABLE=14130;SUPPRESS_DA_RULE_INTERNAL=C101;SUPPRESS_DA_RULE_INTERNAL=C103;SUPPRESS_DA_RULE_INTERNAL=C105;SUPPRESS_DA_RULE_INTERNAL=C106;SUPPRESS_DA_RULE_INTERNAL=R104;SUPPRESS_DA_RULE_INTERNAL=A102;SUPPRESS_DA_RULE_INTERNAL=A103;SUPPRESS_DA_RULE_INTERNAL=C104;SUPPRESS_DA_RULE_INTERNAL=D101;SUPPRESS_DA_RULE_INTERNAL=D102;SUPPRESS_DA_RULE_INTERNAL=D103;SUPPRESS_DA_RULE_INTERNAL=R102;SUPPRESS_DA_RULE_INTERNAL=R105";
end entity ddr_sdram_0_auk_ddr_dqs_group;


architecture europa of ddr_sdram_0_auk_ddr_dqs_group is

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
		
            
    component stratixii_io 
    generic (
        operation_mode : string := "input";
        ddio_mode : string := "none";
        open_drain_output : string := "false";
        bus_hold : string := "false";
        output_register_mode : string := "none";
        output_async_reset : string := "none";
        output_power_up : string := "low";
        output_sync_reset : string := "none";
        tie_off_output_clock_enable : string := "false";
        oe_register_mode : string := "none";
        oe_async_reset : string := "none";
        oe_power_up : string := "low";
        oe_sync_reset : string := "none";
        tie_off_oe_clock_enable : string := "false";
        input_register_mode : string := "none";
        input_async_reset : string := "none";
        input_power_up : string := "low";
        input_sync_reset : string := "none";
        extend_oe_disable : string := "false";
        dqs_input_frequency : string := "10000ps";
        dqs_out_mode : string := "none";
        dqs_delay_buffer_mode : string := "low";
        dqs_phase_shift : integer := 0;
        inclk_input : string := "normal";
        ddioinclk_input : string := "negated_inclk";
        dqs_offsetctrl_enable : string := "false";
        dqs_ctrl_latches_enable : string := "false";
        dqs_edge_detect_enable : string := "false";
        gated_dqs : string := "false";
        sim_dqs_intrinsic_delay : integer := 0;
        sim_dqs_delay_increment : integer := 0;
        sim_dqs_offset_increment : integer := 0;
        lpm_type : string := "stratixii_io"
     );
     port (
        datain             : in std_logic := '0';
        ddiodatain         : in std_logic := '0';
        oe                 : in std_logic := '1';
        outclk             : in std_logic := '0';
        outclkena          : in std_logic := '1';
        inclk              : in std_logic := '0';
        inclkena           : in std_logic := '1';
        areset             : in std_logic := '0';
        sreset             : in std_logic := '0';
        ddioinclk          : in std_logic := '0';
        delayctrlin        : in std_logic_vector(5 downto 0) := "000000";
        offsetctrlin       : in std_logic_vector(5 downto 0) := "000000";
        dqsupdateen        : in std_logic := '0';
        linkin             : in std_logic := '0';
        terminationcontrol : in std_logic_vector(13 downto 0) := "00000000000000";      
        devclrn            : in std_logic := '1';
        devpor             : in std_logic := '1';
        devoe              : in std_logic := '0';
        padio              : inout std_logic;
        combout            : out std_logic;
        regout             : out std_logic;
        ddioregout         : out std_logic;
        dqsbusout          : out std_logic;
        linkout            : out std_logic
    );
    end component;
                        signal ONE :  STD_LOGIC;
                signal ZERO :  STD_LOGIC;
                signal ZEROS :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ZEROS_14 :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal be :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal delayed_dq_captured :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dm_out :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal doing_rd :  STD_LOGIC;
                signal doing_rd_delayed :  STD_LOGIC;
                signal doing_rd_pipe :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal doing_wr :  STD_LOGIC;
                signal doing_wr_r :  STD_LOGIC;
                signal dq_capture_clk :  STD_LOGIC;
                signal dq_captured_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dq_captured_1 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dq_captured_falling :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal dq_captured_rising :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal dq_enable_reset :  STD_LOGIC_VECTOR (0 DOWNTO 0);
                signal dq_oe :  STD_LOGIC;
                signal dqs_burst :  STD_LOGIC;
                signal dqs_clk :  STD_LOGIC_VECTOR (0 DOWNTO 0);
                signal dqs_oe :  STD_LOGIC;
                signal dqs_oe_r :  STD_LOGIC_VECTOR (0 DOWNTO 0);
                signal inter_rdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_ddr_dm :  STD_LOGIC;
                signal not_dqs_clk :  STD_LOGIC_VECTOR (0 DOWNTO 0);
                signal rdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal reset :  STD_LOGIC;
                signal resynched_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal tmp_dmout0 :  STD_LOGIC;
                signal tmp_dmout1 :  STD_LOGIC;
                signal undelayed_dqs :  STD_LOGIC_VECTOR (0 DOWNTO 0);
                signal wdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal wdata_r :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal wdata_valid :  STD_LOGIC;

begin

  --


  ONE <= std_logic'('1');
  ZERO <= std_logic'('0');
  ZEROS <= std_logic_vector'("00000000");
  ZEROS_14 <= std_logic_vector'("00000000000000");
  reset <= NOT reset_n;
  not_dqs_clk <= NOT dqs_clk;
  -- rename user i/f signals, outputs
  control_rdata <= rdata;
  -- rename user i/f signals, inputs
  wdata <= control_wdata;
  wdata_valid <= control_wdata_valid;
  doing_wr <= control_doing_wr;
  doing_rd <= control_doing_rd;
  be <= control_be;
  dqs_burst <= control_dqs_burst;
  -------------------------------------------------------------------------------
  --DQS pin and its logic
  --Generate the output enable for DQS from the signal that indicates we're
  --doing a write. The DQS burst signal is generated by the controller to keep
  --the DQS toggling for the required burst length.
  -------------------------------------------------------------------------------

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dqs_oe_r(0) <= std_logic'('0');
      doing_wr_r <= std_logic'('0');
    elsif clk'event and clk = '1' then
      dqs_oe_r(0) <= dqs_oe;
      doing_wr_r <= doing_wr;
    end if;

  end process;

  dqs_oe <= doing_wr OR dqs_burst;
  -------------------------------------------------------------------------------
  --DM pins and their logic
  --Although these don't get tristated like DQ, they do share the same IO timing.
  -------------------------------------------------------------------------------
  tmp_dmout0 <= dm_out(0);
  tmp_dmout1 <= dm_out(1);
  dm_pin : altddio_out
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
            aclr => reset,
            aset => open,
            datain_h => A_TOSTDLOGICVECTOR(tmp_dmout0),
            datain_l => A_TOSTDLOGICVECTOR(tmp_dmout1),
            dataout(0) => internal_ddr_dm,
            oe => ONE,
            outclock => write_clk,
            outclocken => ONE
    );

  -------------------------------------------------------------------------------
  --Data mask registers
  --These are the last registers before the registers in the altddio_out. They
  --are clocked off the system clock but feed registers which are clocked off the
  --write clock, so their output is the beginning of 3/4 cycle path.
  -------------------------------------------------------------------------------
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dm_out <= A_REP(std_logic'('1'), 2);
    elsif clk'event and clk = '1' then
      if std_logic'(doing_wr) = '1' then 
        -- don't latch in data unless it's valid
        dm_out <= NOT be;
      else
        dm_out <= A_REP(std_logic'('1'), 2);
      end if;
    end if;

  end process;

  -------------------------------------------------------------------------------
  --Logic to disable the capture registers (particularly during DQS postamble)
  --The output of the dq_enable_reset register holds the dq_enable register in
  --reset (which *enables* the dq capture registers). The controller releases
  --the dq_enable register so that it is clocked by the last falling edge of the
  --read dqs signal. This disables the dq capture registers during and after the
  --dqs postamble so that the output of the dq capture registers can be safely
  --resynchronised.
  --Postamble Clock Cycle  : 1
  --Postamble Clock Edge   : rising
  --Postamble Regs Per DQS : 1
  -------------------------------------------------------------------------------

  --Use a rising edge for postamble
  --The registers which generate the reset signal to the above registers
  --Can be clocked off the resynch or system clock
  process (postamble_clk, reset_n)
  begin
    if reset_n = '0' then
      dq_enable_reset(0) <= std_logic'('0');
    elsif postamble_clk'event and postamble_clk = '1' then
      dq_enable_reset(0) <= doing_rd_delayed;
    end if;

  end process;

  --pipeline the doing_rd signal to enable and disable the DQ capture regs at the right time
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      doing_rd_pipe <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      --shift bits up
      doing_rd_pipe <= Std_Logic_Vector'(doing_rd_pipe(1 DOWNTO 0) & A_ToStdLogicVector(doing_rd));
    end if;

  end process;

  --It's safe to clock from falling edge of clk to postamble_clk, so use falling edge clock
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      doing_rd_delayed <= std_logic'('0');
    elsif clk'event and clk = '0' then
      doing_rd_delayed <= doing_rd_pipe(1);
    end if;

  end process;

  -------------------------------------------------------------------------------
  --Decide which clock to use for capturing the DQ data
  -------------------------------------------------------------------------------
  --Use DQS to capture DQ read data
  dq_capture_clk <= NOT dqs_clk(0);
  -------------------------------------------------------------------------------
  --DQ pins and their logic
  -------------------------------------------------------------------------------
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dq_oe <= std_logic'('0');
    elsif clk'event and clk = '1' then
      dq_oe <= doing_wr;
    end if;

  end process;

  \g_dq_io:0:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(0),
            ddiodatain => wdata_r(8),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(0),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(0),
            regout => dq_captured_falling(0),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:1:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(1),
            ddiodatain => wdata_r(9),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(1),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(1),
            regout => dq_captured_falling(1),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:2:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(2),
            ddiodatain => wdata_r(10),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(2),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(2),
            regout => dq_captured_falling(2),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:3:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(3),
            ddiodatain => wdata_r(11),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(3),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(3),
            regout => dq_captured_falling(3),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:4:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(4),
            ddiodatain => wdata_r(12),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(4),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(4),
            regout => dq_captured_falling(4),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:5:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(5),
            ddiodatain => wdata_r(13),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(5),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(5),
            regout => dq_captured_falling(5),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:6:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(6),
            ddiodatain => wdata_r(14),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(6),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(6),
            regout => dq_captured_falling(6),
            sreset => open,
            terminationcontrol => open
    );

  \g_dq_io:7:dq_io\ : stratixii_io
    generic map(
      bus_hold => "false",
      ddio_mode => "bidir",
      ddioinclk_input => "negated_inclk",
      dqs_ctrl_latches_enable => "false",
      dqs_delay_buffer_mode => "none",
      dqs_edge_detect_enable => "false",
      dqs_input_frequency => "none",
      dqs_offsetctrl_enable => "false",
      dqs_out_mode => "none",
      dqs_phase_shift => 0,
      extend_oe_disable => "false",
      gated_dqs => "false",
      inclk_input => "dqs_bus",
      input_async_reset => "clear",
      input_power_up => "low",
      input_register_mode => "register",
      input_sync_reset => "none",
      lpm_type => "stratixii_io",
      oe_async_reset => "clear",
      oe_power_up => "low",
      oe_register_mode => "register",
      oe_sync_reset => "none",
      open_drain_output => "false",
      operation_mode => "bidir",
      output_async_reset => "clear",
      output_power_up => "low",
      output_register_mode => "register",
      output_sync_reset => "none",
      sim_dqs_delay_increment => 0,
      sim_dqs_intrinsic_delay => 0,
      sim_dqs_offset_increment => 0,
      tie_off_oe_clock_enable => "false",
      tie_off_output_clock_enable => "false"
    )
    port map(
            areset => reset,
            combout => open,
            datain => wdata_r(7),
            ddiodatain => wdata_r(15),
            ddioinclk => ZEROS(0),
            ddioregout => dq_captured_rising(7),
            delayctrlin => open,
            devclrn => open,
            devoe => open,
            devpor => open,
            dqsbusout => open,
            dqsupdateen => open,
            inclk => dq_capture_clk,
            inclkena => ONE,
            linkin => open,
            linkout => open,
            oe => dq_oe,
            offsetctrlin => open,
            outclk => write_clk,
            outclkena => ONE,
            padio => ddr_dq(7),
            regout => dq_captured_falling(7),
            sreset => open,
            terminationcontrol => open
    );

  -------------------------------------------------------------------------------
  --Write data registers
  --These are the last registers before the registers in the altddio_bidir. They
  --are clocked off the system clock but feed registers which are clocked off the
  --write clock, so their output is the beginning of 3/4 cycle path.
  -------------------------------------------------------------------------------
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      wdata_r <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(wdata_valid) = '1' then 
        --don't latch in data unless it's valid
        wdata_r <= wdata;
      end if;
    end if;

  end process;

  --Concatenate the rising and falling edge data to make a single bus
  dq_captured_0 <= dq_captured_falling & dq_captured_rising;
  dq_captured_1 <=  transport dq_captured_0 after 1666.75 ps ;
  --Apply delays in 2 chunks to avoid having to use transport delays
  delayed_dq_captured <=  transport dq_captured_1 after 1666.75 ps ;
  -------------------------------------------------------------------------------
  --Resynchronisation registers
  --These registers resychronise the captured read data from the DQS clock
  --domain back into an internal PLL clock domain. 
  -------------------------------------------------------------------------------
  --Use a falling edge for resynch
  process (resynch_clk, reset_n)
  begin
    if reset_n = '0' then
      resynched_data <= std_logic_vector'("0000000000000000");
    elsif resynch_clk'event and resynch_clk = '0' then
      resynched_data <= delayed_dq_captured;
    end if;

  end process;

  --don't insert pipeline registers
  inter_rdata <= resynched_data;
  -------------------------------------------------------------------------------
  --Pipeline read data registers
  --These optional registers can be inserted to make it easier to meet timing
  --coming out of the local_rdata port of the core. It's especially necessary
  --if a falling edge resynch edge is being used..
  --Note that the rdata_valid signal is also pipelined if this is set.
  -------------------------------------------------------------------------------

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rdata <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      rdata <= inter_rdata;
    end if;

  end process;

  --vhdl renameroo for output signals
  ddr_dm <= internal_ddr_dm;
--synthesis translate_off
    dqs_io : stratixii_io
      generic map(
        bus_hold => "false",
        ddio_mode => "output",
        ddioinclk_input => "inclk",
        dqs_ctrl_latches_enable => "true",
        dqs_delay_buffer_mode => gSTRATIXII_DLL_DELAY_BUFFER_MODE,
        dqs_edge_detect_enable => "false",
        dqs_input_frequency => gDLL_INPUT_FREQUENCY,
        dqs_offsetctrl_enable => "false",
        dqs_out_mode => gSTRATIXII_DQS_OUT_MODE,
        dqs_phase_shift => 6000,
        extend_oe_disable => "true",
        gated_dqs => "true",
        inclk_input => "dqs_bus",
        input_async_reset => "preset",
        input_power_up => "high",
        input_register_mode => "register",
        input_sync_reset => "clear",
        lpm_type => "stratixii_io",
        oe_async_reset => "none",
        oe_power_up => "low",
        oe_register_mode => "register",
        oe_sync_reset => "none",
        open_drain_output => "false",
        operation_mode => "bidir",
        output_async_reset => "none",
        output_power_up => "low",
        output_register_mode => "register",
        output_sync_reset => "none",
        sim_dqs_delay_increment => 36,
        sim_dqs_intrinsic_delay => 900,
        sim_dqs_offset_increment => 0,
        tie_off_oe_clock_enable => "false",
        tie_off_output_clock_enable => "false"
      )
      port map(
                areset => ONE,
                combout => undelayed_dqs(0),
                datain => dqs_oe_r(0),
                ddiodatain => ZEROS(0),
                ddioinclk => open,
                ddioregout => open,
                delayctrlin => dqs_delay_ctrl,
                devclrn => open,
                devoe => open,
                devpor => open,
                dqsbusout => dqs_clk(0),
                dqsupdateen => dqsupdate,
                inclk => not_dqs_clk(0),
                inclkena => ONE,
                linkin => open,
                linkout => open,
                oe => dqs_oe,
                offsetctrlin => open,
                outclk => clk,
                outclkena => ONE,
                padio => ddr_dqs,
                regout => open,
                sreset => open,
                terminationcontrol => open
      );

--synthesis translate_on
--synthesis read_comments_as_HDL on
--    dqs_io : stratixii_io
--      generic map(
--        bus_hold => "false",
--        ddio_mode => "output",
--        ddioinclk_input => "negated_inclk",
--        dqs_ctrl_latches_enable => "true",
--        dqs_delay_buffer_mode => gSTRATIXII_DLL_DELAY_BUFFER_MODE,
--        dqs_edge_detect_enable => "false",
--        dqs_input_frequency => gDLL_INPUT_FREQUENCY,
--        dqs_offsetctrl_enable => "false",
--        dqs_out_mode => gSTRATIXII_DQS_OUT_MODE,
--        dqs_phase_shift => 6000,
--        extend_oe_disable => "true",
--        gated_dqs => "true",
--        inclk_input => "dqs_bus",
--        input_async_reset => "preset",
--        input_power_up => "high",
--        input_register_mode => "register",
--        input_sync_reset => "clear",
--        lpm_type => "stratixii_io",
--        oe_async_reset => "none",
--        oe_power_up => "low",
--        oe_register_mode => "register",
--        oe_sync_reset => "none",
--        open_drain_output => "false",
--        operation_mode => "bidir",
--        output_async_reset => "none",
--        output_power_up => "low",
--        output_register_mode => "register",
--        output_sync_reset => "none",
--        sim_dqs_delay_increment => 36,
--        sim_dqs_intrinsic_delay => 900,
--        sim_dqs_offset_increment => 0,
--        tie_off_oe_clock_enable => "false",
--        tie_off_output_clock_enable => "false"
--      )
--      port map(
--                areset => dq_enable_reset(0),
--                combout => undelayed_dqs(0),
--                datain => dqs_oe_r(0),
--                ddiodatain => ZEROS(0),
--                ddioinclk => open,
--                ddioregout => open,
--                delayctrlin => dqs_delay_ctrl,
--                devclrn => open,
--                devoe => open,
--                devpor => open,
--                dqsbusout => dqs_clk(0),
--                dqsupdateen => dqsupdate,
--                inclk => not_dqs_clk(0),
--                inclkena => ONE,
--                linkin => open,
--                linkout => open,
--                oe => dqs_oe,
--                offsetctrlin => open,
--                outclk => clk,
--                outclkena => ONE,
--                padio => ddr_dqs,
--                regout => open,
--                sreset => ONE,
--                terminationcontrol => open
--      );
--
--synthesis read_comments_as_HDL off

end europa;

