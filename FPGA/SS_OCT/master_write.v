// master_write.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module master_write (
		input  wire         clk,                    //   clock_reset.clk
		input  wire         reset,                  //              .reset
		output wire [29:0]  master_address,         // avalon_master.address
		output wire         master_write,           //              .write
		output wire [31:0]  master_byteenable,      //              .byteenable
		output wire [255:0] master_writedata,       //              .writedata
		output wire [3:0]   master_burstcount,      //              .burstcount
		input  wire         master_waitrequest,     //              .waitrequest
		input  wire         control_fixed_location, //       control.export
		input  wire [29:0]  control_write_base,     //              .export
		input  wire [29:0]  control_write_length,   //              .export
		input  wire         control_go,             //              .export
		output wire         control_done,           //              .export
		input  wire         user_write_buffer,      //          user.export
		input  wire [255:0] user_buffer_input_data, //              .export
		output wire         user_buffer_full        //              .export
	);

	custom_master #(
		.MASTER_DIRECTION    (1),
		.DATA_WIDTH          (256),
		.ADDRESS_WIDTH       (30),
		.BURST_CAPABLE       (1),
		.MAXIMUM_BURST_COUNT (8),
		.BURST_COUNT_WIDTH   (4),
		.FIFO_DEPTH          (32),
		.FIFO_DEPTH_LOG2     (5),
		.MEMORY_BASED_FIFO   (1)
	) master_write_inst (
		.clk                     (clk),                                                                                                                                                                                                                                                                   //   clock_reset.clk
		.reset                   (reset),                                                                                                                                                                                                                                                                 //              .reset
		.master_address          (master_address),                                                                                                                                                                                                                                                        // avalon_master.address
		.master_write            (master_write),                                                                                                                                                                                                                                                          //              .write
		.master_byteenable       (master_byteenable),                                                                                                                                                                                                                                                     //              .byteenable
		.master_writedata        (master_writedata),                                                                                                                                                                                                                                                      //              .writedata
		.master_burstcount       (master_burstcount),                                                                                                                                                                                                                                                     //              .burstcount
		.master_waitrequest      (master_waitrequest),                                                                                                                                                                                                                                                    //              .waitrequest
		.control_fixed_location  (control_fixed_location),                                                                                                                                                                                                                                                //       control.export
		.control_write_base      (control_write_base),                                                                                                                                                                                                                                                    //              .export
		.control_write_length    (control_write_length),                                                                                                                                                                                                                                                  //              .export
		.control_go              (control_go),                                                                                                                                                                                                                                                            //              .export
		.control_done            (control_done),                                                                                                                                                                                                                                                          //              .export
		.user_write_buffer       (user_write_buffer),                                                                                                                                                                                                                                                     //          user.export
		.user_buffer_input_data  (user_buffer_input_data),                                                                                                                                                                                                                                                //              .export
		.user_buffer_full        (user_buffer_full),                                                                                                                                                                                                                                                      //              .export
		.master_read             (),                                                                                                                                                                                                                                                                      //   (terminated)
		.master_readdata         (256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000), //   (terminated)
		.master_readdatavalid    (1'b0),                                                                                                                                                                                                                                                                  //   (terminated)
		.control_read_base       (30'b000000000000000000000000000000),                                                                                                                                                                                                                                    //   (terminated)
		.control_read_length     (30'b000000000000000000000000000000),                                                                                                                                                                                                                                    //   (terminated)
		.control_early_done      (),                                                                                                                                                                                                                                                                      //   (terminated)
		.user_read_buffer        (1'b0),                                                                                                                                                                                                                                                                  //   (terminated)
		.user_buffer_output_data (),                                                                                                                                                                                                                                                                      //   (terminated)
		.user_data_available     ()                                                                                                                                                                                                                                                                       //   (terminated)
	);

endmodule
