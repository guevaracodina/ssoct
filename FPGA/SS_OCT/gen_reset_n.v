// ============================================================================
// Copyright (c) 2010 by Terasic Technologies Inc. 
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
// Major Functions:	
//   Generate Reset Signal 
//
// ============================================================================
// Design Description:
//
// ===========================================================================
// Revision History :
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Eric Chen         :| 10/06/01  :| Initial Version
// ============================================================================

module gen_reset_n(
		tx_clk,
		reset_n_in,
		reset_n_out
	);

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter					ctr_width			=	20; // richard 16;	

//===========================================================================
// PORT declarations
//===========================================================================
input 						tx_clk;	
input						reset_n_in;
output						reset_n_out;
reg							reset_n_out;

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg		[ctr_width-1:0]		ctr;	// Reset counter

//=============================================================================
// Structural coding
//=============================================================================

always	@(posedge tx_clk or negedge reset_n_in)
begin
	if	(!reset_n_in)
	begin
		reset_n_out	<=	0;
		ctr			<=	0;
	end else begin
		if	(ctr == {ctr_width{1'b1}})
		begin
			reset_n_out	<=	1'b1; //Auto reset phy 1st time
		end else begin
			ctr	<=	ctr + 1;
			reset_n_out	<=	0;
		end
	end
end

endmodule
