// Custom 11-bit counter to point acquisition data to corresponding register. Starts counting from 0 by signal GCLKIN, finishes at fixed NSAMPLES.

`include "my_incl.v"			// Verilog include file

module sample_addressing_custom (
	clock,
	sclr,
	sample_position,
	acq_busy,
	acq_done,
	dualMSB_write,
	dualMSB_read
	);
//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================
input					clock;
input					sclr;
output reg 	[10:0] 		sample_position;
output 					acq_busy;
output reg				acq_done;
output 					dualMSB_write;
output 					dualMSB_read;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg 		[13:0]		count;

//=======================================================
//  Structural coding
//=======================================================
initial
  begin
	// Initialize count and output sample_position
	sample_position		= 11'd2047;
    count				= 0;
  end

always @(posedge clock)
begin
	if (sclr == 1)	begin
		count			<= 0;		// Synchronous clear
	end
	else begin
		// Increment counter
		count 			<= count + 1'b1;
	end
	if (count > `NSAMPLES)	begin
		// Output sample_position equal to 2047
		sample_position	<= 11'd2047;
		acq_done		<= 1'b1;
	end
	else	begin
		// Output sample_position equal to count LSB
		sample_position <= count[10:0] - 1;
		acq_done		<= 1'b0;
	end
end

// Acquisition started acq_busy;
assign 	acq_busy		= (sample_position >= 0 & sample_position < `NSAMPLES) ? 1'b1 : 1'b0;

// Acquisition done (rising edge)
//assign	acq_done		= ~acq_busy;


// T flip flop (divides frequency of acq_done by 2)
FlipFlopT	FlipFlopT_inst (
	.clock ( acq_done ),
	.data ( dualMSB_read ),
	.q ( dualMSB_write )
	);

// MSB to read address from internal RAM
assign	dualMSB_read	= ~dualMSB_write;

endmodule