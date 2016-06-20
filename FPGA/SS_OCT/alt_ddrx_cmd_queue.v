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
// Title         : DDR controller Command Queue
//
// File          : alt_ddrx_command_queue.v
//
// Abstract      : Store incoming commands
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_cmd_queue 
    # (parameter	 MEM_IF_CSR_COL_WIDTH        = 4,
                     MEM_IF_CSR_ROW_WIDTH        = 5,
                     MEM_IF_CSR_BANK_WIDTH       = 2,
                     MEM_IF_CSR_CS_WIDTH         = 2, 
                     CTL_CMD_QUEUE_DEPTH         = 4,  
                     CTL_LOOK_AHEAD_DEPTH        = 4, 
                     MEM_IF_ROW_WIDTH            = 16, 
                     MEM_IF_COL_WIDTH            = 12,  
                     MEM_IF_BA_WIDTH             = 3,  
                     MEM_IF_CHIP_BITS            = 2,  
                     LOCAL_ADDR_WIDTH            = 33, 
                     LOCAL_SIZE_WIDTH            = 6,
                     DWIDTH_RATIO                = 4,
                     MIN_COL                     = 8,
                     MIN_ROW                     = 12,
                     MIN_BANK                    = 2,
                     MIN_CS                      = 1
	 )                                        
     (
	//input
	ctl_clk       , 								
	ctl_reset_n   ,                                                 		                                                	        
	read_req_to_cmd_queue  ,                                               		
	write_req_to_cmd_queue ,                                               		
	local_size      ,                                               		
	local_autopch_req ,  
    local_multicast ,
	local_addr  	,                                               		
	                                                                                
	//input from CSR block                                          		
	addr_order,  
    col_width_from_csr,
	row_width_from_csr,
	bank_width_from_csr, 
	cs_width_from_csr,
	                                                                                
	//input from State Machine                                      		
	fetch,                                                     		      
	flush1,                                                     	        
	flush2,                                                     		
	flush3,                                                     		
                                                                        		
	//output                                                        		
	cmd_fifo_empty, 			                                        
	cmd_fifo_full,   
	cmd_fifo_wren,
    current_chip_addr,
    
	cmd0_is_a_read,                                                                 
	cmd0_is_a_write,                                                                
	cmd0_autopch_req,                                                            
	cmd0_burstcount,                                                                
	cmd0_chip_addr,                                                                 
	cmd0_row_addr,                                                                  
	cmd0_bank_addr,                                                                 
	cmd0_col_addr,	
	cmd0_is_sequential, 
	cmd0_is_valid,   
    cmd0_diff_cs,
    cmd0_multicast_req,
	                                                                                
	cmd1_is_a_read,                                                                 
	cmd1_is_a_write,  
    cmd1_autopch_req,                                                            
	cmd1_burstcount,  
	cmd1_chip_addr,                                                                 
	cmd1_row_addr,                                                                  
	cmd1_bank_addr,	
    cmd1_col_addr,
	cmd1_is_sequential,                                             		
	cmd1_is_valid,   
    cmd1_diff_cs,
    cmd1_multicast_req,
	                                                                                
	cmd2_is_a_read,                                                                 
	cmd2_is_a_write,  
    cmd2_autopch_req,                                                            
	cmd2_burstcount, 
    cmd2_chip_addr,                                                                 
	cmd2_row_addr,                                                                  
	cmd2_bank_addr,	
    cmd2_col_addr,
	cmd2_is_sequential,                                             		
	cmd2_is_valid,  
    cmd2_diff_cs,
    cmd2_multicast_req,
     
    cmd3_is_a_read,                                                                 
	cmd3_is_a_write,  
    cmd3_autopch_req,                                                            
	cmd3_burstcount,
    cmd3_col_addr,
    cmd3_is_sequential,
	cmd3_chip_addr,                                                                 
	cmd3_row_addr,                                                                  
	cmd3_bank_addr,		                                                                                                    		
	cmd3_is_valid, 
    cmd3_diff_cs,
	cmd3_multicast_req,
    
    cmd4_is_a_read,                                                                 
	cmd4_is_a_write,
    cmd4_is_sequential,
	cmd4_is_valid,                                                  		                                                           
	cmd4_chip_addr,                                                                 
	cmd4_row_addr,                                                  		
	cmd4_bank_addr,    
    cmd4_multicast_req,
	
    cmd5_is_a_read,                                                                 
	cmd5_is_a_write,
	cmd5_is_valid,                                                  		                                                          
	cmd5_chip_addr,                                                                 
	cmd5_row_addr,                                                  		
	cmd5_bank_addr,   
    cmd5_multicast_req,
	
    cmd6_is_a_read,                                                                 
	cmd6_is_a_write,
	cmd6_is_valid,                                                  		                                                         
	cmd6_chip_addr,                                                                 
	cmd6_row_addr,                                                  		
	cmd6_bank_addr,  
    cmd6_multicast_req,
	
    cmd7_is_a_read,                                                                 
	cmd7_is_a_write,
	cmd7_is_valid,                                                  		
	cmd7_chip_addr,                                                         
	cmd7_row_addr,                                                  		
	cmd7_bank_addr,
    cmd7_multicast_req
    ); 
    localparam   BUFFER_WIDTH         = 1 + 1 + 1 + 1 + LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH;
    localparam   THIS_ENTRY_WIDTH     = 1 + 1 + 1 + MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH;
    localparam   MAX_COL              = MEM_IF_COL_WIDTH;
    localparam   MAX_ROW              = MEM_IF_ROW_WIDTH;
    localparam   MAX_BANK             = MEM_IF_BA_WIDTH;
    localparam   MAX_CS               = MEM_IF_CHIP_BITS;
    
    input                		          ctl_clk       	; 	// controller clock
    input                		          ctl_reset_n   	; 	// controller reset_n, synchronous to ctl_clk
	                 		              
	input 		     		              read_req_to_cmd_queue  	;
	input 		     		              write_req_to_cmd_queue 	;
	input [LOCAL_SIZE_WIDTH-1:0]          local_size      	;
	input		     		              local_autopch_req ;
    input                                 local_multicast   ;
	input [LOCAL_ADDR_WIDTH-1:0]          local_addr  	    ;
	output               		          cmd_fifo_empty	;      
	output               		          cmd_fifo_full	    ;    
    output                                cmd_fifo_wren     ;
	
	// input from CSR
	input [1:0]	addr_order;
    input [MEM_IF_CSR_COL_WIDTH-1:0]      col_width_from_csr;                      
	input [MEM_IF_CSR_ROW_WIDTH-1:0]      row_width_from_csr; 
    input [MEM_IF_CSR_BANK_WIDTH-1:0]     bank_width_from_csr; 
    input [MEM_IF_CSR_CS_WIDTH-1:0]       cs_width_from_csr; 
    
	//input from State Machine
	input 				                  fetch;	
	input 				                  flush1;
	input 				                  flush2;
	input 				                  flush3;
    input [MEM_IF_CHIP_BITS-1:0]          current_chip_addr;
	
	output               		          cmd0_is_valid;
	output 				                  cmd0_is_sequential;
    output                		          cmd0_is_a_read;
    output                		          cmd0_is_a_write;
	output		     		              cmd0_autopch_req;
    output [LOCAL_SIZE_WIDTH-1:0]         cmd0_burstcount;
    output [MEM_IF_CHIP_BITS-1:0]         cmd0_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd0_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd0_bank_addr;
	output [MEM_IF_COL_WIDTH-1:0]         cmd0_col_addr;
    output                                cmd0_diff_cs;
    output                                cmd0_multicast_req;
	
	output               		          cmd1_is_valid;
	output				                  cmd1_is_sequential;
    output                		          cmd1_is_a_read;
    output                		          cmd1_is_a_write;
    output		     		              cmd1_autopch_req;
    output [LOCAL_SIZE_WIDTH-1:0]         cmd1_burstcount;
    output [MEM_IF_COL_WIDTH-1:0]         cmd1_col_addr;
    output [MEM_IF_CHIP_BITS-1:0]         cmd1_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd1_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd1_bank_addr;
    output                                cmd1_diff_cs;
    output                                cmd1_multicast_req;
	
	output               		          cmd2_is_valid;
	output				                  cmd2_is_sequential;
    output                		          cmd2_is_a_read;
    output                		          cmd2_is_a_write;
    output		     		              cmd2_autopch_req;
    output [LOCAL_SIZE_WIDTH-1:0]         cmd2_burstcount;
    output [MEM_IF_COL_WIDTH-1:0]         cmd2_col_addr;
    output [MEM_IF_CHIP_BITS-1:0]         cmd2_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd2_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd2_bank_addr;
    output                                cmd2_diff_cs;
    output                                cmd2_multicast_req;
	
	output               		          cmd3_is_valid;
    output                                cmd3_is_sequential;
    output                		          cmd3_is_a_read;
    output                		          cmd3_is_a_write;
    output		     		              cmd3_autopch_req;
    output [LOCAL_SIZE_WIDTH-1:0]         cmd3_burstcount;
    output [MEM_IF_COL_WIDTH-1:0]         cmd3_col_addr;
    output [MEM_IF_CHIP_BITS-1:0]         cmd3_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd3_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd3_bank_addr;
    output                                cmd3_diff_cs;
    output                                cmd3_multicast_req;
	
    output                		          cmd4_is_a_read;
    output                		          cmd4_is_a_write;
    output                                cmd4_is_sequential;
	output               		          cmd4_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd4_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd4_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd4_bank_addr;
    output                                cmd4_multicast_req;
    
    output                		          cmd5_is_a_read;
    output                		          cmd5_is_a_write;
	output               		          cmd5_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd5_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd5_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd5_bank_addr;
    output                                cmd5_multicast_req;
    
    output                		          cmd6_is_a_read;
    output                		          cmd6_is_a_write;
	output               		          cmd6_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd6_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd6_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd6_bank_addr;
    output                                cmd6_multicast_req;
    
    output                		          cmd7_is_a_read;
    output                		          cmd7_is_a_write;
	output               		          cmd7_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd7_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd7_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd7_bank_addr;
    output                                cmd7_multicast_req;
	
    integer                               n;
	integer                               j;
	integer                               k;
	integer                               m;
    
    reg [BUFFER_WIDTH-1:0]		          pipe[CTL_CMD_QUEUE_DEPTH-1:0];		
	reg 				                  pipefull[CTL_CMD_QUEUE_DEPTH-1:0];	
    reg [LOCAL_SIZE_WIDTH-1:0]            last_size;
    reg                                   last_read_req;
    reg                                   last_write_req;
    reg                                   last_multicast;
    reg [MEM_IF_CHIP_BITS-1:0]            last_chip_addr;
    reg [MEM_IF_ROW_WIDTH-1:0]            last_row_addr;
    reg [MEM_IF_BA_WIDTH-1:0]             last_bank_addr;
    reg [MEM_IF_COL_WIDTH-1:0]            last_col_addr;
	reg [MEM_IF_CHIP_BITS-1:0]            cs_addr  ;
	reg [MEM_IF_ROW_WIDTH-1:0]            row_addr ;
	reg [MEM_IF_BA_WIDTH-1:0]             bank_addr;
	reg [MEM_IF_COL_WIDTH-1:0]            col_addr ;
    reg [MEM_IF_COL_WIDTH-1:0]            col_width;
    reg [MEM_IF_ROW_WIDTH-1:0]            row_width;
    reg [MEM_IF_BA_WIDTH-1:0]             bank_width;
    reg [MEM_IF_COL_WIDTH-1:0]            col_num;
    reg [MEM_IF_ROW_WIDTH-1:0]            row_num;
    reg [MEM_IF_BA_WIDTH-1:0]             bank_num;
    
	wire [1:0]                           addr_order;
    wire [MEM_IF_CSR_COL_WIDTH-1:0]      col_width_from_csr;                      
	wire [MEM_IF_CSR_ROW_WIDTH-1:0]      row_width_from_csr; 
    wire [MEM_IF_CSR_BANK_WIDTH-1:0]     bank_width_from_csr; 
    wire [MEM_IF_CSR_CS_WIDTH-1:0]       cs_width_from_csr; 
    
	wire 		     		              read_req_to_cmd_queue  	;
	wire 		     		              write_req_to_cmd_queue 	;
	wire		     		              local_autopch_req ;
    wire                                  local_multicast;
	wire  [LOCAL_SIZE_WIDTH-1:0] 	      local_size;
	wire  [LOCAL_ADDR_WIDTH-1:0]   	      local_addr;
	wire				                  fetch;
	wire				                  flush1;
	wire				                  flush2;
	wire				                  flush3;
    wire  [MEM_IF_CHIP_BITS-1:0]          current_chip_addr;
    wire 				                  cmd_flush[2:0];
	wire [BUFFER_WIDTH-1:0]		          buffer_input;
	wire				                  valid_rreq;
	wire				                  wreq_to_fifo;  
	wire [MEM_IF_CHIP_BITS-1:0]           pipe_chip_addr     [CTL_LOOK_AHEAD_DEPTH-1:0];
	wire [MEM_IF_ROW_WIDTH-1:0]           pipe_row_addr      [CTL_LOOK_AHEAD_DEPTH-1:0];
	wire [MEM_IF_BA_WIDTH-1:0]            pipe_bank_addr     [CTL_LOOK_AHEAD_DEPTH-1:0];
	wire [MEM_IF_COL_WIDTH-1:0]           pipe_col_addr      [CTL_LOOK_AHEAD_DEPTH-1:0];
    wire                                  pipe_read_req      [CTL_LOOK_AHEAD_DEPTH-1:0];
    wire                                  pipe_write_req     [CTL_LOOK_AHEAD_DEPTH-1:0];
    wire                                  pipe_autopch_req   [CTL_LOOK_AHEAD_DEPTH-1:0];
    wire                                  pipe_multicast_req [CTL_LOOK_AHEAD_DEPTH-1:0];
    wire [LOCAL_SIZE_WIDTH-1:0]           pipe_burstcount    [CTL_LOOK_AHEAD_DEPTH-1:0];
    
	wire [THIS_ENTRY_WIDTH-1:0]           seq_entry[5:0];	           
    wire [LOCAL_SIZE_WIDTH-1:0]           prev_size[5:0];
	wire 				                  cmd_is_seq[4:0];		      
	wire [THIS_ENTRY_WIDTH-1:0]           minus_addr [4:0];

    wire                                  cmd_fifo_wren;
	wire				                  cmd0_is_valid;
	wire				                  cmd0_is_sequential;
	wire                		          cmd0_is_a_read;
	wire                		          cmd0_is_a_write;
	wire		     		              cmd0_autopch_req;
	wire [LOCAL_SIZE_WIDTH-1:0]           cmd0_burstcount;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd0_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd0_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd0_bank_addr;
	wire [MEM_IF_COL_WIDTH-1:0]           cmd0_col_addr;
    wire                                  cmd0_diff_cs;
    wire                                  cmd0_multicast_req;

	wire               		              cmd1_is_valid;
	wire				                  cmd1_is_sequential;
    wire                		          cmd1_is_a_read;
    wire                		          cmd1_is_a_write;
    wire		     		              cmd1_autopch_req;
	wire [LOCAL_SIZE_WIDTH-1:0]           cmd1_burstcount;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd1_col_addr;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd1_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd1_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd1_bank_addr;
    wire                                  cmd1_diff_cs;
    wire                                  cmd1_multicast_req;

	wire               		              cmd2_is_valid;
	wire				                  cmd2_is_sequential;
    wire                		          cmd2_is_a_read;
    wire                		          cmd2_is_a_write;
    wire		     		              cmd2_autopch_req;
	wire [LOCAL_SIZE_WIDTH-1:0]           cmd2_burstcount;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd2_col_addr;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd2_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd2_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd2_bank_addr;
    wire                                  cmd2_diff_cs;
    wire                                  cmd2_multicast_req;

	wire               		              cmd3_is_valid;
    wire                                  cmd3_is_sequential;
    wire                		          cmd3_is_a_read;
    wire                		          cmd3_is_a_write;
    wire		     		              cmd3_autopch_req;
	wire [LOCAL_SIZE_WIDTH-1:0]           cmd3_burstcount;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd3_col_addr;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd3_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd3_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd3_bank_addr;
    wire                                  cmd3_diff_cs;
    wire                                  cmd3_multicast_req;
    
    wire                		          cmd4_is_a_read;
    wire                		          cmd4_is_a_write;
	wire               		              cmd4_is_valid;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd4_col_addr;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd4_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd4_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd4_bank_addr;
    wire                                  cmd4_multicast_req;
    
    wire                		          cmd5_is_a_read;
    wire                		          cmd5_is_a_write;
	wire               		              cmd5_is_valid;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd5_col_addr;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd5_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd5_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd5_bank_addr;
    wire                                  cmd5_multicast_req;
    
    wire                		          cmd6_is_a_read;
    wire                		          cmd6_is_a_write;
	wire               		              cmd6_is_valid;
    wire [MEM_IF_COL_WIDTH-1:0]           cmd6_col_addr;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd6_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd6_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd6_bank_addr;
    wire                                  cmd6_multicast_req;
    
    wire                		          cmd7_is_a_read;
    wire                		          cmd7_is_a_write;
	wire               		              cmd7_is_valid;
   	wire [MEM_IF_COL_WIDTH-1:0]           cmd7_col_addr;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd7_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd7_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd7_bank_addr;
    wire                                  cmd7_multicast_req;
    
    wire                                  check_cs[3:0];

    genvar 			      	              i;     
    
//=======================   local_addr remapping   ===========================
        //derive column address from local_addr
        always @(*) 
        begin : Col_addr_loop
            col_addr[MIN_COL - DWIDTH_RATIO/2 - 1 : 0] = local_addr[MIN_COL - DWIDTH_RATIO/2 - 1 : 0];    
            for (n=MIN_COL - DWIDTH_RATIO/2; n<MAX_COL; n=n+1'b1) begin
                if(n < col_width_from_csr - DWIDTH_RATIO/2) begin // bit of col_addr can be configured in CSR using col_width_from_csr
                     col_addr[n] = local_addr[n]; 
                end
                else begin
                     col_addr[n] = 1'b0; 
                end    
            end
        end
        
        //derive row address from local_addr
        always @(*) 
        begin : Row_addr_loop
            for (j=0; j<MIN_ROW; j=j+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(j < row_width_from_csr) begin" which causes multiplexers
                if(addr_order == 2'd1)  // local_addr can arrange in 2 patterns depending on addr_order (i) cs, bank, row, col (ii) cs, row, bank, col
                        row_addr[j] = local_addr[j + col_width_from_csr - DWIDTH_RATIO/2];  //address order pattern 1
                else  // addr_order == 2'd0 or others
                        row_addr[j] = local_addr[j + bank_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
            end
            for (j=MIN_ROW; j<MAX_ROW; j=j+1'b1) begin               
                if(j < row_width_from_csr) begin    // bit of row_addr can be configured in CSR using row_width_from_csr
                    if(addr_order == 2'd1)
                        row_addr[j] = local_addr[j + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                    else  // addr_order == 2'd0 or others
                        row_addr[j] = local_addr[j + bank_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
                end
                else begin
                    row_addr[j] = 1'b0;  
                end
            end
        end
        
        always @(*) 
        begin : Bank_addr_loop
            for (k=0; k<MIN_BANK; k=k+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(k < bank_width_from_csr) begin" which causes multiplexers
                if(addr_order == 2'd1) // local_addr can arrange in 2 patterns depending on addr_order (i) cs, bank, row, col (ii) cs, row, bank, col
                        bank_addr[k] = local_addr[k + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                    else  // addr_order == 2'd0 or others
                        bank_addr[k] = local_addr[k + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
            end
            for (k=MIN_BANK; k<MAX_BANK; k=k+1'b1) begin               
                if(k < bank_width_from_csr) begin   // bit of bank_addr can be configured in CSR using bank_width_from_csr
                    if(addr_order == 2'd1)
                        bank_addr[k] = local_addr[k + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                    else  // addr_order == 2'd0 or others
                        bank_addr[k] = local_addr[k + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
                end
                else begin
                    bank_addr[k] = 1'b0; 
                end
             end
        end
          
            always @(*) 
            begin
                m=0;
                if (cs_width_from_csr > 1'b0) begin    //if cs_width_from_csr =< 1'b1, local_addr doesn't have cs_addr bit
                    for (m=0; m<MIN_CS; m=m+1'b1) begin  //The purpose of using this for-loop is to get rid of "if(m < cs_width_from_csr) begin" which causes multiplexers
                        cs_addr[m] = local_addr[m + bank_width_from_csr + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; 
                    end
                    for (m=MIN_CS; m<MAX_CS; m=m+1'b1) begin                
                        if(m < cs_width_from_csr) begin     // bit of cs_addr can be configured in CSR using cs_width_from_csr
                            cs_addr[m] = local_addr[m + bank_width_from_csr + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; 
                        end    
                        else begin
                            cs_addr[m] = 1'b0;
                        end
                    end
                end
                else begin 
                    cs_addr = {MEM_IF_CHIP_BITS{1'b0}}; //if MEM_IF_CS_WIDTH = 1, then set cs_addr to 0 (one chip, one rank)
                end
            end   
           
//=====================   end of local_addr remapping   =========================

// mapping of buffer_input
	assign buffer_input = {read_req_to_cmd_queue,write_req_to_cmd_queue,local_multicast,local_autopch_req,local_size,cs_addr,row_addr,bank_addr,col_addr};
	
//======================  Bus to output signals mapping   =======================
	//pipe address
	generate for(i=0; i<CTL_LOOK_AHEAD_DEPTH; i=i+1) begin : pipe_address_loop
        assign pipe_read_req[i]         = pipe[i][BUFFER_WIDTH-1];
        assign pipe_write_req[i]        = pipe[i][BUFFER_WIDTH-2];
        assign pipe_multicast_req[i]    = pipe[i][BUFFER_WIDTH-3];
        assign pipe_autopch_req[i]      = pipe[i][BUFFER_WIDTH-4];
        assign pipe_burstcount[i]       = pipe[i][LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
        assign pipe_chip_addr[i]        = pipe[i][MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
        assign pipe_row_addr[i]         = pipe[i][MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
        assign pipe_bank_addr[i]        = pipe[i][MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_COL_WIDTH];
        assign pipe_col_addr[i]         = pipe[i][MEM_IF_COL_WIDTH - 1 : 0];
    end
	endgenerate 

    assign cmd0_is_a_read               = pipe_read_req   [0];
	assign cmd0_is_a_write              = pipe_write_req  [0];
    assign cmd0_multicast_req           = pipe_multicast_req [0];
	assign cmd0_autopch_req             = pipe_autopch_req[0];
	assign cmd0_burstcount              = pipe_burstcount [0];
	assign cmd0_chip_addr               = pipe_chip_addr  [0];
	assign cmd0_row_addr                = pipe_row_addr   [0];
	assign cmd0_bank_addr               = pipe_bank_addr  [0];
	assign cmd0_col_addr                = (pipe[0][MEM_IF_COL_WIDTH - 1 : 0] << (log2 (DWIDTH_RATIO)));
	assign cmd0_is_valid                = pipefull[0];  
    
	assign cmd1_is_a_read               = pipe_read_req   [1]   ;
	assign cmd1_is_a_write              = pipe_write_req  [1]   ;
    assign cmd1_multicast_req           = pipe_multicast_req [1];
    assign cmd1_autopch_req             = pipe_autopch_req[1]   ;
	assign cmd1_burstcount              = pipe_burstcount [1]   ;
	assign cmd1_chip_addr               = pipe_chip_addr  [1]   ;
	assign cmd1_row_addr                = pipe_row_addr   [1]   ;
	assign cmd1_bank_addr               = pipe_bank_addr  [1]   ;
	assign cmd1_col_addr                = (pipe[1][MEM_IF_COL_WIDTH - 1 : 0] << (log2 (DWIDTH_RATIO)));
    assign cmd1_is_valid                = pipefull[1];
    
	assign cmd2_is_a_read               = pipe_read_req   [2]   ;
	assign cmd2_is_a_write              = pipe_write_req  [2]   ;
    assign cmd2_multicast_req           = pipe_multicast_req [2];
    assign cmd2_autopch_req             = pipe_autopch_req[2]   ;
	assign cmd2_burstcount              = pipe_burstcount [2]   ;
	assign cmd2_chip_addr               = pipe_chip_addr  [2]   ;
	assign cmd2_row_addr                = pipe_row_addr   [2]   ;
	assign cmd2_bank_addr               = pipe_bank_addr  [2]   ;
	assign cmd2_col_addr                = (pipe[2][MEM_IF_COL_WIDTH - 1 : 0] << (log2 (DWIDTH_RATIO)));
    assign cmd2_is_valid                = pipefull[2];
    
	assign cmd3_is_a_read               = pipe_read_req   [3]   ;
	assign cmd3_is_a_write              = pipe_write_req  [3]   ;
    assign cmd3_multicast_req           = pipe_multicast_req [3];
    assign cmd3_autopch_req             = pipe_autopch_req[3]   ;
	assign cmd3_burstcount              = pipe_burstcount [3]   ;
	assign cmd3_chip_addr               = pipe_chip_addr  [3]   ;
	assign cmd3_row_addr                = pipe_row_addr   [3]   ;
	assign cmd3_bank_addr               = pipe_bank_addr  [3]   ;
	assign cmd3_col_addr                = (pipe[3][MEM_IF_COL_WIDTH - 1 : 0] << (log2 (DWIDTH_RATIO)));
    assign cmd3_is_valid                = pipefull[3];    

	//subsequent entry
	generate if (CTL_LOOK_AHEAD_DEPTH == 6) begin
            assign cmd4_is_a_read      = pipe_read_req [4];
            assign cmd4_is_a_write     = pipe_write_req[4];
			assign cmd4_chip_addr      = pipe_chip_addr[4];
			assign cmd4_row_addr       = pipe_row_addr [4];
			assign cmd4_bank_addr      = pipe_bank_addr[4];   
            assign cmd4_multicast_req  = pipe_multicast_req [4];
			assign cmd4_is_valid       = pipefull[4];
            
            assign cmd5_is_a_read      = pipe_read_req [5];
            assign cmd5_is_a_write     = pipe_write_req[5];
			assign cmd5_chip_addr      = pipe_chip_addr[5];
			assign cmd5_row_addr       = pipe_row_addr [5];
			assign cmd5_bank_addr      = pipe_bank_addr[5];
            assign cmd5_multicast_req  = pipe_multicast_req [5];
			assign cmd5_is_valid       = pipefull[5];
            
            assign cmd6_is_a_read      = 0;
            assign cmd6_is_a_write     = 0;
			assign cmd6_chip_addr      = 0;
			assign cmd6_row_addr       = 0;
			assign cmd6_bank_addr      = 0; 
            assign cmd6_multicast_req  = 0;
			assign cmd6_is_valid       = 0;
            
            assign cmd7_is_a_read      = 0;
            assign cmd7_is_a_write     = 0;
			assign cmd7_chip_addr      = 0;
			assign cmd7_row_addr       = 0;
			assign cmd7_bank_addr      = 0;
            assign cmd7_multicast_req  = 0;
            assign cmd7_is_valid       = 0;
	    end
	    
	    else if (CTL_LOOK_AHEAD_DEPTH == 8) begin
            assign cmd4_is_a_read      = pipe_read_req [4];
            assign cmd4_is_a_write     = pipe_write_req[4];
			assign cmd4_chip_addr      = pipe_chip_addr[4];
			assign cmd4_row_addr       = pipe_row_addr [4];
			assign cmd4_bank_addr      = pipe_bank_addr[4];   
            assign cmd4_multicast_req  = pipe_multicast_req [4];
			assign cmd4_is_valid       = pipefull[4];
            
            assign cmd5_is_a_read      = pipe_read_req [5];
            assign cmd5_is_a_write     = pipe_write_req[5];
			assign cmd5_chip_addr      = pipe_chip_addr[5];
			assign cmd5_row_addr       = pipe_row_addr [5];
			assign cmd5_bank_addr      = pipe_bank_addr[5];
            assign cmd5_multicast_req  = pipe_multicast_req [5];
			assign cmd5_is_valid       = pipefull[5];
            
            assign cmd6_is_a_read      = pipe_read_req [6];
            assign cmd6_is_a_write     = pipe_write_req[6];
			assign cmd6_chip_addr      = pipe_chip_addr[6];  
			assign cmd6_row_addr       = pipe_row_addr [6];  
			assign cmd6_bank_addr      = pipe_bank_addr[6];   
            assign cmd6_multicast_req  = pipe_multicast_req [6];
			assign cmd6_is_valid       = pipefull[6];
            
            assign cmd7_is_a_read      = pipe_read_req [7];
            assign cmd7_is_a_write     = pipe_write_req[7];
			assign cmd7_chip_addr      = pipe_chip_addr[7];  
			assign cmd7_row_addr       = pipe_row_addr [7];  
			assign cmd7_bank_addr      = pipe_bank_addr[7];   
            assign cmd7_multicast_req  = pipe_multicast_req [7];
	        assign cmd7_is_valid       = pipefull[7];
        end
	    
	    else begin
            assign cmd4_is_a_read      = 0;
            assign cmd4_is_a_write     = 0;
		    assign cmd4_chip_addr      = 0;
			assign cmd4_row_addr       = 0;
			assign cmd4_bank_addr      = 0;
            assign cmd4_multicast_req  = 0;
			assign cmd4_is_valid       = 0;
            
            assign cmd5_is_a_read      = 0;
            assign cmd5_is_a_write     = 0;
			assign cmd5_chip_addr      = 0;
			assign cmd5_row_addr       = 0;
			assign cmd5_bank_addr      = 0;
            assign cmd5_multicast_req  = 0;
			assign cmd5_is_valid       = 0;
            
            assign cmd6_is_a_read      = 0;
            assign cmd6_is_a_write     = 0;
			assign cmd6_chip_addr      = 0;
			assign cmd6_row_addr       = 0;
			assign cmd6_bank_addr      = 0;
            assign cmd6_multicast_req  = 0;
			assign cmd6_is_valid       = 0;
            
            assign cmd7_is_a_read      = 0;
            assign cmd7_is_a_write     = 0;
			assign cmd7_chip_addr      = 0;
			assign cmd7_row_addr       = 0;
			assign cmd7_bank_addr      = 0;
            assign cmd7_multicast_req  = 0;
	        assign cmd7_is_valid       = 0;
	    end
	endgenerate
    
//======================  end of Bus to output signals mapping   ================  
	
//======================   sequential address detector   ========================
	
	//push cmd entry [0,1,2,3,4] to seq_entry [1,2,3,4,5]			
	generate 
        if (CTL_LOOK_AHEAD_DEPTH > 4) begin
            for(i=1; i<6; i=i+1) begin : seq_entry_loop1
                assign seq_entry[i] = {pipe_read_req[i-1],pipe_write_req[i-1],pipe_multicast_req[i-1],pipe_chip_addr[i-1],pipe_row_addr[i-1],pipe_bank_addr[i-1],pipe_col_addr[i-1]};
                assign prev_size[i] = pipe_burstcount[i-1];
            end
        end
        else begin
            for(i=1; i<5; i=i+1) begin : seq_entry_loop2
                assign seq_entry[i] = {pipe_read_req[i-1],pipe_write_req[i-1],pipe_multicast_req[i-1],pipe_chip_addr[i-1],pipe_row_addr[i-1],pipe_bank_addr[i-1],pipe_col_addr[i-1]};
                assign prev_size[i] = pipe_burstcount[i-1];
            end
                assign seq_entry[5] = 0;
                assign prev_size[5] = 0;
        end
	endgenerate 
    
	//push last_entry_written to seq_entry [0]
	assign seq_entry[0] = {last_read_req,last_write_req,last_multicast,last_chip_addr,last_row_addr,last_bank_addr,last_col_addr};
    assign prev_size[0] = last_size;
    
    //Check seq_entry of last_entry_written with pipe[0], pipe[0] with pipe[1], pipe[1] with pipe[2], pipe[2] with pipe[3], pipe[3] with pipe[4], pipe[4] with pipe[5]
    //(i) Make sure pipe_read_req, pipe_write_req, pipe_chip_addr, pipe_row_addr, pipe_bank_addr of two sequential addresses should be equal 
    //(ii) Make sure the difference between two sequential addresses is equal to the local_size from the later command
    //(iii) Make sure that the later command is a valid command.
    generate 
        if (CTL_LOOK_AHEAD_DEPTH > 4) begin
            for (i=0; i<5; i=i+1) begin : cmd_is_seq_loop1     
                assign minus_addr[i] = (seq_entry[i+1][MEM_IF_COL_WIDTH-1 : 0]) - (seq_entry[i][MEM_IF_COL_WIDTH-1 : 0]);
                assign cmd_is_seq[i] = pipefull[i] & (seq_entry[i+1][THIS_ENTRY_WIDTH-1 : MEM_IF_COL_WIDTH] == seq_entry[i][THIS_ENTRY_WIDTH-1 : MEM_IF_COL_WIDTH]) 
                                                    & (minus_addr[i] == prev_size[i])? 1'b1: 1'b0;
            end
        end
        else begin
            for (i=0; i<4; i=i+1) begin : cmd_is_seq_loop2      
                assign minus_addr[i] = (seq_entry[i+1][MEM_IF_COL_WIDTH-1 : 0]) - (seq_entry[i][MEM_IF_COL_WIDTH-1 : 0]);
                assign cmd_is_seq[i] = pipefull[i] & (seq_entry[i+1][THIS_ENTRY_WIDTH-1 : MEM_IF_COL_WIDTH] == seq_entry[i][THIS_ENTRY_WIDTH-1 : MEM_IF_COL_WIDTH]) 
                                                    & (minus_addr[i] == prev_size[i])? 1'b1: 1'b0;
            end
                assign minus_addr[4] = 0;
                assign cmd_is_seq[4] = 0;
        end
	endgenerate 
    
    generate 
        if (CTL_LOOK_AHEAD_DEPTH > 4) begin
            assign cmd0_is_sequential = cmd_is_seq[0];
            assign cmd1_is_sequential = cmd_is_seq[1];
            assign cmd2_is_sequential = cmd_is_seq[2];
            assign cmd3_is_sequential = cmd_is_seq[3];
            assign cmd4_is_sequential = cmd_is_seq[4];
        end
        else begin
            assign cmd0_is_sequential = cmd_is_seq[0];
            assign cmd1_is_sequential = cmd_is_seq[1];
            assign cmd2_is_sequential = cmd_is_seq[2];
            assign cmd3_is_sequential = cmd_is_seq[3];
            assign cmd4_is_sequential = 0;
        end
    endgenerate 
    
    assign cmd0_diff_cs = check_cs[0];
    assign cmd1_diff_cs = check_cs[1];
    assign cmd2_diff_cs = check_cs[2];
    assign cmd3_diff_cs = check_cs[3];
    
    assign check_cs[0] = (last_chip_addr != pipe_chip_addr[0]); 
        
    generate for(i=1; i<4; i=i+1) begin : check_cs_4_loop
            assign check_cs[i] = (pipe_chip_addr[i-1] != pipe_chip_addr[i]); 
    	end
	endgenerate 

	
//===================   end of sequential address detector   ====================

//===============================    queue    ===================================
    
	assign cmd_flush[0] = flush1;
	assign cmd_flush[1] = flush2; 
	assign cmd_flush[2] = flush3; 
    
    // avalon_write_req & avalon_read_req is AND with internal_ready in alt_ddrx_avalon_if.v
    assign wreq_to_fifo = (read_req_to_cmd_queue) | (write_req_to_cmd_queue);
    assign cmd_fifo_wren = (read_req_to_cmd_queue) | (write_req_to_cmd_queue);
	assign valid_rreq = fetch & !cmd_fifo_empty & !cmd_flush[0] & !cmd_flush[1] & !cmd_flush[2];	//fetch first entry, no flush
	assign cmd_fifo_empty = !pipefull[0];
	assign cmd_fifo_full = pipefull[CTL_CMD_QUEUE_DEPTH-1];	
      
        //Last pipeline entry
    always @(posedge ctl_clk or negedge ctl_reset_n) begin   
         if (!ctl_reset_n) begin
             last_read_req      <= 1'b0; 
             last_write_req     <= 1'b0; 
             last_chip_addr     <= {MEM_IF_CHIP_BITS{1'b0}}; 
             last_row_addr      <= {MEM_IF_ROW_WIDTH{1'b0}}; 
             last_bank_addr     <= {MEM_IF_BA_WIDTH{1'b0}}; 
             last_col_addr      <= {MEM_IF_COL_WIDTH{1'b0}}; 
             last_size          <= {LOCAL_SIZE_WIDTH{1'b0}}; 
             last_multicast     <= 1'b0;
         end
         else  if (valid_rreq) begin			 
                    last_read_req   <= pipe_read_req     [0];
                    last_write_req  <= pipe_write_req    [0];
                    last_chip_addr  <= pipe_chip_addr    [0];
                    last_row_addr   <= pipe_row_addr     [0];
                    last_bank_addr  <= pipe_bank_addr    [0];
                    last_col_addr   <= pipe_col_addr     [0];
                    last_size       <= pipe_burstcount   [0];
                    last_multicast  <= pipe_multicast_req[0];
         end
         else if (cmd_flush[0] & fetch) begin	
                  last_read_req   <= pipe_read_req     [1];
                  last_write_req  <= pipe_write_req    [1];
                  last_chip_addr  <= pipe_chip_addr    [1];
                  last_row_addr   <= pipe_row_addr     [1];
                  last_bank_addr  <= pipe_bank_addr    [1];
                  last_col_addr   <= pipe_col_addr     [1];
                  last_size       <= pipe_burstcount   [1];
                  last_multicast  <= pipe_multicast_req[1];
         end 
         else if (cmd_flush[1] & fetch) begin	
                  last_read_req   <= pipe_read_req     [2];
                  last_write_req  <= pipe_write_req    [2];
                  last_chip_addr  <= pipe_chip_addr    [2];
                  last_row_addr   <= pipe_row_addr     [2];
                  last_bank_addr  <= pipe_bank_addr    [2];
                  last_col_addr   <= pipe_col_addr     [2];
                  last_size       <= pipe_burstcount   [2];
                  last_multicast  <= pipe_multicast_req[2];
         end 
         else if (cmd_flush[2] & fetch) begin	
                  last_read_req   <= pipe_read_req     [3];
                  last_write_req  <= pipe_write_req    [3];
                  last_chip_addr  <= pipe_chip_addr    [3];
                  last_row_addr   <= pipe_row_addr     [3];
                  last_bank_addr  <= pipe_bank_addr    [3];
                  last_col_addr   <= pipe_col_addr     [3];
                  last_size       <= pipe_burstcount   [3];
                  last_multicast  <= pipe_multicast_req[3];
         end 
         else begin
                 last_chip_addr  <= current_chip_addr;
                 last_read_req   <= last_read_req ;
                 last_write_req  <= last_write_req;
                 last_row_addr   <= last_row_addr ;
                 last_bank_addr  <= last_bank_addr;
                 last_col_addr   <= last_col_addr ;
                 last_size       <= last_size;
                 last_multicast  <= last_multicast;
         end   
    end

    generate if(CTL_CMD_QUEUE_DEPTH > 4) begin
        //pipefull register chain
        //feed 0 to pipefull entry that is empty
        always @(posedge ctl_clk or negedge ctl_reset_n) begin
            if (!ctl_reset_n) begin
                for(j=0; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                    pipefull[j] <= 1'b0;
                end
            end
            else 
                if (cmd_flush[0] & fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+2];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end 
                else if (cmd_flush[1] & fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+3];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (cmd_flush[2] & fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-4; j=j+1) begin
                        if(pipefull[j+4] == 1'b0 & pipefull[j+3] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+4];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-4] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (cmd_flush[0] & !fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                        if(pipefull[j+1] == 1'b0 & pipefull[j] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+1];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end 
                else if (cmd_flush[1] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+2];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (cmd_flush[2] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+3];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (valid_rreq) begin                    // fetch only
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                        if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+1];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= pipefull[CTL_CMD_QUEUE_DEPTH-1] & wreq_to_fifo;
                end
                else if (wreq_to_fifo & !fetch & !cmd_flush[0] & !cmd_flush[1] & !cmd_flush[2]) begin   // write only
                    for(j=1; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                        if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0)
                            pipefull[j] <= 1'b1;
                    end
                    if(pipefull[0] == 1'b0)
                        pipefull[0] <= 1'b1;
                end 
        end
        
        //pipe register chain
        always @(posedge ctl_clk or negedge ctl_reset_n) begin
        if (!ctl_reset_n) begin
            for(j=0; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                pipe[j] <= 0;
            end
        end
        else 
            if (cmd_flush[0] & fetch) begin   
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                    if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+2];
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-2] <= buffer_input;
            end 
            else if (cmd_flush[1] & fetch) begin  
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                    if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+3];
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-3] <= buffer_input;
            end
            else if (cmd_flush[2] & fetch) begin  
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-4; j=j+1) begin
                    if(pipefull[j+4] == 1'b0 & pipefull[j+3] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+4];
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                pipe[CTL_CMD_QUEUE_DEPTH-3] <= pipe[CTL_CMD_QUEUE_DEPTH-3];
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-4] <= buffer_input;
            end
            else if (cmd_flush[0] & !fetch) begin   
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                    if(pipefull[j+1] == 1'b0 & pipefull[j] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+1];
                end
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= buffer_input;
            end 
            else if (cmd_flush[1] & !fetch) begin  
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                    if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+2];
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-2] <= buffer_input;
            end
            else if (cmd_flush[2] & !fetch) begin  
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                    if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                        pipe[j] <= buffer_input;
                    else
                        pipe[j] <= pipe[j+3];
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                    pipe[CTL_CMD_QUEUE_DEPTH-3] <= buffer_input;
            end
            else if (valid_rreq) begin                    // fetch only
                for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                    if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0) begin
                        pipe[j] <= buffer_input;
                    end
                    else begin
                        pipe[j] <= pipe[j+1];
                    end
                end
                pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1] & buffer_input;
            end
            else if (wreq_to_fifo & !fetch & !cmd_flush[0] & !cmd_flush[1] & !cmd_flush[2]) begin         
                for(j=1; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                    if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0)
                        pipe[j] <= buffer_input;
                end
                if(pipefull[0] == 1'b0)
                    pipe[0] <= buffer_input;
            end 
       end
    end
    else begin                                  // for CTL_CMD_QUEUE_DEPTH == 4
        //pipefull register chain
        always @(posedge ctl_clk or negedge ctl_reset_n) begin
            if (!ctl_reset_n) begin
                for(j=0; j<CTL_CMD_QUEUE_DEPTH; j=j+1'b1) begin
                    pipefull[j] <= 1'b0;
                end
            end
            else 
                if (cmd_flush[0] & fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1'b1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+2];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end 
                else if (cmd_flush[1] & fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1'b1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+3];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (cmd_flush[2] & fetch) begin  
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-4] <= wreq_to_fifo; 
                end
                else if (cmd_flush[0] & !fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                        if(pipefull[j+1] == 1'b0 & pipefull[j] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+1];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end 
                else if (cmd_flush[1] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+2];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (cmd_flush[2] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+3];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-2] <= 1'b0;
                    pipefull[CTL_CMD_QUEUE_DEPTH-3] <= wreq_to_fifo & pipefull[CTL_CMD_QUEUE_DEPTH-1];
                end
                else if (valid_rreq) begin                    // fetch only
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1'b1) begin
                        if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                            pipefull[j] <= wreq_to_fifo;
                        else
                            pipefull[j] <= pipefull[j+1];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= pipefull[CTL_CMD_QUEUE_DEPTH-1] & wreq_to_fifo;
                end
                else if (wreq_to_fifo & !fetch & !cmd_flush[0] & !cmd_flush[1] & !cmd_flush[2]) begin    // write only
                    for(j=1; j<CTL_CMD_QUEUE_DEPTH; j=j+1'b1) begin
                        if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0)
                            pipefull[j] <= 1'b1;
                    end
                    if(pipefull[0] == 1'b0)
                        pipefull[0] <= 1'b1;
                end 
        end
        
        //pipe register chain
        always @(posedge ctl_clk or negedge ctl_reset_n) begin
            if (!ctl_reset_n) begin
                for(j=0; j<CTL_CMD_QUEUE_DEPTH; j=j+1'b1) begin
                    pipe[j] <= 0;
                end
            end
            else 
                if (cmd_flush[0] & fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1'b1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipe[j] <= buffer_input;
                        else
                            pipe[j] <= pipe[j+2];
                    end
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= 0;
                    if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                        pipe[CTL_CMD_QUEUE_DEPTH-2] <= buffer_input;
                end 
                else if (cmd_flush[1] & fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1'b1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipe[j] <= buffer_input;
                        else
                            pipe[j] <= pipe[j+3];
                    end
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                    pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                    if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                        pipe[CTL_CMD_QUEUE_DEPTH-3] <= buffer_input;
                end
                else if (cmd_flush[2] & fetch) begin  
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                    pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                    pipe[CTL_CMD_QUEUE_DEPTH-3] <= pipe[CTL_CMD_QUEUE_DEPTH-3];
                    pipe[CTL_CMD_QUEUE_DEPTH-4] <= buffer_input;
                end
                else if (cmd_flush[0] & !fetch) begin   
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                        if(pipefull[j+1] == 1'b0 & pipefull[j] == 1'b1)
                            pipe[j] <= buffer_input;
                        else
                            pipe[j] <= pipe[j+1];
                    end
                    if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                        pipe[CTL_CMD_QUEUE_DEPTH-1] <= buffer_input;
                end 
                else if (cmd_flush[1] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-2; j=j+1) begin
                        if(pipefull[j+2] == 1'b0 & pipefull[j+1] == 1'b1)
                            pipe[j] <= buffer_input;
                        else
                            pipe[j] <= pipe[j+2];
                    end
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                    if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                        pipe[CTL_CMD_QUEUE_DEPTH-2] <= buffer_input;
                end
                else if (cmd_flush[2] & !fetch) begin  
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-3; j=j+1) begin
                        if(pipefull[j+3] == 1'b0 & pipefull[j+2] == 1'b1)
                            pipe[j] <= buffer_input;
                        else
                            pipe[j] <= pipe[j+3];
                    end
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1];
                    pipe[CTL_CMD_QUEUE_DEPTH-2] <= pipe[CTL_CMD_QUEUE_DEPTH-2];
                    if(pipefull[CTL_CMD_QUEUE_DEPTH-1] == 1'b1)
                        pipe[CTL_CMD_QUEUE_DEPTH-3] <= buffer_input;
                end
                else if (valid_rreq) begin                    // fetch only
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1'b1) begin
                        if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0) begin
                            pipe[j] <= buffer_input;
                        end
                        else begin
                            pipe[j] <= pipe[j+1];
                        end
                    end
                    pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1] & buffer_input;
                end
                else if (wreq_to_fifo & !fetch & !cmd_flush[0] & !cmd_flush[1] & !cmd_flush[2]) begin         
                    for(j=1; j<CTL_CMD_QUEUE_DEPTH; j=j+1'b1) begin
                        if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0)
                            pipe[j] <= buffer_input;
                    end
                    if(pipefull[0] == 1'b0)
                        pipe[0] <= buffer_input;
                end 
           end
    end
    endgenerate
    
//============================    end of queue    ===============================  

    function integer log2;  //constant function
           input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
    endfunction
    
endmodule
