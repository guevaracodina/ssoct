// Copyright (C) 1991-2010 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.


// Generated by Quartus II 64-Bit Version 9.1 (Build Build 350 03/24/2010)
// Created on Thu Nov 10 19:33:38 2011

ddr2_s1_arbitrator ddr2_s1_arbitrator_inst
(
	.DE4_SOPC_burst_0_downstream_address_to_slave(DE4_SOPC_burst_0_downstream_address_to_slave_sig) ,	// input [29:0] DE4_SOPC_burst_0_downstream_address_to_slave_sig
	.DE4_SOPC_burst_0_downstream_arbitrationshare(DE4_SOPC_burst_0_downstream_arbitrationshare_sig) ,	// input [3:0] DE4_SOPC_burst_0_downstream_arbitrationshare_sig
	.DE4_SOPC_burst_0_downstream_burstcount(DE4_SOPC_burst_0_downstream_burstcount_sig) ,	// input [2:0] DE4_SOPC_burst_0_downstream_burstcount_sig
	.DE4_SOPC_burst_0_downstream_byteenable(DE4_SOPC_burst_0_downstream_byteenable_sig) ,	// input [31:0] DE4_SOPC_burst_0_downstream_byteenable_sig
	.DE4_SOPC_burst_0_downstream_latency_counter(DE4_SOPC_burst_0_downstream_latency_counter_sig) ,	// input  DE4_SOPC_burst_0_downstream_latency_counter_sig
	.DE4_SOPC_burst_0_downstream_read(DE4_SOPC_burst_0_downstream_read_sig) ,	// input  DE4_SOPC_burst_0_downstream_read_sig
	.DE4_SOPC_burst_0_downstream_write(DE4_SOPC_burst_0_downstream_write_sig) ,	// input  DE4_SOPC_burst_0_downstream_write_sig
	.DE4_SOPC_burst_0_downstream_writedata(DE4_SOPC_burst_0_downstream_writedata_sig) ,	// input [255:0] DE4_SOPC_burst_0_downstream_writedata_sig
	.clk(clk_sig) ,	// input  clk_sig
	.ddr2_s1_readdata(ddr2_s1_readdata_sig) ,	// input [255:0] ddr2_s1_readdata_sig
	.ddr2_s1_readdatavalid(ddr2_s1_readdatavalid_sig) ,	// input  ddr2_s1_readdatavalid_sig
	.ddr2_s1_resetrequest_n(ddr2_s1_resetrequest_n_sig) ,	// input  ddr2_s1_resetrequest_n_sig
	.ddr2_s1_waitrequest_n(ddr2_s1_waitrequest_n_sig) ,	// input  ddr2_s1_waitrequest_n_sig
	.pipeline_bridge_ddr2_m1_address_to_slave(pipeline_bridge_ddr2_m1_address_to_slave_sig) ,	// input [29:0] pipeline_bridge_ddr2_m1_address_to_slave_sig
	.pipeline_bridge_ddr2_m1_burstcount(pipeline_bridge_ddr2_m1_burstcount_sig) ,	// input  pipeline_bridge_ddr2_m1_burstcount_sig
	.pipeline_bridge_ddr2_m1_byteenable(pipeline_bridge_ddr2_m1_byteenable_sig) ,	// input [3:0] pipeline_bridge_ddr2_m1_byteenable_sig
	.pipeline_bridge_ddr2_m1_chipselect(pipeline_bridge_ddr2_m1_chipselect_sig) ,	// input  pipeline_bridge_ddr2_m1_chipselect_sig
	.pipeline_bridge_ddr2_m1_latency_counter(pipeline_bridge_ddr2_m1_latency_counter_sig) ,	// input  pipeline_bridge_ddr2_m1_latency_counter_sig
	.pipeline_bridge_ddr2_m1_read(pipeline_bridge_ddr2_m1_read_sig) ,	// input  pipeline_bridge_ddr2_m1_read_sig
	.pipeline_bridge_ddr2_m1_write(pipeline_bridge_ddr2_m1_write_sig) ,	// input  pipeline_bridge_ddr2_m1_write_sig
	.pipeline_bridge_ddr2_m1_writedata(pipeline_bridge_ddr2_m1_writedata_sig) ,	// input [31:0] pipeline_bridge_ddr2_m1_writedata_sig
	.reset_n(reset_n_sig) ,	// input  reset_n_sig
	.DE4_SOPC_burst_0_downstream_granted_ddr2_s1(DE4_SOPC_burst_0_downstream_granted_ddr2_s1_sig) ,	// output  DE4_SOPC_burst_0_downstream_granted_ddr2_s1_sig
	.DE4_SOPC_burst_0_downstream_qualified_request_ddr2_s1(DE4_SOPC_burst_0_downstream_qualified_request_ddr2_s1_sig) ,	// output  DE4_SOPC_burst_0_downstream_qualified_request_ddr2_s1_sig
	.DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1(DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1_sig) ,	// output  DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1_sig
	.DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1_shift_register(DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1_shift_register_sig) ,	// output  DE4_SOPC_burst_0_downstream_read_data_valid_ddr2_s1_shift_register_sig
	.DE4_SOPC_burst_0_downstream_requests_ddr2_s1(DE4_SOPC_burst_0_downstream_requests_ddr2_s1_sig) ,	// output  DE4_SOPC_burst_0_downstream_requests_ddr2_s1_sig
	.d1_ddr2_s1_end_xfer(d1_ddr2_s1_end_xfer_sig) ,	// output  d1_ddr2_s1_end_xfer_sig
	.ddr2_s1_address(ddr2_s1_address_sig) ,	// output [24:0] ddr2_s1_address_sig
	.ddr2_s1_beginbursttransfer(ddr2_s1_beginbursttransfer_sig) ,	// output  ddr2_s1_beginbursttransfer_sig
	.ddr2_s1_burstcount(ddr2_s1_burstcount_sig) ,	// output [2:0] ddr2_s1_burstcount_sig
	.ddr2_s1_byteenable(ddr2_s1_byteenable_sig) ,	// output [31:0] ddr2_s1_byteenable_sig
	.ddr2_s1_read(ddr2_s1_read_sig) ,	// output  ddr2_s1_read_sig
	.ddr2_s1_readdata_from_sa(ddr2_s1_readdata_from_sa_sig) ,	// output [255:0] ddr2_s1_readdata_from_sa_sig
	.ddr2_s1_resetrequest_n_from_sa(ddr2_s1_resetrequest_n_from_sa_sig) ,	// output  ddr2_s1_resetrequest_n_from_sa_sig
	.ddr2_s1_waitrequest_n_from_sa(ddr2_s1_waitrequest_n_from_sa_sig) ,	// output  ddr2_s1_waitrequest_n_from_sa_sig
	.ddr2_s1_write(ddr2_s1_write_sig) ,	// output  ddr2_s1_write_sig
	.ddr2_s1_writedata(ddr2_s1_writedata_sig) ,	// output [255:0] ddr2_s1_writedata_sig
	.pipeline_bridge_ddr2_m1_granted_ddr2_s1(pipeline_bridge_ddr2_m1_granted_ddr2_s1_sig) ,	// output  pipeline_bridge_ddr2_m1_granted_ddr2_s1_sig
	.pipeline_bridge_ddr2_m1_qualified_request_ddr2_s1(pipeline_bridge_ddr2_m1_qualified_request_ddr2_s1_sig) ,	// output  pipeline_bridge_ddr2_m1_qualified_request_ddr2_s1_sig
	.pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1(pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1_sig) ,	// output  pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1_sig
	.pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1_shift_register(pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1_shift_register_sig) ,	// output  pipeline_bridge_ddr2_m1_read_data_valid_ddr2_s1_shift_register_sig
	.pipeline_bridge_ddr2_m1_requests_ddr2_s1(pipeline_bridge_ddr2_m1_requests_ddr2_s1_sig) 	// output  pipeline_bridge_ddr2_m1_requests_ddr2_s1_sig
);
