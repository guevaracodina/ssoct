//By continuously changing the LED intensity, the LED appears to "glow".
	module LED_glow(
	clk,
	LED);
//=======================================================
//  PORT declarations
//=======================================================
input clk;
output LED;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg	[23:0]	cnt;
reg	[4:0] 	PWM;


always @(posedge clk) cnt<=cnt+1;
wire [3:0] PWM_input = cnt[23] ? cnt[22:19] : ~cnt[22:19];    // ramp the PWM input up and down

//=======================================================
//  Structural coding
//=======================================================
always @(posedge clk) PWM <= PWM[3:0]+PWM_input;
	assign LED = PWM[4];
endmodule