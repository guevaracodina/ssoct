// master_read.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module master_read (
		input  wire         clk,                     //   clock_reset.clk
		input  wire         reset,                   //              .reset
		output wire [29:0]  master_address,          // avalon_master.address
		output wire         master_read,             //              .read
		output wire [31:0]  master_byteenable,       //              .byteenable
		input  wire [255:0] master_readdata,         //              .readdata
		input  wire         master_readdatavalid,    //              .readdatavalid
		output wire [3:0]   master_burstcount,       //              .burstcount
		input  wire         master_waitrequest,      //              .waitrequest
		input  wire         control_fixed_location,  //       control.export
		input  wire [29:0]  control_read_base,       //              .export
		input  wire [29:0]  control_read_length,     //              .export
		input  wire         control_go,              //              .export
		output wire         control_done,            //              .export
		output wire         control_early_done,      //              .export
		input  wire         user_read_buffer,        //          user.export
		output wire [255:0] user_buffer_output_data, //              .export
		output wire         user_data_available      //              .export
	);

	custom_master #(
		.MASTER_DIRECTION    (0),
		.DATA_WIDTH          (256),
		.ADDRESS_WIDTH       (30),
		.BURST_CAPABLE       (1),
		.MAXIMUM_BURST_COUNT (8),
		.BURST_COUNT_WIDTH   (4),
		.FIFO_DEPTH          (32),
		.FIFO_DEPTH_LOG2     (5),
		.MEMORY_BASED_FIFO   (1)
	) master_read_inst (
		.clk                     (clk),                                                                                                                                                                                                                                                                   //   clock_reset.clk
		.reset                   (reset),                                                                                                                                                                                                                                                                 //              .reset
		.master_address          (master_address),                                                                                                                                                                                                                                                        // avalon_master.address
		.master_read             (master_read),                                                                                                                                                                                                                                                           //              .read
		.master_byteenable       (master_byteenable),                                                                                                                                                                                                                                                     //              .byteenable
		.master_readdata         (master_readdata),                                                                                                                                                                                                                                                       //              .readdata
		.master_readdatavalid    (master_readdatavalid),                                                                                                                                                                                                                                                  //              .readdatavalid
		.master_burstcount       (master_burstcount),                                                                                                                                                                                                                                                     //              .burstcount
		.master_waitrequest      (master_waitrequest),                                                                                                                                                                                                                                                    //              .waitrequest
		.control_fixed_location  (control_fixed_location),                                                                                                                                                                                                                                                //       control.export
		.control_read_base       (control_read_base),                                                                                                                                                                                                                                                     //              .export
		.control_read_length     (control_read_length),                                                                                                                                                                                                                                                   //              .export
		.control_go              (control_go),                                                                                                                                                                                                                                                            //              .export
		.control_done            (control_done),                                                                                                                                                                                                                                                          //              .export
		.control_early_done      (control_early_done),                                                                                                                                                                                                                                                    //              .export
		.user_read_buffer        (user_read_buffer),                                                                                                                                                                                                                                                      //          user.export
		.user_buffer_output_data (user_buffer_output_data),                                                                                                                                                                                                                                               //              .export
		.user_data_available     (user_data_available),                                                                                                                                                                                                                                                   //              .export
		.master_write            (),                                                                                                                                                                                                                                                                      //   (terminated)
		.master_writedata        (),                                                                                                                                                                                                                                                                      //   (terminated)
		.control_write_base      (30'b000000000000000000000000000000),                                                                                                                                                                                                                                    //   (terminated)
		.control_write_length    (30'b000000000000000000000000000000),                                                                                                                                                                                                                                    //   (terminated)
		.user_write_buffer       (1'b0),                                                                                                                                                                                                                                                                  //   (terminated)
		.user_buffer_input_data  (256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000), //   (terminated)
		.user_buffer_full        ()                                                                                                                                                                                                                                                                       //   (terminated)
	);

endmodule
