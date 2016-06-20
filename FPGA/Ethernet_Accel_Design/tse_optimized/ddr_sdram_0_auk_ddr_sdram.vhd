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

library work;
use work.auk_ddr_functions.all;

entity ddr_sdram_0_auk_ddr_sdram is 
        generic (
                 gADDR_CMD_NEGEDGE : string := "false";
                 gEXTRA_PIPELINE_REGS : string := "false";
                 gFAMILY : string := "Stratix";
                 gINTER_RESYNCH : string := "false";
                 gLOCAL_AVALON_IF : string := "false";
                 gMEM_TYPE : string := "ddr_sdram";
                 gPIPELINE_COMMANDS : string := "true";
                 gPIPELINE_READDATA : string := "true";
                 gREG_DIMM : string := "false";
                 gSTRATIXII_DLL_DELAY_BUFFER_MODE : string := "low";
                 gSTRATIXII_DQS_OUT_MODE : string := "delay_chain2";
                 gSTRATIXII_DQS_PHASE : natural := 6000;
                 gSTRATIX_DLL_CONTROL : string := "false";
                 gUSER_REFRESH : string := "false"
                 );
        port (
              -- inputs:
                 signal addrcmd_clk : IN STD_LOGIC;
                 signal capture_clk : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal dqs_delay_ctrl : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal dqsupdate : IN STD_LOGIC;
                 signal local_addr : IN STD_LOGIC_VECTOR (22 DOWNTO 0);
                 signal local_autopch_req : IN STD_LOGIC;
                 signal local_be : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal local_burstbegin : IN STD_LOGIC;
                 signal local_read_req : IN STD_LOGIC;
                 signal local_refresh_req : IN STD_LOGIC;
                 signal local_size : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
                 signal local_wdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal local_write_req : IN STD_LOGIC;
                 signal mem_bl : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal mem_btype : IN STD_LOGIC;
                 signal mem_dll_en : IN STD_LOGIC;
                 signal mem_drv_str : IN STD_LOGIC;
                 signal mem_odt : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal mem_tcl : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal mem_tinit_time : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal mem_tmrd : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal mem_tras : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal mem_trcd : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal mem_trefi : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal mem_trfc : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal mem_trp : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal mem_twr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal mem_twtr : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal postamble_clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal resynch_clk : IN STD_LOGIC;
                 signal write_clk : IN STD_LOGIC;

              -- outputs:
                 signal clk_to_sdram : OUT STD_LOGIC;
                 signal clk_to_sdram_n : OUT STD_LOGIC;
                 signal ddr_a : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal ddr_ba : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_cas_n : OUT STD_LOGIC;
                 signal ddr_cke : OUT STD_LOGIC;
                 signal ddr_cs_n : OUT STD_LOGIC;
                 signal ddr_dm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal ddr_dqs : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_odt : OUT STD_LOGIC;
                 signal ddr_ras_n : OUT STD_LOGIC;
                 signal ddr_we_n : OUT STD_LOGIC;
                 signal local_init_done : OUT STD_LOGIC;
                 signal local_rdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal local_rdata_valid : OUT STD_LOGIC;
                 signal local_rdvalid_in_n : OUT STD_LOGIC;
                 signal local_ready : OUT STD_LOGIC;
                 signal local_refresh_ack : OUT STD_LOGIC;
                 signal local_wdata_req : OUT STD_LOGIC;
                 signal stratix_dll_control : OUT STD_LOGIC
              );
end entity ddr_sdram_0_auk_ddr_sdram;


architecture europa of ddr_sdram_0_auk_ddr_sdram is

        component auk_ddr_controller
            generic
            (
            gREG_DIMM               : string;        
            gLOCAL_DATA_BITS        : integer := 16;            
            gLOCAL_BURST_LEN        : integer := 4;             
            gLOCAL_BURST_LEN_BITS   : integer := 3;             
            gLOCAL_AVALON_IF        : string  := "false";
            gMEM_TYPE               : string  := "ddr_sdram";   
            gMEM_CHIPSELS           : integer := 2;             
            gMEM_CHIP_BITS          : integer := 1;             
            gMEM_ROW_BITS           : integer := 12;            
            gMEM_BANK_BITS          : integer := 2;             
            gMEM_COL_BITS           : integer := 10;            
            gMEM_DQ_PER_DQS         : integer := 8;             
            gMEM_PCH_BIT            : integer := 10;            
            gMEM_ODT_RANKS          : integer := 0;
            gPIPELINE_COMMANDS      : string  := "true";         
            gEXTRA_PIPELINE_REGS    : string  := "false";        
            gADDR_CMD_NEGEDGE       : string  := "false";        
            gFAMILY                 : string  := "Stratix";      
            gRESYNCH_CYCLE          : integer := 0;              
            gINTER_RESYNCH          : string  := "false";        
            gUSER_REFRESH           : string  := "false";        
            gPIPELINE_READDATA      : string  := "true";         
            gSTRATIX_DLL_CONTROL    : string  := "true"          
            );
            port
            (
            stratix_dll_control  : out   std_logic;   
            local_ready          : out   std_logic;
            local_rdata_valid    : out   std_logic;
            local_rdvalid_in_n   : out   std_logic;
            local_rdata          : out   std_logic_vector(gLOCAL_DATA_BITS - 1 downto 0);
            local_wdata_req      : out   std_logic;
            local_init_done      : out   std_logic;
            local_refresh_ack    : out   std_logic;
            ddr_cs_n             : out   std_logic_vector(gMEM_CHIPSELS  - 1 downto 0);
            ddr_cke              : out   std_logic_vector(gMEM_CHIPSELS  - 1 downto 0);
            ddr_odt              : out   std_logic_vector(gMEM_CHIPSELS  - 1 downto 0);
            ddr_a                : out   std_logic_vector(gMEM_ROW_BITS  - 1 downto 0);
            ddr_ba               : out   std_logic_vector(gMEM_BANK_BITS - 1 downto 0);
            ddr_ras_n            : out   std_logic;
            ddr_cas_n            : out   std_logic;
            ddr_we_n             : out   std_logic;
            control_doing_wr     : out   std_logic;
            control_dqs_burst    : out   std_logic;
            control_wdata_valid  : out   std_logic;
            control_wdata        : out   std_logic_vector(gLOCAL_DATA_BITS - 1 downto 0);
            control_be           : out   std_logic_vector(gLOCAL_DATA_BITS/8 - 1 downto 0);
            control_doing_rd     : out   std_logic;

            clk                  : in    std_logic;
            reset_n              : in    std_logic;
            write_clk            : in    std_logic;
            local_read_req       : in    std_logic;
            local_write_req      : in    std_logic;
            local_size           : in    std_logic_vector(gLOCAL_BURST_LEN_BITS - 1 downto 0); 
            local_burstbegin     : in    std_logic; 
            local_cs_addr        : in    std_logic_vector(auk_to_legal_width(gMEM_CHIP_BITS) - 1 downto 0);
            local_row_addr       : in    std_logic_vector(gMEM_ROW_BITS  - 1 downto 0);
            local_bank_addr      : in    std_logic_vector(gMEM_BANK_BITS - 1 downto 0);
            local_col_addr       : in    std_logic_vector(gMEM_COL_BITS  - 2 downto 0); 
            local_wdata          : in    std_logic_vector(gLOCAL_DATA_BITS - 1 downto 0);
            local_be             : in    std_logic_vector(gLOCAL_DATA_BITS/8 - 1 downto 0);
            local_refresh_req    : in    std_logic;
            local_autopch_req    : in    std_logic;
            control_rdata        : in    std_logic_vector(gLOCAL_DATA_BITS - 1 downto 0);
            mem_tcl              : in    std_logic_vector(2 downto 0); 
            mem_bl               : in    std_logic_vector(2 downto 0); 
            mem_odt              : in    std_logic_vector(1 downto 0); 
            mem_btype            : in    std_logic;                    
            mem_dll_en           : in    std_logic;                    
            mem_drv_str          : in    std_logic;                    
            mem_trcd             : in    std_logic_vector(2 downto 0); 
            mem_tras             : in    std_logic_vector(3 downto 0); 
            mem_twtr             : in    std_logic_vector(1 downto 0); 
            mem_twr              : in    std_logic_vector(2 downto 0); 
            mem_trp              : in    std_logic_vector(2 downto 0); 
            mem_trfc             : in    std_logic_vector(6 downto 0); 
            mem_tmrd             : in    std_logic_vector(1 downto 0); 
            mem_trefi            : in    std_logic_vector(15 downto 0);
            mem_tinit_time       : in    std_logic_vector(15 downto 0) 
            );
        end component;
          component ddr_sdram_0_auk_ddr_datapath is
GENERIC (
      gstratixii_dll_delay_buffer_mode : STRING;
        gstratixii_dqs_out_mode : STRING;
        gstratixii_dqs_phase : NATURAL
      );
    PORT (
    signal ddr_dm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal ddr_dqs : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal clk_to_sdram : OUT STD_LOGIC;
        signal control_rdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal ddr_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        signal clk_to_sdram_n : OUT STD_LOGIC;
        signal dqs_delay_ctrl : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        signal capture_clk : IN STD_LOGIC;
        signal resynch_clk : IN STD_LOGIC;
        signal control_wdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal dqsupdate : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal write_clk : IN STD_LOGIC;
        signal control_wdata_valid : IN STD_LOGIC;
        signal control_doing_wr : IN STD_LOGIC;
        signal control_doing_rd : IN STD_LOGIC;
        signal control_be : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal control_dqs_burst : IN STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal postamble_clk : IN STD_LOGIC
      );
  end component ddr_sdram_0_auk_ddr_datapath;
                signal control_be :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal control_doing_rd :  STD_LOGIC;
                signal control_doing_wr :  STD_LOGIC;
                signal control_dqs_burst :  STD_LOGIC;
                signal control_rdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal control_wdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal control_wdata_valid :  STD_LOGIC;
                signal internal_clk_to_sdram :  STD_LOGIC;
                signal internal_clk_to_sdram_n :  STD_LOGIC;
                signal internal_ddr_dm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_local_init_done :  STD_LOGIC;
                signal internal_local_rdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_local_rdata_valid :  STD_LOGIC;
                signal internal_local_rdvalid_in_n :  STD_LOGIC;
                signal internal_local_ready :  STD_LOGIC;
                signal internal_local_refresh_ack :  STD_LOGIC;
                signal internal_local_wdata_req :  STD_LOGIC;
                signal internal_stratix_dll_control :  STD_LOGIC;
                signal local_bank_addr :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal local_col_addr :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal local_cs_addr :  STD_LOGIC;
                signal local_row_addr :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal tmp_ddr_a :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal tmp_ddr_ba :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal tmp_ddr_cas_n :  STD_LOGIC;
                signal tmp_ddr_cke :  STD_LOGIC;
                signal tmp_ddr_cs_n :  STD_LOGIC;
                signal tmp_ddr_odt :  STD_LOGIC;
                signal tmp_ddr_ras_n :  STD_LOGIC;
                signal tmp_ddr_we_n :  STD_LOGIC;

begin

  local_cs_addr <= std_logic'('0');
  --


  local_bank_addr <= local_addr(22 DOWNTO 21);
  local_row_addr <= local_addr(20 DOWNTO 8);
  local_col_addr <= local_addr(7 DOWNTO 0);
  -------------------------------------------------------------------------------
  --Controller
  -------------------------------------------------------------------------------
  ddr_control : auk_ddr_controller
    generic map(
      gADDR_CMD_NEGEDGE => gADDR_CMD_NEGEDGE,
      gEXTRA_PIPELINE_REGS => gEXTRA_PIPELINE_REGS,
      gFAMILY => gFAMILY,
      gINTER_RESYNCH => gINTER_RESYNCH,
      gLOCAL_AVALON_IF => gLOCAL_AVALON_IF,
      gLOCAL_BURST_LEN => 1,
      gLOCAL_BURST_LEN_BITS => 1,
      gLOCAL_DATA_BITS => 32,
      gMEM_BANK_BITS => 2,
      gMEM_CHIPSELS => 1,
      gMEM_CHIP_BITS => 0,
      gMEM_COL_BITS => 9,
      gMEM_DQ_PER_DQS => 8,
      gMEM_ODT_RANKS => 0,
      gMEM_PCH_BIT => 10,
      gMEM_ROW_BITS => 13,
      gMEM_TYPE => gMEM_TYPE,
      gPIPELINE_COMMANDS => gPIPELINE_COMMANDS,
      gPIPELINE_READDATA => gPIPELINE_READDATA,
      gREG_DIMM => gREG_DIMM,
      gRESYNCH_CYCLE => 1,
      gSTRATIX_DLL_CONTROL => gSTRATIX_DLL_CONTROL,
      gUSER_REFRESH => gUSER_REFRESH
    )
    port map(
            clk => clk,
            control_be => control_be,
            control_doing_rd => control_doing_rd,
            control_doing_wr => control_doing_wr,
            control_dqs_burst => control_dqs_burst,
            control_rdata => control_rdata,
            control_wdata => control_wdata,
            control_wdata_valid => control_wdata_valid,
            ddr_a => tmp_ddr_a,
            ddr_ba => tmp_ddr_ba,
            ddr_cas_n => tmp_ddr_cas_n,
            ddr_cke(0) => tmp_ddr_cke,
            ddr_cs_n(0) => tmp_ddr_cs_n,
            ddr_odt(0) => tmp_ddr_odt,
            ddr_ras_n => tmp_ddr_ras_n,
            ddr_we_n => tmp_ddr_we_n,
            local_autopch_req => local_autopch_req,
            local_bank_addr => local_bank_addr,
            local_be => local_be,
            local_burstbegin => local_burstbegin,
            local_col_addr => local_col_addr,
            local_cs_addr => A_TOSTDLOGICVECTOR(local_cs_addr),
            local_init_done => internal_local_init_done,
            local_rdata => internal_local_rdata,
            local_rdata_valid => internal_local_rdata_valid,
            local_rdvalid_in_n => internal_local_rdvalid_in_n,
            local_read_req => local_read_req,
            local_ready => internal_local_ready,
            local_refresh_ack => internal_local_refresh_ack,
            local_refresh_req => local_refresh_req,
            local_row_addr => local_row_addr,
            local_size => A_TOSTDLOGICVECTOR(local_size(0)),
            local_wdata => local_wdata,
            local_wdata_req => internal_local_wdata_req,
            local_write_req => local_write_req,
            mem_bl => mem_bl,
            mem_btype => mem_btype,
            mem_dll_en => mem_dll_en,
            mem_drv_str => mem_drv_str,
            mem_odt => mem_odt,
            mem_tcl => mem_tcl,
            mem_tinit_time => mem_tinit_time,
            mem_tmrd => mem_tmrd,
            mem_tras => mem_tras,
            mem_trcd => mem_trcd,
            mem_trefi => mem_trefi,
            mem_trfc => mem_trfc,
            mem_trp => mem_trp,
            mem_twr => mem_twr,
            mem_twtr => mem_twtr,
            reset_n => reset_n,
            stratix_dll_control => internal_stratix_dll_control,
            write_clk => write_clk
    );

  ddr_io : ddr_sdram_0_auk_ddr_datapath
    generic map(
      gstratixii_dll_delay_buffer_mode => gSTRATIXII_DLL_DELAY_BUFFER_MODE,
      gstratixii_dqs_out_mode => gSTRATIXII_DQS_OUT_MODE,
      gstratixii_dqs_phase => 6000
    )
    port map(
            capture_clk => capture_clk,
            clk => clk,
            clk_to_sdram => internal_clk_to_sdram,
            clk_to_sdram_n => internal_clk_to_sdram_n,
            control_be => control_be,
            control_doing_rd => control_doing_rd,
            control_doing_wr => control_doing_wr,
            control_dqs_burst => control_dqs_burst,
            control_rdata => control_rdata,
            control_wdata => control_wdata,
            control_wdata_valid => control_wdata_valid,
            ddr_dm => internal_ddr_dm(1 DOWNTO 0),
            ddr_dq => ddr_dq,
            ddr_dqs => ddr_dqs(1 DOWNTO 0),
            dqs_delay_ctrl => dqs_delay_ctrl,
            dqsupdate => dqsupdate,
            postamble_clk => postamble_clk,
            reset_n => reset_n,
            resynch_clk => resynch_clk,
            write_clk => write_clk
    );

  ddr_cs_n <= tmp_ddr_cs_n;
  ddr_cke <= tmp_ddr_cke;
  ddr_odt <= tmp_ddr_odt;
  ddr_a <= tmp_ddr_a;
  ddr_ba <= tmp_ddr_ba;
  ddr_ras_n <= tmp_ddr_ras_n;
  ddr_cas_n <= tmp_ddr_cas_n;
  ddr_we_n <= tmp_ddr_we_n;
  --vhdl renameroo for output signals
  clk_to_sdram <= internal_clk_to_sdram;
  --vhdl renameroo for output signals
  clk_to_sdram_n <= internal_clk_to_sdram_n;
  --vhdl renameroo for output signals
  ddr_dm <= internal_ddr_dm;
  --vhdl renameroo for output signals
  local_init_done <= internal_local_init_done;
  --vhdl renameroo for output signals
  local_rdata <= internal_local_rdata;
  --vhdl renameroo for output signals
  local_rdata_valid <= internal_local_rdata_valid;
  --vhdl renameroo for output signals
  local_rdvalid_in_n <= internal_local_rdvalid_in_n;
  --vhdl renameroo for output signals
  local_ready <= internal_local_ready;
  --vhdl renameroo for output signals
  local_refresh_ack <= internal_local_refresh_ack;
  --vhdl renameroo for output signals
  local_wdata_req <= internal_local_wdata_req;
  --vhdl renameroo for output signals
  stratix_dll_control <= internal_stratix_dll_control;

end europa;

