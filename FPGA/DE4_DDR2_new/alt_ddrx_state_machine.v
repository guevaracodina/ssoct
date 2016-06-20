//Legal Notice: (C)2009 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

///////////////////////////////////////////////////////////////////////////////
// Title         : DDRx controller state machine
//
// File          : alt_ddrx_state_machine.v
//
// Abstract      : State machine
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_state_machine
    # (parameter
    
        // controller settings
        CTL_LOOK_AHEAD_DEPTH    = 4,
        WDATA_BEATS_WIDTH       = 6, // LOCAL_SIZE_WIDTH + log2 (CTL_CMD_QUEUE_DEPTH)
        MEM_TYPE                = "DDR3",
        LOCAL_SIZE_WIDTH        = 3,
        DWIDTH_RATIO            = 4,
        STATEMACHINE_TYPE       = "TWO_CK",
        MEMORY_BURSTLENGTH      = 8,
        CTL_CSR_ENABLED         = 0,
        CTL_ECC_ENABLED         = 0, // This is for ECC partial write only
        CTL_REGDIMM_ENABLED     = 0, // This is to enable support for regdimm / rdimm
        CTL_USR_REFRESH         = 0, // 1 if user is controlling refresh
        
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS        = 1,
        MEM_IF_CS_WIDTH         = 2,
        MEM_IF_BA_WIDTH         = 3,  // max supported bank bits
        MEM_IF_ROW_WIDTH        = 13, // max supported row bits
        MEM_IF_COL_WIDTH        = 10, // max supported column bits
        MEM_IF_CSR_CS_WIDTH     = 2,
        MEM_IF_CSR_BANK_WIDTH   = 3,
        MEM_IF_CSR_ROW_WIDTH    = 13,
        MEM_IF_CSR_COL_WIDTH    = 10
        
    )
    (
    
        ctl_clk,
        ctl_reset_n,
        ctl_cal_success,
        
        // command queue interface
        cmd_fifo_empty,
        cmd_fifo_wren,
        write_req_to_wfifo,
        fetch,
        flush1,
        flush2,
        flush3,
        
        cmd0_is_a_read,
        cmd0_is_a_write,
        cmd0_autopch_req,
        cmd0_multicast_req,
        cmd0_burstcount,
        cmd0_chip_addr,
        cmd0_bank_addr,
        cmd0_row_addr,
        cmd0_col_addr,
        cmd0_is_valid,
        cmd0_is_sequential,
        cmd0_diff_cs,
        
        cmd1_is_a_read,
        cmd1_is_a_write,
        cmd1_autopch_req,
        cmd1_multicast_req,
        cmd1_burstcount,
        cmd1_chip_addr,
        cmd1_bank_addr,
        cmd1_row_addr,
        cmd1_col_addr,
        cmd1_is_valid,
        cmd1_is_sequential,
        cmd1_diff_cs,
        
        cmd2_is_a_read,
        cmd2_is_a_write,
        cmd2_autopch_req,
        cmd2_multicast_req,
        cmd2_burstcount,
        cmd2_chip_addr,
        cmd2_bank_addr,
        cmd2_row_addr,
        cmd2_col_addr,
        cmd2_is_valid,
        cmd2_is_sequential,
        cmd2_diff_cs,
        
        cmd3_is_a_read,
        cmd3_is_a_write,
        cmd3_autopch_req,
        cmd3_multicast_req,
        cmd3_burstcount,
        cmd3_chip_addr,
        cmd3_bank_addr,
        cmd3_row_addr,
        cmd3_col_addr,
        cmd3_is_valid,
        cmd3_is_sequential,
        cmd3_diff_cs,
        
        cmd4_is_a_write,
        cmd4_chip_addr,
        cmd4_bank_addr,
        cmd4_row_addr,
        cmd4_is_valid,
        cmd4_multicast_req,
        cmd4_is_sequential,
        
        cmd5_is_a_write,
        cmd5_chip_addr,
        cmd5_bank_addr,
        cmd5_row_addr,
        cmd5_is_valid,
        cmd5_multicast_req,
        
        cmd6_is_a_write,
        cmd6_chip_addr,
        cmd6_bank_addr,
        cmd6_row_addr,
        cmd6_is_valid,
        cmd6_multicast_req,
        
        cmd7_is_a_write,
        cmd7_chip_addr,
        cmd7_bank_addr,
        cmd7_row_addr,
        cmd7_is_valid,
        cmd7_multicast_req,
        
        current_is_a_read,
        current_is_a_write,
        current_chip_addr,
        current_bank_addr,
        current_row_addr,
        current_multicast_req,
        
        // inputs from bank management block
        all_banks_closed,
        bank_info_valid,
        bank_is_open,
        row_is_open,
        current_bank_info_valid,
        current_bank_is_open,
        current_row_is_open,
        
        // inputs from the timer block
        zq_cal_req,
        add_lat_on,
        can_al_activate_write,
        can_al_activate_read,
        can_read,            // [1:0], cmd0 and cmd-1
        can_write,            // [1:0], cmd0 and cmd-1
        can_activate,            // [CTL_LOOK_AHEAD_DEPTH-1:0]
        can_precharge,            // [CTL_LOOK_AHEAD_DEPTH-1:0]
        can_read_current,
        can_write_current,
        can_activate_current,
        can_precharge_current,
        can_lmr,            // chip wide
        can_precharge_all,
        can_refresh,
        can_enter_power_down,          // [MEM_IF_CHIP_BITS-1:0]
        can_exit_power_saving_mode,
        can_self_rfsh,           // [MEM_IF_CHIP_BITS-1:0]
        
        // periodic auto-refresh interface
        auto_refresh_req,     // refresh timer has expired, 
        auto_refresh_chip,
        
        // user auto-refresh interface
        local_refresh_req,       // user refresh req
        local_refresh_chip,      // [MEM_IF_CS_WIDTH-1:0], which CS to auto-refresh
        local_refresh_ack,
        
        // power-down interface
        power_down_req,          // power down timer has expired, 
        local_power_down_ack,
        
        // user self-refresh interface
        local_self_rfsh_req,     // user refresh request
        local_self_rfsh_chip,    // [MEM_IF_CS_WIDTH-1:0], which CS to auto-refresh
        local_self_rfsh_ack,     // user refresh acknowledge
        
        // ecc interface
        do_ecc,
        do_partial,
        ecc_fetch_error_addr,
        wdata_is_partial,
        ecc_single_bit_error,
        rmw_data_ready,
        ecc_error_chip_addr,
        ecc_error_bank_addr,
        ecc_error_row_addr,
        ecc_error_col_addr,
        
        // csr inputs
        cs_width_from_csr,
        bank_width_from_csr,
        row_width_from_csr,
        col_width_from_csr,
        
        // state machine command outputs
        do_write,
        do_read,
        do_auto_precharge,
        do_burst_chop,
        do_activate,
        do_precharge,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        do_lmr,
        do_precharge_all,
        do_zqcal,
        
        rdwr_data_valid,
        
        to_chip,
        to_bank_addr,
        to_row_addr,
        to_col_addr,

        addr_order,
        regdimm_enable

    );

    input ctl_clk;
    input ctl_reset_n;
    input ctl_cal_success;
    
    // command queue interface
    input                               cmd_fifo_empty;
    input                               cmd_fifo_wren;
    input                               write_req_to_wfifo;
    output                              fetch;
    output                              flush1;
    output                              flush2;
    output                              flush3;
    
    input                               cmd0_is_a_read;
    input                               cmd0_is_a_write;
    input                               cmd0_autopch_req;
    input                               cmd0_multicast_req;
    input   [LOCAL_SIZE_WIDTH-1:0]      cmd0_burstcount;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd0_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd0_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd0_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]      cmd0_col_addr;
    input                               cmd0_is_valid;
    input                               cmd0_is_sequential;
    input                               cmd0_diff_cs;
    
    input                               cmd1_is_a_read;
    input                               cmd1_is_a_write;
    input                               cmd1_autopch_req;
    input                               cmd1_multicast_req;
    input   [LOCAL_SIZE_WIDTH-1:0]      cmd1_burstcount;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd1_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd1_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd1_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]      cmd1_col_addr;
    input                               cmd1_is_valid;
    input                               cmd1_is_sequential;
    input                               cmd1_diff_cs;
    
    input                               cmd2_is_a_read;
    input                               cmd2_is_a_write;
    input                               cmd2_autopch_req;
    input                               cmd2_multicast_req;
    input   [LOCAL_SIZE_WIDTH-1:0]      cmd2_burstcount;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd2_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd2_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd2_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]      cmd2_col_addr;
    input                               cmd2_is_valid;
    input                               cmd2_is_sequential;
    input                               cmd2_diff_cs;
    
    input                               cmd3_is_a_read;
    input                               cmd3_is_a_write;
    input                               cmd3_autopch_req;
    input                               cmd3_multicast_req;
    input   [LOCAL_SIZE_WIDTH-1:0]      cmd3_burstcount;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd3_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd3_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd3_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]      cmd3_col_addr;
    input                               cmd3_is_valid;
    input                               cmd3_is_sequential;
    input                               cmd3_diff_cs;
    
    input                               cmd4_is_a_write;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd4_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd4_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd4_row_addr;
    input                               cmd4_is_valid;
    input                               cmd4_multicast_req;
    input                               cmd4_is_sequential;
    
    input                               cmd5_is_a_write;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd5_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd5_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd5_row_addr;
    input                               cmd5_is_valid;
    input                               cmd5_multicast_req;
    
    input                               cmd6_is_a_write;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd6_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd6_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd6_row_addr;
    input                               cmd6_is_valid;
    input                               cmd6_multicast_req;
    
    input                               cmd7_is_a_write;
    input   [MEM_IF_CHIP_BITS-1:0]      cmd7_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       cmd7_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      cmd7_row_addr;
    input                               cmd7_is_valid;
    input                               cmd7_multicast_req;
    
    output                              current_is_a_read;
    output                              current_is_a_write;
    output  [MEM_IF_CHIP_BITS-1:0]      current_chip_addr;
    output  [MEM_IF_BA_WIDTH-1:0]       current_bank_addr;
    output  [MEM_IF_ROW_WIDTH-1:0]      current_row_addr;
    output                              current_multicast_req;
    
    // inputs from bank management block
    input   [MEM_IF_CS_WIDTH-1:0]       all_banks_closed;
    input   [CTL_LOOK_AHEAD_DEPTH-1:0]  bank_info_valid;
    input   [CTL_LOOK_AHEAD_DEPTH-1:0]  bank_is_open;
    input   [CTL_LOOK_AHEAD_DEPTH-1:0]  row_is_open;
    input                               current_bank_info_valid;
    input                               current_bank_is_open;
    input                               current_row_is_open;
    
    // inputs from the timer block
    input                               zq_cal_req;
    input                               add_lat_on;
    input                               can_al_activate_write;
    input                               can_al_activate_read;
    input   [1:0]                       can_read;            // [1:0], cmd0 and cmd-1
    input   [1:0]                       can_write;            // [1:0], cmd0 and cmd-1
    input   [CTL_LOOK_AHEAD_DEPTH-1:0]  can_activate;            // [CTL_LOOK_AHEAD_DEPTH-1:0]
    input   [CTL_LOOK_AHEAD_DEPTH-1:0]  can_precharge;            // [CTL_LOOK_AHEAD_DEPTH-1:0]
    input                               can_read_current;
    input                               can_write_current;
    input                               can_activate_current;
    input                               can_precharge_current;
    input   [MEM_IF_CS_WIDTH-1:0]       can_lmr;
    input   [MEM_IF_CS_WIDTH-1:0]       can_precharge_all;
    input   [MEM_IF_CS_WIDTH-1:0]       can_refresh;
    input   [MEM_IF_CS_WIDTH-1:0]       can_enter_power_down;          // [MEM_IF_CHIP_BITS-1:0]
    input   [MEM_IF_CS_WIDTH-1:0]       can_exit_power_saving_mode;    // [MEM_IF_CHIP_BITS-1:0]
    input   [MEM_IF_CS_WIDTH-1:0]       can_self_rfsh;           // [MEM_IF_CHIP_BITS-1:0]
    
    // periodic auto-refresh interface
    input                               auto_refresh_req;     // refresh timer has expired, active high
    input   [MEM_IF_CS_WIDTH-1:0]       auto_refresh_chip;      // [MEM_IF_CHIP_BITS-1:0], which CS refresh timer has expired
    
    // user auto-refresh interface
    input                               local_refresh_req;       // user refresh req
    input   [MEM_IF_CS_WIDTH-1:0]       local_refresh_chip;      // [MEM_IF_CHIP_BITS-1:0], which CS to auto-refresh
    output                              local_refresh_ack;
    
    // power-down interface
    input                               power_down_req;          // power down timer has expired, active high
    output                              local_power_down_ack;
    
    // user self-refresh interface
    input                               local_self_rfsh_req;     // user refresh request
    input   [MEM_IF_CS_WIDTH-1:0]       local_self_rfsh_chip;    // [MEM_IF_CHIP_BITS-1:0], which CS to auto-refresh
    output                              local_self_rfsh_ack;     // user refresh acknowledge
    
    // ecc interface
    output                              do_ecc;
    output                              do_partial;
    output                              ecc_fetch_error_addr;
    input                               wdata_is_partial;
    input                               ecc_single_bit_error;
    input                               rmw_data_ready;
    input   [MEM_IF_CHIP_BITS-1:0]      ecc_error_chip_addr;
    input   [MEM_IF_BA_WIDTH-1:0]       ecc_error_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]      ecc_error_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]      ecc_error_col_addr;
    
    // csr inputs
    input   [MEM_IF_CSR_CS_WIDTH-1:0]   cs_width_from_csr;
    input   [MEM_IF_CSR_BANK_WIDTH-1:0] bank_width_from_csr;
    input   [MEM_IF_CSR_ROW_WIDTH-1:0]  row_width_from_csr;
    input   [MEM_IF_CSR_COL_WIDTH-1:0]  col_width_from_csr;
    
    // state machine command outputs
    output do_write;
    output do_read;
    output do_auto_precharge;
    output do_burst_chop;
    output do_activate;
    output do_precharge;
    output do_refresh;
    output do_power_down;
    output do_self_rfsh;
    output do_lmr;
    output do_precharge_all;
    output do_zqcal;
    
    output rdwr_data_valid;
    
    output  [MEM_IF_CS_WIDTH-1:0]       to_chip;
    output  [MEM_IF_BA_WIDTH-1:0]       to_bank_addr;
    output  [MEM_IF_ROW_WIDTH-1:0]      to_row_addr;
    output  [MEM_IF_COL_WIDTH-1:0]      to_col_addr;

    input   [1:0]                       addr_order; // 1 is chipbankrowcol, 0 is chiprowbankcol
    input   regdimm_enable;
    
    
    //states list
    localparam INIT         = 32'h696e6974;
    localparam FETCH        = 32'h66657468;
    localparam DO1          = 32'h646f3031;
    localparam DO2          = 32'h646f3032;
    localparam READWRITE    = 32'h72647772;
    localparam PCHALL       = 32'h70636861;
    localparam REFRESH      = 32'h72667368;
    localparam PDOWN        = 32'h7064776e;
    localparam SELFRFSH     = 32'h736c7266;
    localparam ZQCAL        = 32'h7a63616c;
    localparam ECC_DO2      = 32'h65636377;
    
    //typedef enum {INIT,FETCH,DO1,DO2,WRITE,READ} try;
    //try state;
    
    localparam CHIP_BANK_BUS    = MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH;
    localparam INT_SIZE_WIDTH   = (CTL_ECC_ENABLED == 1 && LOCAL_SIZE_WIDTH < 3) ? 3 : LOCAL_SIZE_WIDTH; // 3 bit at least to put decimal 4 onto bus
    
    reg fetch;
    reg fetch_r;
    reg fetch_r2;
    reg [31:0] state;
    reg do_write;
    reg do_read;
    reg do_auto_precharge;
    reg do_burst_chop;
    reg do_activate;
    reg do_precharge;
    reg do_refresh;
    reg do_power_down;
    reg do_self_rfsh;
    reg do_lmr;
    reg do_precharge_all;
    reg do_zqcal;
    
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  cmd_is_valid;
    
    wire    [MEM_IF_BA_WIDTH-1:0]       to_bank_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      to_row_addr;
    wire    [MEM_IF_COL_WIDTH-1:0]      to_col_addr;
    
    wire                                current_is_a_read;
    wire                                current_is_a_write;
    reg                                 current_read;
    reg                                 current_write;
    reg                                 current_autopch_req;
    reg                                 current_multicast_req;
    reg                                 current_is_ecc;
    reg                                 current_diff_cs;
    reg     [INT_SIZE_WIDTH-1:0]        current_burstcount_counter;
    reg     [INT_SIZE_WIDTH-1:0]        current_burstcount_counter_r;
    reg     [INT_SIZE_WIDTH-1:0]        current_burstcount_counter_r2;
    wire    [MEM_IF_CHIP_BITS-1:0]      current_chip_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       current_bank_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      current_row_addr;
    reg     [MEM_IF_CHIP_BITS-1:0]      current_chip;
    reg     [MEM_IF_BA_WIDTH-1:0]       current_bank;
    reg     [MEM_IF_ROW_WIDTH-1:0]      current_row;
    reg     [MEM_IF_COL_WIDTH-1:0]      current_col;
    reg                                 chip_incremented;
    reg                                 bank_incremented;
    reg                                 row_incremented;
    
    reg                                 current_copy_read;
    reg                                 current_copy_write;
    reg                                 current_copy_autopch_req;
    reg                                 current_copy_multicast_req;
    reg                                 current_copy_diff_cs;
    reg     [INT_SIZE_WIDTH-1:0]        current_copy_burstcount_counter;
    reg     [MEM_IF_CHIP_BITS-1:0]      current_copy_chip;
    reg     [MEM_IF_BA_WIDTH-1:0]       current_copy_bank;
    reg     [MEM_IF_ROW_WIDTH-1:0]      current_copy_row;
    reg     [MEM_IF_COL_WIDTH-1:0]      current_copy_col;
    reg     [1:0]                       current_copy_burst_delay;
    reg     [1:0]                       combine_happened;
    
    reg                                 cmd0_is_sequential_reg;
    reg     [1:0]                       burst_delay;
    reg     [1:0]                       burst_delay_r;
    reg     [1:0]                       burst_delay_r2;
    reg                                 can_fetch;
    
    reg     [MEM_IF_CS_WIDTH-1:0]       to_chip;
    reg     [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] to_addr;
    wire    [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] current_addr;
    wire    [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] cmd0_addr;
    wire    [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] cmd1_addr;
    wire    [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] cmd2_addr;
    wire    [MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:0] cmd3_addr;
    
    wire    [MEM_IF_CHIP_BITS-1:0]      max_chip_from_csr;
    wire    [MEM_IF_BA_WIDTH-1:0]       max_bank_from_csr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      max_row_from_csr;
    wire    [MEM_IF_COL_WIDTH-1:0]      max_col_from_csr;
    
    wire rdwr_data_valid;
    reg stall_burstcount;
    reg stall_burstcount_r;
    reg stall_burstcount_r2;
    reg [1:0] sense_burst_chop; //two types of burst chop, lower half, upper half
    
    reg  [MEM_IF_CS_WIDTH-1:0] for_chip;
    wire  [MEM_IF_CS_WIDTH-1:0] for_chip_current;
    wire  [MEM_IF_CS_WIDTH-1:0] for_chip_next;

    wire int_refresh_req;
    reg  int_refresh_ack;
    wire refresh_chip_ok;
    wire [MEM_IF_CS_WIDTH-1:0] refresh_chip;
    
    wire int_power_down_req;
    wire [MEM_IF_CS_WIDTH-1:0] power_down_chip;
    
    reg  int_self_rfsh_req;
    wire self_rfsh_chip_ok;
    reg  [MEM_IF_CS_WIDTH-1:0] self_rfsh_chip;
    reg  [MEM_IF_CS_WIDTH-1:0] for_chip_self_rfsh_saved;

    reg  for_chip_refresh_req;
    reg  for_chip_self_rfsh_req;
    reg  for_chip_power_down_req;
    reg  zq_cal_req_r;

    wire precharge_all_chip_ok;
    
    reg  [MEM_IF_CS_WIDTH-1:0] for_chip_saved;
    wire [MEM_IF_CS_WIDTH-1:0] for_chip_mask;
    reg  [MEM_IF_CS_WIDTH-1:0] for_chip_mask_gen;

    // these are bank information, timer information (can read/write/activate) is checked separately
    wire                                current_is_ready;   // current is ready/open for read/write
    wire                                precharge_current;  // precharge required for current
    wire                                activate_current;   // activate required for current
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  cmd_is_ready;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  precharge_cmd;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  activate_cmd;
    
    wire    no_intrpt_pending;
    
    reg [1:0] combine_allowed;
    reg [1:0] combine_req;
    reg [1:0] combine_dqs;
    reg [1:0] combine_dqs_r;
    reg flush1;
    reg flush2;
    reg flush3;
    
    reg     just_did_activate;
    reg [4:0]   just_did_precharge_to_cmd; // 4 because last is for current
    wire    [CHIP_BANK_BUS-1:0] current_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd0_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd1_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd2_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd3_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd4_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd5_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd6_bank_index;
    wire    [CHIP_BANK_BUS-1:0] cmd7_bank_index;
    reg [CTL_LOOK_AHEAD_DEPTH-1:0]   lookahead_allowed_to_cmd;
    
    // merge combine signals
    reg [1:0]   max_dqs_combine_allowed; //only evaluated once - in DO1 state
    wire        crossing_burst_boundary; //full rate only, valid only after fetch (with fetch_r)
    
    // auto autopch signal
    wire    enable_aap;
    reg auto_autopch_req_c; // compared to current, no fetch
    reg auto_autopch_req_0; // compared to cmd0, fetch
    reg auto_autopch_req_1; // compared to cmd1, fetch flush1
    reg auto_autopch_req_2; // compared to cmd2, fetch flush2
    reg auto_autopch_req_3; // compared to cmd3, fetch flush3
    reg auto_autopch_req;
    
    // writepause signal group
    wire    support_writepause;
    reg [WDATA_BEATS_WIDTH-1:0]   proper_beats_in_fifo;
    reg [3:0]   simple_beats_info;
    reg [3:0]   simple_burstcount;
    reg [3:0]   simple_burstcount_r2;
    reg enough_data_to_write;
    wire    decrement_normal;
    wire    decrement_with_flush;
    reg flush_r;
    reg flush_r2;
    
    reg start_burst;
    reg start_burst_r;
    reg [1:0] bl_counter;
    reg burst_length_gen;
    wire burst_length;
    
    reg start_write_burst;
    reg start_write_burst_r;
    reg [1:0] bl_write_counter;
    reg write_burst_length_gen;
    wire write_burst_length;
    
    reg new_gen_rdwr_data_valid;
    reg longer_than_1_req;
    reg from_fetch_state;
    
    // multichip specific
    reg is_diff_chip;
    reg is_diff_chip_r;
    
    // for fmax reason
    wire    [2:0]   cmd0_burst_til_cmd1;
    wire    [2:0]   cmd0_burst_til_cmd2;
    
    // ecc signals
    wire    int_ecc_req;
    reg     do_ecc;
    reg     do_partial;
    reg     partial_write_read;
    wire    ecc_fetch_error_addr;
    reg     ecc_fetch;
    reg     ecc_dummy_fetch;
    reg     ecc_internal_fetch;
    
    reg     [255:0] partial_data_pipe;
    reg     [7:0]   partial_data_location;
    wire    [4:0]   short_partial_data_pipe;
    
    reg         partial_write;
    
    // proper multicast signal if not gated in wrapper
    wire    proper_multicast_cmd0;
    wire    proper_multicast_cmd1;
    wire    proper_multicast_cmd2;
    wire    proper_multicast_cmd3;
    wire    proper_multicast_cmd4;
    wire    proper_multicast_cmd5;
    wire    proper_multicast_cmd6;
    wire    proper_multicast_cmd7;
    
    assign  current_is_a_read   =   current_read;
    assign  current_is_a_write  =   current_write;
    assign  current_chip_addr   =   current_chip;
    assign  current_bank_addr   =   current_bank;
    assign  current_row_addr    =   current_row;
    
    assign  cmd_is_valid[0] = cmd0_is_valid;
    assign  cmd_is_valid[1] = cmd1_is_valid;
    assign  cmd_is_valid[2] = cmd2_is_valid;
    assign  cmd_is_valid[3] = cmd3_is_valid;
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 4)
            begin
                assign  cmd_is_valid[4] = cmd4_is_valid;
                assign  cmd_is_valid[5] = cmd5_is_valid;
            end
    endgenerate
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 6)
            begin
                assign  cmd_is_valid[6] = cmd6_is_valid;
                assign  cmd_is_valid[7] = cmd7_is_valid;
            end
    endgenerate
    
    assign  to_bank_addr    =   to_addr[MEM_IF_BA_WIDTH+MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH];
    assign  to_row_addr     =   to_addr[MEM_IF_ROW_WIDTH+MEM_IF_COL_WIDTH-1:MEM_IF_COL_WIDTH];
    assign  to_col_addr     =   to_addr[MEM_IF_COL_WIDTH-1:0];
    assign  current_addr    =   {current_bank,current_row,current_col[MEM_IF_COL_WIDTH-1:3],3'b000};
    assign  cmd0_addr       =   {cmd0_bank_addr,cmd0_row_addr,cmd0_col_addr};
    assign  cmd1_addr       =   {cmd1_bank_addr,cmd1_row_addr,cmd1_col_addr};
    assign  cmd2_addr       =   {cmd2_bank_addr,cmd2_row_addr,cmd2_col_addr};
    assign  cmd3_addr       =   {cmd3_bank_addr,cmd3_row_addr,cmd3_col_addr};
    
    assign int_refresh_req = (CTL_USR_REFRESH == 1) ? local_refresh_req : auto_refresh_req;
    assign refresh_chip = (local_refresh_req) ? local_refresh_chip:auto_refresh_chip;
    assign local_refresh_ack = int_refresh_ack;
    
    assign int_power_down_req = power_down_req;
    assign power_down_chip = {MEM_IF_CS_WIDTH{1'b1}};
    assign local_power_down_ack = do_power_down;
    
    assign local_self_rfsh_ack = do_self_rfsh;
    
    assign int_ecc_req = ecc_single_bit_error;
    assign ecc_fetch_error_addr = ecc_fetch;
    
    assign rdwr_data_valid = new_gen_rdwr_data_valid;
    
    // !!!can't just look at the bottom bits!
    assign  cmd0_burst_til_cmd1 = (cmd0_burstcount + cmd1_burstcount > 3) ? 3'd4 : cmd0_burstcount + cmd1_burstcount;
    assign  cmd0_burst_til_cmd2 = (cmd0_burstcount + cmd1_burstcount + cmd2_burstcount > 3) ? 3'd4 : cmd0_burstcount + cmd1_burstcount + cmd2_burstcount;
    
    assign  crossing_burst_boundary = (current_burstcount_counter + burst_delay > 4) ? 1'b1 : 1'b0;
    
    generate
        genvar I;
        for (I = 0; I < CTL_LOOK_AHEAD_DEPTH; I = I + 1)
            begin : A
                assign cmd_is_ready[I]  =   cmd_is_valid[I] && bank_info_valid[I] && bank_is_open[I] && row_is_open[I];
                assign precharge_cmd[I] =   cmd_is_valid[I] && bank_info_valid[I] && bank_is_open[I] && !row_is_open[I];
                assign activate_cmd[I]  =   cmd_is_valid[I] && bank_info_valid[I] && !bank_is_open[I];
            end
    endgenerate
    
    assign  current_is_ready    =   current_bank_info_valid && current_bank_is_open && current_row_is_open;
    assign  precharge_current   =   current_bank_info_valid && current_bank_is_open && !current_row_is_open;
    assign  activate_current    =   current_bank_info_valid && !current_bank_is_open;
    
    assign  current_bank_index  =   {current_chip,current_bank};
    assign  cmd0_bank_index     =   {cmd0_chip_addr,cmd0_bank_addr};
    assign  cmd1_bank_index     =   {cmd1_chip_addr,cmd1_bank_addr};
    assign  cmd2_bank_index     =   {cmd2_chip_addr,cmd2_bank_addr};
    assign  cmd3_bank_index     =   {cmd3_chip_addr,cmd3_bank_addr};
    assign  cmd4_bank_index     =   {cmd4_chip_addr,cmd4_bank_addr};
    assign  cmd5_bank_index     =   {cmd5_chip_addr,cmd5_bank_addr};
    assign  cmd6_bank_index     =   {cmd6_chip_addr,cmd6_bank_addr};
    assign  cmd7_bank_index     =   {cmd7_chip_addr,cmd7_bank_addr};
    
    // enable auto auto precharge here
    // turning this off may introduce protocol failure
    // designed and tested with this turned on
    assign  enable_aap = 1'b1;
    
    // set this to high then state machine will wait for minimum data
    // required to be in wdata fifo before doing a write
    assign  support_writepause  = 1'b1;
    
    assign  no_intrpt_pending   =   !int_refresh_req && !int_power_down_req && !int_self_rfsh_req && !int_ecc_req;
    
    // gate multicast with write
    assign  proper_multicast_cmd0   =   cmd0_multicast_req & cmd0_is_a_write;
    assign  proper_multicast_cmd1   =   cmd1_multicast_req & cmd1_is_a_write;
    assign  proper_multicast_cmd2   =   cmd2_multicast_req & cmd2_is_a_write;
    assign  proper_multicast_cmd3   =   cmd3_multicast_req & cmd3_is_a_write;
    assign  proper_multicast_cmd4   =   cmd4_multicast_req & cmd4_is_a_write;
    assign  proper_multicast_cmd5   =   cmd5_multicast_req & cmd5_is_a_write;
    assign  proper_multicast_cmd6   =   cmd6_multicast_req & cmd6_is_a_write;
    assign  proper_multicast_cmd7   =   cmd7_multicast_req & cmd7_is_a_write;
    
    // csr wiring
    assign  max_chip_from_csr   =   (2**cs_width_from_csr) - 1'b1;
    assign  max_bank_from_csr   =   (2**bank_width_from_csr) - 1'b1;
    assign  max_row_from_csr    =   (2**row_width_from_csr) - 1'b1;
    assign  max_col_from_csr    =   (2**col_width_from_csr) - 1'b1;
    
    // generate max_dqs_combine_allowed
    //assign  max_dqs_combine_allowed = ~burst_delay;
    // max_dqs_combine_allowed ranges from 0-3
    always @(*)
        begin
            // if already crossing, allow combine of the ramainding cycle
            if (crossing_burst_boundary)
                begin
                    if (CTL_ECC_ENABLED == 1)
                        max_dqs_combine_allowed <= 0;
                    else if (current_burstcount_counter + burst_delay < 8)
                        max_dqs_combine_allowed <= 4'd8 - (current_burstcount_counter + burst_delay);
                    else
                        max_dqs_combine_allowed <= 0;
                end
            // 
            else
                begin
                    if (CTL_ECC_ENABLED == 1 && combine_allowed != 3)
                        max_dqs_combine_allowed <= combine_allowed;
                    else
                        max_dqs_combine_allowed <= 3'd4 - (current_burstcount_counter + burst_delay);
                end
        end
    
    // logic that decides whether lookahead is allowed to specific command in queue
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                lookahead_allowed_to_cmd[0]  <=  1'b0;
            else
                begin
                    if (fetch)
                        begin
                            if (flush3)
                                lookahead_allowed_to_cmd[0] <=  1'b0;
                            else if (flush2)
                                lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[3];
                            else if (flush1)
                                lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[2];
                            else
                                lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[1];
                        end
                    else if (flush3)
                        lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[3];
                    else if (flush2)
                        lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[2];
                    else if (flush1)
                        lookahead_allowed_to_cmd[0] <=  lookahead_allowed_to_cmd[1];
                    else if (cmd_is_valid[0] &&
                        (((!current_multicast_req && !proper_multicast_cmd0) && (current_bank_index != cmd0_bank_index)) || ((current_multicast_req || proper_multicast_cmd0) && (current_bank != cmd0_bank_addr)))
                        )
                        lookahead_allowed_to_cmd[0]  <=  1'b1;
                    else
                        lookahead_allowed_to_cmd[0]  <=  1'b0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                lookahead_allowed_to_cmd[1]  <=  1'b0;
            else
                begin
                    if (fetch)
                        begin
                            if (flush3 || flush2)
                                lookahead_allowed_to_cmd[1] <=  1'b0;
                            else if (flush1)
                                lookahead_allowed_to_cmd[1] <=  lookahead_allowed_to_cmd[3];
                            else
                                lookahead_allowed_to_cmd[1] <=  lookahead_allowed_to_cmd[2];
                        end
                    else if (flush3)
                        lookahead_allowed_to_cmd[1] <=  1'b0;
                    else if (flush2)
                        lookahead_allowed_to_cmd[1] <=  lookahead_allowed_to_cmd[3];
                    else if (flush1)
                        lookahead_allowed_to_cmd[1] <=  lookahead_allowed_to_cmd[2];
                    else if (cmd_is_valid[1] &&
                        (((!current_multicast_req && !proper_multicast_cmd1) && (current_bank_index != cmd1_bank_index)) || ((current_multicast_req || proper_multicast_cmd1) && (current_bank != cmd1_bank_addr)))
                        &&
                        (((!proper_multicast_cmd0 && !proper_multicast_cmd1) && (cmd0_bank_index != cmd1_bank_index)) || ((proper_multicast_cmd0 || proper_multicast_cmd1) && (cmd0_bank_addr != cmd1_bank_addr)))
                        )
                        lookahead_allowed_to_cmd[1]  <=  1'b1;
                    else
                        lookahead_allowed_to_cmd[1]  <=  1'b0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                lookahead_allowed_to_cmd[2]  <=  1'b0;
            else
                begin
                    if (fetch)
                        begin
                            if (flush3 || flush2 || flush1)
                                lookahead_allowed_to_cmd[2] <=  1'b0;
                            else
                                lookahead_allowed_to_cmd[2] <=  lookahead_allowed_to_cmd[3];
                        end
                    else if (flush3 || flush2)
                        lookahead_allowed_to_cmd[2] <=  1'b0;
                    else if (flush1)
                        lookahead_allowed_to_cmd[2] <=  lookahead_allowed_to_cmd[3];
                    else if (cmd_is_valid[2] &&
                        //(current_bank_index != cmd2_bank_index)
                        (((!current_multicast_req && !proper_multicast_cmd2) && (current_bank_index != cmd2_bank_index)) || ((current_multicast_req || proper_multicast_cmd2) && (current_bank != cmd2_bank_addr)))
                        &&
                        //(cmd0_bank_index != cmd2_bank_index)
                        (((!proper_multicast_cmd0 && !proper_multicast_cmd2) && (cmd0_bank_index != cmd2_bank_index)) || ((proper_multicast_cmd0 || proper_multicast_cmd2) && (cmd0_bank_addr != cmd2_bank_addr)))
                        &&
                        //(cmd1_bank_index != cmd2_bank_index)
                        (((!proper_multicast_cmd1 && !proper_multicast_cmd2) && (cmd1_bank_index != cmd2_bank_index)) || ((proper_multicast_cmd1 || proper_multicast_cmd2) && (cmd1_bank_addr != cmd2_bank_addr)))
                        )
                        lookahead_allowed_to_cmd[2]  <=  1'b1;
                    else
                        lookahead_allowed_to_cmd[2]  <=  1'b0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                lookahead_allowed_to_cmd[3]  <=  1'b0;
            else
                begin
                    if (fetch)
                        lookahead_allowed_to_cmd[3] <=  1'b0;
                    else if (flush3 || flush2 || flush1)
                        lookahead_allowed_to_cmd[3] <=  1'b0;
                    else if (cmd_is_valid[3] &&
                        //(current_bank_index != cmd3_bank_index)
                        (((!current_multicast_req && !proper_multicast_cmd3) && (current_bank_index != cmd3_bank_index)) || ((current_multicast_req || proper_multicast_cmd3) && (current_bank != cmd3_bank_addr)))
                        &&
                        //(cmd0_bank_index != cmd3_bank_index)
                        (((!proper_multicast_cmd0 && !proper_multicast_cmd3) && (cmd0_bank_index != cmd3_bank_index)) || ((proper_multicast_cmd0 || proper_multicast_cmd3) && (cmd0_bank_addr != cmd3_bank_addr)))
                        &&
                        //(cmd1_bank_index != cmd3_bank_index)
                        (((!proper_multicast_cmd1 && !proper_multicast_cmd3) && (cmd1_bank_index != cmd3_bank_index)) || ((proper_multicast_cmd1 || proper_multicast_cmd3) && (cmd1_bank_addr != cmd3_bank_addr)))
                        &&
                        //(cmd2_bank_index != cmd3_bank_index)
                        (((!proper_multicast_cmd2 && !proper_multicast_cmd3) && (cmd2_bank_index != cmd3_bank_index)) || ((proper_multicast_cmd2 || proper_multicast_cmd3) && (cmd2_bank_addr != cmd3_bank_addr)))
                        )
                        lookahead_allowed_to_cmd[3]  <=  1'b1;
                    else
                        lookahead_allowed_to_cmd[3]  <=  1'b0;
                end
        end
    
    // logic that decides to do auto auto precharge
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 6)
            begin
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_c  <=  1'b0;
                        //else
                        //    begin
                                // only check for another same bank in the queue
                                if (((!current_multicast_req && !proper_multicast_cmd0 && current_bank_index == cmd0_bank_index) || ((current_multicast_req || proper_multicast_cmd0) && current_bank == cmd0_bank_addr)) && cmd_is_valid[0])
                                    if (current_row == cmd0_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd1 && current_bank_index == cmd1_bank_index) || ((current_multicast_req || proper_multicast_cmd1) && current_bank == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (current_row == cmd1_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd2 && current_bank_index == cmd2_bank_index) || ((current_multicast_req || proper_multicast_cmd2) && current_bank == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (current_row == cmd2_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd3 && current_bank_index == cmd3_bank_index) || ((current_multicast_req || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (current_row == cmd3_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd4 && current_bank_index == cmd4_bank_index) || ((current_multicast_req || proper_multicast_cmd4) && current_bank == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (current_row == cmd4_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd5 && current_bank_index == cmd5_bank_index) || ((current_multicast_req || proper_multicast_cmd5) && current_bank == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (current_row == cmd5_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd6 && current_bank_index == cmd6_bank_index) || ((current_multicast_req || proper_multicast_cmd6) && current_bank == cmd6_bank_addr)) && cmd_is_valid[6])
                                    if (current_row == cmd6_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd7 && current_bank_index == cmd7_bank_index) || ((current_multicast_req || proper_multicast_cmd7) && current_bank == cmd7_bank_addr)) && cmd_is_valid[7])
                                    if (current_row == cmd7_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else
                                    auto_autopch_req_c  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_0  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd0 && !proper_multicast_cmd1 && cmd0_bank_index == cmd1_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd1) && cmd0_bank_index == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (cmd0_row_addr == cmd1_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd2 && cmd0_bank_index == cmd2_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd2) && cmd0_bank_index == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd0_row_addr == cmd2_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd3 && cmd0_bank_index == cmd3_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd3) && cmd0_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd0_row_addr == cmd3_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd4 && cmd0_bank_index == cmd4_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd4) && cmd0_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd0_row_addr == cmd4_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd5 && cmd0_bank_index == cmd5_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd5) && cmd0_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd0_row_addr == cmd5_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd6 && cmd0_bank_index == cmd6_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd6) && cmd0_bank_index == cmd6_bank_addr)) && cmd_is_valid[6])
                                    if (cmd0_row_addr == cmd6_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd7 && cmd0_bank_index == cmd7_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd7) && cmd0_bank_index == cmd7_bank_addr)) && cmd_is_valid[7])
                                    if (cmd0_row_addr == cmd7_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else
                                    auto_autopch_req_0  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_1  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd1 && !proper_multicast_cmd2 && cmd1_bank_index == cmd2_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd2) && cmd1_bank_index == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd1_row_addr == cmd2_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd3 && cmd1_bank_index == cmd3_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd3) && cmd1_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd1_row_addr == cmd3_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd4 && cmd1_bank_index == cmd4_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd4) && cmd1_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd1_row_addr == cmd4_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd5 && cmd1_bank_index == cmd5_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd5) && cmd1_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd1_row_addr == cmd5_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd6 && cmd1_bank_index == cmd6_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd6) && cmd1_bank_index == cmd6_bank_addr)) && cmd_is_valid[6])
                                    if (cmd1_row_addr == cmd6_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd7 && cmd1_bank_index == cmd7_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd7) && cmd1_bank_index == cmd7_bank_addr)) && cmd_is_valid[7])
                                    if (cmd1_row_addr == cmd7_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else
                                    auto_autopch_req_1  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_2  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd2 && !proper_multicast_cmd3 && cmd2_bank_index == cmd3_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd3) && cmd2_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd2_row_addr == cmd3_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd4 && cmd2_bank_index == cmd4_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd4) && cmd2_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd2_row_addr == cmd4_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd5 && cmd2_bank_index == cmd5_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd5) && cmd2_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd2_row_addr == cmd5_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd6 && cmd2_bank_index == cmd6_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd6) && cmd2_bank_index == cmd6_bank_addr)) && cmd_is_valid[6])
                                    if (cmd2_row_addr == cmd6_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd7 && cmd2_bank_index == cmd7_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd7) && cmd2_bank_index == cmd7_bank_addr)) && cmd_is_valid[7])
                                    if (cmd2_row_addr == cmd7_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else
                                    auto_autopch_req_2  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_3  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd3 && !proper_multicast_cmd4 && cmd3_bank_index == cmd4_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd4) && cmd3_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd3_row_addr == cmd4_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else if (((!proper_multicast_cmd3 && !proper_multicast_cmd5 && cmd3_bank_index == cmd5_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd5) && cmd3_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd3_row_addr == cmd5_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else if (((!proper_multicast_cmd3 && !proper_multicast_cmd6 && cmd3_bank_index == cmd6_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd6) && cmd3_bank_index == cmd6_bank_addr)) && cmd_is_valid[6])
                                    if (cmd3_row_addr == cmd6_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else if (((!proper_multicast_cmd3 && !proper_multicast_cmd7 && cmd3_bank_index == cmd7_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd7) && cmd3_bank_index == cmd7_bank_addr)) && cmd_is_valid[7])
                                    if (cmd3_row_addr == cmd7_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else
                                    auto_autopch_req_3  <=  1'b0;
                        //    end
                    end
                    
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            auto_autopch_req    <=  1'b0;
                        else
                            begin
                                if (enable_aap)
                                    begin
                                        if (fetch)
                                            if (flush3)
                                                auto_autopch_req    <=  auto_autopch_req_3;
                                            else if (flush2)
                                                auto_autopch_req    <=  auto_autopch_req_2;
                                            else if (flush1)
                                                auto_autopch_req    <=  auto_autopch_req_1;
                                            else
                                                auto_autopch_req    <=  auto_autopch_req_0;
                                        else
                                            auto_autopch_req    <=  auto_autopch_req_c;
                                    end
                                else
                                    auto_autopch_req    <=  1'b0;
                            end
                    end
            end
        else if (CTL_LOOK_AHEAD_DEPTH > 4)
            begin
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_c  <=  1'b0;
                        //else
                        //    begin
                                // only check for another same bank in the queue
                                if (((!current_multicast_req && !proper_multicast_cmd0 && current_bank_index == cmd0_bank_index) || ((current_multicast_req || proper_multicast_cmd0) && current_bank == cmd0_bank_addr)) && cmd_is_valid[0])
                                    if (current_row == cmd0_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd1 && current_bank_index == cmd1_bank_index) || ((current_multicast_req || proper_multicast_cmd1) && current_bank == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (current_row == cmd1_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd2 && current_bank_index == cmd2_bank_index) || ((current_multicast_req || proper_multicast_cmd2) && current_bank == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (current_row == cmd2_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd3 && current_bank_index == cmd3_bank_index) || ((current_multicast_req || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (current_row == cmd3_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd4 && current_bank_index == cmd4_bank_index) || ((current_multicast_req || proper_multicast_cmd4) && current_bank == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (current_row == cmd4_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd5 && current_bank_index == cmd5_bank_index) || ((current_multicast_req || proper_multicast_cmd5) && current_bank == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (current_row == cmd5_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else
                                    auto_autopch_req_c  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_0  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd0 && !proper_multicast_cmd1 && cmd0_bank_index == cmd1_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd1) && cmd0_bank_index == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (cmd0_row_addr == cmd1_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd2 && cmd0_bank_index == cmd2_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd2) && cmd0_bank_index == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd0_row_addr == cmd2_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd3 && cmd0_bank_index == cmd3_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd3) && cmd0_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd0_row_addr == cmd3_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd4 && cmd0_bank_index == cmd4_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd4) && cmd0_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd0_row_addr == cmd4_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd5 && cmd0_bank_index == cmd5_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd5) && cmd0_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd0_row_addr == cmd5_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else
                                    auto_autopch_req_0  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_1  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd1 && !proper_multicast_cmd2 && cmd1_bank_index == cmd2_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd2) && cmd1_bank_index == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd1_row_addr == cmd2_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd3 && cmd1_bank_index == cmd3_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd3) && cmd1_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd1_row_addr == cmd3_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd4 && cmd1_bank_index == cmd4_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd4) && cmd1_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd1_row_addr == cmd4_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd5 && cmd1_bank_index == cmd5_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd5) && cmd1_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd1_row_addr == cmd5_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else
                                    auto_autopch_req_1  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_2  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd2 && !proper_multicast_cmd3 && cmd2_bank_index == cmd3_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd3) && cmd2_bank_index == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd2_row_addr == cmd3_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd4 && cmd2_bank_index == cmd4_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd4) && cmd2_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd2_row_addr == cmd4_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else if (((!proper_multicast_cmd2 && !proper_multicast_cmd5 && cmd2_bank_index == cmd5_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd5) && cmd2_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd2_row_addr == cmd5_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else
                                    auto_autopch_req_2  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_3  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd3 && !proper_multicast_cmd4 && cmd3_bank_index == cmd4_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd4) && cmd3_bank_index == cmd4_bank_addr)) && cmd_is_valid[4])
                                    if (cmd3_row_addr == cmd4_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else if (((!proper_multicast_cmd3 && !proper_multicast_cmd5 && cmd3_bank_index == cmd5_bank_index) || ((proper_multicast_cmd3 || proper_multicast_cmd5) && cmd3_bank_index == cmd5_bank_addr)) && cmd_is_valid[5])
                                    if (cmd3_row_addr == cmd5_row_addr)
                                        auto_autopch_req_3  <=  1'b0;
                                    else
                                        auto_autopch_req_3  <=  1'b1;
                                else
                                    auto_autopch_req_3  <=  1'b0;
                        //    end
                    end
                    
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            auto_autopch_req    <=  1'b0;
                        else
                            begin
                                if (enable_aap)
                                    begin
                                        if (fetch)
                                            if (flush3)
                                                auto_autopch_req    <=  auto_autopch_req_3;
                                            else if (flush2)
                                                auto_autopch_req    <=  auto_autopch_req_2;
                                            else if (flush1)
                                                auto_autopch_req    <=  auto_autopch_req_1;
                                            else
                                                auto_autopch_req    <=  auto_autopch_req_0;
                                        else
                                            auto_autopch_req    <=  auto_autopch_req_c;
                                    end
                                else
                                    auto_autopch_req    <=  1'b0;
                            end
                    end
            end
        else // CTL_LOOK_AHEAD_DEPTH == 4
            begin
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_c  <=  1'b0;
                        //else
                        //    begin
                                // only check for another same bank in the queue
                                if (((!current_multicast_req && !proper_multicast_cmd0 && current_bank_index == cmd0_bank_index) || ((current_multicast_req || proper_multicast_cmd0) && current_bank == cmd0_bank_addr)) && cmd_is_valid[0])
                                    if (current_row == cmd0_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd1 && current_bank_index == cmd1_bank_index) || ((current_multicast_req || proper_multicast_cmd1) && current_bank == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (current_row == cmd1_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd2 && current_bank_index == cmd2_bank_index) || ((current_multicast_req || proper_multicast_cmd2) && current_bank == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (current_row == cmd2_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else if (((!current_multicast_req && !proper_multicast_cmd3 && current_bank_index == cmd3_bank_index) || ((current_multicast_req || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (current_row == cmd3_row_addr)
                                        auto_autopch_req_c  <=  1'b0;
                                    else
                                        auto_autopch_req_c  <=  1'b1;
                                else
                                    auto_autopch_req_c  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_0  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd0 && !proper_multicast_cmd1 && cmd0_bank_index == cmd1_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd1) && current_bank == cmd1_bank_addr)) && cmd_is_valid[1])
                                    if (cmd0_row_addr == cmd1_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd2 && cmd0_bank_index == cmd2_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd2) && current_bank == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd0_row_addr == cmd2_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else if (((!proper_multicast_cmd0 && !proper_multicast_cmd3 && cmd0_bank_index == cmd3_bank_index) || ((proper_multicast_cmd0 || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd0_row_addr == cmd3_row_addr)
                                        auto_autopch_req_0  <=  1'b0;
                                    else
                                        auto_autopch_req_0  <=  1'b1;
                                else
                                    auto_autopch_req_0  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_1  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd1 && !proper_multicast_cmd2 && cmd1_bank_index == cmd2_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd2) && current_bank == cmd2_bank_addr)) && cmd_is_valid[2])
                                    if (cmd1_row_addr == cmd2_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else if (((!proper_multicast_cmd1 && !proper_multicast_cmd3 && cmd1_bank_index == cmd3_bank_index) || ((proper_multicast_cmd1 || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd1_row_addr == cmd3_row_addr)
                                        auto_autopch_req_1  <=  1'b0;
                                    else
                                        auto_autopch_req_1  <=  1'b1;
                                else
                                    auto_autopch_req_1  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_2  <=  1'b0;
                        //else
                        //    begin
                                if (((!proper_multicast_cmd2 && !proper_multicast_cmd3 && cmd2_bank_index == cmd3_bank_index) || ((proper_multicast_cmd2 || proper_multicast_cmd3) && current_bank == cmd3_bank_addr)) && cmd_is_valid[3])
                                    if (cmd2_row_addr == cmd3_row_addr)
                                        auto_autopch_req_2  <=  1'b0;
                                    else
                                        auto_autopch_req_2  <=  1'b1;
                                else
                                    auto_autopch_req_2  <=  1'b0;
                        //    end
                    end
                    
                always @(*)
                    begin
                        //if (!ctl_reset_n)
                        //    auto_autopch_req_3  <=  1'b0;
                        //else
                            auto_autopch_req_3  <=  1'b0;
                    end
                    
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            auto_autopch_req    <=  1'b0;
                        else
                            begin
                                if (enable_aap)
                                    begin
                                        if (fetch)
                                            if (flush3)
                                                auto_autopch_req    <=  auto_autopch_req_3;
                                            else if (flush2)
                                                auto_autopch_req    <=  auto_autopch_req_2;
                                            else if (flush1)
                                                auto_autopch_req    <=  auto_autopch_req_1;
                                            else
                                                auto_autopch_req    <=  auto_autopch_req_0;
                                        else
                                            auto_autopch_req    <=  auto_autopch_req_c;
                                    end
                                else
                                    auto_autopch_req    <=  1'b0;
                            end
                    end
            end
    endgenerate
    
    // writepause support logic
    generate
        if (STATEMACHINE_TYPE == "FOUR_CK")
            begin
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            begin
                                flush_r     <=  1'b0;
                                flush_r2    <=  1'b0;
                            end
                        else
                            begin
                                flush_r     <=  1'b0;
                                flush_r2    <=  1'b0;
                                if ((flush1 || flush2 || flush3) && do_write && !do_ecc)
                                    begin
                                        if (combine_dqs_r == 3)
                                            flush_r2    <=  1'b1;
                                        else if (combine_dqs_r == 2)
                                            flush_r     <=  1'b1;
                                    end
                                else if (flush_r2)
                                    flush_r     <=  1'b1;
                            end
                    end
                
                assign decrement_with_flush = ((flush1 | flush2 | flush3) & do_write & ~do_ecc) | flush_r | flush_r2;
            end
        else
            begin
                assign decrement_with_flush = flush1 & do_write & ~do_ecc;
            end
    endgenerate
    assign decrement_normal = ((STATEMACHINE_TYPE == "FOUR_CK" && !stall_burstcount_r2 && simple_burstcount_r2 != 0 && burst_delay_r2 == 0) || (STATEMACHINE_TYPE == "TWO_CK" && !stall_burstcount && simple_burstcount != 0 && burst_delay == 0));
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                proper_beats_in_fifo <= 0;
            else if (write_req_to_wfifo)
                begin
                    if ((write_burst_length && decrement_normal) && decrement_with_flush)
                        proper_beats_in_fifo <= proper_beats_in_fifo - 1'b1;
                    else if ((write_burst_length && decrement_normal) || decrement_with_flush)
                        proper_beats_in_fifo <= proper_beats_in_fifo;
                    else
                        proper_beats_in_fifo <= proper_beats_in_fifo + 1'b1;
                end
            else if ((write_burst_length && decrement_normal) && decrement_with_flush)
                proper_beats_in_fifo <= proper_beats_in_fifo - 2'b10;
            else if ((write_burst_length && decrement_normal) || decrement_with_flush)
                proper_beats_in_fifo <= proper_beats_in_fifo - 1'b1;
        end
    
    always @(proper_beats_in_fifo)
        begin
            begin
                if (|proper_beats_in_fifo[WDATA_BEATS_WIDTH-1:3])
                    simple_beats_info <= 8;
                else
                    simple_beats_info <= {1'b0,proper_beats_in_fifo[2:0]};
            end
        end
    
    generate
        if (LOCAL_SIZE_WIDTH < 4)
            begin
                always @(current_burstcount_counter)
                    begin
                        simple_burstcount <= {{4-LOCAL_SIZE_WIDTH{1'b0}},current_burstcount_counter[LOCAL_SIZE_WIDTH-1:0]};
                    end
            end
        else
            begin
                always @(current_burstcount_counter)
                    begin
                        if (|current_burstcount_counter[LOCAL_SIZE_WIDTH-1:3])
                            simple_burstcount <= 8;
                        else
                            simple_burstcount <= {1'b0,current_burstcount_counter[2:0]};
                    end
            end
    endgenerate
    
    generate
        if (LOCAL_SIZE_WIDTH < 4)
            begin
                always @(current_burstcount_counter_r2)
                    begin
                        simple_burstcount_r2 <= {{4-LOCAL_SIZE_WIDTH{1'b0}},current_burstcount_counter_r2[LOCAL_SIZE_WIDTH-1:0]};
                    end
            end
        else
            begin
                always @(current_burstcount_counter_r2)
                    begin
                        if (|current_burstcount_counter_r2[LOCAL_SIZE_WIDTH-1:3])
                            simple_burstcount_r2 <= 8;
                        else
                            simple_burstcount_r2 <= {1'b0,current_burstcount_counter_r2[2:0]};
                    end
            end
    endgenerate
    
    always @(support_writepause, simple_beats_info, simple_burstcount, simple_burstcount_r2, burst_length, write_burst_length, fetch, fetch_r2)
        begin
            if (support_writepause)
                begin
                    if ((STATEMACHINE_TYPE == "FOUR_CK" && (simple_beats_info > 4 || (!write_burst_length && simple_beats_info == 4))) || (STATEMACHINE_TYPE == "TWO_CK" && (simple_beats_info > 2 || (!write_burst_length && simple_beats_info == 2))))
                        enough_data_to_write <= 1'b1;
                    else if (STATEMACHINE_TYPE == "FOUR_CK" && simple_beats_info >= simple_burstcount_r2 && !fetch_r2)
                        enough_data_to_write <= 1'b1;
                    else if (STATEMACHINE_TYPE == "TWO_CK" && simple_beats_info >= simple_burstcount && !fetch && simple_beats_info != 0)
                        enough_data_to_write <= 1'b1;
                    else
                        enough_data_to_write <= 1'b0;
                end
            else
                enough_data_to_write <= 1'b1;
        end
    
    //ecc partial wdata tracking
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                partial_data_location <= 0;
            else
                begin
                    if (write_req_to_wfifo)
                        begin
                            if ((write_burst_length && decrement_normal) && decrement_with_flush)
                                partial_data_location <= partial_data_location - 1'b1;
                            else if ((write_burst_length && decrement_normal) || decrement_with_flush)
                                partial_data_location <= partial_data_location;
                            else
                                partial_data_location <= partial_data_location + 1'b1;
                        end
                    else if ((write_burst_length && decrement_normal) && decrement_with_flush)
                        partial_data_location <= partial_data_location - 2'b10;
                    else if ((write_burst_length && decrement_normal) || decrement_with_flush)
                        partial_data_location <= partial_data_location - 1'b1;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                partial_data_pipe <= 0;
            else
                begin
                    if (write_req_to_wfifo)
                        partial_data_pipe[partial_data_location] = wdata_is_partial;
                    
                    if ((write_burst_length && decrement_normal) && decrement_with_flush)
                        partial_data_pipe <= {2'b00,partial_data_pipe[255:2]};
                    else if ((write_burst_length && decrement_normal) || decrement_with_flush)
                        partial_data_pipe <= {1'b0,partial_data_pipe[255:1]};
                end
        end
    
    assign  short_partial_data_pipe = partial_data_pipe[4:0];
    
    //partial write warning logic
    always @(*)
        begin
            //if (state == DO2)
            //    begin
                    if (STATEMACHINE_TYPE == "TWO_CK")
                        begin
                            if (simple_burstcount == 1)
                                partial_write <= short_partial_data_pipe[0];
                            else
                                partial_write <= |short_partial_data_pipe[1:0];
                        end
                    else
                        begin
                            if (fetch_r2)
                                begin
                                    if (write_burst_length)
                                        begin
                                            if (current_burstcount_counter_r + combine_dqs == 1)
                                                partial_write <= short_partial_data_pipe[1];
                                            else if (current_burstcount_counter_r + combine_dqs == 2)
                                                partial_write <= |short_partial_data_pipe[2:1];
                                            else if (current_burstcount_counter_r + combine_dqs == 3)
                                                partial_write <= |short_partial_data_pipe[3:1];
                                            else
                                                partial_write <= |short_partial_data_pipe[4:1];
                                        end
                                    else
                                        begin
                                            if (current_burstcount_counter_r + combine_dqs == 1)
                                                partial_write <= short_partial_data_pipe[0];
                                            else if (current_burstcount_counter_r + combine_dqs == 2)
                                                partial_write <= |short_partial_data_pipe[1:0];
                                            else if (current_burstcount_counter_r + combine_dqs == 3)
                                                partial_write <= |short_partial_data_pipe[2:0];
                                            else
                                                partial_write <= |short_partial_data_pipe[3:0];
                                        end
                                end
                            else
                                begin
                                    if (simple_burstcount_r2 + combine_dqs_r == 1)
                                        partial_write <= short_partial_data_pipe[0];
                                    else if (simple_burstcount_r2 + combine_dqs_r == 2)
                                        partial_write <= |short_partial_data_pipe[1:0];
                                    else if (simple_burstcount_r2 + combine_dqs_r == 3)
                                        partial_write <= |short_partial_data_pipe[2:0];
                                    else
                                        partial_write <= |short_partial_data_pipe[3:0];
                                end
                        end
            //    end
        end
    
    //register local_self_rfsh_req
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_self_rfsh_req   <=  1'b0;
                    self_rfsh_chip      <=  0;
                end
            else
                begin
                    int_self_rfsh_req   <=  local_self_rfsh_req;
                    self_rfsh_chip      <=  local_self_rfsh_chip;
                end
        end

    //generate *_chip_ok signals by checking can_*[chip], only when for_chip[chip] is 1   
    generate
        genvar chip;
        wire [(MEM_IF_CS_WIDTH-1):0] for_chip_and_can_precharge_all_is_same;
        wire [(MEM_IF_CS_WIDTH-1):0] for_chip_and_can_refresh_is_same;
        wire [(MEM_IF_CS_WIDTH-1):0] for_chip_and_can_self_rfsh_is_same;
        for (chip = 0; chip < MEM_IF_CS_WIDTH; chip = chip + 1)
        begin : gen_chip_ok
            // check can_* only for chips that we'd like to precharge_all to, ^~ is XNOR
            assign for_chip_and_can_precharge_all_is_same[chip] = ( for_chip[chip] & can_precharge_all[chip] ) ^~ for_chip[chip];
            assign for_chip_and_can_refresh_is_same[chip] = ( for_chip[chip] & can_refresh[chip] ) ^~ for_chip[chip];
            assign for_chip_and_can_self_rfsh_is_same[chip] = ( for_chip[chip] & can_self_rfsh[chip] ) ^~ for_chip[chip];
        end

        assign precharge_all_chip_ok = &for_chip_and_can_precharge_all_is_same;
        assign refresh_chip_ok = &for_chip_and_can_refresh_is_same;
        assign self_rfsh_chip_ok = &for_chip_and_can_self_rfsh_is_same;

    endgenerate

    // DDR3 regdimm support
    // regdimm_enable comes from alt_ddrx_csr, 
    //      1 if CTL_CSR_ENABLED is 0
    //      0 or 1, if CTL_CSR_ENABLED is 1

    generate
        if ( ( (CTL_CSR_ENABLED == 1) || (CTL_REGDIMM_ENABLED == 1) ) && (MEM_TYPE == "DDR3")) begin
            
            if (MEM_IF_CS_WIDTH == 1) 
            begin

                assign for_chip_mask = 1'b1;

            end
            else if (MEM_IF_CS_WIDTH == 2) 
            begin

                always @ (*)
                begin 
                    if (regdimm_enable)
                    begin
                        if (for_chip[0]) begin
                            for_chip_mask_gen = 2'b01;
                        end
                        else if (for_chip[1]) begin
                            for_chip_mask_gen = 2'b10;
                        end
                        else begin
                            for_chip_mask_gen = 2'b00;
                        end
                    end
                    else 
                        for_chip_mask_gen = {MEM_IF_CS_WIDTH{1'b1}};
                end

                assign for_chip_mask = for_chip_mask_gen;

            end
            else if (MEM_IF_CS_WIDTH == 4)
            begin

                always @ (*)
                begin
                    if (regdimm_enable)
                    begin
                        if (for_chip[0] | for_chip[3]) begin
                            for_chip_mask_gen = 4'b1001;
                        end
                        else if (for_chip[1] | for_chip[2]) begin
                            for_chip_mask_gen = 4'b0110;
                        end
                        else begin
                            for_chip_mask_gen = 4'b0000;
                        end
                    end
                    else 
                        for_chip_mask_gen = {MEM_IF_CS_WIDTH{1'b1}};
                end

                assign for_chip_mask = for_chip_mask_gen;

            end
            else if (MEM_IF_CS_WIDTH == 8)
            begin

                always @ (*)
                begin
                    if (regdimm_enable)
                    begin
                        if (for_chip[0] | for_chip[3] | for_chip[4] | for_chip[7]) begin
                            for_chip_mask_gen = 8'b10011001;
                        end
                        else if (for_chip[1] | for_chip[2] | for_chip[5] | for_chip[6]) begin
                            for_chip_mask_gen = 8'b01100110;
                        end
                        else begin
                            for_chip_mask_gen = 8'b00000000;
                        end
                    end
                    else 
                        for_chip_mask_gen = {MEM_IF_CS_WIDTH{1'b1}};
                end

                assign for_chip_mask = for_chip_mask_gen;

            end
            else
            begin
                //$write(" --- Error! MEM_IF_CS_WIDTH is greater that expected --- \n");
                //$stop();
            end

        end
        else
        begin

            assign for_chip_mask = {MEM_IF_CS_WIDTH{1'b1}};

        end
    endgenerate

    assign for_chip_current = for_chip & for_chip_mask;
    assign for_chip_next = for_chip & ~for_chip_mask;

    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    fetch_r     <=  1'b0;
                    fetch_r2    <=  1'b0;
                end
            else
                begin
                    fetch_r     <=  fetch | ecc_fetch | ecc_dummy_fetch | ecc_internal_fetch;
                    fetch_r2    <=  fetch_r;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    stall_burstcount_r  <=  1'b0;
                    stall_burstcount_r2 <=  1'b0;
                end
            else
                begin
                    stall_burstcount_r  <=  stall_burstcount;
                    stall_burstcount_r2 <=  stall_burstcount_r;
                end
        end
    
    //fmax reason, seq_0 is registered
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                cmd0_is_sequential_reg  <=  1'b0;
            else
                if (fetch)
                    begin
                        if (flush3)
                            cmd0_is_sequential_reg  <=  cmd4_is_sequential;
                        else if (flush2)
                            cmd0_is_sequential_reg  <=  cmd3_is_sequential;
                        else if (flush1)
                            cmd0_is_sequential_reg  <=  cmd2_is_sequential;
                        else
                            cmd0_is_sequential_reg  <=  cmd1_is_sequential;
                    end
                //flush only no fetch
                else if (flush3 || flush2 || flush1)
                    cmd0_is_sequential_reg  <=  1'b0;
                //else
                else
                    cmd0_is_sequential_reg  <=  cmd0_is_sequential;
        end
    
    //pull data into current register on fetch
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    current_read            <=  1'b0;
                    current_write           <=  1'b0;
                    current_autopch_req     <=  1'b0;
                    current_multicast_req   <=  1'b0;
                    current_diff_cs         <=  1'b0;
                    current_is_ecc          <=  1'b0;
                    current_chip            <=  {MEM_IF_CHIP_BITS{1'b0}};
                    current_bank            <=  {MEM_IF_BA_WIDTH{1'b0}};
                    current_row             <=  {MEM_IF_ROW_WIDTH{1'b0}};
                    current_col             <=  {MEM_IF_COL_WIDTH{1'b0}};
                    burst_delay             <=  0;
                    chip_incremented        <=  1'b0;
                    bank_incremented        <=  1'b0;
                    row_incremented         <=  1'b0;
                    combine_allowed         <=  2'b11;
                end
            else
                if (fetch)
                    begin
                        chip_incremented    <=  1'b0;
                        bank_incremented    <=  1'b0;
                        row_incremented     <=  1'b0;
                        current_is_ecc      <=  1'b0;
                        combine_allowed     <=  2'b11;
                        if (flush3)
                            begin
                                current_read            <=  cmd3_is_a_read;
                                current_write           <=  cmd3_is_a_write;
                                current_autopch_req     <=  cmd3_autopch_req;
                                current_multicast_req   <=  proper_multicast_cmd3;
                                current_diff_cs         <=  cmd3_diff_cs;
                                current_chip            <=  cmd3_chip_addr;
                                current_bank            <=  cmd3_bank_addr;
                                current_row             <=  cmd3_row_addr;
                                current_col             <=  cmd3_col_addr;
                                if (DWIDTH_RATIO == 2)
                                    burst_delay[1:0]    <=  cmd3_col_addr[2:1];
                                else
                                    burst_delay[0]      <=  cmd3_col_addr[2];
                            end
                        else if (flush2)
                            begin
                                current_read            <=  cmd2_is_a_read;
                                current_write           <=  cmd2_is_a_write;
                                current_autopch_req     <=  cmd2_autopch_req;
                                current_multicast_req   <=  proper_multicast_cmd2;
                                current_diff_cs         <=  cmd2_diff_cs;
                                current_chip            <=  cmd2_chip_addr;
                                current_bank            <=  cmd2_bank_addr;
                                current_row             <=  cmd2_row_addr;
                                current_col             <=  cmd2_col_addr;
                                if (DWIDTH_RATIO == 2)
                                    burst_delay[1:0]    <=  cmd2_col_addr[2:1];
                                else
                                    burst_delay[0]      <=  cmd2_col_addr[2];
                            end
                        else if (flush1)
                            begin
                                current_read            <=  cmd1_is_a_read;
                                current_write           <=  cmd1_is_a_write;
                                current_autopch_req     <=  cmd1_autopch_req;
                                current_multicast_req   <=  proper_multicast_cmd1;
                                current_diff_cs         <=  cmd1_diff_cs;
                                current_chip            <=  cmd1_chip_addr;
                                current_bank            <=  cmd1_bank_addr;
                                current_row             <=  cmd1_row_addr;
                                current_col             <=  cmd1_col_addr;
                                if (DWIDTH_RATIO == 2)
                                    begin
                                        if (MEMORY_BURSTLENGTH == 8)
                                            burst_delay[1:0]    <=  cmd1_col_addr[2:1];
                                        else
                                            burst_delay[0]      <=  cmd1_col_addr[1];
                                    end
                                else
                                    burst_delay[0]      <=  cmd1_col_addr[2];
                            end
                        else
                            begin
                                current_read            <=  cmd0_is_a_read;
                                current_write           <=  cmd0_is_a_write;
                                current_autopch_req     <=  cmd0_autopch_req;
                                current_multicast_req   <=  proper_multicast_cmd0;
                                current_diff_cs         <=  cmd0_diff_cs;
                                current_chip            <=  cmd0_chip_addr;
                                current_bank            <=  cmd0_bank_addr;
                                current_row             <=  cmd0_row_addr;
                                current_col             <=  cmd0_col_addr;
                                if (DWIDTH_RATIO == 2)
                                    begin
                                        if (MEMORY_BURSTLENGTH == 8)
                                            burst_delay[1:0]    <=  cmd0_col_addr[2:1];
                                        else
                                            burst_delay[0]      <=  cmd0_col_addr[1];
                                    end
                                else
                                    burst_delay[0]      <=  cmd0_col_addr[2];
                            end
                    end
                else if (ecc_internal_fetch)
                    begin
                        current_read            <=  1'b0;
                        current_write           <=  1'b1;
                        current_autopch_req     <=  current_copy_autopch_req;
                        current_multicast_req   <=  current_copy_multicast_req;
                        current_diff_cs         <=  current_copy_diff_cs;
                        current_chip            <=  current_copy_chip;
                        current_bank            <=  current_copy_bank;
                        current_row             <=  current_copy_row;
                        current_col             <=  current_copy_col;
                        burst_delay             <=  current_copy_burst_delay;
                        combine_allowed         <=  combine_happened;
                    end
                else if (ecc_fetch || ecc_dummy_fetch)
                    begin
                        if (ecc_fetch)
                            begin
                                current_read            <=  1'b1;
                                current_write           <=  1'b0;
                                current_chip            <=  ecc_error_chip_addr;
                                current_bank            <=  ecc_error_bank_addr;
                                current_row             <=  ecc_error_row_addr;
                                current_col             <=  ecc_error_col_addr;
                            end
                        else
                            begin
                                current_read            <=  1'b0;
                                current_write           <=  1'b1;
                            end
                        current_autopch_req     <=  1'b0;
                        current_multicast_req   <=  1'b0;
                        current_diff_cs         <=  1'b1;
                        current_is_ecc          <=  1'b1;
                        burst_delay             <=  0;
                        combine_allowed         <=  2'b11;
                    end
                else
                    begin
                        current_diff_cs     <=  chip_incremented;
                        chip_incremented    <=  1'b0;
                        bank_incremented    <=  1'b0;
                        row_incremented     <=  1'b0;
                        if (state == READWRITE && !(do_partial && do_ecc) && ((STATEMACHINE_TYPE == "FOUR_CK" && !can_fetch) || (STATEMACHINE_TYPE == "TWO_CK" && ((current_burstcount_counter + burst_delay > 2) || (burst_delay == 1 && current_burstcount_counter == 1 && cmd0_is_sequential_reg && cmd0_burstcount == 1)))))
                            begin
                                if ((MEMORY_BURSTLENGTH == 8 && current_col[MEM_IF_COL_WIDTH-1:3] == max_col_from_csr[MEM_IF_COL_WIDTH-1:3]) || (MEMORY_BURSTLENGTH == 4 && current_col[MEM_IF_COL_WIDTH-1:2] == max_col_from_csr[MEM_IF_COL_WIDTH-1:2]))
                                    begin
                                        if (MEMORY_BURSTLENGTH == 8)
                                            current_col[MEM_IF_COL_WIDTH-1:3]   <=  0;
                                        else
                                            current_col[MEM_IF_COL_WIDTH-1:2]   <=  0;
                                        
                                        if (addr_order == 1) // 1 is chipbankrowcol
                                            begin
                                                if (current_row == max_row_from_csr)
                                                    begin
                                                        current_row <=  0;
                                                        if (current_bank == max_bank_from_csr)
                                                            begin
                                                                current_bank <=  0;
                                                                if (current_chip == max_chip_from_csr)
                                                                    begin
                                                                        $write(" --- Warning! Reached end of memory in long burst! --- \n");
                                                                        chip_incremented <= 1'b1;
                                                                        current_chip    <=  0;
                                                                    end
                                                                else
                                                                    begin
                                                                        chip_incremented <= 1'b1;
                                                                        current_chip <=  current_chip + 1'b1;
                                                                    end
                                                            end
                                                        else
                                                            begin
                                                                bank_incremented <= 1'b1;
                                                                current_bank <=  current_bank + 1'b1;
                                                            end
                                                    end
                                                else
                                                    begin
                                                        row_incremented <=  1'b1;
                                                        current_row <=  current_row + 1'b1;
                                                    end
                                            end
                                        else // 0 is chiprowbankcol
                                            begin
                                                if (current_bank == max_bank_from_csr)
                                                    begin
                                                        current_bank <=  0;
                                                        if (current_row == max_row_from_csr)
                                                            begin
                                                                current_row <=  0;
                                                                if (current_chip == max_chip_from_csr)
                                                                    begin
                                                                        $write(" --- Warning! Reached end of memory in long burst! --- \n");
                                                                        chip_incremented <= 1'b1;
                                                                        current_chip    <=  0;
                                                                    end
                                                                else
                                                                    begin
                                                                        chip_incremented <= 1'b1;
                                                                        current_chip <=  current_chip + 1'b1;
                                                                    end
                                                            end
                                                        else
                                                            begin
                                                                row_incremented <=  1'b1;
                                                                current_row <=  current_row + 1'b1;
                                                            end
                                                    end
                                                else
                                                    begin
                                                        bank_incremented <= 1'b1;
                                                        current_bank <=  current_bank + 1'b1;
                                                    end
                                            end
                                    end
                                else
                                    begin
                                        if (MEMORY_BURSTLENGTH == 8)
                                            current_col <=  current_col + 4'b1000;
                                        else
                                            current_col <=  current_col + 3'b100;
                                    end
                            end
                        
                        // half rate uses burst_delay unlike full rate
                        if (burst_delay > 0 && !stall_burstcount && burst_length)
                            burst_delay <=  burst_delay - 1'b1;
                    end
        end
    
    // copy current operation attribute when partial write operation detected (for ECC)
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    current_copy_read                   <=  1'b0;
                    current_copy_write                  <=  1'b0;
                    current_copy_autopch_req            <=  1'b0;
                    current_copy_multicast_req          <=  1'b0;
                    current_copy_diff_cs                <=  1'b0;
                    current_copy_burstcount_counter     <=  0;
                    current_copy_chip                   <=  {MEM_IF_CHIP_BITS{1'b0}};
                    current_copy_bank                   <=  {MEM_IF_BA_WIDTH{1'b0}};
                    current_copy_row                    <=  {MEM_IF_ROW_WIDTH{1'b0}};
                    current_copy_col                    <=  {MEM_IF_COL_WIDTH{1'b0}};
                    current_copy_burst_delay            <=  0;
                    combine_happened                    <=  0;
                end
            else
                if (state == READWRITE && do_partial)
                    begin
                        current_copy_read           <=  current_read;
                        current_copy_write          <=  current_write;
                        current_copy_autopch_req    <=  current_autopch_req;
                        current_copy_multicast_req  <=  current_multicast_req;
                        current_copy_diff_cs        <=  current_diff_cs;
                        if (STATEMACHINE_TYPE == "FOUR_CK")
                            begin
                                current_copy_burstcount_counter  <=  current_burstcount_counter_r2;
                                current_copy_burst_delay         <=  burst_delay_r2;
                            end
                        else
                            begin
                                current_copy_burstcount_counter  <=  current_burstcount_counter;
                                current_copy_burst_delay         <=  burst_delay;
                            end
                        current_copy_chip           <=  current_chip;
                        current_copy_bank           <=  current_bank;
                        current_copy_row            <=  current_row;
                        current_copy_col            <=  current_col;
                        combine_happened            <=  combine_dqs_r;
                        
                    end
        end
    
    // burstcount also loaded on fetch, decrements each cycle
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                current_burstcount_counter   <=  0;
            else if (fetch)
                if (flush3)
                    current_burstcount_counter   <=  cmd3_burstcount;
                else if (flush2)
                    current_burstcount_counter   <=  cmd2_burstcount;
                else if (flush1)
                    current_burstcount_counter   <=  cmd1_burstcount;
                else
                    current_burstcount_counter   <=  cmd0_burstcount;
            else if (ecc_internal_fetch)
                current_burstcount_counter  <=  current_copy_burstcount_counter;
            else if (ecc_fetch || ecc_dummy_fetch)
                begin
                    if (STATEMACHINE_TYPE == "FOUR_CK")
                        current_burstcount_counter  <=  4;
                    else
                        current_burstcount_counter  <=  2;
                end
            else if (current_burstcount_counter != 0 && !stall_burstcount && burst_length && burst_delay == 0)
                current_burstcount_counter <= current_burstcount_counter - 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                current_burstcount_counter_r   <=  0;
            else if (fetch_r)
                current_burstcount_counter_r   <=  current_burstcount_counter;
        end
    
    // this burscount is for full rate
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                current_burstcount_counter_r2   <=  0;
            else if (fetch_r2)
                current_burstcount_counter_r2   <=  current_burstcount_counter_r;
            else if (current_burstcount_counter_r2 != 0 && !stall_burstcount_r2 && burst_length && burst_delay_r2 == 0)
                current_burstcount_counter_r2 <= current_burstcount_counter_r2 - 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                burst_delay_r   <=  0;
            else if (fetch_r)
                burst_delay_r   <=  burst_delay;
        end
    
    // burst delay for full rate
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                burst_delay_r2   <=  0;
            else if (fetch_r2)
                begin
                    if (sense_burst_chop[1])
                        burst_delay_r2   <=  burst_delay_r - 2'b10;
                    else
                        burst_delay_r2   <=  burst_delay_r;
                end
            else if (burst_delay_r2 != 0 && burst_length)
                burst_delay_r2 <= burst_delay_r2 - 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                combine_dqs_r   <=  0;
            else if (fetch_r2)
                combine_dqs_r   <=  combine_dqs;
            else if (combine_dqs_r > 0 && current_burstcount_counter_r2 == 0 && burst_length)
                combine_dqs_r   <=  combine_dqs_r - 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                bl_counter   <=  0;
            else
                if (start_burst && STATEMACHINE_TYPE == "FOUR_CK")
                    bl_counter    <=  1;
                else if (bl_counter == 2)
                    bl_counter    <=  0;
                else if (bl_counter > 0)
                    bl_counter    <=  bl_counter + 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                start_burst_r   <=  0;
            else
                start_burst_r   <=  start_burst;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                burst_length_gen         <=  1'b0;
            else
                if (start_burst)
                    burst_length_gen         <=  1'b1;
                else if (bl_counter > 0)
                    burst_length_gen         <=  1'b1;
                else
                    burst_length_gen         <=  1'b0;
        end
    
    assign burst_length = start_burst | start_burst_r | burst_length_gen;
    
    // write burst length generation start
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                bl_write_counter   <=  0;
            else
                if (start_burst && current_write && !do_ecc && STATEMACHINE_TYPE == "FOUR_CK")
                    bl_write_counter    <=  1;
                else if (bl_write_counter == 2)
                    bl_write_counter    <=  0;
                else if (bl_write_counter > 0)
                    bl_write_counter    <=  bl_write_counter + 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                start_write_burst_r   <=  0;
            else
                start_write_burst_r   <=  start_burst & current_write & ~do_ecc;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                write_burst_length_gen         <=  1'b0;
            else
                if (start_burst && current_write && !do_ecc)
                    write_burst_length_gen         <=  1'b1;
                else if (bl_write_counter > 0)
                    write_burst_length_gen         <=  1'b1;
                else
                    write_burst_length_gen         <=  1'b0;
        end
    
    assign write_burst_length = (start_burst & current_write & ~do_ecc) | start_write_burst_r | write_burst_length_gen;
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                new_gen_rdwr_data_valid   <=  1'b0;
            else
                if (STATEMACHINE_TYPE == "FOUR_CK" && (burst_delay_r2 == 0 && burst_length && (current_burstcount_counter_r2 > 0 || combine_dqs_r > 0)))
                    new_gen_rdwr_data_valid <=  1'b1;
                // this logic is for burst chop only, half rate always have only one valid data
                else if (MEM_TYPE == "DDR3" && STATEMACHINE_TYPE == "TWO_CK" && state == READWRITE && (burst_delay == 1 || (current_burstcount_counter == 1 && (!cmd0_is_sequential_reg || (cmd0_is_sequential_reg && cmd0_burstcount != 1)))) )
                    new_gen_rdwr_data_valid <=  1'b1;
                else if (STATEMACHINE_TYPE == "TWO_CK" && ((burst_delay == 0 && burst_length && current_burstcount_counter > 0) || flush1))
                    new_gen_rdwr_data_valid <=  1'b1;
                else
                    new_gen_rdwr_data_valid <=  1'b0;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin : FSM
    if (!ctl_reset_n)
        begin
            state <= INIT;
            to_chip <= 0;
            to_addr <= 0;
            fetch <= 1'b0;
            do_write <= 1'b0;
            do_read <= 1'b0;
            do_burst_chop <= 1'b0;
            do_auto_precharge <= 1'b0;
            do_activate <= 1'b0;
            do_precharge <= 1'b0;
            do_refresh <= 1'b0;
            do_power_down <= 1'b0;
            do_self_rfsh <= 1'b0;
            //do_lmr <= 1'b0;
            do_precharge_all <= 1'b0;
            do_zqcal <= 1'b0;
            stall_burstcount <= 1'b0;
            combine_req <= 2'b00;
            combine_dqs <= 0;
            sense_burst_chop <= 0;
            can_fetch <= 1'b1;
            flush1 <= 1'b0;
            flush2 <= 1'b0;
            flush3 <= 1'b0;
            just_did_activate <= 1'b0;
            just_did_precharge_to_cmd <= 0;
            start_burst <= 1'b0;
            do_ecc <= 1'b0;
            do_partial <= 1'b0;
            ecc_fetch <= 1'b0;
            ecc_dummy_fetch <= 1'b0;
            ecc_internal_fetch <= 1'b0;
            partial_write_read <= 1'b0;
            is_diff_chip <= 1'b0;
            is_diff_chip_r <= 1'b0;
            longer_than_1_req <= 1'b0;
            from_fetch_state <= 1'b0;
            for_chip_refresh_req <= 1'b0;
            for_chip_self_rfsh_req <= 1'b0;
            for_chip_power_down_req <= 1'b0;
            for_chip <= 0;
            for_chip_saved <= 0;
            int_refresh_ack <= 0;
            for_chip_self_rfsh_saved <= 0;
            zq_cal_req_r <= 0;
        end
    else
        case(state)
            INIT :
                if (ctl_cal_success == 1'b1)
                    begin
                        state <= FETCH;
                    end
                else
                    begin
                        state <= INIT;
                    end
            FETCH :
                begin
                    do_write <= 1'b0;
                    do_read <= 1'b0;
                    do_burst_chop <= 1'b0;
                    do_auto_precharge <= 1'b0;
                    do_precharge_all <= 1'b0;
                    do_refresh <= 1'b0;
                    stall_burstcount <= 1'b0;
                    combine_req <= 2'b00;
                    flush1 <= 1'b0;
                    flush2 <= 1'b0;
                    flush3 <= 1'b0;
                    from_fetch_state <= 1'b1;
                    int_refresh_ack <= 0;

                    if (fetch || ecc_internal_fetch) // refresh req comes after state machine decided to do fetch
                        begin
                            if (STATEMACHINE_TYPE == "FOUR_CK")
                                state <= DO1;
                            else // this shouldn't happen
                                begin
                                    state <= DO2;
                                    $write(" --- Error! fetch is high in fetch state, shudnt happen in half rate --- \n");
                                    $stop;
                                end
                            fetch <= 1'b0;
                            ecc_internal_fetch <= 1'b0;
                        end
                    else if (int_refresh_req && !do_refresh)
                        begin
                            stall_burstcount <= 1'b1;
                            if (&all_banks_closed)
                                state <= REFRESH;
                            else
                                state <= PCHALL;

                            for_chip <= refresh_chip;
                            for_chip_saved <= refresh_chip;
                            for_chip_refresh_req <= 1'b1;
                            for_chip_self_rfsh_req <= 1'b0;
                            for_chip_power_down_req <= 1'b0;

                        end
                    else if (do_partial && partial_write_read)
                        begin
                            ecc_internal_fetch <= 1'b1;
                            if (STATEMACHINE_TYPE == "TWO_CK")
                                state <= DO2;
                        end
                    else if (STATEMACHINE_TYPE == "FOUR_CK" && !can_fetch) // full rate only
                        begin
                            can_fetch <= 1'b1;
                            state <= DO1;
                        end
                    // should be here after refresh, if burst is incomplete then go to DO2
                    // burst_length makes sure that this is not fetch state after only rd/wr
                    else if (STATEMACHINE_TYPE == "TWO_CK" && ((burst_length && current_burstcount_counter > 1) || (!burst_length && current_burstcount_counter != 0))) // half rate only
                        begin
                            state <= DO2;
                        end
                    else if (do_ecc)
                        begin
                            if (current_write)
                                do_ecc <= 1'b0;
                            else
                                begin
                                    ecc_dummy_fetch <= 1'b1;
                                    state <= ECC_DO2;
                                end
                        end
                    else if (int_ecc_req)
                        begin
                            do_ecc <= 1'b1;
                            ecc_fetch <= 1'b1;
                            state <= ECC_DO2;
                        end
                    else if (int_self_rfsh_req)
                        begin
                            if (&all_banks_closed)
                                state <= REFRESH;
                            else
                                state <= PCHALL;

                            for_chip <= self_rfsh_chip;
                            for_chip_saved <= self_rfsh_chip;
                            for_chip_refresh_req <= 1'b0;
                            for_chip_self_rfsh_req <= 1'b1;
                            for_chip_power_down_req <= 1'b0;

                        end
                    else if (int_power_down_req)
                        begin
                            if (&all_banks_closed)
                                state <= PDOWN;
                            else
                                state <= PCHALL;

                            for_chip <= power_down_chip;
                            for_chip_saved <= power_down_chip;
                            for_chip_refresh_req <= 1'b0;
                            for_chip_self_rfsh_req <= 1'b0;
                            for_chip_power_down_req <= 1'b1;

                        end
                    else if ((!cmd_fifo_empty || cmd_fifo_wren) && !(flush1 || flush2 || flush3)) // not empty so fetch!
                        begin
                            fetch <= 1'b1;
                            if (STATEMACHINE_TYPE == "TWO_CK")
                                state <= DO2;
                        end
                    else
                        begin
                            fetch <= 1'b0;
                        end
                    
                    if (do_partial && !partial_write_read)
                        do_partial <= 1'b0;
                    
                    if (simple_burstcount > 1)
                        longer_than_1_req <= 1'b1;
                end
            DO1 : // full rate only state, one clock cycle state
                begin
                    fetch <= 1'b0;
                    state <= DO2;
                    can_fetch <= 1'b1;
                    is_diff_chip <= current_diff_cs & burst_length;
                    
                    if (do_partial && !partial_write_read)
                        do_partial <= 1'b0;
                    
                    if (STATEMACHINE_TYPE == "TWO_CK")
                        begin
                            $write(" --- ERROR,  ERROR,  ERROR  DO1 state in half rate --- \n");
                            $write(" --- ERROR!, ERROR!, ERROR! DO1 state in half rate --- \n");
                            $stop;
                        end
                    
                    // full rate seq only evaluated here
                    // max_dqs_combine_allowed
                    // confirmed with Siow Hoay that we don't have to check valid signal along with sequential
                    if (max_dqs_combine_allowed == 3 && cmd0_burstcount < 4 && cmd0_is_sequential && fetch_r)
                        begin
                            // if complete burst or incomplete but no more to combine, combine 1
                            // or if combining next is too long
                            if (cmd0_burstcount == 3 || (cmd0_burstcount < 3 && !cmd1_is_sequential) || (cmd0_burst_til_cmd1 > 3 && cmd1_is_sequential))
                                begin
                                    combine_req <= 1;
                                    combine_dqs <= cmd0_burstcount;
                                end
                            // if complete burst or incomplete but no more to combine, combine 2
                            // or if combining next is too long
                            else if (cmd0_burst_til_cmd1 == 3 || (cmd0_burst_til_cmd1 <= 3 && !cmd2_is_sequential) || (cmd0_burst_til_cmd2 > 3 && cmd2_is_sequential))
                                begin
                                    combine_req <= 2;
                                    combine_dqs <= cmd0_burstcount + cmd1_burstcount;
                                end
                            // can only combine 3 if complete burst
                            else// if (current_burst_til_cmd2 == 4)
                                begin
                                    combine_req <= 3;
                                    combine_dqs <= 3;
                                end
                        end
                    else if (max_dqs_combine_allowed == 2 && cmd0_burstcount < 3 && cmd0_is_sequential && fetch_r)
                        begin
                            if (cmd0_burstcount == 2 || (cmd0_burstcount < 2 && !cmd1_is_sequential) || (cmd0_burst_til_cmd1 > 2 && cmd1_is_sequential))
                                begin
                                    combine_req <= 1;
                                    combine_dqs <= cmd0_burstcount;
                                end
                            else
                                begin
                                    combine_req <= 2;
                                    combine_dqs <= cmd0_burstcount + cmd1_burstcount;
                                end
                        end
                    else if (max_dqs_combine_allowed == 1 && cmd0_burstcount == 1 && cmd0_is_sequential && fetch_r)
                        begin
                            combine_req <= 1;
                            combine_dqs <= 1;
                        end
                    else
                        begin
                            combine_req <= 0;
                            combine_dqs <= 0;
                        end
                    
                    if (fetch_r) // DO1 state just after fetch, current_burstcounter is valid
                        begin
                            if (crossing_burst_boundary) //current_burstcount_counter + burst_delay > 4
                                can_fetch <= 1'b0;
                        end
                    else if (burst_length) // DO1 state when there's no fetch
                        begin
                            if (current_burstcount_counter_r2 + burst_delay_r2 > 6)
                                can_fetch <= 1'b0;
                        end
                    else
                        begin
                            if (current_burstcount_counter_r2 + burst_delay_r2 > 4)
                                can_fetch <= 1'b0;
                        end
                    
                    //burst chop decision and type
                    if (MEM_TYPE == "DDR3")
                        begin
                            if ((current_burstcount_counter == 2 && !cmd0_is_sequential_reg && combine_dqs == 0) || (current_burstcount_counter == 1 && cmd0_is_sequential_reg && cmd0_burstcount == 1 && !cmd1_is_sequential))
                                begin
                                    if (burst_delay == 0)
                                        sense_burst_chop <= 2'b01;
                                    else if (burst_delay == 2)
                                        sense_burst_chop <= 2'b10;
                                    else
                                        sense_burst_chop <= 0;
                                end
                            else if (current_burstcount_counter == 1 && !cmd0_is_sequential_reg && combine_dqs == 0)
                                begin
                                    if (burst_delay == 0 || burst_delay == 1)
                                        sense_burst_chop <= 2'b01;
                                    else if (burst_delay == 2 || burst_delay == 3)
                                        sense_burst_chop <= 2'b10;
                                    else
                                        sense_burst_chop <= 0;
                                end
                        end
                    else
                        sense_burst_chop <= 0;
                    
                    to_chip <=  {MEM_IF_CS_WIDTH{1'b0}};
                    
                    if (precharge_current && can_precharge_current)
                        begin
                            just_did_precharge_to_cmd[4]    <=  1'b1;
                            do_precharge                <=  1'b1;
                            to_addr                     <=  current_addr;
                            if (current_multicast_req)
                                to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                            else
                                to_chip[current_chip]   <=  1'b1;
                        end
                    else if (precharge_cmd[0] && can_precharge[0] && lookahead_allowed_to_cmd[0])
                        begin
                            just_did_precharge_to_cmd[0]     <=  1'b1;
                            do_precharge                <=  1'b1;
                            to_addr                     <=  cmd0_addr;
                            if (proper_multicast_cmd0)
                                to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                            else
                                to_chip[cmd0_chip_addr] <=  1'b1;
                        end
                    else if (precharge_cmd[1] && can_precharge[1] && lookahead_allowed_to_cmd[1])
                        begin
                            just_did_precharge_to_cmd[1]     <=  1'b1;
                            do_precharge                <=  1'b1;
                            to_addr                     <=  cmd1_addr;
                            if (proper_multicast_cmd1)
                                to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                            else
                                to_chip[cmd1_chip_addr] <=  1'b1;
                        end
                    else if (precharge_cmd[2] && can_precharge[2] && lookahead_allowed_to_cmd[2])
                        begin
                            just_did_precharge_to_cmd[2]     <=  1'b1;
                            do_precharge                <=  1'b1;
                            to_addr                     <=  cmd2_addr;
                            if (proper_multicast_cmd2)
                                to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                            else
                                to_chip[cmd2_chip_addr] <=  1'b1;
                        end
                    else if (precharge_cmd[3] && can_precharge[3] && lookahead_allowed_to_cmd[3])
                        begin
                            just_did_precharge_to_cmd[3]     <=  1'b1;
                            do_precharge                <=  1'b1;
                            to_addr                     <=  cmd3_addr;
                            if (proper_multicast_cmd3)
                                to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                            else
                                to_chip[cmd3_chip_addr] <=  1'b1;
                        end
                end
            DO2 : // multi clock cycle state
                begin
                    from_fetch_state    <=  1'b0;
                    do_precharge    <=  1'b0;
                    do_activate     <=  1'b0;
                    is_diff_chip    <=  1'b0;
                    is_diff_chip_r  <=  1'b0;
                    
                    is_diff_chip_r  <= is_diff_chip;
                    
                    if (do_partial && !partial_write_read)
                        do_partial <= 1'b0;
                    
                    if (simple_burstcount > 1)
                        longer_than_1_req <= 1'b1;
                    
                    if (STATEMACHINE_TYPE == "TWO_CK")
                        begin
                            fetch <= 1'b0;
                            ecc_internal_fetch <= 1'b0;
                            do_write <= 1'b0;
                            do_read <= 1'b0;
                            do_burst_chop <= 1'b0;
                            do_auto_precharge <= 1'b0;
                            combine_req <= 0;
                            flush1 <= 1'b0;
                        end
                            
                    if (fetch && STATEMACHINE_TYPE == "TWO_CK" && !(CTL_ECC_ENABLED == 1 && write_burst_length && |short_partial_data_pipe))
                        if (flush1)
                            if (cmd1_diff_cs && burst_length)
                                state <= DO2;
                            else if ((cmd1_is_a_read && current_write) || (cmd1_is_a_write && current_read))
                                state <= DO2;
                            else if (
                                        (add_lat_on && (
                                            (activate_cmd[1] && !just_did_activate && (can_activate[1]) && ( (cmd1_is_a_read && can_al_activate_read) || (cmd1_is_a_write && enough_data_to_write && ((can_al_activate_write && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_al_activate_read && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write)))) ))
                                        ))
                                        ||
                                        (
                                            (cmd_is_ready[1] && !(do_auto_precharge && current_bank_index == cmd1_bank_index && current_row == cmd1_row_addr)) && ((cmd1_is_a_read && can_read[1] && !do_write) || (cmd1_is_a_write && enough_data_to_write && ((can_write[1] && !do_read && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_read[1] && !do_write && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write))) ))
                                        )
                                )
                                begin
                                    start_burst <= 1'b1;
                                    state <= READWRITE;
                                    if (CTL_ECC_ENABLED == 1 && cmd1_is_a_write && partial_write)
                                        begin
                                            partial_write_read <= 1'b1;
                                            do_partial <= 1'b1;
                                            do_ecc <= 1'b1;
                                        end
                                    if (do_partial)
                                        begin
                                            partial_write_read <= 1'b0;
                                            do_ecc <= 1'b0;
                                        end
                                end
                            else
                                state <= DO2;
                        else
                            if (cmd0_diff_cs && burst_length)
                                state <= DO2;
                            else if ((cmd0_is_a_read && current_write) || (cmd0_is_a_write && current_read))
                                state <= DO2;
                            else if (
                                        (add_lat_on && (
                                            (activate_cmd[0] && !just_did_activate && (can_activate[0]) && ( (cmd0_is_a_read && can_al_activate_read) || (cmd0_is_a_write && enough_data_to_write && ((can_al_activate_write && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_al_activate_read && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write)))) ))
                                        ))
                                        ||
                                        (
                                            (cmd_is_ready[0] && !(do_auto_precharge && current_bank_index == cmd0_bank_index && current_row == cmd0_row_addr)) && ((cmd0_is_a_read && can_read[0] && !do_write) || (cmd0_is_a_write && enough_data_to_write && ((can_write[0] && !do_read && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_read[0] && !do_write && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write))) ))
                                        )
                                )
                                begin
                                    start_burst <= 1'b1;
                                    state <= READWRITE;
                                    if (CTL_ECC_ENABLED == 1 && cmd0_is_a_write && partial_write)
                                        begin
                                            partial_write_read <= 1'b1;
                                            do_partial <= 1'b1;
                                            do_ecc <= 1'b1;
                                        end
                                    if (do_partial)
                                        begin
                                            partial_write_read <= 1'b0;
                                            do_ecc <= 1'b0;
                                        end
                                end
                            else
                                state <= DO2;
                    else
                        if ((!(row_incremented || bank_incremented || chip_incremented) && !(is_diff_chip || is_diff_chip_r)) && !(CTL_ECC_ENABLED == 1 && write_burst_length && |short_partial_data_pipe) && // hold of check if just did row increment, current bank info valid will still be high
                            (
                                (add_lat_on && (
                                    (activate_current && !just_did_activate && (can_activate_current) && ( (current_read && can_al_activate_read) || (current_write && (enough_data_to_write && (CTL_ECC_ENABLED == 0 || (CTL_ECC_ENABLED == 1 && (!do_partial || (do_partial && rmw_data_ready)) ))) && ((can_al_activate_write && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_al_activate_read && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write)))) ))
                                )) // in AL go to RDWR state when can activate
                                ||
                                (
                                    current_is_ready && ((current_read && can_read_current) || (current_write && (enough_data_to_write && (CTL_ECC_ENABLED == 0 || (CTL_ECC_ENABLED == 1 && (!do_partial || (do_partial && rmw_data_ready)) ))) && ((can_write_current && (CTL_ECC_ENABLED == 0 || do_partial || !partial_write)) || (can_read_current && (CTL_ECC_ENABLED == 1 && !do_partial && partial_write))) ))
                                )
                            )
                            )
                            begin
                                start_burst <= 1'b1;
                                state <= READWRITE;
                                if (CTL_ECC_ENABLED == 1 && current_write && partial_write)
                                    begin
                                        partial_write_read <= 1'b1;
                                        do_partial <= 1'b1;
                                        do_ecc <= 1'b1;
                                    end
                                if (do_partial)
                                    begin
                                        partial_write_read <= 1'b0;
                                        do_ecc <= 1'b0;
                                    end
                            end
                        else
                            state <= DO2;
                    
                    if (combine_dqs != 0)
                        combine_dqs <= 0;
                    
                    to_chip <=  {MEM_IF_CS_WIDTH{1'b0}};
                    just_did_activate <= 1'b0;
                    just_did_precharge_to_cmd <= 0;
                    
                    if (!fetch)
                        begin
                            if (precharge_current && !just_did_precharge_to_cmd[4] && can_precharge_current && !do_auto_precharge)
                                begin
                                    just_did_precharge_to_cmd[4]    <=  1'b1;
                                    do_precharge                    <=  1'b1;
                                    to_addr                         <=  current_addr;
                                    if (current_multicast_req)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[current_chip]       <=  1'b1;
                                end
                            else if (activate_current && !just_did_activate && can_activate_current && (!add_lat_on || (add_lat_on && (can_al_activate_read || can_al_activate_write) )))
                                begin
                                    just_did_activate               <=  1'b1;
                                    do_activate                     <=  1'b1;
                                    to_addr                         <=  current_addr;
                                    if (current_multicast_req)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[current_chip]       <=  1'b1;
                                end
                            else if (precharge_cmd[0] && !just_did_precharge_to_cmd[0] && can_precharge[0] && lookahead_allowed_to_cmd[0])
                                begin
                                    just_did_precharge_to_cmd[0]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd0_addr;
                                    if (proper_multicast_cmd0)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd0_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[0] && !just_did_activate && can_activate[0] && lookahead_allowed_to_cmd[0])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd0_addr;
                                    if (proper_multicast_cmd0)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd0_chip_addr] <=  1'b1;
                                end
                            else if (precharge_cmd[1] && !just_did_precharge_to_cmd[1] && can_precharge[1] && lookahead_allowed_to_cmd[1])
                                begin
                                    just_did_precharge_to_cmd[1]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd1_addr;
                                    if (proper_multicast_cmd1)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd1_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[1] && !just_did_activate && can_activate[1] && lookahead_allowed_to_cmd[1])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd1_addr;
                                    if (proper_multicast_cmd1)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd1_chip_addr] <=  1'b1;
                                end
                            else if (precharge_cmd[2] && !just_did_precharge_to_cmd[2] && can_precharge[2] && lookahead_allowed_to_cmd[2])
                                begin
                                    just_did_precharge_to_cmd[2]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd2_addr;
                                    if (proper_multicast_cmd2)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd2_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[2] && !just_did_activate && can_activate[2] && lookahead_allowed_to_cmd[2])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd2_addr;
                                    if (proper_multicast_cmd2)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd2_chip_addr] <=  1'b1;
                                end
                            else if (precharge_cmd[3] && !just_did_precharge_to_cmd[3] && can_precharge[3] && lookahead_allowed_to_cmd[3])
                                begin
                                    just_did_precharge_to_cmd[3]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd3_addr;
                                    if (proper_multicast_cmd3)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd3_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[3] && !just_did_activate && can_activate[3] && lookahead_allowed_to_cmd[3])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd3_addr;
                                    if (proper_multicast_cmd3)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd3_chip_addr] <=  1'b1;
                                end
                        end
                    else // fetch is high in DO2 should only happen in half rate
                        begin
                            if (precharge_cmd[0] && can_precharge[0] && !(do_auto_precharge && (current_bank_index == cmd0_bank_index)) && (lookahead_allowed_to_cmd[0] || from_fetch_state))
                                begin
                                    just_did_precharge_to_cmd[4]    <=  1'b1;
                                    do_precharge                    <=  1'b1;
                                    to_addr                         <=  cmd0_addr;
                                    if (proper_multicast_cmd0)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd0_chip_addr]     <=  1'b1;
                                end
                            else if (activate_cmd[0] && can_activate[0] && (lookahead_allowed_to_cmd[0] || from_fetch_state))
                                begin
                                    just_did_activate               <=  1'b1;
                                    do_activate                     <=  1'b1;
                                    to_addr                         <=  cmd0_addr;
                                    if (proper_multicast_cmd0)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd0_chip_addr]     <=  1'b1;
                                end
                            else if (precharge_cmd[1] && can_precharge[1] && lookahead_allowed_to_cmd[1])
                                begin
                                    just_did_precharge_to_cmd[0]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd1_addr;
                                    if (proper_multicast_cmd1)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd1_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[1] && can_activate[1] && lookahead_allowed_to_cmd[1])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd1_addr;
                                    if (proper_multicast_cmd1)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd1_chip_addr] <=  1'b1;
                                end
                            else if (precharge_cmd[2] && can_precharge[2] && lookahead_allowed_to_cmd[2])
                                begin
                                    just_did_precharge_to_cmd[1]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd2_addr;
                                    if (proper_multicast_cmd2)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd2_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[2] && can_activate[2] && lookahead_allowed_to_cmd[2])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd2_addr;
                                    if (proper_multicast_cmd2)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd2_chip_addr] <=  1'b1;
                                end
                            else if (precharge_cmd[3] && can_precharge[3] && lookahead_allowed_to_cmd[3])
                                begin
                                    just_did_precharge_to_cmd[2]     <=  1'b1;
                                    do_precharge                <=  1'b1;
                                    to_addr                     <=  cmd3_addr;
                                    if (proper_multicast_cmd3)
                                        to_chip                         <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd3_chip_addr] <=  1'b1;
                                end
                            else if (activate_cmd[3] && can_activate[3] && lookahead_allowed_to_cmd[3])
                                begin
                                    just_did_activate      <=  1'b1;
                                    do_activate                 <=  1'b1;
                                    to_addr                     <=  cmd3_addr;
                                    if (proper_multicast_cmd3)
                                        to_chip                     <=  {MEM_IF_CS_WIDTH{1'b1}};
                                    else
                                        to_chip[cmd3_chip_addr] <=  1'b1;
                                end
                        end
                end
            READWRITE : // one clock cycle state
                begin
                    
                    if (current_read)
                        do_read <= 1'b1;
                    else if (partial_write_read && current_write)
                        do_read <= 1'b1;
                    else
                        do_write <= 1'b1;
                    
                    start_burst <= 1'b0;
                    just_did_activate <= 1'b0;
                    just_did_precharge_to_cmd <= 0;
                    do_precharge <= 1'b0;
                    do_activate <= 1'b0;
                    //do_auto_precharge <= current_autopch_req;
                    to_addr <= current_addr;
                    to_chip <=  {MEM_IF_CS_WIDTH{1'b0}};
                    
                    if (current_multicast_req)
                        to_chip                 <=  {MEM_IF_CS_WIDTH{1'b1}};
                    else
                        to_chip[current_chip]   <=  1'b1;
                    
                    if (longer_than_1_req && simple_burstcount == 1 && (!do_partial || (do_partial && !do_ecc) ))
                        longer_than_1_req <= 1'b0;
                    
                    if (MEM_TYPE == "DDR3")
                        begin
                            if (STATEMACHINE_TYPE == "FOUR_CK")
                                begin
                                    if (|sense_burst_chop)
                                        begin
                                            sense_burst_chop <= 0;
                                            do_burst_chop <= 1'b1;
                                            to_addr[MEM_IF_COL_WIDTH-1:0] <= {current_col[MEM_IF_COL_WIDTH-1:2],2'b00};
                                        end
                                end
                            else
                                begin
                                    if (burst_delay == 1 || (current_burstcount_counter == 1 && (!cmd0_is_sequential_reg || (cmd0_is_sequential_reg && cmd0_burstcount != 1)) && (CTL_ECC_ENABLED != 1 || (CTL_ECC_ENABLED == 1 && !do_partial && !short_partial_data_pipe[1]))) )
                                        begin
                                            do_burst_chop <= 1'b1;
                                            if (burst_delay == 1 || !longer_than_1_req)
                                                to_addr[MEM_IF_COL_WIDTH-1:0] <= {current_col[MEM_IF_COL_WIDTH-1:2],2'b00};
                                        end
                                end
                        end
                    else
                        begin
                            sense_burst_chop <= 0;
                            if (MEMORY_BURSTLENGTH == 4)
                                to_addr[MEM_IF_COL_WIDTH-1:0] <= {current_col[MEM_IF_COL_WIDTH-1:2],2'b00};
                        end
                    
                    if (!current_is_ecc && !(partial_write_read && current_write)) // eccdo2 state doesn't handle auto precharge signal
                                                                                   // do not do autoprecharge if it is a partial write read
                        if (STATEMACHINE_TYPE == "FOUR_CK")
                            begin
                                if (!int_refresh_req)
                                    if (can_fetch)
                                        do_auto_precharge <= current_autopch_req | auto_autopch_req;
                                    else if (current_col[MEM_IF_COL_WIDTH-1:3] == {MEM_IF_COL_WIDTH-3{1'b1}})
                                        do_auto_precharge <= 1'b1;
                                    else
                                        do_auto_precharge <= 1'b0;
                                else
                                    do_auto_precharge <= 1'b0;
                            end
                        else
                            begin
                                if (!int_refresh_req)
                                    if (!((current_burstcount_counter + burst_delay > 2) || (burst_delay == 1 && current_burstcount_counter == 1 && cmd0_is_sequential_reg && cmd0_burstcount == 1)))
                                        do_auto_precharge <= current_autopch_req | auto_autopch_req;
                                    else if ((MEMORY_BURSTLENGTH == 8 && current_col[MEM_IF_COL_WIDTH-1:3] == {MEM_IF_COL_WIDTH-3{1'b1}}) || (MEMORY_BURSTLENGTH == 4 && current_col[MEM_IF_COL_WIDTH-1:2] == {MEM_IF_COL_WIDTH-2{1'b1}}))
                                        do_auto_precharge <= 1'b1;
                                    else
                                        do_auto_precharge <= 1'b0;
                                else
                                    do_auto_precharge <= 1'b0;
                            end
                    
                    if (current_is_ecc) // ecc writeback corrected data
                        begin
                            if (int_refresh_req)
                                state <= FETCH;
                            else if (current_write)
                                state <= FETCH;
                            else
                                begin
                                    ecc_dummy_fetch <= 1'b1;
                                    state <= ECC_DO2;
                                end
                        end
                    else if (do_partial && partial_write_read) // ecc partial write
                        begin
                            state <= FETCH;
                        end
                    else if (STATEMACHINE_TYPE == "FOUR_CK" && combine_req == 3)//(combine_req == 2 && combine_dqs == 2 && cmd2_is_sequential && cmd2_burstcount == 1)
                        begin
                            flush3 <= 1'b1;
                            state <= FETCH;
                            if ((cmd_is_valid[3] || cmd_fifo_wren) && no_intrpt_pending && can_fetch)
                                fetch <= 1'b1;
                        end
                    else if (STATEMACHINE_TYPE == "FOUR_CK" && combine_req == 2)// || (combine_req == 1 && combine_dqs == 1 && cmd1_is_sequential && cmd1_burstcount == 1))
                        begin
                            flush2 <= 1'b1;
                            state <= FETCH;
                            if ((cmd_is_valid[2] || cmd_fifo_wren) && no_intrpt_pending && can_fetch)
                                fetch <= 1'b1;
                        end
                    // half rate, no point of combining non burst-aligned cmd - keep it simple
                    else if ((STATEMACHINE_TYPE == "FOUR_CK" && combine_req == 1) || (STATEMACHINE_TYPE == "TWO_CK" && burst_delay == 0 && current_burstcount_counter == 1 && cmd0_is_sequential_reg && cmd0_burstcount == 1 && (CTL_ECC_ENABLED != 1 || (CTL_ECC_ENABLED == 1 && !do_partial && !short_partial_data_pipe[1]) )))
                        begin
                            flush1 <= 1'b1;
                            if (STATEMACHINE_TYPE == "FOUR_CK")
                                begin
                                    state <= FETCH;
                                    if ((cmd_is_valid[1] || cmd_fifo_wren) && no_intrpt_pending && can_fetch)
                                        fetch <= 1'b1;
                                end
                            else
                                begin
                                    // burst combine in half rate, so if there is delay, increment col
                                    if (burst_delay == 1)
                                        begin
                                            fetch <= 1'b0;
                                            state <= DO2;
                                        end
                                    else if ((cmd_is_valid[1] || cmd_fifo_wren) && no_intrpt_pending)
                                        begin
                                            fetch <= 1'b1;
                                            state <= DO2;
                                        end
                                    else
                                        begin
                                            fetch <= 1'b0;
                                            state <= FETCH;
                                        end
                                end
                        end
                    else if ((STATEMACHINE_TYPE == "FOUR_CK" && no_intrpt_pending) || (STATEMACHINE_TYPE == "TWO_CK" && !int_refresh_req))
                        begin
                            if (STATEMACHINE_TYPE == "FOUR_CK")
                                begin
                                    if (!cmd_fifo_empty || cmd_fifo_wren)
                                        begin
                                            fetch <= can_fetch;
                                            state <= FETCH;
                                        end
                                    else
                                        begin
                                            fetch <= 1'b0;
                                            state <= FETCH;
                                        end
                                end
                            else
                                begin
                                    if (current_burstcount_counter + burst_delay > 2)
                                        begin
                                            fetch <= 1'b0;
                                            state <= DO2;
                                        end
                                    else if ((!cmd_fifo_empty || cmd_fifo_wren) && !int_power_down_req && !int_self_rfsh_req && !int_ecc_req)
                                        begin
                                            fetch <= 1'b1;
                                            state <= DO2;
                                        end
                                    else
                                        begin
                                            fetch <= 1'b0;
                                            state <= FETCH;
                                        end
                                end
                        end
                    else // means there's refresh/powerdown/self refresh pending
                        begin
                            fetch <= 1'b0;
                            state <= FETCH;
                        end
                end
            ECC_DO2 :
                begin
                    do_precharge <=  1'b0;
                    do_activate <=  1'b0;
                    do_write <= 1'b0;
                    do_read <= 1'b0;
                    ecc_fetch <= 1'b0;
                    ecc_dummy_fetch <= 1'b0;
                    
                    to_chip <=  {MEM_IF_CS_WIDTH{1'b0}};
                    
                    if ((STATEMACHINE_TYPE == "FOUR_CK" && !(ecc_fetch || fetch_r || ecc_dummy_fetch)) || (STATEMACHINE_TYPE == "TWO_CK" && !(ecc_fetch || ecc_dummy_fetch)))
                        begin
                            if (
                                    (add_lat_on && (
                                        (activate_current && can_activate_current && ( (current_read && can_al_activate_read) || (current_write && rmw_data_ready && can_al_activate_write) ))
                                    )) // in AL go to RDWR state when can activate
                                    ||
                                    (
                                        (current_read && current_is_ready && can_read_current) || (current_write && current_is_ready && can_write_current && rmw_data_ready)
                                    )
                                )
                                begin
                                    state <= READWRITE;
                                    start_burst <= 1'b1;
                                end
                            else
                                state <= ECC_DO2;
                            
                            if (precharge_current && can_precharge_current && !just_did_precharge_to_cmd[4] && !do_auto_precharge)
                                begin
                                    just_did_precharge_to_cmd[4]<=  1'b1;
                                    do_precharge            <=  1'b1;
                                    to_addr                 <=  current_addr;
                                    to_chip[current_chip]   <=  1'b1;
                                end
                            else if (activate_current && can_activate_current && !just_did_activate)
                                begin
                                    just_did_activate <=  1'b1;
                                    do_activate             <=  1'b1;
                                    to_addr                 <=  current_addr;
                                    to_chip[current_chip]   <=  1'b1;
                                end
                        end
                    else
                        state <= ECC_DO2;
                end
            PCHALL :
                begin
                    do_precharge_all <= 1'b0;
                    if (for_chip_refresh_req | for_chip_self_rfsh_req | for_chip_power_down_req) 
                    begin

                        if ( |for_chip ) 
                        begin
                            if (precharge_all_chip_ok)
                            begin
                                do_precharge_all <= 1'b1;
                                to_chip <= for_chip_current;
                                for_chip <= for_chip_next;
                                state <= PCHALL;


                            end
                            else
                                state <= PCHALL;

                        end
                        else 
                        begin

                            for_chip <= for_chip_saved;

                            if (for_chip_refresh_req | for_chip_self_rfsh_req)
                            begin
                                // need to do REFRESH before SELFRFSH
                                state <= REFRESH;
                            end
                            else if (for_chip_power_down_req)
                            begin
                                state <= PDOWN;
                            end
                            else
                            begin
                                state <= FETCH;
                            end
                        end
                    end
                    else 
                    begin
                        state <= FETCH;
                        for_chip_refresh_req <= 1'b0;
                        for_chip_self_rfsh_req <= 1'b0;
                        for_chip_power_down_req <= 1'b0;
                    end

                end
            REFRESH :
                begin
                    do_precharge_all <= 1'b0;
                    do_refresh <= 1'b0;
                    int_refresh_ack <= 0;
                    for_chip_refresh_req <= 1'b0;

                    if ( |for_chip )
                    begin
                        if ( refresh_chip_ok && !do_precharge_all)
                        begin
                            do_refresh <= 1'b1;
                            to_chip <= for_chip_current;
                            for_chip <= for_chip_next;
                            state <= REFRESH;

                            if ( ~(|for_chip_next) )
                            begin
                                int_refresh_ack <= 1;
                            end
                        end
                        else
                             state <= REFRESH;
                    end
                    else
                    begin
            
                        int_refresh_ack <= 0;
                        for_chip <= for_chip_saved;

                        if (for_chip_self_rfsh_req)
                        begin
                            // REFRESH -> SELFRFSH only when for_chip was registered to perform a self refresh
                            state <= SELFRFSH;
                        end
                        else if (int_power_down_req && &for_chip_saved && &all_banks_closed && !int_ecc_req && ((STATEMACHINE_TYPE == "FOUR_CK" && simple_burstcount_r2 == 0) || (STATEMACHINE_TYPE == "TWO_CK" && simple_burstcount == 0)))
                        begin
                            // REFRESH -> PDOWN only if all banks already closed, or if the refresh was for all chips (which means a pre-charge to all chips would have been issued)
                            state <= PDOWN;
                        end
                        else
                        begin
                            state <= FETCH;
                        end
                    end
                end
            PDOWN :
                begin
                    do_precharge_all <= 1'b0;
                    do_refresh <= 1'b0;
                    int_refresh_ack <= 0;
                    for_chip_power_down_req <= 1'b0;
                    if (int_refresh_req && !do_refresh && &can_exit_power_saving_mode)
                        begin
                            do_power_down <= 1'b0;
                            state <= REFRESH;
                            for_chip <= refresh_chip;
                        end
                    else if ((!int_power_down_req || int_ecc_req) && &can_exit_power_saving_mode)
                        begin
                            do_power_down <= 1'b0;
                            state <= FETCH;
                        end
                    else if (&can_enter_power_down && !do_precharge_all) // check for all chips
                        begin
                            do_power_down <= 1'b1;
                            to_chip <= for_chip;
                            state <= PDOWN;
                        end
                    else
                        state <= PDOWN;
                end
            SELFRFSH :
                begin
                    do_precharge_all <= 1'b0;
                    int_refresh_ack <= 0;
                    for_chip_self_rfsh_req <= 1'b0;

                    if (!int_self_rfsh_req && &can_exit_power_saving_mode)
                        begin
                            do_self_rfsh <= 1'b0;
                            for_chip_self_rfsh_saved <= 0;
                            for_chip <= for_chip_saved;

                            if (MEM_TYPE == "DDR3")
                                state <= ZQCAL;
                            else
                                state <= FETCH;
                        end
                    else if (self_rfsh_chip_ok && !do_precharge_all)
                        begin
                            do_self_rfsh <= 1'b1;
                            to_chip <= (for_chip_current) | for_chip_self_rfsh_saved;
                            for_chip_self_rfsh_saved <= (for_chip_current) | for_chip_self_rfsh_saved;
                            for_chip <= for_chip_next;
                            state <= SELFRFSH;
                        end
                    else
                        state <= SELFRFSH;
                end
            ZQCAL :
                begin

                    state <= ZQCAL;

                    if (zq_cal_req)
                    begin
                        zq_cal_req_r <= 1;
                    end

                    if (zq_cal_req_r)
                    begin
                        if (|for_chip)
                        begin
                            do_zqcal <= 1;
                            to_chip <= for_chip_current;
                            for_chip <= for_chip_next;
                        end
                        else 
                        begin
                            do_zqcal <= 0;
                            zq_cal_req_r <= 0;
                            state <= FETCH;
                        end
                    end
                end
            default : state <= FETCH;
        endcase
    end



endmodule
