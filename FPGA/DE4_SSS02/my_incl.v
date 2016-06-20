// my_incl.v

// If we have not included file before,
// this symbol _my_incl_v_ is not defined.
`ifndef _my_incl_v_
	`define _my_incl_v_
	// Start of include contents
	`define NET0							// Ethernet PHY 0
	//`define NET1
	//`define NET2
	//`define NET3
	
	//`define USE_DDR2_DIMM2				// Use DIMM 2 for DDR2
	
	`define NSAMPLES 11'd1170				// Number of samples per A-line
	`define NLINESPERFRAME 16'1000			// Number of A-lines per frame
	`define NFRAMES 16'30					// Number of total frames to grab
`endif //_my_incl_v_

// Then, in any module where we need these definitions:
//  
// `include "my_incl.v"
//
// module top(
//	input 						clk,
//	input 	[`NSAMPLES - 1:0] 	in1,
//	output 	[`NSAMPLES - 1:0] 	q
//	);
// m1 u1(.clk(clk), .in1(in1), .q(q));
////...
// endmodule