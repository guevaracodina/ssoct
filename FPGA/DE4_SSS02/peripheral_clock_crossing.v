//Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing_downstream_fifo (
                                                   // inputs:
                                                    aclr,
                                                    data,
                                                    rdclk,
                                                    rdreq,
                                                    wrclk,
                                                    wrreq,

                                                   // outputs:
                                                    q,
                                                    rdempty,
                                                    wrfull
                                                 )
;

  output  [ 47: 0] q;
  output           rdempty;
  output           wrfull;
  input            aclr;
  input   [ 47: 0] data;
  input            rdclk;
  input            rdreq;
  input            wrclk;
  input            wrreq;

  wire    [ 47: 0] q;
  wire             rdempty;
  wire             wrfull;
  dcfifo downstream_fifo
    (
      .aclr (aclr),
      .data (data),
      .q (q),
      .rdclk (rdclk),
      .rdempty (rdempty),
      .rdreq (rdreq),
      .wrclk (wrclk),
      .wrfull (wrfull),
      .wrreq (wrreq)
    );

  defparam downstream_fifo.intended_device_family = "STRATIXIV",
           downstream_fifo.lpm_numwords = 16,
           downstream_fifo.lpm_showahead = "OFF",
           downstream_fifo.lpm_type = "dcfifo",
           downstream_fifo.lpm_width = 48,
           downstream_fifo.lpm_widthu = 4,
           downstream_fifo.overflow_checking = "ON",
           downstream_fifo.rdsync_delaypipe = 5,
           downstream_fifo.underflow_checking = "ON",
           downstream_fifo.use_eab = "ON",
           downstream_fifo.wrsync_delaypipe = 5;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing_upstream_fifo (
                                                 // inputs:
                                                  aclr,
                                                  data,
                                                  rdclk,
                                                  rdreq,
                                                  wrclk,
                                                  wrreq,

                                                 // outputs:
                                                  q,
                                                  rdempty,
                                                  wrusedw
                                               )
;

  output  [ 32: 0] q;
  output           rdempty;
  output  [  5: 0] wrusedw;
  input            aclr;
  input   [ 32: 0] data;
  input            rdclk;
  input            rdreq;
  input            wrclk;
  input            wrreq;

  wire    [ 32: 0] q;
  wire             rdempty;
  wire    [  5: 0] wrusedw;
  dcfifo upstream_fifo
    (
      .aclr (aclr),
      .data (data),
      .q (q),
      .rdclk (rdclk),
      .rdempty (rdempty),
      .rdreq (rdreq),
      .wrclk (wrclk),
      .wrreq (wrreq),
      .wrusedw (wrusedw)
    );

  defparam upstream_fifo.intended_device_family = "STRATIXIV",
           upstream_fifo.lpm_numwords = 64,
           upstream_fifo.lpm_showahead = "OFF",
           upstream_fifo.lpm_type = "dcfifo",
           upstream_fifo.lpm_width = 33,
           upstream_fifo.lpm_widthu = 6,
           upstream_fifo.overflow_checking = "ON",
           upstream_fifo.rdsync_delaypipe = 5,
           upstream_fifo.underflow_checking = "ON",
           upstream_fifo.use_eab = "ON",
           upstream_fifo.wrsync_delaypipe = 5;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing (
                                   // inputs:
                                    master_clk,
                                    master_endofpacket,
                                    master_readdata,
                                    master_readdatavalid,
                                    master_reset_n,
                                    master_waitrequest,
                                    slave_address,
                                    slave_byteenable,
                                    slave_clk,
                                    slave_nativeaddress,
                                    slave_read,
                                    slave_reset_n,
                                    slave_write,
                                    slave_writedata,

                                   // outputs:
                                    master_address,
                                    master_byteenable,
                                    master_nativeaddress,
                                    master_read,
                                    master_write,
                                    master_writedata,
                                    slave_endofpacket,
                                    slave_readdata,
                                    slave_readdatavalid,
                                    slave_waitrequest
                                 )
;

  output  [  6: 0] master_address;
  output  [  3: 0] master_byteenable;
  output  [  4: 0] master_nativeaddress;
  output           master_read;
  output           master_write;
  output  [ 31: 0] master_writedata;
  output           slave_endofpacket;
  output  [ 31: 0] slave_readdata;
  output           slave_readdatavalid;
  output           slave_waitrequest;
  input            master_clk;
  input            master_endofpacket;
  input   [ 31: 0] master_readdata;
  input            master_readdatavalid;
  input            master_reset_n;
  input            master_waitrequest;
  input   [  4: 0] slave_address;
  input   [  3: 0] slave_byteenable;
  input            slave_clk;
  input   [  4: 0] slave_nativeaddress;
  input            slave_read;
  input            slave_reset_n;
  input            slave_write;
  input   [ 31: 0] slave_writedata;

  wire    [ 47: 0] downstream_data_in;
  wire    [ 47: 0] downstream_data_out;
  wire             downstream_rdempty;
  reg              downstream_rdempty_delayed_n;
  wire             downstream_rdreq;
  wire             downstream_wrfull;
  wire             downstream_wrreq;
  reg              downstream_wrreq_delayed;
  wire    [  4: 0] internal_master_address;
  wire             internal_master_read;
  wire             internal_master_write;
  wire    [  6: 0] master_address;
  wire    [  6: 0] master_byte_address;
  wire    [  3: 0] master_byteenable;
  wire             master_hold_read;
  wire             master_hold_write;
  wire    [  4: 0] master_nativeaddress;
  wire             master_new_read;
  wire             master_new_read_term_one;
  wire             master_new_read_term_two;
  wire             master_new_write;
  wire             master_new_write_term_one;
  wire             master_new_write_term_two;
  wire             master_read;
  wire             master_read_write_unchanged_on_wait;
  reg              master_waitrequest_delayed;
  wire             master_write;
  wire    [ 31: 0] master_writedata;
  wire             slave_endofpacket;
  wire    [ 31: 0] slave_readdata;
  reg              slave_readdatavalid;
  wire             slave_waitrequest;
  wire    [ 32: 0] upstream_data_in;
  wire    [ 32: 0] upstream_data_out;
  wire             upstream_rdempty;
  wire             upstream_rdreq;
  wire             upstream_write_almost_full;
  reg              upstream_write_almost_full_delayed;
  wire             upstream_wrreq;
  wire    [  5: 0] upstream_wrusedw;
  //s1, which is an e_avalon_slave
  //m1, which is an e_avalon_master
  assign upstream_data_in = {master_readdata, master_endofpacket};
  assign {slave_readdata, slave_endofpacket} = upstream_data_out;
  assign downstream_data_in = {slave_writedata, slave_address, slave_read, slave_write, slave_nativeaddress, slave_byteenable};
  assign {master_writedata, internal_master_address, internal_master_read, internal_master_write, master_nativeaddress, master_byteenable} = downstream_data_out;
  //the_downstream_fifo, which is an e_instance
  peripheral_clock_crossing_downstream_fifo the_downstream_fifo
    (
      .aclr    (~slave_reset_n),
      .data    (downstream_data_in),
      .q       (downstream_data_out),
      .rdclk   (master_clk),
      .rdempty (downstream_rdempty),
      .rdreq   (downstream_rdreq),
      .wrclk   (slave_clk),
      .wrfull  (downstream_wrfull),
      .wrreq   (downstream_wrreq)
    );

  assign downstream_wrreq = slave_read | slave_write | downstream_wrreq_delayed;
  assign slave_waitrequest = downstream_wrfull;
  assign downstream_rdreq = !downstream_rdempty & !master_waitrequest & !upstream_write_almost_full;
  assign upstream_write_almost_full = upstream_wrusedw >= 15;
  always @(posedge slave_clk or negedge slave_reset_n)
    begin
      if (slave_reset_n == 0)
          downstream_wrreq_delayed <= 0;
      else 
        downstream_wrreq_delayed <= slave_read | slave_write;
    end


  assign master_new_read_term_one = internal_master_read & downstream_rdempty_delayed_n;
  assign master_new_read_term_two = !master_read_write_unchanged_on_wait & !upstream_write_almost_full_delayed;
  assign master_new_read = master_new_read_term_one & master_new_read_term_two;
  assign master_hold_read = master_read_write_unchanged_on_wait & internal_master_read;
  assign master_new_write_term_one = internal_master_write & downstream_rdempty_delayed_n;
  assign master_new_write_term_two = !master_read_write_unchanged_on_wait & !upstream_write_almost_full_delayed;
  assign master_new_write = master_new_write_term_one & master_new_write_term_two;
  assign master_hold_write = master_read_write_unchanged_on_wait & internal_master_write;
  assign master_read_write_unchanged_on_wait = master_waitrequest_delayed;
  always @(posedge master_clk or negedge master_reset_n)
    begin
      if (master_reset_n == 0)
          master_waitrequest_delayed <= 0;
      else 
        master_waitrequest_delayed <= master_waitrequest;
    end


  assign master_read = master_new_read | master_hold_read;
  assign master_write = master_new_write | master_hold_write;
  always @(posedge master_clk or negedge master_reset_n)
    begin
      if (master_reset_n == 0)
          downstream_rdempty_delayed_n <= 0;
      else 
        downstream_rdempty_delayed_n <= !downstream_rdempty;
    end


  always @(posedge master_clk or negedge master_reset_n)
    begin
      if (master_reset_n == 0)
          upstream_write_almost_full_delayed <= 0;
      else 
        upstream_write_almost_full_delayed <= upstream_write_almost_full;
    end


  assign master_byte_address = {internal_master_address, 2'b0};
  assign master_address = master_byte_address;
  //the_upstream_fifo, which is an e_instance
  peripheral_clock_crossing_upstream_fifo the_upstream_fifo
    (
      .aclr    (~master_reset_n),
      .data    (upstream_data_in),
      .q       (upstream_data_out),
      .rdclk   (slave_clk),
      .rdempty (upstream_rdempty),
      .rdreq   (upstream_rdreq),
      .wrclk   (master_clk),
      .wrreq   (upstream_wrreq),
      .wrusedw (upstream_wrusedw)
    );

  assign upstream_wrreq = master_readdatavalid;
  assign upstream_rdreq = !upstream_rdempty;
  always @(posedge slave_clk or negedge slave_reset_n)
    begin
      if (slave_reset_n == 0)
          slave_readdatavalid <= 0;
      else 
        slave_readdatavalid <= !upstream_rdempty;
    end



endmodule

