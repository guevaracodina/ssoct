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

ext_flash_lane1_module ext_flash_lane1_module_inst
(
	.data(data_sig) ,	// input [7:0] data_sig
	.rdaddress(rdaddress_sig) ,	// input [24:0] rdaddress_sig
	.rdclken(rdclken_sig) ,	// input  rdclken_sig
	.wraddress(wraddress_sig) ,	// input [24:0] wraddress_sig
	.wrclock(wrclock_sig) ,	// input  wrclock_sig
	.wren(wren_sig) ,	// input  wren_sig
	.q(q_sig) 	// output [7:0] q_sig
);
