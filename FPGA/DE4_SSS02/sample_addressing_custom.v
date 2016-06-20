// Custom 11-bit counter to point acquisition data to corresponding register. Starts counting from 0 by signal GCLKIN, finishes at fixed NSAMPLES.

`include "my_incl.v"			// Verilog include file

module sample_addressing_custom (
	clock,
	sclr,
	q
	);
//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================
input				clock;
input				sclr;
output reg 	[10:0] 	q;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg 		[13:0]	count;
//=======================================================
//  Structural coding
//=======================================================
initial
  begin
	// Initialize count and output q
	q				= 0;
    count			= 0;
  end
always @(posedge clock)
begin
	if (sclr == 1)	begin
		count		<= 0;		// Synchronous clear
	end
	else
	// Increment counter
	count 			<= count + 1'b1;
	if (count > `NSAMPLES)	begin
	// Output q equal to zero
		q			<= 0;
	end
	else	begin
	// Output q equal to count LSB
		q 			<= count[10:0];	
	end
end
endmodule