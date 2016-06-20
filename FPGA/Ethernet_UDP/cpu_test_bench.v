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


// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_test_bench (
                        // inputs:
                         A_bstatus_reg,
                         A_cmp_result,
                         A_ctrl_exception,
                         A_ctrl_ld_non_bypass,
                         A_dst_regnum,
                         A_en,
                         A_estatus_reg,
                         A_ienable_reg,
                         A_ipending_reg,
                         A_iw,
                         A_mem_byte_en,
                         A_op_hbreak,
                         A_op_intr,
                         A_pcb,
                         A_st_data,
                         A_status_reg,
                         A_valid,
                         A_wr_data_unfiltered,
                         A_wr_dst_reg,
                         E_logic_result,
                         E_valid,
                         M_mem_baddr,
                         M_target_pcb,
                         M_valid,
                         W_dst_regnum,
                         W_iw,
                         W_iw_op,
                         W_iw_opx,
                         W_pcb,
                         W_valid,
                         W_wr_dst_reg,
                         clk,
                         d_address,
                         d_byteenable,
                         d_read,
                         d_write,
                         i_address,
                         i_read,
                         i_readdatavalid,
                         reset_n,

                        // outputs:
                         A_wr_data_filtered,
                         E_src1_eq_src2
                      )
;

  output  [ 31: 0] A_wr_data_filtered;
  output           E_src1_eq_src2;
  input            A_bstatus_reg;
  input            A_cmp_result;
  input            A_ctrl_exception;
  input            A_ctrl_ld_non_bypass;
  input   [  4: 0] A_dst_regnum;
  input            A_en;
  input            A_estatus_reg;
  input   [ 31: 0] A_ienable_reg;
  input   [ 31: 0] A_ipending_reg;
  input   [ 31: 0] A_iw;
  input   [  3: 0] A_mem_byte_en;
  input            A_op_hbreak;
  input            A_op_intr;
  input   [ 25: 0] A_pcb;
  input   [ 31: 0] A_st_data;
  input            A_status_reg;
  input            A_valid;
  input   [ 31: 0] A_wr_data_unfiltered;
  input            A_wr_dst_reg;
  input   [ 31: 0] E_logic_result;
  input            E_valid;
  input   [ 25: 0] M_mem_baddr;
  input   [ 25: 0] M_target_pcb;
  input            M_valid;
  input   [  4: 0] W_dst_regnum;
  input   [ 31: 0] W_iw;
  input   [  5: 0] W_iw_op;
  input   [  5: 0] W_iw_opx;
  input   [ 25: 0] W_pcb;
  input            W_valid;
  input            W_wr_dst_reg;
  input            clk;
  input   [ 25: 0] d_address;
  input   [  3: 0] d_byteenable;
  input            d_read;
  input            d_write;
  input   [ 25: 0] i_address;
  input            i_read;
  input            i_readdatavalid;
  input            reset_n;

  reg     [ 25: 0] A_mem_baddr;
  reg     [ 25: 0] A_target_pcb;
  wire    [ 31: 0] A_wr_data_filtered;
  wire             A_wr_data_unfiltered_0_is_x;
  wire             A_wr_data_unfiltered_10_is_x;
  wire             A_wr_data_unfiltered_11_is_x;
  wire             A_wr_data_unfiltered_12_is_x;
  wire             A_wr_data_unfiltered_13_is_x;
  wire             A_wr_data_unfiltered_14_is_x;
  wire             A_wr_data_unfiltered_15_is_x;
  wire             A_wr_data_unfiltered_16_is_x;
  wire             A_wr_data_unfiltered_17_is_x;
  wire             A_wr_data_unfiltered_18_is_x;
  wire             A_wr_data_unfiltered_19_is_x;
  wire             A_wr_data_unfiltered_1_is_x;
  wire             A_wr_data_unfiltered_20_is_x;
  wire             A_wr_data_unfiltered_21_is_x;
  wire             A_wr_data_unfiltered_22_is_x;
  wire             A_wr_data_unfiltered_23_is_x;
  wire             A_wr_data_unfiltered_24_is_x;
  wire             A_wr_data_unfiltered_25_is_x;
  wire             A_wr_data_unfiltered_26_is_x;
  wire             A_wr_data_unfiltered_27_is_x;
  wire             A_wr_data_unfiltered_28_is_x;
  wire             A_wr_data_unfiltered_29_is_x;
  wire             A_wr_data_unfiltered_2_is_x;
  wire             A_wr_data_unfiltered_30_is_x;
  wire             A_wr_data_unfiltered_31_is_x;
  wire             A_wr_data_unfiltered_3_is_x;
  wire             A_wr_data_unfiltered_4_is_x;
  wire             A_wr_data_unfiltered_5_is_x;
  wire             A_wr_data_unfiltered_6_is_x;
  wire             A_wr_data_unfiltered_7_is_x;
  wire             A_wr_data_unfiltered_8_is_x;
  wire             A_wr_data_unfiltered_9_is_x;
  wire             E_src1_eq_src2;
  wire    [ 55: 0] W_inst;
  wire             W_op_add;
  wire             W_op_addi;
  wire             W_op_and;
  wire             W_op_andhi;
  wire             W_op_andi;
  wire             W_op_beq;
  wire             W_op_bge;
  wire             W_op_bgeu;
  wire             W_op_blt;
  wire             W_op_bltu;
  wire             W_op_bne;
  wire             W_op_br;
  wire             W_op_break;
  wire             W_op_bret;
  wire             W_op_call;
  wire             W_op_callr;
  wire             W_op_cmpeq;
  wire             W_op_cmpeqi;
  wire             W_op_cmpge;
  wire             W_op_cmpgei;
  wire             W_op_cmpgeu;
  wire             W_op_cmpgeui;
  wire             W_op_cmplt;
  wire             W_op_cmplti;
  wire             W_op_cmpltu;
  wire             W_op_cmpltui;
  wire             W_op_cmpne;
  wire             W_op_cmpnei;
  wire             W_op_crst;
  wire             W_op_custom;
  wire             W_op_div;
  wire             W_op_divu;
  wire             W_op_eret;
  wire             W_op_flushd;
  wire             W_op_flushda;
  wire             W_op_flushi;
  wire             W_op_flushp;
  wire             W_op_hbreak;
  wire             W_op_initd;
  wire             W_op_initda;
  wire             W_op_initi;
  wire             W_op_intr;
  wire             W_op_jmp;
  wire             W_op_jmpi;
  wire             W_op_ldb;
  wire             W_op_ldbio;
  wire             W_op_ldbu;
  wire             W_op_ldbuio;
  wire             W_op_ldh;
  wire             W_op_ldhio;
  wire             W_op_ldhu;
  wire             W_op_ldhuio;
  wire             W_op_ldl;
  wire             W_op_ldw;
  wire             W_op_ldwio;
  wire             W_op_mul;
  wire             W_op_muli;
  wire             W_op_mulxss;
  wire             W_op_mulxsu;
  wire             W_op_mulxuu;
  wire             W_op_nextpc;
  wire             W_op_nor;
  wire             W_op_opx;
  wire             W_op_or;
  wire             W_op_orhi;
  wire             W_op_ori;
  wire             W_op_rdctl;
  wire             W_op_ret;
  wire             W_op_rol;
  wire             W_op_roli;
  wire             W_op_ror;
  wire             W_op_rsv02;
  wire             W_op_rsv09;
  wire             W_op_rsv10;
  wire             W_op_rsv17;
  wire             W_op_rsv18;
  wire             W_op_rsv25;
  wire             W_op_rsv26;
  wire             W_op_rsv33;
  wire             W_op_rsv34;
  wire             W_op_rsv41;
  wire             W_op_rsv42;
  wire             W_op_rsv49;
  wire             W_op_rsv56;
  wire             W_op_rsv57;
  wire             W_op_rsv61;
  wire             W_op_rsv62;
  wire             W_op_rsv63;
  wire             W_op_rsvx00;
  wire             W_op_rsvx10;
  wire             W_op_rsvx15;
  wire             W_op_rsvx17;
  wire             W_op_rsvx20;
  wire             W_op_rsvx21;
  wire             W_op_rsvx25;
  wire             W_op_rsvx33;
  wire             W_op_rsvx34;
  wire             W_op_rsvx35;
  wire             W_op_rsvx42;
  wire             W_op_rsvx43;
  wire             W_op_rsvx44;
  wire             W_op_rsvx47;
  wire             W_op_rsvx50;
  wire             W_op_rsvx51;
  wire             W_op_rsvx55;
  wire             W_op_rsvx56;
  wire             W_op_rsvx60;
  wire             W_op_rsvx63;
  wire             W_op_sll;
  wire             W_op_slli;
  wire             W_op_sra;
  wire             W_op_srai;
  wire             W_op_srl;
  wire             W_op_srli;
  wire             W_op_stb;
  wire             W_op_stbio;
  wire             W_op_stc;
  wire             W_op_sth;
  wire             W_op_sthio;
  wire             W_op_stw;
  wire             W_op_stwio;
  wire             W_op_sub;
  wire             W_op_sync;
  wire             W_op_trap;
  wire             W_op_wrctl;
  wire             W_op_xor;
  wire             W_op_xorhi;
  wire             W_op_xori;
  wire    [ 55: 0] W_vinst;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          A_target_pcb <= 0;
      else if (A_en)
          A_target_pcb <= M_target_pcb;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          A_mem_baddr <= 0;
      else if (A_en)
          A_mem_baddr <= M_mem_baddr;
    end


  assign E_src1_eq_src2 = E_logic_result == 0;
  assign W_op_rsv02 = W_iw_op[5 : 0] == 2;
  assign W_op_cmplti = W_iw_op[5 : 0] == 16;
  assign W_op_rsv18 = W_iw_op[5 : 0] == 18;
  assign W_op_rsv26 = W_iw_op[5 : 0] == 26;
  assign W_op_rsv42 = W_iw_op[5 : 0] == 42;
  assign W_op_ldbio = W_iw_op[5 : 0] == 39;
  assign W_op_ldbu = W_iw_op[5 : 0] == 3;
  assign W_op_orhi = W_iw_op[5 : 0] == 52;
  assign W_op_bge = W_iw_op[5 : 0] == 14;
  assign W_op_stc = W_iw_op[5 : 0] == 29;
  assign W_op_br = W_iw_op[5 : 0] == 6;
  assign W_op_ldhio = W_iw_op[5 : 0] == 47;
  assign W_op_rsv41 = W_iw_op[5 : 0] == 41;
  assign W_op_ldwio = W_iw_op[5 : 0] == 55;
  assign W_op_rsv61 = W_iw_op[5 : 0] == 61;
  assign W_op_opx = W_iw_op[5 : 0] == 58;
  assign W_op_stb = W_iw_op[5 : 0] == 5;
  assign W_op_rsv62 = W_iw_op[5 : 0] == 62;
  assign W_op_bltu = W_iw_op[5 : 0] == 54;
  assign W_op_custom = W_iw_op[5 : 0] == 50;
  assign W_op_muli = W_iw_op[5 : 0] == 36;
  assign W_op_xori = W_iw_op[5 : 0] == 28;
  assign W_op_cmpgei = W_iw_op[5 : 0] == 8;
  assign W_op_ldw = W_iw_op[5 : 0] == 23;
  assign W_op_cmpeqi = W_iw_op[5 : 0] == 32;
  assign W_op_ldh = W_iw_op[5 : 0] == 15;
  assign W_op_stw = W_iw_op[5 : 0] == 21;
  assign W_op_rsv09 = W_iw_op[5 : 0] == 9;
  assign W_op_cmpnei = W_iw_op[5 : 0] == 24;
  assign W_op_ldb = W_iw_op[5 : 0] == 7;
  assign W_op_bgeu = W_iw_op[5 : 0] == 46;
  assign W_op_stwio = W_iw_op[5 : 0] == 53;
  assign W_op_rsv33 = W_iw_op[5 : 0] == 33;
  assign W_op_ldl = W_iw_op[5 : 0] == 31;
  assign W_op_andhi = W_iw_op[5 : 0] == 44;
  assign W_op_ldbuio = W_iw_op[5 : 0] == 35;
  assign W_op_rsv34 = W_iw_op[5 : 0] == 34;
  assign W_op_sthio = W_iw_op[5 : 0] == 45;
  assign W_op_cmpgeui = W_iw_op[5 : 0] == 40;
  assign W_op_stbio = W_iw_op[5 : 0] == 37;
  assign W_op_andi = W_iw_op[5 : 0] == 12;
  assign W_op_addi = W_iw_op[5 : 0] == 4;
  assign W_op_flushda = W_iw_op[5 : 0] == 27;
  assign W_op_rsv49 = W_iw_op[5 : 0] == 49;
  assign W_op_jmpi = W_iw_op[5 : 0] == 1;
  assign W_op_initda = W_iw_op[5 : 0] == 19;
  assign W_op_blt = W_iw_op[5 : 0] == 22;
  assign W_op_beq = W_iw_op[5 : 0] == 38;
  assign W_op_ori = W_iw_op[5 : 0] == 20;
  assign W_op_cmpltui = W_iw_op[5 : 0] == 48;
  assign W_op_xorhi = W_iw_op[5 : 0] == 60;
  assign W_op_rsv56 = W_iw_op[5 : 0] == 56;
  assign W_op_ldhuio = W_iw_op[5 : 0] == 43;
  assign W_op_rsv63 = W_iw_op[5 : 0] == 63;
  assign W_op_bne = W_iw_op[5 : 0] == 30;
  assign W_op_rsv57 = W_iw_op[5 : 0] == 57;
  assign W_op_call = W_iw_op[5 : 0] == 0;
  assign W_op_ldhu = W_iw_op[5 : 0] == 11;
  assign W_op_flushd = W_iw_op[5 : 0] == 59;
  assign W_op_initd = W_iw_op[5 : 0] == 51;
  assign W_op_rsv10 = W_iw_op[5 : 0] == 10;
  assign W_op_rsv17 = W_iw_op[5 : 0] == 17;
  assign W_op_sth = W_iw_op[5 : 0] == 13;
  assign W_op_rsv25 = W_iw_op[5 : 0] == 25;
  assign W_op_flushi = W_op_opx & (W_iw_opx[5 : 0] == 12);
  assign W_op_mulxuu = W_op_opx & (W_iw_opx[5 : 0] == 7);
  assign W_op_rsvx33 = W_op_opx & (W_iw_opx[5 : 0] == 33);
  assign W_op_wrctl = W_op_opx & (W_iw_opx[5 : 0] == 46);
  assign W_op_roli = W_op_opx & (W_iw_opx[5 : 0] == 2);
  assign W_op_intr = W_op_opx & (W_iw_opx[5 : 0] == 61);
  assign W_op_rsvx43 = W_op_opx & (W_iw_opx[5 : 0] == 43);
  assign W_op_srl = W_op_opx & (W_iw_opx[5 : 0] == 27);
  assign W_op_trap = W_op_opx & (W_iw_opx[5 : 0] == 45);
  assign W_op_rsvx17 = W_op_opx & (W_iw_opx[5 : 0] == 17);
  assign W_op_break = W_op_opx & (W_iw_opx[5 : 0] == 52);
  assign W_op_rdctl = W_op_opx & (W_iw_opx[5 : 0] == 38);
  assign W_op_cmpltu = W_op_opx & (W_iw_opx[5 : 0] == 48);
  assign W_op_callr = W_op_opx & (W_iw_opx[5 : 0] == 29);
  assign W_op_cmpge = W_op_opx & (W_iw_opx[5 : 0] == 8);
  assign W_op_rsvx47 = W_op_opx & (W_iw_opx[5 : 0] == 47);
  assign W_op_and = W_op_opx & (W_iw_opx[5 : 0] == 14);
  assign W_op_rsvx00 = W_op_opx & (W_iw_opx[5 : 0] == 0);
  assign W_op_rsvx56 = W_op_opx & (W_iw_opx[5 : 0] == 56);
  assign W_op_hbreak = W_op_opx & (W_iw_opx[5 : 0] == 53);
  assign W_op_flushp = W_op_opx & (W_iw_opx[5 : 0] == 4);
  assign W_op_nor = W_op_opx & (W_iw_opx[5 : 0] == 6);
  assign W_op_rsvx50 = W_op_opx & (W_iw_opx[5 : 0] == 50);
  assign W_op_initi = W_op_opx & (W_iw_opx[5 : 0] == 41);
  assign W_op_srai = W_op_opx & (W_iw_opx[5 : 0] == 58);
  assign W_op_sync = W_op_opx & (W_iw_opx[5 : 0] == 54);
  assign W_op_rsvx15 = W_op_opx & (W_iw_opx[5 : 0] == 15);
  assign W_op_rsvx55 = W_op_opx & (W_iw_opx[5 : 0] == 55);
  assign W_op_crst = W_op_opx & (W_iw_opx[5 : 0] == 62);
  assign W_op_rsvx42 = W_op_opx & (W_iw_opx[5 : 0] == 42);
  assign W_op_xor = W_op_opx & (W_iw_opx[5 : 0] == 30);
  assign W_op_rsvx34 = W_op_opx & (W_iw_opx[5 : 0] == 34);
  assign W_op_mulxss = W_op_opx & (W_iw_opx[5 : 0] == 31);
  assign W_op_rsvx51 = W_op_opx & (W_iw_opx[5 : 0] == 51);
  assign W_op_rsvx10 = W_op_opx & (W_iw_opx[5 : 0] == 10);
  assign W_op_eret = W_op_opx & (W_iw_opx[5 : 0] == 1);
  assign W_op_rsvx25 = W_op_opx & (W_iw_opx[5 : 0] == 25);
  assign W_op_jmp = W_op_opx & (W_iw_opx[5 : 0] == 13);
  assign W_op_or = W_op_opx & (W_iw_opx[5 : 0] == 22);
  assign W_op_rsvx35 = W_op_opx & (W_iw_opx[5 : 0] == 35);
  assign W_op_sra = W_op_opx & (W_iw_opx[5 : 0] == 59);
  assign W_op_rsvx20 = W_op_opx & (W_iw_opx[5 : 0] == 20);
  assign W_op_slli = W_op_opx & (W_iw_opx[5 : 0] == 18);
  assign W_op_mulxsu = W_op_opx & (W_iw_opx[5 : 0] == 23);
  assign W_op_rsvx21 = W_op_opx & (W_iw_opx[5 : 0] == 21);
  assign W_op_ror = W_op_opx & (W_iw_opx[5 : 0] == 11);
  assign W_op_srli = W_op_opx & (W_iw_opx[5 : 0] == 26);
  assign W_op_sll = W_op_opx & (W_iw_opx[5 : 0] == 19);
  assign W_op_div = W_op_opx & (W_iw_opx[5 : 0] == 37);
  assign W_op_cmplt = W_op_opx & (W_iw_opx[5 : 0] == 16);
  assign W_op_add = W_op_opx & (W_iw_opx[5 : 0] == 49);
  assign W_op_rsvx44 = W_op_opx & (W_iw_opx[5 : 0] == 44);
  assign W_op_bret = W_op_opx & (W_iw_opx[5 : 0] == 9);
  assign W_op_rsvx60 = W_op_opx & (W_iw_opx[5 : 0] == 60);
  assign W_op_rsvx63 = W_op_opx & (W_iw_opx[5 : 0] == 63);
  assign W_op_mul = W_op_opx & (W_iw_opx[5 : 0] == 39);
  assign W_op_cmpgeu = W_op_opx & (W_iw_opx[5 : 0] == 40);
  assign W_op_cmpne = W_op_opx & (W_iw_opx[5 : 0] == 24);
  assign W_op_cmpeq = W_op_opx & (W_iw_opx[5 : 0] == 32);
  assign W_op_ret = W_op_opx & (W_iw_opx[5 : 0] == 5);
  assign W_op_rol = W_op_opx & (W_iw_opx[5 : 0] == 3);
  assign W_op_sub = W_op_opx & (W_iw_opx[5 : 0] == 57);
  assign W_op_nextpc = W_op_opx & (W_iw_opx[5 : 0] == 28);
  assign W_op_divu = W_op_opx & (W_iw_opx[5 : 0] == 36);

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //Clearing 'X' data bits
  assign A_wr_data_unfiltered_0_is_x = ^(A_wr_data_unfiltered[0]) === 1'bx;

  assign A_wr_data_filtered[0] = (A_wr_data_unfiltered_0_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[0];
  assign A_wr_data_unfiltered_1_is_x = ^(A_wr_data_unfiltered[1]) === 1'bx;
  assign A_wr_data_filtered[1] = (A_wr_data_unfiltered_1_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[1];
  assign A_wr_data_unfiltered_2_is_x = ^(A_wr_data_unfiltered[2]) === 1'bx;
  assign A_wr_data_filtered[2] = (A_wr_data_unfiltered_2_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[2];
  assign A_wr_data_unfiltered_3_is_x = ^(A_wr_data_unfiltered[3]) === 1'bx;
  assign A_wr_data_filtered[3] = (A_wr_data_unfiltered_3_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[3];
  assign A_wr_data_unfiltered_4_is_x = ^(A_wr_data_unfiltered[4]) === 1'bx;
  assign A_wr_data_filtered[4] = (A_wr_data_unfiltered_4_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[4];
  assign A_wr_data_unfiltered_5_is_x = ^(A_wr_data_unfiltered[5]) === 1'bx;
  assign A_wr_data_filtered[5] = (A_wr_data_unfiltered_5_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[5];
  assign A_wr_data_unfiltered_6_is_x = ^(A_wr_data_unfiltered[6]) === 1'bx;
  assign A_wr_data_filtered[6] = (A_wr_data_unfiltered_6_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[6];
  assign A_wr_data_unfiltered_7_is_x = ^(A_wr_data_unfiltered[7]) === 1'bx;
  assign A_wr_data_filtered[7] = (A_wr_data_unfiltered_7_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[7];
  assign A_wr_data_unfiltered_8_is_x = ^(A_wr_data_unfiltered[8]) === 1'bx;
  assign A_wr_data_filtered[8] = (A_wr_data_unfiltered_8_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[8];
  assign A_wr_data_unfiltered_9_is_x = ^(A_wr_data_unfiltered[9]) === 1'bx;
  assign A_wr_data_filtered[9] = (A_wr_data_unfiltered_9_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[9];
  assign A_wr_data_unfiltered_10_is_x = ^(A_wr_data_unfiltered[10]) === 1'bx;
  assign A_wr_data_filtered[10] = (A_wr_data_unfiltered_10_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[10];
  assign A_wr_data_unfiltered_11_is_x = ^(A_wr_data_unfiltered[11]) === 1'bx;
  assign A_wr_data_filtered[11] = (A_wr_data_unfiltered_11_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[11];
  assign A_wr_data_unfiltered_12_is_x = ^(A_wr_data_unfiltered[12]) === 1'bx;
  assign A_wr_data_filtered[12] = (A_wr_data_unfiltered_12_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[12];
  assign A_wr_data_unfiltered_13_is_x = ^(A_wr_data_unfiltered[13]) === 1'bx;
  assign A_wr_data_filtered[13] = (A_wr_data_unfiltered_13_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[13];
  assign A_wr_data_unfiltered_14_is_x = ^(A_wr_data_unfiltered[14]) === 1'bx;
  assign A_wr_data_filtered[14] = (A_wr_data_unfiltered_14_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[14];
  assign A_wr_data_unfiltered_15_is_x = ^(A_wr_data_unfiltered[15]) === 1'bx;
  assign A_wr_data_filtered[15] = (A_wr_data_unfiltered_15_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[15];
  assign A_wr_data_unfiltered_16_is_x = ^(A_wr_data_unfiltered[16]) === 1'bx;
  assign A_wr_data_filtered[16] = (A_wr_data_unfiltered_16_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[16];
  assign A_wr_data_unfiltered_17_is_x = ^(A_wr_data_unfiltered[17]) === 1'bx;
  assign A_wr_data_filtered[17] = (A_wr_data_unfiltered_17_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[17];
  assign A_wr_data_unfiltered_18_is_x = ^(A_wr_data_unfiltered[18]) === 1'bx;
  assign A_wr_data_filtered[18] = (A_wr_data_unfiltered_18_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[18];
  assign A_wr_data_unfiltered_19_is_x = ^(A_wr_data_unfiltered[19]) === 1'bx;
  assign A_wr_data_filtered[19] = (A_wr_data_unfiltered_19_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[19];
  assign A_wr_data_unfiltered_20_is_x = ^(A_wr_data_unfiltered[20]) === 1'bx;
  assign A_wr_data_filtered[20] = (A_wr_data_unfiltered_20_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[20];
  assign A_wr_data_unfiltered_21_is_x = ^(A_wr_data_unfiltered[21]) === 1'bx;
  assign A_wr_data_filtered[21] = (A_wr_data_unfiltered_21_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[21];
  assign A_wr_data_unfiltered_22_is_x = ^(A_wr_data_unfiltered[22]) === 1'bx;
  assign A_wr_data_filtered[22] = (A_wr_data_unfiltered_22_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[22];
  assign A_wr_data_unfiltered_23_is_x = ^(A_wr_data_unfiltered[23]) === 1'bx;
  assign A_wr_data_filtered[23] = (A_wr_data_unfiltered_23_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[23];
  assign A_wr_data_unfiltered_24_is_x = ^(A_wr_data_unfiltered[24]) === 1'bx;
  assign A_wr_data_filtered[24] = (A_wr_data_unfiltered_24_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[24];
  assign A_wr_data_unfiltered_25_is_x = ^(A_wr_data_unfiltered[25]) === 1'bx;
  assign A_wr_data_filtered[25] = (A_wr_data_unfiltered_25_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[25];
  assign A_wr_data_unfiltered_26_is_x = ^(A_wr_data_unfiltered[26]) === 1'bx;
  assign A_wr_data_filtered[26] = (A_wr_data_unfiltered_26_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[26];
  assign A_wr_data_unfiltered_27_is_x = ^(A_wr_data_unfiltered[27]) === 1'bx;
  assign A_wr_data_filtered[27] = (A_wr_data_unfiltered_27_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[27];
  assign A_wr_data_unfiltered_28_is_x = ^(A_wr_data_unfiltered[28]) === 1'bx;
  assign A_wr_data_filtered[28] = (A_wr_data_unfiltered_28_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[28];
  assign A_wr_data_unfiltered_29_is_x = ^(A_wr_data_unfiltered[29]) === 1'bx;
  assign A_wr_data_filtered[29] = (A_wr_data_unfiltered_29_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[29];
  assign A_wr_data_unfiltered_30_is_x = ^(A_wr_data_unfiltered[30]) === 1'bx;
  assign A_wr_data_filtered[30] = (A_wr_data_unfiltered_30_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[30];
  assign A_wr_data_unfiltered_31_is_x = ^(A_wr_data_unfiltered[31]) === 1'bx;
  assign A_wr_data_filtered[31] = (A_wr_data_unfiltered_31_is_x & (A_ctrl_ld_non_bypass)) ? 1'b0 : A_wr_data_unfiltered[31];
  always @(posedge clk)
    begin
      if (reset_n)
          if (^(W_wr_dst_reg) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/W_wr_dst_reg is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (W_wr_dst_reg)
          if (^(W_dst_regnum) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/W_dst_regnum is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(W_valid) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/W_valid is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (W_valid)
          if (^(W_pcb) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/W_pcb is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (W_valid)
          if (^(W_iw) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/W_iw is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(A_en) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/A_en is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(E_valid) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/E_valid is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(M_valid) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/M_valid is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(A_valid) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/A_valid is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (A_valid & A_en & A_wr_dst_reg)
          if (^(A_wr_data_unfiltered) === 1'bx)
            begin
              $write("%0d ns: WARNING: cpu_test_bench/A_wr_data_unfiltered is 'x'\n", $time);
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(A_status_reg) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/A_status_reg is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(A_estatus_reg) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/A_estatus_reg is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(A_bstatus_reg) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/A_bstatus_reg is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(i_read) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/i_read is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (i_read)
          if (^(i_address) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/i_address is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(i_readdatavalid) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/i_readdatavalid is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(d_write) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/d_write is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (d_write)
          if (^(d_byteenable) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/d_byteenable is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
        end
      else if (d_write | d_read)
          if (^(d_address) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/d_address is 'x'\n", $time);
              $stop;
            end
    end


  always @(posedge clk)
    begin
      if (reset_n)
          if (^(d_read) === 1'bx)
            begin
              $write("%0d ns: ERROR: cpu_test_bench/d_read is 'x'\n", $time);
              $stop;
            end
    end


  
  reg [31:0] trace_handle; // for $fopen
  initial  
  begin
    trace_handle = $fopen("cpu.tr");
    $fwrite(trace_handle, "version 2\nnumThreads 1\n");
  end
  always @(posedge clk)
    begin
      if (~reset_n || (A_valid & A_en))
          $fwrite(trace_handle, "%0d ns: %0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h\n", $time, ~reset_n, A_pcb, 0, A_op_intr, A_op_hbreak, A_iw, A_wr_dst_reg, A_dst_regnum, A_wr_data_filtered, A_mem_baddr, A_st_data, A_mem_byte_en, A_cmp_result, A_target_pcb, A_status_reg, A_estatus_reg, A_bstatus_reg, A_ienable_reg, A_ipending_reg, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, A_ctrl_exception);
    end


  assign W_inst = ((((W_iw_op[5 : 0] == 2))))? 56'h20207273763032 :
    ((((W_iw_op[5 : 0] == 16))))? 56'h20636d706c7469 :
    ((((W_iw_op[5 : 0] == 18))))? 56'h20207273763138 :
    ((((W_iw_op[5 : 0] == 26))))? 56'h20207273763236 :
    ((((W_iw_op[5 : 0] == 42))))? 56'h20207273763432 :
    ((((W_iw_op[5 : 0] == 39))))? 56'h20206c6462696f :
    ((((W_iw_op[5 : 0] == 3))))? 56'h2020206c646275 :
    ((((W_iw_op[5 : 0] == 52))))? 56'h2020206f726869 :
    ((((W_iw_op[5 : 0] == 14))))? 56'h20202020626765 :
    ((((W_iw_op[5 : 0] == 29))))? 56'h20202020737463 :
    ((((W_iw_op[5 : 0] == 6))))? 56'h20202020206272 :
    ((((W_iw_op[5 : 0] == 47))))? 56'h20206c6468696f :
    ((((W_iw_op[5 : 0] == 41))))? 56'h20207273763431 :
    ((((W_iw_op[5 : 0] == 55))))? 56'h20206c6477696f :
    ((((W_iw_op[5 : 0] == 61))))? 56'h20207273763631 :
    ((((W_iw_op[5 : 0] == 5))))? 56'h20202020737462 :
    ((((W_iw_op[5 : 0] == 62))))? 56'h20207273763632 :
    ((((W_iw_op[5 : 0] == 54))))? 56'h202020626c7475 :
    ((((W_iw_op[5 : 0] == 50))))? 56'h20637573746f6d :
    ((((W_iw_op[5 : 0] == 36))))? 56'h2020206d756c69 :
    ((((W_iw_op[5 : 0] == 28))))? 56'h202020786f7269 :
    ((((W_iw_op[5 : 0] == 8))))? 56'h20636d70676569 :
    ((((W_iw_op[5 : 0] == 23))))? 56'h202020206c6477 :
    ((((W_iw_op[5 : 0] == 32))))? 56'h20636d70657169 :
    ((((W_iw_op[5 : 0] == 15))))? 56'h202020206c6468 :
    ((((W_iw_op[5 : 0] == 21))))? 56'h20202020737477 :
    ((((W_iw_op[5 : 0] == 9))))? 56'h20207273763039 :
    ((((W_iw_op[5 : 0] == 24))))? 56'h20636d706e6569 :
    ((((W_iw_op[5 : 0] == 7))))? 56'h202020206c6462 :
    ((((W_iw_op[5 : 0] == 46))))? 56'h20202062676575 :
    ((((W_iw_op[5 : 0] == 53))))? 56'h2020737477696f :
    ((((W_iw_op[5 : 0] == 33))))? 56'h20207273763333 :
    ((((W_iw_op[5 : 0] == 31))))? 56'h202020206c646c :
    ((((W_iw_op[5 : 0] == 44))))? 56'h2020616e646869 :
    ((((W_iw_op[5 : 0] == 35))))? 56'h206c646275696f :
    ((((W_iw_op[5 : 0] == 34))))? 56'h20207273763334 :
    ((((W_iw_op[5 : 0] == 45))))? 56'h2020737468696f :
    ((((W_iw_op[5 : 0] == 40))))? 56'h636d7067657569 :
    ((((W_iw_op[5 : 0] == 37))))? 56'h2020737462696f :
    ((((W_iw_op[5 : 0] == 12))))? 56'h202020616e6469 :
    ((((W_iw_op[5 : 0] == 4))))? 56'h20202061646469 :
    ((((W_iw_op[5 : 0] == 27))))? 56'h666c7573686461 :
    ((((W_iw_op[5 : 0] == 49))))? 56'h20207273763439 :
    ((((W_iw_op[5 : 0] == 1))))? 56'h2020206a6d7069 :
    ((((W_iw_op[5 : 0] == 19))))? 56'h20696e69746461 :
    ((((W_iw_op[5 : 0] == 22))))? 56'h20202020626c74 :
    ((((W_iw_op[5 : 0] == 38))))? 56'h20202020626571 :
    ((((W_iw_op[5 : 0] == 20))))? 56'h202020206f7269 :
    ((((W_iw_op[5 : 0] == 48))))? 56'h636d706c747569 :
    ((((W_iw_op[5 : 0] == 60))))? 56'h2020786f726869 :
    ((((W_iw_op[5 : 0] == 56))))? 56'h20207273763536 :
    ((((W_iw_op[5 : 0] == 43))))? 56'h206c646875696f :
    ((((W_iw_op[5 : 0] == 63))))? 56'h20207273763633 :
    ((((W_iw_op[5 : 0] == 30))))? 56'h20202020626e65 :
    ((((W_iw_op[5 : 0] == 57))))? 56'h20207273763537 :
    ((((W_iw_op[5 : 0] == 0))))? 56'h20202063616c6c :
    ((((W_iw_op[5 : 0] == 11))))? 56'h2020206c646875 :
    ((((W_iw_op[5 : 0] == 59))))? 56'h20666c75736864 :
    ((((W_iw_op[5 : 0] == 51))))? 56'h2020696e697464 :
    ((((W_iw_op[5 : 0] == 10))))? 56'h20207273763130 :
    ((((W_iw_op[5 : 0] == 17))))? 56'h20207273763137 :
    ((((W_iw_op[5 : 0] == 13))))? 56'h20202020737468 :
    ((((W_iw_op[5 : 0] == 25))))? 56'h20207273763235 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 12))))? 56'h20666c75736869 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 7))))? 56'h206d756c787575 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 33))))? 56'h20727376783333 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 46))))? 56'h2020777263746c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 2))))? 56'h202020726f6c69 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 61))))? 56'h202020696e7472 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 43))))? 56'h20727376783433 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 27))))? 56'h2020202073726c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 45))))? 56'h20202074726170 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 17))))? 56'h20727376783137 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 52))))? 56'h2020627265616b :
    (((W_op_opx & (W_iw_opx[5 : 0] == 38))))? 56'h2020726463746c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 48))))? 56'h20636d706c7475 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 29))))? 56'h202063616c6c72 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 8))))? 56'h2020636d706765 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 47))))? 56'h20727376783437 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 14))))? 56'h20202020616e64 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 0))))? 56'h20727376783030 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 56))))? 56'h20727376783536 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 53))))? 56'h2068627265616b :
    (((W_op_opx & (W_iw_opx[5 : 0] == 4))))? 56'h20666c75736870 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 6))))? 56'h202020206e6f72 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 50))))? 56'h20727376783530 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 41))))? 56'h2020696e697469 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 58))))? 56'h20202073726169 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 54))))? 56'h20202073796e63 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 15))))? 56'h20727376783135 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 55))))? 56'h20727376783535 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 62))))? 56'h20202063727374 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 42))))? 56'h20727376783432 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 30))))? 56'h20202020786f72 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 34))))? 56'h20727376783334 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 31))))? 56'h206d756c787373 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 51))))? 56'h20727376783531 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 10))))? 56'h20727376783130 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 1))))? 56'h20202065726574 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 25))))? 56'h20727376783235 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 13))))? 56'h202020206a6d70 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 22))))? 56'h20202020206f72 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 35))))? 56'h20727376783335 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 59))))? 56'h20202020737261 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 20))))? 56'h20727376783230 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 18))))? 56'h202020736c6c69 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 23))))? 56'h206d756c787375 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 21))))? 56'h20727376783231 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 11))))? 56'h20202020726f72 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 26))))? 56'h20202073726c69 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 19))))? 56'h20202020736c6c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 37))))? 56'h20202020646976 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 16))))? 56'h2020636d706c74 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 49))))? 56'h20202020616464 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 44))))? 56'h20727376783434 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 9))))? 56'h20202062726574 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 60))))? 56'h20727376783630 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 63))))? 56'h20727376783633 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 39))))? 56'h202020206d756c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 40))))? 56'h20636d70676575 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 24))))? 56'h2020636d706e65 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 32))))? 56'h2020636d706571 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 5))))? 56'h20202020726574 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 3))))? 56'h20202020726f6c :
    (((W_op_opx & (W_iw_opx[5 : 0] == 57))))? 56'h20202020737562 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 28))))? 56'h206e6578747063 :
    (((W_op_opx & (W_iw_opx[5 : 0] == 36))))? 56'h20202064697675 :
    56'h20202020424144;

  assign W_vinst = W_valid ? W_inst : {7{8'h2d}};

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign A_wr_data_filtered = A_wr_data_unfiltered;
//
//synthesis read_comments_as_HDL off

endmodule

