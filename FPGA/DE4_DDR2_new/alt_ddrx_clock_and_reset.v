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
// Title         : DDR controller Clock and Reset
//
// File          : alt_ddrx_clock_and_reset.v
//
// Abstract      : Clock and reset
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_clock_and_reset #
    ( parameter
        DWIDTH_RATIO = "2"
    )
    (
        // Inputs
        ctl_full_clk,
        ctl_half_clk,
        ctl_quater_clk,
        //csr_clk,
        reset_phy_clk_n,
        
        // Outputs
        ctl_clk,
        ctl_reset_n
    );

input ctl_full_clk;
input ctl_half_clk;
input ctl_quater_clk;
//input csr_clk;
input reset_phy_clk_n;

output ctl_clk;
output ctl_reset_n;

wire ctl_clk;
wire ctl_reset_n = reset_phy_clk_n;

generate
    if (DWIDTH_RATIO == 2) // fullrate
        assign ctl_clk = ctl_full_clk;
    else if (DWIDTH_RATIO == 4) // halfrate
        assign ctl_clk = ctl_half_clk;
endgenerate

endmodule
