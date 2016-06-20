//PWM control of Fan speed
//Here's an example that uses a 4-bit control to select between 16 speed levels for the fan.

module FAN_PWM(
	clk,						// 50MHz OSC_50_BANK2
	PWM_input,					// 16 speed levels
	clk_div_out,				// 8 bit frequency divider
	FAN);						// Fan control pin
	
//=======================================================
//  PORT declarations
//=======================================================
input 			clk;			// 50MHz OSC_50_BANK2
input 	[3:0]	PWM_input;		// 16 speed levels
								// 4'hF -> ON
								// 4'h0 -> OFF
output 			FAN;			// Fan control pin
output	[7:0]	clk_div_out;	// 8 bit frequency divider

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg 	[4:0] 	PWM;
wire			fan_clk;

//=======================================================
//  Structural coding
//=======================================================
always @(posedge fan_clk) 
	PWM <= PWM[3:0]+PWM_input;
assign FAN = PWM[4];
assign	fan_clk 		= clk_div_out[6];

// 8-bit counter. Using bit 6 at a clk frquency of 50 MHz, works fine
clock_divider	clock_divider_inst (
	.clock ( clk ), 			// 50MHz OSC_50_BANK2
	.q ( clk_div_out )
	);
	
endmodule