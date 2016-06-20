//=======================================================
//  External PLL Configuration ==========================
//=======================================================


//  Structural coding

assign clk1_set_wr = 4'd0; //Unchange MHZ

assign clk1_set_wr = 4'd1; //Disable MHZ

assign clk1_set_wr = 4'd2; //62.5 MHZ

assign clk1_set_wr = 4'd3; //75 MHZ

assign clk1_set_wr = 4'd4; //100 MHZ

assign clk1_set_wr = 4'd5; //125 MHZ

assign clk1_set_wr = 4'd6; //150 MHZ

assign clk1_set_wr = 4'd7; //156.25 MHZ

assign clk1_set_wr = 4'd8; //187.5 MHZ

assign clk1_set_wr = 4'd9; //200 MHZ

assign clk2_set_wr = 4'd10; //250 MHZ

assign clk1_set_wr = 4'd11; //312.5 MHZ

assign clk1_set_wr = 4'd12; //625 MHZ
assign clk2_set_wr = 4'd12; //625 MHZ
assign clk3_set_wr = 4'd12; //625 MHZ