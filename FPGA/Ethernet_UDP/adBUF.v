/*****************************************************************
*
* This module implements a ping-pong buffer for Ethernet transfer
*
*******************************************************************/

module adBUF (adclk, rdclk, wrclk, cs_n, rst_n, rd, a2dc, addr, waitreq, a2do);

	// ------------- Port Definition
	input         adclk;    
	input         rdclk;    
	input         wrclk;    
	input         cs_n;     
	input         rst_n;    
	input         rd;       
	input  [11:0] a2dc;     // ADC data
	input  [11:0] addr;    
	output        waitreq;  
	output [31:0] a2do;     
	
	wire          waitreq;
	wire   [31:0] a2do;
	
	// --------------- Intermediate Variable ------------------
	wire   [ 7:0] a2du;         
	reg    [ 7:0] a2di0, a2di1, a2di2, a2di3;    
	reg    [ 1:0] current_byte, next_byte;               
	reg    [31:0] dati;       
	wire   [31:0] ccb_q;       
	wire          rempty;
	reg           srcen;        
	reg    [ 1:0] current_buf, next_buf;
	reg           idle;               
	reg           wren0, wren1, rden; 
	reg           rdreq;              
	wire          wfull0, rempty0;    
	wire          wfull1, rempty1; 
	wire   [31:0] ad_q0, ad_q1;	     

	// --------------- 2's complement to binary ----------------
	assign a2du[7]   = ~a2dc[11];
	assign a2du[6:0] =  a2dc[10:4];
	
	// ------------------- 8-bit to 32-bit --------------------
	always @(posedge adclk or negedge rst_n) begin
		if (~rst_n)
			current_byte <= 2'b00;
		else
			current_byte <= next_byte;
	end
	
	always @(current_byte) begin 
		case(current_byte)
			2'b00:   next_byte = 2'b01;  
			2'b01:   next_byte = 2'b10;  
			2'b10:   next_byte = 2'b11;  
			2'b11:   next_byte = 2'b00; 
		endcase
	end	

	always @(posedge adclk) begin
		case(next_byte)
			2'b00:  begin
				a2di3 <= a2du;	
			end
            2'b01:  begin
				a2di0 <= a2du;
				dati  <= {a2di3, a2di2, a2di1, a2di0};
			end
            2'b10:   begin
				a2di1 <= a2du;
			end
            2'b11:   begin
				a2di2 <= a2du;
			end
		endcase
	end		
	
				    
	// ===================== Cross Clock Bridge ==================== //
	adFIFO crossclk (
					 .data     (dati),
					 .wrclk    (wrclk),
					 .wrreq    (1'b1), 
					 .q        (ccb_q),
					 .rdclk    (rdclk),
					 .rdreq    (srcen & ~rempty),
					 .rdempty  (rempty)
					);


	
	// ======================== Swing Buffer ======================= //
	parameter
				INITIAL = 2'b00,
				BUFFER0 = 2'b01,  
				BUFFER1 = 2'b10;  			

	always @(posedge rdclk or negedge rst_n) begin
		if (~rst_n)
			current_buf <= INITIAL;
		else
			current_buf <= next_buf;
	end
	
	always @(current_buf or cs_n or wfull0 or wfull1 or rempty0 or rempty1) begin
		case(current_buf) 
			INITIAL: begin
				if (wfull0 & ~cs_n) 
					next_buf = BUFFER0;
				else
					next_buf = INITIAL;
			end
			BUFFER0: begin
				if (wfull1 & rempty0)
					next_buf = BUFFER1;
				else
					next_buf = BUFFER0;
			end
			BUFFER1: begin
				if (wfull0 & rempty1)
					next_buf = BUFFER0;
				else
					next_buf = BUFFER1;
			end
			default: begin
				next_buf = INITIAL;
			end
		endcase
	end

	always @(posedge rdclk) begin
		case(next_buf)
			INITIAL: begin
				srcen <= 1'b1;
				wren0 <= 1'b1;
				wren1 <= 1'b0;
				rden  <= 1'b0;
				rdreq <= 1'bz;		
				idle  <= 1'b0;			
			end
			BUFFER0: begin
				if (wfull1) begin
					wren1 <= 1'b0;
					srcen <= 1'b0;
				end
				else begin
					wren1 <= 1'b1;
					srcen <= 1'b1;
				end
				if (rempty0) begin
					rden  <= 1'b0;
					idle  <= 1'b1;
				end
				else begin
					rden  <= 1'b1;
					idle  <= 1'b0;
				end
				wren0 <= 1'b0;				
				rdreq <= 1'b1;
			end
			BUFFER1: begin				
				if (wfull0) begin
					wren0 <= 1'b0;
					srcen <= 1'b0;
				end
				else begin
					wren0 <= 1'b1;
					srcen <= 1'b1;
				end				
				if (rempty1) begin
					rden  <= 1'b0;
					idle  <= 1'b1;
				end
				else begin
				    rden  <= 1'b1;
				    idle  <= 1'b0;
				end
				wren1 <= 1'b0;
				rdreq <= 1'b0;
			end
			default: begin
				srcen <= 1'b1;
				wren0 <= 1'b1;
				wren1 <= 1'b0;
				rden  <= 1'b0;
				rdreq <= 1'bz;	
				idle  <= 1'b0;	
			end
		endcase
	end
	
	swBUF buf0 (
				.clock (rdclk),
				.sclr  (~rst_n),
				.data  (ccb_q),
				.wrreq (srcen & ~rempty & wren0), 
				.full  (wfull0),
				.rdreq (rden & rd & rdreq),
				.empty (rempty0),
				.q     (ad_q0)
			   );
	swBUF buf1 (
				.clock (rdclk),
				.sclr  (~rst_n),
				.data  (ccb_q),
				.wrreq (srcen & ~rempty & wren1), 
				.full  (wfull1),
				.rdreq (rden & rd & ~rdreq),
				.empty (rempty1),
				.q     (ad_q1)
			   );

     assign waitreq = idle;
	 assign a2do    = rdreq ? ad_q0 : ad_q1; 						    

endmodule
