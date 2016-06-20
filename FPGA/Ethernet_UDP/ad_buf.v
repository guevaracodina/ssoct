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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ad_buf (
                // inputs:
                 a2dc,
                 adclk,
                 addr,
                 cs_n,
                 rd,
                 rdclk,
                 rst_n,
                 wrclk,

                // outputs:
                 a2do,
                 waitreq
              )
;

  output  [ 31: 0] a2do;
  output           waitreq;
  input   [ 11: 0] a2dc;
  input            adclk;
  input   [ 11: 0] addr;
  input            cs_n;
  input            rd;
  input            rdclk;
  input            rst_n;
  input            wrclk;

  wire    [ 31: 0] a2do;
  wire             waitreq;
  adBUF the_adBUF
    (
      .a2dc    (a2dc),
      .a2do    (a2do),
      .adclk   (adclk),
      .addr    (addr),
      .cs_n    (cs_n),
      .rd      (rd),
      .rdclk   (rdclk),
      .rst_n   (rst_n),
      .waitreq (waitreq),
      .wrclk   (wrclk)
    );
  defparam the_adBUF.BUFFER0 = 1,
           the_adBUF.BUFFER1 = 2,
           the_adBUF.INITIAL = 0;


endmodule

