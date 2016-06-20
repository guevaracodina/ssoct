//	Copyright (C) 1988-2009 Altera Corporation

//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.


module sin400k_st(clk, reset_n, clken, phi_inc_i, fsin_o, out_valid);

parameter mpr = 14;
parameter apr = 32;
parameter apri= 16;
parameter aprf= 32;
parameter aprp= 16;
parameter aprid=21;
parameter dpri= 5;
parameter rdw = 14;
parameter raw = 16;
parameter rnw = 65536;
parameter mxnb = 256;
parameter rsf = "sin400k_sin.hex";
parameter nc = 1;
parameter log2nc =0;
parameter outselinit = 0;
parameter paci0= 0;
parameter paci1= 0;
parameter paci2= 0;
parameter paci3= 0;
parameter paci4= 0;
parameter paci5= 0;
parameter paci6= 0;
parameter paci7= 0;

input clk; 
input reset_n; 
input clken; 
input [apr-1:0] phi_inc_i; 

output [mpr-1:0] fsin_o;
output out_valid;
wire reset; 
assign reset = !reset_n;

wire [apr-1:0]  phi_inc_i_w;
wire [raw-1:0] raxx001w;
wire [apr-1:0] phi_acc_w;
wire [apri-1:0] phi_acc_w_addr;
wire [mpr-1:0] sin_o_w;
wire [mpr-1:0] cos_o_w;
wire [mpr-1:0] rxs_w;
wire [mpr-1:0] rxc_w;
wire [mpr-1:0] fsin_o_w;	

assign phi_inc_i_w = phi_inc_i;



asj_altqmcpipe ux000 (.clk(clk), 
             .reset(reset), 
             .clken(clken), 
             .phi_inc_int(phi_inc_i_w), 
             .phi_acc_reg(phi_acc_w)
             );

defparam ux000.apr = apr ;
defparam ux000.lat = 1 ;
defparam ux000.nc = nc ;
defparam ux000.paci0 = paci0 ;
defparam ux000.paci1 = paci1 ;
defparam ux000.paci2 = paci2 ;
defparam ux000.paci3 = paci3 ;
defparam ux000.paci4 = paci4 ;
defparam ux000.paci5 = paci5 ;
defparam ux000.paci6 = paci6 ;
defparam ux000.paci7 = paci7 ;

asj_gal ux009( .clk(clk),
                   .reset(reset), 
                   .clken(clken), 
                   .phi_acc_w(phi_acc_w[apr-1:apr-raw]),
                   .rom_add(raxx001w)
                   );
defparam ux009.raw = raw;
defparam ux009.apr = raw;

asj_nco_as_m_cen ux0120(.clk(clk),
                   .clken (clken),
                   .raxx (raxx001w[raw-1:0]),
                   .srw_int_res(rxs_w[mpr-1:0])
                   );
defparam ux0120.mpr = mpr;
defparam ux0120.rdw = rdw;
defparam ux0120.raw = raw;
defparam ux0120.rnw = rnw;
defparam ux0120.rf = rsf;
defparam ux0120.dev = "StratixII";


asj_nco_mob_rw ux122(.data_in(rxs_w),
                     .data_out(fsin_o_w),
                     .reset(reset),
                     .clken(clken),
                     .clk(clk)
);
defparam ux122.mpr = mpr;
defparam ux122.sel = 0;
assign fsin_o = fsin_o_w;


asj_nco_isdr ux710isdr(.clk(clk),                              
                    .reset(reset),                          
                    .clken(clken),                  
                    .data_ready(out_valid)          
                    );                                      
defparam ux710isdr.ctc=4;                                       
defparam ux710isdr.cpr=3;                                   
                                                            

endmodule