//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ADC_data_pio_s1_arbitrator (
                                    // inputs:
                                     ADC_data_pio_s1_readdata,
                                     clk,
                                     peripheral_clock_crossing_m1_address_to_slave,
                                     peripheral_clock_crossing_m1_latency_counter,
                                     peripheral_clock_crossing_m1_nativeaddress,
                                     peripheral_clock_crossing_m1_read,
                                     peripheral_clock_crossing_m1_write,
                                     reset_n,

                                    // outputs:
                                     ADC_data_pio_s1_address,
                                     ADC_data_pio_s1_readdata_from_sa,
                                     ADC_data_pio_s1_reset_n,
                                     d1_ADC_data_pio_s1_end_xfer,
                                     peripheral_clock_crossing_m1_granted_ADC_data_pio_s1,
                                     peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1,
                                     peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1,
                                     peripheral_clock_crossing_m1_requests_ADC_data_pio_s1
                                  )
;

  output  [  1: 0] ADC_data_pio_s1_address;
  output  [ 15: 0] ADC_data_pio_s1_readdata_from_sa;
  output           ADC_data_pio_s1_reset_n;
  output           d1_ADC_data_pio_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_ADC_data_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1;
  output           peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;
  input   [ 15: 0] ADC_data_pio_s1_readdata;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input            reset_n;

  wire    [  1: 0] ADC_data_pio_s1_address;
  wire             ADC_data_pio_s1_allgrants;
  wire             ADC_data_pio_s1_allow_new_arb_cycle;
  wire             ADC_data_pio_s1_any_bursting_master_saved_grant;
  wire             ADC_data_pio_s1_any_continuerequest;
  wire             ADC_data_pio_s1_arb_counter_enable;
  reg              ADC_data_pio_s1_arb_share_counter;
  wire             ADC_data_pio_s1_arb_share_counter_next_value;
  wire             ADC_data_pio_s1_arb_share_set_values;
  wire             ADC_data_pio_s1_beginbursttransfer_internal;
  wire             ADC_data_pio_s1_begins_xfer;
  wire             ADC_data_pio_s1_end_xfer;
  wire             ADC_data_pio_s1_firsttransfer;
  wire             ADC_data_pio_s1_grant_vector;
  wire             ADC_data_pio_s1_in_a_read_cycle;
  wire             ADC_data_pio_s1_in_a_write_cycle;
  wire             ADC_data_pio_s1_master_qreq_vector;
  wire             ADC_data_pio_s1_non_bursting_master_requests;
  wire    [ 15: 0] ADC_data_pio_s1_readdata_from_sa;
  reg              ADC_data_pio_s1_reg_firsttransfer;
  wire             ADC_data_pio_s1_reset_n;
  reg              ADC_data_pio_s1_slavearbiterlockenable;
  wire             ADC_data_pio_s1_slavearbiterlockenable2;
  wire             ADC_data_pio_s1_unreg_firsttransfer;
  wire             ADC_data_pio_s1_waits_for_read;
  wire             ADC_data_pio_s1_waits_for_write;
  reg              d1_ADC_data_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ADC_data_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_ADC_data_pio_s1;
  wire             wait_for_ADC_data_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ADC_data_pio_s1_end_xfer;
    end


  assign ADC_data_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1));
  //assign ADC_data_pio_s1_readdata_from_sa = ADC_data_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ADC_data_pio_s1_readdata_from_sa = ADC_data_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_ADC_data_pio_s1 = (({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h50) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write)) & peripheral_clock_crossing_m1_read;
  //ADC_data_pio_s1_arb_share_counter set values, which is an e_mux
  assign ADC_data_pio_s1_arb_share_set_values = 1;

  //ADC_data_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign ADC_data_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;

  //ADC_data_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ADC_data_pio_s1_any_bursting_master_saved_grant = 0;

  //ADC_data_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ADC_data_pio_s1_arb_share_counter_next_value = ADC_data_pio_s1_firsttransfer ? (ADC_data_pio_s1_arb_share_set_values - 1) : |ADC_data_pio_s1_arb_share_counter ? (ADC_data_pio_s1_arb_share_counter - 1) : 0;

  //ADC_data_pio_s1_allgrants all slave grants, which is an e_mux
  assign ADC_data_pio_s1_allgrants = |ADC_data_pio_s1_grant_vector;

  //ADC_data_pio_s1_end_xfer assignment, which is an e_assign
  assign ADC_data_pio_s1_end_xfer = ~(ADC_data_pio_s1_waits_for_read | ADC_data_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ADC_data_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ADC_data_pio_s1 = ADC_data_pio_s1_end_xfer & (~ADC_data_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ADC_data_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ADC_data_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ADC_data_pio_s1 & ADC_data_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_ADC_data_pio_s1 & ~ADC_data_pio_s1_non_bursting_master_requests);

  //ADC_data_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ADC_data_pio_s1_arb_share_counter <= 0;
      else if (ADC_data_pio_s1_arb_counter_enable)
          ADC_data_pio_s1_arb_share_counter <= ADC_data_pio_s1_arb_share_counter_next_value;
    end


  //ADC_data_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ADC_data_pio_s1_slavearbiterlockenable <= 0;
      else if ((|ADC_data_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ADC_data_pio_s1) | (end_xfer_arb_share_counter_term_ADC_data_pio_s1 & ~ADC_data_pio_s1_non_bursting_master_requests))
          ADC_data_pio_s1_slavearbiterlockenable <= |ADC_data_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 ADC_data_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = ADC_data_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //ADC_data_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ADC_data_pio_s1_slavearbiterlockenable2 = |ADC_data_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 ADC_data_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = ADC_data_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //ADC_data_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ADC_data_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 = peripheral_clock_crossing_m1_requests_ADC_data_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1 = peripheral_clock_crossing_m1_granted_ADC_data_pio_s1 & peripheral_clock_crossing_m1_read & ~ADC_data_pio_s1_waits_for_read;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_ADC_data_pio_s1 = peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant ADC_data_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_ADC_data_pio_s1 = peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;

  //allow new arb cycle for ADC_data_pio/s1, which is an e_assign
  assign ADC_data_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ADC_data_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ADC_data_pio_s1_master_qreq_vector = 1;

  //ADC_data_pio_s1_reset_n assignment, which is an e_assign
  assign ADC_data_pio_s1_reset_n = reset_n;

  //ADC_data_pio_s1_firsttransfer first transaction, which is an e_assign
  assign ADC_data_pio_s1_firsttransfer = ADC_data_pio_s1_begins_xfer ? ADC_data_pio_s1_unreg_firsttransfer : ADC_data_pio_s1_reg_firsttransfer;

  //ADC_data_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ADC_data_pio_s1_unreg_firsttransfer = ~(ADC_data_pio_s1_slavearbiterlockenable & ADC_data_pio_s1_any_continuerequest);

  //ADC_data_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ADC_data_pio_s1_reg_firsttransfer <= 1'b1;
      else if (ADC_data_pio_s1_begins_xfer)
          ADC_data_pio_s1_reg_firsttransfer <= ADC_data_pio_s1_unreg_firsttransfer;
    end


  //ADC_data_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ADC_data_pio_s1_beginbursttransfer_internal = ADC_data_pio_s1_begins_xfer;

  //ADC_data_pio_s1_address mux, which is an e_mux
  assign ADC_data_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_ADC_data_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ADC_data_pio_s1_end_xfer <= 1;
      else 
        d1_ADC_data_pio_s1_end_xfer <= ADC_data_pio_s1_end_xfer;
    end


  //ADC_data_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign ADC_data_pio_s1_waits_for_read = ADC_data_pio_s1_in_a_read_cycle & ADC_data_pio_s1_begins_xfer;

  //ADC_data_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign ADC_data_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_ADC_data_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ADC_data_pio_s1_in_a_read_cycle;

  //ADC_data_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign ADC_data_pio_s1_waits_for_write = ADC_data_pio_s1_in_a_write_cycle & 0;

  //ADC_data_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign ADC_data_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_ADC_data_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ADC_data_pio_s1_in_a_write_cycle;

  assign wait_for_ADC_data_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ADC_data_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_clock_0_in_arbitrator (
                                        // inputs:
                                         DE4_SOPC_clock_0_in_endofpacket,
                                         DE4_SOPC_clock_0_in_readdata,
                                         DE4_SOPC_clock_0_in_waitrequest,
                                         clk,
                                         cpu_data_master_address_to_slave,
                                         cpu_data_master_byteenable,
                                         cpu_data_master_latency_counter,
                                         cpu_data_master_read,
                                         cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                         cpu_data_master_write,
                                         cpu_data_master_writedata,
                                         reset_n,

                                        // outputs:
                                         DE4_SOPC_clock_0_in_address,
                                         DE4_SOPC_clock_0_in_byteenable,
                                         DE4_SOPC_clock_0_in_endofpacket_from_sa,
                                         DE4_SOPC_clock_0_in_nativeaddress,
                                         DE4_SOPC_clock_0_in_read,
                                         DE4_SOPC_clock_0_in_readdata_from_sa,
                                         DE4_SOPC_clock_0_in_reset_n,
                                         DE4_SOPC_clock_0_in_waitrequest_from_sa,
                                         DE4_SOPC_clock_0_in_write,
                                         DE4_SOPC_clock_0_in_writedata,
                                         cpu_data_master_granted_DE4_SOPC_clock_0_in,
                                         cpu_data_master_qualified_request_DE4_SOPC_clock_0_in,
                                         cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in,
                                         cpu_data_master_requests_DE4_SOPC_clock_0_in,
                                         d1_DE4_SOPC_clock_0_in_end_xfer
                                      )
;

  output  [  3: 0] DE4_SOPC_clock_0_in_address;
  output  [  1: 0] DE4_SOPC_clock_0_in_byteenable;
  output           DE4_SOPC_clock_0_in_endofpacket_from_sa;
  output  [  2: 0] DE4_SOPC_clock_0_in_nativeaddress;
  output           DE4_SOPC_clock_0_in_read;
  output  [ 15: 0] DE4_SOPC_clock_0_in_readdata_from_sa;
  output           DE4_SOPC_clock_0_in_reset_n;
  output           DE4_SOPC_clock_0_in_waitrequest_from_sa;
  output           DE4_SOPC_clock_0_in_write;
  output  [ 15: 0] DE4_SOPC_clock_0_in_writedata;
  output           cpu_data_master_granted_DE4_SOPC_clock_0_in;
  output           cpu_data_master_qualified_request_DE4_SOPC_clock_0_in;
  output           cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in;
  output           cpu_data_master_requests_DE4_SOPC_clock_0_in;
  output           d1_DE4_SOPC_clock_0_in_end_xfer;
  input            DE4_SOPC_clock_0_in_endofpacket;
  input   [ 15: 0] DE4_SOPC_clock_0_in_readdata;
  input            DE4_SOPC_clock_0_in_waitrequest;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;

  wire    [  3: 0] DE4_SOPC_clock_0_in_address;
  wire             DE4_SOPC_clock_0_in_allgrants;
  wire             DE4_SOPC_clock_0_in_allow_new_arb_cycle;
  wire             DE4_SOPC_clock_0_in_any_bursting_master_saved_grant;
  wire             DE4_SOPC_clock_0_in_any_continuerequest;
  wire             DE4_SOPC_clock_0_in_arb_counter_enable;
  reg     [  1: 0] DE4_SOPC_clock_0_in_arb_share_counter;
  wire    [  1: 0] DE4_SOPC_clock_0_in_arb_share_counter_next_value;
  wire    [  1: 0] DE4_SOPC_clock_0_in_arb_share_set_values;
  wire             DE4_SOPC_clock_0_in_beginbursttransfer_internal;
  wire             DE4_SOPC_clock_0_in_begins_xfer;
  wire    [  1: 0] DE4_SOPC_clock_0_in_byteenable;
  wire             DE4_SOPC_clock_0_in_end_xfer;
  wire             DE4_SOPC_clock_0_in_endofpacket_from_sa;
  wire             DE4_SOPC_clock_0_in_firsttransfer;
  wire             DE4_SOPC_clock_0_in_grant_vector;
  wire             DE4_SOPC_clock_0_in_in_a_read_cycle;
  wire             DE4_SOPC_clock_0_in_in_a_write_cycle;
  wire             DE4_SOPC_clock_0_in_master_qreq_vector;
  wire    [  2: 0] DE4_SOPC_clock_0_in_nativeaddress;
  wire             DE4_SOPC_clock_0_in_non_bursting_master_requests;
  wire             DE4_SOPC_clock_0_in_read;
  wire    [ 15: 0] DE4_SOPC_clock_0_in_readdata_from_sa;
  reg              DE4_SOPC_clock_0_in_reg_firsttransfer;
  wire             DE4_SOPC_clock_0_in_reset_n;
  reg              DE4_SOPC_clock_0_in_slavearbiterlockenable;
  wire             DE4_SOPC_clock_0_in_slavearbiterlockenable2;
  wire             DE4_SOPC_clock_0_in_unreg_firsttransfer;
  wire             DE4_SOPC_clock_0_in_waitrequest_from_sa;
  wire             DE4_SOPC_clock_0_in_waits_for_read;
  wire             DE4_SOPC_clock_0_in_waits_for_write;
  wire             DE4_SOPC_clock_0_in_write;
  wire    [ 15: 0] DE4_SOPC_clock_0_in_writedata;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_qualified_request_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_requests_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_saved_grant_DE4_SOPC_clock_0_in;
  reg              d1_DE4_SOPC_clock_0_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_DE4_SOPC_clock_0_in_from_cpu_data_master;
  wire             wait_for_DE4_SOPC_clock_0_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~DE4_SOPC_clock_0_in_end_xfer;
    end


  assign DE4_SOPC_clock_0_in_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_DE4_SOPC_clock_0_in));
  //assign DE4_SOPC_clock_0_in_readdata_from_sa = DE4_SOPC_clock_0_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_0_in_readdata_from_sa = DE4_SOPC_clock_0_in_readdata;

  assign cpu_data_master_requests_DE4_SOPC_clock_0_in = ({cpu_data_master_address_to_slave[26 : 5] , 5'b0} == 27'h5201c80) & (cpu_data_master_read | cpu_data_master_write);
  //assign DE4_SOPC_clock_0_in_waitrequest_from_sa = DE4_SOPC_clock_0_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_0_in_waitrequest_from_sa = DE4_SOPC_clock_0_in_waitrequest;

  //DE4_SOPC_clock_0_in_arb_share_counter set values, which is an e_mux
  assign DE4_SOPC_clock_0_in_arb_share_set_values = 1;

  //DE4_SOPC_clock_0_in_non_bursting_master_requests mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_non_bursting_master_requests = cpu_data_master_requests_DE4_SOPC_clock_0_in;

  //DE4_SOPC_clock_0_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_any_bursting_master_saved_grant = 0;

  //DE4_SOPC_clock_0_in_arb_share_counter_next_value assignment, which is an e_assign
  assign DE4_SOPC_clock_0_in_arb_share_counter_next_value = DE4_SOPC_clock_0_in_firsttransfer ? (DE4_SOPC_clock_0_in_arb_share_set_values - 1) : |DE4_SOPC_clock_0_in_arb_share_counter ? (DE4_SOPC_clock_0_in_arb_share_counter - 1) : 0;

  //DE4_SOPC_clock_0_in_allgrants all slave grants, which is an e_mux
  assign DE4_SOPC_clock_0_in_allgrants = |DE4_SOPC_clock_0_in_grant_vector;

  //DE4_SOPC_clock_0_in_end_xfer assignment, which is an e_assign
  assign DE4_SOPC_clock_0_in_end_xfer = ~(DE4_SOPC_clock_0_in_waits_for_read | DE4_SOPC_clock_0_in_waits_for_write);

  //end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in = DE4_SOPC_clock_0_in_end_xfer & (~DE4_SOPC_clock_0_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //DE4_SOPC_clock_0_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign DE4_SOPC_clock_0_in_arb_counter_enable = (end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in & DE4_SOPC_clock_0_in_allgrants) | (end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in & ~DE4_SOPC_clock_0_in_non_bursting_master_requests);

  //DE4_SOPC_clock_0_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_in_arb_share_counter <= 0;
      else if (DE4_SOPC_clock_0_in_arb_counter_enable)
          DE4_SOPC_clock_0_in_arb_share_counter <= DE4_SOPC_clock_0_in_arb_share_counter_next_value;
    end


  //DE4_SOPC_clock_0_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_in_slavearbiterlockenable <= 0;
      else if ((|DE4_SOPC_clock_0_in_master_qreq_vector & end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in) | (end_xfer_arb_share_counter_term_DE4_SOPC_clock_0_in & ~DE4_SOPC_clock_0_in_non_bursting_master_requests))
          DE4_SOPC_clock_0_in_slavearbiterlockenable <= |DE4_SOPC_clock_0_in_arb_share_counter_next_value;
    end


  //cpu/data_master DE4_SOPC_clock_0/in arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = DE4_SOPC_clock_0_in_slavearbiterlockenable & cpu_data_master_continuerequest;

  //DE4_SOPC_clock_0_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign DE4_SOPC_clock_0_in_slavearbiterlockenable2 = |DE4_SOPC_clock_0_in_arb_share_counter_next_value;

  //cpu/data_master DE4_SOPC_clock_0/in arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = DE4_SOPC_clock_0_in_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //DE4_SOPC_clock_0_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign DE4_SOPC_clock_0_in_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_DE4_SOPC_clock_0_in = cpu_data_master_requests_DE4_SOPC_clock_0_in & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in, which is an e_mux
  assign cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in = cpu_data_master_granted_DE4_SOPC_clock_0_in & cpu_data_master_read & ~DE4_SOPC_clock_0_in_waits_for_read;

  //DE4_SOPC_clock_0_in_writedata mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_writedata = cpu_data_master_writedata;

  //assign DE4_SOPC_clock_0_in_endofpacket_from_sa = DE4_SOPC_clock_0_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_0_in_endofpacket_from_sa = DE4_SOPC_clock_0_in_endofpacket;

  //master is always granted when requested
  assign cpu_data_master_granted_DE4_SOPC_clock_0_in = cpu_data_master_qualified_request_DE4_SOPC_clock_0_in;

  //cpu/data_master saved-grant DE4_SOPC_clock_0/in, which is an e_assign
  assign cpu_data_master_saved_grant_DE4_SOPC_clock_0_in = cpu_data_master_requests_DE4_SOPC_clock_0_in;

  //allow new arb cycle for DE4_SOPC_clock_0/in, which is an e_assign
  assign DE4_SOPC_clock_0_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign DE4_SOPC_clock_0_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign DE4_SOPC_clock_0_in_master_qreq_vector = 1;

  //DE4_SOPC_clock_0_in_reset_n assignment, which is an e_assign
  assign DE4_SOPC_clock_0_in_reset_n = reset_n;

  //DE4_SOPC_clock_0_in_firsttransfer first transaction, which is an e_assign
  assign DE4_SOPC_clock_0_in_firsttransfer = DE4_SOPC_clock_0_in_begins_xfer ? DE4_SOPC_clock_0_in_unreg_firsttransfer : DE4_SOPC_clock_0_in_reg_firsttransfer;

  //DE4_SOPC_clock_0_in_unreg_firsttransfer first transaction, which is an e_assign
  assign DE4_SOPC_clock_0_in_unreg_firsttransfer = ~(DE4_SOPC_clock_0_in_slavearbiterlockenable & DE4_SOPC_clock_0_in_any_continuerequest);

  //DE4_SOPC_clock_0_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_in_reg_firsttransfer <= 1'b1;
      else if (DE4_SOPC_clock_0_in_begins_xfer)
          DE4_SOPC_clock_0_in_reg_firsttransfer <= DE4_SOPC_clock_0_in_unreg_firsttransfer;
    end


  //DE4_SOPC_clock_0_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign DE4_SOPC_clock_0_in_beginbursttransfer_internal = DE4_SOPC_clock_0_in_begins_xfer;

  //DE4_SOPC_clock_0_in_read assignment, which is an e_mux
  assign DE4_SOPC_clock_0_in_read = cpu_data_master_granted_DE4_SOPC_clock_0_in & cpu_data_master_read;

  //DE4_SOPC_clock_0_in_write assignment, which is an e_mux
  assign DE4_SOPC_clock_0_in_write = cpu_data_master_granted_DE4_SOPC_clock_0_in & cpu_data_master_write;

  assign shifted_address_to_DE4_SOPC_clock_0_in_from_cpu_data_master = cpu_data_master_address_to_slave;
  //DE4_SOPC_clock_0_in_address mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_address = shifted_address_to_DE4_SOPC_clock_0_in_from_cpu_data_master >> 2;

  //slaveid DE4_SOPC_clock_0_in_nativeaddress nativeaddress mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_nativeaddress = cpu_data_master_address_to_slave >> 2;

  //d1_DE4_SOPC_clock_0_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_DE4_SOPC_clock_0_in_end_xfer <= 1;
      else 
        d1_DE4_SOPC_clock_0_in_end_xfer <= DE4_SOPC_clock_0_in_end_xfer;
    end


  //DE4_SOPC_clock_0_in_waits_for_read in a cycle, which is an e_mux
  assign DE4_SOPC_clock_0_in_waits_for_read = DE4_SOPC_clock_0_in_in_a_read_cycle & DE4_SOPC_clock_0_in_waitrequest_from_sa;

  //DE4_SOPC_clock_0_in_in_a_read_cycle assignment, which is an e_assign
  assign DE4_SOPC_clock_0_in_in_a_read_cycle = cpu_data_master_granted_DE4_SOPC_clock_0_in & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = DE4_SOPC_clock_0_in_in_a_read_cycle;

  //DE4_SOPC_clock_0_in_waits_for_write in a cycle, which is an e_mux
  assign DE4_SOPC_clock_0_in_waits_for_write = DE4_SOPC_clock_0_in_in_a_write_cycle & DE4_SOPC_clock_0_in_waitrequest_from_sa;

  //DE4_SOPC_clock_0_in_in_a_write_cycle assignment, which is an e_assign
  assign DE4_SOPC_clock_0_in_in_a_write_cycle = cpu_data_master_granted_DE4_SOPC_clock_0_in & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = DE4_SOPC_clock_0_in_in_a_write_cycle;

  assign wait_for_DE4_SOPC_clock_0_in_counter = 0;
  //DE4_SOPC_clock_0_in_byteenable byte enable port mux, which is an e_mux
  assign DE4_SOPC_clock_0_in_byteenable = (cpu_data_master_granted_DE4_SOPC_clock_0_in)? cpu_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE4_SOPC_clock_0/in enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_clock_0_out_arbitrator (
                                         // inputs:
                                          DE4_SOPC_clock_0_out_address,
                                          DE4_SOPC_clock_0_out_byteenable,
                                          DE4_SOPC_clock_0_out_granted_pll_s1,
                                          DE4_SOPC_clock_0_out_qualified_request_pll_s1,
                                          DE4_SOPC_clock_0_out_read,
                                          DE4_SOPC_clock_0_out_read_data_valid_pll_s1,
                                          DE4_SOPC_clock_0_out_requests_pll_s1,
                                          DE4_SOPC_clock_0_out_write,
                                          DE4_SOPC_clock_0_out_writedata,
                                          clk,
                                          d1_pll_s1_end_xfer,
                                          pll_s1_readdata_from_sa,
                                          reset_n,

                                         // outputs:
                                          DE4_SOPC_clock_0_out_address_to_slave,
                                          DE4_SOPC_clock_0_out_readdata,
                                          DE4_SOPC_clock_0_out_reset_n,
                                          DE4_SOPC_clock_0_out_waitrequest
                                       )
;

  output  [  3: 0] DE4_SOPC_clock_0_out_address_to_slave;
  output  [ 15: 0] DE4_SOPC_clock_0_out_readdata;
  output           DE4_SOPC_clock_0_out_reset_n;
  output           DE4_SOPC_clock_0_out_waitrequest;
  input   [  3: 0] DE4_SOPC_clock_0_out_address;
  input   [  1: 0] DE4_SOPC_clock_0_out_byteenable;
  input            DE4_SOPC_clock_0_out_granted_pll_s1;
  input            DE4_SOPC_clock_0_out_qualified_request_pll_s1;
  input            DE4_SOPC_clock_0_out_read;
  input            DE4_SOPC_clock_0_out_read_data_valid_pll_s1;
  input            DE4_SOPC_clock_0_out_requests_pll_s1;
  input            DE4_SOPC_clock_0_out_write;
  input   [ 15: 0] DE4_SOPC_clock_0_out_writedata;
  input            clk;
  input            d1_pll_s1_end_xfer;
  input   [ 15: 0] pll_s1_readdata_from_sa;
  input            reset_n;

  reg     [  3: 0] DE4_SOPC_clock_0_out_address_last_time;
  wire    [  3: 0] DE4_SOPC_clock_0_out_address_to_slave;
  reg     [  1: 0] DE4_SOPC_clock_0_out_byteenable_last_time;
  reg              DE4_SOPC_clock_0_out_read_last_time;
  wire    [ 15: 0] DE4_SOPC_clock_0_out_readdata;
  wire             DE4_SOPC_clock_0_out_reset_n;
  wire             DE4_SOPC_clock_0_out_run;
  wire             DE4_SOPC_clock_0_out_waitrequest;
  reg              DE4_SOPC_clock_0_out_write_last_time;
  reg     [ 15: 0] DE4_SOPC_clock_0_out_writedata_last_time;
  reg              active_and_waiting_last_time;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & ((~DE4_SOPC_clock_0_out_qualified_request_pll_s1 | ~DE4_SOPC_clock_0_out_read | (1 & ~d1_pll_s1_end_xfer & DE4_SOPC_clock_0_out_read))) & ((~DE4_SOPC_clock_0_out_qualified_request_pll_s1 | ~DE4_SOPC_clock_0_out_write | (1 & DE4_SOPC_clock_0_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign DE4_SOPC_clock_0_out_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign DE4_SOPC_clock_0_out_address_to_slave = DE4_SOPC_clock_0_out_address;

  //DE4_SOPC_clock_0/out readdata mux, which is an e_mux
  assign DE4_SOPC_clock_0_out_readdata = pll_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign DE4_SOPC_clock_0_out_waitrequest = ~DE4_SOPC_clock_0_out_run;

  //DE4_SOPC_clock_0_out_reset_n assignment, which is an e_assign
  assign DE4_SOPC_clock_0_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE4_SOPC_clock_0_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_out_address_last_time <= 0;
      else 
        DE4_SOPC_clock_0_out_address_last_time <= DE4_SOPC_clock_0_out_address;
    end


  //DE4_SOPC_clock_0/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= DE4_SOPC_clock_0_out_waitrequest & (DE4_SOPC_clock_0_out_read | DE4_SOPC_clock_0_out_write);
    end


  //DE4_SOPC_clock_0_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_0_out_address != DE4_SOPC_clock_0_out_address_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_0_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_0_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_out_byteenable_last_time <= 0;
      else 
        DE4_SOPC_clock_0_out_byteenable_last_time <= DE4_SOPC_clock_0_out_byteenable;
    end


  //DE4_SOPC_clock_0_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_0_out_byteenable != DE4_SOPC_clock_0_out_byteenable_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_0_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_0_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_out_read_last_time <= 0;
      else 
        DE4_SOPC_clock_0_out_read_last_time <= DE4_SOPC_clock_0_out_read;
    end


  //DE4_SOPC_clock_0_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_0_out_read != DE4_SOPC_clock_0_out_read_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_0_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_0_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_out_write_last_time <= 0;
      else 
        DE4_SOPC_clock_0_out_write_last_time <= DE4_SOPC_clock_0_out_write;
    end


  //DE4_SOPC_clock_0_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_0_out_write != DE4_SOPC_clock_0_out_write_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_0_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_0_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_0_out_writedata_last_time <= 0;
      else 
        DE4_SOPC_clock_0_out_writedata_last_time <= DE4_SOPC_clock_0_out_writedata;
    end


  //DE4_SOPC_clock_0_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_0_out_writedata != DE4_SOPC_clock_0_out_writedata_last_time) & DE4_SOPC_clock_0_out_write)
        begin
          $write("%0d ns: DE4_SOPC_clock_0_out_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_clock_1_in_arbitrator (
                                        // inputs:
                                         DE4_SOPC_clock_1_in_endofpacket,
                                         DE4_SOPC_clock_1_in_readdata,
                                         DE4_SOPC_clock_1_in_waitrequest,
                                         clk,
                                         cpu_data_master_address_to_slave,
                                         cpu_data_master_byteenable,
                                         cpu_data_master_latency_counter,
                                         cpu_data_master_read,
                                         cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                         cpu_data_master_write,
                                         cpu_data_master_writedata,
                                         reset_n,

                                        // outputs:
                                         DE4_SOPC_clock_1_in_address,
                                         DE4_SOPC_clock_1_in_byteenable,
                                         DE4_SOPC_clock_1_in_endofpacket_from_sa,
                                         DE4_SOPC_clock_1_in_nativeaddress,
                                         DE4_SOPC_clock_1_in_read,
                                         DE4_SOPC_clock_1_in_readdata_from_sa,
                                         DE4_SOPC_clock_1_in_reset_n,
                                         DE4_SOPC_clock_1_in_waitrequest_from_sa,
                                         DE4_SOPC_clock_1_in_write,
                                         DE4_SOPC_clock_1_in_writedata,
                                         cpu_data_master_granted_DE4_SOPC_clock_1_in,
                                         cpu_data_master_qualified_request_DE4_SOPC_clock_1_in,
                                         cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in,
                                         cpu_data_master_requests_DE4_SOPC_clock_1_in,
                                         d1_DE4_SOPC_clock_1_in_end_xfer
                                      )
;

  output  [  2: 0] DE4_SOPC_clock_1_in_address;
  output  [  3: 0] DE4_SOPC_clock_1_in_byteenable;
  output           DE4_SOPC_clock_1_in_endofpacket_from_sa;
  output           DE4_SOPC_clock_1_in_nativeaddress;
  output           DE4_SOPC_clock_1_in_read;
  output  [ 31: 0] DE4_SOPC_clock_1_in_readdata_from_sa;
  output           DE4_SOPC_clock_1_in_reset_n;
  output           DE4_SOPC_clock_1_in_waitrequest_from_sa;
  output           DE4_SOPC_clock_1_in_write;
  output  [ 31: 0] DE4_SOPC_clock_1_in_writedata;
  output           cpu_data_master_granted_DE4_SOPC_clock_1_in;
  output           cpu_data_master_qualified_request_DE4_SOPC_clock_1_in;
  output           cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in;
  output           cpu_data_master_requests_DE4_SOPC_clock_1_in;
  output           d1_DE4_SOPC_clock_1_in_end_xfer;
  input            DE4_SOPC_clock_1_in_endofpacket;
  input   [ 31: 0] DE4_SOPC_clock_1_in_readdata;
  input            DE4_SOPC_clock_1_in_waitrequest;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;

  wire    [  2: 0] DE4_SOPC_clock_1_in_address;
  wire             DE4_SOPC_clock_1_in_allgrants;
  wire             DE4_SOPC_clock_1_in_allow_new_arb_cycle;
  wire             DE4_SOPC_clock_1_in_any_bursting_master_saved_grant;
  wire             DE4_SOPC_clock_1_in_any_continuerequest;
  wire             DE4_SOPC_clock_1_in_arb_counter_enable;
  reg     [  1: 0] DE4_SOPC_clock_1_in_arb_share_counter;
  wire    [  1: 0] DE4_SOPC_clock_1_in_arb_share_counter_next_value;
  wire    [  1: 0] DE4_SOPC_clock_1_in_arb_share_set_values;
  wire             DE4_SOPC_clock_1_in_beginbursttransfer_internal;
  wire             DE4_SOPC_clock_1_in_begins_xfer;
  wire    [  3: 0] DE4_SOPC_clock_1_in_byteenable;
  wire             DE4_SOPC_clock_1_in_end_xfer;
  wire             DE4_SOPC_clock_1_in_endofpacket_from_sa;
  wire             DE4_SOPC_clock_1_in_firsttransfer;
  wire             DE4_SOPC_clock_1_in_grant_vector;
  wire             DE4_SOPC_clock_1_in_in_a_read_cycle;
  wire             DE4_SOPC_clock_1_in_in_a_write_cycle;
  wire             DE4_SOPC_clock_1_in_master_qreq_vector;
  wire             DE4_SOPC_clock_1_in_nativeaddress;
  wire             DE4_SOPC_clock_1_in_non_bursting_master_requests;
  wire             DE4_SOPC_clock_1_in_read;
  wire    [ 31: 0] DE4_SOPC_clock_1_in_readdata_from_sa;
  reg              DE4_SOPC_clock_1_in_reg_firsttransfer;
  wire             DE4_SOPC_clock_1_in_reset_n;
  reg              DE4_SOPC_clock_1_in_slavearbiterlockenable;
  wire             DE4_SOPC_clock_1_in_slavearbiterlockenable2;
  wire             DE4_SOPC_clock_1_in_unreg_firsttransfer;
  wire             DE4_SOPC_clock_1_in_waitrequest_from_sa;
  wire             DE4_SOPC_clock_1_in_waits_for_read;
  wire             DE4_SOPC_clock_1_in_waits_for_write;
  wire             DE4_SOPC_clock_1_in_write;
  wire    [ 31: 0] DE4_SOPC_clock_1_in_writedata;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_qualified_request_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_requests_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_saved_grant_DE4_SOPC_clock_1_in;
  reg              d1_DE4_SOPC_clock_1_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_DE4_SOPC_clock_1_in_from_cpu_data_master;
  wire             wait_for_DE4_SOPC_clock_1_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~DE4_SOPC_clock_1_in_end_xfer;
    end


  assign DE4_SOPC_clock_1_in_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_DE4_SOPC_clock_1_in));
  //assign DE4_SOPC_clock_1_in_readdata_from_sa = DE4_SOPC_clock_1_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_1_in_readdata_from_sa = DE4_SOPC_clock_1_in_readdata;

  assign cpu_data_master_requests_DE4_SOPC_clock_1_in = ({cpu_data_master_address_to_slave[26 : 3] , 3'b0} == 27'h5201ce8) & (cpu_data_master_read | cpu_data_master_write);
  //assign DE4_SOPC_clock_1_in_waitrequest_from_sa = DE4_SOPC_clock_1_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_1_in_waitrequest_from_sa = DE4_SOPC_clock_1_in_waitrequest;

  //DE4_SOPC_clock_1_in_arb_share_counter set values, which is an e_mux
  assign DE4_SOPC_clock_1_in_arb_share_set_values = 1;

  //DE4_SOPC_clock_1_in_non_bursting_master_requests mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_non_bursting_master_requests = cpu_data_master_requests_DE4_SOPC_clock_1_in;

  //DE4_SOPC_clock_1_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_any_bursting_master_saved_grant = 0;

  //DE4_SOPC_clock_1_in_arb_share_counter_next_value assignment, which is an e_assign
  assign DE4_SOPC_clock_1_in_arb_share_counter_next_value = DE4_SOPC_clock_1_in_firsttransfer ? (DE4_SOPC_clock_1_in_arb_share_set_values - 1) : |DE4_SOPC_clock_1_in_arb_share_counter ? (DE4_SOPC_clock_1_in_arb_share_counter - 1) : 0;

  //DE4_SOPC_clock_1_in_allgrants all slave grants, which is an e_mux
  assign DE4_SOPC_clock_1_in_allgrants = |DE4_SOPC_clock_1_in_grant_vector;

  //DE4_SOPC_clock_1_in_end_xfer assignment, which is an e_assign
  assign DE4_SOPC_clock_1_in_end_xfer = ~(DE4_SOPC_clock_1_in_waits_for_read | DE4_SOPC_clock_1_in_waits_for_write);

  //end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in = DE4_SOPC_clock_1_in_end_xfer & (~DE4_SOPC_clock_1_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //DE4_SOPC_clock_1_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign DE4_SOPC_clock_1_in_arb_counter_enable = (end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in & DE4_SOPC_clock_1_in_allgrants) | (end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in & ~DE4_SOPC_clock_1_in_non_bursting_master_requests);

  //DE4_SOPC_clock_1_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_in_arb_share_counter <= 0;
      else if (DE4_SOPC_clock_1_in_arb_counter_enable)
          DE4_SOPC_clock_1_in_arb_share_counter <= DE4_SOPC_clock_1_in_arb_share_counter_next_value;
    end


  //DE4_SOPC_clock_1_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_in_slavearbiterlockenable <= 0;
      else if ((|DE4_SOPC_clock_1_in_master_qreq_vector & end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in) | (end_xfer_arb_share_counter_term_DE4_SOPC_clock_1_in & ~DE4_SOPC_clock_1_in_non_bursting_master_requests))
          DE4_SOPC_clock_1_in_slavearbiterlockenable <= |DE4_SOPC_clock_1_in_arb_share_counter_next_value;
    end


  //cpu/data_master DE4_SOPC_clock_1/in arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = DE4_SOPC_clock_1_in_slavearbiterlockenable & cpu_data_master_continuerequest;

  //DE4_SOPC_clock_1_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign DE4_SOPC_clock_1_in_slavearbiterlockenable2 = |DE4_SOPC_clock_1_in_arb_share_counter_next_value;

  //cpu/data_master DE4_SOPC_clock_1/in arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = DE4_SOPC_clock_1_in_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //DE4_SOPC_clock_1_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign DE4_SOPC_clock_1_in_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_DE4_SOPC_clock_1_in = cpu_data_master_requests_DE4_SOPC_clock_1_in & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in, which is an e_mux
  assign cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in = cpu_data_master_granted_DE4_SOPC_clock_1_in & cpu_data_master_read & ~DE4_SOPC_clock_1_in_waits_for_read;

  //DE4_SOPC_clock_1_in_writedata mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_writedata = cpu_data_master_writedata;

  //assign DE4_SOPC_clock_1_in_endofpacket_from_sa = DE4_SOPC_clock_1_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE4_SOPC_clock_1_in_endofpacket_from_sa = DE4_SOPC_clock_1_in_endofpacket;

  //master is always granted when requested
  assign cpu_data_master_granted_DE4_SOPC_clock_1_in = cpu_data_master_qualified_request_DE4_SOPC_clock_1_in;

  //cpu/data_master saved-grant DE4_SOPC_clock_1/in, which is an e_assign
  assign cpu_data_master_saved_grant_DE4_SOPC_clock_1_in = cpu_data_master_requests_DE4_SOPC_clock_1_in;

  //allow new arb cycle for DE4_SOPC_clock_1/in, which is an e_assign
  assign DE4_SOPC_clock_1_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign DE4_SOPC_clock_1_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign DE4_SOPC_clock_1_in_master_qreq_vector = 1;

  //DE4_SOPC_clock_1_in_reset_n assignment, which is an e_assign
  assign DE4_SOPC_clock_1_in_reset_n = reset_n;

  //DE4_SOPC_clock_1_in_firsttransfer first transaction, which is an e_assign
  assign DE4_SOPC_clock_1_in_firsttransfer = DE4_SOPC_clock_1_in_begins_xfer ? DE4_SOPC_clock_1_in_unreg_firsttransfer : DE4_SOPC_clock_1_in_reg_firsttransfer;

  //DE4_SOPC_clock_1_in_unreg_firsttransfer first transaction, which is an e_assign
  assign DE4_SOPC_clock_1_in_unreg_firsttransfer = ~(DE4_SOPC_clock_1_in_slavearbiterlockenable & DE4_SOPC_clock_1_in_any_continuerequest);

  //DE4_SOPC_clock_1_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_in_reg_firsttransfer <= 1'b1;
      else if (DE4_SOPC_clock_1_in_begins_xfer)
          DE4_SOPC_clock_1_in_reg_firsttransfer <= DE4_SOPC_clock_1_in_unreg_firsttransfer;
    end


  //DE4_SOPC_clock_1_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign DE4_SOPC_clock_1_in_beginbursttransfer_internal = DE4_SOPC_clock_1_in_begins_xfer;

  //DE4_SOPC_clock_1_in_read assignment, which is an e_mux
  assign DE4_SOPC_clock_1_in_read = cpu_data_master_granted_DE4_SOPC_clock_1_in & cpu_data_master_read;

  //DE4_SOPC_clock_1_in_write assignment, which is an e_mux
  assign DE4_SOPC_clock_1_in_write = cpu_data_master_granted_DE4_SOPC_clock_1_in & cpu_data_master_write;

  assign shifted_address_to_DE4_SOPC_clock_1_in_from_cpu_data_master = cpu_data_master_address_to_slave;
  //DE4_SOPC_clock_1_in_address mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_address = shifted_address_to_DE4_SOPC_clock_1_in_from_cpu_data_master >> 2;

  //slaveid DE4_SOPC_clock_1_in_nativeaddress nativeaddress mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_nativeaddress = cpu_data_master_address_to_slave >> 2;

  //d1_DE4_SOPC_clock_1_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_DE4_SOPC_clock_1_in_end_xfer <= 1;
      else 
        d1_DE4_SOPC_clock_1_in_end_xfer <= DE4_SOPC_clock_1_in_end_xfer;
    end


  //DE4_SOPC_clock_1_in_waits_for_read in a cycle, which is an e_mux
  assign DE4_SOPC_clock_1_in_waits_for_read = DE4_SOPC_clock_1_in_in_a_read_cycle & DE4_SOPC_clock_1_in_waitrequest_from_sa;

  //DE4_SOPC_clock_1_in_in_a_read_cycle assignment, which is an e_assign
  assign DE4_SOPC_clock_1_in_in_a_read_cycle = cpu_data_master_granted_DE4_SOPC_clock_1_in & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = DE4_SOPC_clock_1_in_in_a_read_cycle;

  //DE4_SOPC_clock_1_in_waits_for_write in a cycle, which is an e_mux
  assign DE4_SOPC_clock_1_in_waits_for_write = DE4_SOPC_clock_1_in_in_a_write_cycle & DE4_SOPC_clock_1_in_waitrequest_from_sa;

  //DE4_SOPC_clock_1_in_in_a_write_cycle assignment, which is an e_assign
  assign DE4_SOPC_clock_1_in_in_a_write_cycle = cpu_data_master_granted_DE4_SOPC_clock_1_in & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = DE4_SOPC_clock_1_in_in_a_write_cycle;

  assign wait_for_DE4_SOPC_clock_1_in_counter = 0;
  //DE4_SOPC_clock_1_in_byteenable byte enable port mux, which is an e_mux
  assign DE4_SOPC_clock_1_in_byteenable = (cpu_data_master_granted_DE4_SOPC_clock_1_in)? cpu_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE4_SOPC_clock_1/in enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_clock_1_out_arbitrator (
                                         // inputs:
                                          DE4_SOPC_clock_1_out_address,
                                          DE4_SOPC_clock_1_out_byteenable,
                                          DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave,
                                          DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave,
                                          DE4_SOPC_clock_1_out_read,
                                          DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave,
                                          DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave,
                                          DE4_SOPC_clock_1_out_write,
                                          DE4_SOPC_clock_1_out_writedata,
                                          clk,
                                          d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                          jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                          jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                          reset_n,

                                         // outputs:
                                          DE4_SOPC_clock_1_out_address_to_slave,
                                          DE4_SOPC_clock_1_out_readdata,
                                          DE4_SOPC_clock_1_out_reset_n,
                                          DE4_SOPC_clock_1_out_waitrequest
                                       )
;

  output  [  2: 0] DE4_SOPC_clock_1_out_address_to_slave;
  output  [ 31: 0] DE4_SOPC_clock_1_out_readdata;
  output           DE4_SOPC_clock_1_out_reset_n;
  output           DE4_SOPC_clock_1_out_waitrequest;
  input   [  2: 0] DE4_SOPC_clock_1_out_address;
  input   [  3: 0] DE4_SOPC_clock_1_out_byteenable;
  input            DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave;
  input            DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave;
  input            DE4_SOPC_clock_1_out_read;
  input            DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;
  input            DE4_SOPC_clock_1_out_write;
  input   [ 31: 0] DE4_SOPC_clock_1_out_writedata;
  input            clk;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input            reset_n;

  reg     [  2: 0] DE4_SOPC_clock_1_out_address_last_time;
  wire    [  2: 0] DE4_SOPC_clock_1_out_address_to_slave;
  reg     [  3: 0] DE4_SOPC_clock_1_out_byteenable_last_time;
  reg              DE4_SOPC_clock_1_out_read_last_time;
  wire    [ 31: 0] DE4_SOPC_clock_1_out_readdata;
  wire             DE4_SOPC_clock_1_out_reset_n;
  wire             DE4_SOPC_clock_1_out_run;
  wire             DE4_SOPC_clock_1_out_waitrequest;
  reg              DE4_SOPC_clock_1_out_write_last_time;
  reg     [ 31: 0] DE4_SOPC_clock_1_out_writedata_last_time;
  reg              active_and_waiting_last_time;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & ((~DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave | ~(DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write)))) & ((~DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave | ~(DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign DE4_SOPC_clock_1_out_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign DE4_SOPC_clock_1_out_address_to_slave = DE4_SOPC_clock_1_out_address;

  //DE4_SOPC_clock_1/out readdata mux, which is an e_mux
  assign DE4_SOPC_clock_1_out_readdata = jtag_uart_avalon_jtag_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign DE4_SOPC_clock_1_out_waitrequest = ~DE4_SOPC_clock_1_out_run;

  //DE4_SOPC_clock_1_out_reset_n assignment, which is an e_assign
  assign DE4_SOPC_clock_1_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE4_SOPC_clock_1_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_out_address_last_time <= 0;
      else 
        DE4_SOPC_clock_1_out_address_last_time <= DE4_SOPC_clock_1_out_address;
    end


  //DE4_SOPC_clock_1/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= DE4_SOPC_clock_1_out_waitrequest & (DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write);
    end


  //DE4_SOPC_clock_1_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_1_out_address != DE4_SOPC_clock_1_out_address_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_1_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_1_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_out_byteenable_last_time <= 0;
      else 
        DE4_SOPC_clock_1_out_byteenable_last_time <= DE4_SOPC_clock_1_out_byteenable;
    end


  //DE4_SOPC_clock_1_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_1_out_byteenable != DE4_SOPC_clock_1_out_byteenable_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_1_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_1_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_out_read_last_time <= 0;
      else 
        DE4_SOPC_clock_1_out_read_last_time <= DE4_SOPC_clock_1_out_read;
    end


  //DE4_SOPC_clock_1_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_1_out_read != DE4_SOPC_clock_1_out_read_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_1_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_1_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_out_write_last_time <= 0;
      else 
        DE4_SOPC_clock_1_out_write_last_time <= DE4_SOPC_clock_1_out_write;
    end


  //DE4_SOPC_clock_1_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_1_out_write != DE4_SOPC_clock_1_out_write_last_time))
        begin
          $write("%0d ns: DE4_SOPC_clock_1_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE4_SOPC_clock_1_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE4_SOPC_clock_1_out_writedata_last_time <= 0;
      else 
        DE4_SOPC_clock_1_out_writedata_last_time <= DE4_SOPC_clock_1_out_writedata;
    end


  //DE4_SOPC_clock_1_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE4_SOPC_clock_1_out_writedata != DE4_SOPC_clock_1_out_writedata_last_time) & DE4_SOPC_clock_1_out_write)
        begin
          $write("%0d ns: DE4_SOPC_clock_1_out_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module acq_busy_pio_s1_arbitrator (
                                    // inputs:
                                     acq_busy_pio_s1_readdata,
                                     clk,
                                     peripheral_clock_crossing_m1_address_to_slave,
                                     peripheral_clock_crossing_m1_latency_counter,
                                     peripheral_clock_crossing_m1_nativeaddress,
                                     peripheral_clock_crossing_m1_read,
                                     peripheral_clock_crossing_m1_write,
                                     reset_n,

                                    // outputs:
                                     acq_busy_pio_s1_address,
                                     acq_busy_pio_s1_readdata_from_sa,
                                     acq_busy_pio_s1_reset_n,
                                     d1_acq_busy_pio_s1_end_xfer,
                                     peripheral_clock_crossing_m1_granted_acq_busy_pio_s1,
                                     peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1,
                                     peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1,
                                     peripheral_clock_crossing_m1_requests_acq_busy_pio_s1
                                  )
;

  output  [  1: 0] acq_busy_pio_s1_address;
  output           acq_busy_pio_s1_readdata_from_sa;
  output           acq_busy_pio_s1_reset_n;
  output           d1_acq_busy_pio_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_acq_busy_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1;
  output           peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;
  input            acq_busy_pio_s1_readdata;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input            reset_n;

  wire    [  1: 0] acq_busy_pio_s1_address;
  wire             acq_busy_pio_s1_allgrants;
  wire             acq_busy_pio_s1_allow_new_arb_cycle;
  wire             acq_busy_pio_s1_any_bursting_master_saved_grant;
  wire             acq_busy_pio_s1_any_continuerequest;
  wire             acq_busy_pio_s1_arb_counter_enable;
  reg              acq_busy_pio_s1_arb_share_counter;
  wire             acq_busy_pio_s1_arb_share_counter_next_value;
  wire             acq_busy_pio_s1_arb_share_set_values;
  wire             acq_busy_pio_s1_beginbursttransfer_internal;
  wire             acq_busy_pio_s1_begins_xfer;
  wire             acq_busy_pio_s1_end_xfer;
  wire             acq_busy_pio_s1_firsttransfer;
  wire             acq_busy_pio_s1_grant_vector;
  wire             acq_busy_pio_s1_in_a_read_cycle;
  wire             acq_busy_pio_s1_in_a_write_cycle;
  wire             acq_busy_pio_s1_master_qreq_vector;
  wire             acq_busy_pio_s1_non_bursting_master_requests;
  wire             acq_busy_pio_s1_readdata_from_sa;
  reg              acq_busy_pio_s1_reg_firsttransfer;
  wire             acq_busy_pio_s1_reset_n;
  reg              acq_busy_pio_s1_slavearbiterlockenable;
  wire             acq_busy_pio_s1_slavearbiterlockenable2;
  wire             acq_busy_pio_s1_unreg_firsttransfer;
  wire             acq_busy_pio_s1_waits_for_read;
  wire             acq_busy_pio_s1_waits_for_write;
  reg              d1_acq_busy_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_acq_busy_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_acq_busy_pio_s1;
  wire             wait_for_acq_busy_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~acq_busy_pio_s1_end_xfer;
    end


  assign acq_busy_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1));
  //assign acq_busy_pio_s1_readdata_from_sa = acq_busy_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign acq_busy_pio_s1_readdata_from_sa = acq_busy_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_acq_busy_pio_s1 = (({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h40) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write)) & peripheral_clock_crossing_m1_read;
  //acq_busy_pio_s1_arb_share_counter set values, which is an e_mux
  assign acq_busy_pio_s1_arb_share_set_values = 1;

  //acq_busy_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign acq_busy_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;

  //acq_busy_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign acq_busy_pio_s1_any_bursting_master_saved_grant = 0;

  //acq_busy_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign acq_busy_pio_s1_arb_share_counter_next_value = acq_busy_pio_s1_firsttransfer ? (acq_busy_pio_s1_arb_share_set_values - 1) : |acq_busy_pio_s1_arb_share_counter ? (acq_busy_pio_s1_arb_share_counter - 1) : 0;

  //acq_busy_pio_s1_allgrants all slave grants, which is an e_mux
  assign acq_busy_pio_s1_allgrants = |acq_busy_pio_s1_grant_vector;

  //acq_busy_pio_s1_end_xfer assignment, which is an e_assign
  assign acq_busy_pio_s1_end_xfer = ~(acq_busy_pio_s1_waits_for_read | acq_busy_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_acq_busy_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_acq_busy_pio_s1 = acq_busy_pio_s1_end_xfer & (~acq_busy_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //acq_busy_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign acq_busy_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_acq_busy_pio_s1 & acq_busy_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_acq_busy_pio_s1 & ~acq_busy_pio_s1_non_bursting_master_requests);

  //acq_busy_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          acq_busy_pio_s1_arb_share_counter <= 0;
      else if (acq_busy_pio_s1_arb_counter_enable)
          acq_busy_pio_s1_arb_share_counter <= acq_busy_pio_s1_arb_share_counter_next_value;
    end


  //acq_busy_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          acq_busy_pio_s1_slavearbiterlockenable <= 0;
      else if ((|acq_busy_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_acq_busy_pio_s1) | (end_xfer_arb_share_counter_term_acq_busy_pio_s1 & ~acq_busy_pio_s1_non_bursting_master_requests))
          acq_busy_pio_s1_slavearbiterlockenable <= |acq_busy_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 acq_busy_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = acq_busy_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //acq_busy_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign acq_busy_pio_s1_slavearbiterlockenable2 = |acq_busy_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 acq_busy_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = acq_busy_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //acq_busy_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign acq_busy_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 = peripheral_clock_crossing_m1_requests_acq_busy_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1 = peripheral_clock_crossing_m1_granted_acq_busy_pio_s1 & peripheral_clock_crossing_m1_read & ~acq_busy_pio_s1_waits_for_read;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_acq_busy_pio_s1 = peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant acq_busy_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_acq_busy_pio_s1 = peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;

  //allow new arb cycle for acq_busy_pio/s1, which is an e_assign
  assign acq_busy_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign acq_busy_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign acq_busy_pio_s1_master_qreq_vector = 1;

  //acq_busy_pio_s1_reset_n assignment, which is an e_assign
  assign acq_busy_pio_s1_reset_n = reset_n;

  //acq_busy_pio_s1_firsttransfer first transaction, which is an e_assign
  assign acq_busy_pio_s1_firsttransfer = acq_busy_pio_s1_begins_xfer ? acq_busy_pio_s1_unreg_firsttransfer : acq_busy_pio_s1_reg_firsttransfer;

  //acq_busy_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign acq_busy_pio_s1_unreg_firsttransfer = ~(acq_busy_pio_s1_slavearbiterlockenable & acq_busy_pio_s1_any_continuerequest);

  //acq_busy_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          acq_busy_pio_s1_reg_firsttransfer <= 1'b1;
      else if (acq_busy_pio_s1_begins_xfer)
          acq_busy_pio_s1_reg_firsttransfer <= acq_busy_pio_s1_unreg_firsttransfer;
    end


  //acq_busy_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign acq_busy_pio_s1_beginbursttransfer_internal = acq_busy_pio_s1_begins_xfer;

  //acq_busy_pio_s1_address mux, which is an e_mux
  assign acq_busy_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_acq_busy_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_acq_busy_pio_s1_end_xfer <= 1;
      else 
        d1_acq_busy_pio_s1_end_xfer <= acq_busy_pio_s1_end_xfer;
    end


  //acq_busy_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign acq_busy_pio_s1_waits_for_read = acq_busy_pio_s1_in_a_read_cycle & acq_busy_pio_s1_begins_xfer;

  //acq_busy_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign acq_busy_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_acq_busy_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = acq_busy_pio_s1_in_a_read_cycle;

  //acq_busy_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign acq_busy_pio_s1_waits_for_write = acq_busy_pio_s1_in_a_write_cycle & 0;

  //acq_busy_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign acq_busy_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_acq_busy_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = acq_busy_pio_s1_in_a_write_cycle;

  assign wait_for_acq_busy_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //acq_busy_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_jtag_debug_module_arbitrator (
                                          // inputs:
                                           clk,
                                           cpu_data_master_address_to_slave,
                                           cpu_data_master_byteenable,
                                           cpu_data_master_debugaccess,
                                           cpu_data_master_latency_counter,
                                           cpu_data_master_read,
                                           cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                           cpu_data_master_write,
                                           cpu_data_master_writedata,
                                           cpu_instruction_master_address_to_slave,
                                           cpu_instruction_master_latency_counter,
                                           cpu_instruction_master_read,
                                           cpu_jtag_debug_module_readdata,
                                           cpu_jtag_debug_module_resetrequest,
                                           reset_n,

                                          // outputs:
                                           cpu_data_master_granted_cpu_jtag_debug_module,
                                           cpu_data_master_qualified_request_cpu_jtag_debug_module,
                                           cpu_data_master_read_data_valid_cpu_jtag_debug_module,
                                           cpu_data_master_requests_cpu_jtag_debug_module,
                                           cpu_instruction_master_granted_cpu_jtag_debug_module,
                                           cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
                                           cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
                                           cpu_instruction_master_requests_cpu_jtag_debug_module,
                                           cpu_jtag_debug_module_address,
                                           cpu_jtag_debug_module_begintransfer,
                                           cpu_jtag_debug_module_byteenable,
                                           cpu_jtag_debug_module_chipselect,
                                           cpu_jtag_debug_module_debugaccess,
                                           cpu_jtag_debug_module_readdata_from_sa,
                                           cpu_jtag_debug_module_reset_n,
                                           cpu_jtag_debug_module_resetrequest_from_sa,
                                           cpu_jtag_debug_module_write,
                                           cpu_jtag_debug_module_writedata,
                                           d1_cpu_jtag_debug_module_end_xfer
                                        )
;

  output           cpu_data_master_granted_cpu_jtag_debug_module;
  output           cpu_data_master_qualified_request_cpu_jtag_debug_module;
  output           cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  output           cpu_data_master_requests_cpu_jtag_debug_module;
  output           cpu_instruction_master_granted_cpu_jtag_debug_module;
  output           cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  output           cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  output           cpu_instruction_master_requests_cpu_jtag_debug_module;
  output  [  8: 0] cpu_jtag_debug_module_address;
  output           cpu_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_jtag_debug_module_byteenable;
  output           cpu_jtag_debug_module_chipselect;
  output           cpu_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  output           cpu_jtag_debug_module_reset_n;
  output           cpu_jtag_debug_module_resetrequest_from_sa;
  output           cpu_jtag_debug_module_write;
  output  [ 31: 0] cpu_jtag_debug_module_writedata;
  output           d1_cpu_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input            cpu_data_master_debugaccess;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 26: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input   [ 31: 0] cpu_jtag_debug_module_readdata;
  input            cpu_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_cpu_jtag_debug_module;
  wire             cpu_data_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_data_master_requests_cpu_jtag_debug_module;
  wire             cpu_data_master_saved_grant_cpu_jtag_debug_module;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_cpu_jtag_debug_module;
  wire             cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_instruction_master_requests_cpu_jtag_debug_module;
  wire             cpu_instruction_master_saved_grant_cpu_jtag_debug_module;
  wire    [  8: 0] cpu_jtag_debug_module_address;
  wire             cpu_jtag_debug_module_allgrants;
  wire             cpu_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_jtag_debug_module_any_bursting_master_saved_grant;
  wire             cpu_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_jtag_debug_module_arb_addend;
  wire             cpu_jtag_debug_module_arb_counter_enable;
  reg     [  1: 0] cpu_jtag_debug_module_arb_share_counter;
  wire    [  1: 0] cpu_jtag_debug_module_arb_share_counter_next_value;
  wire    [  1: 0] cpu_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_jtag_debug_module_arb_winner;
  wire             cpu_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_jtag_debug_module_begins_xfer;
  wire             cpu_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_jtag_debug_module_byteenable;
  wire             cpu_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_jtag_debug_module_debugaccess;
  wire             cpu_jtag_debug_module_end_xfer;
  wire             cpu_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_jtag_debug_module_grant_vector;
  wire             cpu_jtag_debug_module_in_a_read_cycle;
  wire             cpu_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_jtag_debug_module_master_qreq_vector;
  wire             cpu_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  reg              cpu_jtag_debug_module_reg_firsttransfer;
  wire             cpu_jtag_debug_module_reset_n;
  wire             cpu_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_jtag_debug_module_unreg_firsttransfer;
  wire             cpu_jtag_debug_module_waits_for_read;
  wire             cpu_jtag_debug_module_waits_for_write;
  wire             cpu_jtag_debug_module_write;
  wire    [ 31: 0] cpu_jtag_debug_module_writedata;
  reg              d1_cpu_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cpu_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module;
  reg              last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module;
  wire    [ 26: 0] shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master;
  wire    [ 26: 0] shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master;
  wire             wait_for_cpu_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cpu_jtag_debug_module_end_xfer;
    end


  assign cpu_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_cpu_jtag_debug_module | cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  //assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata;

  assign cpu_data_master_requests_cpu_jtag_debug_module = ({cpu_data_master_address_to_slave[26 : 11] , 11'b0} == 27'h5200800) & (cpu_data_master_read | cpu_data_master_write);
  //cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_jtag_debug_module_arb_share_set_values = 1;

  //cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_jtag_debug_module_non_bursting_master_requests = cpu_data_master_requests_cpu_jtag_debug_module |
    cpu_instruction_master_requests_cpu_jtag_debug_module |
    cpu_data_master_requests_cpu_jtag_debug_module |
    cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign cpu_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_jtag_debug_module_arb_share_counter_next_value = cpu_jtag_debug_module_firsttransfer ? (cpu_jtag_debug_module_arb_share_set_values - 1) : |cpu_jtag_debug_module_arb_share_counter ? (cpu_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_jtag_debug_module_allgrants = (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector);

  //cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_jtag_debug_module_end_xfer = ~(cpu_jtag_debug_module_waits_for_read | cpu_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cpu_jtag_debug_module = cpu_jtag_debug_module_end_xfer & (~cpu_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & cpu_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & ~cpu_jtag_debug_module_non_bursting_master_requests);

  //cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_jtag_debug_module_arb_counter_enable)
          cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_cpu_jtag_debug_module) | (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & ~cpu_jtag_debug_module_non_bursting_master_requests))
          cpu_jtag_debug_module_slavearbiterlockenable <= |cpu_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = cpu_jtag_debug_module_slavearbiterlockenable & cpu_data_master_continuerequest;

  //cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_jtag_debug_module_slavearbiterlockenable2 = |cpu_jtag_debug_module_arb_share_counter_next_value;

  //cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = cpu_jtag_debug_module_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = cpu_jtag_debug_module_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = cpu_jtag_debug_module_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= cpu_instruction_master_saved_grant_cpu_jtag_debug_module ? 1 : (cpu_jtag_debug_module_arbitration_holdoff_internal | ~cpu_instruction_master_requests_cpu_jtag_debug_module) ? 0 : last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module & cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_jtag_debug_module_any_continuerequest = cpu_instruction_master_continuerequest |
    cpu_data_master_continuerequest;

  assign cpu_data_master_qualified_request_cpu_jtag_debug_module = cpu_data_master_requests_cpu_jtag_debug_module & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))) | cpu_instruction_master_arbiterlock);
  //local readdatavalid cpu_data_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  assign cpu_data_master_read_data_valid_cpu_jtag_debug_module = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_read & ~cpu_jtag_debug_module_waits_for_read;

  //cpu_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_jtag_debug_module_writedata = cpu_data_master_writedata;

  assign cpu_instruction_master_requests_cpu_jtag_debug_module = (({cpu_instruction_master_address_to_slave[26 : 11] , 11'b0} == 27'h5200800) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= cpu_data_master_saved_grant_cpu_jtag_debug_module ? 1 : (cpu_jtag_debug_module_arbitration_holdoff_internal | ~cpu_data_master_requests_cpu_jtag_debug_module) ? 0 : last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module & cpu_data_master_requests_cpu_jtag_debug_module;

  assign cpu_instruction_master_qualified_request_cpu_jtag_debug_module = cpu_instruction_master_requests_cpu_jtag_debug_module & ~((cpu_instruction_master_read & ((cpu_instruction_master_latency_counter != 0))) | cpu_data_master_arbiterlock);
  //local readdatavalid cpu_instruction_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  assign cpu_instruction_master_read_data_valid_cpu_jtag_debug_module = cpu_instruction_master_granted_cpu_jtag_debug_module & cpu_instruction_master_read & ~cpu_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_master_qreq_vector[0] = cpu_instruction_master_qualified_request_cpu_jtag_debug_module;

  //cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_instruction_master_granted_cpu_jtag_debug_module = cpu_jtag_debug_module_grant_vector[0];

  //cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_instruction_master_saved_grant_cpu_jtag_debug_module = cpu_jtag_debug_module_arb_winner[0] && cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_master_qreq_vector[1] = cpu_data_master_qualified_request_cpu_jtag_debug_module;

  //cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_data_master_granted_cpu_jtag_debug_module = cpu_jtag_debug_module_grant_vector[1];

  //cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_data_master_saved_grant_cpu_jtag_debug_module = cpu_jtag_debug_module_arb_winner[1] && cpu_data_master_requests_cpu_jtag_debug_module;

  //cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_jtag_debug_module_chosen_master_double_vector = {cpu_jtag_debug_module_master_qreq_vector, cpu_jtag_debug_module_master_qreq_vector} & ({~cpu_jtag_debug_module_master_qreq_vector, ~cpu_jtag_debug_module_master_qreq_vector} + cpu_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_jtag_debug_module_arb_winner = (cpu_jtag_debug_module_allow_new_arb_cycle & | cpu_jtag_debug_module_grant_vector) ? cpu_jtag_debug_module_grant_vector : cpu_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_jtag_debug_module_allow_new_arb_cycle)
          cpu_jtag_debug_module_saved_chosen_master_vector <= |cpu_jtag_debug_module_grant_vector ? cpu_jtag_debug_module_grant_vector : cpu_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_jtag_debug_module_grant_vector = {(cpu_jtag_debug_module_chosen_master_double_vector[1] | cpu_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_jtag_debug_module_chosen_master_double_vector[0] | cpu_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_jtag_debug_module_chosen_master_rot_left = (cpu_jtag_debug_module_arb_winner << 1) ? (cpu_jtag_debug_module_arb_winner << 1) : 1;

  //cpu/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_jtag_debug_module_grant_vector)
          cpu_jtag_debug_module_arb_addend <= cpu_jtag_debug_module_end_xfer? cpu_jtag_debug_module_chosen_master_rot_left : cpu_jtag_debug_module_grant_vector;
    end


  assign cpu_jtag_debug_module_begintransfer = cpu_jtag_debug_module_begins_xfer;
  //cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  assign cpu_jtag_debug_module_reset_n = reset_n;

  //assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest;

  assign cpu_jtag_debug_module_chipselect = cpu_data_master_granted_cpu_jtag_debug_module | cpu_instruction_master_granted_cpu_jtag_debug_module;
  //cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_jtag_debug_module_firsttransfer = cpu_jtag_debug_module_begins_xfer ? cpu_jtag_debug_module_unreg_firsttransfer : cpu_jtag_debug_module_reg_firsttransfer;

  //cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign cpu_jtag_debug_module_unreg_firsttransfer = ~(cpu_jtag_debug_module_slavearbiterlockenable & cpu_jtag_debug_module_any_continuerequest);

  //cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (cpu_jtag_debug_module_begins_xfer)
          cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
    end


  //cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_jtag_debug_module_beginbursttransfer_internal = cpu_jtag_debug_module_begins_xfer;

  //cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_jtag_debug_module_arbitration_holdoff_internal = cpu_jtag_debug_module_begins_xfer & cpu_jtag_debug_module_firsttransfer;

  //cpu_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_jtag_debug_module_write = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_write;

  assign shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master = cpu_data_master_address_to_slave;
  //cpu_jtag_debug_module_address mux, which is an e_mux
  assign cpu_jtag_debug_module_address = (cpu_data_master_granted_cpu_jtag_debug_module)? (shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master >> 2) :
    (shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master >> 2);

  assign shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master = cpu_instruction_master_address_to_slave;
  //d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_jtag_debug_module_end_xfer <= 1;
      else 
        d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
    end


  //cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_jtag_debug_module_waits_for_read = cpu_jtag_debug_module_in_a_read_cycle & cpu_jtag_debug_module_begins_xfer;

  //cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_jtag_debug_module_in_a_read_cycle = (cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_read) | (cpu_instruction_master_granted_cpu_jtag_debug_module & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_jtag_debug_module_in_a_read_cycle;

  //cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_jtag_debug_module_waits_for_write = cpu_jtag_debug_module_in_a_write_cycle & 0;

  //cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_jtag_debug_module_in_a_write_cycle = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_jtag_debug_module_counter = 0;
  //cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_jtag_debug_module_byteenable = (cpu_data_master_granted_cpu_jtag_debug_module)? cpu_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign cpu_jtag_debug_module_debugaccess = (cpu_data_master_granted_cpu_jtag_debug_module)? cpu_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_cpu_jtag_debug_module + cpu_instruction_master_granted_cpu_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_cpu_jtag_debug_module + cpu_instruction_master_saved_grant_cpu_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_irq_from_sa_clock_crossing_cpu_data_master_module (
                                                                                       // inputs:
                                                                                        clk,
                                                                                        data_in,
                                                                                        reset_n,

                                                                                       // outputs:
                                                                                        data_out
                                                                                     )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_data_master_arbitrator (
                                    // inputs:
                                     DE4_SOPC_clock_0_in_readdata_from_sa,
                                     DE4_SOPC_clock_0_in_waitrequest_from_sa,
                                     DE4_SOPC_clock_1_in_readdata_from_sa,
                                     DE4_SOPC_clock_1_in_waitrequest_from_sa,
                                     clk,
                                     cpu_data_master_address,
                                     cpu_data_master_byteenable,
                                     cpu_data_master_byteenable_ext_flash_s1,
                                     cpu_data_master_granted_DE4_SOPC_clock_0_in,
                                     cpu_data_master_granted_DE4_SOPC_clock_1_in,
                                     cpu_data_master_granted_cpu_jtag_debug_module,
                                     cpu_data_master_granted_descriptor_memory_s1,
                                     cpu_data_master_granted_ext_flash_s1,
                                     cpu_data_master_granted_high_res_timer_s1,
                                     cpu_data_master_granted_onchip_memory_s1,
                                     cpu_data_master_granted_peripheral_clock_crossing_s1,
                                     cpu_data_master_granted_sgdma_rx_csr,
                                     cpu_data_master_granted_sgdma_tx_csr,
                                     cpu_data_master_granted_sys_timer_s1,
                                     cpu_data_master_granted_sysid_control_slave,
                                     cpu_data_master_granted_tse_mac_control_port,
                                     cpu_data_master_qualified_request_DE4_SOPC_clock_0_in,
                                     cpu_data_master_qualified_request_DE4_SOPC_clock_1_in,
                                     cpu_data_master_qualified_request_cpu_jtag_debug_module,
                                     cpu_data_master_qualified_request_descriptor_memory_s1,
                                     cpu_data_master_qualified_request_ext_flash_s1,
                                     cpu_data_master_qualified_request_high_res_timer_s1,
                                     cpu_data_master_qualified_request_onchip_memory_s1,
                                     cpu_data_master_qualified_request_peripheral_clock_crossing_s1,
                                     cpu_data_master_qualified_request_sgdma_rx_csr,
                                     cpu_data_master_qualified_request_sgdma_tx_csr,
                                     cpu_data_master_qualified_request_sys_timer_s1,
                                     cpu_data_master_qualified_request_sysid_control_slave,
                                     cpu_data_master_qualified_request_tse_mac_control_port,
                                     cpu_data_master_read,
                                     cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in,
                                     cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in,
                                     cpu_data_master_read_data_valid_cpu_jtag_debug_module,
                                     cpu_data_master_read_data_valid_descriptor_memory_s1,
                                     cpu_data_master_read_data_valid_ext_flash_s1,
                                     cpu_data_master_read_data_valid_high_res_timer_s1,
                                     cpu_data_master_read_data_valid_onchip_memory_s1,
                                     cpu_data_master_read_data_valid_peripheral_clock_crossing_s1,
                                     cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                     cpu_data_master_read_data_valid_sgdma_rx_csr,
                                     cpu_data_master_read_data_valid_sgdma_tx_csr,
                                     cpu_data_master_read_data_valid_sys_timer_s1,
                                     cpu_data_master_read_data_valid_sysid_control_slave,
                                     cpu_data_master_read_data_valid_tse_mac_control_port,
                                     cpu_data_master_requests_DE4_SOPC_clock_0_in,
                                     cpu_data_master_requests_DE4_SOPC_clock_1_in,
                                     cpu_data_master_requests_cpu_jtag_debug_module,
                                     cpu_data_master_requests_descriptor_memory_s1,
                                     cpu_data_master_requests_ext_flash_s1,
                                     cpu_data_master_requests_high_res_timer_s1,
                                     cpu_data_master_requests_onchip_memory_s1,
                                     cpu_data_master_requests_peripheral_clock_crossing_s1,
                                     cpu_data_master_requests_sgdma_rx_csr,
                                     cpu_data_master_requests_sgdma_tx_csr,
                                     cpu_data_master_requests_sys_timer_s1,
                                     cpu_data_master_requests_sysid_control_slave,
                                     cpu_data_master_requests_tse_mac_control_port,
                                     cpu_data_master_write,
                                     cpu_data_master_writedata,
                                     cpu_jtag_debug_module_readdata_from_sa,
                                     d1_DE4_SOPC_clock_0_in_end_xfer,
                                     d1_DE4_SOPC_clock_1_in_end_xfer,
                                     d1_cpu_jtag_debug_module_end_xfer,
                                     d1_descriptor_memory_s1_end_xfer,
                                     d1_flash_tristate_bridge_avalon_slave_end_xfer,
                                     d1_high_res_timer_s1_end_xfer,
                                     d1_onchip_memory_s1_end_xfer,
                                     d1_peripheral_clock_crossing_s1_end_xfer,
                                     d1_sgdma_rx_csr_end_xfer,
                                     d1_sgdma_tx_csr_end_xfer,
                                     d1_sys_timer_s1_end_xfer,
                                     d1_sysid_control_slave_end_xfer,
                                     d1_tse_mac_control_port_end_xfer,
                                     descriptor_memory_s1_readdata_from_sa,
                                     ext_flash_s1_wait_counter_eq_0,
                                     high_res_timer_s1_irq_from_sa,
                                     high_res_timer_s1_readdata_from_sa,
                                     incoming_flash_tristate_bridge_data_with_Xs_converted_to_0,
                                     jtag_uart_avalon_jtag_slave_irq_from_sa,
                                     onchip_memory_s1_readdata_from_sa,
                                     peripheral_clock_crossing_s1_readdata_from_sa,
                                     peripheral_clock_crossing_s1_waitrequest_from_sa,
                                     pll_sys_clk,
                                     pll_sys_clk_reset_n,
                                     reset_n,
                                     sgdma_rx_csr_irq_from_sa,
                                     sgdma_rx_csr_readdata_from_sa,
                                     sgdma_tx_csr_irq_from_sa,
                                     sgdma_tx_csr_readdata_from_sa,
                                     sys_timer_s1_irq_from_sa,
                                     sys_timer_s1_readdata_from_sa,
                                     sysid_control_slave_readdata_from_sa,
                                     tse_mac_control_port_readdata_from_sa,
                                     tse_mac_control_port_waitrequest_from_sa,

                                    // outputs:
                                     cpu_data_master_address_to_slave,
                                     cpu_data_master_dbs_address,
                                     cpu_data_master_dbs_write_16,
                                     cpu_data_master_irq,
                                     cpu_data_master_latency_counter,
                                     cpu_data_master_readdata,
                                     cpu_data_master_readdatavalid,
                                     cpu_data_master_waitrequest
                                  )
;

  output  [ 26: 0] cpu_data_master_address_to_slave;
  output  [  1: 0] cpu_data_master_dbs_address;
  output  [ 15: 0] cpu_data_master_dbs_write_16;
  output  [ 31: 0] cpu_data_master_irq;
  output  [  1: 0] cpu_data_master_latency_counter;
  output  [ 31: 0] cpu_data_master_readdata;
  output           cpu_data_master_readdatavalid;
  output           cpu_data_master_waitrequest;
  input   [ 15: 0] DE4_SOPC_clock_0_in_readdata_from_sa;
  input            DE4_SOPC_clock_0_in_waitrequest_from_sa;
  input   [ 31: 0] DE4_SOPC_clock_1_in_readdata_from_sa;
  input            DE4_SOPC_clock_1_in_waitrequest_from_sa;
  input            clk;
  input   [ 26: 0] cpu_data_master_address;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_byteenable_ext_flash_s1;
  input            cpu_data_master_granted_DE4_SOPC_clock_0_in;
  input            cpu_data_master_granted_DE4_SOPC_clock_1_in;
  input            cpu_data_master_granted_cpu_jtag_debug_module;
  input            cpu_data_master_granted_descriptor_memory_s1;
  input            cpu_data_master_granted_ext_flash_s1;
  input            cpu_data_master_granted_high_res_timer_s1;
  input            cpu_data_master_granted_onchip_memory_s1;
  input            cpu_data_master_granted_peripheral_clock_crossing_s1;
  input            cpu_data_master_granted_sgdma_rx_csr;
  input            cpu_data_master_granted_sgdma_tx_csr;
  input            cpu_data_master_granted_sys_timer_s1;
  input            cpu_data_master_granted_sysid_control_slave;
  input            cpu_data_master_granted_tse_mac_control_port;
  input            cpu_data_master_qualified_request_DE4_SOPC_clock_0_in;
  input            cpu_data_master_qualified_request_DE4_SOPC_clock_1_in;
  input            cpu_data_master_qualified_request_cpu_jtag_debug_module;
  input            cpu_data_master_qualified_request_descriptor_memory_s1;
  input            cpu_data_master_qualified_request_ext_flash_s1;
  input            cpu_data_master_qualified_request_high_res_timer_s1;
  input            cpu_data_master_qualified_request_onchip_memory_s1;
  input            cpu_data_master_qualified_request_peripheral_clock_crossing_s1;
  input            cpu_data_master_qualified_request_sgdma_rx_csr;
  input            cpu_data_master_qualified_request_sgdma_tx_csr;
  input            cpu_data_master_qualified_request_sys_timer_s1;
  input            cpu_data_master_qualified_request_sysid_control_slave;
  input            cpu_data_master_qualified_request_tse_mac_control_port;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in;
  input            cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in;
  input            cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  input            cpu_data_master_read_data_valid_descriptor_memory_s1;
  input            cpu_data_master_read_data_valid_ext_flash_s1;
  input            cpu_data_master_read_data_valid_high_res_timer_s1;
  input            cpu_data_master_read_data_valid_onchip_memory_s1;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_read_data_valid_sgdma_rx_csr;
  input            cpu_data_master_read_data_valid_sgdma_tx_csr;
  input            cpu_data_master_read_data_valid_sys_timer_s1;
  input            cpu_data_master_read_data_valid_sysid_control_slave;
  input            cpu_data_master_read_data_valid_tse_mac_control_port;
  input            cpu_data_master_requests_DE4_SOPC_clock_0_in;
  input            cpu_data_master_requests_DE4_SOPC_clock_1_in;
  input            cpu_data_master_requests_cpu_jtag_debug_module;
  input            cpu_data_master_requests_descriptor_memory_s1;
  input            cpu_data_master_requests_ext_flash_s1;
  input            cpu_data_master_requests_high_res_timer_s1;
  input            cpu_data_master_requests_onchip_memory_s1;
  input            cpu_data_master_requests_peripheral_clock_crossing_s1;
  input            cpu_data_master_requests_sgdma_rx_csr;
  input            cpu_data_master_requests_sgdma_tx_csr;
  input            cpu_data_master_requests_sys_timer_s1;
  input            cpu_data_master_requests_sysid_control_slave;
  input            cpu_data_master_requests_tse_mac_control_port;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  input            d1_DE4_SOPC_clock_0_in_end_xfer;
  input            d1_DE4_SOPC_clock_1_in_end_xfer;
  input            d1_cpu_jtag_debug_module_end_xfer;
  input            d1_descriptor_memory_s1_end_xfer;
  input            d1_flash_tristate_bridge_avalon_slave_end_xfer;
  input            d1_high_res_timer_s1_end_xfer;
  input            d1_onchip_memory_s1_end_xfer;
  input            d1_peripheral_clock_crossing_s1_end_xfer;
  input            d1_sgdma_rx_csr_end_xfer;
  input            d1_sgdma_tx_csr_end_xfer;
  input            d1_sys_timer_s1_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_tse_mac_control_port_end_xfer;
  input   [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  input            ext_flash_s1_wait_counter_eq_0;
  input            high_res_timer_s1_irq_from_sa;
  input   [ 15: 0] high_res_timer_s1_readdata_from_sa;
  input   [ 15: 0] incoming_flash_tristate_bridge_data_with_Xs_converted_to_0;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] onchip_memory_s1_readdata_from_sa;
  input   [ 31: 0] peripheral_clock_crossing_s1_readdata_from_sa;
  input            peripheral_clock_crossing_s1_waitrequest_from_sa;
  input            pll_sys_clk;
  input            pll_sys_clk_reset_n;
  input            reset_n;
  input            sgdma_rx_csr_irq_from_sa;
  input   [ 31: 0] sgdma_rx_csr_readdata_from_sa;
  input            sgdma_tx_csr_irq_from_sa;
  input   [ 31: 0] sgdma_tx_csr_readdata_from_sa;
  input            sys_timer_s1_irq_from_sa;
  input   [ 15: 0] sys_timer_s1_readdata_from_sa;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input   [ 31: 0] tse_mac_control_port_readdata_from_sa;
  input            tse_mac_control_port_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 26: 0] cpu_data_master_address_last_time;
  wire    [ 26: 0] cpu_data_master_address_to_slave;
  reg     [  3: 0] cpu_data_master_byteenable_last_time;
  reg     [  1: 0] cpu_data_master_dbs_address;
  wire    [  1: 0] cpu_data_master_dbs_increment;
  reg     [  1: 0] cpu_data_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_data_master_dbs_rdv_counter_inc;
  wire    [ 15: 0] cpu_data_master_dbs_write_16;
  wire    [ 31: 0] cpu_data_master_irq;
  wire             cpu_data_master_is_granted_some_slave;
  reg     [  1: 0] cpu_data_master_latency_counter;
  wire    [  1: 0] cpu_data_master_next_dbs_rdv_counter;
  reg              cpu_data_master_read_but_no_slave_selected;
  reg              cpu_data_master_read_last_time;
  wire    [ 31: 0] cpu_data_master_readdata;
  wire             cpu_data_master_readdatavalid;
  wire             cpu_data_master_run;
  wire             cpu_data_master_waitrequest;
  reg              cpu_data_master_write_last_time;
  reg     [ 31: 0] cpu_data_master_writedata_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_data_master_latency_counter;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire             pll_sys_clk_jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_data_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_data_master_qualified_request_DE4_SOPC_clock_0_in | ~cpu_data_master_requests_DE4_SOPC_clock_0_in) & ((~cpu_data_master_qualified_request_DE4_SOPC_clock_0_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE4_SOPC_clock_0_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_DE4_SOPC_clock_0_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE4_SOPC_clock_0_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_DE4_SOPC_clock_1_in | ~cpu_data_master_requests_DE4_SOPC_clock_1_in) & ((~cpu_data_master_qualified_request_DE4_SOPC_clock_1_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE4_SOPC_clock_1_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_DE4_SOPC_clock_1_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE4_SOPC_clock_1_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_requests_cpu_jtag_debug_module) & (cpu_data_master_granted_cpu_jtag_debug_module | ~cpu_data_master_qualified_request_cpu_jtag_debug_module) & ((~cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_read | (1 & ~d1_cpu_jtag_debug_module_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_descriptor_memory_s1 | ~cpu_data_master_requests_descriptor_memory_s1) & (cpu_data_master_granted_descriptor_memory_s1 | ~cpu_data_master_qualified_request_descriptor_memory_s1) & ((~cpu_data_master_qualified_request_descriptor_memory_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_descriptor_memory_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_ext_flash_s1 | (cpu_data_master_write & !cpu_data_master_byteenable_ext_flash_s1 & cpu_data_master_dbs_address[1]) | ~cpu_data_master_requests_ext_flash_s1);

  //cascaded wait assignment, which is an e_assign
  assign cpu_data_master_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = (cpu_data_master_granted_ext_flash_s1 | ~cpu_data_master_qualified_request_ext_flash_s1) & ((~cpu_data_master_qualified_request_ext_flash_s1 | ~cpu_data_master_read | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1]) & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_ext_flash_s1 | ~cpu_data_master_write | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1]) & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_high_res_timer_s1 | ~cpu_data_master_requests_high_res_timer_s1) & ((~cpu_data_master_qualified_request_high_res_timer_s1 | ~cpu_data_master_read | (1 & ~d1_high_res_timer_s1_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_high_res_timer_s1 | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_onchip_memory_s1 | ~cpu_data_master_requests_onchip_memory_s1) & (cpu_data_master_granted_onchip_memory_s1 | ~cpu_data_master_qualified_request_onchip_memory_s1) & ((~cpu_data_master_qualified_request_onchip_memory_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_onchip_memory_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_peripheral_clock_crossing_s1 | ~cpu_data_master_requests_peripheral_clock_crossing_s1) & ((~cpu_data_master_qualified_request_peripheral_clock_crossing_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~peripheral_clock_crossing_s1_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_peripheral_clock_crossing_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~peripheral_clock_crossing_s1_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write))));

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (cpu_data_master_qualified_request_sgdma_rx_csr | ~cpu_data_master_requests_sgdma_rx_csr) & ((~cpu_data_master_qualified_request_sgdma_rx_csr | ~cpu_data_master_read | (1 & ~d1_sgdma_rx_csr_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sgdma_rx_csr | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_sgdma_tx_csr | ~cpu_data_master_requests_sgdma_tx_csr) & ((~cpu_data_master_qualified_request_sgdma_tx_csr | ~cpu_data_master_read | (1 & ~d1_sgdma_tx_csr_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sgdma_tx_csr | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_sys_timer_s1 | ~cpu_data_master_requests_sys_timer_s1) & ((~cpu_data_master_qualified_request_sys_timer_s1 | ~cpu_data_master_read | (1 & ~d1_sys_timer_s1_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sys_timer_s1 | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_sysid_control_slave | ~cpu_data_master_requests_sysid_control_slave) & ((~cpu_data_master_qualified_request_sysid_control_slave | ~cpu_data_master_read | (1 & ~d1_sysid_control_slave_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sysid_control_slave | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_tse_mac_control_port | ~cpu_data_master_requests_tse_mac_control_port) & ((~cpu_data_master_qualified_request_tse_mac_control_port | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~tse_mac_control_port_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_tse_mac_control_port | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~tse_mac_control_port_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write))));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_data_master_address_to_slave = cpu_data_master_address[26 : 0];

  //cpu_data_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_but_no_slave_selected <= 0;
      else 
        cpu_data_master_read_but_no_slave_selected <= cpu_data_master_read & cpu_data_master_run & ~cpu_data_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_data_master_is_granted_some_slave = cpu_data_master_granted_DE4_SOPC_clock_0_in |
    cpu_data_master_granted_DE4_SOPC_clock_1_in |
    cpu_data_master_granted_cpu_jtag_debug_module |
    cpu_data_master_granted_descriptor_memory_s1 |
    cpu_data_master_granted_ext_flash_s1 |
    cpu_data_master_granted_high_res_timer_s1 |
    cpu_data_master_granted_onchip_memory_s1 |
    cpu_data_master_granted_peripheral_clock_crossing_s1 |
    cpu_data_master_granted_sgdma_rx_csr |
    cpu_data_master_granted_sgdma_tx_csr |
    cpu_data_master_granted_sys_timer_s1 |
    cpu_data_master_granted_sysid_control_slave |
    cpu_data_master_granted_tse_mac_control_port;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_data_master_readdatavalid = cpu_data_master_read_data_valid_descriptor_memory_s1 |
    (cpu_data_master_read_data_valid_ext_flash_s1 & dbs_rdv_counter_overflow) |
    cpu_data_master_read_data_valid_onchip_memory_s1 |
    cpu_data_master_read_data_valid_peripheral_clock_crossing_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_data_master_readdatavalid = cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_cpu_jtag_debug_module |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_high_res_timer_s1 |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_sgdma_rx_csr |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_sgdma_tx_csr |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_sys_timer_s1 |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_sysid_control_slave |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_tse_mac_control_port;

  //cpu/data_master readdata mux, which is an e_mux
  assign cpu_data_master_readdata = ({32 {~(cpu_data_master_qualified_request_DE4_SOPC_clock_0_in & cpu_data_master_read)}} | DE4_SOPC_clock_0_in_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_DE4_SOPC_clock_1_in & cpu_data_master_read)}} | DE4_SOPC_clock_1_in_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_cpu_jtag_debug_module & cpu_data_master_read)}} | cpu_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_data_master_read_data_valid_descriptor_memory_s1}} | descriptor_memory_s1_readdata_from_sa) &
    ({32 {~cpu_data_master_read_data_valid_ext_flash_s1}} | {incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~(cpu_data_master_qualified_request_high_res_timer_s1 & cpu_data_master_read)}} | high_res_timer_s1_readdata_from_sa) &
    ({32 {~cpu_data_master_read_data_valid_onchip_memory_s1}} | onchip_memory_s1_readdata_from_sa) &
    ({32 {~cpu_data_master_read_data_valid_peripheral_clock_crossing_s1}} | peripheral_clock_crossing_s1_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sgdma_rx_csr & cpu_data_master_read)}} | sgdma_rx_csr_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sgdma_tx_csr & cpu_data_master_read)}} | sgdma_tx_csr_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sys_timer_s1 & cpu_data_master_read)}} | sys_timer_s1_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sysid_control_slave & cpu_data_master_read)}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_tse_mac_control_port & cpu_data_master_read)}} | tse_mac_control_port_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign cpu_data_master_waitrequest = ~cpu_data_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_latency_counter <= 0;
      else 
        cpu_data_master_latency_counter <= p1_cpu_data_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_data_master_latency_counter = ((cpu_data_master_run & cpu_data_master_read))? latency_load_value :
    (cpu_data_master_latency_counter)? cpu_data_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = ({2 {cpu_data_master_requests_descriptor_memory_s1}} & 1) |
    ({2 {cpu_data_master_requests_ext_flash_s1}} & 2) |
    ({2 {cpu_data_master_requests_onchip_memory_s1}} & 1);

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~0) & cpu_data_master_requests_ext_flash_s1 & cpu_data_master_write & !cpu_data_master_byteenable_ext_flash_s1)) |
    ((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer}))) |
    ((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer})));

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = incoming_flash_tristate_bridge_data_with_Xs_converted_to_0;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_data_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_data_master_dbs_write_16 = (cpu_data_master_dbs_address[1])? cpu_data_master_writedata[31 : 16] :
    cpu_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign cpu_data_master_dbs_increment = (cpu_data_master_requests_ext_flash_s1)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_data_master_dbs_address + cpu_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_data_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_data_master_next_dbs_rdv_counter = cpu_data_master_dbs_rdv_counter + cpu_data_master_dbs_rdv_counter_inc;

  //cpu_data_master_rdv_inc_mux, which is an e_mux
  assign cpu_data_master_dbs_rdv_counter_inc = 2;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_data_master_read_data_valid_ext_flash_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_data_master_dbs_rdv_counter <= cpu_data_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_data_master_dbs_rdv_counter[1] & ~cpu_data_master_next_dbs_rdv_counter[1];

  //irq assign, which is an e_assign
  assign cpu_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    sgdma_rx_csr_irq_from_sa,
    sgdma_tx_csr_irq_from_sa,
    sys_timer_s1_irq_from_sa,
    high_res_timer_s1_irq_from_sa,
    pll_sys_clk_jtag_uart_avalon_jtag_slave_irq_from_sa};

  //jtag_uart_avalon_jtag_slave_irq_from_sa from pll_peripheral_clk to pll_sys_clk
  jtag_uart_avalon_jtag_slave_irq_from_sa_clock_crossing_cpu_data_master_module jtag_uart_avalon_jtag_slave_irq_from_sa_clock_crossing_cpu_data_master
    (
      .clk      (pll_sys_clk),
      .data_in  (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .data_out (pll_sys_clk_jtag_uart_avalon_jtag_slave_irq_from_sa),
      .reset_n  (pll_sys_clk_reset_n)
    );


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_data_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_address_last_time <= 0;
      else 
        cpu_data_master_address_last_time <= cpu_data_master_address;
    end


  //cpu/data_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_data_master_waitrequest & (cpu_data_master_read | cpu_data_master_write);
    end


  //cpu_data_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_address != cpu_data_master_address_last_time))
        begin
          $write("%0d ns: cpu_data_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_byteenable_last_time <= 0;
      else 
        cpu_data_master_byteenable_last_time <= cpu_data_master_byteenable;
    end


  //cpu_data_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_byteenable != cpu_data_master_byteenable_last_time))
        begin
          $write("%0d ns: cpu_data_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_last_time <= 0;
      else 
        cpu_data_master_read_last_time <= cpu_data_master_read;
    end


  //cpu_data_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_read != cpu_data_master_read_last_time))
        begin
          $write("%0d ns: cpu_data_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_write_last_time <= 0;
      else 
        cpu_data_master_write_last_time <= cpu_data_master_write;
    end


  //cpu_data_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_write != cpu_data_master_write_last_time))
        begin
          $write("%0d ns: cpu_data_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_writedata_last_time <= 0;
      else 
        cpu_data_master_writedata_last_time <= cpu_data_master_writedata;
    end


  //cpu_data_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_writedata != cpu_data_master_writedata_last_time) & cpu_data_master_write)
        begin
          $write("%0d ns: cpu_data_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_instruction_master_arbitrator (
                                           // inputs:
                                            clk,
                                            cpu_instruction_master_address,
                                            cpu_instruction_master_granted_cpu_jtag_debug_module,
                                            cpu_instruction_master_granted_ext_flash_s1,
                                            cpu_instruction_master_granted_onchip_memory_s1,
                                            cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
                                            cpu_instruction_master_qualified_request_ext_flash_s1,
                                            cpu_instruction_master_qualified_request_onchip_memory_s1,
                                            cpu_instruction_master_read,
                                            cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
                                            cpu_instruction_master_read_data_valid_ext_flash_s1,
                                            cpu_instruction_master_read_data_valid_onchip_memory_s1,
                                            cpu_instruction_master_requests_cpu_jtag_debug_module,
                                            cpu_instruction_master_requests_ext_flash_s1,
                                            cpu_instruction_master_requests_onchip_memory_s1,
                                            cpu_jtag_debug_module_readdata_from_sa,
                                            d1_cpu_jtag_debug_module_end_xfer,
                                            d1_flash_tristate_bridge_avalon_slave_end_xfer,
                                            d1_onchip_memory_s1_end_xfer,
                                            ext_flash_s1_wait_counter_eq_0,
                                            incoming_flash_tristate_bridge_data,
                                            onchip_memory_s1_readdata_from_sa,
                                            reset_n,

                                           // outputs:
                                            cpu_instruction_master_address_to_slave,
                                            cpu_instruction_master_dbs_address,
                                            cpu_instruction_master_latency_counter,
                                            cpu_instruction_master_readdata,
                                            cpu_instruction_master_readdatavalid,
                                            cpu_instruction_master_waitrequest
                                         )
;

  output  [ 26: 0] cpu_instruction_master_address_to_slave;
  output  [  1: 0] cpu_instruction_master_dbs_address;
  output  [  1: 0] cpu_instruction_master_latency_counter;
  output  [ 31: 0] cpu_instruction_master_readdata;
  output           cpu_instruction_master_readdatavalid;
  output           cpu_instruction_master_waitrequest;
  input            clk;
  input   [ 26: 0] cpu_instruction_master_address;
  input            cpu_instruction_master_granted_cpu_jtag_debug_module;
  input            cpu_instruction_master_granted_ext_flash_s1;
  input            cpu_instruction_master_granted_onchip_memory_s1;
  input            cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  input            cpu_instruction_master_qualified_request_ext_flash_s1;
  input            cpu_instruction_master_qualified_request_onchip_memory_s1;
  input            cpu_instruction_master_read;
  input            cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  input            cpu_instruction_master_read_data_valid_ext_flash_s1;
  input            cpu_instruction_master_read_data_valid_onchip_memory_s1;
  input            cpu_instruction_master_requests_cpu_jtag_debug_module;
  input            cpu_instruction_master_requests_ext_flash_s1;
  input            cpu_instruction_master_requests_onchip_memory_s1;
  input   [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_jtag_debug_module_end_xfer;
  input            d1_flash_tristate_bridge_avalon_slave_end_xfer;
  input            d1_onchip_memory_s1_end_xfer;
  input            ext_flash_s1_wait_counter_eq_0;
  input   [ 15: 0] incoming_flash_tristate_bridge_data;
  input   [ 31: 0] onchip_memory_s1_readdata_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [ 26: 0] cpu_instruction_master_address_last_time;
  wire    [ 26: 0] cpu_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_instruction_master_dbs_address;
  wire    [  1: 0] cpu_instruction_master_dbs_increment;
  reg     [  1: 0] cpu_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_instruction_master_dbs_rdv_counter_inc;
  wire             cpu_instruction_master_is_granted_some_slave;
  reg     [  1: 0] cpu_instruction_master_latency_counter;
  wire    [  1: 0] cpu_instruction_master_next_dbs_rdv_counter;
  reg              cpu_instruction_master_read_but_no_slave_selected;
  reg              cpu_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_instruction_master_readdata;
  wire             cpu_instruction_master_readdatavalid;
  wire             cpu_instruction_master_run;
  wire             cpu_instruction_master_waitrequest;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_instruction_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_instruction_master_qualified_request_cpu_jtag_debug_module | ~cpu_instruction_master_requests_cpu_jtag_debug_module) & (cpu_instruction_master_granted_cpu_jtag_debug_module | ~cpu_instruction_master_qualified_request_cpu_jtag_debug_module) & ((~cpu_instruction_master_qualified_request_cpu_jtag_debug_module | ~cpu_instruction_master_read | (1 & ~d1_cpu_jtag_debug_module_end_xfer & cpu_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_instruction_master_run = r_0 & r_1;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_instruction_master_qualified_request_ext_flash_s1 | ~cpu_instruction_master_requests_ext_flash_s1) & (cpu_instruction_master_granted_ext_flash_s1 | ~cpu_instruction_master_qualified_request_ext_flash_s1) & ((~cpu_instruction_master_qualified_request_ext_flash_s1 | ~cpu_instruction_master_read | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer)) & (cpu_instruction_master_dbs_address[1]) & cpu_instruction_master_read))) & 1 & (cpu_instruction_master_qualified_request_onchip_memory_s1 | ~cpu_instruction_master_requests_onchip_memory_s1) & (cpu_instruction_master_granted_onchip_memory_s1 | ~cpu_instruction_master_qualified_request_onchip_memory_s1) & ((~cpu_instruction_master_qualified_request_onchip_memory_s1 | ~(cpu_instruction_master_read) | (1 & (cpu_instruction_master_read))));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_instruction_master_address_to_slave = cpu_instruction_master_address[26 : 0];

  //cpu_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_but_no_slave_selected <= 0;
      else 
        cpu_instruction_master_read_but_no_slave_selected <= cpu_instruction_master_read & cpu_instruction_master_run & ~cpu_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_instruction_master_is_granted_some_slave = cpu_instruction_master_granted_cpu_jtag_debug_module |
    cpu_instruction_master_granted_ext_flash_s1 |
    cpu_instruction_master_granted_onchip_memory_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_instruction_master_readdatavalid = (cpu_instruction_master_read_data_valid_ext_flash_s1 & dbs_rdv_counter_overflow) |
    cpu_instruction_master_read_data_valid_onchip_memory_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_instruction_master_readdatavalid = cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid |
    cpu_instruction_master_read_data_valid_cpu_jtag_debug_module |
    cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid |
    cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid;

  //cpu/instruction_master readdata mux, which is an e_mux
  assign cpu_instruction_master_readdata = ({32 {~(cpu_instruction_master_qualified_request_cpu_jtag_debug_module & cpu_instruction_master_read)}} | cpu_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_instruction_master_read_data_valid_ext_flash_s1}} | {incoming_flash_tristate_bridge_data[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_instruction_master_read_data_valid_onchip_memory_s1}} | onchip_memory_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign cpu_instruction_master_waitrequest = ~cpu_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_latency_counter <= 0;
      else 
        cpu_instruction_master_latency_counter <= p1_cpu_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_instruction_master_latency_counter = ((cpu_instruction_master_run & cpu_instruction_master_read))? latency_load_value :
    (cpu_instruction_master_latency_counter)? cpu_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = ({2 {cpu_instruction_master_requests_ext_flash_s1}} & 2) |
    ({2 {cpu_instruction_master_requests_onchip_memory_s1}} & 1);

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = incoming_flash_tristate_bridge_data;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_instruction_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_instruction_master_dbs_increment = (cpu_instruction_master_requests_ext_flash_s1)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_instruction_master_dbs_address + cpu_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_instruction_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_instruction_master_next_dbs_rdv_counter = cpu_instruction_master_dbs_rdv_counter + cpu_instruction_master_dbs_rdv_counter_inc;

  //cpu_instruction_master_rdv_inc_mux, which is an e_mux
  assign cpu_instruction_master_dbs_rdv_counter_inc = 2;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_instruction_master_read_data_valid_ext_flash_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_instruction_master_dbs_rdv_counter <= cpu_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_instruction_master_dbs_rdv_counter[1] & ~cpu_instruction_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_flash_tristate_bridge_avalon_slave_end_xfer});


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_address_last_time <= 0;
      else 
        cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
    end


  //cpu/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_instruction_master_waitrequest & (cpu_instruction_master_read);
    end


  //cpu_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_instruction_master_address != cpu_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_last_time <= 0;
      else 
        cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
    end


  //cpu_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_instruction_master_read != cpu_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_memory_s1_arbitrator (
                                         // inputs:
                                          clk,
                                          cpu_data_master_address_to_slave,
                                          cpu_data_master_byteenable,
                                          cpu_data_master_latency_counter,
                                          cpu_data_master_read,
                                          cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                          cpu_data_master_write,
                                          cpu_data_master_writedata,
                                          descriptor_memory_s1_readdata,
                                          reset_n,
                                          sgdma_rx_descriptor_read_address_to_slave,
                                          sgdma_rx_descriptor_read_latency_counter,
                                          sgdma_rx_descriptor_read_read,
                                          sgdma_rx_descriptor_write_address_to_slave,
                                          sgdma_rx_descriptor_write_write,
                                          sgdma_rx_descriptor_write_writedata,
                                          sgdma_tx_descriptor_read_address_to_slave,
                                          sgdma_tx_descriptor_read_latency_counter,
                                          sgdma_tx_descriptor_read_read,
                                          sgdma_tx_descriptor_write_address_to_slave,
                                          sgdma_tx_descriptor_write_write,
                                          sgdma_tx_descriptor_write_writedata,

                                         // outputs:
                                          cpu_data_master_granted_descriptor_memory_s1,
                                          cpu_data_master_qualified_request_descriptor_memory_s1,
                                          cpu_data_master_read_data_valid_descriptor_memory_s1,
                                          cpu_data_master_requests_descriptor_memory_s1,
                                          d1_descriptor_memory_s1_end_xfer,
                                          descriptor_memory_s1_address,
                                          descriptor_memory_s1_byteenable,
                                          descriptor_memory_s1_chipselect,
                                          descriptor_memory_s1_clken,
                                          descriptor_memory_s1_readdata_from_sa,
                                          descriptor_memory_s1_write,
                                          descriptor_memory_s1_writedata,
                                          sgdma_rx_descriptor_read_granted_descriptor_memory_s1,
                                          sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1,
                                          sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1,
                                          sgdma_rx_descriptor_read_requests_descriptor_memory_s1,
                                          sgdma_rx_descriptor_write_granted_descriptor_memory_s1,
                                          sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1,
                                          sgdma_rx_descriptor_write_requests_descriptor_memory_s1,
                                          sgdma_tx_descriptor_read_granted_descriptor_memory_s1,
                                          sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1,
                                          sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1,
                                          sgdma_tx_descriptor_read_requests_descriptor_memory_s1,
                                          sgdma_tx_descriptor_write_granted_descriptor_memory_s1,
                                          sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1,
                                          sgdma_tx_descriptor_write_requests_descriptor_memory_s1
                                       )
;

  output           cpu_data_master_granted_descriptor_memory_s1;
  output           cpu_data_master_qualified_request_descriptor_memory_s1;
  output           cpu_data_master_read_data_valid_descriptor_memory_s1;
  output           cpu_data_master_requests_descriptor_memory_s1;
  output           d1_descriptor_memory_s1_end_xfer;
  output  [  8: 0] descriptor_memory_s1_address;
  output  [  3: 0] descriptor_memory_s1_byteenable;
  output           descriptor_memory_s1_chipselect;
  output           descriptor_memory_s1_clken;
  output  [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  output           descriptor_memory_s1_write;
  output  [ 31: 0] descriptor_memory_s1_writedata;
  output           sgdma_rx_descriptor_read_granted_descriptor_memory_s1;
  output           sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1;
  output           sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1;
  output           sgdma_rx_descriptor_read_requests_descriptor_memory_s1;
  output           sgdma_rx_descriptor_write_granted_descriptor_memory_s1;
  output           sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1;
  output           sgdma_rx_descriptor_write_requests_descriptor_memory_s1;
  output           sgdma_tx_descriptor_read_granted_descriptor_memory_s1;
  output           sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1;
  output           sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1;
  output           sgdma_tx_descriptor_read_requests_descriptor_memory_s1;
  output           sgdma_tx_descriptor_write_granted_descriptor_memory_s1;
  output           sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1;
  output           sgdma_tx_descriptor_write_requests_descriptor_memory_s1;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 31: 0] descriptor_memory_s1_readdata;
  input            reset_n;
  input   [ 31: 0] sgdma_rx_descriptor_read_address_to_slave;
  input            sgdma_rx_descriptor_read_latency_counter;
  input            sgdma_rx_descriptor_read_read;
  input   [ 31: 0] sgdma_rx_descriptor_write_address_to_slave;
  input            sgdma_rx_descriptor_write_write;
  input   [ 31: 0] sgdma_rx_descriptor_write_writedata;
  input   [ 31: 0] sgdma_tx_descriptor_read_address_to_slave;
  input            sgdma_tx_descriptor_read_latency_counter;
  input            sgdma_tx_descriptor_read_read;
  input   [ 31: 0] sgdma_tx_descriptor_write_address_to_slave;
  input            sgdma_tx_descriptor_write_write;
  input   [ 31: 0] sgdma_tx_descriptor_write_writedata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_descriptor_memory_s1;
  wire             cpu_data_master_qualified_request_descriptor_memory_s1;
  wire             cpu_data_master_read_data_valid_descriptor_memory_s1;
  reg              cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register;
  wire             cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register_in;
  wire             cpu_data_master_requests_descriptor_memory_s1;
  wire             cpu_data_master_saved_grant_descriptor_memory_s1;
  reg              d1_descriptor_memory_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire    [  8: 0] descriptor_memory_s1_address;
  wire             descriptor_memory_s1_allgrants;
  wire             descriptor_memory_s1_allow_new_arb_cycle;
  wire             descriptor_memory_s1_any_bursting_master_saved_grant;
  wire             descriptor_memory_s1_any_continuerequest;
  reg     [  4: 0] descriptor_memory_s1_arb_addend;
  wire             descriptor_memory_s1_arb_counter_enable;
  reg     [  1: 0] descriptor_memory_s1_arb_share_counter;
  wire    [  1: 0] descriptor_memory_s1_arb_share_counter_next_value;
  wire    [  1: 0] descriptor_memory_s1_arb_share_set_values;
  wire    [  4: 0] descriptor_memory_s1_arb_winner;
  wire             descriptor_memory_s1_arbitration_holdoff_internal;
  wire             descriptor_memory_s1_beginbursttransfer_internal;
  wire             descriptor_memory_s1_begins_xfer;
  wire    [  3: 0] descriptor_memory_s1_byteenable;
  wire             descriptor_memory_s1_chipselect;
  wire    [  9: 0] descriptor_memory_s1_chosen_master_double_vector;
  wire    [  4: 0] descriptor_memory_s1_chosen_master_rot_left;
  wire             descriptor_memory_s1_clken;
  wire             descriptor_memory_s1_end_xfer;
  wire             descriptor_memory_s1_firsttransfer;
  wire    [  4: 0] descriptor_memory_s1_grant_vector;
  wire             descriptor_memory_s1_in_a_read_cycle;
  wire             descriptor_memory_s1_in_a_write_cycle;
  wire    [  4: 0] descriptor_memory_s1_master_qreq_vector;
  wire             descriptor_memory_s1_non_bursting_master_requests;
  wire    [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  reg              descriptor_memory_s1_reg_firsttransfer;
  reg     [  4: 0] descriptor_memory_s1_saved_chosen_master_vector;
  reg              descriptor_memory_s1_slavearbiterlockenable;
  wire             descriptor_memory_s1_slavearbiterlockenable2;
  wire             descriptor_memory_s1_unreg_firsttransfer;
  wire             descriptor_memory_s1_waits_for_read;
  wire             descriptor_memory_s1_waits_for_write;
  wire             descriptor_memory_s1_write;
  wire    [ 31: 0] descriptor_memory_s1_writedata;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_descriptor_memory_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1;
  reg              last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1;
  reg              last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1;
  reg              last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1;
  reg              last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1;
  wire             p1_cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register;
  wire             p1_sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
  wire             p1_sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
  wire             sgdma_rx_descriptor_read_arbiterlock;
  wire             sgdma_rx_descriptor_read_arbiterlock2;
  wire             sgdma_rx_descriptor_read_continuerequest;
  wire             sgdma_rx_descriptor_read_granted_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1;
  reg              sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
  wire             sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in;
  wire             sgdma_rx_descriptor_read_requests_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_saved_grant_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_arbiterlock;
  wire             sgdma_rx_descriptor_write_arbiterlock2;
  wire             sgdma_rx_descriptor_write_continuerequest;
  wire             sgdma_rx_descriptor_write_granted_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_requests_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_saved_grant_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_arbiterlock;
  wire             sgdma_tx_descriptor_read_arbiterlock2;
  wire             sgdma_tx_descriptor_read_continuerequest;
  wire             sgdma_tx_descriptor_read_granted_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1;
  reg              sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
  wire             sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in;
  wire             sgdma_tx_descriptor_read_requests_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_saved_grant_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_arbiterlock;
  wire             sgdma_tx_descriptor_write_arbiterlock2;
  wire             sgdma_tx_descriptor_write_continuerequest;
  wire             sgdma_tx_descriptor_write_granted_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_requests_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_saved_grant_descriptor_memory_s1;
  wire    [ 26: 0] shifted_address_to_descriptor_memory_s1_from_cpu_data_master;
  wire    [ 31: 0] shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_read;
  wire    [ 31: 0] shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_write;
  wire    [ 31: 0] shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_read;
  wire    [ 31: 0] shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_write;
  wire             wait_for_descriptor_memory_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~descriptor_memory_s1_end_xfer;
    end


  assign descriptor_memory_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_descriptor_memory_s1 | sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1 | sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1 | sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1 | sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1));
  //assign descriptor_memory_s1_readdata_from_sa = descriptor_memory_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign descriptor_memory_s1_readdata_from_sa = descriptor_memory_s1_readdata;

  assign cpu_data_master_requests_descriptor_memory_s1 = ({cpu_data_master_address_to_slave[26 : 11] , 11'b0} == 27'h5201000) & (cpu_data_master_read | cpu_data_master_write);
  //descriptor_memory_s1_arb_share_counter set values, which is an e_mux
  assign descriptor_memory_s1_arb_share_set_values = 1;

  //descriptor_memory_s1_non_bursting_master_requests mux, which is an e_mux
  assign descriptor_memory_s1_non_bursting_master_requests = cpu_data_master_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_write_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_write_requests_descriptor_memory_s1 |
    cpu_data_master_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_write_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_write_requests_descriptor_memory_s1 |
    cpu_data_master_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_write_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_write_requests_descriptor_memory_s1 |
    cpu_data_master_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_write_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_write_requests_descriptor_memory_s1 |
    cpu_data_master_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_rx_descriptor_write_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_read_requests_descriptor_memory_s1 |
    sgdma_tx_descriptor_write_requests_descriptor_memory_s1;

  //descriptor_memory_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign descriptor_memory_s1_any_bursting_master_saved_grant = 0;

  //descriptor_memory_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign descriptor_memory_s1_arb_share_counter_next_value = descriptor_memory_s1_firsttransfer ? (descriptor_memory_s1_arb_share_set_values - 1) : |descriptor_memory_s1_arb_share_counter ? (descriptor_memory_s1_arb_share_counter - 1) : 0;

  //descriptor_memory_s1_allgrants all slave grants, which is an e_mux
  assign descriptor_memory_s1_allgrants = (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector) |
    (|descriptor_memory_s1_grant_vector);

  //descriptor_memory_s1_end_xfer assignment, which is an e_assign
  assign descriptor_memory_s1_end_xfer = ~(descriptor_memory_s1_waits_for_read | descriptor_memory_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_descriptor_memory_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_descriptor_memory_s1 = descriptor_memory_s1_end_xfer & (~descriptor_memory_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //descriptor_memory_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign descriptor_memory_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_descriptor_memory_s1 & descriptor_memory_s1_allgrants) | (end_xfer_arb_share_counter_term_descriptor_memory_s1 & ~descriptor_memory_s1_non_bursting_master_requests);

  //descriptor_memory_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_memory_s1_arb_share_counter <= 0;
      else if (descriptor_memory_s1_arb_counter_enable)
          descriptor_memory_s1_arb_share_counter <= descriptor_memory_s1_arb_share_counter_next_value;
    end


  //descriptor_memory_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_memory_s1_slavearbiterlockenable <= 0;
      else if ((|descriptor_memory_s1_master_qreq_vector & end_xfer_arb_share_counter_term_descriptor_memory_s1) | (end_xfer_arb_share_counter_term_descriptor_memory_s1 & ~descriptor_memory_s1_non_bursting_master_requests))
          descriptor_memory_s1_slavearbiterlockenable <= |descriptor_memory_s1_arb_share_counter_next_value;
    end


  //cpu/data_master descriptor_memory/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = descriptor_memory_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //descriptor_memory_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign descriptor_memory_s1_slavearbiterlockenable2 = |descriptor_memory_s1_arb_share_counter_next_value;

  //cpu/data_master descriptor_memory/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = descriptor_memory_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sgdma_rx/descriptor_read descriptor_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_rx_descriptor_read_arbiterlock = descriptor_memory_s1_slavearbiterlockenable & sgdma_rx_descriptor_read_continuerequest;

  //sgdma_rx/descriptor_read descriptor_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_rx_descriptor_read_arbiterlock2 = descriptor_memory_s1_slavearbiterlockenable2 & sgdma_rx_descriptor_read_continuerequest;

  //sgdma_rx/descriptor_read granted descriptor_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 <= 0;
      else 
        last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 <= sgdma_rx_descriptor_read_saved_grant_descriptor_memory_s1 ? 1 : (descriptor_memory_s1_arbitration_holdoff_internal | ~sgdma_rx_descriptor_read_requests_descriptor_memory_s1) ? 0 : last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1;
    end


  //sgdma_rx_descriptor_read_continuerequest continued request, which is an e_mux
  assign sgdma_rx_descriptor_read_continuerequest = (last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_read_requests_descriptor_memory_s1);

  //descriptor_memory_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign descriptor_memory_s1_any_continuerequest = sgdma_rx_descriptor_read_continuerequest |
    sgdma_rx_descriptor_write_continuerequest |
    sgdma_tx_descriptor_read_continuerequest |
    sgdma_tx_descriptor_write_continuerequest |
    cpu_data_master_continuerequest |
    sgdma_rx_descriptor_write_continuerequest |
    sgdma_tx_descriptor_read_continuerequest |
    sgdma_tx_descriptor_write_continuerequest |
    cpu_data_master_continuerequest |
    sgdma_rx_descriptor_read_continuerequest |
    sgdma_tx_descriptor_read_continuerequest |
    sgdma_tx_descriptor_write_continuerequest |
    cpu_data_master_continuerequest |
    sgdma_rx_descriptor_read_continuerequest |
    sgdma_rx_descriptor_write_continuerequest |
    sgdma_tx_descriptor_write_continuerequest |
    cpu_data_master_continuerequest |
    sgdma_rx_descriptor_read_continuerequest |
    sgdma_rx_descriptor_write_continuerequest |
    sgdma_tx_descriptor_read_continuerequest;

  //sgdma_rx/descriptor_write descriptor_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_rx_descriptor_write_arbiterlock = descriptor_memory_s1_slavearbiterlockenable & sgdma_rx_descriptor_write_continuerequest;

  //sgdma_rx/descriptor_write descriptor_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_rx_descriptor_write_arbiterlock2 = descriptor_memory_s1_slavearbiterlockenable2 & sgdma_rx_descriptor_write_continuerequest;

  //sgdma_rx/descriptor_write granted descriptor_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 <= 0;
      else 
        last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 <= sgdma_rx_descriptor_write_saved_grant_descriptor_memory_s1 ? 1 : (descriptor_memory_s1_arbitration_holdoff_internal | ~sgdma_rx_descriptor_write_requests_descriptor_memory_s1) ? 0 : last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1;
    end


  //sgdma_rx_descriptor_write_continuerequest continued request, which is an e_mux
  assign sgdma_rx_descriptor_write_continuerequest = (last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_rx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_rx_descriptor_write_requests_descriptor_memory_s1);

  //sgdma_tx/descriptor_read descriptor_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_tx_descriptor_read_arbiterlock = descriptor_memory_s1_slavearbiterlockenable & sgdma_tx_descriptor_read_continuerequest;

  //sgdma_tx/descriptor_read descriptor_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_tx_descriptor_read_arbiterlock2 = descriptor_memory_s1_slavearbiterlockenable2 & sgdma_tx_descriptor_read_continuerequest;

  //sgdma_tx/descriptor_read granted descriptor_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 <= 0;
      else 
        last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 <= sgdma_tx_descriptor_read_saved_grant_descriptor_memory_s1 ? 1 : (descriptor_memory_s1_arbitration_holdoff_internal | ~sgdma_tx_descriptor_read_requests_descriptor_memory_s1) ? 0 : last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1;
    end


  //sgdma_tx_descriptor_read_continuerequest continued request, which is an e_mux
  assign sgdma_tx_descriptor_read_continuerequest = (last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_read_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_read_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_read_requests_descriptor_memory_s1);

  //sgdma_tx/descriptor_write descriptor_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_tx_descriptor_write_arbiterlock = descriptor_memory_s1_slavearbiterlockenable & sgdma_tx_descriptor_write_continuerequest;

  //sgdma_tx/descriptor_write descriptor_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_tx_descriptor_write_arbiterlock2 = descriptor_memory_s1_slavearbiterlockenable2 & sgdma_tx_descriptor_write_continuerequest;

  //sgdma_tx/descriptor_write granted descriptor_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 <= 0;
      else 
        last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 <= sgdma_tx_descriptor_write_saved_grant_descriptor_memory_s1 ? 1 : (descriptor_memory_s1_arbitration_holdoff_internal | ~sgdma_tx_descriptor_write_requests_descriptor_memory_s1) ? 0 : last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1;
    end


  //sgdma_tx_descriptor_write_continuerequest continued request, which is an e_mux
  assign sgdma_tx_descriptor_write_continuerequest = (last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_write_requests_descriptor_memory_s1) |
    (last_cycle_sgdma_tx_descriptor_write_granted_slave_descriptor_memory_s1 & sgdma_tx_descriptor_write_requests_descriptor_memory_s1);

  assign cpu_data_master_qualified_request_descriptor_memory_s1 = cpu_data_master_requests_descriptor_memory_s1 & ~((cpu_data_master_read & ((1 < cpu_data_master_latency_counter) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))) | sgdma_rx_descriptor_read_arbiterlock | sgdma_rx_descriptor_write_arbiterlock | sgdma_tx_descriptor_read_arbiterlock | sgdma_tx_descriptor_write_arbiterlock);
  //cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register_in = cpu_data_master_granted_descriptor_memory_s1 & cpu_data_master_read & ~descriptor_memory_s1_waits_for_read;

  //shift register p1 cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register = {cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register, cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register_in};

  //cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register <= 0;
      else 
        cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register <= p1_cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register;
    end


  //local readdatavalid cpu_data_master_read_data_valid_descriptor_memory_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_descriptor_memory_s1 = cpu_data_master_read_data_valid_descriptor_memory_s1_shift_register;

  //descriptor_memory_s1_writedata mux, which is an e_mux
  assign descriptor_memory_s1_writedata = (cpu_data_master_granted_descriptor_memory_s1)? cpu_data_master_writedata :
    (sgdma_rx_descriptor_write_granted_descriptor_memory_s1)? sgdma_rx_descriptor_write_writedata :
    sgdma_tx_descriptor_write_writedata;

  //mux descriptor_memory_s1_clken, which is an e_mux
  assign descriptor_memory_s1_clken = 1'b1;

  assign sgdma_rx_descriptor_read_requests_descriptor_memory_s1 = (({sgdma_rx_descriptor_read_address_to_slave[31 : 11] , 11'b0} == 32'h5201000) & (sgdma_rx_descriptor_read_read)) & sgdma_rx_descriptor_read_read;
  //cpu/data_master granted descriptor_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 <= cpu_data_master_saved_grant_descriptor_memory_s1 ? 1 : (descriptor_memory_s1_arbitration_holdoff_internal | ~cpu_data_master_requests_descriptor_memory_s1) ? 0 : last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = (last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 & cpu_data_master_requests_descriptor_memory_s1) |
    (last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 & cpu_data_master_requests_descriptor_memory_s1) |
    (last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 & cpu_data_master_requests_descriptor_memory_s1) |
    (last_cycle_cpu_data_master_granted_slave_descriptor_memory_s1 & cpu_data_master_requests_descriptor_memory_s1);

  assign sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1 = sgdma_rx_descriptor_read_requests_descriptor_memory_s1 & ~(cpu_data_master_arbiterlock | sgdma_rx_descriptor_write_arbiterlock | sgdma_tx_descriptor_read_arbiterlock | sgdma_tx_descriptor_write_arbiterlock);
  //sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in = sgdma_rx_descriptor_read_granted_descriptor_memory_s1 & sgdma_rx_descriptor_read_read & ~descriptor_memory_s1_waits_for_read;

  //shift register p1 sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register = {sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register, sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in};

  //sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register <= 0;
      else 
        sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register <= p1_sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
    end


  //local readdatavalid sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1, which is an e_mux
  assign sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1 = sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;

  assign sgdma_rx_descriptor_write_requests_descriptor_memory_s1 = (({sgdma_rx_descriptor_write_address_to_slave[31 : 11] , 11'b0} == 32'h5201000) & (sgdma_rx_descriptor_write_write)) & sgdma_rx_descriptor_write_write;
  assign sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1 = sgdma_rx_descriptor_write_requests_descriptor_memory_s1 & ~(cpu_data_master_arbiterlock | sgdma_rx_descriptor_read_arbiterlock | sgdma_tx_descriptor_read_arbiterlock | sgdma_tx_descriptor_write_arbiterlock);
  assign sgdma_tx_descriptor_read_requests_descriptor_memory_s1 = (({sgdma_tx_descriptor_read_address_to_slave[31 : 11] , 11'b0} == 32'h5201000) & (sgdma_tx_descriptor_read_read)) & sgdma_tx_descriptor_read_read;
  assign sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1 = sgdma_tx_descriptor_read_requests_descriptor_memory_s1 & ~(cpu_data_master_arbiterlock | sgdma_rx_descriptor_read_arbiterlock | sgdma_rx_descriptor_write_arbiterlock | sgdma_tx_descriptor_write_arbiterlock);
  //sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in = sgdma_tx_descriptor_read_granted_descriptor_memory_s1 & sgdma_tx_descriptor_read_read & ~descriptor_memory_s1_waits_for_read;

  //shift register p1 sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register = {sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register, sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register_in};

  //sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register <= 0;
      else 
        sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register <= p1_sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;
    end


  //local readdatavalid sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1, which is an e_mux
  assign sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1 = sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1_shift_register;

  assign sgdma_tx_descriptor_write_requests_descriptor_memory_s1 = (({sgdma_tx_descriptor_write_address_to_slave[31 : 11] , 11'b0} == 32'h5201000) & (sgdma_tx_descriptor_write_write)) & sgdma_tx_descriptor_write_write;
  assign sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1 = sgdma_tx_descriptor_write_requests_descriptor_memory_s1 & ~(cpu_data_master_arbiterlock | sgdma_rx_descriptor_read_arbiterlock | sgdma_rx_descriptor_write_arbiterlock | sgdma_tx_descriptor_read_arbiterlock);
  //allow new arb cycle for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~sgdma_rx_descriptor_read_arbiterlock & ~sgdma_rx_descriptor_write_arbiterlock & ~sgdma_tx_descriptor_read_arbiterlock & ~sgdma_tx_descriptor_write_arbiterlock;

  //sgdma_tx/descriptor_write assignment into master qualified-requests vector for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_master_qreq_vector[0] = sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1;

  //sgdma_tx/descriptor_write grant descriptor_memory/s1, which is an e_assign
  assign sgdma_tx_descriptor_write_granted_descriptor_memory_s1 = descriptor_memory_s1_grant_vector[0];

  //sgdma_tx/descriptor_write saved-grant descriptor_memory/s1, which is an e_assign
  assign sgdma_tx_descriptor_write_saved_grant_descriptor_memory_s1 = descriptor_memory_s1_arb_winner[0] && sgdma_tx_descriptor_write_requests_descriptor_memory_s1;

  //sgdma_tx/descriptor_read assignment into master qualified-requests vector for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_master_qreq_vector[1] = sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1;

  //sgdma_tx/descriptor_read grant descriptor_memory/s1, which is an e_assign
  assign sgdma_tx_descriptor_read_granted_descriptor_memory_s1 = descriptor_memory_s1_grant_vector[1];

  //sgdma_tx/descriptor_read saved-grant descriptor_memory/s1, which is an e_assign
  assign sgdma_tx_descriptor_read_saved_grant_descriptor_memory_s1 = descriptor_memory_s1_arb_winner[1] && sgdma_tx_descriptor_read_requests_descriptor_memory_s1;

  //sgdma_rx/descriptor_write assignment into master qualified-requests vector for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_master_qreq_vector[2] = sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1;

  //sgdma_rx/descriptor_write grant descriptor_memory/s1, which is an e_assign
  assign sgdma_rx_descriptor_write_granted_descriptor_memory_s1 = descriptor_memory_s1_grant_vector[2];

  //sgdma_rx/descriptor_write saved-grant descriptor_memory/s1, which is an e_assign
  assign sgdma_rx_descriptor_write_saved_grant_descriptor_memory_s1 = descriptor_memory_s1_arb_winner[2] && sgdma_rx_descriptor_write_requests_descriptor_memory_s1;

  //sgdma_rx/descriptor_read assignment into master qualified-requests vector for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_master_qreq_vector[3] = sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1;

  //sgdma_rx/descriptor_read grant descriptor_memory/s1, which is an e_assign
  assign sgdma_rx_descriptor_read_granted_descriptor_memory_s1 = descriptor_memory_s1_grant_vector[3];

  //sgdma_rx/descriptor_read saved-grant descriptor_memory/s1, which is an e_assign
  assign sgdma_rx_descriptor_read_saved_grant_descriptor_memory_s1 = descriptor_memory_s1_arb_winner[3] && sgdma_rx_descriptor_read_requests_descriptor_memory_s1;

  //cpu/data_master assignment into master qualified-requests vector for descriptor_memory/s1, which is an e_assign
  assign descriptor_memory_s1_master_qreq_vector[4] = cpu_data_master_qualified_request_descriptor_memory_s1;

  //cpu/data_master grant descriptor_memory/s1, which is an e_assign
  assign cpu_data_master_granted_descriptor_memory_s1 = descriptor_memory_s1_grant_vector[4];

  //cpu/data_master saved-grant descriptor_memory/s1, which is an e_assign
  assign cpu_data_master_saved_grant_descriptor_memory_s1 = descriptor_memory_s1_arb_winner[4] && cpu_data_master_requests_descriptor_memory_s1;

  //descriptor_memory/s1 chosen-master double-vector, which is an e_assign
  assign descriptor_memory_s1_chosen_master_double_vector = {descriptor_memory_s1_master_qreq_vector, descriptor_memory_s1_master_qreq_vector} & ({~descriptor_memory_s1_master_qreq_vector, ~descriptor_memory_s1_master_qreq_vector} + descriptor_memory_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign descriptor_memory_s1_arb_winner = (descriptor_memory_s1_allow_new_arb_cycle & | descriptor_memory_s1_grant_vector) ? descriptor_memory_s1_grant_vector : descriptor_memory_s1_saved_chosen_master_vector;

  //saved descriptor_memory_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_memory_s1_saved_chosen_master_vector <= 0;
      else if (descriptor_memory_s1_allow_new_arb_cycle)
          descriptor_memory_s1_saved_chosen_master_vector <= |descriptor_memory_s1_grant_vector ? descriptor_memory_s1_grant_vector : descriptor_memory_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign descriptor_memory_s1_grant_vector = {(descriptor_memory_s1_chosen_master_double_vector[4] | descriptor_memory_s1_chosen_master_double_vector[9]),
    (descriptor_memory_s1_chosen_master_double_vector[3] | descriptor_memory_s1_chosen_master_double_vector[8]),
    (descriptor_memory_s1_chosen_master_double_vector[2] | descriptor_memory_s1_chosen_master_double_vector[7]),
    (descriptor_memory_s1_chosen_master_double_vector[1] | descriptor_memory_s1_chosen_master_double_vector[6]),
    (descriptor_memory_s1_chosen_master_double_vector[0] | descriptor_memory_s1_chosen_master_double_vector[5])};

  //descriptor_memory/s1 chosen master rotated left, which is an e_assign
  assign descriptor_memory_s1_chosen_master_rot_left = (descriptor_memory_s1_arb_winner << 1) ? (descriptor_memory_s1_arb_winner << 1) : 1;

  //descriptor_memory/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_memory_s1_arb_addend <= 1;
      else if (|descriptor_memory_s1_grant_vector)
          descriptor_memory_s1_arb_addend <= descriptor_memory_s1_end_xfer? descriptor_memory_s1_chosen_master_rot_left : descriptor_memory_s1_grant_vector;
    end


  assign descriptor_memory_s1_chipselect = cpu_data_master_granted_descriptor_memory_s1 | sgdma_rx_descriptor_read_granted_descriptor_memory_s1 | sgdma_rx_descriptor_write_granted_descriptor_memory_s1 | sgdma_tx_descriptor_read_granted_descriptor_memory_s1 | sgdma_tx_descriptor_write_granted_descriptor_memory_s1;
  //descriptor_memory_s1_firsttransfer first transaction, which is an e_assign
  assign descriptor_memory_s1_firsttransfer = descriptor_memory_s1_begins_xfer ? descriptor_memory_s1_unreg_firsttransfer : descriptor_memory_s1_reg_firsttransfer;

  //descriptor_memory_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign descriptor_memory_s1_unreg_firsttransfer = ~(descriptor_memory_s1_slavearbiterlockenable & descriptor_memory_s1_any_continuerequest);

  //descriptor_memory_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_memory_s1_reg_firsttransfer <= 1'b1;
      else if (descriptor_memory_s1_begins_xfer)
          descriptor_memory_s1_reg_firsttransfer <= descriptor_memory_s1_unreg_firsttransfer;
    end


  //descriptor_memory_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign descriptor_memory_s1_beginbursttransfer_internal = descriptor_memory_s1_begins_xfer;

  //descriptor_memory_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign descriptor_memory_s1_arbitration_holdoff_internal = descriptor_memory_s1_begins_xfer & descriptor_memory_s1_firsttransfer;

  //descriptor_memory_s1_write assignment, which is an e_mux
  assign descriptor_memory_s1_write = (cpu_data_master_granted_descriptor_memory_s1 & cpu_data_master_write) | (sgdma_rx_descriptor_write_granted_descriptor_memory_s1 & sgdma_rx_descriptor_write_write) | (sgdma_tx_descriptor_write_granted_descriptor_memory_s1 & sgdma_tx_descriptor_write_write);

  assign shifted_address_to_descriptor_memory_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //descriptor_memory_s1_address mux, which is an e_mux
  assign descriptor_memory_s1_address = (cpu_data_master_granted_descriptor_memory_s1)? (shifted_address_to_descriptor_memory_s1_from_cpu_data_master >> 2) :
    (sgdma_rx_descriptor_read_granted_descriptor_memory_s1)? (shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_read >> 2) :
    (sgdma_rx_descriptor_write_granted_descriptor_memory_s1)? (shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_write >> 2) :
    (sgdma_tx_descriptor_read_granted_descriptor_memory_s1)? (shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_read >> 2) :
    (shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_write >> 2);

  assign shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_read = sgdma_rx_descriptor_read_address_to_slave;
  assign shifted_address_to_descriptor_memory_s1_from_sgdma_rx_descriptor_write = sgdma_rx_descriptor_write_address_to_slave;
  assign shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_read = sgdma_tx_descriptor_read_address_to_slave;
  assign shifted_address_to_descriptor_memory_s1_from_sgdma_tx_descriptor_write = sgdma_tx_descriptor_write_address_to_slave;
  //d1_descriptor_memory_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_descriptor_memory_s1_end_xfer <= 1;
      else 
        d1_descriptor_memory_s1_end_xfer <= descriptor_memory_s1_end_xfer;
    end


  //descriptor_memory_s1_waits_for_read in a cycle, which is an e_mux
  assign descriptor_memory_s1_waits_for_read = descriptor_memory_s1_in_a_read_cycle & 0;

  //descriptor_memory_s1_in_a_read_cycle assignment, which is an e_assign
  assign descriptor_memory_s1_in_a_read_cycle = (cpu_data_master_granted_descriptor_memory_s1 & cpu_data_master_read) | (sgdma_rx_descriptor_read_granted_descriptor_memory_s1 & sgdma_rx_descriptor_read_read) | (sgdma_tx_descriptor_read_granted_descriptor_memory_s1 & sgdma_tx_descriptor_read_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = descriptor_memory_s1_in_a_read_cycle;

  //descriptor_memory_s1_waits_for_write in a cycle, which is an e_mux
  assign descriptor_memory_s1_waits_for_write = descriptor_memory_s1_in_a_write_cycle & 0;

  //descriptor_memory_s1_in_a_write_cycle assignment, which is an e_assign
  assign descriptor_memory_s1_in_a_write_cycle = (cpu_data_master_granted_descriptor_memory_s1 & cpu_data_master_write) | (sgdma_rx_descriptor_write_granted_descriptor_memory_s1 & sgdma_rx_descriptor_write_write) | (sgdma_tx_descriptor_write_granted_descriptor_memory_s1 & sgdma_tx_descriptor_write_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = descriptor_memory_s1_in_a_write_cycle;

  assign wait_for_descriptor_memory_s1_counter = 0;
  //descriptor_memory_s1_byteenable byte enable port mux, which is an e_mux
  assign descriptor_memory_s1_byteenable = (cpu_data_master_granted_descriptor_memory_s1)? cpu_data_master_byteenable :
    (sgdma_rx_descriptor_write_granted_descriptor_memory_s1)? {4 {1'b1}} :
    (sgdma_tx_descriptor_write_granted_descriptor_memory_s1)? {4 {1'b1}} :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //descriptor_memory/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_descriptor_memory_s1 + sgdma_rx_descriptor_read_granted_descriptor_memory_s1 + sgdma_rx_descriptor_write_granted_descriptor_memory_s1 + sgdma_tx_descriptor_read_granted_descriptor_memory_s1 + sgdma_tx_descriptor_write_granted_descriptor_memory_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_descriptor_memory_s1 + sgdma_rx_descriptor_read_saved_grant_descriptor_memory_s1 + sgdma_rx_descriptor_write_saved_grant_descriptor_memory_s1 + sgdma_tx_descriptor_read_saved_grant_descriptor_memory_s1 + sgdma_tx_descriptor_write_saved_grant_descriptor_memory_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module flash_tristate_bridge_avalon_slave_arbitrator (
                                                       // inputs:
                                                        clk,
                                                        cpu_data_master_address_to_slave,
                                                        cpu_data_master_byteenable,
                                                        cpu_data_master_dbs_address,
                                                        cpu_data_master_dbs_write_16,
                                                        cpu_data_master_latency_counter,
                                                        cpu_data_master_read,
                                                        cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                                        cpu_data_master_write,
                                                        cpu_instruction_master_address_to_slave,
                                                        cpu_instruction_master_dbs_address,
                                                        cpu_instruction_master_latency_counter,
                                                        cpu_instruction_master_read,
                                                        reset_n,

                                                       // outputs:
                                                        cpu_data_master_byteenable_ext_flash_s1,
                                                        cpu_data_master_granted_ext_flash_s1,
                                                        cpu_data_master_qualified_request_ext_flash_s1,
                                                        cpu_data_master_read_data_valid_ext_flash_s1,
                                                        cpu_data_master_requests_ext_flash_s1,
                                                        cpu_instruction_master_granted_ext_flash_s1,
                                                        cpu_instruction_master_qualified_request_ext_flash_s1,
                                                        cpu_instruction_master_read_data_valid_ext_flash_s1,
                                                        cpu_instruction_master_requests_ext_flash_s1,
                                                        d1_flash_tristate_bridge_avalon_slave_end_xfer,
                                                        ext_flash_s1_wait_counter_eq_0,
                                                        flash_tristate_bridge_address,
                                                        flash_tristate_bridge_data,
                                                        flash_tristate_bridge_readn,
                                                        flash_tristate_bridge_writen,
                                                        incoming_flash_tristate_bridge_data,
                                                        incoming_flash_tristate_bridge_data_with_Xs_converted_to_0,
                                                        select_n_to_the_ext_flash
                                                     )
;

  output  [  1: 0] cpu_data_master_byteenable_ext_flash_s1;
  output           cpu_data_master_granted_ext_flash_s1;
  output           cpu_data_master_qualified_request_ext_flash_s1;
  output           cpu_data_master_read_data_valid_ext_flash_s1;
  output           cpu_data_master_requests_ext_flash_s1;
  output           cpu_instruction_master_granted_ext_flash_s1;
  output           cpu_instruction_master_qualified_request_ext_flash_s1;
  output           cpu_instruction_master_read_data_valid_ext_flash_s1;
  output           cpu_instruction_master_requests_ext_flash_s1;
  output           d1_flash_tristate_bridge_avalon_slave_end_xfer;
  output           ext_flash_s1_wait_counter_eq_0;
  output  [ 24: 0] flash_tristate_bridge_address;
  inout   [ 15: 0] flash_tristate_bridge_data;
  output           flash_tristate_bridge_readn;
  output           flash_tristate_bridge_writen;
  output  [ 15: 0] incoming_flash_tristate_bridge_data;
  output  [ 15: 0] incoming_flash_tristate_bridge_data_with_Xs_converted_to_0;
  output           select_n_to_the_ext_flash;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_dbs_address;
  input   [ 15: 0] cpu_data_master_dbs_write_16;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 26: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_dbs_address;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire    [  1: 0] cpu_data_master_byteenable_ext_flash_s1;
  wire    [  1: 0] cpu_data_master_byteenable_ext_flash_s1_segment_0;
  wire    [  1: 0] cpu_data_master_byteenable_ext_flash_s1_segment_1;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_ext_flash_s1;
  wire             cpu_data_master_qualified_request_ext_flash_s1;
  wire             cpu_data_master_read_data_valid_ext_flash_s1;
  reg     [  1: 0] cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
  wire             cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in;
  wire             cpu_data_master_requests_ext_flash_s1;
  wire             cpu_data_master_saved_grant_ext_flash_s1;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_ext_flash_s1;
  wire             cpu_instruction_master_qualified_request_ext_flash_s1;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1;
  reg     [  1: 0] cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in;
  wire             cpu_instruction_master_requests_ext_flash_s1;
  wire             cpu_instruction_master_saved_grant_ext_flash_s1;
  reg              d1_flash_tristate_bridge_avalon_slave_end_xfer;
  reg              d1_in_a_write_cycle /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
  reg     [ 15: 0] d1_outgoing_flash_tristate_bridge_data /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave;
  wire    [  3: 0] ext_flash_s1_counter_load_value;
  wire             ext_flash_s1_in_a_read_cycle;
  wire             ext_flash_s1_in_a_write_cycle;
  reg     [  3: 0] ext_flash_s1_wait_counter;
  wire             ext_flash_s1_wait_counter_eq_0;
  wire             ext_flash_s1_waits_for_read;
  wire             ext_flash_s1_waits_for_write;
  wire             ext_flash_s1_with_write_latency;
  reg     [ 24: 0] flash_tristate_bridge_address /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             flash_tristate_bridge_avalon_slave_allgrants;
  wire             flash_tristate_bridge_avalon_slave_allow_new_arb_cycle;
  wire             flash_tristate_bridge_avalon_slave_any_bursting_master_saved_grant;
  wire             flash_tristate_bridge_avalon_slave_any_continuerequest;
  reg     [  1: 0] flash_tristate_bridge_avalon_slave_arb_addend;
  wire             flash_tristate_bridge_avalon_slave_arb_counter_enable;
  reg     [  1: 0] flash_tristate_bridge_avalon_slave_arb_share_counter;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_arb_share_counter_next_value;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_arb_share_set_values;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_arb_winner;
  wire             flash_tristate_bridge_avalon_slave_arbitration_holdoff_internal;
  wire             flash_tristate_bridge_avalon_slave_beginbursttransfer_internal;
  wire             flash_tristate_bridge_avalon_slave_begins_xfer;
  wire    [  3: 0] flash_tristate_bridge_avalon_slave_chosen_master_double_vector;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_chosen_master_rot_left;
  wire             flash_tristate_bridge_avalon_slave_end_xfer;
  wire             flash_tristate_bridge_avalon_slave_firsttransfer;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_grant_vector;
  wire    [  1: 0] flash_tristate_bridge_avalon_slave_master_qreq_vector;
  wire             flash_tristate_bridge_avalon_slave_non_bursting_master_requests;
  wire             flash_tristate_bridge_avalon_slave_read_pending;
  reg              flash_tristate_bridge_avalon_slave_reg_firsttransfer;
  reg     [  1: 0] flash_tristate_bridge_avalon_slave_saved_chosen_master_vector;
  reg              flash_tristate_bridge_avalon_slave_slavearbiterlockenable;
  wire             flash_tristate_bridge_avalon_slave_slavearbiterlockenable2;
  wire             flash_tristate_bridge_avalon_slave_unreg_firsttransfer;
  wire             flash_tristate_bridge_avalon_slave_write_pending;
  wire    [ 15: 0] flash_tristate_bridge_data;
  reg              flash_tristate_bridge_readn /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              flash_tristate_bridge_writen /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg     [ 15: 0] incoming_flash_tristate_bridge_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
  wire             incoming_flash_tristate_bridge_data_bit_0_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_10_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_11_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_12_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_13_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_14_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_15_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_1_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_2_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_3_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_4_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_5_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_6_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_7_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_8_is_x;
  wire             incoming_flash_tristate_bridge_data_bit_9_is_x;
  wire    [ 15: 0] incoming_flash_tristate_bridge_data_with_Xs_converted_to_0;
  reg              last_cycle_cpu_data_master_granted_slave_ext_flash_s1;
  reg              last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1;
  wire    [ 15: 0] outgoing_flash_tristate_bridge_data;
  wire    [  1: 0] p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
  wire    [  1: 0] p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
  wire    [ 24: 0] p1_flash_tristate_bridge_address;
  wire             p1_flash_tristate_bridge_readn;
  wire             p1_flash_tristate_bridge_writen;
  wire             p1_select_n_to_the_ext_flash;
  reg              select_n_to_the_ext_flash /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             time_to_write;
  wire             wait_for_ext_flash_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~flash_tristate_bridge_avalon_slave_end_xfer;
    end


  assign flash_tristate_bridge_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_ext_flash_s1 | cpu_instruction_master_qualified_request_ext_flash_s1));
  assign cpu_data_master_requests_ext_flash_s1 = ({cpu_data_master_address_to_slave[26 : 25] , 25'b0} == 27'h2000000) & (cpu_data_master_read | cpu_data_master_write);
  //~select_n_to_the_ext_flash of type chipselect to ~p1_select_n_to_the_ext_flash, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          select_n_to_the_ext_flash <= ~0;
      else 
        select_n_to_the_ext_flash <= p1_select_n_to_the_ext_flash;
    end


  assign flash_tristate_bridge_avalon_slave_write_pending = 0;
  //flash_tristate_bridge/avalon_slave read pending calc, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_read_pending = 0;

  //flash_tristate_bridge_avalon_slave_arb_share_counter set values, which is an e_mux
  assign flash_tristate_bridge_avalon_slave_arb_share_set_values = (cpu_data_master_granted_ext_flash_s1)? 2 :
    (cpu_instruction_master_granted_ext_flash_s1)? 2 :
    (cpu_data_master_granted_ext_flash_s1)? 2 :
    (cpu_instruction_master_granted_ext_flash_s1)? 2 :
    1;

  //flash_tristate_bridge_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign flash_tristate_bridge_avalon_slave_non_bursting_master_requests = cpu_data_master_requests_ext_flash_s1 |
    cpu_instruction_master_requests_ext_flash_s1 |
    cpu_data_master_requests_ext_flash_s1 |
    cpu_instruction_master_requests_ext_flash_s1;

  //flash_tristate_bridge_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign flash_tristate_bridge_avalon_slave_any_bursting_master_saved_grant = 0;

  //flash_tristate_bridge_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_arb_share_counter_next_value = flash_tristate_bridge_avalon_slave_firsttransfer ? (flash_tristate_bridge_avalon_slave_arb_share_set_values - 1) : |flash_tristate_bridge_avalon_slave_arb_share_counter ? (flash_tristate_bridge_avalon_slave_arb_share_counter - 1) : 0;

  //flash_tristate_bridge_avalon_slave_allgrants all slave grants, which is an e_mux
  assign flash_tristate_bridge_avalon_slave_allgrants = (|flash_tristate_bridge_avalon_slave_grant_vector) |
    (|flash_tristate_bridge_avalon_slave_grant_vector) |
    (|flash_tristate_bridge_avalon_slave_grant_vector) |
    (|flash_tristate_bridge_avalon_slave_grant_vector);

  //flash_tristate_bridge_avalon_slave_end_xfer assignment, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_end_xfer = ~(ext_flash_s1_waits_for_read | ext_flash_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave = flash_tristate_bridge_avalon_slave_end_xfer & (~flash_tristate_bridge_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //flash_tristate_bridge_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave & flash_tristate_bridge_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave & ~flash_tristate_bridge_avalon_slave_non_bursting_master_requests);

  //flash_tristate_bridge_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_avalon_slave_arb_share_counter <= 0;
      else if (flash_tristate_bridge_avalon_slave_arb_counter_enable)
          flash_tristate_bridge_avalon_slave_arb_share_counter <= flash_tristate_bridge_avalon_slave_arb_share_counter_next_value;
    end


  //flash_tristate_bridge_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|flash_tristate_bridge_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave) | (end_xfer_arb_share_counter_term_flash_tristate_bridge_avalon_slave & ~flash_tristate_bridge_avalon_slave_non_bursting_master_requests))
          flash_tristate_bridge_avalon_slave_slavearbiterlockenable <= |flash_tristate_bridge_avalon_slave_arb_share_counter_next_value;
    end


  //cpu/data_master flash_tristate_bridge/avalon_slave arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = flash_tristate_bridge_avalon_slave_slavearbiterlockenable & cpu_data_master_continuerequest;

  //flash_tristate_bridge_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_slavearbiterlockenable2 = |flash_tristate_bridge_avalon_slave_arb_share_counter_next_value;

  //cpu/data_master flash_tristate_bridge/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = flash_tristate_bridge_avalon_slave_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master flash_tristate_bridge/avalon_slave arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = flash_tristate_bridge_avalon_slave_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master flash_tristate_bridge/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = flash_tristate_bridge_avalon_slave_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted ext_flash/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 <= cpu_instruction_master_saved_grant_ext_flash_s1 ? 1 : (flash_tristate_bridge_avalon_slave_arbitration_holdoff_internal | ~cpu_instruction_master_requests_ext_flash_s1) ? 0 : last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 & cpu_instruction_master_requests_ext_flash_s1;

  //flash_tristate_bridge_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign flash_tristate_bridge_avalon_slave_any_continuerequest = cpu_instruction_master_continuerequest |
    cpu_data_master_continuerequest;

  assign cpu_data_master_qualified_request_ext_flash_s1 = cpu_data_master_requests_ext_flash_s1 & ~((cpu_data_master_read & (flash_tristate_bridge_avalon_slave_write_pending | (flash_tristate_bridge_avalon_slave_read_pending) | (2 < cpu_data_master_latency_counter) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))) | ((flash_tristate_bridge_avalon_slave_read_pending | !cpu_data_master_byteenable_ext_flash_s1) & cpu_data_master_write) | cpu_instruction_master_arbiterlock);
  //cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in = cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read & ~ext_flash_s1_waits_for_read;

  //shift register p1 cpu_data_master_read_data_valid_ext_flash_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register = {cpu_data_master_read_data_valid_ext_flash_s1_shift_register, cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in};

  //cpu_data_master_read_data_valid_ext_flash_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_data_valid_ext_flash_s1_shift_register <= 0;
      else 
        cpu_data_master_read_data_valid_ext_flash_s1_shift_register <= p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
    end


  //local readdatavalid cpu_data_master_read_data_valid_ext_flash_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_ext_flash_s1 = cpu_data_master_read_data_valid_ext_flash_s1_shift_register[1];

  //flash_tristate_bridge_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          incoming_flash_tristate_bridge_data <= 0;
      else 
        incoming_flash_tristate_bridge_data <= flash_tristate_bridge_data;
    end


  //ext_flash_s1_with_write_latency assignment, which is an e_assign
  assign ext_flash_s1_with_write_latency = in_a_write_cycle & (cpu_data_master_qualified_request_ext_flash_s1 | cpu_instruction_master_qualified_request_ext_flash_s1);

  //time to write the data, which is an e_mux
  assign time_to_write = (ext_flash_s1_with_write_latency)? 1 :
    0;

  //d1_outgoing_flash_tristate_bridge_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_outgoing_flash_tristate_bridge_data <= 0;
      else 
        d1_outgoing_flash_tristate_bridge_data <= outgoing_flash_tristate_bridge_data;
    end


  //write cycle delayed by 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_in_a_write_cycle <= 0;
      else 
        d1_in_a_write_cycle <= time_to_write;
    end


  //d1_outgoing_flash_tristate_bridge_data tristate driver, which is an e_assign
  assign flash_tristate_bridge_data = (d1_in_a_write_cycle)? d1_outgoing_flash_tristate_bridge_data:{16{1'bz}};

  //outgoing_flash_tristate_bridge_data mux, which is an e_mux
  assign outgoing_flash_tristate_bridge_data = cpu_data_master_dbs_write_16;

  assign cpu_instruction_master_requests_ext_flash_s1 = (({cpu_instruction_master_address_to_slave[26 : 25] , 25'b0} == 27'h2000000) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted ext_flash/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_ext_flash_s1 <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_ext_flash_s1 <= cpu_data_master_saved_grant_ext_flash_s1 ? 1 : (flash_tristate_bridge_avalon_slave_arbitration_holdoff_internal | ~cpu_data_master_requests_ext_flash_s1) ? 0 : last_cycle_cpu_data_master_granted_slave_ext_flash_s1;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = last_cycle_cpu_data_master_granted_slave_ext_flash_s1 & cpu_data_master_requests_ext_flash_s1;

  assign cpu_instruction_master_qualified_request_ext_flash_s1 = cpu_instruction_master_requests_ext_flash_s1 & ~((cpu_instruction_master_read & (flash_tristate_bridge_avalon_slave_write_pending | (flash_tristate_bridge_avalon_slave_read_pending) | (2 < cpu_instruction_master_latency_counter))) | cpu_data_master_arbiterlock);
  //cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in = cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read & ~ext_flash_s1_waits_for_read;

  //shift register p1 cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register = {cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register, cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in};

  //cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register <= 0;
      else 
        cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register <= p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
    end


  //local readdatavalid cpu_instruction_master_read_data_valid_ext_flash_s1, which is an e_mux
  assign cpu_instruction_master_read_data_valid_ext_flash_s1 = cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register[1];

  //allow new arb cycle for flash_tristate_bridge/avalon_slave, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for ext_flash/s1, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_master_qreq_vector[0] = cpu_instruction_master_qualified_request_ext_flash_s1;

  //cpu/instruction_master grant ext_flash/s1, which is an e_assign
  assign cpu_instruction_master_granted_ext_flash_s1 = flash_tristate_bridge_avalon_slave_grant_vector[0];

  //cpu/instruction_master saved-grant ext_flash/s1, which is an e_assign
  assign cpu_instruction_master_saved_grant_ext_flash_s1 = flash_tristate_bridge_avalon_slave_arb_winner[0] && cpu_instruction_master_requests_ext_flash_s1;

  //cpu/data_master assignment into master qualified-requests vector for ext_flash/s1, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_master_qreq_vector[1] = cpu_data_master_qualified_request_ext_flash_s1;

  //cpu/data_master grant ext_flash/s1, which is an e_assign
  assign cpu_data_master_granted_ext_flash_s1 = flash_tristate_bridge_avalon_slave_grant_vector[1];

  //cpu/data_master saved-grant ext_flash/s1, which is an e_assign
  assign cpu_data_master_saved_grant_ext_flash_s1 = flash_tristate_bridge_avalon_slave_arb_winner[1] && cpu_data_master_requests_ext_flash_s1;

  //flash_tristate_bridge/avalon_slave chosen-master double-vector, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_chosen_master_double_vector = {flash_tristate_bridge_avalon_slave_master_qreq_vector, flash_tristate_bridge_avalon_slave_master_qreq_vector} & ({~flash_tristate_bridge_avalon_slave_master_qreq_vector, ~flash_tristate_bridge_avalon_slave_master_qreq_vector} + flash_tristate_bridge_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign flash_tristate_bridge_avalon_slave_arb_winner = (flash_tristate_bridge_avalon_slave_allow_new_arb_cycle & | flash_tristate_bridge_avalon_slave_grant_vector) ? flash_tristate_bridge_avalon_slave_grant_vector : flash_tristate_bridge_avalon_slave_saved_chosen_master_vector;

  //saved flash_tristate_bridge_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_avalon_slave_saved_chosen_master_vector <= 0;
      else if (flash_tristate_bridge_avalon_slave_allow_new_arb_cycle)
          flash_tristate_bridge_avalon_slave_saved_chosen_master_vector <= |flash_tristate_bridge_avalon_slave_grant_vector ? flash_tristate_bridge_avalon_slave_grant_vector : flash_tristate_bridge_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign flash_tristate_bridge_avalon_slave_grant_vector = {(flash_tristate_bridge_avalon_slave_chosen_master_double_vector[1] | flash_tristate_bridge_avalon_slave_chosen_master_double_vector[3]),
    (flash_tristate_bridge_avalon_slave_chosen_master_double_vector[0] | flash_tristate_bridge_avalon_slave_chosen_master_double_vector[2])};

  //flash_tristate_bridge/avalon_slave chosen master rotated left, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_chosen_master_rot_left = (flash_tristate_bridge_avalon_slave_arb_winner << 1) ? (flash_tristate_bridge_avalon_slave_arb_winner << 1) : 1;

  //flash_tristate_bridge/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_avalon_slave_arb_addend <= 1;
      else if (|flash_tristate_bridge_avalon_slave_grant_vector)
          flash_tristate_bridge_avalon_slave_arb_addend <= flash_tristate_bridge_avalon_slave_end_xfer? flash_tristate_bridge_avalon_slave_chosen_master_rot_left : flash_tristate_bridge_avalon_slave_grant_vector;
    end


  assign p1_select_n_to_the_ext_flash = ~(cpu_data_master_granted_ext_flash_s1 | cpu_instruction_master_granted_ext_flash_s1);
  //flash_tristate_bridge_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_firsttransfer = flash_tristate_bridge_avalon_slave_begins_xfer ? flash_tristate_bridge_avalon_slave_unreg_firsttransfer : flash_tristate_bridge_avalon_slave_reg_firsttransfer;

  //flash_tristate_bridge_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_unreg_firsttransfer = ~(flash_tristate_bridge_avalon_slave_slavearbiterlockenable & flash_tristate_bridge_avalon_slave_any_continuerequest);

  //flash_tristate_bridge_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (flash_tristate_bridge_avalon_slave_begins_xfer)
          flash_tristate_bridge_avalon_slave_reg_firsttransfer <= flash_tristate_bridge_avalon_slave_unreg_firsttransfer;
    end


  //flash_tristate_bridge_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_beginbursttransfer_internal = flash_tristate_bridge_avalon_slave_begins_xfer;

  //flash_tristate_bridge_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign flash_tristate_bridge_avalon_slave_arbitration_holdoff_internal = flash_tristate_bridge_avalon_slave_begins_xfer & flash_tristate_bridge_avalon_slave_firsttransfer;

  //~flash_tristate_bridge_readn of type read to ~p1_flash_tristate_bridge_readn, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_readn <= ~0;
      else 
        flash_tristate_bridge_readn <= p1_flash_tristate_bridge_readn;
    end


  //~p1_flash_tristate_bridge_readn assignment, which is an e_mux
  assign p1_flash_tristate_bridge_readn = ~(((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read))& ~flash_tristate_bridge_avalon_slave_begins_xfer & (ext_flash_s1_wait_counter < 9));

  //~flash_tristate_bridge_writen of type write to ~p1_flash_tristate_bridge_writen, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_writen <= ~0;
      else 
        flash_tristate_bridge_writen <= p1_flash_tristate_bridge_writen;
    end


  //~p1_flash_tristate_bridge_writen assignment, which is an e_mux
  assign p1_flash_tristate_bridge_writen = ~(((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write)) & ~flash_tristate_bridge_avalon_slave_begins_xfer & (ext_flash_s1_wait_counter >= 2) & (ext_flash_s1_wait_counter < 11));

  //flash_tristate_bridge_address of type address to p1_flash_tristate_bridge_address, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          flash_tristate_bridge_address <= 0;
      else 
        flash_tristate_bridge_address <= p1_flash_tristate_bridge_address;
    end


  //p1_flash_tristate_bridge_address mux, which is an e_mux
  assign p1_flash_tristate_bridge_address = (cpu_data_master_granted_ext_flash_s1)? ({cpu_data_master_address_to_slave >> 2,
    cpu_data_master_dbs_address[1],
    {1 {1'b0}}}) :
    ({cpu_instruction_master_address_to_slave >> 2,
    cpu_instruction_master_dbs_address[1],
    {1 {1'b0}}});

  //d1_flash_tristate_bridge_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_flash_tristate_bridge_avalon_slave_end_xfer <= 1;
      else 
        d1_flash_tristate_bridge_avalon_slave_end_xfer <= flash_tristate_bridge_avalon_slave_end_xfer;
    end


  //ext_flash_s1_waits_for_read in a cycle, which is an e_mux
  assign ext_flash_s1_waits_for_read = ext_flash_s1_in_a_read_cycle & wait_for_ext_flash_s1_counter;

  //ext_flash_s1_in_a_read_cycle assignment, which is an e_assign
  assign ext_flash_s1_in_a_read_cycle = (cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ext_flash_s1_in_a_read_cycle;

  //ext_flash_s1_waits_for_write in a cycle, which is an e_mux
  assign ext_flash_s1_waits_for_write = ext_flash_s1_in_a_write_cycle & wait_for_ext_flash_s1_counter;

  //ext_flash_s1_in_a_write_cycle assignment, which is an e_assign
  assign ext_flash_s1_in_a_write_cycle = cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ext_flash_s1_in_a_write_cycle;

  assign ext_flash_s1_wait_counter_eq_0 = ext_flash_s1_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ext_flash_s1_wait_counter <= 0;
      else 
        ext_flash_s1_wait_counter <= ext_flash_s1_counter_load_value;
    end


  assign ext_flash_s1_counter_load_value = ((ext_flash_s1_in_a_read_cycle & flash_tristate_bridge_avalon_slave_begins_xfer))? 10 :
    ((ext_flash_s1_in_a_write_cycle & flash_tristate_bridge_avalon_slave_begins_xfer))? 12 :
    (~ext_flash_s1_wait_counter_eq_0)? ext_flash_s1_wait_counter - 1 :
    0;

  assign wait_for_ext_flash_s1_counter = flash_tristate_bridge_avalon_slave_begins_xfer | ~ext_flash_s1_wait_counter_eq_0;
  assign {cpu_data_master_byteenable_ext_flash_s1_segment_1,
cpu_data_master_byteenable_ext_flash_s1_segment_0} = cpu_data_master_byteenable;
  assign cpu_data_master_byteenable_ext_flash_s1 = ((cpu_data_master_dbs_address[1] == 0))? cpu_data_master_byteenable_ext_flash_s1_segment_0 :
    cpu_data_master_byteenable_ext_flash_s1_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //incoming_flash_tristate_bridge_data_bit_0_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_0_is_x = ^(incoming_flash_tristate_bridge_data[0]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[0] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[0] = incoming_flash_tristate_bridge_data_bit_0_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[0];

  //incoming_flash_tristate_bridge_data_bit_1_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_1_is_x = ^(incoming_flash_tristate_bridge_data[1]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[1] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[1] = incoming_flash_tristate_bridge_data_bit_1_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[1];

  //incoming_flash_tristate_bridge_data_bit_2_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_2_is_x = ^(incoming_flash_tristate_bridge_data[2]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[2] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[2] = incoming_flash_tristate_bridge_data_bit_2_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[2];

  //incoming_flash_tristate_bridge_data_bit_3_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_3_is_x = ^(incoming_flash_tristate_bridge_data[3]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[3] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[3] = incoming_flash_tristate_bridge_data_bit_3_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[3];

  //incoming_flash_tristate_bridge_data_bit_4_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_4_is_x = ^(incoming_flash_tristate_bridge_data[4]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[4] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[4] = incoming_flash_tristate_bridge_data_bit_4_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[4];

  //incoming_flash_tristate_bridge_data_bit_5_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_5_is_x = ^(incoming_flash_tristate_bridge_data[5]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[5] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[5] = incoming_flash_tristate_bridge_data_bit_5_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[5];

  //incoming_flash_tristate_bridge_data_bit_6_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_6_is_x = ^(incoming_flash_tristate_bridge_data[6]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[6] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[6] = incoming_flash_tristate_bridge_data_bit_6_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[6];

  //incoming_flash_tristate_bridge_data_bit_7_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_7_is_x = ^(incoming_flash_tristate_bridge_data[7]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[7] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[7] = incoming_flash_tristate_bridge_data_bit_7_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[7];

  //incoming_flash_tristate_bridge_data_bit_8_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_8_is_x = ^(incoming_flash_tristate_bridge_data[8]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[8] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[8] = incoming_flash_tristate_bridge_data_bit_8_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[8];

  //incoming_flash_tristate_bridge_data_bit_9_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_9_is_x = ^(incoming_flash_tristate_bridge_data[9]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[9] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[9] = incoming_flash_tristate_bridge_data_bit_9_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[9];

  //incoming_flash_tristate_bridge_data_bit_10_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_10_is_x = ^(incoming_flash_tristate_bridge_data[10]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[10] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[10] = incoming_flash_tristate_bridge_data_bit_10_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[10];

  //incoming_flash_tristate_bridge_data_bit_11_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_11_is_x = ^(incoming_flash_tristate_bridge_data[11]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[11] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[11] = incoming_flash_tristate_bridge_data_bit_11_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[11];

  //incoming_flash_tristate_bridge_data_bit_12_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_12_is_x = ^(incoming_flash_tristate_bridge_data[12]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[12] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[12] = incoming_flash_tristate_bridge_data_bit_12_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[12];

  //incoming_flash_tristate_bridge_data_bit_13_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_13_is_x = ^(incoming_flash_tristate_bridge_data[13]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[13] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[13] = incoming_flash_tristate_bridge_data_bit_13_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[13];

  //incoming_flash_tristate_bridge_data_bit_14_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_14_is_x = ^(incoming_flash_tristate_bridge_data[14]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[14] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[14] = incoming_flash_tristate_bridge_data_bit_14_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[14];

  //incoming_flash_tristate_bridge_data_bit_15_is_x x check, which is an e_assign_is_x
  assign incoming_flash_tristate_bridge_data_bit_15_is_x = ^(incoming_flash_tristate_bridge_data[15]) === 1'bx;

  //Crush incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[15] Xs to 0, which is an e_assign
  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0[15] = incoming_flash_tristate_bridge_data_bit_15_is_x ? 1'b0 : incoming_flash_tristate_bridge_data[15];

  //ext_flash/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_ext_flash_s1 + cpu_instruction_master_granted_ext_flash_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_ext_flash_s1 + cpu_instruction_master_saved_grant_ext_flash_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign incoming_flash_tristate_bridge_data_with_Xs_converted_to_0 = incoming_flash_tristate_bridge_data;
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module flash_tristate_bridge_bridge_arbitrator 
;



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module high_res_timer_s1_arbitrator (
                                      // inputs:
                                       clk,
                                       cpu_data_master_address_to_slave,
                                       cpu_data_master_latency_counter,
                                       cpu_data_master_read,
                                       cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                       cpu_data_master_write,
                                       cpu_data_master_writedata,
                                       high_res_timer_s1_irq,
                                       high_res_timer_s1_readdata,
                                       reset_n,

                                      // outputs:
                                       cpu_data_master_granted_high_res_timer_s1,
                                       cpu_data_master_qualified_request_high_res_timer_s1,
                                       cpu_data_master_read_data_valid_high_res_timer_s1,
                                       cpu_data_master_requests_high_res_timer_s1,
                                       d1_high_res_timer_s1_end_xfer,
                                       high_res_timer_s1_address,
                                       high_res_timer_s1_chipselect,
                                       high_res_timer_s1_irq_from_sa,
                                       high_res_timer_s1_readdata_from_sa,
                                       high_res_timer_s1_reset_n,
                                       high_res_timer_s1_write_n,
                                       high_res_timer_s1_writedata
                                    )
;

  output           cpu_data_master_granted_high_res_timer_s1;
  output           cpu_data_master_qualified_request_high_res_timer_s1;
  output           cpu_data_master_read_data_valid_high_res_timer_s1;
  output           cpu_data_master_requests_high_res_timer_s1;
  output           d1_high_res_timer_s1_end_xfer;
  output  [  2: 0] high_res_timer_s1_address;
  output           high_res_timer_s1_chipselect;
  output           high_res_timer_s1_irq_from_sa;
  output  [ 15: 0] high_res_timer_s1_readdata_from_sa;
  output           high_res_timer_s1_reset_n;
  output           high_res_timer_s1_write_n;
  output  [ 15: 0] high_res_timer_s1_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            high_res_timer_s1_irq;
  input   [ 15: 0] high_res_timer_s1_readdata;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_high_res_timer_s1;
  wire             cpu_data_master_qualified_request_high_res_timer_s1;
  wire             cpu_data_master_read_data_valid_high_res_timer_s1;
  wire             cpu_data_master_requests_high_res_timer_s1;
  wire             cpu_data_master_saved_grant_high_res_timer_s1;
  reg              d1_high_res_timer_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_high_res_timer_s1;
  wire    [  2: 0] high_res_timer_s1_address;
  wire             high_res_timer_s1_allgrants;
  wire             high_res_timer_s1_allow_new_arb_cycle;
  wire             high_res_timer_s1_any_bursting_master_saved_grant;
  wire             high_res_timer_s1_any_continuerequest;
  wire             high_res_timer_s1_arb_counter_enable;
  reg     [  1: 0] high_res_timer_s1_arb_share_counter;
  wire    [  1: 0] high_res_timer_s1_arb_share_counter_next_value;
  wire    [  1: 0] high_res_timer_s1_arb_share_set_values;
  wire             high_res_timer_s1_beginbursttransfer_internal;
  wire             high_res_timer_s1_begins_xfer;
  wire             high_res_timer_s1_chipselect;
  wire             high_res_timer_s1_end_xfer;
  wire             high_res_timer_s1_firsttransfer;
  wire             high_res_timer_s1_grant_vector;
  wire             high_res_timer_s1_in_a_read_cycle;
  wire             high_res_timer_s1_in_a_write_cycle;
  wire             high_res_timer_s1_irq_from_sa;
  wire             high_res_timer_s1_master_qreq_vector;
  wire             high_res_timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] high_res_timer_s1_readdata_from_sa;
  reg              high_res_timer_s1_reg_firsttransfer;
  wire             high_res_timer_s1_reset_n;
  reg              high_res_timer_s1_slavearbiterlockenable;
  wire             high_res_timer_s1_slavearbiterlockenable2;
  wire             high_res_timer_s1_unreg_firsttransfer;
  wire             high_res_timer_s1_waits_for_read;
  wire             high_res_timer_s1_waits_for_write;
  wire             high_res_timer_s1_write_n;
  wire    [ 15: 0] high_res_timer_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_high_res_timer_s1_from_cpu_data_master;
  wire             wait_for_high_res_timer_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~high_res_timer_s1_end_xfer;
    end


  assign high_res_timer_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_high_res_timer_s1));
  //assign high_res_timer_s1_readdata_from_sa = high_res_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign high_res_timer_s1_readdata_from_sa = high_res_timer_s1_readdata;

  assign cpu_data_master_requests_high_res_timer_s1 = ({cpu_data_master_address_to_slave[26 : 5] , 5'b0} == 27'h5201ca0) & (cpu_data_master_read | cpu_data_master_write);
  //high_res_timer_s1_arb_share_counter set values, which is an e_mux
  assign high_res_timer_s1_arb_share_set_values = 1;

  //high_res_timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign high_res_timer_s1_non_bursting_master_requests = cpu_data_master_requests_high_res_timer_s1;

  //high_res_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign high_res_timer_s1_any_bursting_master_saved_grant = 0;

  //high_res_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign high_res_timer_s1_arb_share_counter_next_value = high_res_timer_s1_firsttransfer ? (high_res_timer_s1_arb_share_set_values - 1) : |high_res_timer_s1_arb_share_counter ? (high_res_timer_s1_arb_share_counter - 1) : 0;

  //high_res_timer_s1_allgrants all slave grants, which is an e_mux
  assign high_res_timer_s1_allgrants = |high_res_timer_s1_grant_vector;

  //high_res_timer_s1_end_xfer assignment, which is an e_assign
  assign high_res_timer_s1_end_xfer = ~(high_res_timer_s1_waits_for_read | high_res_timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_high_res_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_high_res_timer_s1 = high_res_timer_s1_end_xfer & (~high_res_timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //high_res_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign high_res_timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_high_res_timer_s1 & high_res_timer_s1_allgrants) | (end_xfer_arb_share_counter_term_high_res_timer_s1 & ~high_res_timer_s1_non_bursting_master_requests);

  //high_res_timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_arb_share_counter <= 0;
      else if (high_res_timer_s1_arb_counter_enable)
          high_res_timer_s1_arb_share_counter <= high_res_timer_s1_arb_share_counter_next_value;
    end


  //high_res_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_slavearbiterlockenable <= 0;
      else if ((|high_res_timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_high_res_timer_s1) | (end_xfer_arb_share_counter_term_high_res_timer_s1 & ~high_res_timer_s1_non_bursting_master_requests))
          high_res_timer_s1_slavearbiterlockenable <= |high_res_timer_s1_arb_share_counter_next_value;
    end


  //cpu/data_master high_res_timer/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = high_res_timer_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //high_res_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign high_res_timer_s1_slavearbiterlockenable2 = |high_res_timer_s1_arb_share_counter_next_value;

  //cpu/data_master high_res_timer/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = high_res_timer_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //high_res_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign high_res_timer_s1_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_high_res_timer_s1 = cpu_data_master_requests_high_res_timer_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_high_res_timer_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_high_res_timer_s1 = cpu_data_master_granted_high_res_timer_s1 & cpu_data_master_read & ~high_res_timer_s1_waits_for_read;

  //high_res_timer_s1_writedata mux, which is an e_mux
  assign high_res_timer_s1_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_high_res_timer_s1 = cpu_data_master_qualified_request_high_res_timer_s1;

  //cpu/data_master saved-grant high_res_timer/s1, which is an e_assign
  assign cpu_data_master_saved_grant_high_res_timer_s1 = cpu_data_master_requests_high_res_timer_s1;

  //allow new arb cycle for high_res_timer/s1, which is an e_assign
  assign high_res_timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign high_res_timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign high_res_timer_s1_master_qreq_vector = 1;

  //high_res_timer_s1_reset_n assignment, which is an e_assign
  assign high_res_timer_s1_reset_n = reset_n;

  assign high_res_timer_s1_chipselect = cpu_data_master_granted_high_res_timer_s1;
  //high_res_timer_s1_firsttransfer first transaction, which is an e_assign
  assign high_res_timer_s1_firsttransfer = high_res_timer_s1_begins_xfer ? high_res_timer_s1_unreg_firsttransfer : high_res_timer_s1_reg_firsttransfer;

  //high_res_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign high_res_timer_s1_unreg_firsttransfer = ~(high_res_timer_s1_slavearbiterlockenable & high_res_timer_s1_any_continuerequest);

  //high_res_timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_reg_firsttransfer <= 1'b1;
      else if (high_res_timer_s1_begins_xfer)
          high_res_timer_s1_reg_firsttransfer <= high_res_timer_s1_unreg_firsttransfer;
    end


  //high_res_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign high_res_timer_s1_beginbursttransfer_internal = high_res_timer_s1_begins_xfer;

  //~high_res_timer_s1_write_n assignment, which is an e_mux
  assign high_res_timer_s1_write_n = ~(cpu_data_master_granted_high_res_timer_s1 & cpu_data_master_write);

  assign shifted_address_to_high_res_timer_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //high_res_timer_s1_address mux, which is an e_mux
  assign high_res_timer_s1_address = shifted_address_to_high_res_timer_s1_from_cpu_data_master >> 2;

  //d1_high_res_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_high_res_timer_s1_end_xfer <= 1;
      else 
        d1_high_res_timer_s1_end_xfer <= high_res_timer_s1_end_xfer;
    end


  //high_res_timer_s1_waits_for_read in a cycle, which is an e_mux
  assign high_res_timer_s1_waits_for_read = high_res_timer_s1_in_a_read_cycle & high_res_timer_s1_begins_xfer;

  //high_res_timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign high_res_timer_s1_in_a_read_cycle = cpu_data_master_granted_high_res_timer_s1 & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = high_res_timer_s1_in_a_read_cycle;

  //high_res_timer_s1_waits_for_write in a cycle, which is an e_mux
  assign high_res_timer_s1_waits_for_write = high_res_timer_s1_in_a_write_cycle & 0;

  //high_res_timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign high_res_timer_s1_in_a_write_cycle = cpu_data_master_granted_high_res_timer_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = high_res_timer_s1_in_a_write_cycle;

  assign wait_for_high_res_timer_s1_counter = 0;
  //assign high_res_timer_s1_irq_from_sa = high_res_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign high_res_timer_s1_irq_from_sa = high_res_timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //high_res_timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_arbitrator (
                                                // inputs:
                                                 DE4_SOPC_clock_1_out_address_to_slave,
                                                 DE4_SOPC_clock_1_out_nativeaddress,
                                                 DE4_SOPC_clock_1_out_read,
                                                 DE4_SOPC_clock_1_out_write,
                                                 DE4_SOPC_clock_1_out_writedata,
                                                 clk,
                                                 jtag_uart_avalon_jtag_slave_dataavailable,
                                                 jtag_uart_avalon_jtag_slave_irq,
                                                 jtag_uart_avalon_jtag_slave_readdata,
                                                 jtag_uart_avalon_jtag_slave_readyfordata,
                                                 jtag_uart_avalon_jtag_slave_waitrequest,
                                                 reset_n,

                                                // outputs:
                                                 DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave,
                                                 DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave,
                                                 DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave,
                                                 DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave,
                                                 d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                                 jtag_uart_avalon_jtag_slave_address,
                                                 jtag_uart_avalon_jtag_slave_chipselect,
                                                 jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
                                                 jtag_uart_avalon_jtag_slave_irq_from_sa,
                                                 jtag_uart_avalon_jtag_slave_read_n,
                                                 jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_reset_n,
                                                 jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                                 jtag_uart_avalon_jtag_slave_write_n,
                                                 jtag_uart_avalon_jtag_slave_writedata
                                              )
;

  output           DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave;
  output           DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave;
  output           DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave;
  output           DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;
  output           d1_jtag_uart_avalon_jtag_slave_end_xfer;
  output           jtag_uart_avalon_jtag_slave_address;
  output           jtag_uart_avalon_jtag_slave_chipselect;
  output           jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_avalon_jtag_slave_reset_n;
  output           jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  input   [  2: 0] DE4_SOPC_clock_1_out_address_to_slave;
  input            DE4_SOPC_clock_1_out_nativeaddress;
  input            DE4_SOPC_clock_1_out_read;
  input            DE4_SOPC_clock_1_out_write;
  input   [ 31: 0] DE4_SOPC_clock_1_out_writedata;
  input            clk;
  input            jtag_uart_avalon_jtag_slave_dataavailable;
  input            jtag_uart_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  input            jtag_uart_avalon_jtag_slave_readyfordata;
  input            jtag_uart_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             DE4_SOPC_clock_1_out_arbiterlock;
  wire             DE4_SOPC_clock_1_out_arbiterlock2;
  wire             DE4_SOPC_clock_1_out_continuerequest;
  wire             DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_saved_grant_jtag_uart_avalon_jtag_slave;
  reg              d1_jtag_uart_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_allgrants;
  wire             jtag_uart_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_avalon_jtag_slave_arb_counter_enable;
  reg              jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire             jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire             jtag_uart_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  reg              jtag_uart_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire             wait_for_jtag_uart_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave));
  //assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata;

  assign DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave = (1) & (DE4_SOPC_clock_1_out_read | DE4_SOPC_clock_1_out_write);
  //assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest;

  //jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_non_bursting_master_requests = DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;

  //jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_avalon_jtag_slave_firsttransfer ? (jtag_uart_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_avalon_jtag_slave_arb_share_counter ? (jtag_uart_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_allgrants = |jtag_uart_avalon_jtag_slave_grant_vector;

  //jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_end_xfer = ~(jtag_uart_avalon_jtag_slave_waits_for_read | jtag_uart_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave = jtag_uart_avalon_jtag_slave_end_xfer & (~jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & jtag_uart_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //DE4_SOPC_clock_1/out jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  assign DE4_SOPC_clock_1_out_arbiterlock = jtag_uart_avalon_jtag_slave_slavearbiterlockenable & DE4_SOPC_clock_1_out_continuerequest;

  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;

  //DE4_SOPC_clock_1/out jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign DE4_SOPC_clock_1_out_arbiterlock2 = jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 & DE4_SOPC_clock_1_out_continuerequest;

  //jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_any_continuerequest = 1;

  //DE4_SOPC_clock_1_out_continuerequest continued request, which is an e_assign
  assign DE4_SOPC_clock_1_out_continuerequest = 1;

  assign DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave = DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_writedata = DE4_SOPC_clock_1_out_writedata;

  //master is always granted when requested
  assign DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave = DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave;

  //DE4_SOPC_clock_1/out saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  assign DE4_SOPC_clock_1_out_saved_grant_jtag_uart_avalon_jtag_slave = DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_avalon_jtag_slave_chipselect = DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_firsttransfer = jtag_uart_avalon_jtag_slave_begins_xfer ? jtag_uart_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_avalon_jtag_slave_begins_xfer)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_read_n = ~(DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave & DE4_SOPC_clock_1_out_read);

  //~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_write_n = ~(DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave & DE4_SOPC_clock_1_out_write);

  //jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_address = DE4_SOPC_clock_1_out_nativeaddress;

  //d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_read = jtag_uart_avalon_jtag_slave_in_a_read_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_read_cycle = DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave & DE4_SOPC_clock_1_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_write = jtag_uart_avalon_jtag_slave_in_a_write_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_write_cycle = DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave & DE4_SOPC_clock_1_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module led_pio_s1_arbitrator (
                               // inputs:
                                clk,
                                led_pio_s1_readdata,
                                peripheral_clock_crossing_m1_address_to_slave,
                                peripheral_clock_crossing_m1_byteenable,
                                peripheral_clock_crossing_m1_latency_counter,
                                peripheral_clock_crossing_m1_nativeaddress,
                                peripheral_clock_crossing_m1_read,
                                peripheral_clock_crossing_m1_write,
                                peripheral_clock_crossing_m1_writedata,
                                reset_n,

                               // outputs:
                                d1_led_pio_s1_end_xfer,
                                led_pio_s1_address,
                                led_pio_s1_chipselect,
                                led_pio_s1_readdata_from_sa,
                                led_pio_s1_reset_n,
                                led_pio_s1_write_n,
                                led_pio_s1_writedata,
                                peripheral_clock_crossing_m1_granted_led_pio_s1,
                                peripheral_clock_crossing_m1_qualified_request_led_pio_s1,
                                peripheral_clock_crossing_m1_read_data_valid_led_pio_s1,
                                peripheral_clock_crossing_m1_requests_led_pio_s1
                             )
;

  output           d1_led_pio_s1_end_xfer;
  output  [  1: 0] led_pio_s1_address;
  output           led_pio_s1_chipselect;
  output  [  7: 0] led_pio_s1_readdata_from_sa;
  output           led_pio_s1_reset_n;
  output           led_pio_s1_write_n;
  output  [  7: 0] led_pio_s1_writedata;
  output           peripheral_clock_crossing_m1_granted_led_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_led_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_led_pio_s1;
  output           peripheral_clock_crossing_m1_requests_led_pio_s1;
  input            clk;
  input   [  7: 0] led_pio_s1_readdata;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input   [  3: 0] peripheral_clock_crossing_m1_byteenable;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input   [ 31: 0] peripheral_clock_crossing_m1_writedata;
  input            reset_n;

  reg              d1_led_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_led_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] led_pio_s1_address;
  wire             led_pio_s1_allgrants;
  wire             led_pio_s1_allow_new_arb_cycle;
  wire             led_pio_s1_any_bursting_master_saved_grant;
  wire             led_pio_s1_any_continuerequest;
  wire             led_pio_s1_arb_counter_enable;
  reg              led_pio_s1_arb_share_counter;
  wire             led_pio_s1_arb_share_counter_next_value;
  wire             led_pio_s1_arb_share_set_values;
  wire             led_pio_s1_beginbursttransfer_internal;
  wire             led_pio_s1_begins_xfer;
  wire             led_pio_s1_chipselect;
  wire             led_pio_s1_end_xfer;
  wire             led_pio_s1_firsttransfer;
  wire             led_pio_s1_grant_vector;
  wire             led_pio_s1_in_a_read_cycle;
  wire             led_pio_s1_in_a_write_cycle;
  wire             led_pio_s1_master_qreq_vector;
  wire             led_pio_s1_non_bursting_master_requests;
  wire             led_pio_s1_pretend_byte_enable;
  wire    [  7: 0] led_pio_s1_readdata_from_sa;
  reg              led_pio_s1_reg_firsttransfer;
  wire             led_pio_s1_reset_n;
  reg              led_pio_s1_slavearbiterlockenable;
  wire             led_pio_s1_slavearbiterlockenable2;
  wire             led_pio_s1_unreg_firsttransfer;
  wire             led_pio_s1_waits_for_read;
  wire             led_pio_s1_waits_for_write;
  wire             led_pio_s1_write_n;
  wire    [  7: 0] led_pio_s1_writedata;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_led_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_led_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_led_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_led_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_led_pio_s1;
  wire             wait_for_led_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~led_pio_s1_end_xfer;
    end


  assign led_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_led_pio_s1));
  //assign led_pio_s1_readdata_from_sa = led_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign led_pio_s1_readdata_from_sa = led_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_led_pio_s1 = ({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h0) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write);
  //led_pio_s1_arb_share_counter set values, which is an e_mux
  assign led_pio_s1_arb_share_set_values = 1;

  //led_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign led_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_led_pio_s1;

  //led_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign led_pio_s1_any_bursting_master_saved_grant = 0;

  //led_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign led_pio_s1_arb_share_counter_next_value = led_pio_s1_firsttransfer ? (led_pio_s1_arb_share_set_values - 1) : |led_pio_s1_arb_share_counter ? (led_pio_s1_arb_share_counter - 1) : 0;

  //led_pio_s1_allgrants all slave grants, which is an e_mux
  assign led_pio_s1_allgrants = |led_pio_s1_grant_vector;

  //led_pio_s1_end_xfer assignment, which is an e_assign
  assign led_pio_s1_end_xfer = ~(led_pio_s1_waits_for_read | led_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_led_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_led_pio_s1 = led_pio_s1_end_xfer & (~led_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //led_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign led_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_led_pio_s1 & led_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_led_pio_s1 & ~led_pio_s1_non_bursting_master_requests);

  //led_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_arb_share_counter <= 0;
      else if (led_pio_s1_arb_counter_enable)
          led_pio_s1_arb_share_counter <= led_pio_s1_arb_share_counter_next_value;
    end


  //led_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_slavearbiterlockenable <= 0;
      else if ((|led_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_led_pio_s1) | (end_xfer_arb_share_counter_term_led_pio_s1 & ~led_pio_s1_non_bursting_master_requests))
          led_pio_s1_slavearbiterlockenable <= |led_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 led_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = led_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //led_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign led_pio_s1_slavearbiterlockenable2 = |led_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 led_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = led_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //led_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign led_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_led_pio_s1 = peripheral_clock_crossing_m1_requests_led_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_led_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_led_pio_s1 = peripheral_clock_crossing_m1_granted_led_pio_s1 & peripheral_clock_crossing_m1_read & ~led_pio_s1_waits_for_read;

  //led_pio_s1_writedata mux, which is an e_mux
  assign led_pio_s1_writedata = peripheral_clock_crossing_m1_writedata;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_led_pio_s1 = peripheral_clock_crossing_m1_qualified_request_led_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant led_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_led_pio_s1 = peripheral_clock_crossing_m1_requests_led_pio_s1;

  //allow new arb cycle for led_pio/s1, which is an e_assign
  assign led_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign led_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign led_pio_s1_master_qreq_vector = 1;

  //led_pio_s1_reset_n assignment, which is an e_assign
  assign led_pio_s1_reset_n = reset_n;

  assign led_pio_s1_chipselect = peripheral_clock_crossing_m1_granted_led_pio_s1;
  //led_pio_s1_firsttransfer first transaction, which is an e_assign
  assign led_pio_s1_firsttransfer = led_pio_s1_begins_xfer ? led_pio_s1_unreg_firsttransfer : led_pio_s1_reg_firsttransfer;

  //led_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign led_pio_s1_unreg_firsttransfer = ~(led_pio_s1_slavearbiterlockenable & led_pio_s1_any_continuerequest);

  //led_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_reg_firsttransfer <= 1'b1;
      else if (led_pio_s1_begins_xfer)
          led_pio_s1_reg_firsttransfer <= led_pio_s1_unreg_firsttransfer;
    end


  //led_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign led_pio_s1_beginbursttransfer_internal = led_pio_s1_begins_xfer;

  //~led_pio_s1_write_n assignment, which is an e_mux
  assign led_pio_s1_write_n = ~(((peripheral_clock_crossing_m1_granted_led_pio_s1 & peripheral_clock_crossing_m1_write)) & led_pio_s1_pretend_byte_enable);

  //led_pio_s1_address mux, which is an e_mux
  assign led_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_led_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_led_pio_s1_end_xfer <= 1;
      else 
        d1_led_pio_s1_end_xfer <= led_pio_s1_end_xfer;
    end


  //led_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign led_pio_s1_waits_for_read = led_pio_s1_in_a_read_cycle & led_pio_s1_begins_xfer;

  //led_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign led_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_led_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = led_pio_s1_in_a_read_cycle;

  //led_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign led_pio_s1_waits_for_write = led_pio_s1_in_a_write_cycle & 0;

  //led_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign led_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_led_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = led_pio_s1_in_a_write_cycle;

  assign wait_for_led_pio_s1_counter = 0;
  //led_pio_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign led_pio_s1_pretend_byte_enable = (peripheral_clock_crossing_m1_granted_led_pio_s1)? peripheral_clock_crossing_m1_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //led_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module onchip_memory_s1_arbitrator (
                                     // inputs:
                                      clk,
                                      cpu_data_master_address_to_slave,
                                      cpu_data_master_byteenable,
                                      cpu_data_master_latency_counter,
                                      cpu_data_master_read,
                                      cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                      cpu_data_master_write,
                                      cpu_data_master_writedata,
                                      cpu_instruction_master_address_to_slave,
                                      cpu_instruction_master_latency_counter,
                                      cpu_instruction_master_read,
                                      onchip_memory_s1_readdata,
                                      reset_n,
                                      sgdma_rx_m_write_address_to_slave,
                                      sgdma_rx_m_write_byteenable,
                                      sgdma_rx_m_write_write,
                                      sgdma_rx_m_write_writedata,
                                      sgdma_tx_m_read_address_to_slave,
                                      sgdma_tx_m_read_latency_counter,
                                      sgdma_tx_m_read_read,

                                     // outputs:
                                      cpu_data_master_granted_onchip_memory_s1,
                                      cpu_data_master_qualified_request_onchip_memory_s1,
                                      cpu_data_master_read_data_valid_onchip_memory_s1,
                                      cpu_data_master_requests_onchip_memory_s1,
                                      cpu_instruction_master_granted_onchip_memory_s1,
                                      cpu_instruction_master_qualified_request_onchip_memory_s1,
                                      cpu_instruction_master_read_data_valid_onchip_memory_s1,
                                      cpu_instruction_master_requests_onchip_memory_s1,
                                      d1_onchip_memory_s1_end_xfer,
                                      onchip_memory_s1_address,
                                      onchip_memory_s1_byteenable,
                                      onchip_memory_s1_chipselect,
                                      onchip_memory_s1_clken,
                                      onchip_memory_s1_readdata_from_sa,
                                      onchip_memory_s1_write,
                                      onchip_memory_s1_writedata,
                                      sgdma_rx_m_write_granted_onchip_memory_s1,
                                      sgdma_rx_m_write_qualified_request_onchip_memory_s1,
                                      sgdma_rx_m_write_requests_onchip_memory_s1,
                                      sgdma_tx_m_read_granted_onchip_memory_s1,
                                      sgdma_tx_m_read_qualified_request_onchip_memory_s1,
                                      sgdma_tx_m_read_read_data_valid_onchip_memory_s1,
                                      sgdma_tx_m_read_requests_onchip_memory_s1
                                   )
;

  output           cpu_data_master_granted_onchip_memory_s1;
  output           cpu_data_master_qualified_request_onchip_memory_s1;
  output           cpu_data_master_read_data_valid_onchip_memory_s1;
  output           cpu_data_master_requests_onchip_memory_s1;
  output           cpu_instruction_master_granted_onchip_memory_s1;
  output           cpu_instruction_master_qualified_request_onchip_memory_s1;
  output           cpu_instruction_master_read_data_valid_onchip_memory_s1;
  output           cpu_instruction_master_requests_onchip_memory_s1;
  output           d1_onchip_memory_s1_end_xfer;
  output  [ 17: 0] onchip_memory_s1_address;
  output  [  3: 0] onchip_memory_s1_byteenable;
  output           onchip_memory_s1_chipselect;
  output           onchip_memory_s1_clken;
  output  [ 31: 0] onchip_memory_s1_readdata_from_sa;
  output           onchip_memory_s1_write;
  output  [ 31: 0] onchip_memory_s1_writedata;
  output           sgdma_rx_m_write_granted_onchip_memory_s1;
  output           sgdma_rx_m_write_qualified_request_onchip_memory_s1;
  output           sgdma_rx_m_write_requests_onchip_memory_s1;
  output           sgdma_tx_m_read_granted_onchip_memory_s1;
  output           sgdma_tx_m_read_qualified_request_onchip_memory_s1;
  output           sgdma_tx_m_read_read_data_valid_onchip_memory_s1;
  output           sgdma_tx_m_read_requests_onchip_memory_s1;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 26: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input   [ 31: 0] onchip_memory_s1_readdata;
  input            reset_n;
  input   [ 31: 0] sgdma_rx_m_write_address_to_slave;
  input   [  3: 0] sgdma_rx_m_write_byteenable;
  input            sgdma_rx_m_write_write;
  input   [ 31: 0] sgdma_rx_m_write_writedata;
  input   [ 31: 0] sgdma_tx_m_read_address_to_slave;
  input            sgdma_tx_m_read_latency_counter;
  input            sgdma_tx_m_read_read;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_onchip_memory_s1;
  wire             cpu_data_master_qualified_request_onchip_memory_s1;
  wire             cpu_data_master_read_data_valid_onchip_memory_s1;
  reg              cpu_data_master_read_data_valid_onchip_memory_s1_shift_register;
  wire             cpu_data_master_read_data_valid_onchip_memory_s1_shift_register_in;
  wire             cpu_data_master_requests_onchip_memory_s1;
  wire             cpu_data_master_saved_grant_onchip_memory_s1;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_onchip_memory_s1;
  wire             cpu_instruction_master_qualified_request_onchip_memory_s1;
  wire             cpu_instruction_master_read_data_valid_onchip_memory_s1;
  reg              cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register;
  wire             cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register_in;
  wire             cpu_instruction_master_requests_onchip_memory_s1;
  wire             cpu_instruction_master_saved_grant_onchip_memory_s1;
  reg              d1_onchip_memory_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_onchip_memory_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_data_master_granted_slave_onchip_memory_s1;
  reg              last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1;
  reg              last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1;
  reg              last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1;
  wire    [ 17: 0] onchip_memory_s1_address;
  wire             onchip_memory_s1_allgrants;
  wire             onchip_memory_s1_allow_new_arb_cycle;
  wire             onchip_memory_s1_any_bursting_master_saved_grant;
  wire             onchip_memory_s1_any_continuerequest;
  reg     [  3: 0] onchip_memory_s1_arb_addend;
  wire             onchip_memory_s1_arb_counter_enable;
  reg     [  1: 0] onchip_memory_s1_arb_share_counter;
  wire    [  1: 0] onchip_memory_s1_arb_share_counter_next_value;
  wire    [  1: 0] onchip_memory_s1_arb_share_set_values;
  wire    [  3: 0] onchip_memory_s1_arb_winner;
  wire             onchip_memory_s1_arbitration_holdoff_internal;
  wire             onchip_memory_s1_beginbursttransfer_internal;
  wire             onchip_memory_s1_begins_xfer;
  wire    [  3: 0] onchip_memory_s1_byteenable;
  wire             onchip_memory_s1_chipselect;
  wire    [  7: 0] onchip_memory_s1_chosen_master_double_vector;
  wire    [  3: 0] onchip_memory_s1_chosen_master_rot_left;
  wire             onchip_memory_s1_clken;
  wire             onchip_memory_s1_end_xfer;
  wire             onchip_memory_s1_firsttransfer;
  wire    [  3: 0] onchip_memory_s1_grant_vector;
  wire             onchip_memory_s1_in_a_read_cycle;
  wire             onchip_memory_s1_in_a_write_cycle;
  wire    [  3: 0] onchip_memory_s1_master_qreq_vector;
  wire             onchip_memory_s1_non_bursting_master_requests;
  wire    [ 31: 0] onchip_memory_s1_readdata_from_sa;
  reg              onchip_memory_s1_reg_firsttransfer;
  reg     [  3: 0] onchip_memory_s1_saved_chosen_master_vector;
  reg              onchip_memory_s1_slavearbiterlockenable;
  wire             onchip_memory_s1_slavearbiterlockenable2;
  wire             onchip_memory_s1_unreg_firsttransfer;
  wire             onchip_memory_s1_waits_for_read;
  wire             onchip_memory_s1_waits_for_write;
  wire             onchip_memory_s1_write;
  wire    [ 31: 0] onchip_memory_s1_writedata;
  wire             p1_cpu_data_master_read_data_valid_onchip_memory_s1_shift_register;
  wire             p1_cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register;
  wire             p1_sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register;
  wire             sgdma_rx_m_write_arbiterlock;
  wire             sgdma_rx_m_write_arbiterlock2;
  wire             sgdma_rx_m_write_continuerequest;
  wire             sgdma_rx_m_write_granted_onchip_memory_s1;
  wire             sgdma_rx_m_write_qualified_request_onchip_memory_s1;
  wire             sgdma_rx_m_write_requests_onchip_memory_s1;
  wire             sgdma_rx_m_write_saved_grant_onchip_memory_s1;
  wire             sgdma_tx_m_read_arbiterlock;
  wire             sgdma_tx_m_read_arbiterlock2;
  wire             sgdma_tx_m_read_continuerequest;
  wire             sgdma_tx_m_read_granted_onchip_memory_s1;
  wire             sgdma_tx_m_read_qualified_request_onchip_memory_s1;
  wire             sgdma_tx_m_read_read_data_valid_onchip_memory_s1;
  reg              sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register;
  wire             sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register_in;
  wire             sgdma_tx_m_read_requests_onchip_memory_s1;
  wire             sgdma_tx_m_read_saved_grant_onchip_memory_s1;
  wire    [ 26: 0] shifted_address_to_onchip_memory_s1_from_cpu_data_master;
  wire    [ 26: 0] shifted_address_to_onchip_memory_s1_from_cpu_instruction_master;
  wire    [ 31: 0] shifted_address_to_onchip_memory_s1_from_sgdma_rx_m_write;
  wire    [ 31: 0] shifted_address_to_onchip_memory_s1_from_sgdma_tx_m_read;
  wire             wait_for_onchip_memory_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~onchip_memory_s1_end_xfer;
    end


  assign onchip_memory_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_onchip_memory_s1 | cpu_instruction_master_qualified_request_onchip_memory_s1 | sgdma_rx_m_write_qualified_request_onchip_memory_s1 | sgdma_tx_m_read_qualified_request_onchip_memory_s1));
  //assign onchip_memory_s1_readdata_from_sa = onchip_memory_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign onchip_memory_s1_readdata_from_sa = onchip_memory_s1_readdata;

  assign cpu_data_master_requests_onchip_memory_s1 = ({cpu_data_master_address_to_slave[26 : 20] , 20'b0} == 27'h5100000) & (cpu_data_master_read | cpu_data_master_write);
  //onchip_memory_s1_arb_share_counter set values, which is an e_mux
  assign onchip_memory_s1_arb_share_set_values = 1;

  //onchip_memory_s1_non_bursting_master_requests mux, which is an e_mux
  assign onchip_memory_s1_non_bursting_master_requests = cpu_data_master_requests_onchip_memory_s1 |
    cpu_instruction_master_requests_onchip_memory_s1 |
    sgdma_rx_m_write_requests_onchip_memory_s1 |
    sgdma_tx_m_read_requests_onchip_memory_s1 |
    cpu_data_master_requests_onchip_memory_s1 |
    cpu_instruction_master_requests_onchip_memory_s1 |
    sgdma_rx_m_write_requests_onchip_memory_s1 |
    sgdma_tx_m_read_requests_onchip_memory_s1 |
    cpu_data_master_requests_onchip_memory_s1 |
    cpu_instruction_master_requests_onchip_memory_s1 |
    sgdma_rx_m_write_requests_onchip_memory_s1 |
    sgdma_tx_m_read_requests_onchip_memory_s1 |
    cpu_data_master_requests_onchip_memory_s1 |
    cpu_instruction_master_requests_onchip_memory_s1 |
    sgdma_rx_m_write_requests_onchip_memory_s1 |
    sgdma_tx_m_read_requests_onchip_memory_s1;

  //onchip_memory_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign onchip_memory_s1_any_bursting_master_saved_grant = 0;

  //onchip_memory_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign onchip_memory_s1_arb_share_counter_next_value = onchip_memory_s1_firsttransfer ? (onchip_memory_s1_arb_share_set_values - 1) : |onchip_memory_s1_arb_share_counter ? (onchip_memory_s1_arb_share_counter - 1) : 0;

  //onchip_memory_s1_allgrants all slave grants, which is an e_mux
  assign onchip_memory_s1_allgrants = (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector) |
    (|onchip_memory_s1_grant_vector);

  //onchip_memory_s1_end_xfer assignment, which is an e_assign
  assign onchip_memory_s1_end_xfer = ~(onchip_memory_s1_waits_for_read | onchip_memory_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_onchip_memory_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_onchip_memory_s1 = onchip_memory_s1_end_xfer & (~onchip_memory_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //onchip_memory_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign onchip_memory_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_onchip_memory_s1 & onchip_memory_s1_allgrants) | (end_xfer_arb_share_counter_term_onchip_memory_s1 & ~onchip_memory_s1_non_bursting_master_requests);

  //onchip_memory_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory_s1_arb_share_counter <= 0;
      else if (onchip_memory_s1_arb_counter_enable)
          onchip_memory_s1_arb_share_counter <= onchip_memory_s1_arb_share_counter_next_value;
    end


  //onchip_memory_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory_s1_slavearbiterlockenable <= 0;
      else if ((|onchip_memory_s1_master_qreq_vector & end_xfer_arb_share_counter_term_onchip_memory_s1) | (end_xfer_arb_share_counter_term_onchip_memory_s1 & ~onchip_memory_s1_non_bursting_master_requests))
          onchip_memory_s1_slavearbiterlockenable <= |onchip_memory_s1_arb_share_counter_next_value;
    end


  //cpu/data_master onchip_memory/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = onchip_memory_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //onchip_memory_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign onchip_memory_s1_slavearbiterlockenable2 = |onchip_memory_s1_arb_share_counter_next_value;

  //cpu/data_master onchip_memory/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = onchip_memory_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master onchip_memory/s1 arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = onchip_memory_s1_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master onchip_memory/s1 arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = onchip_memory_s1_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted onchip_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1 <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1 <= cpu_instruction_master_saved_grant_onchip_memory_s1 ? 1 : (onchip_memory_s1_arbitration_holdoff_internal | ~cpu_instruction_master_requests_onchip_memory_s1) ? 0 : last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = (last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1 & cpu_instruction_master_requests_onchip_memory_s1) |
    (last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1 & cpu_instruction_master_requests_onchip_memory_s1) |
    (last_cycle_cpu_instruction_master_granted_slave_onchip_memory_s1 & cpu_instruction_master_requests_onchip_memory_s1);

  //onchip_memory_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign onchip_memory_s1_any_continuerequest = cpu_instruction_master_continuerequest |
    sgdma_rx_m_write_continuerequest |
    sgdma_tx_m_read_continuerequest |
    cpu_data_master_continuerequest |
    sgdma_rx_m_write_continuerequest |
    sgdma_tx_m_read_continuerequest |
    cpu_data_master_continuerequest |
    cpu_instruction_master_continuerequest |
    sgdma_tx_m_read_continuerequest |
    cpu_data_master_continuerequest |
    cpu_instruction_master_continuerequest |
    sgdma_rx_m_write_continuerequest;

  //sgdma_rx/m_write onchip_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_rx_m_write_arbiterlock = onchip_memory_s1_slavearbiterlockenable & sgdma_rx_m_write_continuerequest;

  //sgdma_rx/m_write onchip_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_rx_m_write_arbiterlock2 = onchip_memory_s1_slavearbiterlockenable2 & sgdma_rx_m_write_continuerequest;

  //sgdma_rx/m_write granted onchip_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1 <= 0;
      else 
        last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1 <= sgdma_rx_m_write_saved_grant_onchip_memory_s1 ? 1 : (onchip_memory_s1_arbitration_holdoff_internal | ~sgdma_rx_m_write_requests_onchip_memory_s1) ? 0 : last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1;
    end


  //sgdma_rx_m_write_continuerequest continued request, which is an e_mux
  assign sgdma_rx_m_write_continuerequest = (last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1 & sgdma_rx_m_write_requests_onchip_memory_s1) |
    (last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1 & sgdma_rx_m_write_requests_onchip_memory_s1) |
    (last_cycle_sgdma_rx_m_write_granted_slave_onchip_memory_s1 & sgdma_rx_m_write_requests_onchip_memory_s1);

  //sgdma_tx/m_read onchip_memory/s1 arbiterlock, which is an e_assign
  assign sgdma_tx_m_read_arbiterlock = onchip_memory_s1_slavearbiterlockenable & sgdma_tx_m_read_continuerequest;

  //sgdma_tx/m_read onchip_memory/s1 arbiterlock2, which is an e_assign
  assign sgdma_tx_m_read_arbiterlock2 = onchip_memory_s1_slavearbiterlockenable2 & sgdma_tx_m_read_continuerequest;

  //sgdma_tx/m_read granted onchip_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1 <= 0;
      else 
        last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1 <= sgdma_tx_m_read_saved_grant_onchip_memory_s1 ? 1 : (onchip_memory_s1_arbitration_holdoff_internal | ~sgdma_tx_m_read_requests_onchip_memory_s1) ? 0 : last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1;
    end


  //sgdma_tx_m_read_continuerequest continued request, which is an e_mux
  assign sgdma_tx_m_read_continuerequest = (last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1 & sgdma_tx_m_read_requests_onchip_memory_s1) |
    (last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1 & sgdma_tx_m_read_requests_onchip_memory_s1) |
    (last_cycle_sgdma_tx_m_read_granted_slave_onchip_memory_s1 & sgdma_tx_m_read_requests_onchip_memory_s1);

  assign cpu_data_master_qualified_request_onchip_memory_s1 = cpu_data_master_requests_onchip_memory_s1 & ~((cpu_data_master_read & ((1 < cpu_data_master_latency_counter) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))) | cpu_instruction_master_arbiterlock | sgdma_rx_m_write_arbiterlock | sgdma_tx_m_read_arbiterlock);
  //cpu_data_master_read_data_valid_onchip_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_data_master_read_data_valid_onchip_memory_s1_shift_register_in = cpu_data_master_granted_onchip_memory_s1 & cpu_data_master_read & ~onchip_memory_s1_waits_for_read;

  //shift register p1 cpu_data_master_read_data_valid_onchip_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_data_master_read_data_valid_onchip_memory_s1_shift_register = {cpu_data_master_read_data_valid_onchip_memory_s1_shift_register, cpu_data_master_read_data_valid_onchip_memory_s1_shift_register_in};

  //cpu_data_master_read_data_valid_onchip_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_data_valid_onchip_memory_s1_shift_register <= 0;
      else 
        cpu_data_master_read_data_valid_onchip_memory_s1_shift_register <= p1_cpu_data_master_read_data_valid_onchip_memory_s1_shift_register;
    end


  //local readdatavalid cpu_data_master_read_data_valid_onchip_memory_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_onchip_memory_s1 = cpu_data_master_read_data_valid_onchip_memory_s1_shift_register;

  //onchip_memory_s1_writedata mux, which is an e_mux
  assign onchip_memory_s1_writedata = (cpu_data_master_granted_onchip_memory_s1)? cpu_data_master_writedata :
    sgdma_rx_m_write_writedata;

  //mux onchip_memory_s1_clken, which is an e_mux
  assign onchip_memory_s1_clken = 1'b1;

  assign cpu_instruction_master_requests_onchip_memory_s1 = (({cpu_instruction_master_address_to_slave[26 : 20] , 20'b0} == 27'h5100000) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted onchip_memory/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_onchip_memory_s1 <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_onchip_memory_s1 <= cpu_data_master_saved_grant_onchip_memory_s1 ? 1 : (onchip_memory_s1_arbitration_holdoff_internal | ~cpu_data_master_requests_onchip_memory_s1) ? 0 : last_cycle_cpu_data_master_granted_slave_onchip_memory_s1;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = (last_cycle_cpu_data_master_granted_slave_onchip_memory_s1 & cpu_data_master_requests_onchip_memory_s1) |
    (last_cycle_cpu_data_master_granted_slave_onchip_memory_s1 & cpu_data_master_requests_onchip_memory_s1) |
    (last_cycle_cpu_data_master_granted_slave_onchip_memory_s1 & cpu_data_master_requests_onchip_memory_s1);

  assign cpu_instruction_master_qualified_request_onchip_memory_s1 = cpu_instruction_master_requests_onchip_memory_s1 & ~((cpu_instruction_master_read & ((1 < cpu_instruction_master_latency_counter))) | cpu_data_master_arbiterlock | sgdma_rx_m_write_arbiterlock | sgdma_tx_m_read_arbiterlock);
  //cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register_in = cpu_instruction_master_granted_onchip_memory_s1 & cpu_instruction_master_read & ~onchip_memory_s1_waits_for_read;

  //shift register p1 cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register = {cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register, cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register_in};

  //cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register <= 0;
      else 
        cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register <= p1_cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register;
    end


  //local readdatavalid cpu_instruction_master_read_data_valid_onchip_memory_s1, which is an e_mux
  assign cpu_instruction_master_read_data_valid_onchip_memory_s1 = cpu_instruction_master_read_data_valid_onchip_memory_s1_shift_register;

  assign sgdma_rx_m_write_requests_onchip_memory_s1 = (({sgdma_rx_m_write_address_to_slave[31 : 20] , 20'b0} == 32'h5100000) & (sgdma_rx_m_write_write)) & sgdma_rx_m_write_write;
  assign sgdma_rx_m_write_qualified_request_onchip_memory_s1 = sgdma_rx_m_write_requests_onchip_memory_s1 & ~(cpu_data_master_arbiterlock | cpu_instruction_master_arbiterlock | sgdma_tx_m_read_arbiterlock);
  assign sgdma_tx_m_read_requests_onchip_memory_s1 = (({sgdma_tx_m_read_address_to_slave[31 : 20] , 20'b0} == 32'h5100000) & (sgdma_tx_m_read_read)) & sgdma_tx_m_read_read;
  assign sgdma_tx_m_read_qualified_request_onchip_memory_s1 = sgdma_tx_m_read_requests_onchip_memory_s1 & ~(cpu_data_master_arbiterlock | cpu_instruction_master_arbiterlock | sgdma_rx_m_write_arbiterlock);
  //sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register_in = sgdma_tx_m_read_granted_onchip_memory_s1 & sgdma_tx_m_read_read & ~onchip_memory_s1_waits_for_read;

  //shift register p1 sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register = {sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register, sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register_in};

  //sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register <= 0;
      else 
        sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register <= p1_sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register;
    end


  //local readdatavalid sgdma_tx_m_read_read_data_valid_onchip_memory_s1, which is an e_mux
  assign sgdma_tx_m_read_read_data_valid_onchip_memory_s1 = sgdma_tx_m_read_read_data_valid_onchip_memory_s1_shift_register;

  //allow new arb cycle for onchip_memory/s1, which is an e_assign
  assign onchip_memory_s1_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock & ~sgdma_rx_m_write_arbiterlock & ~sgdma_tx_m_read_arbiterlock;

  //sgdma_tx/m_read assignment into master qualified-requests vector for onchip_memory/s1, which is an e_assign
  assign onchip_memory_s1_master_qreq_vector[0] = sgdma_tx_m_read_qualified_request_onchip_memory_s1;

  //sgdma_tx/m_read grant onchip_memory/s1, which is an e_assign
  assign sgdma_tx_m_read_granted_onchip_memory_s1 = onchip_memory_s1_grant_vector[0];

  //sgdma_tx/m_read saved-grant onchip_memory/s1, which is an e_assign
  assign sgdma_tx_m_read_saved_grant_onchip_memory_s1 = onchip_memory_s1_arb_winner[0] && sgdma_tx_m_read_requests_onchip_memory_s1;

  //sgdma_rx/m_write assignment into master qualified-requests vector for onchip_memory/s1, which is an e_assign
  assign onchip_memory_s1_master_qreq_vector[1] = sgdma_rx_m_write_qualified_request_onchip_memory_s1;

  //sgdma_rx/m_write grant onchip_memory/s1, which is an e_assign
  assign sgdma_rx_m_write_granted_onchip_memory_s1 = onchip_memory_s1_grant_vector[1];

  //sgdma_rx/m_write saved-grant onchip_memory/s1, which is an e_assign
  assign sgdma_rx_m_write_saved_grant_onchip_memory_s1 = onchip_memory_s1_arb_winner[1] && sgdma_rx_m_write_requests_onchip_memory_s1;

  //cpu/instruction_master assignment into master qualified-requests vector for onchip_memory/s1, which is an e_assign
  assign onchip_memory_s1_master_qreq_vector[2] = cpu_instruction_master_qualified_request_onchip_memory_s1;

  //cpu/instruction_master grant onchip_memory/s1, which is an e_assign
  assign cpu_instruction_master_granted_onchip_memory_s1 = onchip_memory_s1_grant_vector[2];

  //cpu/instruction_master saved-grant onchip_memory/s1, which is an e_assign
  assign cpu_instruction_master_saved_grant_onchip_memory_s1 = onchip_memory_s1_arb_winner[2] && cpu_instruction_master_requests_onchip_memory_s1;

  //cpu/data_master assignment into master qualified-requests vector for onchip_memory/s1, which is an e_assign
  assign onchip_memory_s1_master_qreq_vector[3] = cpu_data_master_qualified_request_onchip_memory_s1;

  //cpu/data_master grant onchip_memory/s1, which is an e_assign
  assign cpu_data_master_granted_onchip_memory_s1 = onchip_memory_s1_grant_vector[3];

  //cpu/data_master saved-grant onchip_memory/s1, which is an e_assign
  assign cpu_data_master_saved_grant_onchip_memory_s1 = onchip_memory_s1_arb_winner[3] && cpu_data_master_requests_onchip_memory_s1;

  //onchip_memory/s1 chosen-master double-vector, which is an e_assign
  assign onchip_memory_s1_chosen_master_double_vector = {onchip_memory_s1_master_qreq_vector, onchip_memory_s1_master_qreq_vector} & ({~onchip_memory_s1_master_qreq_vector, ~onchip_memory_s1_master_qreq_vector} + onchip_memory_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign onchip_memory_s1_arb_winner = (onchip_memory_s1_allow_new_arb_cycle & | onchip_memory_s1_grant_vector) ? onchip_memory_s1_grant_vector : onchip_memory_s1_saved_chosen_master_vector;

  //saved onchip_memory_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory_s1_saved_chosen_master_vector <= 0;
      else if (onchip_memory_s1_allow_new_arb_cycle)
          onchip_memory_s1_saved_chosen_master_vector <= |onchip_memory_s1_grant_vector ? onchip_memory_s1_grant_vector : onchip_memory_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign onchip_memory_s1_grant_vector = {(onchip_memory_s1_chosen_master_double_vector[3] | onchip_memory_s1_chosen_master_double_vector[7]),
    (onchip_memory_s1_chosen_master_double_vector[2] | onchip_memory_s1_chosen_master_double_vector[6]),
    (onchip_memory_s1_chosen_master_double_vector[1] | onchip_memory_s1_chosen_master_double_vector[5]),
    (onchip_memory_s1_chosen_master_double_vector[0] | onchip_memory_s1_chosen_master_double_vector[4])};

  //onchip_memory/s1 chosen master rotated left, which is an e_assign
  assign onchip_memory_s1_chosen_master_rot_left = (onchip_memory_s1_arb_winner << 1) ? (onchip_memory_s1_arb_winner << 1) : 1;

  //onchip_memory/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory_s1_arb_addend <= 1;
      else if (|onchip_memory_s1_grant_vector)
          onchip_memory_s1_arb_addend <= onchip_memory_s1_end_xfer? onchip_memory_s1_chosen_master_rot_left : onchip_memory_s1_grant_vector;
    end


  assign onchip_memory_s1_chipselect = cpu_data_master_granted_onchip_memory_s1 | cpu_instruction_master_granted_onchip_memory_s1 | sgdma_rx_m_write_granted_onchip_memory_s1 | sgdma_tx_m_read_granted_onchip_memory_s1;
  //onchip_memory_s1_firsttransfer first transaction, which is an e_assign
  assign onchip_memory_s1_firsttransfer = onchip_memory_s1_begins_xfer ? onchip_memory_s1_unreg_firsttransfer : onchip_memory_s1_reg_firsttransfer;

  //onchip_memory_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign onchip_memory_s1_unreg_firsttransfer = ~(onchip_memory_s1_slavearbiterlockenable & onchip_memory_s1_any_continuerequest);

  //onchip_memory_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          onchip_memory_s1_reg_firsttransfer <= 1'b1;
      else if (onchip_memory_s1_begins_xfer)
          onchip_memory_s1_reg_firsttransfer <= onchip_memory_s1_unreg_firsttransfer;
    end


  //onchip_memory_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign onchip_memory_s1_beginbursttransfer_internal = onchip_memory_s1_begins_xfer;

  //onchip_memory_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign onchip_memory_s1_arbitration_holdoff_internal = onchip_memory_s1_begins_xfer & onchip_memory_s1_firsttransfer;

  //onchip_memory_s1_write assignment, which is an e_mux
  assign onchip_memory_s1_write = (cpu_data_master_granted_onchip_memory_s1 & cpu_data_master_write) | (sgdma_rx_m_write_granted_onchip_memory_s1 & sgdma_rx_m_write_write);

  assign shifted_address_to_onchip_memory_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //onchip_memory_s1_address mux, which is an e_mux
  assign onchip_memory_s1_address = (cpu_data_master_granted_onchip_memory_s1)? (shifted_address_to_onchip_memory_s1_from_cpu_data_master >> 2) :
    (cpu_instruction_master_granted_onchip_memory_s1)? (shifted_address_to_onchip_memory_s1_from_cpu_instruction_master >> 2) :
    (sgdma_rx_m_write_granted_onchip_memory_s1)? (shifted_address_to_onchip_memory_s1_from_sgdma_rx_m_write >> 2) :
    (shifted_address_to_onchip_memory_s1_from_sgdma_tx_m_read >> 2);

  assign shifted_address_to_onchip_memory_s1_from_cpu_instruction_master = cpu_instruction_master_address_to_slave;
  assign shifted_address_to_onchip_memory_s1_from_sgdma_rx_m_write = sgdma_rx_m_write_address_to_slave;
  assign shifted_address_to_onchip_memory_s1_from_sgdma_tx_m_read = sgdma_tx_m_read_address_to_slave;
  //d1_onchip_memory_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_onchip_memory_s1_end_xfer <= 1;
      else 
        d1_onchip_memory_s1_end_xfer <= onchip_memory_s1_end_xfer;
    end


  //onchip_memory_s1_waits_for_read in a cycle, which is an e_mux
  assign onchip_memory_s1_waits_for_read = onchip_memory_s1_in_a_read_cycle & 0;

  //onchip_memory_s1_in_a_read_cycle assignment, which is an e_assign
  assign onchip_memory_s1_in_a_read_cycle = (cpu_data_master_granted_onchip_memory_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_onchip_memory_s1 & cpu_instruction_master_read) | (sgdma_tx_m_read_granted_onchip_memory_s1 & sgdma_tx_m_read_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = onchip_memory_s1_in_a_read_cycle;

  //onchip_memory_s1_waits_for_write in a cycle, which is an e_mux
  assign onchip_memory_s1_waits_for_write = onchip_memory_s1_in_a_write_cycle & 0;

  //onchip_memory_s1_in_a_write_cycle assignment, which is an e_assign
  assign onchip_memory_s1_in_a_write_cycle = (cpu_data_master_granted_onchip_memory_s1 & cpu_data_master_write) | (sgdma_rx_m_write_granted_onchip_memory_s1 & sgdma_rx_m_write_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = onchip_memory_s1_in_a_write_cycle;

  assign wait_for_onchip_memory_s1_counter = 0;
  //onchip_memory_s1_byteenable byte enable port mux, which is an e_mux
  assign onchip_memory_s1_byteenable = (cpu_data_master_granted_onchip_memory_s1)? cpu_data_master_byteenable :
    (sgdma_rx_m_write_granted_onchip_memory_s1)? sgdma_rx_m_write_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //onchip_memory/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_onchip_memory_s1 + cpu_instruction_master_granted_onchip_memory_s1 + sgdma_rx_m_write_granted_onchip_memory_s1 + sgdma_tx_m_read_granted_onchip_memory_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_onchip_memory_s1 + cpu_instruction_master_saved_grant_onchip_memory_s1 + sgdma_rx_m_write_saved_grant_onchip_memory_s1 + sgdma_tx_m_read_saved_grant_onchip_memory_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pb_pio_s1_arbitrator (
                              // inputs:
                               clk,
                               pb_pio_s1_readdata,
                               peripheral_clock_crossing_m1_address_to_slave,
                               peripheral_clock_crossing_m1_latency_counter,
                               peripheral_clock_crossing_m1_nativeaddress,
                               peripheral_clock_crossing_m1_read,
                               peripheral_clock_crossing_m1_write,
                               reset_n,

                              // outputs:
                               d1_pb_pio_s1_end_xfer,
                               pb_pio_s1_address,
                               pb_pio_s1_readdata_from_sa,
                               pb_pio_s1_reset_n,
                               peripheral_clock_crossing_m1_granted_pb_pio_s1,
                               peripheral_clock_crossing_m1_qualified_request_pb_pio_s1,
                               peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1,
                               peripheral_clock_crossing_m1_requests_pb_pio_s1
                            )
;

  output           d1_pb_pio_s1_end_xfer;
  output  [  1: 0] pb_pio_s1_address;
  output  [  3: 0] pb_pio_s1_readdata_from_sa;
  output           pb_pio_s1_reset_n;
  output           peripheral_clock_crossing_m1_granted_pb_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_pb_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1;
  output           peripheral_clock_crossing_m1_requests_pb_pio_s1;
  input            clk;
  input   [  3: 0] pb_pio_s1_readdata;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input            reset_n;

  reg              d1_pb_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pb_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] pb_pio_s1_address;
  wire             pb_pio_s1_allgrants;
  wire             pb_pio_s1_allow_new_arb_cycle;
  wire             pb_pio_s1_any_bursting_master_saved_grant;
  wire             pb_pio_s1_any_continuerequest;
  wire             pb_pio_s1_arb_counter_enable;
  reg              pb_pio_s1_arb_share_counter;
  wire             pb_pio_s1_arb_share_counter_next_value;
  wire             pb_pio_s1_arb_share_set_values;
  wire             pb_pio_s1_beginbursttransfer_internal;
  wire             pb_pio_s1_begins_xfer;
  wire             pb_pio_s1_end_xfer;
  wire             pb_pio_s1_firsttransfer;
  wire             pb_pio_s1_grant_vector;
  wire             pb_pio_s1_in_a_read_cycle;
  wire             pb_pio_s1_in_a_write_cycle;
  wire             pb_pio_s1_master_qreq_vector;
  wire             pb_pio_s1_non_bursting_master_requests;
  wire    [  3: 0] pb_pio_s1_readdata_from_sa;
  reg              pb_pio_s1_reg_firsttransfer;
  wire             pb_pio_s1_reset_n;
  reg              pb_pio_s1_slavearbiterlockenable;
  wire             pb_pio_s1_slavearbiterlockenable2;
  wire             pb_pio_s1_unreg_firsttransfer;
  wire             pb_pio_s1_waits_for_read;
  wire             pb_pio_s1_waits_for_write;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_pb_pio_s1;
  wire             wait_for_pb_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pb_pio_s1_end_xfer;
    end


  assign pb_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_pb_pio_s1));
  //assign pb_pio_s1_readdata_from_sa = pb_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pb_pio_s1_readdata_from_sa = pb_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_pb_pio_s1 = (({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h20) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write)) & peripheral_clock_crossing_m1_read;
  //pb_pio_s1_arb_share_counter set values, which is an e_mux
  assign pb_pio_s1_arb_share_set_values = 1;

  //pb_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign pb_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_pb_pio_s1;

  //pb_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign pb_pio_s1_any_bursting_master_saved_grant = 0;

  //pb_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign pb_pio_s1_arb_share_counter_next_value = pb_pio_s1_firsttransfer ? (pb_pio_s1_arb_share_set_values - 1) : |pb_pio_s1_arb_share_counter ? (pb_pio_s1_arb_share_counter - 1) : 0;

  //pb_pio_s1_allgrants all slave grants, which is an e_mux
  assign pb_pio_s1_allgrants = |pb_pio_s1_grant_vector;

  //pb_pio_s1_end_xfer assignment, which is an e_assign
  assign pb_pio_s1_end_xfer = ~(pb_pio_s1_waits_for_read | pb_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_pb_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pb_pio_s1 = pb_pio_s1_end_xfer & (~pb_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pb_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign pb_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_pb_pio_s1 & pb_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_pb_pio_s1 & ~pb_pio_s1_non_bursting_master_requests);

  //pb_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pb_pio_s1_arb_share_counter <= 0;
      else if (pb_pio_s1_arb_counter_enable)
          pb_pio_s1_arb_share_counter <= pb_pio_s1_arb_share_counter_next_value;
    end


  //pb_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pb_pio_s1_slavearbiterlockenable <= 0;
      else if ((|pb_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_pb_pio_s1) | (end_xfer_arb_share_counter_term_pb_pio_s1 & ~pb_pio_s1_non_bursting_master_requests))
          pb_pio_s1_slavearbiterlockenable <= |pb_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 pb_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = pb_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //pb_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pb_pio_s1_slavearbiterlockenable2 = |pb_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 pb_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = pb_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //pb_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pb_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 = peripheral_clock_crossing_m1_requests_pb_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1 = peripheral_clock_crossing_m1_granted_pb_pio_s1 & peripheral_clock_crossing_m1_read & ~pb_pio_s1_waits_for_read;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_pb_pio_s1 = peripheral_clock_crossing_m1_qualified_request_pb_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant pb_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_pb_pio_s1 = peripheral_clock_crossing_m1_requests_pb_pio_s1;

  //allow new arb cycle for pb_pio/s1, which is an e_assign
  assign pb_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pb_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pb_pio_s1_master_qreq_vector = 1;

  //pb_pio_s1_reset_n assignment, which is an e_assign
  assign pb_pio_s1_reset_n = reset_n;

  //pb_pio_s1_firsttransfer first transaction, which is an e_assign
  assign pb_pio_s1_firsttransfer = pb_pio_s1_begins_xfer ? pb_pio_s1_unreg_firsttransfer : pb_pio_s1_reg_firsttransfer;

  //pb_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign pb_pio_s1_unreg_firsttransfer = ~(pb_pio_s1_slavearbiterlockenable & pb_pio_s1_any_continuerequest);

  //pb_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pb_pio_s1_reg_firsttransfer <= 1'b1;
      else if (pb_pio_s1_begins_xfer)
          pb_pio_s1_reg_firsttransfer <= pb_pio_s1_unreg_firsttransfer;
    end


  //pb_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pb_pio_s1_beginbursttransfer_internal = pb_pio_s1_begins_xfer;

  //pb_pio_s1_address mux, which is an e_mux
  assign pb_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_pb_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pb_pio_s1_end_xfer <= 1;
      else 
        d1_pb_pio_s1_end_xfer <= pb_pio_s1_end_xfer;
    end


  //pb_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign pb_pio_s1_waits_for_read = pb_pio_s1_in_a_read_cycle & pb_pio_s1_begins_xfer;

  //pb_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign pb_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_pb_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pb_pio_s1_in_a_read_cycle;

  //pb_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign pb_pio_s1_waits_for_write = pb_pio_s1_in_a_write_cycle & 0;

  //pb_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign pb_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_pb_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pb_pio_s1_in_a_write_cycle;

  assign wait_for_pb_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pb_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_data_master_to_peripheral_clock_crossing_s1_module (
                                                                             // inputs:
                                                                              clear_fifo,
                                                                              clk,
                                                                              data_in,
                                                                              read,
                                                                              reset_n,
                                                                              sync_reset,
                                                                              write,

                                                                             // outputs:
                                                                              data_out,
                                                                              empty,
                                                                              fifo_contains_ones_n,
                                                                              full
                                                                           )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_10;
  reg              full_11;
  reg              full_12;
  reg              full_13;
  reg              full_14;
  reg              full_15;
  reg              full_16;
  reg              full_17;
  reg              full_18;
  reg              full_19;
  reg              full_2;
  reg              full_20;
  reg              full_21;
  reg              full_22;
  reg              full_23;
  reg              full_24;
  reg              full_25;
  reg              full_26;
  reg              full_27;
  reg              full_28;
  reg              full_29;
  reg              full_3;
  reg              full_30;
  reg              full_31;
  wire             full_32;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  reg              full_7;
  reg              full_8;
  reg              full_9;
  reg     [  6: 0] how_many_ones;
  wire    [  6: 0] one_count_minus_one;
  wire    [  6: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p10_full_10;
  wire             p10_stage_10;
  wire             p11_full_11;
  wire             p11_stage_11;
  wire             p12_full_12;
  wire             p12_stage_12;
  wire             p13_full_13;
  wire             p13_stage_13;
  wire             p14_full_14;
  wire             p14_stage_14;
  wire             p15_full_15;
  wire             p15_stage_15;
  wire             p16_full_16;
  wire             p16_stage_16;
  wire             p17_full_17;
  wire             p17_stage_17;
  wire             p18_full_18;
  wire             p18_stage_18;
  wire             p19_full_19;
  wire             p19_stage_19;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p20_full_20;
  wire             p20_stage_20;
  wire             p21_full_21;
  wire             p21_stage_21;
  wire             p22_full_22;
  wire             p22_stage_22;
  wire             p23_full_23;
  wire             p23_stage_23;
  wire             p24_full_24;
  wire             p24_stage_24;
  wire             p25_full_25;
  wire             p25_stage_25;
  wire             p26_full_26;
  wire             p26_stage_26;
  wire             p27_full_27;
  wire             p27_stage_27;
  wire             p28_full_28;
  wire             p28_stage_28;
  wire             p29_full_29;
  wire             p29_stage_29;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p30_full_30;
  wire             p30_stage_30;
  wire             p31_full_31;
  wire             p31_stage_31;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  wire             p7_full_7;
  wire             p7_stage_7;
  wire             p8_full_8;
  wire             p8_stage_8;
  wire             p9_full_9;
  wire             p9_stage_9;
  reg              stage_0;
  reg              stage_1;
  reg              stage_10;
  reg              stage_11;
  reg              stage_12;
  reg              stage_13;
  reg              stage_14;
  reg              stage_15;
  reg              stage_16;
  reg              stage_17;
  reg              stage_18;
  reg              stage_19;
  reg              stage_2;
  reg              stage_20;
  reg              stage_21;
  reg              stage_22;
  reg              stage_23;
  reg              stage_24;
  reg              stage_25;
  reg              stage_26;
  reg              stage_27;
  reg              stage_28;
  reg              stage_29;
  reg              stage_3;
  reg              stage_30;
  reg              stage_31;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  reg              stage_7;
  reg              stage_8;
  reg              stage_9;
  wire    [  6: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_31;
  assign empty = !full_0;
  assign full_32 = 0;
  //data_31, which is an e_mux
  assign p31_stage_31 = ((full_32 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_31 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_31))
          if (sync_reset & full_31 & !((full_32 == 0) & read & write))
              stage_31 <= 0;
          else 
            stage_31 <= p31_stage_31;
    end


  //control_31, which is an e_mux
  assign p31_full_31 = ((read & !write) == 0)? full_30 :
    0;

  //control_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_31 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_31 <= 0;
          else 
            full_31 <= p31_full_31;
    end


  //data_30, which is an e_mux
  assign p30_stage_30 = ((full_31 & ~clear_fifo) == 0)? data_in :
    stage_31;

  //data_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_30 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_30))
          if (sync_reset & full_30 & !((full_31 == 0) & read & write))
              stage_30 <= 0;
          else 
            stage_30 <= p30_stage_30;
    end


  //control_30, which is an e_mux
  assign p30_full_30 = ((read & !write) == 0)? full_29 :
    full_31;

  //control_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_30 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_30 <= 0;
          else 
            full_30 <= p30_full_30;
    end


  //data_29, which is an e_mux
  assign p29_stage_29 = ((full_30 & ~clear_fifo) == 0)? data_in :
    stage_30;

  //data_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_29 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_29))
          if (sync_reset & full_29 & !((full_30 == 0) & read & write))
              stage_29 <= 0;
          else 
            stage_29 <= p29_stage_29;
    end


  //control_29, which is an e_mux
  assign p29_full_29 = ((read & !write) == 0)? full_28 :
    full_30;

  //control_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_29 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_29 <= 0;
          else 
            full_29 <= p29_full_29;
    end


  //data_28, which is an e_mux
  assign p28_stage_28 = ((full_29 & ~clear_fifo) == 0)? data_in :
    stage_29;

  //data_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_28 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_28))
          if (sync_reset & full_28 & !((full_29 == 0) & read & write))
              stage_28 <= 0;
          else 
            stage_28 <= p28_stage_28;
    end


  //control_28, which is an e_mux
  assign p28_full_28 = ((read & !write) == 0)? full_27 :
    full_29;

  //control_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_28 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_28 <= 0;
          else 
            full_28 <= p28_full_28;
    end


  //data_27, which is an e_mux
  assign p27_stage_27 = ((full_28 & ~clear_fifo) == 0)? data_in :
    stage_28;

  //data_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_27 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_27))
          if (sync_reset & full_27 & !((full_28 == 0) & read & write))
              stage_27 <= 0;
          else 
            stage_27 <= p27_stage_27;
    end


  //control_27, which is an e_mux
  assign p27_full_27 = ((read & !write) == 0)? full_26 :
    full_28;

  //control_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_27 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_27 <= 0;
          else 
            full_27 <= p27_full_27;
    end


  //data_26, which is an e_mux
  assign p26_stage_26 = ((full_27 & ~clear_fifo) == 0)? data_in :
    stage_27;

  //data_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_26 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_26))
          if (sync_reset & full_26 & !((full_27 == 0) & read & write))
              stage_26 <= 0;
          else 
            stage_26 <= p26_stage_26;
    end


  //control_26, which is an e_mux
  assign p26_full_26 = ((read & !write) == 0)? full_25 :
    full_27;

  //control_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_26 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_26 <= 0;
          else 
            full_26 <= p26_full_26;
    end


  //data_25, which is an e_mux
  assign p25_stage_25 = ((full_26 & ~clear_fifo) == 0)? data_in :
    stage_26;

  //data_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_25 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_25))
          if (sync_reset & full_25 & !((full_26 == 0) & read & write))
              stage_25 <= 0;
          else 
            stage_25 <= p25_stage_25;
    end


  //control_25, which is an e_mux
  assign p25_full_25 = ((read & !write) == 0)? full_24 :
    full_26;

  //control_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_25 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_25 <= 0;
          else 
            full_25 <= p25_full_25;
    end


  //data_24, which is an e_mux
  assign p24_stage_24 = ((full_25 & ~clear_fifo) == 0)? data_in :
    stage_25;

  //data_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_24 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_24))
          if (sync_reset & full_24 & !((full_25 == 0) & read & write))
              stage_24 <= 0;
          else 
            stage_24 <= p24_stage_24;
    end


  //control_24, which is an e_mux
  assign p24_full_24 = ((read & !write) == 0)? full_23 :
    full_25;

  //control_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_24 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_24 <= 0;
          else 
            full_24 <= p24_full_24;
    end


  //data_23, which is an e_mux
  assign p23_stage_23 = ((full_24 & ~clear_fifo) == 0)? data_in :
    stage_24;

  //data_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_23 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_23))
          if (sync_reset & full_23 & !((full_24 == 0) & read & write))
              stage_23 <= 0;
          else 
            stage_23 <= p23_stage_23;
    end


  //control_23, which is an e_mux
  assign p23_full_23 = ((read & !write) == 0)? full_22 :
    full_24;

  //control_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_23 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_23 <= 0;
          else 
            full_23 <= p23_full_23;
    end


  //data_22, which is an e_mux
  assign p22_stage_22 = ((full_23 & ~clear_fifo) == 0)? data_in :
    stage_23;

  //data_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_22 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_22))
          if (sync_reset & full_22 & !((full_23 == 0) & read & write))
              stage_22 <= 0;
          else 
            stage_22 <= p22_stage_22;
    end


  //control_22, which is an e_mux
  assign p22_full_22 = ((read & !write) == 0)? full_21 :
    full_23;

  //control_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_22 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_22 <= 0;
          else 
            full_22 <= p22_full_22;
    end


  //data_21, which is an e_mux
  assign p21_stage_21 = ((full_22 & ~clear_fifo) == 0)? data_in :
    stage_22;

  //data_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_21 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_21))
          if (sync_reset & full_21 & !((full_22 == 0) & read & write))
              stage_21 <= 0;
          else 
            stage_21 <= p21_stage_21;
    end


  //control_21, which is an e_mux
  assign p21_full_21 = ((read & !write) == 0)? full_20 :
    full_22;

  //control_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_21 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_21 <= 0;
          else 
            full_21 <= p21_full_21;
    end


  //data_20, which is an e_mux
  assign p20_stage_20 = ((full_21 & ~clear_fifo) == 0)? data_in :
    stage_21;

  //data_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_20 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_20))
          if (sync_reset & full_20 & !((full_21 == 0) & read & write))
              stage_20 <= 0;
          else 
            stage_20 <= p20_stage_20;
    end


  //control_20, which is an e_mux
  assign p20_full_20 = ((read & !write) == 0)? full_19 :
    full_21;

  //control_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_20 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_20 <= 0;
          else 
            full_20 <= p20_full_20;
    end


  //data_19, which is an e_mux
  assign p19_stage_19 = ((full_20 & ~clear_fifo) == 0)? data_in :
    stage_20;

  //data_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_19 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_19))
          if (sync_reset & full_19 & !((full_20 == 0) & read & write))
              stage_19 <= 0;
          else 
            stage_19 <= p19_stage_19;
    end


  //control_19, which is an e_mux
  assign p19_full_19 = ((read & !write) == 0)? full_18 :
    full_20;

  //control_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_19 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_19 <= 0;
          else 
            full_19 <= p19_full_19;
    end


  //data_18, which is an e_mux
  assign p18_stage_18 = ((full_19 & ~clear_fifo) == 0)? data_in :
    stage_19;

  //data_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_18 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_18))
          if (sync_reset & full_18 & !((full_19 == 0) & read & write))
              stage_18 <= 0;
          else 
            stage_18 <= p18_stage_18;
    end


  //control_18, which is an e_mux
  assign p18_full_18 = ((read & !write) == 0)? full_17 :
    full_19;

  //control_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_18 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_18 <= 0;
          else 
            full_18 <= p18_full_18;
    end


  //data_17, which is an e_mux
  assign p17_stage_17 = ((full_18 & ~clear_fifo) == 0)? data_in :
    stage_18;

  //data_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_17 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_17))
          if (sync_reset & full_17 & !((full_18 == 0) & read & write))
              stage_17 <= 0;
          else 
            stage_17 <= p17_stage_17;
    end


  //control_17, which is an e_mux
  assign p17_full_17 = ((read & !write) == 0)? full_16 :
    full_18;

  //control_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_17 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_17 <= 0;
          else 
            full_17 <= p17_full_17;
    end


  //data_16, which is an e_mux
  assign p16_stage_16 = ((full_17 & ~clear_fifo) == 0)? data_in :
    stage_17;

  //data_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_16 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_16))
          if (sync_reset & full_16 & !((full_17 == 0) & read & write))
              stage_16 <= 0;
          else 
            stage_16 <= p16_stage_16;
    end


  //control_16, which is an e_mux
  assign p16_full_16 = ((read & !write) == 0)? full_15 :
    full_17;

  //control_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_16 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_16 <= 0;
          else 
            full_16 <= p16_full_16;
    end


  //data_15, which is an e_mux
  assign p15_stage_15 = ((full_16 & ~clear_fifo) == 0)? data_in :
    stage_16;

  //data_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_15 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_15))
          if (sync_reset & full_15 & !((full_16 == 0) & read & write))
              stage_15 <= 0;
          else 
            stage_15 <= p15_stage_15;
    end


  //control_15, which is an e_mux
  assign p15_full_15 = ((read & !write) == 0)? full_14 :
    full_16;

  //control_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_15 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_15 <= 0;
          else 
            full_15 <= p15_full_15;
    end


  //data_14, which is an e_mux
  assign p14_stage_14 = ((full_15 & ~clear_fifo) == 0)? data_in :
    stage_15;

  //data_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_14 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_14))
          if (sync_reset & full_14 & !((full_15 == 0) & read & write))
              stage_14 <= 0;
          else 
            stage_14 <= p14_stage_14;
    end


  //control_14, which is an e_mux
  assign p14_full_14 = ((read & !write) == 0)? full_13 :
    full_15;

  //control_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_14 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_14 <= 0;
          else 
            full_14 <= p14_full_14;
    end


  //data_13, which is an e_mux
  assign p13_stage_13 = ((full_14 & ~clear_fifo) == 0)? data_in :
    stage_14;

  //data_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_13 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_13))
          if (sync_reset & full_13 & !((full_14 == 0) & read & write))
              stage_13 <= 0;
          else 
            stage_13 <= p13_stage_13;
    end


  //control_13, which is an e_mux
  assign p13_full_13 = ((read & !write) == 0)? full_12 :
    full_14;

  //control_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_13 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_13 <= 0;
          else 
            full_13 <= p13_full_13;
    end


  //data_12, which is an e_mux
  assign p12_stage_12 = ((full_13 & ~clear_fifo) == 0)? data_in :
    stage_13;

  //data_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_12 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_12))
          if (sync_reset & full_12 & !((full_13 == 0) & read & write))
              stage_12 <= 0;
          else 
            stage_12 <= p12_stage_12;
    end


  //control_12, which is an e_mux
  assign p12_full_12 = ((read & !write) == 0)? full_11 :
    full_13;

  //control_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_12 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_12 <= 0;
          else 
            full_12 <= p12_full_12;
    end


  //data_11, which is an e_mux
  assign p11_stage_11 = ((full_12 & ~clear_fifo) == 0)? data_in :
    stage_12;

  //data_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_11 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_11))
          if (sync_reset & full_11 & !((full_12 == 0) & read & write))
              stage_11 <= 0;
          else 
            stage_11 <= p11_stage_11;
    end


  //control_11, which is an e_mux
  assign p11_full_11 = ((read & !write) == 0)? full_10 :
    full_12;

  //control_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_11 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_11 <= 0;
          else 
            full_11 <= p11_full_11;
    end


  //data_10, which is an e_mux
  assign p10_stage_10 = ((full_11 & ~clear_fifo) == 0)? data_in :
    stage_11;

  //data_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_10 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_10))
          if (sync_reset & full_10 & !((full_11 == 0) & read & write))
              stage_10 <= 0;
          else 
            stage_10 <= p10_stage_10;
    end


  //control_10, which is an e_mux
  assign p10_full_10 = ((read & !write) == 0)? full_9 :
    full_11;

  //control_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_10 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_10 <= 0;
          else 
            full_10 <= p10_full_10;
    end


  //data_9, which is an e_mux
  assign p9_stage_9 = ((full_10 & ~clear_fifo) == 0)? data_in :
    stage_10;

  //data_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_9 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_9))
          if (sync_reset & full_9 & !((full_10 == 0) & read & write))
              stage_9 <= 0;
          else 
            stage_9 <= p9_stage_9;
    end


  //control_9, which is an e_mux
  assign p9_full_9 = ((read & !write) == 0)? full_8 :
    full_10;

  //control_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_9 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_9 <= 0;
          else 
            full_9 <= p9_full_9;
    end


  //data_8, which is an e_mux
  assign p8_stage_8 = ((full_9 & ~clear_fifo) == 0)? data_in :
    stage_9;

  //data_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_8 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_8))
          if (sync_reset & full_8 & !((full_9 == 0) & read & write))
              stage_8 <= 0;
          else 
            stage_8 <= p8_stage_8;
    end


  //control_8, which is an e_mux
  assign p8_full_8 = ((read & !write) == 0)? full_7 :
    full_9;

  //control_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_8 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_8 <= 0;
          else 
            full_8 <= p8_full_8;
    end


  //data_7, which is an e_mux
  assign p7_stage_7 = ((full_8 & ~clear_fifo) == 0)? data_in :
    stage_8;

  //data_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_7 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_7))
          if (sync_reset & full_7 & !((full_8 == 0) & read & write))
              stage_7 <= 0;
          else 
            stage_7 <= p7_stage_7;
    end


  //control_7, which is an e_mux
  assign p7_full_7 = ((read & !write) == 0)? full_6 :
    full_8;

  //control_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_7 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_7 <= 0;
          else 
            full_7 <= p7_full_7;
    end


  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    stage_7;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    full_7;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing_s1_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  cpu_data_master_address_to_slave,
                                                  cpu_data_master_byteenable,
                                                  cpu_data_master_latency_counter,
                                                  cpu_data_master_read,
                                                  cpu_data_master_write,
                                                  cpu_data_master_writedata,
                                                  peripheral_clock_crossing_s1_endofpacket,
                                                  peripheral_clock_crossing_s1_readdata,
                                                  peripheral_clock_crossing_s1_readdatavalid,
                                                  peripheral_clock_crossing_s1_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  cpu_data_master_granted_peripheral_clock_crossing_s1,
                                                  cpu_data_master_qualified_request_peripheral_clock_crossing_s1,
                                                  cpu_data_master_read_data_valid_peripheral_clock_crossing_s1,
                                                  cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                                  cpu_data_master_requests_peripheral_clock_crossing_s1,
                                                  d1_peripheral_clock_crossing_s1_end_xfer,
                                                  peripheral_clock_crossing_s1_address,
                                                  peripheral_clock_crossing_s1_byteenable,
                                                  peripheral_clock_crossing_s1_endofpacket_from_sa,
                                                  peripheral_clock_crossing_s1_nativeaddress,
                                                  peripheral_clock_crossing_s1_read,
                                                  peripheral_clock_crossing_s1_readdata_from_sa,
                                                  peripheral_clock_crossing_s1_reset_n,
                                                  peripheral_clock_crossing_s1_waitrequest_from_sa,
                                                  peripheral_clock_crossing_s1_write,
                                                  peripheral_clock_crossing_s1_writedata
                                               )
;

  output           cpu_data_master_granted_peripheral_clock_crossing_s1;
  output           cpu_data_master_qualified_request_peripheral_clock_crossing_s1;
  output           cpu_data_master_read_data_valid_peripheral_clock_crossing_s1;
  output           cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  output           cpu_data_master_requests_peripheral_clock_crossing_s1;
  output           d1_peripheral_clock_crossing_s1_end_xfer;
  output  [  4: 0] peripheral_clock_crossing_s1_address;
  output  [  3: 0] peripheral_clock_crossing_s1_byteenable;
  output           peripheral_clock_crossing_s1_endofpacket_from_sa;
  output  [  4: 0] peripheral_clock_crossing_s1_nativeaddress;
  output           peripheral_clock_crossing_s1_read;
  output  [ 31: 0] peripheral_clock_crossing_s1_readdata_from_sa;
  output           peripheral_clock_crossing_s1_reset_n;
  output           peripheral_clock_crossing_s1_waitrequest_from_sa;
  output           peripheral_clock_crossing_s1_write;
  output  [ 31: 0] peripheral_clock_crossing_s1_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            peripheral_clock_crossing_s1_endofpacket;
  input   [ 31: 0] peripheral_clock_crossing_s1_readdata;
  input            peripheral_clock_crossing_s1_readdatavalid;
  input            peripheral_clock_crossing_s1_waitrequest;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_peripheral_clock_crossing_s1;
  wire             cpu_data_master_qualified_request_peripheral_clock_crossing_s1;
  wire             cpu_data_master_rdv_fifo_empty_peripheral_clock_crossing_s1;
  wire             cpu_data_master_rdv_fifo_output_from_peripheral_clock_crossing_s1;
  wire             cpu_data_master_read_data_valid_peripheral_clock_crossing_s1;
  wire             cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  wire             cpu_data_master_requests_peripheral_clock_crossing_s1;
  wire             cpu_data_master_saved_grant_peripheral_clock_crossing_s1;
  reg              d1_peripheral_clock_crossing_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  4: 0] peripheral_clock_crossing_s1_address;
  wire             peripheral_clock_crossing_s1_allgrants;
  wire             peripheral_clock_crossing_s1_allow_new_arb_cycle;
  wire             peripheral_clock_crossing_s1_any_bursting_master_saved_grant;
  wire             peripheral_clock_crossing_s1_any_continuerequest;
  wire             peripheral_clock_crossing_s1_arb_counter_enable;
  reg     [  1: 0] peripheral_clock_crossing_s1_arb_share_counter;
  wire    [  1: 0] peripheral_clock_crossing_s1_arb_share_counter_next_value;
  wire    [  1: 0] peripheral_clock_crossing_s1_arb_share_set_values;
  wire             peripheral_clock_crossing_s1_beginbursttransfer_internal;
  wire             peripheral_clock_crossing_s1_begins_xfer;
  wire    [  3: 0] peripheral_clock_crossing_s1_byteenable;
  wire             peripheral_clock_crossing_s1_end_xfer;
  wire             peripheral_clock_crossing_s1_endofpacket_from_sa;
  wire             peripheral_clock_crossing_s1_firsttransfer;
  wire             peripheral_clock_crossing_s1_grant_vector;
  wire             peripheral_clock_crossing_s1_in_a_read_cycle;
  wire             peripheral_clock_crossing_s1_in_a_write_cycle;
  wire             peripheral_clock_crossing_s1_master_qreq_vector;
  wire             peripheral_clock_crossing_s1_move_on_to_next_transaction;
  wire    [  4: 0] peripheral_clock_crossing_s1_nativeaddress;
  wire             peripheral_clock_crossing_s1_non_bursting_master_requests;
  wire             peripheral_clock_crossing_s1_read;
  wire    [ 31: 0] peripheral_clock_crossing_s1_readdata_from_sa;
  wire             peripheral_clock_crossing_s1_readdatavalid_from_sa;
  reg              peripheral_clock_crossing_s1_reg_firsttransfer;
  wire             peripheral_clock_crossing_s1_reset_n;
  reg              peripheral_clock_crossing_s1_slavearbiterlockenable;
  wire             peripheral_clock_crossing_s1_slavearbiterlockenable2;
  wire             peripheral_clock_crossing_s1_unreg_firsttransfer;
  wire             peripheral_clock_crossing_s1_waitrequest_from_sa;
  wire             peripheral_clock_crossing_s1_waits_for_read;
  wire             peripheral_clock_crossing_s1_waits_for_write;
  wire             peripheral_clock_crossing_s1_write;
  wire    [ 31: 0] peripheral_clock_crossing_s1_writedata;
  wire    [ 26: 0] shifted_address_to_peripheral_clock_crossing_s1_from_cpu_data_master;
  wire             wait_for_peripheral_clock_crossing_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~peripheral_clock_crossing_s1_end_xfer;
    end


  assign peripheral_clock_crossing_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_peripheral_clock_crossing_s1));
  //assign peripheral_clock_crossing_s1_readdatavalid_from_sa = peripheral_clock_crossing_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign peripheral_clock_crossing_s1_readdatavalid_from_sa = peripheral_clock_crossing_s1_readdatavalid;

  //assign peripheral_clock_crossing_s1_readdata_from_sa = peripheral_clock_crossing_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign peripheral_clock_crossing_s1_readdata_from_sa = peripheral_clock_crossing_s1_readdata;

  assign cpu_data_master_requests_peripheral_clock_crossing_s1 = ({cpu_data_master_address_to_slave[26 : 7] , 7'b0} == 27'h4000000) & (cpu_data_master_read | cpu_data_master_write);
  //assign peripheral_clock_crossing_s1_waitrequest_from_sa = peripheral_clock_crossing_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign peripheral_clock_crossing_s1_waitrequest_from_sa = peripheral_clock_crossing_s1_waitrequest;

  //peripheral_clock_crossing_s1_arb_share_counter set values, which is an e_mux
  assign peripheral_clock_crossing_s1_arb_share_set_values = 1;

  //peripheral_clock_crossing_s1_non_bursting_master_requests mux, which is an e_mux
  assign peripheral_clock_crossing_s1_non_bursting_master_requests = cpu_data_master_requests_peripheral_clock_crossing_s1;

  //peripheral_clock_crossing_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign peripheral_clock_crossing_s1_any_bursting_master_saved_grant = 0;

  //peripheral_clock_crossing_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign peripheral_clock_crossing_s1_arb_share_counter_next_value = peripheral_clock_crossing_s1_firsttransfer ? (peripheral_clock_crossing_s1_arb_share_set_values - 1) : |peripheral_clock_crossing_s1_arb_share_counter ? (peripheral_clock_crossing_s1_arb_share_counter - 1) : 0;

  //peripheral_clock_crossing_s1_allgrants all slave grants, which is an e_mux
  assign peripheral_clock_crossing_s1_allgrants = |peripheral_clock_crossing_s1_grant_vector;

  //peripheral_clock_crossing_s1_end_xfer assignment, which is an e_assign
  assign peripheral_clock_crossing_s1_end_xfer = ~(peripheral_clock_crossing_s1_waits_for_read | peripheral_clock_crossing_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1 = peripheral_clock_crossing_s1_end_xfer & (~peripheral_clock_crossing_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //peripheral_clock_crossing_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign peripheral_clock_crossing_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1 & peripheral_clock_crossing_s1_allgrants) | (end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1 & ~peripheral_clock_crossing_s1_non_bursting_master_requests);

  //peripheral_clock_crossing_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_s1_arb_share_counter <= 0;
      else if (peripheral_clock_crossing_s1_arb_counter_enable)
          peripheral_clock_crossing_s1_arb_share_counter <= peripheral_clock_crossing_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_s1_slavearbiterlockenable <= 0;
      else if ((|peripheral_clock_crossing_s1_master_qreq_vector & end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1) | (end_xfer_arb_share_counter_term_peripheral_clock_crossing_s1 & ~peripheral_clock_crossing_s1_non_bursting_master_requests))
          peripheral_clock_crossing_s1_slavearbiterlockenable <= |peripheral_clock_crossing_s1_arb_share_counter_next_value;
    end


  //cpu/data_master peripheral_clock_crossing/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = peripheral_clock_crossing_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //peripheral_clock_crossing_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_s1_slavearbiterlockenable2 = |peripheral_clock_crossing_s1_arb_share_counter_next_value;

  //cpu/data_master peripheral_clock_crossing/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = peripheral_clock_crossing_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //peripheral_clock_crossing_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign peripheral_clock_crossing_s1_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_peripheral_clock_crossing_s1 = cpu_data_master_requests_peripheral_clock_crossing_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (1 < cpu_data_master_latency_counter))));
  //unique name for peripheral_clock_crossing_s1_move_on_to_next_transaction, which is an e_assign
  assign peripheral_clock_crossing_s1_move_on_to_next_transaction = peripheral_clock_crossing_s1_readdatavalid_from_sa;

  //rdv_fifo_for_cpu_data_master_to_peripheral_clock_crossing_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_peripheral_clock_crossing_s1_module rdv_fifo_for_cpu_data_master_to_peripheral_clock_crossing_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_data_master_granted_peripheral_clock_crossing_s1),
      .data_out             (cpu_data_master_rdv_fifo_output_from_peripheral_clock_crossing_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_data_master_rdv_fifo_empty_peripheral_clock_crossing_s1),
      .full                 (),
      .read                 (peripheral_clock_crossing_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~peripheral_clock_crossing_s1_waits_for_read)
    );

  assign cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register = ~cpu_data_master_rdv_fifo_empty_peripheral_clock_crossing_s1;
  //local readdatavalid cpu_data_master_read_data_valid_peripheral_clock_crossing_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_peripheral_clock_crossing_s1 = peripheral_clock_crossing_s1_readdatavalid_from_sa;

  //peripheral_clock_crossing_s1_writedata mux, which is an e_mux
  assign peripheral_clock_crossing_s1_writedata = cpu_data_master_writedata;

  //assign peripheral_clock_crossing_s1_endofpacket_from_sa = peripheral_clock_crossing_s1_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign peripheral_clock_crossing_s1_endofpacket_from_sa = peripheral_clock_crossing_s1_endofpacket;

  //master is always granted when requested
  assign cpu_data_master_granted_peripheral_clock_crossing_s1 = cpu_data_master_qualified_request_peripheral_clock_crossing_s1;

  //cpu/data_master saved-grant peripheral_clock_crossing/s1, which is an e_assign
  assign cpu_data_master_saved_grant_peripheral_clock_crossing_s1 = cpu_data_master_requests_peripheral_clock_crossing_s1;

  //allow new arb cycle for peripheral_clock_crossing/s1, which is an e_assign
  assign peripheral_clock_crossing_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign peripheral_clock_crossing_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign peripheral_clock_crossing_s1_master_qreq_vector = 1;

  //peripheral_clock_crossing_s1_reset_n assignment, which is an e_assign
  assign peripheral_clock_crossing_s1_reset_n = reset_n;

  //peripheral_clock_crossing_s1_firsttransfer first transaction, which is an e_assign
  assign peripheral_clock_crossing_s1_firsttransfer = peripheral_clock_crossing_s1_begins_xfer ? peripheral_clock_crossing_s1_unreg_firsttransfer : peripheral_clock_crossing_s1_reg_firsttransfer;

  //peripheral_clock_crossing_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign peripheral_clock_crossing_s1_unreg_firsttransfer = ~(peripheral_clock_crossing_s1_slavearbiterlockenable & peripheral_clock_crossing_s1_any_continuerequest);

  //peripheral_clock_crossing_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_s1_reg_firsttransfer <= 1'b1;
      else if (peripheral_clock_crossing_s1_begins_xfer)
          peripheral_clock_crossing_s1_reg_firsttransfer <= peripheral_clock_crossing_s1_unreg_firsttransfer;
    end


  //peripheral_clock_crossing_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign peripheral_clock_crossing_s1_beginbursttransfer_internal = peripheral_clock_crossing_s1_begins_xfer;

  //peripheral_clock_crossing_s1_read assignment, which is an e_mux
  assign peripheral_clock_crossing_s1_read = cpu_data_master_granted_peripheral_clock_crossing_s1 & cpu_data_master_read;

  //peripheral_clock_crossing_s1_write assignment, which is an e_mux
  assign peripheral_clock_crossing_s1_write = cpu_data_master_granted_peripheral_clock_crossing_s1 & cpu_data_master_write;

  assign shifted_address_to_peripheral_clock_crossing_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //peripheral_clock_crossing_s1_address mux, which is an e_mux
  assign peripheral_clock_crossing_s1_address = shifted_address_to_peripheral_clock_crossing_s1_from_cpu_data_master >> 2;

  //slaveid peripheral_clock_crossing_s1_nativeaddress nativeaddress mux, which is an e_mux
  assign peripheral_clock_crossing_s1_nativeaddress = cpu_data_master_address_to_slave >> 2;

  //d1_peripheral_clock_crossing_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_peripheral_clock_crossing_s1_end_xfer <= 1;
      else 
        d1_peripheral_clock_crossing_s1_end_xfer <= peripheral_clock_crossing_s1_end_xfer;
    end


  //peripheral_clock_crossing_s1_waits_for_read in a cycle, which is an e_mux
  assign peripheral_clock_crossing_s1_waits_for_read = peripheral_clock_crossing_s1_in_a_read_cycle & peripheral_clock_crossing_s1_waitrequest_from_sa;

  //peripheral_clock_crossing_s1_in_a_read_cycle assignment, which is an e_assign
  assign peripheral_clock_crossing_s1_in_a_read_cycle = cpu_data_master_granted_peripheral_clock_crossing_s1 & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = peripheral_clock_crossing_s1_in_a_read_cycle;

  //peripheral_clock_crossing_s1_waits_for_write in a cycle, which is an e_mux
  assign peripheral_clock_crossing_s1_waits_for_write = peripheral_clock_crossing_s1_in_a_write_cycle & peripheral_clock_crossing_s1_waitrequest_from_sa;

  //peripheral_clock_crossing_s1_in_a_write_cycle assignment, which is an e_assign
  assign peripheral_clock_crossing_s1_in_a_write_cycle = cpu_data_master_granted_peripheral_clock_crossing_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = peripheral_clock_crossing_s1_in_a_write_cycle;

  assign wait_for_peripheral_clock_crossing_s1_counter = 0;
  //peripheral_clock_crossing_s1_byteenable byte enable port mux, which is an e_mux
  assign peripheral_clock_crossing_s1_byteenable = (cpu_data_master_granted_peripheral_clock_crossing_s1)? cpu_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //peripheral_clock_crossing/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing_m1_arbitrator (
                                                 // inputs:
                                                  ADC_data_pio_s1_readdata_from_sa,
                                                  acq_busy_pio_s1_readdata_from_sa,
                                                  clk,
                                                  d1_ADC_data_pio_s1_end_xfer,
                                                  d1_acq_busy_pio_s1_end_xfer,
                                                  d1_led_pio_s1_end_xfer,
                                                  d1_pb_pio_s1_end_xfer,
                                                  d1_read_RAM_address_s1_end_xfer,
                                                  d1_read_RAM_busy_pio_s1_end_xfer,
                                                  d1_seven_seg_pio_s1_end_xfer,
                                                  d1_sw_pio_s1_end_xfer,
                                                  led_pio_s1_readdata_from_sa,
                                                  pb_pio_s1_readdata_from_sa,
                                                  peripheral_clock_crossing_m1_address,
                                                  peripheral_clock_crossing_m1_byteenable,
                                                  peripheral_clock_crossing_m1_granted_ADC_data_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_acq_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_led_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_pb_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_read_RAM_address_s1,
                                                  peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_seven_seg_pio_s1,
                                                  peripheral_clock_crossing_m1_granted_sw_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_led_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_pb_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1,
                                                  peripheral_clock_crossing_m1_qualified_request_sw_pio_s1,
                                                  peripheral_clock_crossing_m1_read,
                                                  peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_led_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1,
                                                  peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_ADC_data_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_acq_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_led_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_pb_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_read_RAM_address_s1,
                                                  peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_seven_seg_pio_s1,
                                                  peripheral_clock_crossing_m1_requests_sw_pio_s1,
                                                  peripheral_clock_crossing_m1_write,
                                                  peripheral_clock_crossing_m1_writedata,
                                                  read_RAM_address_s1_readdata_from_sa,
                                                  read_RAM_busy_pio_s1_readdata_from_sa,
                                                  reset_n,
                                                  seven_seg_pio_s1_readdata_from_sa,
                                                  sw_pio_s1_readdata_from_sa,

                                                 // outputs:
                                                  peripheral_clock_crossing_m1_address_to_slave,
                                                  peripheral_clock_crossing_m1_latency_counter,
                                                  peripheral_clock_crossing_m1_readdata,
                                                  peripheral_clock_crossing_m1_readdatavalid,
                                                  peripheral_clock_crossing_m1_reset_n,
                                                  peripheral_clock_crossing_m1_waitrequest
                                               )
;

  output  [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  output           peripheral_clock_crossing_m1_latency_counter;
  output  [ 31: 0] peripheral_clock_crossing_m1_readdata;
  output           peripheral_clock_crossing_m1_readdatavalid;
  output           peripheral_clock_crossing_m1_reset_n;
  output           peripheral_clock_crossing_m1_waitrequest;
  input   [ 15: 0] ADC_data_pio_s1_readdata_from_sa;
  input            acq_busy_pio_s1_readdata_from_sa;
  input            clk;
  input            d1_ADC_data_pio_s1_end_xfer;
  input            d1_acq_busy_pio_s1_end_xfer;
  input            d1_led_pio_s1_end_xfer;
  input            d1_pb_pio_s1_end_xfer;
  input            d1_read_RAM_address_s1_end_xfer;
  input            d1_read_RAM_busy_pio_s1_end_xfer;
  input            d1_seven_seg_pio_s1_end_xfer;
  input            d1_sw_pio_s1_end_xfer;
  input   [  7: 0] led_pio_s1_readdata_from_sa;
  input   [  3: 0] pb_pio_s1_readdata_from_sa;
  input   [  6: 0] peripheral_clock_crossing_m1_address;
  input   [  3: 0] peripheral_clock_crossing_m1_byteenable;
  input            peripheral_clock_crossing_m1_granted_ADC_data_pio_s1;
  input            peripheral_clock_crossing_m1_granted_acq_busy_pio_s1;
  input            peripheral_clock_crossing_m1_granted_led_pio_s1;
  input            peripheral_clock_crossing_m1_granted_pb_pio_s1;
  input            peripheral_clock_crossing_m1_granted_read_RAM_address_s1;
  input            peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1;
  input            peripheral_clock_crossing_m1_granted_seven_seg_pio_s1;
  input            peripheral_clock_crossing_m1_granted_sw_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_led_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_pb_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1;
  input            peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1;
  input            peripheral_clock_crossing_m1_qualified_request_sw_pio_s1;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_led_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1;
  input            peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1;
  input            peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;
  input            peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;
  input            peripheral_clock_crossing_m1_requests_led_pio_s1;
  input            peripheral_clock_crossing_m1_requests_pb_pio_s1;
  input            peripheral_clock_crossing_m1_requests_read_RAM_address_s1;
  input            peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;
  input            peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;
  input            peripheral_clock_crossing_m1_requests_sw_pio_s1;
  input            peripheral_clock_crossing_m1_write;
  input   [ 31: 0] peripheral_clock_crossing_m1_writedata;
  input   [ 10: 0] read_RAM_address_s1_readdata_from_sa;
  input            read_RAM_busy_pio_s1_readdata_from_sa;
  input            reset_n;
  input   [ 15: 0] seven_seg_pio_s1_readdata_from_sa;
  input   [  7: 0] sw_pio_s1_readdata_from_sa;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_peripheral_clock_crossing_m1_latency_counter;
  reg     [  6: 0] peripheral_clock_crossing_m1_address_last_time;
  wire    [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  reg     [  3: 0] peripheral_clock_crossing_m1_byteenable_last_time;
  wire             peripheral_clock_crossing_m1_is_granted_some_slave;
  reg              peripheral_clock_crossing_m1_latency_counter;
  reg              peripheral_clock_crossing_m1_read_but_no_slave_selected;
  reg              peripheral_clock_crossing_m1_read_last_time;
  wire    [ 31: 0] peripheral_clock_crossing_m1_readdata;
  wire             peripheral_clock_crossing_m1_readdatavalid;
  wire             peripheral_clock_crossing_m1_reset_n;
  wire             peripheral_clock_crossing_m1_run;
  wire             peripheral_clock_crossing_m1_waitrequest;
  reg              peripheral_clock_crossing_m1_write_last_time;
  reg     [ 31: 0] peripheral_clock_crossing_m1_writedata_last_time;
  wire             pre_flush_peripheral_clock_crossing_m1_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 | ~peripheral_clock_crossing_m1_requests_ADC_data_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_ADC_data_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write))) & 1 & (peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 | ~peripheral_clock_crossing_m1_requests_acq_busy_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_acq_busy_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write)));

  //cascaded wait assignment, which is an e_assign
  assign peripheral_clock_crossing_m1_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (peripheral_clock_crossing_m1_qualified_request_led_pio_s1 | ~peripheral_clock_crossing_m1_requests_led_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_led_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_led_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_led_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write))) & 1 & (peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 | ~peripheral_clock_crossing_m1_requests_pb_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_pb_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write))) & 1 & (peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 | ~peripheral_clock_crossing_m1_requests_read_RAM_address_s1) & ((~peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_read_RAM_address_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write))) & 1 & (peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 | ~peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_read_RAM_busy_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write))) & 1 & (peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 | ~peripheral_clock_crossing_m1_requests_seven_seg_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_seven_seg_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write)));

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 | ~peripheral_clock_crossing_m1_requests_sw_pio_s1) & ((~peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 | ~peripheral_clock_crossing_m1_read | (1 & ~d1_sw_pio_s1_end_xfer & peripheral_clock_crossing_m1_read))) & ((~peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 | ~peripheral_clock_crossing_m1_write | (1 & peripheral_clock_crossing_m1_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign peripheral_clock_crossing_m1_address_to_slave = peripheral_clock_crossing_m1_address[6 : 0];

  //peripheral_clock_crossing_m1_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_read_but_no_slave_selected <= 0;
      else 
        peripheral_clock_crossing_m1_read_but_no_slave_selected <= peripheral_clock_crossing_m1_read & peripheral_clock_crossing_m1_run & ~peripheral_clock_crossing_m1_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign peripheral_clock_crossing_m1_is_granted_some_slave = peripheral_clock_crossing_m1_granted_ADC_data_pio_s1 |
    peripheral_clock_crossing_m1_granted_acq_busy_pio_s1 |
    peripheral_clock_crossing_m1_granted_led_pio_s1 |
    peripheral_clock_crossing_m1_granted_pb_pio_s1 |
    peripheral_clock_crossing_m1_granted_read_RAM_address_s1 |
    peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 |
    peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 |
    peripheral_clock_crossing_m1_granted_sw_pio_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_peripheral_clock_crossing_m1_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign peripheral_clock_crossing_m1_readdatavalid = peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_led_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1 |
    peripheral_clock_crossing_m1_read_but_no_slave_selected |
    pre_flush_peripheral_clock_crossing_m1_readdatavalid |
    peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1;

  //peripheral_clock_crossing/m1 readdata mux, which is an e_mux
  assign peripheral_clock_crossing_m1_readdata = ({32 {~(peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 & peripheral_clock_crossing_m1_read)}} | ADC_data_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 & peripheral_clock_crossing_m1_read)}} | acq_busy_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_led_pio_s1 & peripheral_clock_crossing_m1_read)}} | led_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 & peripheral_clock_crossing_m1_read)}} | pb_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 & peripheral_clock_crossing_m1_read)}} | read_RAM_address_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 & peripheral_clock_crossing_m1_read)}} | read_RAM_busy_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 & peripheral_clock_crossing_m1_read)}} | seven_seg_pio_s1_readdata_from_sa) &
    ({32 {~(peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 & peripheral_clock_crossing_m1_read)}} | sw_pio_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign peripheral_clock_crossing_m1_waitrequest = ~peripheral_clock_crossing_m1_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_latency_counter <= 0;
      else 
        peripheral_clock_crossing_m1_latency_counter <= p1_peripheral_clock_crossing_m1_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_peripheral_clock_crossing_m1_latency_counter = ((peripheral_clock_crossing_m1_run & peripheral_clock_crossing_m1_read))? latency_load_value :
    (peripheral_clock_crossing_m1_latency_counter)? peripheral_clock_crossing_m1_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //peripheral_clock_crossing_m1_reset_n assignment, which is an e_assign
  assign peripheral_clock_crossing_m1_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //peripheral_clock_crossing_m1_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_address_last_time <= 0;
      else 
        peripheral_clock_crossing_m1_address_last_time <= peripheral_clock_crossing_m1_address;
    end


  //peripheral_clock_crossing/m1 waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= peripheral_clock_crossing_m1_waitrequest & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write);
    end


  //peripheral_clock_crossing_m1_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (peripheral_clock_crossing_m1_address != peripheral_clock_crossing_m1_address_last_time))
        begin
          $write("%0d ns: peripheral_clock_crossing_m1_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //peripheral_clock_crossing_m1_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_byteenable_last_time <= 0;
      else 
        peripheral_clock_crossing_m1_byteenable_last_time <= peripheral_clock_crossing_m1_byteenable;
    end


  //peripheral_clock_crossing_m1_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (peripheral_clock_crossing_m1_byteenable != peripheral_clock_crossing_m1_byteenable_last_time))
        begin
          $write("%0d ns: peripheral_clock_crossing_m1_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //peripheral_clock_crossing_m1_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_read_last_time <= 0;
      else 
        peripheral_clock_crossing_m1_read_last_time <= peripheral_clock_crossing_m1_read;
    end


  //peripheral_clock_crossing_m1_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (peripheral_clock_crossing_m1_read != peripheral_clock_crossing_m1_read_last_time))
        begin
          $write("%0d ns: peripheral_clock_crossing_m1_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //peripheral_clock_crossing_m1_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_write_last_time <= 0;
      else 
        peripheral_clock_crossing_m1_write_last_time <= peripheral_clock_crossing_m1_write;
    end


  //peripheral_clock_crossing_m1_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (peripheral_clock_crossing_m1_write != peripheral_clock_crossing_m1_write_last_time))
        begin
          $write("%0d ns: peripheral_clock_crossing_m1_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //peripheral_clock_crossing_m1_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          peripheral_clock_crossing_m1_writedata_last_time <= 0;
      else 
        peripheral_clock_crossing_m1_writedata_last_time <= peripheral_clock_crossing_m1_writedata;
    end


  //peripheral_clock_crossing_m1_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (peripheral_clock_crossing_m1_writedata != peripheral_clock_crossing_m1_writedata_last_time) & peripheral_clock_crossing_m1_write)
        begin
          $write("%0d ns: peripheral_clock_crossing_m1_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module peripheral_clock_crossing_bridge_arbitrator 
;



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pll_s1_arbitrator (
                           // inputs:
                            DE4_SOPC_clock_0_out_address_to_slave,
                            DE4_SOPC_clock_0_out_nativeaddress,
                            DE4_SOPC_clock_0_out_read,
                            DE4_SOPC_clock_0_out_write,
                            DE4_SOPC_clock_0_out_writedata,
                            clk,
                            pll_s1_readdata,
                            pll_s1_resetrequest,
                            reset_n,

                           // outputs:
                            DE4_SOPC_clock_0_out_granted_pll_s1,
                            DE4_SOPC_clock_0_out_qualified_request_pll_s1,
                            DE4_SOPC_clock_0_out_read_data_valid_pll_s1,
                            DE4_SOPC_clock_0_out_requests_pll_s1,
                            d1_pll_s1_end_xfer,
                            pll_s1_address,
                            pll_s1_chipselect,
                            pll_s1_read,
                            pll_s1_readdata_from_sa,
                            pll_s1_reset_n,
                            pll_s1_resetrequest_from_sa,
                            pll_s1_write,
                            pll_s1_writedata
                         )
;

  output           DE4_SOPC_clock_0_out_granted_pll_s1;
  output           DE4_SOPC_clock_0_out_qualified_request_pll_s1;
  output           DE4_SOPC_clock_0_out_read_data_valid_pll_s1;
  output           DE4_SOPC_clock_0_out_requests_pll_s1;
  output           d1_pll_s1_end_xfer;
  output  [  2: 0] pll_s1_address;
  output           pll_s1_chipselect;
  output           pll_s1_read;
  output  [ 15: 0] pll_s1_readdata_from_sa;
  output           pll_s1_reset_n;
  output           pll_s1_resetrequest_from_sa;
  output           pll_s1_write;
  output  [ 15: 0] pll_s1_writedata;
  input   [  3: 0] DE4_SOPC_clock_0_out_address_to_slave;
  input   [  2: 0] DE4_SOPC_clock_0_out_nativeaddress;
  input            DE4_SOPC_clock_0_out_read;
  input            DE4_SOPC_clock_0_out_write;
  input   [ 15: 0] DE4_SOPC_clock_0_out_writedata;
  input            clk;
  input   [ 15: 0] pll_s1_readdata;
  input            pll_s1_resetrequest;
  input            reset_n;

  wire             DE4_SOPC_clock_0_out_arbiterlock;
  wire             DE4_SOPC_clock_0_out_arbiterlock2;
  wire             DE4_SOPC_clock_0_out_continuerequest;
  wire             DE4_SOPC_clock_0_out_granted_pll_s1;
  wire             DE4_SOPC_clock_0_out_qualified_request_pll_s1;
  wire             DE4_SOPC_clock_0_out_read_data_valid_pll_s1;
  wire             DE4_SOPC_clock_0_out_requests_pll_s1;
  wire             DE4_SOPC_clock_0_out_saved_grant_pll_s1;
  reg              d1_pll_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pll_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  2: 0] pll_s1_address;
  wire             pll_s1_allgrants;
  wire             pll_s1_allow_new_arb_cycle;
  wire             pll_s1_any_bursting_master_saved_grant;
  wire             pll_s1_any_continuerequest;
  wire             pll_s1_arb_counter_enable;
  reg              pll_s1_arb_share_counter;
  wire             pll_s1_arb_share_counter_next_value;
  wire             pll_s1_arb_share_set_values;
  wire             pll_s1_beginbursttransfer_internal;
  wire             pll_s1_begins_xfer;
  wire             pll_s1_chipselect;
  wire             pll_s1_end_xfer;
  wire             pll_s1_firsttransfer;
  wire             pll_s1_grant_vector;
  wire             pll_s1_in_a_read_cycle;
  wire             pll_s1_in_a_write_cycle;
  wire             pll_s1_master_qreq_vector;
  wire             pll_s1_non_bursting_master_requests;
  wire             pll_s1_read;
  wire    [ 15: 0] pll_s1_readdata_from_sa;
  reg              pll_s1_reg_firsttransfer;
  wire             pll_s1_reset_n;
  wire             pll_s1_resetrequest_from_sa;
  reg              pll_s1_slavearbiterlockenable;
  wire             pll_s1_slavearbiterlockenable2;
  wire             pll_s1_unreg_firsttransfer;
  wire             pll_s1_waits_for_read;
  wire             pll_s1_waits_for_write;
  wire             pll_s1_write;
  wire    [ 15: 0] pll_s1_writedata;
  wire             wait_for_pll_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pll_s1_end_xfer;
    end


  assign pll_s1_begins_xfer = ~d1_reasons_to_wait & ((DE4_SOPC_clock_0_out_qualified_request_pll_s1));
  //assign pll_s1_readdata_from_sa = pll_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pll_s1_readdata_from_sa = pll_s1_readdata;

  assign DE4_SOPC_clock_0_out_requests_pll_s1 = (1) & (DE4_SOPC_clock_0_out_read | DE4_SOPC_clock_0_out_write);
  //pll_s1_arb_share_counter set values, which is an e_mux
  assign pll_s1_arb_share_set_values = 1;

  //pll_s1_non_bursting_master_requests mux, which is an e_mux
  assign pll_s1_non_bursting_master_requests = DE4_SOPC_clock_0_out_requests_pll_s1;

  //pll_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign pll_s1_any_bursting_master_saved_grant = 0;

  //pll_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign pll_s1_arb_share_counter_next_value = pll_s1_firsttransfer ? (pll_s1_arb_share_set_values - 1) : |pll_s1_arb_share_counter ? (pll_s1_arb_share_counter - 1) : 0;

  //pll_s1_allgrants all slave grants, which is an e_mux
  assign pll_s1_allgrants = |pll_s1_grant_vector;

  //pll_s1_end_xfer assignment, which is an e_assign
  assign pll_s1_end_xfer = ~(pll_s1_waits_for_read | pll_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_pll_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pll_s1 = pll_s1_end_xfer & (~pll_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pll_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign pll_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_pll_s1 & pll_s1_allgrants) | (end_xfer_arb_share_counter_term_pll_s1 & ~pll_s1_non_bursting_master_requests);

  //pll_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_arb_share_counter <= 0;
      else if (pll_s1_arb_counter_enable)
          pll_s1_arb_share_counter <= pll_s1_arb_share_counter_next_value;
    end


  //pll_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_slavearbiterlockenable <= 0;
      else if ((|pll_s1_master_qreq_vector & end_xfer_arb_share_counter_term_pll_s1) | (end_xfer_arb_share_counter_term_pll_s1 & ~pll_s1_non_bursting_master_requests))
          pll_s1_slavearbiterlockenable <= |pll_s1_arb_share_counter_next_value;
    end


  //DE4_SOPC_clock_0/out pll/s1 arbiterlock, which is an e_assign
  assign DE4_SOPC_clock_0_out_arbiterlock = pll_s1_slavearbiterlockenable & DE4_SOPC_clock_0_out_continuerequest;

  //pll_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pll_s1_slavearbiterlockenable2 = |pll_s1_arb_share_counter_next_value;

  //DE4_SOPC_clock_0/out pll/s1 arbiterlock2, which is an e_assign
  assign DE4_SOPC_clock_0_out_arbiterlock2 = pll_s1_slavearbiterlockenable2 & DE4_SOPC_clock_0_out_continuerequest;

  //pll_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pll_s1_any_continuerequest = 1;

  //DE4_SOPC_clock_0_out_continuerequest continued request, which is an e_assign
  assign DE4_SOPC_clock_0_out_continuerequest = 1;

  assign DE4_SOPC_clock_0_out_qualified_request_pll_s1 = DE4_SOPC_clock_0_out_requests_pll_s1;
  //pll_s1_writedata mux, which is an e_mux
  assign pll_s1_writedata = DE4_SOPC_clock_0_out_writedata;

  //master is always granted when requested
  assign DE4_SOPC_clock_0_out_granted_pll_s1 = DE4_SOPC_clock_0_out_qualified_request_pll_s1;

  //DE4_SOPC_clock_0/out saved-grant pll/s1, which is an e_assign
  assign DE4_SOPC_clock_0_out_saved_grant_pll_s1 = DE4_SOPC_clock_0_out_requests_pll_s1;

  //allow new arb cycle for pll/s1, which is an e_assign
  assign pll_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pll_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pll_s1_master_qreq_vector = 1;

  //pll_s1_reset_n assignment, which is an e_assign
  assign pll_s1_reset_n = reset_n;

  //assign pll_s1_resetrequest_from_sa = pll_s1_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pll_s1_resetrequest_from_sa = pll_s1_resetrequest;

  assign pll_s1_chipselect = DE4_SOPC_clock_0_out_granted_pll_s1;
  //pll_s1_firsttransfer first transaction, which is an e_assign
  assign pll_s1_firsttransfer = pll_s1_begins_xfer ? pll_s1_unreg_firsttransfer : pll_s1_reg_firsttransfer;

  //pll_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign pll_s1_unreg_firsttransfer = ~(pll_s1_slavearbiterlockenable & pll_s1_any_continuerequest);

  //pll_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_reg_firsttransfer <= 1'b1;
      else if (pll_s1_begins_xfer)
          pll_s1_reg_firsttransfer <= pll_s1_unreg_firsttransfer;
    end


  //pll_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pll_s1_beginbursttransfer_internal = pll_s1_begins_xfer;

  //pll_s1_read assignment, which is an e_mux
  assign pll_s1_read = DE4_SOPC_clock_0_out_granted_pll_s1 & DE4_SOPC_clock_0_out_read;

  //pll_s1_write assignment, which is an e_mux
  assign pll_s1_write = DE4_SOPC_clock_0_out_granted_pll_s1 & DE4_SOPC_clock_0_out_write;

  //pll_s1_address mux, which is an e_mux
  assign pll_s1_address = DE4_SOPC_clock_0_out_nativeaddress;

  //d1_pll_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pll_s1_end_xfer <= 1;
      else 
        d1_pll_s1_end_xfer <= pll_s1_end_xfer;
    end


  //pll_s1_waits_for_read in a cycle, which is an e_mux
  assign pll_s1_waits_for_read = pll_s1_in_a_read_cycle & pll_s1_begins_xfer;

  //pll_s1_in_a_read_cycle assignment, which is an e_assign
  assign pll_s1_in_a_read_cycle = DE4_SOPC_clock_0_out_granted_pll_s1 & DE4_SOPC_clock_0_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pll_s1_in_a_read_cycle;

  //pll_s1_waits_for_write in a cycle, which is an e_mux
  assign pll_s1_waits_for_write = pll_s1_in_a_write_cycle & 0;

  //pll_s1_in_a_write_cycle assignment, which is an e_assign
  assign pll_s1_in_a_write_cycle = DE4_SOPC_clock_0_out_granted_pll_s1 & DE4_SOPC_clock_0_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pll_s1_in_a_write_cycle;

  assign wait_for_pll_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pll/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module read_RAM_address_s1_arbitrator (
                                        // inputs:
                                         clk,
                                         peripheral_clock_crossing_m1_address_to_slave,
                                         peripheral_clock_crossing_m1_latency_counter,
                                         peripheral_clock_crossing_m1_nativeaddress,
                                         peripheral_clock_crossing_m1_read,
                                         peripheral_clock_crossing_m1_write,
                                         peripheral_clock_crossing_m1_writedata,
                                         read_RAM_address_s1_readdata,
                                         reset_n,

                                        // outputs:
                                         d1_read_RAM_address_s1_end_xfer,
                                         peripheral_clock_crossing_m1_granted_read_RAM_address_s1,
                                         peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1,
                                         peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1,
                                         peripheral_clock_crossing_m1_requests_read_RAM_address_s1,
                                         read_RAM_address_s1_address,
                                         read_RAM_address_s1_chipselect,
                                         read_RAM_address_s1_readdata_from_sa,
                                         read_RAM_address_s1_reset_n,
                                         read_RAM_address_s1_write_n,
                                         read_RAM_address_s1_writedata
                                      )
;

  output           d1_read_RAM_address_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_read_RAM_address_s1;
  output           peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1;
  output           peripheral_clock_crossing_m1_requests_read_RAM_address_s1;
  output  [  1: 0] read_RAM_address_s1_address;
  output           read_RAM_address_s1_chipselect;
  output  [ 10: 0] read_RAM_address_s1_readdata_from_sa;
  output           read_RAM_address_s1_reset_n;
  output           read_RAM_address_s1_write_n;
  output  [ 10: 0] read_RAM_address_s1_writedata;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input   [ 31: 0] peripheral_clock_crossing_m1_writedata;
  input   [ 10: 0] read_RAM_address_s1_readdata;
  input            reset_n;

  reg              d1_read_RAM_address_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_read_RAM_address_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_requests_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_read_RAM_address_s1;
  wire    [  1: 0] read_RAM_address_s1_address;
  wire             read_RAM_address_s1_allgrants;
  wire             read_RAM_address_s1_allow_new_arb_cycle;
  wire             read_RAM_address_s1_any_bursting_master_saved_grant;
  wire             read_RAM_address_s1_any_continuerequest;
  wire             read_RAM_address_s1_arb_counter_enable;
  reg              read_RAM_address_s1_arb_share_counter;
  wire             read_RAM_address_s1_arb_share_counter_next_value;
  wire             read_RAM_address_s1_arb_share_set_values;
  wire             read_RAM_address_s1_beginbursttransfer_internal;
  wire             read_RAM_address_s1_begins_xfer;
  wire             read_RAM_address_s1_chipselect;
  wire             read_RAM_address_s1_end_xfer;
  wire             read_RAM_address_s1_firsttransfer;
  wire             read_RAM_address_s1_grant_vector;
  wire             read_RAM_address_s1_in_a_read_cycle;
  wire             read_RAM_address_s1_in_a_write_cycle;
  wire             read_RAM_address_s1_master_qreq_vector;
  wire             read_RAM_address_s1_non_bursting_master_requests;
  wire    [ 10: 0] read_RAM_address_s1_readdata_from_sa;
  reg              read_RAM_address_s1_reg_firsttransfer;
  wire             read_RAM_address_s1_reset_n;
  reg              read_RAM_address_s1_slavearbiterlockenable;
  wire             read_RAM_address_s1_slavearbiterlockenable2;
  wire             read_RAM_address_s1_unreg_firsttransfer;
  wire             read_RAM_address_s1_waits_for_read;
  wire             read_RAM_address_s1_waits_for_write;
  wire             read_RAM_address_s1_write_n;
  wire    [ 10: 0] read_RAM_address_s1_writedata;
  wire             wait_for_read_RAM_address_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~read_RAM_address_s1_end_xfer;
    end


  assign read_RAM_address_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1));
  //assign read_RAM_address_s1_readdata_from_sa = read_RAM_address_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign read_RAM_address_s1_readdata_from_sa = read_RAM_address_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_read_RAM_address_s1 = ({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h60) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write);
  //read_RAM_address_s1_arb_share_counter set values, which is an e_mux
  assign read_RAM_address_s1_arb_share_set_values = 1;

  //read_RAM_address_s1_non_bursting_master_requests mux, which is an e_mux
  assign read_RAM_address_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_read_RAM_address_s1;

  //read_RAM_address_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign read_RAM_address_s1_any_bursting_master_saved_grant = 0;

  //read_RAM_address_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign read_RAM_address_s1_arb_share_counter_next_value = read_RAM_address_s1_firsttransfer ? (read_RAM_address_s1_arb_share_set_values - 1) : |read_RAM_address_s1_arb_share_counter ? (read_RAM_address_s1_arb_share_counter - 1) : 0;

  //read_RAM_address_s1_allgrants all slave grants, which is an e_mux
  assign read_RAM_address_s1_allgrants = |read_RAM_address_s1_grant_vector;

  //read_RAM_address_s1_end_xfer assignment, which is an e_assign
  assign read_RAM_address_s1_end_xfer = ~(read_RAM_address_s1_waits_for_read | read_RAM_address_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_read_RAM_address_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_read_RAM_address_s1 = read_RAM_address_s1_end_xfer & (~read_RAM_address_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //read_RAM_address_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign read_RAM_address_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_read_RAM_address_s1 & read_RAM_address_s1_allgrants) | (end_xfer_arb_share_counter_term_read_RAM_address_s1 & ~read_RAM_address_s1_non_bursting_master_requests);

  //read_RAM_address_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_address_s1_arb_share_counter <= 0;
      else if (read_RAM_address_s1_arb_counter_enable)
          read_RAM_address_s1_arb_share_counter <= read_RAM_address_s1_arb_share_counter_next_value;
    end


  //read_RAM_address_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_address_s1_slavearbiterlockenable <= 0;
      else if ((|read_RAM_address_s1_master_qreq_vector & end_xfer_arb_share_counter_term_read_RAM_address_s1) | (end_xfer_arb_share_counter_term_read_RAM_address_s1 & ~read_RAM_address_s1_non_bursting_master_requests))
          read_RAM_address_s1_slavearbiterlockenable <= |read_RAM_address_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 read_RAM_address/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = read_RAM_address_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //read_RAM_address_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign read_RAM_address_s1_slavearbiterlockenable2 = |read_RAM_address_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 read_RAM_address/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = read_RAM_address_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //read_RAM_address_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign read_RAM_address_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 = peripheral_clock_crossing_m1_requests_read_RAM_address_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1 = peripheral_clock_crossing_m1_granted_read_RAM_address_s1 & peripheral_clock_crossing_m1_read & ~read_RAM_address_s1_waits_for_read;

  //read_RAM_address_s1_writedata mux, which is an e_mux
  assign read_RAM_address_s1_writedata = peripheral_clock_crossing_m1_writedata;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_read_RAM_address_s1 = peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1;

  //peripheral_clock_crossing/m1 saved-grant read_RAM_address/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_read_RAM_address_s1 = peripheral_clock_crossing_m1_requests_read_RAM_address_s1;

  //allow new arb cycle for read_RAM_address/s1, which is an e_assign
  assign read_RAM_address_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign read_RAM_address_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign read_RAM_address_s1_master_qreq_vector = 1;

  //read_RAM_address_s1_reset_n assignment, which is an e_assign
  assign read_RAM_address_s1_reset_n = reset_n;

  assign read_RAM_address_s1_chipselect = peripheral_clock_crossing_m1_granted_read_RAM_address_s1;
  //read_RAM_address_s1_firsttransfer first transaction, which is an e_assign
  assign read_RAM_address_s1_firsttransfer = read_RAM_address_s1_begins_xfer ? read_RAM_address_s1_unreg_firsttransfer : read_RAM_address_s1_reg_firsttransfer;

  //read_RAM_address_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign read_RAM_address_s1_unreg_firsttransfer = ~(read_RAM_address_s1_slavearbiterlockenable & read_RAM_address_s1_any_continuerequest);

  //read_RAM_address_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_address_s1_reg_firsttransfer <= 1'b1;
      else if (read_RAM_address_s1_begins_xfer)
          read_RAM_address_s1_reg_firsttransfer <= read_RAM_address_s1_unreg_firsttransfer;
    end


  //read_RAM_address_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign read_RAM_address_s1_beginbursttransfer_internal = read_RAM_address_s1_begins_xfer;

  //~read_RAM_address_s1_write_n assignment, which is an e_mux
  assign read_RAM_address_s1_write_n = ~(peripheral_clock_crossing_m1_granted_read_RAM_address_s1 & peripheral_clock_crossing_m1_write);

  //read_RAM_address_s1_address mux, which is an e_mux
  assign read_RAM_address_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_read_RAM_address_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_read_RAM_address_s1_end_xfer <= 1;
      else 
        d1_read_RAM_address_s1_end_xfer <= read_RAM_address_s1_end_xfer;
    end


  //read_RAM_address_s1_waits_for_read in a cycle, which is an e_mux
  assign read_RAM_address_s1_waits_for_read = read_RAM_address_s1_in_a_read_cycle & read_RAM_address_s1_begins_xfer;

  //read_RAM_address_s1_in_a_read_cycle assignment, which is an e_assign
  assign read_RAM_address_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_read_RAM_address_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = read_RAM_address_s1_in_a_read_cycle;

  //read_RAM_address_s1_waits_for_write in a cycle, which is an e_mux
  assign read_RAM_address_s1_waits_for_write = read_RAM_address_s1_in_a_write_cycle & 0;

  //read_RAM_address_s1_in_a_write_cycle assignment, which is an e_assign
  assign read_RAM_address_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_read_RAM_address_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = read_RAM_address_s1_in_a_write_cycle;

  assign wait_for_read_RAM_address_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //read_RAM_address/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module read_RAM_busy_pio_s1_arbitrator (
                                         // inputs:
                                          clk,
                                          peripheral_clock_crossing_m1_address_to_slave,
                                          peripheral_clock_crossing_m1_latency_counter,
                                          peripheral_clock_crossing_m1_nativeaddress,
                                          peripheral_clock_crossing_m1_read,
                                          peripheral_clock_crossing_m1_write,
                                          peripheral_clock_crossing_m1_writedata,
                                          read_RAM_busy_pio_s1_readdata,
                                          reset_n,

                                         // outputs:
                                          d1_read_RAM_busy_pio_s1_end_xfer,
                                          peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1,
                                          peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1,
                                          peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1,
                                          peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1,
                                          read_RAM_busy_pio_s1_address,
                                          read_RAM_busy_pio_s1_chipselect,
                                          read_RAM_busy_pio_s1_readdata_from_sa,
                                          read_RAM_busy_pio_s1_reset_n,
                                          read_RAM_busy_pio_s1_write_n,
                                          read_RAM_busy_pio_s1_writedata
                                       )
;

  output           d1_read_RAM_busy_pio_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1;
  output           peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;
  output  [  1: 0] read_RAM_busy_pio_s1_address;
  output           read_RAM_busy_pio_s1_chipselect;
  output           read_RAM_busy_pio_s1_readdata_from_sa;
  output           read_RAM_busy_pio_s1_reset_n;
  output           read_RAM_busy_pio_s1_write_n;
  output           read_RAM_busy_pio_s1_writedata;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input   [ 31: 0] peripheral_clock_crossing_m1_writedata;
  input            read_RAM_busy_pio_s1_readdata;
  input            reset_n;

  reg              d1_read_RAM_busy_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_read_RAM_busy_pio_s1;
  wire    [  1: 0] read_RAM_busy_pio_s1_address;
  wire             read_RAM_busy_pio_s1_allgrants;
  wire             read_RAM_busy_pio_s1_allow_new_arb_cycle;
  wire             read_RAM_busy_pio_s1_any_bursting_master_saved_grant;
  wire             read_RAM_busy_pio_s1_any_continuerequest;
  wire             read_RAM_busy_pio_s1_arb_counter_enable;
  reg              read_RAM_busy_pio_s1_arb_share_counter;
  wire             read_RAM_busy_pio_s1_arb_share_counter_next_value;
  wire             read_RAM_busy_pio_s1_arb_share_set_values;
  wire             read_RAM_busy_pio_s1_beginbursttransfer_internal;
  wire             read_RAM_busy_pio_s1_begins_xfer;
  wire             read_RAM_busy_pio_s1_chipselect;
  wire             read_RAM_busy_pio_s1_end_xfer;
  wire             read_RAM_busy_pio_s1_firsttransfer;
  wire             read_RAM_busy_pio_s1_grant_vector;
  wire             read_RAM_busy_pio_s1_in_a_read_cycle;
  wire             read_RAM_busy_pio_s1_in_a_write_cycle;
  wire             read_RAM_busy_pio_s1_master_qreq_vector;
  wire             read_RAM_busy_pio_s1_non_bursting_master_requests;
  wire             read_RAM_busy_pio_s1_readdata_from_sa;
  reg              read_RAM_busy_pio_s1_reg_firsttransfer;
  wire             read_RAM_busy_pio_s1_reset_n;
  reg              read_RAM_busy_pio_s1_slavearbiterlockenable;
  wire             read_RAM_busy_pio_s1_slavearbiterlockenable2;
  wire             read_RAM_busy_pio_s1_unreg_firsttransfer;
  wire             read_RAM_busy_pio_s1_waits_for_read;
  wire             read_RAM_busy_pio_s1_waits_for_write;
  wire             read_RAM_busy_pio_s1_write_n;
  wire             read_RAM_busy_pio_s1_writedata;
  wire             wait_for_read_RAM_busy_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~read_RAM_busy_pio_s1_end_xfer;
    end


  assign read_RAM_busy_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1));
  //assign read_RAM_busy_pio_s1_readdata_from_sa = read_RAM_busy_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign read_RAM_busy_pio_s1_readdata_from_sa = read_RAM_busy_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1 = ({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h70) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write);
  //read_RAM_busy_pio_s1_arb_share_counter set values, which is an e_mux
  assign read_RAM_busy_pio_s1_arb_share_set_values = 1;

  //read_RAM_busy_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign read_RAM_busy_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;

  //read_RAM_busy_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign read_RAM_busy_pio_s1_any_bursting_master_saved_grant = 0;

  //read_RAM_busy_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign read_RAM_busy_pio_s1_arb_share_counter_next_value = read_RAM_busy_pio_s1_firsttransfer ? (read_RAM_busy_pio_s1_arb_share_set_values - 1) : |read_RAM_busy_pio_s1_arb_share_counter ? (read_RAM_busy_pio_s1_arb_share_counter - 1) : 0;

  //read_RAM_busy_pio_s1_allgrants all slave grants, which is an e_mux
  assign read_RAM_busy_pio_s1_allgrants = |read_RAM_busy_pio_s1_grant_vector;

  //read_RAM_busy_pio_s1_end_xfer assignment, which is an e_assign
  assign read_RAM_busy_pio_s1_end_xfer = ~(read_RAM_busy_pio_s1_waits_for_read | read_RAM_busy_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1 = read_RAM_busy_pio_s1_end_xfer & (~read_RAM_busy_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //read_RAM_busy_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign read_RAM_busy_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1 & read_RAM_busy_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1 & ~read_RAM_busy_pio_s1_non_bursting_master_requests);

  //read_RAM_busy_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_busy_pio_s1_arb_share_counter <= 0;
      else if (read_RAM_busy_pio_s1_arb_counter_enable)
          read_RAM_busy_pio_s1_arb_share_counter <= read_RAM_busy_pio_s1_arb_share_counter_next_value;
    end


  //read_RAM_busy_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_busy_pio_s1_slavearbiterlockenable <= 0;
      else if ((|read_RAM_busy_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1) | (end_xfer_arb_share_counter_term_read_RAM_busy_pio_s1 & ~read_RAM_busy_pio_s1_non_bursting_master_requests))
          read_RAM_busy_pio_s1_slavearbiterlockenable <= |read_RAM_busy_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 read_RAM_busy_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = read_RAM_busy_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //read_RAM_busy_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign read_RAM_busy_pio_s1_slavearbiterlockenable2 = |read_RAM_busy_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 read_RAM_busy_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = read_RAM_busy_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //read_RAM_busy_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign read_RAM_busy_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 = peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1 = peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 & peripheral_clock_crossing_m1_read & ~read_RAM_busy_pio_s1_waits_for_read;

  //read_RAM_busy_pio_s1_writedata mux, which is an e_mux
  assign read_RAM_busy_pio_s1_writedata = peripheral_clock_crossing_m1_writedata;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 = peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant read_RAM_busy_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_read_RAM_busy_pio_s1 = peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;

  //allow new arb cycle for read_RAM_busy_pio/s1, which is an e_assign
  assign read_RAM_busy_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign read_RAM_busy_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign read_RAM_busy_pio_s1_master_qreq_vector = 1;

  //read_RAM_busy_pio_s1_reset_n assignment, which is an e_assign
  assign read_RAM_busy_pio_s1_reset_n = reset_n;

  assign read_RAM_busy_pio_s1_chipselect = peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1;
  //read_RAM_busy_pio_s1_firsttransfer first transaction, which is an e_assign
  assign read_RAM_busy_pio_s1_firsttransfer = read_RAM_busy_pio_s1_begins_xfer ? read_RAM_busy_pio_s1_unreg_firsttransfer : read_RAM_busy_pio_s1_reg_firsttransfer;

  //read_RAM_busy_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign read_RAM_busy_pio_s1_unreg_firsttransfer = ~(read_RAM_busy_pio_s1_slavearbiterlockenable & read_RAM_busy_pio_s1_any_continuerequest);

  //read_RAM_busy_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_RAM_busy_pio_s1_reg_firsttransfer <= 1'b1;
      else if (read_RAM_busy_pio_s1_begins_xfer)
          read_RAM_busy_pio_s1_reg_firsttransfer <= read_RAM_busy_pio_s1_unreg_firsttransfer;
    end


  //read_RAM_busy_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign read_RAM_busy_pio_s1_beginbursttransfer_internal = read_RAM_busy_pio_s1_begins_xfer;

  //~read_RAM_busy_pio_s1_write_n assignment, which is an e_mux
  assign read_RAM_busy_pio_s1_write_n = ~(peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 & peripheral_clock_crossing_m1_write);

  //read_RAM_busy_pio_s1_address mux, which is an e_mux
  assign read_RAM_busy_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_read_RAM_busy_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_read_RAM_busy_pio_s1_end_xfer <= 1;
      else 
        d1_read_RAM_busy_pio_s1_end_xfer <= read_RAM_busy_pio_s1_end_xfer;
    end


  //read_RAM_busy_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign read_RAM_busy_pio_s1_waits_for_read = read_RAM_busy_pio_s1_in_a_read_cycle & read_RAM_busy_pio_s1_begins_xfer;

  //read_RAM_busy_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign read_RAM_busy_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = read_RAM_busy_pio_s1_in_a_read_cycle;

  //read_RAM_busy_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign read_RAM_busy_pio_s1_waits_for_write = read_RAM_busy_pio_s1_in_a_write_cycle & 0;

  //read_RAM_busy_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign read_RAM_busy_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = read_RAM_busy_pio_s1_in_a_write_cycle;

  assign wait_for_read_RAM_busy_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //read_RAM_busy_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module seven_seg_pio_s1_arbitrator (
                                     // inputs:
                                      clk,
                                      peripheral_clock_crossing_m1_address_to_slave,
                                      peripheral_clock_crossing_m1_latency_counter,
                                      peripheral_clock_crossing_m1_nativeaddress,
                                      peripheral_clock_crossing_m1_read,
                                      peripheral_clock_crossing_m1_write,
                                      peripheral_clock_crossing_m1_writedata,
                                      reset_n,
                                      seven_seg_pio_s1_readdata,

                                     // outputs:
                                      d1_seven_seg_pio_s1_end_xfer,
                                      peripheral_clock_crossing_m1_granted_seven_seg_pio_s1,
                                      peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1,
                                      peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1,
                                      peripheral_clock_crossing_m1_requests_seven_seg_pio_s1,
                                      seven_seg_pio_s1_address,
                                      seven_seg_pio_s1_chipselect,
                                      seven_seg_pio_s1_readdata_from_sa,
                                      seven_seg_pio_s1_reset_n,
                                      seven_seg_pio_s1_write_n,
                                      seven_seg_pio_s1_writedata
                                   )
;

  output           d1_seven_seg_pio_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_seven_seg_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1;
  output           peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;
  output  [  1: 0] seven_seg_pio_s1_address;
  output           seven_seg_pio_s1_chipselect;
  output  [ 15: 0] seven_seg_pio_s1_readdata_from_sa;
  output           seven_seg_pio_s1_reset_n;
  output           seven_seg_pio_s1_write_n;
  output  [ 15: 0] seven_seg_pio_s1_writedata;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input   [ 31: 0] peripheral_clock_crossing_m1_writedata;
  input            reset_n;
  input   [ 15: 0] seven_seg_pio_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_seven_seg_pio_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_seven_seg_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_seven_seg_pio_s1;
  wire    [  1: 0] seven_seg_pio_s1_address;
  wire             seven_seg_pio_s1_allgrants;
  wire             seven_seg_pio_s1_allow_new_arb_cycle;
  wire             seven_seg_pio_s1_any_bursting_master_saved_grant;
  wire             seven_seg_pio_s1_any_continuerequest;
  wire             seven_seg_pio_s1_arb_counter_enable;
  reg              seven_seg_pio_s1_arb_share_counter;
  wire             seven_seg_pio_s1_arb_share_counter_next_value;
  wire             seven_seg_pio_s1_arb_share_set_values;
  wire             seven_seg_pio_s1_beginbursttransfer_internal;
  wire             seven_seg_pio_s1_begins_xfer;
  wire             seven_seg_pio_s1_chipselect;
  wire             seven_seg_pio_s1_end_xfer;
  wire             seven_seg_pio_s1_firsttransfer;
  wire             seven_seg_pio_s1_grant_vector;
  wire             seven_seg_pio_s1_in_a_read_cycle;
  wire             seven_seg_pio_s1_in_a_write_cycle;
  wire             seven_seg_pio_s1_master_qreq_vector;
  wire             seven_seg_pio_s1_non_bursting_master_requests;
  wire    [ 15: 0] seven_seg_pio_s1_readdata_from_sa;
  reg              seven_seg_pio_s1_reg_firsttransfer;
  wire             seven_seg_pio_s1_reset_n;
  reg              seven_seg_pio_s1_slavearbiterlockenable;
  wire             seven_seg_pio_s1_slavearbiterlockenable2;
  wire             seven_seg_pio_s1_unreg_firsttransfer;
  wire             seven_seg_pio_s1_waits_for_read;
  wire             seven_seg_pio_s1_waits_for_write;
  wire             seven_seg_pio_s1_write_n;
  wire    [ 15: 0] seven_seg_pio_s1_writedata;
  wire             wait_for_seven_seg_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~seven_seg_pio_s1_end_xfer;
    end


  assign seven_seg_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1));
  //assign seven_seg_pio_s1_readdata_from_sa = seven_seg_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign seven_seg_pio_s1_readdata_from_sa = seven_seg_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_seven_seg_pio_s1 = ({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h30) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write);
  //seven_seg_pio_s1_arb_share_counter set values, which is an e_mux
  assign seven_seg_pio_s1_arb_share_set_values = 1;

  //seven_seg_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign seven_seg_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;

  //seven_seg_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign seven_seg_pio_s1_any_bursting_master_saved_grant = 0;

  //seven_seg_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign seven_seg_pio_s1_arb_share_counter_next_value = seven_seg_pio_s1_firsttransfer ? (seven_seg_pio_s1_arb_share_set_values - 1) : |seven_seg_pio_s1_arb_share_counter ? (seven_seg_pio_s1_arb_share_counter - 1) : 0;

  //seven_seg_pio_s1_allgrants all slave grants, which is an e_mux
  assign seven_seg_pio_s1_allgrants = |seven_seg_pio_s1_grant_vector;

  //seven_seg_pio_s1_end_xfer assignment, which is an e_assign
  assign seven_seg_pio_s1_end_xfer = ~(seven_seg_pio_s1_waits_for_read | seven_seg_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_seven_seg_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_seven_seg_pio_s1 = seven_seg_pio_s1_end_xfer & (~seven_seg_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //seven_seg_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign seven_seg_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_seven_seg_pio_s1 & seven_seg_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_seven_seg_pio_s1 & ~seven_seg_pio_s1_non_bursting_master_requests);

  //seven_seg_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_pio_s1_arb_share_counter <= 0;
      else if (seven_seg_pio_s1_arb_counter_enable)
          seven_seg_pio_s1_arb_share_counter <= seven_seg_pio_s1_arb_share_counter_next_value;
    end


  //seven_seg_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_pio_s1_slavearbiterlockenable <= 0;
      else if ((|seven_seg_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_seven_seg_pio_s1) | (end_xfer_arb_share_counter_term_seven_seg_pio_s1 & ~seven_seg_pio_s1_non_bursting_master_requests))
          seven_seg_pio_s1_slavearbiterlockenable <= |seven_seg_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 seven_seg_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = seven_seg_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //seven_seg_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign seven_seg_pio_s1_slavearbiterlockenable2 = |seven_seg_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 seven_seg_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = seven_seg_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //seven_seg_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign seven_seg_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 = peripheral_clock_crossing_m1_requests_seven_seg_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1 = peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 & peripheral_clock_crossing_m1_read & ~seven_seg_pio_s1_waits_for_read;

  //seven_seg_pio_s1_writedata mux, which is an e_mux
  assign seven_seg_pio_s1_writedata = peripheral_clock_crossing_m1_writedata;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 = peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant seven_seg_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_seven_seg_pio_s1 = peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;

  //allow new arb cycle for seven_seg_pio/s1, which is an e_assign
  assign seven_seg_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign seven_seg_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign seven_seg_pio_s1_master_qreq_vector = 1;

  //seven_seg_pio_s1_reset_n assignment, which is an e_assign
  assign seven_seg_pio_s1_reset_n = reset_n;

  assign seven_seg_pio_s1_chipselect = peripheral_clock_crossing_m1_granted_seven_seg_pio_s1;
  //seven_seg_pio_s1_firsttransfer first transaction, which is an e_assign
  assign seven_seg_pio_s1_firsttransfer = seven_seg_pio_s1_begins_xfer ? seven_seg_pio_s1_unreg_firsttransfer : seven_seg_pio_s1_reg_firsttransfer;

  //seven_seg_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign seven_seg_pio_s1_unreg_firsttransfer = ~(seven_seg_pio_s1_slavearbiterlockenable & seven_seg_pio_s1_any_continuerequest);

  //seven_seg_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          seven_seg_pio_s1_reg_firsttransfer <= 1'b1;
      else if (seven_seg_pio_s1_begins_xfer)
          seven_seg_pio_s1_reg_firsttransfer <= seven_seg_pio_s1_unreg_firsttransfer;
    end


  //seven_seg_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign seven_seg_pio_s1_beginbursttransfer_internal = seven_seg_pio_s1_begins_xfer;

  //~seven_seg_pio_s1_write_n assignment, which is an e_mux
  assign seven_seg_pio_s1_write_n = ~(peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 & peripheral_clock_crossing_m1_write);

  //seven_seg_pio_s1_address mux, which is an e_mux
  assign seven_seg_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_seven_seg_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_seven_seg_pio_s1_end_xfer <= 1;
      else 
        d1_seven_seg_pio_s1_end_xfer <= seven_seg_pio_s1_end_xfer;
    end


  //seven_seg_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign seven_seg_pio_s1_waits_for_read = seven_seg_pio_s1_in_a_read_cycle & seven_seg_pio_s1_begins_xfer;

  //seven_seg_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign seven_seg_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = seven_seg_pio_s1_in_a_read_cycle;

  //seven_seg_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign seven_seg_pio_s1_waits_for_write = seven_seg_pio_s1_in_a_write_cycle & 0;

  //seven_seg_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign seven_seg_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_seven_seg_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = seven_seg_pio_s1_in_a_write_cycle;

  assign wait_for_seven_seg_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //seven_seg_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_csr_arbitrator (
                                 // inputs:
                                  clk,
                                  cpu_data_master_address_to_slave,
                                  cpu_data_master_latency_counter,
                                  cpu_data_master_read,
                                  cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                  cpu_data_master_write,
                                  cpu_data_master_writedata,
                                  reset_n,
                                  sgdma_rx_csr_irq,
                                  sgdma_rx_csr_readdata,

                                 // outputs:
                                  cpu_data_master_granted_sgdma_rx_csr,
                                  cpu_data_master_qualified_request_sgdma_rx_csr,
                                  cpu_data_master_read_data_valid_sgdma_rx_csr,
                                  cpu_data_master_requests_sgdma_rx_csr,
                                  d1_sgdma_rx_csr_end_xfer,
                                  sgdma_rx_csr_address,
                                  sgdma_rx_csr_chipselect,
                                  sgdma_rx_csr_irq_from_sa,
                                  sgdma_rx_csr_read,
                                  sgdma_rx_csr_readdata_from_sa,
                                  sgdma_rx_csr_reset_n,
                                  sgdma_rx_csr_write,
                                  sgdma_rx_csr_writedata
                               )
;

  output           cpu_data_master_granted_sgdma_rx_csr;
  output           cpu_data_master_qualified_request_sgdma_rx_csr;
  output           cpu_data_master_read_data_valid_sgdma_rx_csr;
  output           cpu_data_master_requests_sgdma_rx_csr;
  output           d1_sgdma_rx_csr_end_xfer;
  output  [  3: 0] sgdma_rx_csr_address;
  output           sgdma_rx_csr_chipselect;
  output           sgdma_rx_csr_irq_from_sa;
  output           sgdma_rx_csr_read;
  output  [ 31: 0] sgdma_rx_csr_readdata_from_sa;
  output           sgdma_rx_csr_reset_n;
  output           sgdma_rx_csr_write;
  output  [ 31: 0] sgdma_rx_csr_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;
  input            sgdma_rx_csr_irq;
  input   [ 31: 0] sgdma_rx_csr_readdata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sgdma_rx_csr;
  wire             cpu_data_master_qualified_request_sgdma_rx_csr;
  wire             cpu_data_master_read_data_valid_sgdma_rx_csr;
  wire             cpu_data_master_requests_sgdma_rx_csr;
  wire             cpu_data_master_saved_grant_sgdma_rx_csr;
  reg              d1_reasons_to_wait;
  reg              d1_sgdma_rx_csr_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sgdma_rx_csr;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  3: 0] sgdma_rx_csr_address;
  wire             sgdma_rx_csr_allgrants;
  wire             sgdma_rx_csr_allow_new_arb_cycle;
  wire             sgdma_rx_csr_any_bursting_master_saved_grant;
  wire             sgdma_rx_csr_any_continuerequest;
  wire             sgdma_rx_csr_arb_counter_enable;
  reg     [  1: 0] sgdma_rx_csr_arb_share_counter;
  wire    [  1: 0] sgdma_rx_csr_arb_share_counter_next_value;
  wire    [  1: 0] sgdma_rx_csr_arb_share_set_values;
  wire             sgdma_rx_csr_beginbursttransfer_internal;
  wire             sgdma_rx_csr_begins_xfer;
  wire             sgdma_rx_csr_chipselect;
  wire             sgdma_rx_csr_end_xfer;
  wire             sgdma_rx_csr_firsttransfer;
  wire             sgdma_rx_csr_grant_vector;
  wire             sgdma_rx_csr_in_a_read_cycle;
  wire             sgdma_rx_csr_in_a_write_cycle;
  wire             sgdma_rx_csr_irq_from_sa;
  wire             sgdma_rx_csr_master_qreq_vector;
  wire             sgdma_rx_csr_non_bursting_master_requests;
  wire             sgdma_rx_csr_read;
  wire    [ 31: 0] sgdma_rx_csr_readdata_from_sa;
  reg              sgdma_rx_csr_reg_firsttransfer;
  wire             sgdma_rx_csr_reset_n;
  reg              sgdma_rx_csr_slavearbiterlockenable;
  wire             sgdma_rx_csr_slavearbiterlockenable2;
  wire             sgdma_rx_csr_unreg_firsttransfer;
  wire             sgdma_rx_csr_waits_for_read;
  wire             sgdma_rx_csr_waits_for_write;
  wire             sgdma_rx_csr_write;
  wire    [ 31: 0] sgdma_rx_csr_writedata;
  wire    [ 26: 0] shifted_address_to_sgdma_rx_csr_from_cpu_data_master;
  wire             wait_for_sgdma_rx_csr_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sgdma_rx_csr_end_xfer;
    end


  assign sgdma_rx_csr_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_sgdma_rx_csr));
  //assign sgdma_rx_csr_readdata_from_sa = sgdma_rx_csr_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sgdma_rx_csr_readdata_from_sa = sgdma_rx_csr_readdata;

  assign cpu_data_master_requests_sgdma_rx_csr = ({cpu_data_master_address_to_slave[26 : 6] , 6'b0} == 27'h5201c40) & (cpu_data_master_read | cpu_data_master_write);
  //sgdma_rx_csr_arb_share_counter set values, which is an e_mux
  assign sgdma_rx_csr_arb_share_set_values = 1;

  //sgdma_rx_csr_non_bursting_master_requests mux, which is an e_mux
  assign sgdma_rx_csr_non_bursting_master_requests = cpu_data_master_requests_sgdma_rx_csr;

  //sgdma_rx_csr_any_bursting_master_saved_grant mux, which is an e_mux
  assign sgdma_rx_csr_any_bursting_master_saved_grant = 0;

  //sgdma_rx_csr_arb_share_counter_next_value assignment, which is an e_assign
  assign sgdma_rx_csr_arb_share_counter_next_value = sgdma_rx_csr_firsttransfer ? (sgdma_rx_csr_arb_share_set_values - 1) : |sgdma_rx_csr_arb_share_counter ? (sgdma_rx_csr_arb_share_counter - 1) : 0;

  //sgdma_rx_csr_allgrants all slave grants, which is an e_mux
  assign sgdma_rx_csr_allgrants = |sgdma_rx_csr_grant_vector;

  //sgdma_rx_csr_end_xfer assignment, which is an e_assign
  assign sgdma_rx_csr_end_xfer = ~(sgdma_rx_csr_waits_for_read | sgdma_rx_csr_waits_for_write);

  //end_xfer_arb_share_counter_term_sgdma_rx_csr arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sgdma_rx_csr = sgdma_rx_csr_end_xfer & (~sgdma_rx_csr_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sgdma_rx_csr_arb_share_counter arbitration counter enable, which is an e_assign
  assign sgdma_rx_csr_arb_counter_enable = (end_xfer_arb_share_counter_term_sgdma_rx_csr & sgdma_rx_csr_allgrants) | (end_xfer_arb_share_counter_term_sgdma_rx_csr & ~sgdma_rx_csr_non_bursting_master_requests);

  //sgdma_rx_csr_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_csr_arb_share_counter <= 0;
      else if (sgdma_rx_csr_arb_counter_enable)
          sgdma_rx_csr_arb_share_counter <= sgdma_rx_csr_arb_share_counter_next_value;
    end


  //sgdma_rx_csr_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_csr_slavearbiterlockenable <= 0;
      else if ((|sgdma_rx_csr_master_qreq_vector & end_xfer_arb_share_counter_term_sgdma_rx_csr) | (end_xfer_arb_share_counter_term_sgdma_rx_csr & ~sgdma_rx_csr_non_bursting_master_requests))
          sgdma_rx_csr_slavearbiterlockenable <= |sgdma_rx_csr_arb_share_counter_next_value;
    end


  //cpu/data_master sgdma_rx/csr arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sgdma_rx_csr_slavearbiterlockenable & cpu_data_master_continuerequest;

  //sgdma_rx_csr_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sgdma_rx_csr_slavearbiterlockenable2 = |sgdma_rx_csr_arb_share_counter_next_value;

  //cpu/data_master sgdma_rx/csr arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sgdma_rx_csr_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sgdma_rx_csr_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sgdma_rx_csr_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_sgdma_rx_csr = cpu_data_master_requests_sgdma_rx_csr & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_sgdma_rx_csr, which is an e_mux
  assign cpu_data_master_read_data_valid_sgdma_rx_csr = cpu_data_master_granted_sgdma_rx_csr & cpu_data_master_read & ~sgdma_rx_csr_waits_for_read;

  //sgdma_rx_csr_writedata mux, which is an e_mux
  assign sgdma_rx_csr_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_sgdma_rx_csr = cpu_data_master_qualified_request_sgdma_rx_csr;

  //cpu/data_master saved-grant sgdma_rx/csr, which is an e_assign
  assign cpu_data_master_saved_grant_sgdma_rx_csr = cpu_data_master_requests_sgdma_rx_csr;

  //allow new arb cycle for sgdma_rx/csr, which is an e_assign
  assign sgdma_rx_csr_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sgdma_rx_csr_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sgdma_rx_csr_master_qreq_vector = 1;

  //sgdma_rx_csr_reset_n assignment, which is an e_assign
  assign sgdma_rx_csr_reset_n = reset_n;

  assign sgdma_rx_csr_chipselect = cpu_data_master_granted_sgdma_rx_csr;
  //sgdma_rx_csr_firsttransfer first transaction, which is an e_assign
  assign sgdma_rx_csr_firsttransfer = sgdma_rx_csr_begins_xfer ? sgdma_rx_csr_unreg_firsttransfer : sgdma_rx_csr_reg_firsttransfer;

  //sgdma_rx_csr_unreg_firsttransfer first transaction, which is an e_assign
  assign sgdma_rx_csr_unreg_firsttransfer = ~(sgdma_rx_csr_slavearbiterlockenable & sgdma_rx_csr_any_continuerequest);

  //sgdma_rx_csr_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_csr_reg_firsttransfer <= 1'b1;
      else if (sgdma_rx_csr_begins_xfer)
          sgdma_rx_csr_reg_firsttransfer <= sgdma_rx_csr_unreg_firsttransfer;
    end


  //sgdma_rx_csr_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sgdma_rx_csr_beginbursttransfer_internal = sgdma_rx_csr_begins_xfer;

  //sgdma_rx_csr_read assignment, which is an e_mux
  assign sgdma_rx_csr_read = cpu_data_master_granted_sgdma_rx_csr & cpu_data_master_read;

  //sgdma_rx_csr_write assignment, which is an e_mux
  assign sgdma_rx_csr_write = cpu_data_master_granted_sgdma_rx_csr & cpu_data_master_write;

  assign shifted_address_to_sgdma_rx_csr_from_cpu_data_master = cpu_data_master_address_to_slave;
  //sgdma_rx_csr_address mux, which is an e_mux
  assign sgdma_rx_csr_address = shifted_address_to_sgdma_rx_csr_from_cpu_data_master >> 2;

  //d1_sgdma_rx_csr_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sgdma_rx_csr_end_xfer <= 1;
      else 
        d1_sgdma_rx_csr_end_xfer <= sgdma_rx_csr_end_xfer;
    end


  //sgdma_rx_csr_waits_for_read in a cycle, which is an e_mux
  assign sgdma_rx_csr_waits_for_read = sgdma_rx_csr_in_a_read_cycle & sgdma_rx_csr_begins_xfer;

  //sgdma_rx_csr_in_a_read_cycle assignment, which is an e_assign
  assign sgdma_rx_csr_in_a_read_cycle = cpu_data_master_granted_sgdma_rx_csr & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sgdma_rx_csr_in_a_read_cycle;

  //sgdma_rx_csr_waits_for_write in a cycle, which is an e_mux
  assign sgdma_rx_csr_waits_for_write = sgdma_rx_csr_in_a_write_cycle & 0;

  //sgdma_rx_csr_in_a_write_cycle assignment, which is an e_assign
  assign sgdma_rx_csr_in_a_write_cycle = cpu_data_master_granted_sgdma_rx_csr & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sgdma_rx_csr_in_a_write_cycle;

  assign wait_for_sgdma_rx_csr_counter = 0;
  //assign sgdma_rx_csr_irq_from_sa = sgdma_rx_csr_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sgdma_rx_csr_irq_from_sa = sgdma_rx_csr_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_rx/csr enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_in_arbitrator (
                                // inputs:
                                 clk,
                                 reset_n,
                                 sgdma_rx_in_ready,
                                 tse_mac_receive_data,
                                 tse_mac_receive_empty,
                                 tse_mac_receive_endofpacket,
                                 tse_mac_receive_error,
                                 tse_mac_receive_startofpacket,
                                 tse_mac_receive_valid,

                                // outputs:
                                 sgdma_rx_in_data,
                                 sgdma_rx_in_empty,
                                 sgdma_rx_in_endofpacket,
                                 sgdma_rx_in_error,
                                 sgdma_rx_in_ready_from_sa,
                                 sgdma_rx_in_startofpacket,
                                 sgdma_rx_in_valid
                              )
;

  output  [ 31: 0] sgdma_rx_in_data;
  output  [  3: 0] sgdma_rx_in_empty;
  output           sgdma_rx_in_endofpacket;
  output  [  5: 0] sgdma_rx_in_error;
  output           sgdma_rx_in_ready_from_sa;
  output           sgdma_rx_in_startofpacket;
  output           sgdma_rx_in_valid;
  input            clk;
  input            reset_n;
  input            sgdma_rx_in_ready;
  input   [ 31: 0] tse_mac_receive_data;
  input   [  1: 0] tse_mac_receive_empty;
  input            tse_mac_receive_endofpacket;
  input   [  5: 0] tse_mac_receive_error;
  input            tse_mac_receive_startofpacket;
  input            tse_mac_receive_valid;

  wire    [ 31: 0] sgdma_rx_in_data;
  wire    [  3: 0] sgdma_rx_in_empty;
  wire             sgdma_rx_in_endofpacket;
  wire    [  5: 0] sgdma_rx_in_error;
  wire             sgdma_rx_in_ready_from_sa;
  wire             sgdma_rx_in_startofpacket;
  wire             sgdma_rx_in_valid;
  //mux sgdma_rx_in_data, which is an e_mux
  assign sgdma_rx_in_data = tse_mac_receive_data;

  //mux sgdma_rx_in_empty, which is an e_mux
  assign sgdma_rx_in_empty = tse_mac_receive_empty;

  //mux sgdma_rx_in_endofpacket, which is an e_mux
  assign sgdma_rx_in_endofpacket = tse_mac_receive_endofpacket;

  //mux sgdma_rx_in_error, which is an e_mux
  assign sgdma_rx_in_error = tse_mac_receive_error;

  //assign sgdma_rx_in_ready_from_sa = sgdma_rx_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sgdma_rx_in_ready_from_sa = sgdma_rx_in_ready;

  //mux sgdma_rx_in_startofpacket, which is an e_mux
  assign sgdma_rx_in_startofpacket = tse_mac_receive_startofpacket;

  //mux sgdma_rx_in_valid, which is an e_mux
  assign sgdma_rx_in_valid = tse_mac_receive_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_descriptor_read_arbitrator (
                                             // inputs:
                                              clk,
                                              d1_descriptor_memory_s1_end_xfer,
                                              descriptor_memory_s1_readdata_from_sa,
                                              reset_n,
                                              sgdma_rx_descriptor_read_address,
                                              sgdma_rx_descriptor_read_granted_descriptor_memory_s1,
                                              sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1,
                                              sgdma_rx_descriptor_read_read,
                                              sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1,
                                              sgdma_rx_descriptor_read_requests_descriptor_memory_s1,

                                             // outputs:
                                              sgdma_rx_descriptor_read_address_to_slave,
                                              sgdma_rx_descriptor_read_latency_counter,
                                              sgdma_rx_descriptor_read_readdata,
                                              sgdma_rx_descriptor_read_readdatavalid,
                                              sgdma_rx_descriptor_read_waitrequest
                                           )
;

  output  [ 31: 0] sgdma_rx_descriptor_read_address_to_slave;
  output           sgdma_rx_descriptor_read_latency_counter;
  output  [ 31: 0] sgdma_rx_descriptor_read_readdata;
  output           sgdma_rx_descriptor_read_readdatavalid;
  output           sgdma_rx_descriptor_read_waitrequest;
  input            clk;
  input            d1_descriptor_memory_s1_end_xfer;
  input   [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sgdma_rx_descriptor_read_address;
  input            sgdma_rx_descriptor_read_granted_descriptor_memory_s1;
  input            sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1;
  input            sgdma_rx_descriptor_read_read;
  input            sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1;
  input            sgdma_rx_descriptor_read_requests_descriptor_memory_s1;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_sgdma_rx_descriptor_read_latency_counter;
  wire             pre_flush_sgdma_rx_descriptor_read_readdatavalid;
  wire             r_0;
  reg     [ 31: 0] sgdma_rx_descriptor_read_address_last_time;
  wire    [ 31: 0] sgdma_rx_descriptor_read_address_to_slave;
  wire             sgdma_rx_descriptor_read_is_granted_some_slave;
  reg              sgdma_rx_descriptor_read_latency_counter;
  reg              sgdma_rx_descriptor_read_read_but_no_slave_selected;
  reg              sgdma_rx_descriptor_read_read_last_time;
  wire    [ 31: 0] sgdma_rx_descriptor_read_readdata;
  wire             sgdma_rx_descriptor_read_readdatavalid;
  wire             sgdma_rx_descriptor_read_run;
  wire             sgdma_rx_descriptor_read_waitrequest;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1 | ~sgdma_rx_descriptor_read_requests_descriptor_memory_s1) & (sgdma_rx_descriptor_read_granted_descriptor_memory_s1 | ~sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1) & ((~sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1 | ~(sgdma_rx_descriptor_read_read) | (1 & (sgdma_rx_descriptor_read_read))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_rx_descriptor_read_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_rx_descriptor_read_address_to_slave = {21'b1010010000000010,
    sgdma_rx_descriptor_read_address[10 : 0]};

  //sgdma_rx_descriptor_read_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_read_read_but_no_slave_selected <= 0;
      else 
        sgdma_rx_descriptor_read_read_but_no_slave_selected <= sgdma_rx_descriptor_read_read & sgdma_rx_descriptor_read_run & ~sgdma_rx_descriptor_read_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign sgdma_rx_descriptor_read_is_granted_some_slave = sgdma_rx_descriptor_read_granted_descriptor_memory_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_sgdma_rx_descriptor_read_readdatavalid = sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign sgdma_rx_descriptor_read_readdatavalid = sgdma_rx_descriptor_read_read_but_no_slave_selected |
    pre_flush_sgdma_rx_descriptor_read_readdatavalid;

  //sgdma_rx/descriptor_read readdata mux, which is an e_mux
  assign sgdma_rx_descriptor_read_readdata = descriptor_memory_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign sgdma_rx_descriptor_read_waitrequest = ~sgdma_rx_descriptor_read_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_read_latency_counter <= 0;
      else 
        sgdma_rx_descriptor_read_latency_counter <= p1_sgdma_rx_descriptor_read_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_sgdma_rx_descriptor_read_latency_counter = ((sgdma_rx_descriptor_read_run & sgdma_rx_descriptor_read_read))? latency_load_value :
    (sgdma_rx_descriptor_read_latency_counter)? sgdma_rx_descriptor_read_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {1 {sgdma_rx_descriptor_read_requests_descriptor_memory_s1}} & 1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_rx_descriptor_read_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_read_address_last_time <= 0;
      else 
        sgdma_rx_descriptor_read_address_last_time <= sgdma_rx_descriptor_read_address;
    end


  //sgdma_rx/descriptor_read waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_rx_descriptor_read_waitrequest & (sgdma_rx_descriptor_read_read);
    end


  //sgdma_rx_descriptor_read_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_descriptor_read_address != sgdma_rx_descriptor_read_address_last_time))
        begin
          $write("%0d ns: sgdma_rx_descriptor_read_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_descriptor_read_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_read_read_last_time <= 0;
      else 
        sgdma_rx_descriptor_read_read_last_time <= sgdma_rx_descriptor_read_read;
    end


  //sgdma_rx_descriptor_read_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_descriptor_read_read != sgdma_rx_descriptor_read_read_last_time))
        begin
          $write("%0d ns: sgdma_rx_descriptor_read_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_descriptor_write_arbitrator (
                                              // inputs:
                                               clk,
                                               d1_descriptor_memory_s1_end_xfer,
                                               reset_n,
                                               sgdma_rx_descriptor_write_address,
                                               sgdma_rx_descriptor_write_granted_descriptor_memory_s1,
                                               sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1,
                                               sgdma_rx_descriptor_write_requests_descriptor_memory_s1,
                                               sgdma_rx_descriptor_write_write,
                                               sgdma_rx_descriptor_write_writedata,

                                              // outputs:
                                               sgdma_rx_descriptor_write_address_to_slave,
                                               sgdma_rx_descriptor_write_waitrequest
                                            )
;

  output  [ 31: 0] sgdma_rx_descriptor_write_address_to_slave;
  output           sgdma_rx_descriptor_write_waitrequest;
  input            clk;
  input            d1_descriptor_memory_s1_end_xfer;
  input            reset_n;
  input   [ 31: 0] sgdma_rx_descriptor_write_address;
  input            sgdma_rx_descriptor_write_granted_descriptor_memory_s1;
  input            sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1;
  input            sgdma_rx_descriptor_write_requests_descriptor_memory_s1;
  input            sgdma_rx_descriptor_write_write;
  input   [ 31: 0] sgdma_rx_descriptor_write_writedata;

  reg              active_and_waiting_last_time;
  wire             r_0;
  reg     [ 31: 0] sgdma_rx_descriptor_write_address_last_time;
  wire    [ 31: 0] sgdma_rx_descriptor_write_address_to_slave;
  wire             sgdma_rx_descriptor_write_run;
  wire             sgdma_rx_descriptor_write_waitrequest;
  reg              sgdma_rx_descriptor_write_write_last_time;
  reg     [ 31: 0] sgdma_rx_descriptor_write_writedata_last_time;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1 | ~sgdma_rx_descriptor_write_requests_descriptor_memory_s1) & (sgdma_rx_descriptor_write_granted_descriptor_memory_s1 | ~sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1) & ((~sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1 | ~(sgdma_rx_descriptor_write_write) | (1 & (sgdma_rx_descriptor_write_write))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_rx_descriptor_write_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_rx_descriptor_write_address_to_slave = {21'b1010010000000010,
    sgdma_rx_descriptor_write_address[10 : 0]};

  //actual waitrequest port, which is an e_assign
  assign sgdma_rx_descriptor_write_waitrequest = ~sgdma_rx_descriptor_write_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_rx_descriptor_write_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_write_address_last_time <= 0;
      else 
        sgdma_rx_descriptor_write_address_last_time <= sgdma_rx_descriptor_write_address;
    end


  //sgdma_rx/descriptor_write waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_rx_descriptor_write_waitrequest & (sgdma_rx_descriptor_write_write);
    end


  //sgdma_rx_descriptor_write_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_descriptor_write_address != sgdma_rx_descriptor_write_address_last_time))
        begin
          $write("%0d ns: sgdma_rx_descriptor_write_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_descriptor_write_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_write_write_last_time <= 0;
      else 
        sgdma_rx_descriptor_write_write_last_time <= sgdma_rx_descriptor_write_write;
    end


  //sgdma_rx_descriptor_write_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_descriptor_write_write != sgdma_rx_descriptor_write_write_last_time))
        begin
          $write("%0d ns: sgdma_rx_descriptor_write_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_descriptor_write_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_descriptor_write_writedata_last_time <= 0;
      else 
        sgdma_rx_descriptor_write_writedata_last_time <= sgdma_rx_descriptor_write_writedata;
    end


  //sgdma_rx_descriptor_write_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_descriptor_write_writedata != sgdma_rx_descriptor_write_writedata_last_time) & sgdma_rx_descriptor_write_write)
        begin
          $write("%0d ns: sgdma_rx_descriptor_write_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_m_write_arbitrator (
                                     // inputs:
                                      clk,
                                      d1_onchip_memory_s1_end_xfer,
                                      reset_n,
                                      sgdma_rx_m_write_address,
                                      sgdma_rx_m_write_byteenable,
                                      sgdma_rx_m_write_granted_onchip_memory_s1,
                                      sgdma_rx_m_write_qualified_request_onchip_memory_s1,
                                      sgdma_rx_m_write_requests_onchip_memory_s1,
                                      sgdma_rx_m_write_write,
                                      sgdma_rx_m_write_writedata,

                                     // outputs:
                                      sgdma_rx_m_write_address_to_slave,
                                      sgdma_rx_m_write_waitrequest
                                   )
;

  output  [ 31: 0] sgdma_rx_m_write_address_to_slave;
  output           sgdma_rx_m_write_waitrequest;
  input            clk;
  input            d1_onchip_memory_s1_end_xfer;
  input            reset_n;
  input   [ 31: 0] sgdma_rx_m_write_address;
  input   [  3: 0] sgdma_rx_m_write_byteenable;
  input            sgdma_rx_m_write_granted_onchip_memory_s1;
  input            sgdma_rx_m_write_qualified_request_onchip_memory_s1;
  input            sgdma_rx_m_write_requests_onchip_memory_s1;
  input            sgdma_rx_m_write_write;
  input   [ 31: 0] sgdma_rx_m_write_writedata;

  reg              active_and_waiting_last_time;
  wire             r_1;
  reg     [ 31: 0] sgdma_rx_m_write_address_last_time;
  wire    [ 31: 0] sgdma_rx_m_write_address_to_slave;
  reg     [  3: 0] sgdma_rx_m_write_byteenable_last_time;
  wire             sgdma_rx_m_write_run;
  wire             sgdma_rx_m_write_waitrequest;
  reg              sgdma_rx_m_write_write_last_time;
  reg     [ 31: 0] sgdma_rx_m_write_writedata_last_time;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (sgdma_rx_m_write_qualified_request_onchip_memory_s1 | ~sgdma_rx_m_write_requests_onchip_memory_s1) & (sgdma_rx_m_write_granted_onchip_memory_s1 | ~sgdma_rx_m_write_qualified_request_onchip_memory_s1) & ((~sgdma_rx_m_write_qualified_request_onchip_memory_s1 | ~(sgdma_rx_m_write_write) | (1 & (sgdma_rx_m_write_write))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_rx_m_write_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_rx_m_write_address_to_slave = {12'b1010001,
    sgdma_rx_m_write_address[19 : 0]};

  //actual waitrequest port, which is an e_assign
  assign sgdma_rx_m_write_waitrequest = ~sgdma_rx_m_write_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_rx_m_write_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_m_write_address_last_time <= 0;
      else 
        sgdma_rx_m_write_address_last_time <= sgdma_rx_m_write_address;
    end


  //sgdma_rx/m_write waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_rx_m_write_waitrequest & (sgdma_rx_m_write_write);
    end


  //sgdma_rx_m_write_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_m_write_address != sgdma_rx_m_write_address_last_time))
        begin
          $write("%0d ns: sgdma_rx_m_write_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_m_write_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_m_write_byteenable_last_time <= 0;
      else 
        sgdma_rx_m_write_byteenable_last_time <= sgdma_rx_m_write_byteenable;
    end


  //sgdma_rx_m_write_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_m_write_byteenable != sgdma_rx_m_write_byteenable_last_time))
        begin
          $write("%0d ns: sgdma_rx_m_write_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_m_write_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_m_write_write_last_time <= 0;
      else 
        sgdma_rx_m_write_write_last_time <= sgdma_rx_m_write_write;
    end


  //sgdma_rx_m_write_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_m_write_write != sgdma_rx_m_write_write_last_time))
        begin
          $write("%0d ns: sgdma_rx_m_write_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_rx_m_write_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_rx_m_write_writedata_last_time <= 0;
      else 
        sgdma_rx_m_write_writedata_last_time <= sgdma_rx_m_write_writedata;
    end


  //sgdma_rx_m_write_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_rx_m_write_writedata != sgdma_rx_m_write_writedata_last_time) & sgdma_rx_m_write_write)
        begin
          $write("%0d ns: sgdma_rx_m_write_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_tx_csr_arbitrator (
                                 // inputs:
                                  clk,
                                  cpu_data_master_address_to_slave,
                                  cpu_data_master_latency_counter,
                                  cpu_data_master_read,
                                  cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                  cpu_data_master_write,
                                  cpu_data_master_writedata,
                                  reset_n,
                                  sgdma_tx_csr_irq,
                                  sgdma_tx_csr_readdata,

                                 // outputs:
                                  cpu_data_master_granted_sgdma_tx_csr,
                                  cpu_data_master_qualified_request_sgdma_tx_csr,
                                  cpu_data_master_read_data_valid_sgdma_tx_csr,
                                  cpu_data_master_requests_sgdma_tx_csr,
                                  d1_sgdma_tx_csr_end_xfer,
                                  sgdma_tx_csr_address,
                                  sgdma_tx_csr_chipselect,
                                  sgdma_tx_csr_irq_from_sa,
                                  sgdma_tx_csr_read,
                                  sgdma_tx_csr_readdata_from_sa,
                                  sgdma_tx_csr_reset_n,
                                  sgdma_tx_csr_write,
                                  sgdma_tx_csr_writedata
                               )
;

  output           cpu_data_master_granted_sgdma_tx_csr;
  output           cpu_data_master_qualified_request_sgdma_tx_csr;
  output           cpu_data_master_read_data_valid_sgdma_tx_csr;
  output           cpu_data_master_requests_sgdma_tx_csr;
  output           d1_sgdma_tx_csr_end_xfer;
  output  [  3: 0] sgdma_tx_csr_address;
  output           sgdma_tx_csr_chipselect;
  output           sgdma_tx_csr_irq_from_sa;
  output           sgdma_tx_csr_read;
  output  [ 31: 0] sgdma_tx_csr_readdata_from_sa;
  output           sgdma_tx_csr_reset_n;
  output           sgdma_tx_csr_write;
  output  [ 31: 0] sgdma_tx_csr_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;
  input            sgdma_tx_csr_irq;
  input   [ 31: 0] sgdma_tx_csr_readdata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sgdma_tx_csr;
  wire             cpu_data_master_qualified_request_sgdma_tx_csr;
  wire             cpu_data_master_read_data_valid_sgdma_tx_csr;
  wire             cpu_data_master_requests_sgdma_tx_csr;
  wire             cpu_data_master_saved_grant_sgdma_tx_csr;
  reg              d1_reasons_to_wait;
  reg              d1_sgdma_tx_csr_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sgdma_tx_csr;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  3: 0] sgdma_tx_csr_address;
  wire             sgdma_tx_csr_allgrants;
  wire             sgdma_tx_csr_allow_new_arb_cycle;
  wire             sgdma_tx_csr_any_bursting_master_saved_grant;
  wire             sgdma_tx_csr_any_continuerequest;
  wire             sgdma_tx_csr_arb_counter_enable;
  reg     [  1: 0] sgdma_tx_csr_arb_share_counter;
  wire    [  1: 0] sgdma_tx_csr_arb_share_counter_next_value;
  wire    [  1: 0] sgdma_tx_csr_arb_share_set_values;
  wire             sgdma_tx_csr_beginbursttransfer_internal;
  wire             sgdma_tx_csr_begins_xfer;
  wire             sgdma_tx_csr_chipselect;
  wire             sgdma_tx_csr_end_xfer;
  wire             sgdma_tx_csr_firsttransfer;
  wire             sgdma_tx_csr_grant_vector;
  wire             sgdma_tx_csr_in_a_read_cycle;
  wire             sgdma_tx_csr_in_a_write_cycle;
  wire             sgdma_tx_csr_irq_from_sa;
  wire             sgdma_tx_csr_master_qreq_vector;
  wire             sgdma_tx_csr_non_bursting_master_requests;
  wire             sgdma_tx_csr_read;
  wire    [ 31: 0] sgdma_tx_csr_readdata_from_sa;
  reg              sgdma_tx_csr_reg_firsttransfer;
  wire             sgdma_tx_csr_reset_n;
  reg              sgdma_tx_csr_slavearbiterlockenable;
  wire             sgdma_tx_csr_slavearbiterlockenable2;
  wire             sgdma_tx_csr_unreg_firsttransfer;
  wire             sgdma_tx_csr_waits_for_read;
  wire             sgdma_tx_csr_waits_for_write;
  wire             sgdma_tx_csr_write;
  wire    [ 31: 0] sgdma_tx_csr_writedata;
  wire    [ 26: 0] shifted_address_to_sgdma_tx_csr_from_cpu_data_master;
  wire             wait_for_sgdma_tx_csr_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sgdma_tx_csr_end_xfer;
    end


  assign sgdma_tx_csr_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_sgdma_tx_csr));
  //assign sgdma_tx_csr_readdata_from_sa = sgdma_tx_csr_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sgdma_tx_csr_readdata_from_sa = sgdma_tx_csr_readdata;

  assign cpu_data_master_requests_sgdma_tx_csr = ({cpu_data_master_address_to_slave[26 : 6] , 6'b0} == 27'h5201c00) & (cpu_data_master_read | cpu_data_master_write);
  //sgdma_tx_csr_arb_share_counter set values, which is an e_mux
  assign sgdma_tx_csr_arb_share_set_values = 1;

  //sgdma_tx_csr_non_bursting_master_requests mux, which is an e_mux
  assign sgdma_tx_csr_non_bursting_master_requests = cpu_data_master_requests_sgdma_tx_csr;

  //sgdma_tx_csr_any_bursting_master_saved_grant mux, which is an e_mux
  assign sgdma_tx_csr_any_bursting_master_saved_grant = 0;

  //sgdma_tx_csr_arb_share_counter_next_value assignment, which is an e_assign
  assign sgdma_tx_csr_arb_share_counter_next_value = sgdma_tx_csr_firsttransfer ? (sgdma_tx_csr_arb_share_set_values - 1) : |sgdma_tx_csr_arb_share_counter ? (sgdma_tx_csr_arb_share_counter - 1) : 0;

  //sgdma_tx_csr_allgrants all slave grants, which is an e_mux
  assign sgdma_tx_csr_allgrants = |sgdma_tx_csr_grant_vector;

  //sgdma_tx_csr_end_xfer assignment, which is an e_assign
  assign sgdma_tx_csr_end_xfer = ~(sgdma_tx_csr_waits_for_read | sgdma_tx_csr_waits_for_write);

  //end_xfer_arb_share_counter_term_sgdma_tx_csr arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sgdma_tx_csr = sgdma_tx_csr_end_xfer & (~sgdma_tx_csr_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sgdma_tx_csr_arb_share_counter arbitration counter enable, which is an e_assign
  assign sgdma_tx_csr_arb_counter_enable = (end_xfer_arb_share_counter_term_sgdma_tx_csr & sgdma_tx_csr_allgrants) | (end_xfer_arb_share_counter_term_sgdma_tx_csr & ~sgdma_tx_csr_non_bursting_master_requests);

  //sgdma_tx_csr_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_csr_arb_share_counter <= 0;
      else if (sgdma_tx_csr_arb_counter_enable)
          sgdma_tx_csr_arb_share_counter <= sgdma_tx_csr_arb_share_counter_next_value;
    end


  //sgdma_tx_csr_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_csr_slavearbiterlockenable <= 0;
      else if ((|sgdma_tx_csr_master_qreq_vector & end_xfer_arb_share_counter_term_sgdma_tx_csr) | (end_xfer_arb_share_counter_term_sgdma_tx_csr & ~sgdma_tx_csr_non_bursting_master_requests))
          sgdma_tx_csr_slavearbiterlockenable <= |sgdma_tx_csr_arb_share_counter_next_value;
    end


  //cpu/data_master sgdma_tx/csr arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sgdma_tx_csr_slavearbiterlockenable & cpu_data_master_continuerequest;

  //sgdma_tx_csr_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sgdma_tx_csr_slavearbiterlockenable2 = |sgdma_tx_csr_arb_share_counter_next_value;

  //cpu/data_master sgdma_tx/csr arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sgdma_tx_csr_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sgdma_tx_csr_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sgdma_tx_csr_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_sgdma_tx_csr = cpu_data_master_requests_sgdma_tx_csr & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_sgdma_tx_csr, which is an e_mux
  assign cpu_data_master_read_data_valid_sgdma_tx_csr = cpu_data_master_granted_sgdma_tx_csr & cpu_data_master_read & ~sgdma_tx_csr_waits_for_read;

  //sgdma_tx_csr_writedata mux, which is an e_mux
  assign sgdma_tx_csr_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_sgdma_tx_csr = cpu_data_master_qualified_request_sgdma_tx_csr;

  //cpu/data_master saved-grant sgdma_tx/csr, which is an e_assign
  assign cpu_data_master_saved_grant_sgdma_tx_csr = cpu_data_master_requests_sgdma_tx_csr;

  //allow new arb cycle for sgdma_tx/csr, which is an e_assign
  assign sgdma_tx_csr_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sgdma_tx_csr_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sgdma_tx_csr_master_qreq_vector = 1;

  //sgdma_tx_csr_reset_n assignment, which is an e_assign
  assign sgdma_tx_csr_reset_n = reset_n;

  assign sgdma_tx_csr_chipselect = cpu_data_master_granted_sgdma_tx_csr;
  //sgdma_tx_csr_firsttransfer first transaction, which is an e_assign
  assign sgdma_tx_csr_firsttransfer = sgdma_tx_csr_begins_xfer ? sgdma_tx_csr_unreg_firsttransfer : sgdma_tx_csr_reg_firsttransfer;

  //sgdma_tx_csr_unreg_firsttransfer first transaction, which is an e_assign
  assign sgdma_tx_csr_unreg_firsttransfer = ~(sgdma_tx_csr_slavearbiterlockenable & sgdma_tx_csr_any_continuerequest);

  //sgdma_tx_csr_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_csr_reg_firsttransfer <= 1'b1;
      else if (sgdma_tx_csr_begins_xfer)
          sgdma_tx_csr_reg_firsttransfer <= sgdma_tx_csr_unreg_firsttransfer;
    end


  //sgdma_tx_csr_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sgdma_tx_csr_beginbursttransfer_internal = sgdma_tx_csr_begins_xfer;

  //sgdma_tx_csr_read assignment, which is an e_mux
  assign sgdma_tx_csr_read = cpu_data_master_granted_sgdma_tx_csr & cpu_data_master_read;

  //sgdma_tx_csr_write assignment, which is an e_mux
  assign sgdma_tx_csr_write = cpu_data_master_granted_sgdma_tx_csr & cpu_data_master_write;

  assign shifted_address_to_sgdma_tx_csr_from_cpu_data_master = cpu_data_master_address_to_slave;
  //sgdma_tx_csr_address mux, which is an e_mux
  assign sgdma_tx_csr_address = shifted_address_to_sgdma_tx_csr_from_cpu_data_master >> 2;

  //d1_sgdma_tx_csr_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sgdma_tx_csr_end_xfer <= 1;
      else 
        d1_sgdma_tx_csr_end_xfer <= sgdma_tx_csr_end_xfer;
    end


  //sgdma_tx_csr_waits_for_read in a cycle, which is an e_mux
  assign sgdma_tx_csr_waits_for_read = sgdma_tx_csr_in_a_read_cycle & sgdma_tx_csr_begins_xfer;

  //sgdma_tx_csr_in_a_read_cycle assignment, which is an e_assign
  assign sgdma_tx_csr_in_a_read_cycle = cpu_data_master_granted_sgdma_tx_csr & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sgdma_tx_csr_in_a_read_cycle;

  //sgdma_tx_csr_waits_for_write in a cycle, which is an e_mux
  assign sgdma_tx_csr_waits_for_write = sgdma_tx_csr_in_a_write_cycle & 0;

  //sgdma_tx_csr_in_a_write_cycle assignment, which is an e_assign
  assign sgdma_tx_csr_in_a_write_cycle = cpu_data_master_granted_sgdma_tx_csr & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sgdma_tx_csr_in_a_write_cycle;

  assign wait_for_sgdma_tx_csr_counter = 0;
  //assign sgdma_tx_csr_irq_from_sa = sgdma_tx_csr_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sgdma_tx_csr_irq_from_sa = sgdma_tx_csr_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_tx/csr enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_tx_descriptor_read_arbitrator (
                                             // inputs:
                                              clk,
                                              d1_descriptor_memory_s1_end_xfer,
                                              descriptor_memory_s1_readdata_from_sa,
                                              reset_n,
                                              sgdma_tx_descriptor_read_address,
                                              sgdma_tx_descriptor_read_granted_descriptor_memory_s1,
                                              sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1,
                                              sgdma_tx_descriptor_read_read,
                                              sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1,
                                              sgdma_tx_descriptor_read_requests_descriptor_memory_s1,

                                             // outputs:
                                              sgdma_tx_descriptor_read_address_to_slave,
                                              sgdma_tx_descriptor_read_latency_counter,
                                              sgdma_tx_descriptor_read_readdata,
                                              sgdma_tx_descriptor_read_readdatavalid,
                                              sgdma_tx_descriptor_read_waitrequest
                                           )
;

  output  [ 31: 0] sgdma_tx_descriptor_read_address_to_slave;
  output           sgdma_tx_descriptor_read_latency_counter;
  output  [ 31: 0] sgdma_tx_descriptor_read_readdata;
  output           sgdma_tx_descriptor_read_readdatavalid;
  output           sgdma_tx_descriptor_read_waitrequest;
  input            clk;
  input            d1_descriptor_memory_s1_end_xfer;
  input   [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sgdma_tx_descriptor_read_address;
  input            sgdma_tx_descriptor_read_granted_descriptor_memory_s1;
  input            sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1;
  input            sgdma_tx_descriptor_read_read;
  input            sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1;
  input            sgdma_tx_descriptor_read_requests_descriptor_memory_s1;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_sgdma_tx_descriptor_read_latency_counter;
  wire             pre_flush_sgdma_tx_descriptor_read_readdatavalid;
  wire             r_0;
  reg     [ 31: 0] sgdma_tx_descriptor_read_address_last_time;
  wire    [ 31: 0] sgdma_tx_descriptor_read_address_to_slave;
  wire             sgdma_tx_descriptor_read_is_granted_some_slave;
  reg              sgdma_tx_descriptor_read_latency_counter;
  reg              sgdma_tx_descriptor_read_read_but_no_slave_selected;
  reg              sgdma_tx_descriptor_read_read_last_time;
  wire    [ 31: 0] sgdma_tx_descriptor_read_readdata;
  wire             sgdma_tx_descriptor_read_readdatavalid;
  wire             sgdma_tx_descriptor_read_run;
  wire             sgdma_tx_descriptor_read_waitrequest;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1 | ~sgdma_tx_descriptor_read_requests_descriptor_memory_s1) & (sgdma_tx_descriptor_read_granted_descriptor_memory_s1 | ~sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1) & ((~sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1 | ~(sgdma_tx_descriptor_read_read) | (1 & (sgdma_tx_descriptor_read_read))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_tx_descriptor_read_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_tx_descriptor_read_address_to_slave = {21'b1010010000000010,
    sgdma_tx_descriptor_read_address[10 : 0]};

  //sgdma_tx_descriptor_read_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_read_read_but_no_slave_selected <= 0;
      else 
        sgdma_tx_descriptor_read_read_but_no_slave_selected <= sgdma_tx_descriptor_read_read & sgdma_tx_descriptor_read_run & ~sgdma_tx_descriptor_read_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign sgdma_tx_descriptor_read_is_granted_some_slave = sgdma_tx_descriptor_read_granted_descriptor_memory_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_sgdma_tx_descriptor_read_readdatavalid = sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign sgdma_tx_descriptor_read_readdatavalid = sgdma_tx_descriptor_read_read_but_no_slave_selected |
    pre_flush_sgdma_tx_descriptor_read_readdatavalid;

  //sgdma_tx/descriptor_read readdata mux, which is an e_mux
  assign sgdma_tx_descriptor_read_readdata = descriptor_memory_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign sgdma_tx_descriptor_read_waitrequest = ~sgdma_tx_descriptor_read_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_read_latency_counter <= 0;
      else 
        sgdma_tx_descriptor_read_latency_counter <= p1_sgdma_tx_descriptor_read_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_sgdma_tx_descriptor_read_latency_counter = ((sgdma_tx_descriptor_read_run & sgdma_tx_descriptor_read_read))? latency_load_value :
    (sgdma_tx_descriptor_read_latency_counter)? sgdma_tx_descriptor_read_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {1 {sgdma_tx_descriptor_read_requests_descriptor_memory_s1}} & 1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_tx_descriptor_read_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_read_address_last_time <= 0;
      else 
        sgdma_tx_descriptor_read_address_last_time <= sgdma_tx_descriptor_read_address;
    end


  //sgdma_tx/descriptor_read waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_tx_descriptor_read_waitrequest & (sgdma_tx_descriptor_read_read);
    end


  //sgdma_tx_descriptor_read_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_descriptor_read_address != sgdma_tx_descriptor_read_address_last_time))
        begin
          $write("%0d ns: sgdma_tx_descriptor_read_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_tx_descriptor_read_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_read_read_last_time <= 0;
      else 
        sgdma_tx_descriptor_read_read_last_time <= sgdma_tx_descriptor_read_read;
    end


  //sgdma_tx_descriptor_read_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_descriptor_read_read != sgdma_tx_descriptor_read_read_last_time))
        begin
          $write("%0d ns: sgdma_tx_descriptor_read_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_tx_descriptor_write_arbitrator (
                                              // inputs:
                                               clk,
                                               d1_descriptor_memory_s1_end_xfer,
                                               reset_n,
                                               sgdma_tx_descriptor_write_address,
                                               sgdma_tx_descriptor_write_granted_descriptor_memory_s1,
                                               sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1,
                                               sgdma_tx_descriptor_write_requests_descriptor_memory_s1,
                                               sgdma_tx_descriptor_write_write,
                                               sgdma_tx_descriptor_write_writedata,

                                              // outputs:
                                               sgdma_tx_descriptor_write_address_to_slave,
                                               sgdma_tx_descriptor_write_waitrequest
                                            )
;

  output  [ 31: 0] sgdma_tx_descriptor_write_address_to_slave;
  output           sgdma_tx_descriptor_write_waitrequest;
  input            clk;
  input            d1_descriptor_memory_s1_end_xfer;
  input            reset_n;
  input   [ 31: 0] sgdma_tx_descriptor_write_address;
  input            sgdma_tx_descriptor_write_granted_descriptor_memory_s1;
  input            sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1;
  input            sgdma_tx_descriptor_write_requests_descriptor_memory_s1;
  input            sgdma_tx_descriptor_write_write;
  input   [ 31: 0] sgdma_tx_descriptor_write_writedata;

  reg              active_and_waiting_last_time;
  wire             r_0;
  reg     [ 31: 0] sgdma_tx_descriptor_write_address_last_time;
  wire    [ 31: 0] sgdma_tx_descriptor_write_address_to_slave;
  wire             sgdma_tx_descriptor_write_run;
  wire             sgdma_tx_descriptor_write_waitrequest;
  reg              sgdma_tx_descriptor_write_write_last_time;
  reg     [ 31: 0] sgdma_tx_descriptor_write_writedata_last_time;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1 | ~sgdma_tx_descriptor_write_requests_descriptor_memory_s1) & (sgdma_tx_descriptor_write_granted_descriptor_memory_s1 | ~sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1) & ((~sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1 | ~(sgdma_tx_descriptor_write_write) | (1 & (sgdma_tx_descriptor_write_write))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_tx_descriptor_write_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_tx_descriptor_write_address_to_slave = {21'b1010010000000010,
    sgdma_tx_descriptor_write_address[10 : 0]};

  //actual waitrequest port, which is an e_assign
  assign sgdma_tx_descriptor_write_waitrequest = ~sgdma_tx_descriptor_write_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_tx_descriptor_write_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_write_address_last_time <= 0;
      else 
        sgdma_tx_descriptor_write_address_last_time <= sgdma_tx_descriptor_write_address;
    end


  //sgdma_tx/descriptor_write waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_tx_descriptor_write_waitrequest & (sgdma_tx_descriptor_write_write);
    end


  //sgdma_tx_descriptor_write_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_descriptor_write_address != sgdma_tx_descriptor_write_address_last_time))
        begin
          $write("%0d ns: sgdma_tx_descriptor_write_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_tx_descriptor_write_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_write_write_last_time <= 0;
      else 
        sgdma_tx_descriptor_write_write_last_time <= sgdma_tx_descriptor_write_write;
    end


  //sgdma_tx_descriptor_write_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_descriptor_write_write != sgdma_tx_descriptor_write_write_last_time))
        begin
          $write("%0d ns: sgdma_tx_descriptor_write_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_tx_descriptor_write_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_descriptor_write_writedata_last_time <= 0;
      else 
        sgdma_tx_descriptor_write_writedata_last_time <= sgdma_tx_descriptor_write_writedata;
    end


  //sgdma_tx_descriptor_write_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_descriptor_write_writedata != sgdma_tx_descriptor_write_writedata_last_time) & sgdma_tx_descriptor_write_write)
        begin
          $write("%0d ns: sgdma_tx_descriptor_write_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_tx_m_read_arbitrator (
                                    // inputs:
                                     clk,
                                     d1_onchip_memory_s1_end_xfer,
                                     onchip_memory_s1_readdata_from_sa,
                                     reset_n,
                                     sgdma_tx_m_read_address,
                                     sgdma_tx_m_read_granted_onchip_memory_s1,
                                     sgdma_tx_m_read_qualified_request_onchip_memory_s1,
                                     sgdma_tx_m_read_read,
                                     sgdma_tx_m_read_read_data_valid_onchip_memory_s1,
                                     sgdma_tx_m_read_requests_onchip_memory_s1,

                                    // outputs:
                                     sgdma_tx_m_read_address_to_slave,
                                     sgdma_tx_m_read_latency_counter,
                                     sgdma_tx_m_read_readdata,
                                     sgdma_tx_m_read_readdatavalid,
                                     sgdma_tx_m_read_waitrequest
                                  )
;

  output  [ 31: 0] sgdma_tx_m_read_address_to_slave;
  output           sgdma_tx_m_read_latency_counter;
  output  [ 31: 0] sgdma_tx_m_read_readdata;
  output           sgdma_tx_m_read_readdatavalid;
  output           sgdma_tx_m_read_waitrequest;
  input            clk;
  input            d1_onchip_memory_s1_end_xfer;
  input   [ 31: 0] onchip_memory_s1_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sgdma_tx_m_read_address;
  input            sgdma_tx_m_read_granted_onchip_memory_s1;
  input            sgdma_tx_m_read_qualified_request_onchip_memory_s1;
  input            sgdma_tx_m_read_read;
  input            sgdma_tx_m_read_read_data_valid_onchip_memory_s1;
  input            sgdma_tx_m_read_requests_onchip_memory_s1;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_sgdma_tx_m_read_latency_counter;
  wire             pre_flush_sgdma_tx_m_read_readdatavalid;
  wire             r_1;
  reg     [ 31: 0] sgdma_tx_m_read_address_last_time;
  wire    [ 31: 0] sgdma_tx_m_read_address_to_slave;
  wire             sgdma_tx_m_read_is_granted_some_slave;
  reg              sgdma_tx_m_read_latency_counter;
  reg              sgdma_tx_m_read_read_but_no_slave_selected;
  reg              sgdma_tx_m_read_read_last_time;
  wire    [ 31: 0] sgdma_tx_m_read_readdata;
  wire             sgdma_tx_m_read_readdatavalid;
  wire             sgdma_tx_m_read_run;
  wire             sgdma_tx_m_read_waitrequest;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (sgdma_tx_m_read_qualified_request_onchip_memory_s1 | ~sgdma_tx_m_read_requests_onchip_memory_s1) & (sgdma_tx_m_read_granted_onchip_memory_s1 | ~sgdma_tx_m_read_qualified_request_onchip_memory_s1) & ((~sgdma_tx_m_read_qualified_request_onchip_memory_s1 | ~(sgdma_tx_m_read_read) | (1 & (sgdma_tx_m_read_read))));

  //cascaded wait assignment, which is an e_assign
  assign sgdma_tx_m_read_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign sgdma_tx_m_read_address_to_slave = {12'b1010001,
    sgdma_tx_m_read_address[19 : 0]};

  //sgdma_tx_m_read_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_m_read_read_but_no_slave_selected <= 0;
      else 
        sgdma_tx_m_read_read_but_no_slave_selected <= sgdma_tx_m_read_read & sgdma_tx_m_read_run & ~sgdma_tx_m_read_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign sgdma_tx_m_read_is_granted_some_slave = sgdma_tx_m_read_granted_onchip_memory_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_sgdma_tx_m_read_readdatavalid = sgdma_tx_m_read_read_data_valid_onchip_memory_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign sgdma_tx_m_read_readdatavalid = sgdma_tx_m_read_read_but_no_slave_selected |
    pre_flush_sgdma_tx_m_read_readdatavalid;

  //sgdma_tx/m_read readdata mux, which is an e_mux
  assign sgdma_tx_m_read_readdata = onchip_memory_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign sgdma_tx_m_read_waitrequest = ~sgdma_tx_m_read_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_m_read_latency_counter <= 0;
      else 
        sgdma_tx_m_read_latency_counter <= p1_sgdma_tx_m_read_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_sgdma_tx_m_read_latency_counter = ((sgdma_tx_m_read_run & sgdma_tx_m_read_read))? latency_load_value :
    (sgdma_tx_m_read_latency_counter)? sgdma_tx_m_read_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {1 {sgdma_tx_m_read_requests_onchip_memory_s1}} & 1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sgdma_tx_m_read_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_m_read_address_last_time <= 0;
      else 
        sgdma_tx_m_read_address_last_time <= sgdma_tx_m_read_address;
    end


  //sgdma_tx/m_read waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= sgdma_tx_m_read_waitrequest & (sgdma_tx_m_read_read);
    end


  //sgdma_tx_m_read_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_m_read_address != sgdma_tx_m_read_address_last_time))
        begin
          $write("%0d ns: sgdma_tx_m_read_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //sgdma_tx_m_read_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sgdma_tx_m_read_read_last_time <= 0;
      else 
        sgdma_tx_m_read_read_last_time <= sgdma_tx_m_read_read;
    end


  //sgdma_tx_m_read_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (sgdma_tx_m_read_read != sgdma_tx_m_read_read_last_time))
        begin
          $write("%0d ns: sgdma_tx_m_read_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_tx_out_arbitrator (
                                 // inputs:
                                  clk,
                                  reset_n,
                                  sgdma_tx_out_data,
                                  sgdma_tx_out_empty,
                                  sgdma_tx_out_endofpacket,
                                  sgdma_tx_out_error,
                                  sgdma_tx_out_startofpacket,
                                  sgdma_tx_out_valid,
                                  tse_mac_transmit_ready_from_sa,

                                 // outputs:
                                  sgdma_tx_out_ready
                               )
;

  output           sgdma_tx_out_ready;
  input            clk;
  input            reset_n;
  input   [ 31: 0] sgdma_tx_out_data;
  input   [  1: 0] sgdma_tx_out_empty;
  input            sgdma_tx_out_endofpacket;
  input            sgdma_tx_out_error;
  input            sgdma_tx_out_startofpacket;
  input            sgdma_tx_out_valid;
  input            tse_mac_transmit_ready_from_sa;

  wire             sgdma_tx_out_ready;
  //mux sgdma_tx_out_ready, which is an e_mux
  assign sgdma_tx_out_ready = tse_mac_transmit_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sw_pio_s1_arbitrator (
                              // inputs:
                               clk,
                               peripheral_clock_crossing_m1_address_to_slave,
                               peripheral_clock_crossing_m1_latency_counter,
                               peripheral_clock_crossing_m1_nativeaddress,
                               peripheral_clock_crossing_m1_read,
                               peripheral_clock_crossing_m1_write,
                               reset_n,
                               sw_pio_s1_readdata,

                              // outputs:
                               d1_sw_pio_s1_end_xfer,
                               peripheral_clock_crossing_m1_granted_sw_pio_s1,
                               peripheral_clock_crossing_m1_qualified_request_sw_pio_s1,
                               peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1,
                               peripheral_clock_crossing_m1_requests_sw_pio_s1,
                               sw_pio_s1_address,
                               sw_pio_s1_readdata_from_sa,
                               sw_pio_s1_reset_n
                            )
;

  output           d1_sw_pio_s1_end_xfer;
  output           peripheral_clock_crossing_m1_granted_sw_pio_s1;
  output           peripheral_clock_crossing_m1_qualified_request_sw_pio_s1;
  output           peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1;
  output           peripheral_clock_crossing_m1_requests_sw_pio_s1;
  output  [  1: 0] sw_pio_s1_address;
  output  [  7: 0] sw_pio_s1_readdata_from_sa;
  output           sw_pio_s1_reset_n;
  input            clk;
  input   [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  input            peripheral_clock_crossing_m1_latency_counter;
  input   [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  input            peripheral_clock_crossing_m1_read;
  input            peripheral_clock_crossing_m1_write;
  input            reset_n;
  input   [  7: 0] sw_pio_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sw_pio_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sw_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             peripheral_clock_crossing_m1_arbiterlock;
  wire             peripheral_clock_crossing_m1_arbiterlock2;
  wire             peripheral_clock_crossing_m1_continuerequest;
  wire             peripheral_clock_crossing_m1_granted_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_saved_grant_sw_pio_s1;
  wire    [  1: 0] sw_pio_s1_address;
  wire             sw_pio_s1_allgrants;
  wire             sw_pio_s1_allow_new_arb_cycle;
  wire             sw_pio_s1_any_bursting_master_saved_grant;
  wire             sw_pio_s1_any_continuerequest;
  wire             sw_pio_s1_arb_counter_enable;
  reg              sw_pio_s1_arb_share_counter;
  wire             sw_pio_s1_arb_share_counter_next_value;
  wire             sw_pio_s1_arb_share_set_values;
  wire             sw_pio_s1_beginbursttransfer_internal;
  wire             sw_pio_s1_begins_xfer;
  wire             sw_pio_s1_end_xfer;
  wire             sw_pio_s1_firsttransfer;
  wire             sw_pio_s1_grant_vector;
  wire             sw_pio_s1_in_a_read_cycle;
  wire             sw_pio_s1_in_a_write_cycle;
  wire             sw_pio_s1_master_qreq_vector;
  wire             sw_pio_s1_non_bursting_master_requests;
  wire    [  7: 0] sw_pio_s1_readdata_from_sa;
  reg              sw_pio_s1_reg_firsttransfer;
  wire             sw_pio_s1_reset_n;
  reg              sw_pio_s1_slavearbiterlockenable;
  wire             sw_pio_s1_slavearbiterlockenable2;
  wire             sw_pio_s1_unreg_firsttransfer;
  wire             sw_pio_s1_waits_for_read;
  wire             sw_pio_s1_waits_for_write;
  wire             wait_for_sw_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sw_pio_s1_end_xfer;
    end


  assign sw_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((peripheral_clock_crossing_m1_qualified_request_sw_pio_s1));
  //assign sw_pio_s1_readdata_from_sa = sw_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sw_pio_s1_readdata_from_sa = sw_pio_s1_readdata;

  assign peripheral_clock_crossing_m1_requests_sw_pio_s1 = (({peripheral_clock_crossing_m1_address_to_slave[6 : 4] , 4'b0} == 7'h10) & (peripheral_clock_crossing_m1_read | peripheral_clock_crossing_m1_write)) & peripheral_clock_crossing_m1_read;
  //sw_pio_s1_arb_share_counter set values, which is an e_mux
  assign sw_pio_s1_arb_share_set_values = 1;

  //sw_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign sw_pio_s1_non_bursting_master_requests = peripheral_clock_crossing_m1_requests_sw_pio_s1;

  //sw_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sw_pio_s1_any_bursting_master_saved_grant = 0;

  //sw_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sw_pio_s1_arb_share_counter_next_value = sw_pio_s1_firsttransfer ? (sw_pio_s1_arb_share_set_values - 1) : |sw_pio_s1_arb_share_counter ? (sw_pio_s1_arb_share_counter - 1) : 0;

  //sw_pio_s1_allgrants all slave grants, which is an e_mux
  assign sw_pio_s1_allgrants = |sw_pio_s1_grant_vector;

  //sw_pio_s1_end_xfer assignment, which is an e_assign
  assign sw_pio_s1_end_xfer = ~(sw_pio_s1_waits_for_read | sw_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sw_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sw_pio_s1 = sw_pio_s1_end_xfer & (~sw_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sw_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sw_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sw_pio_s1 & sw_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_sw_pio_s1 & ~sw_pio_s1_non_bursting_master_requests);

  //sw_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sw_pio_s1_arb_share_counter <= 0;
      else if (sw_pio_s1_arb_counter_enable)
          sw_pio_s1_arb_share_counter <= sw_pio_s1_arb_share_counter_next_value;
    end


  //sw_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sw_pio_s1_slavearbiterlockenable <= 0;
      else if ((|sw_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sw_pio_s1) | (end_xfer_arb_share_counter_term_sw_pio_s1 & ~sw_pio_s1_non_bursting_master_requests))
          sw_pio_s1_slavearbiterlockenable <= |sw_pio_s1_arb_share_counter_next_value;
    end


  //peripheral_clock_crossing/m1 sw_pio/s1 arbiterlock, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock = sw_pio_s1_slavearbiterlockenable & peripheral_clock_crossing_m1_continuerequest;

  //sw_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sw_pio_s1_slavearbiterlockenable2 = |sw_pio_s1_arb_share_counter_next_value;

  //peripheral_clock_crossing/m1 sw_pio/s1 arbiterlock2, which is an e_assign
  assign peripheral_clock_crossing_m1_arbiterlock2 = sw_pio_s1_slavearbiterlockenable2 & peripheral_clock_crossing_m1_continuerequest;

  //sw_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sw_pio_s1_any_continuerequest = 1;

  //peripheral_clock_crossing_m1_continuerequest continued request, which is an e_assign
  assign peripheral_clock_crossing_m1_continuerequest = 1;

  assign peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 = peripheral_clock_crossing_m1_requests_sw_pio_s1 & ~((peripheral_clock_crossing_m1_read & ((peripheral_clock_crossing_m1_latency_counter != 0))));
  //local readdatavalid peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1, which is an e_mux
  assign peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1 = peripheral_clock_crossing_m1_granted_sw_pio_s1 & peripheral_clock_crossing_m1_read & ~sw_pio_s1_waits_for_read;

  //master is always granted when requested
  assign peripheral_clock_crossing_m1_granted_sw_pio_s1 = peripheral_clock_crossing_m1_qualified_request_sw_pio_s1;

  //peripheral_clock_crossing/m1 saved-grant sw_pio/s1, which is an e_assign
  assign peripheral_clock_crossing_m1_saved_grant_sw_pio_s1 = peripheral_clock_crossing_m1_requests_sw_pio_s1;

  //allow new arb cycle for sw_pio/s1, which is an e_assign
  assign sw_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sw_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sw_pio_s1_master_qreq_vector = 1;

  //sw_pio_s1_reset_n assignment, which is an e_assign
  assign sw_pio_s1_reset_n = reset_n;

  //sw_pio_s1_firsttransfer first transaction, which is an e_assign
  assign sw_pio_s1_firsttransfer = sw_pio_s1_begins_xfer ? sw_pio_s1_unreg_firsttransfer : sw_pio_s1_reg_firsttransfer;

  //sw_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sw_pio_s1_unreg_firsttransfer = ~(sw_pio_s1_slavearbiterlockenable & sw_pio_s1_any_continuerequest);

  //sw_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sw_pio_s1_reg_firsttransfer <= 1'b1;
      else if (sw_pio_s1_begins_xfer)
          sw_pio_s1_reg_firsttransfer <= sw_pio_s1_unreg_firsttransfer;
    end


  //sw_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sw_pio_s1_beginbursttransfer_internal = sw_pio_s1_begins_xfer;

  //sw_pio_s1_address mux, which is an e_mux
  assign sw_pio_s1_address = peripheral_clock_crossing_m1_nativeaddress;

  //d1_sw_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sw_pio_s1_end_xfer <= 1;
      else 
        d1_sw_pio_s1_end_xfer <= sw_pio_s1_end_xfer;
    end


  //sw_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign sw_pio_s1_waits_for_read = sw_pio_s1_in_a_read_cycle & sw_pio_s1_begins_xfer;

  //sw_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign sw_pio_s1_in_a_read_cycle = peripheral_clock_crossing_m1_granted_sw_pio_s1 & peripheral_clock_crossing_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sw_pio_s1_in_a_read_cycle;

  //sw_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign sw_pio_s1_waits_for_write = sw_pio_s1_in_a_write_cycle & 0;

  //sw_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign sw_pio_s1_in_a_write_cycle = peripheral_clock_crossing_m1_granted_sw_pio_s1 & peripheral_clock_crossing_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sw_pio_s1_in_a_write_cycle;

  assign wait_for_sw_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sw_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sys_timer_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  cpu_data_master_address_to_slave,
                                  cpu_data_master_latency_counter,
                                  cpu_data_master_read,
                                  cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                  cpu_data_master_write,
                                  cpu_data_master_writedata,
                                  reset_n,
                                  sys_timer_s1_irq,
                                  sys_timer_s1_readdata,

                                 // outputs:
                                  cpu_data_master_granted_sys_timer_s1,
                                  cpu_data_master_qualified_request_sys_timer_s1,
                                  cpu_data_master_read_data_valid_sys_timer_s1,
                                  cpu_data_master_requests_sys_timer_s1,
                                  d1_sys_timer_s1_end_xfer,
                                  sys_timer_s1_address,
                                  sys_timer_s1_chipselect,
                                  sys_timer_s1_irq_from_sa,
                                  sys_timer_s1_readdata_from_sa,
                                  sys_timer_s1_reset_n,
                                  sys_timer_s1_write_n,
                                  sys_timer_s1_writedata
                               )
;

  output           cpu_data_master_granted_sys_timer_s1;
  output           cpu_data_master_qualified_request_sys_timer_s1;
  output           cpu_data_master_read_data_valid_sys_timer_s1;
  output           cpu_data_master_requests_sys_timer_s1;
  output           d1_sys_timer_s1_end_xfer;
  output  [  2: 0] sys_timer_s1_address;
  output           sys_timer_s1_chipselect;
  output           sys_timer_s1_irq_from_sa;
  output  [ 15: 0] sys_timer_s1_readdata_from_sa;
  output           sys_timer_s1_reset_n;
  output           sys_timer_s1_write_n;
  output  [ 15: 0] sys_timer_s1_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;
  input            sys_timer_s1_irq;
  input   [ 15: 0] sys_timer_s1_readdata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sys_timer_s1;
  wire             cpu_data_master_qualified_request_sys_timer_s1;
  wire             cpu_data_master_read_data_valid_sys_timer_s1;
  wire             cpu_data_master_requests_sys_timer_s1;
  wire             cpu_data_master_saved_grant_sys_timer_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sys_timer_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sys_timer_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_sys_timer_s1_from_cpu_data_master;
  wire    [  2: 0] sys_timer_s1_address;
  wire             sys_timer_s1_allgrants;
  wire             sys_timer_s1_allow_new_arb_cycle;
  wire             sys_timer_s1_any_bursting_master_saved_grant;
  wire             sys_timer_s1_any_continuerequest;
  wire             sys_timer_s1_arb_counter_enable;
  reg     [  1: 0] sys_timer_s1_arb_share_counter;
  wire    [  1: 0] sys_timer_s1_arb_share_counter_next_value;
  wire    [  1: 0] sys_timer_s1_arb_share_set_values;
  wire             sys_timer_s1_beginbursttransfer_internal;
  wire             sys_timer_s1_begins_xfer;
  wire             sys_timer_s1_chipselect;
  wire             sys_timer_s1_end_xfer;
  wire             sys_timer_s1_firsttransfer;
  wire             sys_timer_s1_grant_vector;
  wire             sys_timer_s1_in_a_read_cycle;
  wire             sys_timer_s1_in_a_write_cycle;
  wire             sys_timer_s1_irq_from_sa;
  wire             sys_timer_s1_master_qreq_vector;
  wire             sys_timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] sys_timer_s1_readdata_from_sa;
  reg              sys_timer_s1_reg_firsttransfer;
  wire             sys_timer_s1_reset_n;
  reg              sys_timer_s1_slavearbiterlockenable;
  wire             sys_timer_s1_slavearbiterlockenable2;
  wire             sys_timer_s1_unreg_firsttransfer;
  wire             sys_timer_s1_waits_for_read;
  wire             sys_timer_s1_waits_for_write;
  wire             sys_timer_s1_write_n;
  wire    [ 15: 0] sys_timer_s1_writedata;
  wire             wait_for_sys_timer_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sys_timer_s1_end_xfer;
    end


  assign sys_timer_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_sys_timer_s1));
  //assign sys_timer_s1_readdata_from_sa = sys_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sys_timer_s1_readdata_from_sa = sys_timer_s1_readdata;

  assign cpu_data_master_requests_sys_timer_s1 = ({cpu_data_master_address_to_slave[26 : 5] , 5'b0} == 27'h5201cc0) & (cpu_data_master_read | cpu_data_master_write);
  //sys_timer_s1_arb_share_counter set values, which is an e_mux
  assign sys_timer_s1_arb_share_set_values = 1;

  //sys_timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign sys_timer_s1_non_bursting_master_requests = cpu_data_master_requests_sys_timer_s1;

  //sys_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sys_timer_s1_any_bursting_master_saved_grant = 0;

  //sys_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sys_timer_s1_arb_share_counter_next_value = sys_timer_s1_firsttransfer ? (sys_timer_s1_arb_share_set_values - 1) : |sys_timer_s1_arb_share_counter ? (sys_timer_s1_arb_share_counter - 1) : 0;

  //sys_timer_s1_allgrants all slave grants, which is an e_mux
  assign sys_timer_s1_allgrants = |sys_timer_s1_grant_vector;

  //sys_timer_s1_end_xfer assignment, which is an e_assign
  assign sys_timer_s1_end_xfer = ~(sys_timer_s1_waits_for_read | sys_timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sys_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sys_timer_s1 = sys_timer_s1_end_xfer & (~sys_timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sys_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sys_timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sys_timer_s1 & sys_timer_s1_allgrants) | (end_xfer_arb_share_counter_term_sys_timer_s1 & ~sys_timer_s1_non_bursting_master_requests);

  //sys_timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_timer_s1_arb_share_counter <= 0;
      else if (sys_timer_s1_arb_counter_enable)
          sys_timer_s1_arb_share_counter <= sys_timer_s1_arb_share_counter_next_value;
    end


  //sys_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_timer_s1_slavearbiterlockenable <= 0;
      else if ((|sys_timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sys_timer_s1) | (end_xfer_arb_share_counter_term_sys_timer_s1 & ~sys_timer_s1_non_bursting_master_requests))
          sys_timer_s1_slavearbiterlockenable <= |sys_timer_s1_arb_share_counter_next_value;
    end


  //cpu/data_master sys_timer/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sys_timer_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //sys_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sys_timer_s1_slavearbiterlockenable2 = |sys_timer_s1_arb_share_counter_next_value;

  //cpu/data_master sys_timer/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sys_timer_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sys_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sys_timer_s1_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_sys_timer_s1 = cpu_data_master_requests_sys_timer_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_sys_timer_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_sys_timer_s1 = cpu_data_master_granted_sys_timer_s1 & cpu_data_master_read & ~sys_timer_s1_waits_for_read;

  //sys_timer_s1_writedata mux, which is an e_mux
  assign sys_timer_s1_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_sys_timer_s1 = cpu_data_master_qualified_request_sys_timer_s1;

  //cpu/data_master saved-grant sys_timer/s1, which is an e_assign
  assign cpu_data_master_saved_grant_sys_timer_s1 = cpu_data_master_requests_sys_timer_s1;

  //allow new arb cycle for sys_timer/s1, which is an e_assign
  assign sys_timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sys_timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sys_timer_s1_master_qreq_vector = 1;

  //sys_timer_s1_reset_n assignment, which is an e_assign
  assign sys_timer_s1_reset_n = reset_n;

  assign sys_timer_s1_chipselect = cpu_data_master_granted_sys_timer_s1;
  //sys_timer_s1_firsttransfer first transaction, which is an e_assign
  assign sys_timer_s1_firsttransfer = sys_timer_s1_begins_xfer ? sys_timer_s1_unreg_firsttransfer : sys_timer_s1_reg_firsttransfer;

  //sys_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sys_timer_s1_unreg_firsttransfer = ~(sys_timer_s1_slavearbiterlockenable & sys_timer_s1_any_continuerequest);

  //sys_timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_timer_s1_reg_firsttransfer <= 1'b1;
      else if (sys_timer_s1_begins_xfer)
          sys_timer_s1_reg_firsttransfer <= sys_timer_s1_unreg_firsttransfer;
    end


  //sys_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sys_timer_s1_beginbursttransfer_internal = sys_timer_s1_begins_xfer;

  //~sys_timer_s1_write_n assignment, which is an e_mux
  assign sys_timer_s1_write_n = ~(cpu_data_master_granted_sys_timer_s1 & cpu_data_master_write);

  assign shifted_address_to_sys_timer_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //sys_timer_s1_address mux, which is an e_mux
  assign sys_timer_s1_address = shifted_address_to_sys_timer_s1_from_cpu_data_master >> 2;

  //d1_sys_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sys_timer_s1_end_xfer <= 1;
      else 
        d1_sys_timer_s1_end_xfer <= sys_timer_s1_end_xfer;
    end


  //sys_timer_s1_waits_for_read in a cycle, which is an e_mux
  assign sys_timer_s1_waits_for_read = sys_timer_s1_in_a_read_cycle & sys_timer_s1_begins_xfer;

  //sys_timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign sys_timer_s1_in_a_read_cycle = cpu_data_master_granted_sys_timer_s1 & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sys_timer_s1_in_a_read_cycle;

  //sys_timer_s1_waits_for_write in a cycle, which is an e_mux
  assign sys_timer_s1_waits_for_write = sys_timer_s1_in_a_write_cycle & 0;

  //sys_timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign sys_timer_s1_in_a_write_cycle = cpu_data_master_granted_sys_timer_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sys_timer_s1_in_a_write_cycle;

  assign wait_for_sys_timer_s1_counter = 0;
  //assign sys_timer_s1_irq_from_sa = sys_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sys_timer_s1_irq_from_sa = sys_timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sys_timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         cpu_data_master_address_to_slave,
                                         cpu_data_master_latency_counter,
                                         cpu_data_master_read,
                                         cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                         cpu_data_master_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         cpu_data_master_granted_sysid_control_slave,
                                         cpu_data_master_qualified_request_sysid_control_slave,
                                         cpu_data_master_read_data_valid_sysid_control_slave,
                                         cpu_data_master_requests_sysid_control_slave,
                                         d1_sysid_control_slave_end_xfer,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa
                                      )
;

  output           cpu_data_master_granted_sysid_control_slave;
  output           cpu_data_master_qualified_request_sysid_control_slave;
  output           cpu_data_master_read_data_valid_sysid_control_slave;
  output           cpu_data_master_requests_sysid_control_slave;
  output           d1_sysid_control_slave_end_xfer;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sysid_control_slave;
  wire             cpu_data_master_qualified_request_sysid_control_slave;
  wire             cpu_data_master_read_data_valid_sysid_control_slave;
  wire             cpu_data_master_requests_sysid_control_slave;
  wire             cpu_data_master_saved_grant_sysid_control_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_sysid_control_slave_from_cpu_data_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg     [  1: 0] sysid_control_slave_arb_share_counter;
  wire    [  1: 0] sysid_control_slave_arb_share_counter_next_value;
  wire    [  1: 0] sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign cpu_data_master_requests_sysid_control_slave = (({cpu_data_master_address_to_slave[26 : 3] , 3'b0} == 27'h5201ce0) & (cpu_data_master_read | cpu_data_master_write)) & cpu_data_master_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = cpu_data_master_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //cpu/data_master sysid/control_slave arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sysid_control_slave_slavearbiterlockenable & cpu_data_master_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //cpu/data_master sysid/control_slave arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_sysid_control_slave = cpu_data_master_requests_sysid_control_slave & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_sysid_control_slave, which is an e_mux
  assign cpu_data_master_read_data_valid_sysid_control_slave = cpu_data_master_granted_sysid_control_slave & cpu_data_master_read & ~sysid_control_slave_waits_for_read;

  //master is always granted when requested
  assign cpu_data_master_granted_sysid_control_slave = cpu_data_master_qualified_request_sysid_control_slave;

  //cpu/data_master saved-grant sysid/control_slave, which is an e_assign
  assign cpu_data_master_saved_grant_sysid_control_slave = cpu_data_master_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  assign shifted_address_to_sysid_control_slave_from_cpu_data_master = cpu_data_master_address_to_slave;
  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = shifted_address_to_sysid_control_slave_from_cpu_data_master >> 2;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else 
        d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = cpu_data_master_granted_sysid_control_slave & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = cpu_data_master_granted_sysid_control_slave & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tse_mac_control_port_arbitrator (
                                         // inputs:
                                          clk,
                                          cpu_data_master_address_to_slave,
                                          cpu_data_master_latency_counter,
                                          cpu_data_master_read,
                                          cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register,
                                          cpu_data_master_write,
                                          cpu_data_master_writedata,
                                          reset_n,
                                          tse_mac_control_port_readdata,
                                          tse_mac_control_port_waitrequest,

                                         // outputs:
                                          cpu_data_master_granted_tse_mac_control_port,
                                          cpu_data_master_qualified_request_tse_mac_control_port,
                                          cpu_data_master_read_data_valid_tse_mac_control_port,
                                          cpu_data_master_requests_tse_mac_control_port,
                                          d1_tse_mac_control_port_end_xfer,
                                          tse_mac_control_port_address,
                                          tse_mac_control_port_read,
                                          tse_mac_control_port_readdata_from_sa,
                                          tse_mac_control_port_reset,
                                          tse_mac_control_port_waitrequest_from_sa,
                                          tse_mac_control_port_write,
                                          tse_mac_control_port_writedata
                                       )
;

  output           cpu_data_master_granted_tse_mac_control_port;
  output           cpu_data_master_qualified_request_tse_mac_control_port;
  output           cpu_data_master_read_data_valid_tse_mac_control_port;
  output           cpu_data_master_requests_tse_mac_control_port;
  output           d1_tse_mac_control_port_end_xfer;
  output  [  7: 0] tse_mac_control_port_address;
  output           tse_mac_control_port_read;
  output  [ 31: 0] tse_mac_control_port_readdata_from_sa;
  output           tse_mac_control_port_reset;
  output           tse_mac_control_port_waitrequest_from_sa;
  output           tse_mac_control_port_write;
  output  [ 31: 0] tse_mac_control_port_writedata;
  input            clk;
  input   [ 26: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] tse_mac_control_port_readdata;
  input            tse_mac_control_port_waitrequest;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_tse_mac_control_port;
  wire             cpu_data_master_qualified_request_tse_mac_control_port;
  wire             cpu_data_master_read_data_valid_tse_mac_control_port;
  wire             cpu_data_master_requests_tse_mac_control_port;
  wire             cpu_data_master_saved_grant_tse_mac_control_port;
  reg              d1_reasons_to_wait;
  reg              d1_tse_mac_control_port_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tse_mac_control_port;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 26: 0] shifted_address_to_tse_mac_control_port_from_cpu_data_master;
  wire    [  7: 0] tse_mac_control_port_address;
  wire             tse_mac_control_port_allgrants;
  wire             tse_mac_control_port_allow_new_arb_cycle;
  wire             tse_mac_control_port_any_bursting_master_saved_grant;
  wire             tse_mac_control_port_any_continuerequest;
  wire             tse_mac_control_port_arb_counter_enable;
  reg     [  1: 0] tse_mac_control_port_arb_share_counter;
  wire    [  1: 0] tse_mac_control_port_arb_share_counter_next_value;
  wire    [  1: 0] tse_mac_control_port_arb_share_set_values;
  wire             tse_mac_control_port_beginbursttransfer_internal;
  wire             tse_mac_control_port_begins_xfer;
  wire             tse_mac_control_port_end_xfer;
  wire             tse_mac_control_port_firsttransfer;
  wire             tse_mac_control_port_grant_vector;
  wire             tse_mac_control_port_in_a_read_cycle;
  wire             tse_mac_control_port_in_a_write_cycle;
  wire             tse_mac_control_port_master_qreq_vector;
  wire             tse_mac_control_port_non_bursting_master_requests;
  wire             tse_mac_control_port_read;
  wire    [ 31: 0] tse_mac_control_port_readdata_from_sa;
  reg              tse_mac_control_port_reg_firsttransfer;
  wire             tse_mac_control_port_reset;
  reg              tse_mac_control_port_slavearbiterlockenable;
  wire             tse_mac_control_port_slavearbiterlockenable2;
  wire             tse_mac_control_port_unreg_firsttransfer;
  wire             tse_mac_control_port_waitrequest_from_sa;
  wire             tse_mac_control_port_waits_for_read;
  wire             tse_mac_control_port_waits_for_write;
  wire             tse_mac_control_port_write;
  wire    [ 31: 0] tse_mac_control_port_writedata;
  wire             wait_for_tse_mac_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tse_mac_control_port_end_xfer;
    end


  assign tse_mac_control_port_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_tse_mac_control_port));
  //assign tse_mac_control_port_readdata_from_sa = tse_mac_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tse_mac_control_port_readdata_from_sa = tse_mac_control_port_readdata;

  assign cpu_data_master_requests_tse_mac_control_port = ({cpu_data_master_address_to_slave[26 : 10] , 10'b0} == 27'h5201800) & (cpu_data_master_read | cpu_data_master_write);
  //assign tse_mac_control_port_waitrequest_from_sa = tse_mac_control_port_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tse_mac_control_port_waitrequest_from_sa = tse_mac_control_port_waitrequest;

  //tse_mac_control_port_arb_share_counter set values, which is an e_mux
  assign tse_mac_control_port_arb_share_set_values = 1;

  //tse_mac_control_port_non_bursting_master_requests mux, which is an e_mux
  assign tse_mac_control_port_non_bursting_master_requests = cpu_data_master_requests_tse_mac_control_port;

  //tse_mac_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign tse_mac_control_port_any_bursting_master_saved_grant = 0;

  //tse_mac_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign tse_mac_control_port_arb_share_counter_next_value = tse_mac_control_port_firsttransfer ? (tse_mac_control_port_arb_share_set_values - 1) : |tse_mac_control_port_arb_share_counter ? (tse_mac_control_port_arb_share_counter - 1) : 0;

  //tse_mac_control_port_allgrants all slave grants, which is an e_mux
  assign tse_mac_control_port_allgrants = |tse_mac_control_port_grant_vector;

  //tse_mac_control_port_end_xfer assignment, which is an e_assign
  assign tse_mac_control_port_end_xfer = ~(tse_mac_control_port_waits_for_read | tse_mac_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_tse_mac_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tse_mac_control_port = tse_mac_control_port_end_xfer & (~tse_mac_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tse_mac_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign tse_mac_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_tse_mac_control_port & tse_mac_control_port_allgrants) | (end_xfer_arb_share_counter_term_tse_mac_control_port & ~tse_mac_control_port_non_bursting_master_requests);

  //tse_mac_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tse_mac_control_port_arb_share_counter <= 0;
      else if (tse_mac_control_port_arb_counter_enable)
          tse_mac_control_port_arb_share_counter <= tse_mac_control_port_arb_share_counter_next_value;
    end


  //tse_mac_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tse_mac_control_port_slavearbiterlockenable <= 0;
      else if ((|tse_mac_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_tse_mac_control_port) | (end_xfer_arb_share_counter_term_tse_mac_control_port & ~tse_mac_control_port_non_bursting_master_requests))
          tse_mac_control_port_slavearbiterlockenable <= |tse_mac_control_port_arb_share_counter_next_value;
    end


  //cpu/data_master tse_mac/control_port arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = tse_mac_control_port_slavearbiterlockenable & cpu_data_master_continuerequest;

  //tse_mac_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tse_mac_control_port_slavearbiterlockenable2 = |tse_mac_control_port_arb_share_counter_next_value;

  //cpu/data_master tse_mac/control_port arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = tse_mac_control_port_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //tse_mac_control_port_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tse_mac_control_port_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_tse_mac_control_port = cpu_data_master_requests_tse_mac_control_port & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_tse_mac_control_port, which is an e_mux
  assign cpu_data_master_read_data_valid_tse_mac_control_port = cpu_data_master_granted_tse_mac_control_port & cpu_data_master_read & ~tse_mac_control_port_waits_for_read;

  //tse_mac_control_port_writedata mux, which is an e_mux
  assign tse_mac_control_port_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_tse_mac_control_port = cpu_data_master_qualified_request_tse_mac_control_port;

  //cpu/data_master saved-grant tse_mac/control_port, which is an e_assign
  assign cpu_data_master_saved_grant_tse_mac_control_port = cpu_data_master_requests_tse_mac_control_port;

  //allow new arb cycle for tse_mac/control_port, which is an e_assign
  assign tse_mac_control_port_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tse_mac_control_port_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tse_mac_control_port_master_qreq_vector = 1;

  //~tse_mac_control_port_reset assignment, which is an e_assign
  assign tse_mac_control_port_reset = ~reset_n;

  //tse_mac_control_port_firsttransfer first transaction, which is an e_assign
  assign tse_mac_control_port_firsttransfer = tse_mac_control_port_begins_xfer ? tse_mac_control_port_unreg_firsttransfer : tse_mac_control_port_reg_firsttransfer;

  //tse_mac_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign tse_mac_control_port_unreg_firsttransfer = ~(tse_mac_control_port_slavearbiterlockenable & tse_mac_control_port_any_continuerequest);

  //tse_mac_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tse_mac_control_port_reg_firsttransfer <= 1'b1;
      else if (tse_mac_control_port_begins_xfer)
          tse_mac_control_port_reg_firsttransfer <= tse_mac_control_port_unreg_firsttransfer;
    end


  //tse_mac_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tse_mac_control_port_beginbursttransfer_internal = tse_mac_control_port_begins_xfer;

  //tse_mac_control_port_read assignment, which is an e_mux
  assign tse_mac_control_port_read = cpu_data_master_granted_tse_mac_control_port & cpu_data_master_read;

  //tse_mac_control_port_write assignment, which is an e_mux
  assign tse_mac_control_port_write = cpu_data_master_granted_tse_mac_control_port & cpu_data_master_write;

  assign shifted_address_to_tse_mac_control_port_from_cpu_data_master = cpu_data_master_address_to_slave;
  //tse_mac_control_port_address mux, which is an e_mux
  assign tse_mac_control_port_address = shifted_address_to_tse_mac_control_port_from_cpu_data_master >> 2;

  //d1_tse_mac_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tse_mac_control_port_end_xfer <= 1;
      else 
        d1_tse_mac_control_port_end_xfer <= tse_mac_control_port_end_xfer;
    end


  //tse_mac_control_port_waits_for_read in a cycle, which is an e_mux
  assign tse_mac_control_port_waits_for_read = tse_mac_control_port_in_a_read_cycle & tse_mac_control_port_waitrequest_from_sa;

  //tse_mac_control_port_in_a_read_cycle assignment, which is an e_assign
  assign tse_mac_control_port_in_a_read_cycle = cpu_data_master_granted_tse_mac_control_port & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tse_mac_control_port_in_a_read_cycle;

  //tse_mac_control_port_waits_for_write in a cycle, which is an e_mux
  assign tse_mac_control_port_waits_for_write = tse_mac_control_port_in_a_write_cycle & tse_mac_control_port_waitrequest_from_sa;

  //tse_mac_control_port_in_a_write_cycle assignment, which is an e_assign
  assign tse_mac_control_port_in_a_write_cycle = cpu_data_master_granted_tse_mac_control_port & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tse_mac_control_port_in_a_write_cycle;

  assign wait_for_tse_mac_control_port_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tse_mac/control_port enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tse_mac_transmit_arbitrator (
                                     // inputs:
                                      clk,
                                      reset_n,
                                      sgdma_tx_out_data,
                                      sgdma_tx_out_empty,
                                      sgdma_tx_out_endofpacket,
                                      sgdma_tx_out_error,
                                      sgdma_tx_out_startofpacket,
                                      sgdma_tx_out_valid,
                                      tse_mac_transmit_ready,

                                     // outputs:
                                      tse_mac_transmit_data,
                                      tse_mac_transmit_empty,
                                      tse_mac_transmit_endofpacket,
                                      tse_mac_transmit_error,
                                      tse_mac_transmit_ready_from_sa,
                                      tse_mac_transmit_startofpacket,
                                      tse_mac_transmit_valid
                                   )
;

  output  [ 31: 0] tse_mac_transmit_data;
  output  [  1: 0] tse_mac_transmit_empty;
  output           tse_mac_transmit_endofpacket;
  output           tse_mac_transmit_error;
  output           tse_mac_transmit_ready_from_sa;
  output           tse_mac_transmit_startofpacket;
  output           tse_mac_transmit_valid;
  input            clk;
  input            reset_n;
  input   [ 31: 0] sgdma_tx_out_data;
  input   [  1: 0] sgdma_tx_out_empty;
  input            sgdma_tx_out_endofpacket;
  input            sgdma_tx_out_error;
  input            sgdma_tx_out_startofpacket;
  input            sgdma_tx_out_valid;
  input            tse_mac_transmit_ready;

  wire    [ 31: 0] tse_mac_transmit_data;
  wire    [  1: 0] tse_mac_transmit_empty;
  wire             tse_mac_transmit_endofpacket;
  wire             tse_mac_transmit_error;
  wire             tse_mac_transmit_ready_from_sa;
  wire             tse_mac_transmit_startofpacket;
  wire             tse_mac_transmit_valid;
  //mux tse_mac_transmit_data, which is an e_mux
  assign tse_mac_transmit_data = sgdma_tx_out_data;

  //mux tse_mac_transmit_endofpacket, which is an e_mux
  assign tse_mac_transmit_endofpacket = sgdma_tx_out_endofpacket;

  //mux tse_mac_transmit_error, which is an e_mux
  assign tse_mac_transmit_error = sgdma_tx_out_error;

  //mux tse_mac_transmit_empty, which is an e_mux
  assign tse_mac_transmit_empty = sgdma_tx_out_empty;

  //assign tse_mac_transmit_ready_from_sa = tse_mac_transmit_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tse_mac_transmit_ready_from_sa = tse_mac_transmit_ready;

  //mux tse_mac_transmit_startofpacket, which is an e_mux
  assign tse_mac_transmit_startofpacket = sgdma_tx_out_startofpacket;

  //mux tse_mac_transmit_valid, which is an e_mux
  assign tse_mac_transmit_valid = sgdma_tx_out_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tse_mac_receive_arbitrator (
                                    // inputs:
                                     clk,
                                     reset_n,
                                     sgdma_rx_in_ready_from_sa,
                                     tse_mac_receive_data,
                                     tse_mac_receive_empty,
                                     tse_mac_receive_endofpacket,
                                     tse_mac_receive_error,
                                     tse_mac_receive_startofpacket,
                                     tse_mac_receive_valid,

                                    // outputs:
                                     tse_mac_receive_ready
                                  )
;

  output           tse_mac_receive_ready;
  input            clk;
  input            reset_n;
  input            sgdma_rx_in_ready_from_sa;
  input   [ 31: 0] tse_mac_receive_data;
  input   [  1: 0] tse_mac_receive_empty;
  input            tse_mac_receive_endofpacket;
  input   [  5: 0] tse_mac_receive_error;
  input            tse_mac_receive_startofpacket;
  input            tse_mac_receive_valid;

  wire             tse_mac_receive_ready;
  //mux tse_mac_receive_ready, which is an e_mux
  assign tse_mac_receive_ready = sgdma_rx_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_reset_pll_peripheral_clk_domain_synch_module (
                                                               // inputs:
                                                                clk,
                                                                data_in,
                                                                reset_n,

                                                               // outputs:
                                                                data_out
                                                             )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_reset_pll_sys_clk_domain_synch_module (
                                                        // inputs:
                                                         clk,
                                                         data_in,
                                                         reset_n,

                                                        // outputs:
                                                         data_out
                                                      )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC_reset_ext_clk_domain_synch_module (
                                                    // inputs:
                                                     clk,
                                                     data_in,
                                                     reset_n,

                                                    // outputs:
                                                     data_out
                                                  )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE4_SOPC (
                  // 1) global signals:
                   ext_clk,
                   pll_peripheral_clk,
                   pll_sys_clk,
                   reset_n,

                  // the_ADC_data_pio
                   in_port_to_the_ADC_data_pio,

                  // the_acq_busy_pio
                   in_port_to_the_acq_busy_pio,

                  // the_flash_tristate_bridge_avalon_slave
                   flash_tristate_bridge_address,
                   flash_tristate_bridge_data,
                   flash_tristate_bridge_readn,
                   flash_tristate_bridge_writen,
                   select_n_to_the_ext_flash,

                  // the_led_pio
                   out_port_from_the_led_pio,

                  // the_pb_pio
                   in_port_to_the_pb_pio,

                  // the_read_RAM_address
                   out_port_from_the_read_RAM_address,

                  // the_read_RAM_busy_pio
                   out_port_from_the_read_RAM_busy_pio,

                  // the_seven_seg_pio
                   out_port_from_the_seven_seg_pio,

                  // the_sw_pio
                   in_port_to_the_sw_pio,

                  // the_tse_mac
                   led_an_from_the_tse_mac,
                   led_char_err_from_the_tse_mac,
                   led_col_from_the_tse_mac,
                   led_crs_from_the_tse_mac,
                   led_disp_err_from_the_tse_mac,
                   led_link_from_the_tse_mac,
                   mdc_from_the_tse_mac,
                   mdio_in_to_the_tse_mac,
                   mdio_oen_from_the_tse_mac,
                   mdio_out_from_the_tse_mac,
                   ref_clk_to_the_tse_mac,
                   rxp_to_the_tse_mac,
                   txp_from_the_tse_mac
                )
;

  output  [ 24: 0] flash_tristate_bridge_address;
  inout   [ 15: 0] flash_tristate_bridge_data;
  output           flash_tristate_bridge_readn;
  output           flash_tristate_bridge_writen;
  output           led_an_from_the_tse_mac;
  output           led_char_err_from_the_tse_mac;
  output           led_col_from_the_tse_mac;
  output           led_crs_from_the_tse_mac;
  output           led_disp_err_from_the_tse_mac;
  output           led_link_from_the_tse_mac;
  output           mdc_from_the_tse_mac;
  output           mdio_oen_from_the_tse_mac;
  output           mdio_out_from_the_tse_mac;
  output  [  7: 0] out_port_from_the_led_pio;
  output  [ 10: 0] out_port_from_the_read_RAM_address;
  output           out_port_from_the_read_RAM_busy_pio;
  output  [ 15: 0] out_port_from_the_seven_seg_pio;
  output           pll_peripheral_clk;
  output           pll_sys_clk;
  output           select_n_to_the_ext_flash;
  output           txp_from_the_tse_mac;
  input            ext_clk;
  input   [ 15: 0] in_port_to_the_ADC_data_pio;
  input            in_port_to_the_acq_busy_pio;
  input   [  3: 0] in_port_to_the_pb_pio;
  input   [  7: 0] in_port_to_the_sw_pio;
  input            mdio_in_to_the_tse_mac;
  input            ref_clk_to_the_tse_mac;
  input            reset_n;
  input            rxp_to_the_tse_mac;

  wire    [  1: 0] ADC_data_pio_s1_address;
  wire    [ 15: 0] ADC_data_pio_s1_readdata;
  wire    [ 15: 0] ADC_data_pio_s1_readdata_from_sa;
  wire             ADC_data_pio_s1_reset_n;
  wire    [  3: 0] DE4_SOPC_clock_0_in_address;
  wire    [  1: 0] DE4_SOPC_clock_0_in_byteenable;
  wire             DE4_SOPC_clock_0_in_endofpacket;
  wire             DE4_SOPC_clock_0_in_endofpacket_from_sa;
  wire    [  2: 0] DE4_SOPC_clock_0_in_nativeaddress;
  wire             DE4_SOPC_clock_0_in_read;
  wire    [ 15: 0] DE4_SOPC_clock_0_in_readdata;
  wire    [ 15: 0] DE4_SOPC_clock_0_in_readdata_from_sa;
  wire             DE4_SOPC_clock_0_in_reset_n;
  wire             DE4_SOPC_clock_0_in_waitrequest;
  wire             DE4_SOPC_clock_0_in_waitrequest_from_sa;
  wire             DE4_SOPC_clock_0_in_write;
  wire    [ 15: 0] DE4_SOPC_clock_0_in_writedata;
  wire    [  3: 0] DE4_SOPC_clock_0_out_address;
  wire    [  3: 0] DE4_SOPC_clock_0_out_address_to_slave;
  wire    [  1: 0] DE4_SOPC_clock_0_out_byteenable;
  wire             DE4_SOPC_clock_0_out_endofpacket;
  wire             DE4_SOPC_clock_0_out_granted_pll_s1;
  wire    [  2: 0] DE4_SOPC_clock_0_out_nativeaddress;
  wire             DE4_SOPC_clock_0_out_qualified_request_pll_s1;
  wire             DE4_SOPC_clock_0_out_read;
  wire             DE4_SOPC_clock_0_out_read_data_valid_pll_s1;
  wire    [ 15: 0] DE4_SOPC_clock_0_out_readdata;
  wire             DE4_SOPC_clock_0_out_requests_pll_s1;
  wire             DE4_SOPC_clock_0_out_reset_n;
  wire             DE4_SOPC_clock_0_out_waitrequest;
  wire             DE4_SOPC_clock_0_out_write;
  wire    [ 15: 0] DE4_SOPC_clock_0_out_writedata;
  wire    [  2: 0] DE4_SOPC_clock_1_in_address;
  wire    [  3: 0] DE4_SOPC_clock_1_in_byteenable;
  wire             DE4_SOPC_clock_1_in_endofpacket;
  wire             DE4_SOPC_clock_1_in_endofpacket_from_sa;
  wire             DE4_SOPC_clock_1_in_nativeaddress;
  wire             DE4_SOPC_clock_1_in_read;
  wire    [ 31: 0] DE4_SOPC_clock_1_in_readdata;
  wire    [ 31: 0] DE4_SOPC_clock_1_in_readdata_from_sa;
  wire             DE4_SOPC_clock_1_in_reset_n;
  wire             DE4_SOPC_clock_1_in_waitrequest;
  wire             DE4_SOPC_clock_1_in_waitrequest_from_sa;
  wire             DE4_SOPC_clock_1_in_write;
  wire    [ 31: 0] DE4_SOPC_clock_1_in_writedata;
  wire    [  2: 0] DE4_SOPC_clock_1_out_address;
  wire    [  2: 0] DE4_SOPC_clock_1_out_address_to_slave;
  wire    [  3: 0] DE4_SOPC_clock_1_out_byteenable;
  wire             DE4_SOPC_clock_1_out_endofpacket;
  wire             DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_nativeaddress;
  wire             DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_read;
  wire             DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire    [ 31: 0] DE4_SOPC_clock_1_out_readdata;
  wire             DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave;
  wire             DE4_SOPC_clock_1_out_reset_n;
  wire             DE4_SOPC_clock_1_out_waitrequest;
  wire             DE4_SOPC_clock_1_out_write;
  wire    [ 31: 0] DE4_SOPC_clock_1_out_writedata;
  wire    [  1: 0] acq_busy_pio_s1_address;
  wire             acq_busy_pio_s1_readdata;
  wire             acq_busy_pio_s1_readdata_from_sa;
  wire             acq_busy_pio_s1_reset_n;
  wire    [ 26: 0] cpu_data_master_address;
  wire    [ 26: 0] cpu_data_master_address_to_slave;
  wire    [  3: 0] cpu_data_master_byteenable;
  wire    [  1: 0] cpu_data_master_byteenable_ext_flash_s1;
  wire    [  1: 0] cpu_data_master_dbs_address;
  wire    [ 15: 0] cpu_data_master_dbs_write_16;
  wire             cpu_data_master_debugaccess;
  wire             cpu_data_master_granted_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_granted_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_granted_cpu_jtag_debug_module;
  wire             cpu_data_master_granted_descriptor_memory_s1;
  wire             cpu_data_master_granted_ext_flash_s1;
  wire             cpu_data_master_granted_high_res_timer_s1;
  wire             cpu_data_master_granted_onchip_memory_s1;
  wire             cpu_data_master_granted_peripheral_clock_crossing_s1;
  wire             cpu_data_master_granted_sgdma_rx_csr;
  wire             cpu_data_master_granted_sgdma_tx_csr;
  wire             cpu_data_master_granted_sys_timer_s1;
  wire             cpu_data_master_granted_sysid_control_slave;
  wire             cpu_data_master_granted_tse_mac_control_port;
  wire    [ 31: 0] cpu_data_master_irq;
  wire    [  1: 0] cpu_data_master_latency_counter;
  wire             cpu_data_master_qualified_request_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_qualified_request_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_data_master_qualified_request_descriptor_memory_s1;
  wire             cpu_data_master_qualified_request_ext_flash_s1;
  wire             cpu_data_master_qualified_request_high_res_timer_s1;
  wire             cpu_data_master_qualified_request_onchip_memory_s1;
  wire             cpu_data_master_qualified_request_peripheral_clock_crossing_s1;
  wire             cpu_data_master_qualified_request_sgdma_rx_csr;
  wire             cpu_data_master_qualified_request_sgdma_tx_csr;
  wire             cpu_data_master_qualified_request_sys_timer_s1;
  wire             cpu_data_master_qualified_request_sysid_control_slave;
  wire             cpu_data_master_qualified_request_tse_mac_control_port;
  wire             cpu_data_master_read;
  wire             cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_data_master_read_data_valid_descriptor_memory_s1;
  wire             cpu_data_master_read_data_valid_ext_flash_s1;
  wire             cpu_data_master_read_data_valid_high_res_timer_s1;
  wire             cpu_data_master_read_data_valid_onchip_memory_s1;
  wire             cpu_data_master_read_data_valid_peripheral_clock_crossing_s1;
  wire             cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register;
  wire             cpu_data_master_read_data_valid_sgdma_rx_csr;
  wire             cpu_data_master_read_data_valid_sgdma_tx_csr;
  wire             cpu_data_master_read_data_valid_sys_timer_s1;
  wire             cpu_data_master_read_data_valid_sysid_control_slave;
  wire             cpu_data_master_read_data_valid_tse_mac_control_port;
  wire    [ 31: 0] cpu_data_master_readdata;
  wire             cpu_data_master_readdatavalid;
  wire             cpu_data_master_requests_DE4_SOPC_clock_0_in;
  wire             cpu_data_master_requests_DE4_SOPC_clock_1_in;
  wire             cpu_data_master_requests_cpu_jtag_debug_module;
  wire             cpu_data_master_requests_descriptor_memory_s1;
  wire             cpu_data_master_requests_ext_flash_s1;
  wire             cpu_data_master_requests_high_res_timer_s1;
  wire             cpu_data_master_requests_onchip_memory_s1;
  wire             cpu_data_master_requests_peripheral_clock_crossing_s1;
  wire             cpu_data_master_requests_sgdma_rx_csr;
  wire             cpu_data_master_requests_sgdma_tx_csr;
  wire             cpu_data_master_requests_sys_timer_s1;
  wire             cpu_data_master_requests_sysid_control_slave;
  wire             cpu_data_master_requests_tse_mac_control_port;
  wire             cpu_data_master_waitrequest;
  wire             cpu_data_master_write;
  wire    [ 31: 0] cpu_data_master_writedata;
  wire    [ 26: 0] cpu_instruction_master_address;
  wire    [ 26: 0] cpu_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_instruction_master_dbs_address;
  wire             cpu_instruction_master_granted_cpu_jtag_debug_module;
  wire             cpu_instruction_master_granted_ext_flash_s1;
  wire             cpu_instruction_master_granted_onchip_memory_s1;
  wire    [  1: 0] cpu_instruction_master_latency_counter;
  wire             cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_instruction_master_qualified_request_ext_flash_s1;
  wire             cpu_instruction_master_qualified_request_onchip_memory_s1;
  wire             cpu_instruction_master_read;
  wire             cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1;
  wire             cpu_instruction_master_read_data_valid_onchip_memory_s1;
  wire    [ 31: 0] cpu_instruction_master_readdata;
  wire             cpu_instruction_master_readdatavalid;
  wire             cpu_instruction_master_requests_cpu_jtag_debug_module;
  wire             cpu_instruction_master_requests_ext_flash_s1;
  wire             cpu_instruction_master_requests_onchip_memory_s1;
  wire             cpu_instruction_master_waitrequest;
  wire    [  8: 0] cpu_jtag_debug_module_address;
  wire             cpu_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_jtag_debug_module_byteenable;
  wire             cpu_jtag_debug_module_chipselect;
  wire             cpu_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  wire             cpu_jtag_debug_module_reset_n;
  wire             cpu_jtag_debug_module_resetrequest;
  wire             cpu_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_jtag_debug_module_write;
  wire    [ 31: 0] cpu_jtag_debug_module_writedata;
  wire             d1_ADC_data_pio_s1_end_xfer;
  wire             d1_DE4_SOPC_clock_0_in_end_xfer;
  wire             d1_DE4_SOPC_clock_1_in_end_xfer;
  wire             d1_acq_busy_pio_s1_end_xfer;
  wire             d1_cpu_jtag_debug_module_end_xfer;
  wire             d1_descriptor_memory_s1_end_xfer;
  wire             d1_flash_tristate_bridge_avalon_slave_end_xfer;
  wire             d1_high_res_timer_s1_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_led_pio_s1_end_xfer;
  wire             d1_onchip_memory_s1_end_xfer;
  wire             d1_pb_pio_s1_end_xfer;
  wire             d1_peripheral_clock_crossing_s1_end_xfer;
  wire             d1_pll_s1_end_xfer;
  wire             d1_read_RAM_address_s1_end_xfer;
  wire             d1_read_RAM_busy_pio_s1_end_xfer;
  wire             d1_seven_seg_pio_s1_end_xfer;
  wire             d1_sgdma_rx_csr_end_xfer;
  wire             d1_sgdma_tx_csr_end_xfer;
  wire             d1_sw_pio_s1_end_xfer;
  wire             d1_sys_timer_s1_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_tse_mac_control_port_end_xfer;
  wire    [  8: 0] descriptor_memory_s1_address;
  wire    [  3: 0] descriptor_memory_s1_byteenable;
  wire             descriptor_memory_s1_chipselect;
  wire             descriptor_memory_s1_clken;
  wire    [ 31: 0] descriptor_memory_s1_readdata;
  wire    [ 31: 0] descriptor_memory_s1_readdata_from_sa;
  wire             descriptor_memory_s1_write;
  wire    [ 31: 0] descriptor_memory_s1_writedata;
  wire             ext_clk_reset_n;
  wire             ext_flash_s1_wait_counter_eq_0;
  wire    [ 24: 0] flash_tristate_bridge_address;
  wire    [ 15: 0] flash_tristate_bridge_data;
  wire             flash_tristate_bridge_readn;
  wire             flash_tristate_bridge_writen;
  wire    [  2: 0] high_res_timer_s1_address;
  wire             high_res_timer_s1_chipselect;
  wire             high_res_timer_s1_irq;
  wire             high_res_timer_s1_irq_from_sa;
  wire    [ 15: 0] high_res_timer_s1_readdata;
  wire    [ 15: 0] high_res_timer_s1_readdata_from_sa;
  wire             high_res_timer_s1_reset_n;
  wire             high_res_timer_s1_write_n;
  wire    [ 15: 0] high_res_timer_s1_writedata;
  wire    [ 15: 0] incoming_flash_tristate_bridge_data;
  wire    [ 15: 0] incoming_flash_tristate_bridge_data_with_Xs_converted_to_0;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_irq;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  wire             jtag_uart_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire             led_an_from_the_tse_mac;
  wire             led_char_err_from_the_tse_mac;
  wire             led_col_from_the_tse_mac;
  wire             led_crs_from_the_tse_mac;
  wire             led_disp_err_from_the_tse_mac;
  wire             led_link_from_the_tse_mac;
  wire    [  1: 0] led_pio_s1_address;
  wire             led_pio_s1_chipselect;
  wire    [  7: 0] led_pio_s1_readdata;
  wire    [  7: 0] led_pio_s1_readdata_from_sa;
  wire             led_pio_s1_reset_n;
  wire             led_pio_s1_write_n;
  wire    [  7: 0] led_pio_s1_writedata;
  wire             mdc_from_the_tse_mac;
  wire             mdio_oen_from_the_tse_mac;
  wire             mdio_out_from_the_tse_mac;
  wire    [ 17: 0] onchip_memory_s1_address;
  wire    [  3: 0] onchip_memory_s1_byteenable;
  wire             onchip_memory_s1_chipselect;
  wire             onchip_memory_s1_clken;
  wire    [ 31: 0] onchip_memory_s1_readdata;
  wire    [ 31: 0] onchip_memory_s1_readdata_from_sa;
  wire             onchip_memory_s1_write;
  wire    [ 31: 0] onchip_memory_s1_writedata;
  wire             out_clk_pll_c0;
  wire             out_clk_pll_c1;
  wire    [  7: 0] out_port_from_the_led_pio;
  wire    [ 10: 0] out_port_from_the_read_RAM_address;
  wire             out_port_from_the_read_RAM_busy_pio;
  wire    [ 15: 0] out_port_from_the_seven_seg_pio;
  wire    [  1: 0] pb_pio_s1_address;
  wire    [  3: 0] pb_pio_s1_readdata;
  wire    [  3: 0] pb_pio_s1_readdata_from_sa;
  wire             pb_pio_s1_reset_n;
  wire    [  6: 0] peripheral_clock_crossing_m1_address;
  wire    [  6: 0] peripheral_clock_crossing_m1_address_to_slave;
  wire    [  3: 0] peripheral_clock_crossing_m1_byteenable;
  wire             peripheral_clock_crossing_m1_endofpacket;
  wire             peripheral_clock_crossing_m1_granted_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_led_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_granted_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_latency_counter;
  wire    [  4: 0] peripheral_clock_crossing_m1_nativeaddress;
  wire             peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_led_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_qualified_request_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_read;
  wire             peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_led_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1;
  wire    [ 31: 0] peripheral_clock_crossing_m1_readdata;
  wire             peripheral_clock_crossing_m1_readdatavalid;
  wire             peripheral_clock_crossing_m1_requests_ADC_data_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_acq_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_led_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_pb_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_read_RAM_address_s1;
  wire             peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_seven_seg_pio_s1;
  wire             peripheral_clock_crossing_m1_requests_sw_pio_s1;
  wire             peripheral_clock_crossing_m1_reset_n;
  wire             peripheral_clock_crossing_m1_waitrequest;
  wire             peripheral_clock_crossing_m1_write;
  wire    [ 31: 0] peripheral_clock_crossing_m1_writedata;
  wire    [  4: 0] peripheral_clock_crossing_s1_address;
  wire    [  3: 0] peripheral_clock_crossing_s1_byteenable;
  wire             peripheral_clock_crossing_s1_endofpacket;
  wire             peripheral_clock_crossing_s1_endofpacket_from_sa;
  wire    [  4: 0] peripheral_clock_crossing_s1_nativeaddress;
  wire             peripheral_clock_crossing_s1_read;
  wire    [ 31: 0] peripheral_clock_crossing_s1_readdata;
  wire    [ 31: 0] peripheral_clock_crossing_s1_readdata_from_sa;
  wire             peripheral_clock_crossing_s1_readdatavalid;
  wire             peripheral_clock_crossing_s1_reset_n;
  wire             peripheral_clock_crossing_s1_waitrequest;
  wire             peripheral_clock_crossing_s1_waitrequest_from_sa;
  wire             peripheral_clock_crossing_s1_write;
  wire    [ 31: 0] peripheral_clock_crossing_s1_writedata;
  wire             pll_peripheral_clk;
  wire             pll_peripheral_clk_reset_n;
  wire    [  2: 0] pll_s1_address;
  wire             pll_s1_chipselect;
  wire             pll_s1_read;
  wire    [ 15: 0] pll_s1_readdata;
  wire    [ 15: 0] pll_s1_readdata_from_sa;
  wire             pll_s1_reset_n;
  wire             pll_s1_resetrequest;
  wire             pll_s1_resetrequest_from_sa;
  wire             pll_s1_write;
  wire    [ 15: 0] pll_s1_writedata;
  wire             pll_sys_clk;
  wire             pll_sys_clk_reset_n;
  wire    [  1: 0] read_RAM_address_s1_address;
  wire             read_RAM_address_s1_chipselect;
  wire    [ 10: 0] read_RAM_address_s1_readdata;
  wire    [ 10: 0] read_RAM_address_s1_readdata_from_sa;
  wire             read_RAM_address_s1_reset_n;
  wire             read_RAM_address_s1_write_n;
  wire    [ 10: 0] read_RAM_address_s1_writedata;
  wire    [  1: 0] read_RAM_busy_pio_s1_address;
  wire             read_RAM_busy_pio_s1_chipselect;
  wire             read_RAM_busy_pio_s1_readdata;
  wire             read_RAM_busy_pio_s1_readdata_from_sa;
  wire             read_RAM_busy_pio_s1_reset_n;
  wire             read_RAM_busy_pio_s1_write_n;
  wire             read_RAM_busy_pio_s1_writedata;
  wire             reset_n_sources;
  wire             select_n_to_the_ext_flash;
  wire    [  1: 0] seven_seg_pio_s1_address;
  wire             seven_seg_pio_s1_chipselect;
  wire    [ 15: 0] seven_seg_pio_s1_readdata;
  wire    [ 15: 0] seven_seg_pio_s1_readdata_from_sa;
  wire             seven_seg_pio_s1_reset_n;
  wire             seven_seg_pio_s1_write_n;
  wire    [ 15: 0] seven_seg_pio_s1_writedata;
  wire    [  3: 0] sgdma_rx_csr_address;
  wire             sgdma_rx_csr_chipselect;
  wire             sgdma_rx_csr_irq;
  wire             sgdma_rx_csr_irq_from_sa;
  wire             sgdma_rx_csr_read;
  wire    [ 31: 0] sgdma_rx_csr_readdata;
  wire    [ 31: 0] sgdma_rx_csr_readdata_from_sa;
  wire             sgdma_rx_csr_reset_n;
  wire             sgdma_rx_csr_write;
  wire    [ 31: 0] sgdma_rx_csr_writedata;
  wire    [ 31: 0] sgdma_rx_descriptor_read_address;
  wire    [ 31: 0] sgdma_rx_descriptor_read_address_to_slave;
  wire             sgdma_rx_descriptor_read_granted_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_latency_counter;
  wire             sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_read;
  wire             sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1;
  wire    [ 31: 0] sgdma_rx_descriptor_read_readdata;
  wire             sgdma_rx_descriptor_read_readdatavalid;
  wire             sgdma_rx_descriptor_read_requests_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_read_waitrequest;
  wire    [ 31: 0] sgdma_rx_descriptor_write_address;
  wire    [ 31: 0] sgdma_rx_descriptor_write_address_to_slave;
  wire             sgdma_rx_descriptor_write_granted_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_requests_descriptor_memory_s1;
  wire             sgdma_rx_descriptor_write_waitrequest;
  wire             sgdma_rx_descriptor_write_write;
  wire    [ 31: 0] sgdma_rx_descriptor_write_writedata;
  wire    [ 31: 0] sgdma_rx_in_data;
  wire    [  3: 0] sgdma_rx_in_empty;
  wire             sgdma_rx_in_endofpacket;
  wire    [  5: 0] sgdma_rx_in_error;
  wire             sgdma_rx_in_ready;
  wire             sgdma_rx_in_ready_from_sa;
  wire             sgdma_rx_in_startofpacket;
  wire             sgdma_rx_in_valid;
  wire    [ 31: 0] sgdma_rx_m_write_address;
  wire    [ 31: 0] sgdma_rx_m_write_address_to_slave;
  wire    [  3: 0] sgdma_rx_m_write_byteenable;
  wire             sgdma_rx_m_write_granted_onchip_memory_s1;
  wire             sgdma_rx_m_write_qualified_request_onchip_memory_s1;
  wire             sgdma_rx_m_write_requests_onchip_memory_s1;
  wire             sgdma_rx_m_write_waitrequest;
  wire             sgdma_rx_m_write_write;
  wire    [ 31: 0] sgdma_rx_m_write_writedata;
  wire    [  3: 0] sgdma_tx_csr_address;
  wire             sgdma_tx_csr_chipselect;
  wire             sgdma_tx_csr_irq;
  wire             sgdma_tx_csr_irq_from_sa;
  wire             sgdma_tx_csr_read;
  wire    [ 31: 0] sgdma_tx_csr_readdata;
  wire    [ 31: 0] sgdma_tx_csr_readdata_from_sa;
  wire             sgdma_tx_csr_reset_n;
  wire             sgdma_tx_csr_write;
  wire    [ 31: 0] sgdma_tx_csr_writedata;
  wire    [ 31: 0] sgdma_tx_descriptor_read_address;
  wire    [ 31: 0] sgdma_tx_descriptor_read_address_to_slave;
  wire             sgdma_tx_descriptor_read_granted_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_latency_counter;
  wire             sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_read;
  wire             sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1;
  wire    [ 31: 0] sgdma_tx_descriptor_read_readdata;
  wire             sgdma_tx_descriptor_read_readdatavalid;
  wire             sgdma_tx_descriptor_read_requests_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_read_waitrequest;
  wire    [ 31: 0] sgdma_tx_descriptor_write_address;
  wire    [ 31: 0] sgdma_tx_descriptor_write_address_to_slave;
  wire             sgdma_tx_descriptor_write_granted_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_requests_descriptor_memory_s1;
  wire             sgdma_tx_descriptor_write_waitrequest;
  wire             sgdma_tx_descriptor_write_write;
  wire    [ 31: 0] sgdma_tx_descriptor_write_writedata;
  wire    [ 31: 0] sgdma_tx_m_read_address;
  wire    [ 31: 0] sgdma_tx_m_read_address_to_slave;
  wire             sgdma_tx_m_read_granted_onchip_memory_s1;
  wire             sgdma_tx_m_read_latency_counter;
  wire             sgdma_tx_m_read_qualified_request_onchip_memory_s1;
  wire             sgdma_tx_m_read_read;
  wire             sgdma_tx_m_read_read_data_valid_onchip_memory_s1;
  wire    [ 31: 0] sgdma_tx_m_read_readdata;
  wire             sgdma_tx_m_read_readdatavalid;
  wire             sgdma_tx_m_read_requests_onchip_memory_s1;
  wire             sgdma_tx_m_read_waitrequest;
  wire    [ 31: 0] sgdma_tx_out_data;
  wire    [  1: 0] sgdma_tx_out_empty;
  wire             sgdma_tx_out_endofpacket;
  wire             sgdma_tx_out_error;
  wire             sgdma_tx_out_ready;
  wire             sgdma_tx_out_startofpacket;
  wire             sgdma_tx_out_valid;
  wire    [  1: 0] sw_pio_s1_address;
  wire    [  7: 0] sw_pio_s1_readdata;
  wire    [  7: 0] sw_pio_s1_readdata_from_sa;
  wire             sw_pio_s1_reset_n;
  wire    [  2: 0] sys_timer_s1_address;
  wire             sys_timer_s1_chipselect;
  wire             sys_timer_s1_irq;
  wire             sys_timer_s1_irq_from_sa;
  wire    [ 15: 0] sys_timer_s1_readdata;
  wire    [ 15: 0] sys_timer_s1_readdata_from_sa;
  wire             sys_timer_s1_reset_n;
  wire             sys_timer_s1_write_n;
  wire    [ 15: 0] sys_timer_s1_writedata;
  wire             sysid_control_slave_address;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire    [  7: 0] tse_mac_control_port_address;
  wire             tse_mac_control_port_read;
  wire    [ 31: 0] tse_mac_control_port_readdata;
  wire    [ 31: 0] tse_mac_control_port_readdata_from_sa;
  wire             tse_mac_control_port_reset;
  wire             tse_mac_control_port_waitrequest;
  wire             tse_mac_control_port_waitrequest_from_sa;
  wire             tse_mac_control_port_write;
  wire    [ 31: 0] tse_mac_control_port_writedata;
  wire    [ 31: 0] tse_mac_receive_data;
  wire    [  1: 0] tse_mac_receive_empty;
  wire             tse_mac_receive_endofpacket;
  wire    [  5: 0] tse_mac_receive_error;
  wire             tse_mac_receive_ready;
  wire             tse_mac_receive_startofpacket;
  wire             tse_mac_receive_valid;
  wire    [ 31: 0] tse_mac_transmit_data;
  wire    [  1: 0] tse_mac_transmit_empty;
  wire             tse_mac_transmit_endofpacket;
  wire             tse_mac_transmit_error;
  wire             tse_mac_transmit_ready;
  wire             tse_mac_transmit_ready_from_sa;
  wire             tse_mac_transmit_startofpacket;
  wire             tse_mac_transmit_valid;
  wire             txp_from_the_tse_mac;
  ADC_data_pio_s1_arbitrator the_ADC_data_pio_s1
    (
      .ADC_data_pio_s1_address                                        (ADC_data_pio_s1_address),
      .ADC_data_pio_s1_readdata                                       (ADC_data_pio_s1_readdata),
      .ADC_data_pio_s1_readdata_from_sa                               (ADC_data_pio_s1_readdata_from_sa),
      .ADC_data_pio_s1_reset_n                                        (ADC_data_pio_s1_reset_n),
      .clk                                                            (pll_peripheral_clk),
      .d1_ADC_data_pio_s1_end_xfer                                    (d1_ADC_data_pio_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave                  (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_ADC_data_pio_s1           (peripheral_clock_crossing_m1_granted_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter                   (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                     (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1 (peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_read                              (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_requests_ADC_data_pio_s1          (peripheral_clock_crossing_m1_requests_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_write                             (peripheral_clock_crossing_m1_write),
      .reset_n                                                        (pll_peripheral_clk_reset_n)
    );

  ADC_data_pio the_ADC_data_pio
    (
      .address  (ADC_data_pio_s1_address),
      .clk      (pll_peripheral_clk),
      .in_port  (in_port_to_the_ADC_data_pio),
      .readdata (ADC_data_pio_s1_readdata),
      .reset_n  (ADC_data_pio_s1_reset_n)
    );

  DE4_SOPC_clock_0_in_arbitrator the_DE4_SOPC_clock_0_in
    (
      .DE4_SOPC_clock_0_in_address                                                 (DE4_SOPC_clock_0_in_address),
      .DE4_SOPC_clock_0_in_byteenable                                              (DE4_SOPC_clock_0_in_byteenable),
      .DE4_SOPC_clock_0_in_endofpacket                                             (DE4_SOPC_clock_0_in_endofpacket),
      .DE4_SOPC_clock_0_in_endofpacket_from_sa                                     (DE4_SOPC_clock_0_in_endofpacket_from_sa),
      .DE4_SOPC_clock_0_in_nativeaddress                                           (DE4_SOPC_clock_0_in_nativeaddress),
      .DE4_SOPC_clock_0_in_read                                                    (DE4_SOPC_clock_0_in_read),
      .DE4_SOPC_clock_0_in_readdata                                                (DE4_SOPC_clock_0_in_readdata),
      .DE4_SOPC_clock_0_in_readdata_from_sa                                        (DE4_SOPC_clock_0_in_readdata_from_sa),
      .DE4_SOPC_clock_0_in_reset_n                                                 (DE4_SOPC_clock_0_in_reset_n),
      .DE4_SOPC_clock_0_in_waitrequest                                             (DE4_SOPC_clock_0_in_waitrequest),
      .DE4_SOPC_clock_0_in_waitrequest_from_sa                                     (DE4_SOPC_clock_0_in_waitrequest_from_sa),
      .DE4_SOPC_clock_0_in_write                                                   (DE4_SOPC_clock_0_in_write),
      .DE4_SOPC_clock_0_in_writedata                                               (DE4_SOPC_clock_0_in_writedata),
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_granted_DE4_SOPC_clock_0_in                                 (cpu_data_master_granted_DE4_SOPC_clock_0_in),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_DE4_SOPC_clock_0_in                       (cpu_data_master_qualified_request_DE4_SOPC_clock_0_in),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in                         (cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_DE4_SOPC_clock_0_in                                (cpu_data_master_requests_DE4_SOPC_clock_0_in),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_DE4_SOPC_clock_0_in_end_xfer                                             (d1_DE4_SOPC_clock_0_in_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n)
    );

  DE4_SOPC_clock_0_out_arbitrator the_DE4_SOPC_clock_0_out
    (
      .DE4_SOPC_clock_0_out_address                  (DE4_SOPC_clock_0_out_address),
      .DE4_SOPC_clock_0_out_address_to_slave         (DE4_SOPC_clock_0_out_address_to_slave),
      .DE4_SOPC_clock_0_out_byteenable               (DE4_SOPC_clock_0_out_byteenable),
      .DE4_SOPC_clock_0_out_granted_pll_s1           (DE4_SOPC_clock_0_out_granted_pll_s1),
      .DE4_SOPC_clock_0_out_qualified_request_pll_s1 (DE4_SOPC_clock_0_out_qualified_request_pll_s1),
      .DE4_SOPC_clock_0_out_read                     (DE4_SOPC_clock_0_out_read),
      .DE4_SOPC_clock_0_out_read_data_valid_pll_s1   (DE4_SOPC_clock_0_out_read_data_valid_pll_s1),
      .DE4_SOPC_clock_0_out_readdata                 (DE4_SOPC_clock_0_out_readdata),
      .DE4_SOPC_clock_0_out_requests_pll_s1          (DE4_SOPC_clock_0_out_requests_pll_s1),
      .DE4_SOPC_clock_0_out_reset_n                  (DE4_SOPC_clock_0_out_reset_n),
      .DE4_SOPC_clock_0_out_waitrequest              (DE4_SOPC_clock_0_out_waitrequest),
      .DE4_SOPC_clock_0_out_write                    (DE4_SOPC_clock_0_out_write),
      .DE4_SOPC_clock_0_out_writedata                (DE4_SOPC_clock_0_out_writedata),
      .clk                                           (ext_clk),
      .d1_pll_s1_end_xfer                            (d1_pll_s1_end_xfer),
      .pll_s1_readdata_from_sa                       (pll_s1_readdata_from_sa),
      .reset_n                                       (ext_clk_reset_n)
    );

  DE4_SOPC_clock_0 the_DE4_SOPC_clock_0
    (
      .master_address       (DE4_SOPC_clock_0_out_address),
      .master_byteenable    (DE4_SOPC_clock_0_out_byteenable),
      .master_clk           (ext_clk),
      .master_endofpacket   (DE4_SOPC_clock_0_out_endofpacket),
      .master_nativeaddress (DE4_SOPC_clock_0_out_nativeaddress),
      .master_read          (DE4_SOPC_clock_0_out_read),
      .master_readdata      (DE4_SOPC_clock_0_out_readdata),
      .master_reset_n       (DE4_SOPC_clock_0_out_reset_n),
      .master_waitrequest   (DE4_SOPC_clock_0_out_waitrequest),
      .master_write         (DE4_SOPC_clock_0_out_write),
      .master_writedata     (DE4_SOPC_clock_0_out_writedata),
      .slave_address        (DE4_SOPC_clock_0_in_address),
      .slave_byteenable     (DE4_SOPC_clock_0_in_byteenable),
      .slave_clk            (pll_sys_clk),
      .slave_endofpacket    (DE4_SOPC_clock_0_in_endofpacket),
      .slave_nativeaddress  (DE4_SOPC_clock_0_in_nativeaddress),
      .slave_read           (DE4_SOPC_clock_0_in_read),
      .slave_readdata       (DE4_SOPC_clock_0_in_readdata),
      .slave_reset_n        (DE4_SOPC_clock_0_in_reset_n),
      .slave_waitrequest    (DE4_SOPC_clock_0_in_waitrequest),
      .slave_write          (DE4_SOPC_clock_0_in_write),
      .slave_writedata      (DE4_SOPC_clock_0_in_writedata)
    );

  DE4_SOPC_clock_1_in_arbitrator the_DE4_SOPC_clock_1_in
    (
      .DE4_SOPC_clock_1_in_address                                                 (DE4_SOPC_clock_1_in_address),
      .DE4_SOPC_clock_1_in_byteenable                                              (DE4_SOPC_clock_1_in_byteenable),
      .DE4_SOPC_clock_1_in_endofpacket                                             (DE4_SOPC_clock_1_in_endofpacket),
      .DE4_SOPC_clock_1_in_endofpacket_from_sa                                     (DE4_SOPC_clock_1_in_endofpacket_from_sa),
      .DE4_SOPC_clock_1_in_nativeaddress                                           (DE4_SOPC_clock_1_in_nativeaddress),
      .DE4_SOPC_clock_1_in_read                                                    (DE4_SOPC_clock_1_in_read),
      .DE4_SOPC_clock_1_in_readdata                                                (DE4_SOPC_clock_1_in_readdata),
      .DE4_SOPC_clock_1_in_readdata_from_sa                                        (DE4_SOPC_clock_1_in_readdata_from_sa),
      .DE4_SOPC_clock_1_in_reset_n                                                 (DE4_SOPC_clock_1_in_reset_n),
      .DE4_SOPC_clock_1_in_waitrequest                                             (DE4_SOPC_clock_1_in_waitrequest),
      .DE4_SOPC_clock_1_in_waitrequest_from_sa                                     (DE4_SOPC_clock_1_in_waitrequest_from_sa),
      .DE4_SOPC_clock_1_in_write                                                   (DE4_SOPC_clock_1_in_write),
      .DE4_SOPC_clock_1_in_writedata                                               (DE4_SOPC_clock_1_in_writedata),
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_granted_DE4_SOPC_clock_1_in                                 (cpu_data_master_granted_DE4_SOPC_clock_1_in),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_DE4_SOPC_clock_1_in                       (cpu_data_master_qualified_request_DE4_SOPC_clock_1_in),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in                         (cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_DE4_SOPC_clock_1_in                                (cpu_data_master_requests_DE4_SOPC_clock_1_in),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_DE4_SOPC_clock_1_in_end_xfer                                             (d1_DE4_SOPC_clock_1_in_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n)
    );

  DE4_SOPC_clock_1_out_arbitrator the_DE4_SOPC_clock_1_out
    (
      .DE4_SOPC_clock_1_out_address                                       (DE4_SOPC_clock_1_out_address),
      .DE4_SOPC_clock_1_out_address_to_slave                              (DE4_SOPC_clock_1_out_address_to_slave),
      .DE4_SOPC_clock_1_out_byteenable                                    (DE4_SOPC_clock_1_out_byteenable),
      .DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave           (DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave (DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_read                                          (DE4_SOPC_clock_1_out_read),
      .DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave   (DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_readdata                                      (DE4_SOPC_clock_1_out_readdata),
      .DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave          (DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_reset_n                                       (DE4_SOPC_clock_1_out_reset_n),
      .DE4_SOPC_clock_1_out_waitrequest                                   (DE4_SOPC_clock_1_out_waitrequest),
      .DE4_SOPC_clock_1_out_write                                         (DE4_SOPC_clock_1_out_write),
      .DE4_SOPC_clock_1_out_writedata                                     (DE4_SOPC_clock_1_out_writedata),
      .clk                                                                (pll_peripheral_clk),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                            (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                       (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                    (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .reset_n                                                            (pll_peripheral_clk_reset_n)
    );

  DE4_SOPC_clock_1 the_DE4_SOPC_clock_1
    (
      .master_address       (DE4_SOPC_clock_1_out_address),
      .master_byteenable    (DE4_SOPC_clock_1_out_byteenable),
      .master_clk           (pll_peripheral_clk),
      .master_endofpacket   (DE4_SOPC_clock_1_out_endofpacket),
      .master_nativeaddress (DE4_SOPC_clock_1_out_nativeaddress),
      .master_read          (DE4_SOPC_clock_1_out_read),
      .master_readdata      (DE4_SOPC_clock_1_out_readdata),
      .master_reset_n       (DE4_SOPC_clock_1_out_reset_n),
      .master_waitrequest   (DE4_SOPC_clock_1_out_waitrequest),
      .master_write         (DE4_SOPC_clock_1_out_write),
      .master_writedata     (DE4_SOPC_clock_1_out_writedata),
      .slave_address        (DE4_SOPC_clock_1_in_address),
      .slave_byteenable     (DE4_SOPC_clock_1_in_byteenable),
      .slave_clk            (pll_sys_clk),
      .slave_endofpacket    (DE4_SOPC_clock_1_in_endofpacket),
      .slave_nativeaddress  (DE4_SOPC_clock_1_in_nativeaddress),
      .slave_read           (DE4_SOPC_clock_1_in_read),
      .slave_readdata       (DE4_SOPC_clock_1_in_readdata),
      .slave_reset_n        (DE4_SOPC_clock_1_in_reset_n),
      .slave_waitrequest    (DE4_SOPC_clock_1_in_waitrequest),
      .slave_write          (DE4_SOPC_clock_1_in_write),
      .slave_writedata      (DE4_SOPC_clock_1_in_writedata)
    );

  acq_busy_pio_s1_arbitrator the_acq_busy_pio_s1
    (
      .acq_busy_pio_s1_address                                        (acq_busy_pio_s1_address),
      .acq_busy_pio_s1_readdata                                       (acq_busy_pio_s1_readdata),
      .acq_busy_pio_s1_readdata_from_sa                               (acq_busy_pio_s1_readdata_from_sa),
      .acq_busy_pio_s1_reset_n                                        (acq_busy_pio_s1_reset_n),
      .clk                                                            (pll_peripheral_clk),
      .d1_acq_busy_pio_s1_end_xfer                                    (d1_acq_busy_pio_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave                  (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_acq_busy_pio_s1           (peripheral_clock_crossing_m1_granted_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter                   (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                     (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1 (peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_read                              (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_requests_acq_busy_pio_s1          (peripheral_clock_crossing_m1_requests_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_write                             (peripheral_clock_crossing_m1_write),
      .reset_n                                                        (pll_peripheral_clk_reset_n)
    );

  acq_busy_pio the_acq_busy_pio
    (
      .address  (acq_busy_pio_s1_address),
      .clk      (pll_peripheral_clk),
      .in_port  (in_port_to_the_acq_busy_pio),
      .readdata (acq_busy_pio_s1_readdata),
      .reset_n  (acq_busy_pio_s1_reset_n)
    );

  cpu_jtag_debug_module_arbitrator the_cpu_jtag_debug_module
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_debugaccess                                                 (cpu_data_master_debugaccess),
      .cpu_data_master_granted_cpu_jtag_debug_module                               (cpu_data_master_granted_cpu_jtag_debug_module),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_cpu_jtag_debug_module                     (cpu_data_master_qualified_request_cpu_jtag_debug_module),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_cpu_jtag_debug_module                       (cpu_data_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_cpu_jtag_debug_module                              (cpu_data_master_requests_cpu_jtag_debug_module),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .cpu_instruction_master_address_to_slave                                     (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_granted_cpu_jtag_debug_module                        (cpu_instruction_master_granted_cpu_jtag_debug_module),
      .cpu_instruction_master_latency_counter                                      (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_cpu_jtag_debug_module              (cpu_instruction_master_qualified_request_cpu_jtag_debug_module),
      .cpu_instruction_master_read                                                 (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_cpu_jtag_debug_module                (cpu_instruction_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_instruction_master_requests_cpu_jtag_debug_module                       (cpu_instruction_master_requests_cpu_jtag_debug_module),
      .cpu_jtag_debug_module_address                                               (cpu_jtag_debug_module_address),
      .cpu_jtag_debug_module_begintransfer                                         (cpu_jtag_debug_module_begintransfer),
      .cpu_jtag_debug_module_byteenable                                            (cpu_jtag_debug_module_byteenable),
      .cpu_jtag_debug_module_chipselect                                            (cpu_jtag_debug_module_chipselect),
      .cpu_jtag_debug_module_debugaccess                                           (cpu_jtag_debug_module_debugaccess),
      .cpu_jtag_debug_module_readdata                                              (cpu_jtag_debug_module_readdata),
      .cpu_jtag_debug_module_readdata_from_sa                                      (cpu_jtag_debug_module_readdata_from_sa),
      .cpu_jtag_debug_module_reset_n                                               (cpu_jtag_debug_module_reset_n),
      .cpu_jtag_debug_module_resetrequest                                          (cpu_jtag_debug_module_resetrequest),
      .cpu_jtag_debug_module_resetrequest_from_sa                                  (cpu_jtag_debug_module_resetrequest_from_sa),
      .cpu_jtag_debug_module_write                                                 (cpu_jtag_debug_module_write),
      .cpu_jtag_debug_module_writedata                                             (cpu_jtag_debug_module_writedata),
      .d1_cpu_jtag_debug_module_end_xfer                                           (d1_cpu_jtag_debug_module_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n)
    );

  cpu_data_master_arbitrator the_cpu_data_master
    (
      .DE4_SOPC_clock_0_in_readdata_from_sa                                        (DE4_SOPC_clock_0_in_readdata_from_sa),
      .DE4_SOPC_clock_0_in_waitrequest_from_sa                                     (DE4_SOPC_clock_0_in_waitrequest_from_sa),
      .DE4_SOPC_clock_1_in_readdata_from_sa                                        (DE4_SOPC_clock_1_in_readdata_from_sa),
      .DE4_SOPC_clock_1_in_waitrequest_from_sa                                     (DE4_SOPC_clock_1_in_waitrequest_from_sa),
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address                                                     (cpu_data_master_address),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_byteenable_ext_flash_s1                                     (cpu_data_master_byteenable_ext_flash_s1),
      .cpu_data_master_dbs_address                                                 (cpu_data_master_dbs_address),
      .cpu_data_master_dbs_write_16                                                (cpu_data_master_dbs_write_16),
      .cpu_data_master_granted_DE4_SOPC_clock_0_in                                 (cpu_data_master_granted_DE4_SOPC_clock_0_in),
      .cpu_data_master_granted_DE4_SOPC_clock_1_in                                 (cpu_data_master_granted_DE4_SOPC_clock_1_in),
      .cpu_data_master_granted_cpu_jtag_debug_module                               (cpu_data_master_granted_cpu_jtag_debug_module),
      .cpu_data_master_granted_descriptor_memory_s1                                (cpu_data_master_granted_descriptor_memory_s1),
      .cpu_data_master_granted_ext_flash_s1                                        (cpu_data_master_granted_ext_flash_s1),
      .cpu_data_master_granted_high_res_timer_s1                                   (cpu_data_master_granted_high_res_timer_s1),
      .cpu_data_master_granted_onchip_memory_s1                                    (cpu_data_master_granted_onchip_memory_s1),
      .cpu_data_master_granted_peripheral_clock_crossing_s1                        (cpu_data_master_granted_peripheral_clock_crossing_s1),
      .cpu_data_master_granted_sgdma_rx_csr                                        (cpu_data_master_granted_sgdma_rx_csr),
      .cpu_data_master_granted_sgdma_tx_csr                                        (cpu_data_master_granted_sgdma_tx_csr),
      .cpu_data_master_granted_sys_timer_s1                                        (cpu_data_master_granted_sys_timer_s1),
      .cpu_data_master_granted_sysid_control_slave                                 (cpu_data_master_granted_sysid_control_slave),
      .cpu_data_master_granted_tse_mac_control_port                                (cpu_data_master_granted_tse_mac_control_port),
      .cpu_data_master_irq                                                         (cpu_data_master_irq),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_DE4_SOPC_clock_0_in                       (cpu_data_master_qualified_request_DE4_SOPC_clock_0_in),
      .cpu_data_master_qualified_request_DE4_SOPC_clock_1_in                       (cpu_data_master_qualified_request_DE4_SOPC_clock_1_in),
      .cpu_data_master_qualified_request_cpu_jtag_debug_module                     (cpu_data_master_qualified_request_cpu_jtag_debug_module),
      .cpu_data_master_qualified_request_descriptor_memory_s1                      (cpu_data_master_qualified_request_descriptor_memory_s1),
      .cpu_data_master_qualified_request_ext_flash_s1                              (cpu_data_master_qualified_request_ext_flash_s1),
      .cpu_data_master_qualified_request_high_res_timer_s1                         (cpu_data_master_qualified_request_high_res_timer_s1),
      .cpu_data_master_qualified_request_onchip_memory_s1                          (cpu_data_master_qualified_request_onchip_memory_s1),
      .cpu_data_master_qualified_request_peripheral_clock_crossing_s1              (cpu_data_master_qualified_request_peripheral_clock_crossing_s1),
      .cpu_data_master_qualified_request_sgdma_rx_csr                              (cpu_data_master_qualified_request_sgdma_rx_csr),
      .cpu_data_master_qualified_request_sgdma_tx_csr                              (cpu_data_master_qualified_request_sgdma_tx_csr),
      .cpu_data_master_qualified_request_sys_timer_s1                              (cpu_data_master_qualified_request_sys_timer_s1),
      .cpu_data_master_qualified_request_sysid_control_slave                       (cpu_data_master_qualified_request_sysid_control_slave),
      .cpu_data_master_qualified_request_tse_mac_control_port                      (cpu_data_master_qualified_request_tse_mac_control_port),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in                         (cpu_data_master_read_data_valid_DE4_SOPC_clock_0_in),
      .cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in                         (cpu_data_master_read_data_valid_DE4_SOPC_clock_1_in),
      .cpu_data_master_read_data_valid_cpu_jtag_debug_module                       (cpu_data_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_data_master_read_data_valid_descriptor_memory_s1                        (cpu_data_master_read_data_valid_descriptor_memory_s1),
      .cpu_data_master_read_data_valid_ext_flash_s1                                (cpu_data_master_read_data_valid_ext_flash_s1),
      .cpu_data_master_read_data_valid_high_res_timer_s1                           (cpu_data_master_read_data_valid_high_res_timer_s1),
      .cpu_data_master_read_data_valid_onchip_memory_s1                            (cpu_data_master_read_data_valid_onchip_memory_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1                (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_sgdma_rx_csr                                (cpu_data_master_read_data_valid_sgdma_rx_csr),
      .cpu_data_master_read_data_valid_sgdma_tx_csr                                (cpu_data_master_read_data_valid_sgdma_tx_csr),
      .cpu_data_master_read_data_valid_sys_timer_s1                                (cpu_data_master_read_data_valid_sys_timer_s1),
      .cpu_data_master_read_data_valid_sysid_control_slave                         (cpu_data_master_read_data_valid_sysid_control_slave),
      .cpu_data_master_read_data_valid_tse_mac_control_port                        (cpu_data_master_read_data_valid_tse_mac_control_port),
      .cpu_data_master_readdata                                                    (cpu_data_master_readdata),
      .cpu_data_master_readdatavalid                                               (cpu_data_master_readdatavalid),
      .cpu_data_master_requests_DE4_SOPC_clock_0_in                                (cpu_data_master_requests_DE4_SOPC_clock_0_in),
      .cpu_data_master_requests_DE4_SOPC_clock_1_in                                (cpu_data_master_requests_DE4_SOPC_clock_1_in),
      .cpu_data_master_requests_cpu_jtag_debug_module                              (cpu_data_master_requests_cpu_jtag_debug_module),
      .cpu_data_master_requests_descriptor_memory_s1                               (cpu_data_master_requests_descriptor_memory_s1),
      .cpu_data_master_requests_ext_flash_s1                                       (cpu_data_master_requests_ext_flash_s1),
      .cpu_data_master_requests_high_res_timer_s1                                  (cpu_data_master_requests_high_res_timer_s1),
      .cpu_data_master_requests_onchip_memory_s1                                   (cpu_data_master_requests_onchip_memory_s1),
      .cpu_data_master_requests_peripheral_clock_crossing_s1                       (cpu_data_master_requests_peripheral_clock_crossing_s1),
      .cpu_data_master_requests_sgdma_rx_csr                                       (cpu_data_master_requests_sgdma_rx_csr),
      .cpu_data_master_requests_sgdma_tx_csr                                       (cpu_data_master_requests_sgdma_tx_csr),
      .cpu_data_master_requests_sys_timer_s1                                       (cpu_data_master_requests_sys_timer_s1),
      .cpu_data_master_requests_sysid_control_slave                                (cpu_data_master_requests_sysid_control_slave),
      .cpu_data_master_requests_tse_mac_control_port                               (cpu_data_master_requests_tse_mac_control_port),
      .cpu_data_master_waitrequest                                                 (cpu_data_master_waitrequest),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .cpu_jtag_debug_module_readdata_from_sa                                      (cpu_jtag_debug_module_readdata_from_sa),
      .d1_DE4_SOPC_clock_0_in_end_xfer                                             (d1_DE4_SOPC_clock_0_in_end_xfer),
      .d1_DE4_SOPC_clock_1_in_end_xfer                                             (d1_DE4_SOPC_clock_1_in_end_xfer),
      .d1_cpu_jtag_debug_module_end_xfer                                           (d1_cpu_jtag_debug_module_end_xfer),
      .d1_descriptor_memory_s1_end_xfer                                            (d1_descriptor_memory_s1_end_xfer),
      .d1_flash_tristate_bridge_avalon_slave_end_xfer                              (d1_flash_tristate_bridge_avalon_slave_end_xfer),
      .d1_high_res_timer_s1_end_xfer                                               (d1_high_res_timer_s1_end_xfer),
      .d1_onchip_memory_s1_end_xfer                                                (d1_onchip_memory_s1_end_xfer),
      .d1_peripheral_clock_crossing_s1_end_xfer                                    (d1_peripheral_clock_crossing_s1_end_xfer),
      .d1_sgdma_rx_csr_end_xfer                                                    (d1_sgdma_rx_csr_end_xfer),
      .d1_sgdma_tx_csr_end_xfer                                                    (d1_sgdma_tx_csr_end_xfer),
      .d1_sys_timer_s1_end_xfer                                                    (d1_sys_timer_s1_end_xfer),
      .d1_sysid_control_slave_end_xfer                                             (d1_sysid_control_slave_end_xfer),
      .d1_tse_mac_control_port_end_xfer                                            (d1_tse_mac_control_port_end_xfer),
      .descriptor_memory_s1_readdata_from_sa                                       (descriptor_memory_s1_readdata_from_sa),
      .ext_flash_s1_wait_counter_eq_0                                              (ext_flash_s1_wait_counter_eq_0),
      .high_res_timer_s1_irq_from_sa                                               (high_res_timer_s1_irq_from_sa),
      .high_res_timer_s1_readdata_from_sa                                          (high_res_timer_s1_readdata_from_sa),
      .incoming_flash_tristate_bridge_data_with_Xs_converted_to_0                  (incoming_flash_tristate_bridge_data_with_Xs_converted_to_0),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                                     (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .onchip_memory_s1_readdata_from_sa                                           (onchip_memory_s1_readdata_from_sa),
      .peripheral_clock_crossing_s1_readdata_from_sa                               (peripheral_clock_crossing_s1_readdata_from_sa),
      .peripheral_clock_crossing_s1_waitrequest_from_sa                            (peripheral_clock_crossing_s1_waitrequest_from_sa),
      .pll_sys_clk                                                                 (pll_sys_clk),
      .pll_sys_clk_reset_n                                                         (pll_sys_clk_reset_n),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sgdma_rx_csr_irq_from_sa                                                    (sgdma_rx_csr_irq_from_sa),
      .sgdma_rx_csr_readdata_from_sa                                               (sgdma_rx_csr_readdata_from_sa),
      .sgdma_tx_csr_irq_from_sa                                                    (sgdma_tx_csr_irq_from_sa),
      .sgdma_tx_csr_readdata_from_sa                                               (sgdma_tx_csr_readdata_from_sa),
      .sys_timer_s1_irq_from_sa                                                    (sys_timer_s1_irq_from_sa),
      .sys_timer_s1_readdata_from_sa                                               (sys_timer_s1_readdata_from_sa),
      .sysid_control_slave_readdata_from_sa                                        (sysid_control_slave_readdata_from_sa),
      .tse_mac_control_port_readdata_from_sa                                       (tse_mac_control_port_readdata_from_sa),
      .tse_mac_control_port_waitrequest_from_sa                                    (tse_mac_control_port_waitrequest_from_sa)
    );

  cpu_instruction_master_arbitrator the_cpu_instruction_master
    (
      .clk                                                            (pll_sys_clk),
      .cpu_instruction_master_address                                 (cpu_instruction_master_address),
      .cpu_instruction_master_address_to_slave                        (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_dbs_address                             (cpu_instruction_master_dbs_address),
      .cpu_instruction_master_granted_cpu_jtag_debug_module           (cpu_instruction_master_granted_cpu_jtag_debug_module),
      .cpu_instruction_master_granted_ext_flash_s1                    (cpu_instruction_master_granted_ext_flash_s1),
      .cpu_instruction_master_granted_onchip_memory_s1                (cpu_instruction_master_granted_onchip_memory_s1),
      .cpu_instruction_master_latency_counter                         (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_cpu_jtag_debug_module (cpu_instruction_master_qualified_request_cpu_jtag_debug_module),
      .cpu_instruction_master_qualified_request_ext_flash_s1          (cpu_instruction_master_qualified_request_ext_flash_s1),
      .cpu_instruction_master_qualified_request_onchip_memory_s1      (cpu_instruction_master_qualified_request_onchip_memory_s1),
      .cpu_instruction_master_read                                    (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_cpu_jtag_debug_module   (cpu_instruction_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_instruction_master_read_data_valid_ext_flash_s1            (cpu_instruction_master_read_data_valid_ext_flash_s1),
      .cpu_instruction_master_read_data_valid_onchip_memory_s1        (cpu_instruction_master_read_data_valid_onchip_memory_s1),
      .cpu_instruction_master_readdata                                (cpu_instruction_master_readdata),
      .cpu_instruction_master_readdatavalid                           (cpu_instruction_master_readdatavalid),
      .cpu_instruction_master_requests_cpu_jtag_debug_module          (cpu_instruction_master_requests_cpu_jtag_debug_module),
      .cpu_instruction_master_requests_ext_flash_s1                   (cpu_instruction_master_requests_ext_flash_s1),
      .cpu_instruction_master_requests_onchip_memory_s1               (cpu_instruction_master_requests_onchip_memory_s1),
      .cpu_instruction_master_waitrequest                             (cpu_instruction_master_waitrequest),
      .cpu_jtag_debug_module_readdata_from_sa                         (cpu_jtag_debug_module_readdata_from_sa),
      .d1_cpu_jtag_debug_module_end_xfer                              (d1_cpu_jtag_debug_module_end_xfer),
      .d1_flash_tristate_bridge_avalon_slave_end_xfer                 (d1_flash_tristate_bridge_avalon_slave_end_xfer),
      .d1_onchip_memory_s1_end_xfer                                   (d1_onchip_memory_s1_end_xfer),
      .ext_flash_s1_wait_counter_eq_0                                 (ext_flash_s1_wait_counter_eq_0),
      .incoming_flash_tristate_bridge_data                            (incoming_flash_tristate_bridge_data),
      .onchip_memory_s1_readdata_from_sa                              (onchip_memory_s1_readdata_from_sa),
      .reset_n                                                        (pll_sys_clk_reset_n)
    );

  cpu the_cpu
    (
      .clk                                   (pll_sys_clk),
      .d_address                             (cpu_data_master_address),
      .d_byteenable                          (cpu_data_master_byteenable),
      .d_irq                                 (cpu_data_master_irq),
      .d_read                                (cpu_data_master_read),
      .d_readdata                            (cpu_data_master_readdata),
      .d_readdatavalid                       (cpu_data_master_readdatavalid),
      .d_waitrequest                         (cpu_data_master_waitrequest),
      .d_write                               (cpu_data_master_write),
      .d_writedata                           (cpu_data_master_writedata),
      .i_address                             (cpu_instruction_master_address),
      .i_read                                (cpu_instruction_master_read),
      .i_readdata                            (cpu_instruction_master_readdata),
      .i_readdatavalid                       (cpu_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (cpu_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (cpu_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_jtag_debug_module_writedata),
      .reset_n                               (cpu_jtag_debug_module_reset_n)
    );

  descriptor_memory_s1_arbitrator the_descriptor_memory_s1
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_granted_descriptor_memory_s1                                (cpu_data_master_granted_descriptor_memory_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_descriptor_memory_s1                      (cpu_data_master_qualified_request_descriptor_memory_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_descriptor_memory_s1                        (cpu_data_master_read_data_valid_descriptor_memory_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_descriptor_memory_s1                               (cpu_data_master_requests_descriptor_memory_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_descriptor_memory_s1_end_xfer                                            (d1_descriptor_memory_s1_end_xfer),
      .descriptor_memory_s1_address                                                (descriptor_memory_s1_address),
      .descriptor_memory_s1_byteenable                                             (descriptor_memory_s1_byteenable),
      .descriptor_memory_s1_chipselect                                             (descriptor_memory_s1_chipselect),
      .descriptor_memory_s1_clken                                                  (descriptor_memory_s1_clken),
      .descriptor_memory_s1_readdata                                               (descriptor_memory_s1_readdata),
      .descriptor_memory_s1_readdata_from_sa                                       (descriptor_memory_s1_readdata_from_sa),
      .descriptor_memory_s1_write                                                  (descriptor_memory_s1_write),
      .descriptor_memory_s1_writedata                                              (descriptor_memory_s1_writedata),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sgdma_rx_descriptor_read_address_to_slave                                   (sgdma_rx_descriptor_read_address_to_slave),
      .sgdma_rx_descriptor_read_granted_descriptor_memory_s1                       (sgdma_rx_descriptor_read_granted_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_latency_counter                                    (sgdma_rx_descriptor_read_latency_counter),
      .sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1             (sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_read                                               (sgdma_rx_descriptor_read_read),
      .sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1               (sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_requests_descriptor_memory_s1                      (sgdma_rx_descriptor_read_requests_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_address_to_slave                                  (sgdma_rx_descriptor_write_address_to_slave),
      .sgdma_rx_descriptor_write_granted_descriptor_memory_s1                      (sgdma_rx_descriptor_write_granted_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1            (sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_requests_descriptor_memory_s1                     (sgdma_rx_descriptor_write_requests_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_write                                             (sgdma_rx_descriptor_write_write),
      .sgdma_rx_descriptor_write_writedata                                         (sgdma_rx_descriptor_write_writedata),
      .sgdma_tx_descriptor_read_address_to_slave                                   (sgdma_tx_descriptor_read_address_to_slave),
      .sgdma_tx_descriptor_read_granted_descriptor_memory_s1                       (sgdma_tx_descriptor_read_granted_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_latency_counter                                    (sgdma_tx_descriptor_read_latency_counter),
      .sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1             (sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_read                                               (sgdma_tx_descriptor_read_read),
      .sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1               (sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_requests_descriptor_memory_s1                      (sgdma_tx_descriptor_read_requests_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_address_to_slave                                  (sgdma_tx_descriptor_write_address_to_slave),
      .sgdma_tx_descriptor_write_granted_descriptor_memory_s1                      (sgdma_tx_descriptor_write_granted_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1            (sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_requests_descriptor_memory_s1                     (sgdma_tx_descriptor_write_requests_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_write                                             (sgdma_tx_descriptor_write_write),
      .sgdma_tx_descriptor_write_writedata                                         (sgdma_tx_descriptor_write_writedata)
    );

  descriptor_memory the_descriptor_memory
    (
      .address    (descriptor_memory_s1_address),
      .byteenable (descriptor_memory_s1_byteenable),
      .chipselect (descriptor_memory_s1_chipselect),
      .clk        (pll_sys_clk),
      .clken      (descriptor_memory_s1_clken),
      .readdata   (descriptor_memory_s1_readdata),
      .write      (descriptor_memory_s1_write),
      .writedata  (descriptor_memory_s1_writedata)
    );

  flash_tristate_bridge_avalon_slave_arbitrator the_flash_tristate_bridge_avalon_slave
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_byteenable_ext_flash_s1                                     (cpu_data_master_byteenable_ext_flash_s1),
      .cpu_data_master_dbs_address                                                 (cpu_data_master_dbs_address),
      .cpu_data_master_dbs_write_16                                                (cpu_data_master_dbs_write_16),
      .cpu_data_master_granted_ext_flash_s1                                        (cpu_data_master_granted_ext_flash_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_ext_flash_s1                              (cpu_data_master_qualified_request_ext_flash_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_ext_flash_s1                                (cpu_data_master_read_data_valid_ext_flash_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_ext_flash_s1                                       (cpu_data_master_requests_ext_flash_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_instruction_master_address_to_slave                                     (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_dbs_address                                          (cpu_instruction_master_dbs_address),
      .cpu_instruction_master_granted_ext_flash_s1                                 (cpu_instruction_master_granted_ext_flash_s1),
      .cpu_instruction_master_latency_counter                                      (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_ext_flash_s1                       (cpu_instruction_master_qualified_request_ext_flash_s1),
      .cpu_instruction_master_read                                                 (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_ext_flash_s1                         (cpu_instruction_master_read_data_valid_ext_flash_s1),
      .cpu_instruction_master_requests_ext_flash_s1                                (cpu_instruction_master_requests_ext_flash_s1),
      .d1_flash_tristate_bridge_avalon_slave_end_xfer                              (d1_flash_tristate_bridge_avalon_slave_end_xfer),
      .ext_flash_s1_wait_counter_eq_0                                              (ext_flash_s1_wait_counter_eq_0),
      .flash_tristate_bridge_address                                               (flash_tristate_bridge_address),
      .flash_tristate_bridge_data                                                  (flash_tristate_bridge_data),
      .flash_tristate_bridge_readn                                                 (flash_tristate_bridge_readn),
      .flash_tristate_bridge_writen                                                (flash_tristate_bridge_writen),
      .incoming_flash_tristate_bridge_data                                         (incoming_flash_tristate_bridge_data),
      .incoming_flash_tristate_bridge_data_with_Xs_converted_to_0                  (incoming_flash_tristate_bridge_data_with_Xs_converted_to_0),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .select_n_to_the_ext_flash                                                   (select_n_to_the_ext_flash)
    );

  high_res_timer_s1_arbitrator the_high_res_timer_s1
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_high_res_timer_s1                                   (cpu_data_master_granted_high_res_timer_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_high_res_timer_s1                         (cpu_data_master_qualified_request_high_res_timer_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_high_res_timer_s1                           (cpu_data_master_read_data_valid_high_res_timer_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_high_res_timer_s1                                  (cpu_data_master_requests_high_res_timer_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_high_res_timer_s1_end_xfer                                               (d1_high_res_timer_s1_end_xfer),
      .high_res_timer_s1_address                                                   (high_res_timer_s1_address),
      .high_res_timer_s1_chipselect                                                (high_res_timer_s1_chipselect),
      .high_res_timer_s1_irq                                                       (high_res_timer_s1_irq),
      .high_res_timer_s1_irq_from_sa                                               (high_res_timer_s1_irq_from_sa),
      .high_res_timer_s1_readdata                                                  (high_res_timer_s1_readdata),
      .high_res_timer_s1_readdata_from_sa                                          (high_res_timer_s1_readdata_from_sa),
      .high_res_timer_s1_reset_n                                                   (high_res_timer_s1_reset_n),
      .high_res_timer_s1_write_n                                                   (high_res_timer_s1_write_n),
      .high_res_timer_s1_writedata                                                 (high_res_timer_s1_writedata),
      .reset_n                                                                     (pll_sys_clk_reset_n)
    );

  high_res_timer the_high_res_timer
    (
      .address    (high_res_timer_s1_address),
      .chipselect (high_res_timer_s1_chipselect),
      .clk        (pll_sys_clk),
      .irq        (high_res_timer_s1_irq),
      .readdata   (high_res_timer_s1_readdata),
      .reset_n    (high_res_timer_s1_reset_n),
      .write_n    (high_res_timer_s1_write_n),
      .writedata  (high_res_timer_s1_writedata)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .DE4_SOPC_clock_1_out_address_to_slave                              (DE4_SOPC_clock_1_out_address_to_slave),
      .DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave           (DE4_SOPC_clock_1_out_granted_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_nativeaddress                                 (DE4_SOPC_clock_1_out_nativeaddress),
      .DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave (DE4_SOPC_clock_1_out_qualified_request_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_read                                          (DE4_SOPC_clock_1_out_read),
      .DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave   (DE4_SOPC_clock_1_out_read_data_valid_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave          (DE4_SOPC_clock_1_out_requests_jtag_uart_avalon_jtag_slave),
      .DE4_SOPC_clock_1_out_write                                         (DE4_SOPC_clock_1_out_write),
      .DE4_SOPC_clock_1_out_writedata                                     (DE4_SOPC_clock_1_out_writedata),
      .clk                                                                (pll_peripheral_clk),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                            (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_address                                (jtag_uart_avalon_jtag_slave_address),
      .jtag_uart_avalon_jtag_slave_chipselect                             (jtag_uart_avalon_jtag_slave_chipselect),
      .jtag_uart_avalon_jtag_slave_dataavailable                          (jtag_uart_avalon_jtag_slave_dataavailable),
      .jtag_uart_avalon_jtag_slave_dataavailable_from_sa                  (jtag_uart_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_avalon_jtag_slave_irq                                    (jtag_uart_avalon_jtag_slave_irq),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                            (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_read_n                                 (jtag_uart_avalon_jtag_slave_read_n),
      .jtag_uart_avalon_jtag_slave_readdata                               (jtag_uart_avalon_jtag_slave_readdata),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                       (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_readyfordata                           (jtag_uart_avalon_jtag_slave_readyfordata),
      .jtag_uart_avalon_jtag_slave_readyfordata_from_sa                   (jtag_uart_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_avalon_jtag_slave_reset_n                                (jtag_uart_avalon_jtag_slave_reset_n),
      .jtag_uart_avalon_jtag_slave_waitrequest                            (jtag_uart_avalon_jtag_slave_waitrequest),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                    (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_avalon_jtag_slave_write_n                                (jtag_uart_avalon_jtag_slave_write_n),
      .jtag_uart_avalon_jtag_slave_writedata                              (jtag_uart_avalon_jtag_slave_writedata),
      .reset_n                                                            (pll_peripheral_clk_reset_n)
    );

  jtag_uart the_jtag_uart
    (
      .av_address     (jtag_uart_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_avalon_jtag_slave_writedata),
      .clk            (pll_peripheral_clk),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  led_pio_s1_arbitrator the_led_pio_s1
    (
      .clk                                                       (pll_peripheral_clk),
      .d1_led_pio_s1_end_xfer                                    (d1_led_pio_s1_end_xfer),
      .led_pio_s1_address                                        (led_pio_s1_address),
      .led_pio_s1_chipselect                                     (led_pio_s1_chipselect),
      .led_pio_s1_readdata                                       (led_pio_s1_readdata),
      .led_pio_s1_readdata_from_sa                               (led_pio_s1_readdata_from_sa),
      .led_pio_s1_reset_n                                        (led_pio_s1_reset_n),
      .led_pio_s1_write_n                                        (led_pio_s1_write_n),
      .led_pio_s1_writedata                                      (led_pio_s1_writedata),
      .peripheral_clock_crossing_m1_address_to_slave             (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_byteenable                   (peripheral_clock_crossing_m1_byteenable),
      .peripheral_clock_crossing_m1_granted_led_pio_s1           (peripheral_clock_crossing_m1_granted_led_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter              (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_led_pio_s1 (peripheral_clock_crossing_m1_qualified_request_led_pio_s1),
      .peripheral_clock_crossing_m1_read                         (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_led_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_led_pio_s1),
      .peripheral_clock_crossing_m1_requests_led_pio_s1          (peripheral_clock_crossing_m1_requests_led_pio_s1),
      .peripheral_clock_crossing_m1_write                        (peripheral_clock_crossing_m1_write),
      .peripheral_clock_crossing_m1_writedata                    (peripheral_clock_crossing_m1_writedata),
      .reset_n                                                   (pll_peripheral_clk_reset_n)
    );

  led_pio the_led_pio
    (
      .address    (led_pio_s1_address),
      .chipselect (led_pio_s1_chipselect),
      .clk        (pll_peripheral_clk),
      .out_port   (out_port_from_the_led_pio),
      .readdata   (led_pio_s1_readdata),
      .reset_n    (led_pio_s1_reset_n),
      .write_n    (led_pio_s1_write_n),
      .writedata  (led_pio_s1_writedata)
    );

  onchip_memory_s1_arbitrator the_onchip_memory_s1
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_granted_onchip_memory_s1                                    (cpu_data_master_granted_onchip_memory_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_onchip_memory_s1                          (cpu_data_master_qualified_request_onchip_memory_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_onchip_memory_s1                            (cpu_data_master_read_data_valid_onchip_memory_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_onchip_memory_s1                                   (cpu_data_master_requests_onchip_memory_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .cpu_instruction_master_address_to_slave                                     (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_granted_onchip_memory_s1                             (cpu_instruction_master_granted_onchip_memory_s1),
      .cpu_instruction_master_latency_counter                                      (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_onchip_memory_s1                   (cpu_instruction_master_qualified_request_onchip_memory_s1),
      .cpu_instruction_master_read                                                 (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_onchip_memory_s1                     (cpu_instruction_master_read_data_valid_onchip_memory_s1),
      .cpu_instruction_master_requests_onchip_memory_s1                            (cpu_instruction_master_requests_onchip_memory_s1),
      .d1_onchip_memory_s1_end_xfer                                                (d1_onchip_memory_s1_end_xfer),
      .onchip_memory_s1_address                                                    (onchip_memory_s1_address),
      .onchip_memory_s1_byteenable                                                 (onchip_memory_s1_byteenable),
      .onchip_memory_s1_chipselect                                                 (onchip_memory_s1_chipselect),
      .onchip_memory_s1_clken                                                      (onchip_memory_s1_clken),
      .onchip_memory_s1_readdata                                                   (onchip_memory_s1_readdata),
      .onchip_memory_s1_readdata_from_sa                                           (onchip_memory_s1_readdata_from_sa),
      .onchip_memory_s1_write                                                      (onchip_memory_s1_write),
      .onchip_memory_s1_writedata                                                  (onchip_memory_s1_writedata),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sgdma_rx_m_write_address_to_slave                                           (sgdma_rx_m_write_address_to_slave),
      .sgdma_rx_m_write_byteenable                                                 (sgdma_rx_m_write_byteenable),
      .sgdma_rx_m_write_granted_onchip_memory_s1                                   (sgdma_rx_m_write_granted_onchip_memory_s1),
      .sgdma_rx_m_write_qualified_request_onchip_memory_s1                         (sgdma_rx_m_write_qualified_request_onchip_memory_s1),
      .sgdma_rx_m_write_requests_onchip_memory_s1                                  (sgdma_rx_m_write_requests_onchip_memory_s1),
      .sgdma_rx_m_write_write                                                      (sgdma_rx_m_write_write),
      .sgdma_rx_m_write_writedata                                                  (sgdma_rx_m_write_writedata),
      .sgdma_tx_m_read_address_to_slave                                            (sgdma_tx_m_read_address_to_slave),
      .sgdma_tx_m_read_granted_onchip_memory_s1                                    (sgdma_tx_m_read_granted_onchip_memory_s1),
      .sgdma_tx_m_read_latency_counter                                             (sgdma_tx_m_read_latency_counter),
      .sgdma_tx_m_read_qualified_request_onchip_memory_s1                          (sgdma_tx_m_read_qualified_request_onchip_memory_s1),
      .sgdma_tx_m_read_read                                                        (sgdma_tx_m_read_read),
      .sgdma_tx_m_read_read_data_valid_onchip_memory_s1                            (sgdma_tx_m_read_read_data_valid_onchip_memory_s1),
      .sgdma_tx_m_read_requests_onchip_memory_s1                                   (sgdma_tx_m_read_requests_onchip_memory_s1)
    );

  onchip_memory the_onchip_memory
    (
      .address    (onchip_memory_s1_address),
      .byteenable (onchip_memory_s1_byteenable),
      .chipselect (onchip_memory_s1_chipselect),
      .clk        (pll_sys_clk),
      .clken      (onchip_memory_s1_clken),
      .readdata   (onchip_memory_s1_readdata),
      .write      (onchip_memory_s1_write),
      .writedata  (onchip_memory_s1_writedata)
    );

  pb_pio_s1_arbitrator the_pb_pio_s1
    (
      .clk                                                      (pll_peripheral_clk),
      .d1_pb_pio_s1_end_xfer                                    (d1_pb_pio_s1_end_xfer),
      .pb_pio_s1_address                                        (pb_pio_s1_address),
      .pb_pio_s1_readdata                                       (pb_pio_s1_readdata),
      .pb_pio_s1_readdata_from_sa                               (pb_pio_s1_readdata_from_sa),
      .pb_pio_s1_reset_n                                        (pb_pio_s1_reset_n),
      .peripheral_clock_crossing_m1_address_to_slave            (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_pb_pio_s1           (peripheral_clock_crossing_m1_granted_pb_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter             (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress               (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_pb_pio_s1 (peripheral_clock_crossing_m1_qualified_request_pb_pio_s1),
      .peripheral_clock_crossing_m1_read                        (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1),
      .peripheral_clock_crossing_m1_requests_pb_pio_s1          (peripheral_clock_crossing_m1_requests_pb_pio_s1),
      .peripheral_clock_crossing_m1_write                       (peripheral_clock_crossing_m1_write),
      .reset_n                                                  (pll_peripheral_clk_reset_n)
    );

  pb_pio the_pb_pio
    (
      .address  (pb_pio_s1_address),
      .clk      (pll_peripheral_clk),
      .in_port  (in_port_to_the_pb_pio),
      .readdata (pb_pio_s1_readdata),
      .reset_n  (pb_pio_s1_reset_n)
    );

  peripheral_clock_crossing_s1_arbitrator the_peripheral_clock_crossing_s1
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                  (cpu_data_master_byteenable),
      .cpu_data_master_granted_peripheral_clock_crossing_s1                        (cpu_data_master_granted_peripheral_clock_crossing_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_peripheral_clock_crossing_s1              (cpu_data_master_qualified_request_peripheral_clock_crossing_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1                (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_requests_peripheral_clock_crossing_s1                       (cpu_data_master_requests_peripheral_clock_crossing_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_peripheral_clock_crossing_s1_end_xfer                                    (d1_peripheral_clock_crossing_s1_end_xfer),
      .peripheral_clock_crossing_s1_address                                        (peripheral_clock_crossing_s1_address),
      .peripheral_clock_crossing_s1_byteenable                                     (peripheral_clock_crossing_s1_byteenable),
      .peripheral_clock_crossing_s1_endofpacket                                    (peripheral_clock_crossing_s1_endofpacket),
      .peripheral_clock_crossing_s1_endofpacket_from_sa                            (peripheral_clock_crossing_s1_endofpacket_from_sa),
      .peripheral_clock_crossing_s1_nativeaddress                                  (peripheral_clock_crossing_s1_nativeaddress),
      .peripheral_clock_crossing_s1_read                                           (peripheral_clock_crossing_s1_read),
      .peripheral_clock_crossing_s1_readdata                                       (peripheral_clock_crossing_s1_readdata),
      .peripheral_clock_crossing_s1_readdata_from_sa                               (peripheral_clock_crossing_s1_readdata_from_sa),
      .peripheral_clock_crossing_s1_readdatavalid                                  (peripheral_clock_crossing_s1_readdatavalid),
      .peripheral_clock_crossing_s1_reset_n                                        (peripheral_clock_crossing_s1_reset_n),
      .peripheral_clock_crossing_s1_waitrequest                                    (peripheral_clock_crossing_s1_waitrequest),
      .peripheral_clock_crossing_s1_waitrequest_from_sa                            (peripheral_clock_crossing_s1_waitrequest_from_sa),
      .peripheral_clock_crossing_s1_write                                          (peripheral_clock_crossing_s1_write),
      .peripheral_clock_crossing_s1_writedata                                      (peripheral_clock_crossing_s1_writedata),
      .reset_n                                                                     (pll_sys_clk_reset_n)
    );

  peripheral_clock_crossing_m1_arbitrator the_peripheral_clock_crossing_m1
    (
      .ADC_data_pio_s1_readdata_from_sa                                    (ADC_data_pio_s1_readdata_from_sa),
      .acq_busy_pio_s1_readdata_from_sa                                    (acq_busy_pio_s1_readdata_from_sa),
      .clk                                                                 (pll_peripheral_clk),
      .d1_ADC_data_pio_s1_end_xfer                                         (d1_ADC_data_pio_s1_end_xfer),
      .d1_acq_busy_pio_s1_end_xfer                                         (d1_acq_busy_pio_s1_end_xfer),
      .d1_led_pio_s1_end_xfer                                              (d1_led_pio_s1_end_xfer),
      .d1_pb_pio_s1_end_xfer                                               (d1_pb_pio_s1_end_xfer),
      .d1_read_RAM_address_s1_end_xfer                                     (d1_read_RAM_address_s1_end_xfer),
      .d1_read_RAM_busy_pio_s1_end_xfer                                    (d1_read_RAM_busy_pio_s1_end_xfer),
      .d1_seven_seg_pio_s1_end_xfer                                        (d1_seven_seg_pio_s1_end_xfer),
      .d1_sw_pio_s1_end_xfer                                               (d1_sw_pio_s1_end_xfer),
      .led_pio_s1_readdata_from_sa                                         (led_pio_s1_readdata_from_sa),
      .pb_pio_s1_readdata_from_sa                                          (pb_pio_s1_readdata_from_sa),
      .peripheral_clock_crossing_m1_address                                (peripheral_clock_crossing_m1_address),
      .peripheral_clock_crossing_m1_address_to_slave                       (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_byteenable                             (peripheral_clock_crossing_m1_byteenable),
      .peripheral_clock_crossing_m1_granted_ADC_data_pio_s1                (peripheral_clock_crossing_m1_granted_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_granted_acq_busy_pio_s1                (peripheral_clock_crossing_m1_granted_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_granted_led_pio_s1                     (peripheral_clock_crossing_m1_granted_led_pio_s1),
      .peripheral_clock_crossing_m1_granted_pb_pio_s1                      (peripheral_clock_crossing_m1_granted_pb_pio_s1),
      .peripheral_clock_crossing_m1_granted_read_RAM_address_s1            (peripheral_clock_crossing_m1_granted_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1           (peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_granted_seven_seg_pio_s1               (peripheral_clock_crossing_m1_granted_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_granted_sw_pio_s1                      (peripheral_clock_crossing_m1_granted_sw_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter                        (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1      (peripheral_clock_crossing_m1_qualified_request_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1      (peripheral_clock_crossing_m1_qualified_request_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_led_pio_s1           (peripheral_clock_crossing_m1_qualified_request_led_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_pb_pio_s1            (peripheral_clock_crossing_m1_qualified_request_pb_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1  (peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 (peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1     (peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_qualified_request_sw_pio_s1            (peripheral_clock_crossing_m1_qualified_request_sw_pio_s1),
      .peripheral_clock_crossing_m1_read                                   (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1        (peripheral_clock_crossing_m1_read_data_valid_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1        (peripheral_clock_crossing_m1_read_data_valid_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_led_pio_s1             (peripheral_clock_crossing_m1_read_data_valid_led_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1              (peripheral_clock_crossing_m1_read_data_valid_pb_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1    (peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1       (peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1              (peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1),
      .peripheral_clock_crossing_m1_readdata                               (peripheral_clock_crossing_m1_readdata),
      .peripheral_clock_crossing_m1_readdatavalid                          (peripheral_clock_crossing_m1_readdatavalid),
      .peripheral_clock_crossing_m1_requests_ADC_data_pio_s1               (peripheral_clock_crossing_m1_requests_ADC_data_pio_s1),
      .peripheral_clock_crossing_m1_requests_acq_busy_pio_s1               (peripheral_clock_crossing_m1_requests_acq_busy_pio_s1),
      .peripheral_clock_crossing_m1_requests_led_pio_s1                    (peripheral_clock_crossing_m1_requests_led_pio_s1),
      .peripheral_clock_crossing_m1_requests_pb_pio_s1                     (peripheral_clock_crossing_m1_requests_pb_pio_s1),
      .peripheral_clock_crossing_m1_requests_read_RAM_address_s1           (peripheral_clock_crossing_m1_requests_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1          (peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_requests_seven_seg_pio_s1              (peripheral_clock_crossing_m1_requests_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_requests_sw_pio_s1                     (peripheral_clock_crossing_m1_requests_sw_pio_s1),
      .peripheral_clock_crossing_m1_reset_n                                (peripheral_clock_crossing_m1_reset_n),
      .peripheral_clock_crossing_m1_waitrequest                            (peripheral_clock_crossing_m1_waitrequest),
      .peripheral_clock_crossing_m1_write                                  (peripheral_clock_crossing_m1_write),
      .peripheral_clock_crossing_m1_writedata                              (peripheral_clock_crossing_m1_writedata),
      .read_RAM_address_s1_readdata_from_sa                                (read_RAM_address_s1_readdata_from_sa),
      .read_RAM_busy_pio_s1_readdata_from_sa                               (read_RAM_busy_pio_s1_readdata_from_sa),
      .reset_n                                                             (pll_peripheral_clk_reset_n),
      .seven_seg_pio_s1_readdata_from_sa                                   (seven_seg_pio_s1_readdata_from_sa),
      .sw_pio_s1_readdata_from_sa                                          (sw_pio_s1_readdata_from_sa)
    );

  peripheral_clock_crossing the_peripheral_clock_crossing
    (
      .master_address       (peripheral_clock_crossing_m1_address),
      .master_byteenable    (peripheral_clock_crossing_m1_byteenable),
      .master_clk           (pll_peripheral_clk),
      .master_endofpacket   (peripheral_clock_crossing_m1_endofpacket),
      .master_nativeaddress (peripheral_clock_crossing_m1_nativeaddress),
      .master_read          (peripheral_clock_crossing_m1_read),
      .master_readdata      (peripheral_clock_crossing_m1_readdata),
      .master_readdatavalid (peripheral_clock_crossing_m1_readdatavalid),
      .master_reset_n       (peripheral_clock_crossing_m1_reset_n),
      .master_waitrequest   (peripheral_clock_crossing_m1_waitrequest),
      .master_write         (peripheral_clock_crossing_m1_write),
      .master_writedata     (peripheral_clock_crossing_m1_writedata),
      .slave_address        (peripheral_clock_crossing_s1_address),
      .slave_byteenable     (peripheral_clock_crossing_s1_byteenable),
      .slave_clk            (pll_sys_clk),
      .slave_endofpacket    (peripheral_clock_crossing_s1_endofpacket),
      .slave_nativeaddress  (peripheral_clock_crossing_s1_nativeaddress),
      .slave_read           (peripheral_clock_crossing_s1_read),
      .slave_readdata       (peripheral_clock_crossing_s1_readdata),
      .slave_readdatavalid  (peripheral_clock_crossing_s1_readdatavalid),
      .slave_reset_n        (peripheral_clock_crossing_s1_reset_n),
      .slave_waitrequest    (peripheral_clock_crossing_s1_waitrequest),
      .slave_write          (peripheral_clock_crossing_s1_write),
      .slave_writedata      (peripheral_clock_crossing_s1_writedata)
    );

  pll_s1_arbitrator the_pll_s1
    (
      .DE4_SOPC_clock_0_out_address_to_slave         (DE4_SOPC_clock_0_out_address_to_slave),
      .DE4_SOPC_clock_0_out_granted_pll_s1           (DE4_SOPC_clock_0_out_granted_pll_s1),
      .DE4_SOPC_clock_0_out_nativeaddress            (DE4_SOPC_clock_0_out_nativeaddress),
      .DE4_SOPC_clock_0_out_qualified_request_pll_s1 (DE4_SOPC_clock_0_out_qualified_request_pll_s1),
      .DE4_SOPC_clock_0_out_read                     (DE4_SOPC_clock_0_out_read),
      .DE4_SOPC_clock_0_out_read_data_valid_pll_s1   (DE4_SOPC_clock_0_out_read_data_valid_pll_s1),
      .DE4_SOPC_clock_0_out_requests_pll_s1          (DE4_SOPC_clock_0_out_requests_pll_s1),
      .DE4_SOPC_clock_0_out_write                    (DE4_SOPC_clock_0_out_write),
      .DE4_SOPC_clock_0_out_writedata                (DE4_SOPC_clock_0_out_writedata),
      .clk                                           (ext_clk),
      .d1_pll_s1_end_xfer                            (d1_pll_s1_end_xfer),
      .pll_s1_address                                (pll_s1_address),
      .pll_s1_chipselect                             (pll_s1_chipselect),
      .pll_s1_read                                   (pll_s1_read),
      .pll_s1_readdata                               (pll_s1_readdata),
      .pll_s1_readdata_from_sa                       (pll_s1_readdata_from_sa),
      .pll_s1_reset_n                                (pll_s1_reset_n),
      .pll_s1_resetrequest                           (pll_s1_resetrequest),
      .pll_s1_resetrequest_from_sa                   (pll_s1_resetrequest_from_sa),
      .pll_s1_write                                  (pll_s1_write),
      .pll_s1_writedata                              (pll_s1_writedata),
      .reset_n                                       (ext_clk_reset_n)
    );

  //pll_sys_clk out_clk assignment, which is an e_assign
  assign pll_sys_clk = out_clk_pll_c0;

  //pll_peripheral_clk out_clk assignment, which is an e_assign
  assign pll_peripheral_clk = out_clk_pll_c1;

  pll the_pll
    (
      .address      (pll_s1_address),
      .c0           (out_clk_pll_c0),
      .c1           (out_clk_pll_c1),
      .chipselect   (pll_s1_chipselect),
      .clk          (ext_clk),
      .read         (pll_s1_read),
      .readdata     (pll_s1_readdata),
      .reset_n      (pll_s1_reset_n),
      .resetrequest (pll_s1_resetrequest),
      .write        (pll_s1_write),
      .writedata    (pll_s1_writedata)
    );

  read_RAM_address_s1_arbitrator the_read_RAM_address_s1
    (
      .clk                                                                (pll_peripheral_clk),
      .d1_read_RAM_address_s1_end_xfer                                    (d1_read_RAM_address_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave                      (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_read_RAM_address_s1           (peripheral_clock_crossing_m1_granted_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_latency_counter                       (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                         (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1 (peripheral_clock_crossing_m1_qualified_request_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_read                                  (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1   (peripheral_clock_crossing_m1_read_data_valid_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_requests_read_RAM_address_s1          (peripheral_clock_crossing_m1_requests_read_RAM_address_s1),
      .peripheral_clock_crossing_m1_write                                 (peripheral_clock_crossing_m1_write),
      .peripheral_clock_crossing_m1_writedata                             (peripheral_clock_crossing_m1_writedata),
      .read_RAM_address_s1_address                                        (read_RAM_address_s1_address),
      .read_RAM_address_s1_chipselect                                     (read_RAM_address_s1_chipselect),
      .read_RAM_address_s1_readdata                                       (read_RAM_address_s1_readdata),
      .read_RAM_address_s1_readdata_from_sa                               (read_RAM_address_s1_readdata_from_sa),
      .read_RAM_address_s1_reset_n                                        (read_RAM_address_s1_reset_n),
      .read_RAM_address_s1_write_n                                        (read_RAM_address_s1_write_n),
      .read_RAM_address_s1_writedata                                      (read_RAM_address_s1_writedata),
      .reset_n                                                            (pll_peripheral_clk_reset_n)
    );

  read_RAM_address the_read_RAM_address
    (
      .address    (read_RAM_address_s1_address),
      .chipselect (read_RAM_address_s1_chipselect),
      .clk        (pll_peripheral_clk),
      .out_port   (out_port_from_the_read_RAM_address),
      .readdata   (read_RAM_address_s1_readdata),
      .reset_n    (read_RAM_address_s1_reset_n),
      .write_n    (read_RAM_address_s1_write_n),
      .writedata  (read_RAM_address_s1_writedata)
    );

  read_RAM_busy_pio_s1_arbitrator the_read_RAM_busy_pio_s1
    (
      .clk                                                                 (pll_peripheral_clk),
      .d1_read_RAM_busy_pio_s1_end_xfer                                    (d1_read_RAM_busy_pio_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave                       (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1           (peripheral_clock_crossing_m1_granted_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter                        (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                          (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1 (peripheral_clock_crossing_m1_qualified_request_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_read                                   (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1          (peripheral_clock_crossing_m1_requests_read_RAM_busy_pio_s1),
      .peripheral_clock_crossing_m1_write                                  (peripheral_clock_crossing_m1_write),
      .peripheral_clock_crossing_m1_writedata                              (peripheral_clock_crossing_m1_writedata),
      .read_RAM_busy_pio_s1_address                                        (read_RAM_busy_pio_s1_address),
      .read_RAM_busy_pio_s1_chipselect                                     (read_RAM_busy_pio_s1_chipselect),
      .read_RAM_busy_pio_s1_readdata                                       (read_RAM_busy_pio_s1_readdata),
      .read_RAM_busy_pio_s1_readdata_from_sa                               (read_RAM_busy_pio_s1_readdata_from_sa),
      .read_RAM_busy_pio_s1_reset_n                                        (read_RAM_busy_pio_s1_reset_n),
      .read_RAM_busy_pio_s1_write_n                                        (read_RAM_busy_pio_s1_write_n),
      .read_RAM_busy_pio_s1_writedata                                      (read_RAM_busy_pio_s1_writedata),
      .reset_n                                                             (pll_peripheral_clk_reset_n)
    );

  read_RAM_busy_pio the_read_RAM_busy_pio
    (
      .address    (read_RAM_busy_pio_s1_address),
      .chipselect (read_RAM_busy_pio_s1_chipselect),
      .clk        (pll_peripheral_clk),
      .out_port   (out_port_from_the_read_RAM_busy_pio),
      .readdata   (read_RAM_busy_pio_s1_readdata),
      .reset_n    (read_RAM_busy_pio_s1_reset_n),
      .write_n    (read_RAM_busy_pio_s1_write_n),
      .writedata  (read_RAM_busy_pio_s1_writedata)
    );

  seven_seg_pio_s1_arbitrator the_seven_seg_pio_s1
    (
      .clk                                                             (pll_peripheral_clk),
      .d1_seven_seg_pio_s1_end_xfer                                    (d1_seven_seg_pio_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave                   (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_seven_seg_pio_s1           (peripheral_clock_crossing_m1_granted_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter                    (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress                      (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1 (peripheral_clock_crossing_m1_qualified_request_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_read                               (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_requests_seven_seg_pio_s1          (peripheral_clock_crossing_m1_requests_seven_seg_pio_s1),
      .peripheral_clock_crossing_m1_write                              (peripheral_clock_crossing_m1_write),
      .peripheral_clock_crossing_m1_writedata                          (peripheral_clock_crossing_m1_writedata),
      .reset_n                                                         (pll_peripheral_clk_reset_n),
      .seven_seg_pio_s1_address                                        (seven_seg_pio_s1_address),
      .seven_seg_pio_s1_chipselect                                     (seven_seg_pio_s1_chipselect),
      .seven_seg_pio_s1_readdata                                       (seven_seg_pio_s1_readdata),
      .seven_seg_pio_s1_readdata_from_sa                               (seven_seg_pio_s1_readdata_from_sa),
      .seven_seg_pio_s1_reset_n                                        (seven_seg_pio_s1_reset_n),
      .seven_seg_pio_s1_write_n                                        (seven_seg_pio_s1_write_n),
      .seven_seg_pio_s1_writedata                                      (seven_seg_pio_s1_writedata)
    );

  seven_seg_pio the_seven_seg_pio
    (
      .address    (seven_seg_pio_s1_address),
      .chipselect (seven_seg_pio_s1_chipselect),
      .clk        (pll_peripheral_clk),
      .out_port   (out_port_from_the_seven_seg_pio),
      .readdata   (seven_seg_pio_s1_readdata),
      .reset_n    (seven_seg_pio_s1_reset_n),
      .write_n    (seven_seg_pio_s1_write_n),
      .writedata  (seven_seg_pio_s1_writedata)
    );

  sgdma_rx_csr_arbitrator the_sgdma_rx_csr
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_sgdma_rx_csr                                        (cpu_data_master_granted_sgdma_rx_csr),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sgdma_rx_csr                              (cpu_data_master_qualified_request_sgdma_rx_csr),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_sgdma_rx_csr                                (cpu_data_master_read_data_valid_sgdma_rx_csr),
      .cpu_data_master_requests_sgdma_rx_csr                                       (cpu_data_master_requests_sgdma_rx_csr),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_sgdma_rx_csr_end_xfer                                                    (d1_sgdma_rx_csr_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sgdma_rx_csr_address                                                        (sgdma_rx_csr_address),
      .sgdma_rx_csr_chipselect                                                     (sgdma_rx_csr_chipselect),
      .sgdma_rx_csr_irq                                                            (sgdma_rx_csr_irq),
      .sgdma_rx_csr_irq_from_sa                                                    (sgdma_rx_csr_irq_from_sa),
      .sgdma_rx_csr_read                                                           (sgdma_rx_csr_read),
      .sgdma_rx_csr_readdata                                                       (sgdma_rx_csr_readdata),
      .sgdma_rx_csr_readdata_from_sa                                               (sgdma_rx_csr_readdata_from_sa),
      .sgdma_rx_csr_reset_n                                                        (sgdma_rx_csr_reset_n),
      .sgdma_rx_csr_write                                                          (sgdma_rx_csr_write),
      .sgdma_rx_csr_writedata                                                      (sgdma_rx_csr_writedata)
    );

  sgdma_rx_in_arbitrator the_sgdma_rx_in
    (
      .clk                           (pll_sys_clk),
      .reset_n                       (pll_sys_clk_reset_n),
      .sgdma_rx_in_data              (sgdma_rx_in_data),
      .sgdma_rx_in_empty             (sgdma_rx_in_empty),
      .sgdma_rx_in_endofpacket       (sgdma_rx_in_endofpacket),
      .sgdma_rx_in_error             (sgdma_rx_in_error),
      .sgdma_rx_in_ready             (sgdma_rx_in_ready),
      .sgdma_rx_in_ready_from_sa     (sgdma_rx_in_ready_from_sa),
      .sgdma_rx_in_startofpacket     (sgdma_rx_in_startofpacket),
      .sgdma_rx_in_valid             (sgdma_rx_in_valid),
      .tse_mac_receive_data          (tse_mac_receive_data),
      .tse_mac_receive_empty         (tse_mac_receive_empty),
      .tse_mac_receive_endofpacket   (tse_mac_receive_endofpacket),
      .tse_mac_receive_error         (tse_mac_receive_error),
      .tse_mac_receive_startofpacket (tse_mac_receive_startofpacket),
      .tse_mac_receive_valid         (tse_mac_receive_valid)
    );

  sgdma_rx_descriptor_read_arbitrator the_sgdma_rx_descriptor_read
    (
      .clk                                                             (pll_sys_clk),
      .d1_descriptor_memory_s1_end_xfer                                (d1_descriptor_memory_s1_end_xfer),
      .descriptor_memory_s1_readdata_from_sa                           (descriptor_memory_s1_readdata_from_sa),
      .reset_n                                                         (pll_sys_clk_reset_n),
      .sgdma_rx_descriptor_read_address                                (sgdma_rx_descriptor_read_address),
      .sgdma_rx_descriptor_read_address_to_slave                       (sgdma_rx_descriptor_read_address_to_slave),
      .sgdma_rx_descriptor_read_granted_descriptor_memory_s1           (sgdma_rx_descriptor_read_granted_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_latency_counter                        (sgdma_rx_descriptor_read_latency_counter),
      .sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1 (sgdma_rx_descriptor_read_qualified_request_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_read                                   (sgdma_rx_descriptor_read_read),
      .sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1   (sgdma_rx_descriptor_read_read_data_valid_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_readdata                               (sgdma_rx_descriptor_read_readdata),
      .sgdma_rx_descriptor_read_readdatavalid                          (sgdma_rx_descriptor_read_readdatavalid),
      .sgdma_rx_descriptor_read_requests_descriptor_memory_s1          (sgdma_rx_descriptor_read_requests_descriptor_memory_s1),
      .sgdma_rx_descriptor_read_waitrequest                            (sgdma_rx_descriptor_read_waitrequest)
    );

  sgdma_rx_descriptor_write_arbitrator the_sgdma_rx_descriptor_write
    (
      .clk                                                              (pll_sys_clk),
      .d1_descriptor_memory_s1_end_xfer                                 (d1_descriptor_memory_s1_end_xfer),
      .reset_n                                                          (pll_sys_clk_reset_n),
      .sgdma_rx_descriptor_write_address                                (sgdma_rx_descriptor_write_address),
      .sgdma_rx_descriptor_write_address_to_slave                       (sgdma_rx_descriptor_write_address_to_slave),
      .sgdma_rx_descriptor_write_granted_descriptor_memory_s1           (sgdma_rx_descriptor_write_granted_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1 (sgdma_rx_descriptor_write_qualified_request_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_requests_descriptor_memory_s1          (sgdma_rx_descriptor_write_requests_descriptor_memory_s1),
      .sgdma_rx_descriptor_write_waitrequest                            (sgdma_rx_descriptor_write_waitrequest),
      .sgdma_rx_descriptor_write_write                                  (sgdma_rx_descriptor_write_write),
      .sgdma_rx_descriptor_write_writedata                              (sgdma_rx_descriptor_write_writedata)
    );

  sgdma_rx_m_write_arbitrator the_sgdma_rx_m_write
    (
      .clk                                                 (pll_sys_clk),
      .d1_onchip_memory_s1_end_xfer                        (d1_onchip_memory_s1_end_xfer),
      .reset_n                                             (pll_sys_clk_reset_n),
      .sgdma_rx_m_write_address                            (sgdma_rx_m_write_address),
      .sgdma_rx_m_write_address_to_slave                   (sgdma_rx_m_write_address_to_slave),
      .sgdma_rx_m_write_byteenable                         (sgdma_rx_m_write_byteenable),
      .sgdma_rx_m_write_granted_onchip_memory_s1           (sgdma_rx_m_write_granted_onchip_memory_s1),
      .sgdma_rx_m_write_qualified_request_onchip_memory_s1 (sgdma_rx_m_write_qualified_request_onchip_memory_s1),
      .sgdma_rx_m_write_requests_onchip_memory_s1          (sgdma_rx_m_write_requests_onchip_memory_s1),
      .sgdma_rx_m_write_waitrequest                        (sgdma_rx_m_write_waitrequest),
      .sgdma_rx_m_write_write                              (sgdma_rx_m_write_write),
      .sgdma_rx_m_write_writedata                          (sgdma_rx_m_write_writedata)
    );

  sgdma_rx the_sgdma_rx
    (
      .clk                           (pll_sys_clk),
      .csr_address                   (sgdma_rx_csr_address),
      .csr_chipselect                (sgdma_rx_csr_chipselect),
      .csr_irq                       (sgdma_rx_csr_irq),
      .csr_read                      (sgdma_rx_csr_read),
      .csr_readdata                  (sgdma_rx_csr_readdata),
      .csr_write                     (sgdma_rx_csr_write),
      .csr_writedata                 (sgdma_rx_csr_writedata),
      .descriptor_read_address       (sgdma_rx_descriptor_read_address),
      .descriptor_read_read          (sgdma_rx_descriptor_read_read),
      .descriptor_read_readdata      (sgdma_rx_descriptor_read_readdata),
      .descriptor_read_readdatavalid (sgdma_rx_descriptor_read_readdatavalid),
      .descriptor_read_waitrequest   (sgdma_rx_descriptor_read_waitrequest),
      .descriptor_write_address      (sgdma_rx_descriptor_write_address),
      .descriptor_write_waitrequest  (sgdma_rx_descriptor_write_waitrequest),
      .descriptor_write_write        (sgdma_rx_descriptor_write_write),
      .descriptor_write_writedata    (sgdma_rx_descriptor_write_writedata),
      .in_data                       (sgdma_rx_in_data),
      .in_empty                      (sgdma_rx_in_empty),
      .in_endofpacket                (sgdma_rx_in_endofpacket),
      .in_error                      (sgdma_rx_in_error),
      .in_ready                      (sgdma_rx_in_ready),
      .in_startofpacket              (sgdma_rx_in_startofpacket),
      .in_valid                      (sgdma_rx_in_valid),
      .m_write_address               (sgdma_rx_m_write_address),
      .m_write_byteenable            (sgdma_rx_m_write_byteenable),
      .m_write_waitrequest           (sgdma_rx_m_write_waitrequest),
      .m_write_write                 (sgdma_rx_m_write_write),
      .m_write_writedata             (sgdma_rx_m_write_writedata),
      .system_reset_n                (sgdma_rx_csr_reset_n)
    );

  sgdma_tx_csr_arbitrator the_sgdma_tx_csr
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_sgdma_tx_csr                                        (cpu_data_master_granted_sgdma_tx_csr),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sgdma_tx_csr                              (cpu_data_master_qualified_request_sgdma_tx_csr),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_sgdma_tx_csr                                (cpu_data_master_read_data_valid_sgdma_tx_csr),
      .cpu_data_master_requests_sgdma_tx_csr                                       (cpu_data_master_requests_sgdma_tx_csr),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_sgdma_tx_csr_end_xfer                                                    (d1_sgdma_tx_csr_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sgdma_tx_csr_address                                                        (sgdma_tx_csr_address),
      .sgdma_tx_csr_chipselect                                                     (sgdma_tx_csr_chipselect),
      .sgdma_tx_csr_irq                                                            (sgdma_tx_csr_irq),
      .sgdma_tx_csr_irq_from_sa                                                    (sgdma_tx_csr_irq_from_sa),
      .sgdma_tx_csr_read                                                           (sgdma_tx_csr_read),
      .sgdma_tx_csr_readdata                                                       (sgdma_tx_csr_readdata),
      .sgdma_tx_csr_readdata_from_sa                                               (sgdma_tx_csr_readdata_from_sa),
      .sgdma_tx_csr_reset_n                                                        (sgdma_tx_csr_reset_n),
      .sgdma_tx_csr_write                                                          (sgdma_tx_csr_write),
      .sgdma_tx_csr_writedata                                                      (sgdma_tx_csr_writedata)
    );

  sgdma_tx_descriptor_read_arbitrator the_sgdma_tx_descriptor_read
    (
      .clk                                                             (pll_sys_clk),
      .d1_descriptor_memory_s1_end_xfer                                (d1_descriptor_memory_s1_end_xfer),
      .descriptor_memory_s1_readdata_from_sa                           (descriptor_memory_s1_readdata_from_sa),
      .reset_n                                                         (pll_sys_clk_reset_n),
      .sgdma_tx_descriptor_read_address                                (sgdma_tx_descriptor_read_address),
      .sgdma_tx_descriptor_read_address_to_slave                       (sgdma_tx_descriptor_read_address_to_slave),
      .sgdma_tx_descriptor_read_granted_descriptor_memory_s1           (sgdma_tx_descriptor_read_granted_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_latency_counter                        (sgdma_tx_descriptor_read_latency_counter),
      .sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1 (sgdma_tx_descriptor_read_qualified_request_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_read                                   (sgdma_tx_descriptor_read_read),
      .sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1   (sgdma_tx_descriptor_read_read_data_valid_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_readdata                               (sgdma_tx_descriptor_read_readdata),
      .sgdma_tx_descriptor_read_readdatavalid                          (sgdma_tx_descriptor_read_readdatavalid),
      .sgdma_tx_descriptor_read_requests_descriptor_memory_s1          (sgdma_tx_descriptor_read_requests_descriptor_memory_s1),
      .sgdma_tx_descriptor_read_waitrequest                            (sgdma_tx_descriptor_read_waitrequest)
    );

  sgdma_tx_descriptor_write_arbitrator the_sgdma_tx_descriptor_write
    (
      .clk                                                              (pll_sys_clk),
      .d1_descriptor_memory_s1_end_xfer                                 (d1_descriptor_memory_s1_end_xfer),
      .reset_n                                                          (pll_sys_clk_reset_n),
      .sgdma_tx_descriptor_write_address                                (sgdma_tx_descriptor_write_address),
      .sgdma_tx_descriptor_write_address_to_slave                       (sgdma_tx_descriptor_write_address_to_slave),
      .sgdma_tx_descriptor_write_granted_descriptor_memory_s1           (sgdma_tx_descriptor_write_granted_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1 (sgdma_tx_descriptor_write_qualified_request_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_requests_descriptor_memory_s1          (sgdma_tx_descriptor_write_requests_descriptor_memory_s1),
      .sgdma_tx_descriptor_write_waitrequest                            (sgdma_tx_descriptor_write_waitrequest),
      .sgdma_tx_descriptor_write_write                                  (sgdma_tx_descriptor_write_write),
      .sgdma_tx_descriptor_write_writedata                              (sgdma_tx_descriptor_write_writedata)
    );

  sgdma_tx_m_read_arbitrator the_sgdma_tx_m_read
    (
      .clk                                                (pll_sys_clk),
      .d1_onchip_memory_s1_end_xfer                       (d1_onchip_memory_s1_end_xfer),
      .onchip_memory_s1_readdata_from_sa                  (onchip_memory_s1_readdata_from_sa),
      .reset_n                                            (pll_sys_clk_reset_n),
      .sgdma_tx_m_read_address                            (sgdma_tx_m_read_address),
      .sgdma_tx_m_read_address_to_slave                   (sgdma_tx_m_read_address_to_slave),
      .sgdma_tx_m_read_granted_onchip_memory_s1           (sgdma_tx_m_read_granted_onchip_memory_s1),
      .sgdma_tx_m_read_latency_counter                    (sgdma_tx_m_read_latency_counter),
      .sgdma_tx_m_read_qualified_request_onchip_memory_s1 (sgdma_tx_m_read_qualified_request_onchip_memory_s1),
      .sgdma_tx_m_read_read                               (sgdma_tx_m_read_read),
      .sgdma_tx_m_read_read_data_valid_onchip_memory_s1   (sgdma_tx_m_read_read_data_valid_onchip_memory_s1),
      .sgdma_tx_m_read_readdata                           (sgdma_tx_m_read_readdata),
      .sgdma_tx_m_read_readdatavalid                      (sgdma_tx_m_read_readdatavalid),
      .sgdma_tx_m_read_requests_onchip_memory_s1          (sgdma_tx_m_read_requests_onchip_memory_s1),
      .sgdma_tx_m_read_waitrequest                        (sgdma_tx_m_read_waitrequest)
    );

  sgdma_tx_out_arbitrator the_sgdma_tx_out
    (
      .clk                            (pll_sys_clk),
      .reset_n                        (pll_sys_clk_reset_n),
      .sgdma_tx_out_data              (sgdma_tx_out_data),
      .sgdma_tx_out_empty             (sgdma_tx_out_empty),
      .sgdma_tx_out_endofpacket       (sgdma_tx_out_endofpacket),
      .sgdma_tx_out_error             (sgdma_tx_out_error),
      .sgdma_tx_out_ready             (sgdma_tx_out_ready),
      .sgdma_tx_out_startofpacket     (sgdma_tx_out_startofpacket),
      .sgdma_tx_out_valid             (sgdma_tx_out_valid),
      .tse_mac_transmit_ready_from_sa (tse_mac_transmit_ready_from_sa)
    );

  sgdma_tx the_sgdma_tx
    (
      .clk                           (pll_sys_clk),
      .csr_address                   (sgdma_tx_csr_address),
      .csr_chipselect                (sgdma_tx_csr_chipselect),
      .csr_irq                       (sgdma_tx_csr_irq),
      .csr_read                      (sgdma_tx_csr_read),
      .csr_readdata                  (sgdma_tx_csr_readdata),
      .csr_write                     (sgdma_tx_csr_write),
      .csr_writedata                 (sgdma_tx_csr_writedata),
      .descriptor_read_address       (sgdma_tx_descriptor_read_address),
      .descriptor_read_read          (sgdma_tx_descriptor_read_read),
      .descriptor_read_readdata      (sgdma_tx_descriptor_read_readdata),
      .descriptor_read_readdatavalid (sgdma_tx_descriptor_read_readdatavalid),
      .descriptor_read_waitrequest   (sgdma_tx_descriptor_read_waitrequest),
      .descriptor_write_address      (sgdma_tx_descriptor_write_address),
      .descriptor_write_waitrequest  (sgdma_tx_descriptor_write_waitrequest),
      .descriptor_write_write        (sgdma_tx_descriptor_write_write),
      .descriptor_write_writedata    (sgdma_tx_descriptor_write_writedata),
      .m_read_address                (sgdma_tx_m_read_address),
      .m_read_read                   (sgdma_tx_m_read_read),
      .m_read_readdata               (sgdma_tx_m_read_readdata),
      .m_read_readdatavalid          (sgdma_tx_m_read_readdatavalid),
      .m_read_waitrequest            (sgdma_tx_m_read_waitrequest),
      .out_data                      (sgdma_tx_out_data),
      .out_empty                     (sgdma_tx_out_empty),
      .out_endofpacket               (sgdma_tx_out_endofpacket),
      .out_error                     (sgdma_tx_out_error),
      .out_ready                     (sgdma_tx_out_ready),
      .out_startofpacket             (sgdma_tx_out_startofpacket),
      .out_valid                     (sgdma_tx_out_valid),
      .system_reset_n                (sgdma_tx_csr_reset_n)
    );

  sw_pio_s1_arbitrator the_sw_pio_s1
    (
      .clk                                                      (pll_peripheral_clk),
      .d1_sw_pio_s1_end_xfer                                    (d1_sw_pio_s1_end_xfer),
      .peripheral_clock_crossing_m1_address_to_slave            (peripheral_clock_crossing_m1_address_to_slave),
      .peripheral_clock_crossing_m1_granted_sw_pio_s1           (peripheral_clock_crossing_m1_granted_sw_pio_s1),
      .peripheral_clock_crossing_m1_latency_counter             (peripheral_clock_crossing_m1_latency_counter),
      .peripheral_clock_crossing_m1_nativeaddress               (peripheral_clock_crossing_m1_nativeaddress),
      .peripheral_clock_crossing_m1_qualified_request_sw_pio_s1 (peripheral_clock_crossing_m1_qualified_request_sw_pio_s1),
      .peripheral_clock_crossing_m1_read                        (peripheral_clock_crossing_m1_read),
      .peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1   (peripheral_clock_crossing_m1_read_data_valid_sw_pio_s1),
      .peripheral_clock_crossing_m1_requests_sw_pio_s1          (peripheral_clock_crossing_m1_requests_sw_pio_s1),
      .peripheral_clock_crossing_m1_write                       (peripheral_clock_crossing_m1_write),
      .reset_n                                                  (pll_peripheral_clk_reset_n),
      .sw_pio_s1_address                                        (sw_pio_s1_address),
      .sw_pio_s1_readdata                                       (sw_pio_s1_readdata),
      .sw_pio_s1_readdata_from_sa                               (sw_pio_s1_readdata_from_sa),
      .sw_pio_s1_reset_n                                        (sw_pio_s1_reset_n)
    );

  sw_pio the_sw_pio
    (
      .address  (sw_pio_s1_address),
      .clk      (pll_peripheral_clk),
      .in_port  (in_port_to_the_sw_pio),
      .readdata (sw_pio_s1_readdata),
      .reset_n  (sw_pio_s1_reset_n)
    );

  sys_timer_s1_arbitrator the_sys_timer_s1
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_sys_timer_s1                                        (cpu_data_master_granted_sys_timer_s1),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sys_timer_s1                              (cpu_data_master_qualified_request_sys_timer_s1),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_sys_timer_s1                                (cpu_data_master_read_data_valid_sys_timer_s1),
      .cpu_data_master_requests_sys_timer_s1                                       (cpu_data_master_requests_sys_timer_s1),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_sys_timer_s1_end_xfer                                                    (d1_sys_timer_s1_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sys_timer_s1_address                                                        (sys_timer_s1_address),
      .sys_timer_s1_chipselect                                                     (sys_timer_s1_chipselect),
      .sys_timer_s1_irq                                                            (sys_timer_s1_irq),
      .sys_timer_s1_irq_from_sa                                                    (sys_timer_s1_irq_from_sa),
      .sys_timer_s1_readdata                                                       (sys_timer_s1_readdata),
      .sys_timer_s1_readdata_from_sa                                               (sys_timer_s1_readdata_from_sa),
      .sys_timer_s1_reset_n                                                        (sys_timer_s1_reset_n),
      .sys_timer_s1_write_n                                                        (sys_timer_s1_write_n),
      .sys_timer_s1_writedata                                                      (sys_timer_s1_writedata)
    );

  sys_timer the_sys_timer
    (
      .address    (sys_timer_s1_address),
      .chipselect (sys_timer_s1_chipselect),
      .clk        (pll_sys_clk),
      .irq        (sys_timer_s1_irq),
      .readdata   (sys_timer_s1_readdata),
      .reset_n    (sys_timer_s1_reset_n),
      .write_n    (sys_timer_s1_write_n),
      .writedata  (sys_timer_s1_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_sysid_control_slave                                 (cpu_data_master_granted_sysid_control_slave),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sysid_control_slave                       (cpu_data_master_qualified_request_sysid_control_slave),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_sysid_control_slave                         (cpu_data_master_read_data_valid_sysid_control_slave),
      .cpu_data_master_requests_sysid_control_slave                                (cpu_data_master_requests_sysid_control_slave),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .d1_sysid_control_slave_end_xfer                                             (d1_sysid_control_slave_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .sysid_control_slave_address                                                 (sysid_control_slave_address),
      .sysid_control_slave_readdata                                                (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                                        (sysid_control_slave_readdata_from_sa)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .readdata (sysid_control_slave_readdata)
    );

  tse_mac_control_port_arbitrator the_tse_mac_control_port
    (
      .clk                                                                         (pll_sys_clk),
      .cpu_data_master_address_to_slave                                            (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_tse_mac_control_port                                (cpu_data_master_granted_tse_mac_control_port),
      .cpu_data_master_latency_counter                                             (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_tse_mac_control_port                      (cpu_data_master_qualified_request_tse_mac_control_port),
      .cpu_data_master_read                                                        (cpu_data_master_read),
      .cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register (cpu_data_master_read_data_valid_peripheral_clock_crossing_s1_shift_register),
      .cpu_data_master_read_data_valid_tse_mac_control_port                        (cpu_data_master_read_data_valid_tse_mac_control_port),
      .cpu_data_master_requests_tse_mac_control_port                               (cpu_data_master_requests_tse_mac_control_port),
      .cpu_data_master_write                                                       (cpu_data_master_write),
      .cpu_data_master_writedata                                                   (cpu_data_master_writedata),
      .d1_tse_mac_control_port_end_xfer                                            (d1_tse_mac_control_port_end_xfer),
      .reset_n                                                                     (pll_sys_clk_reset_n),
      .tse_mac_control_port_address                                                (tse_mac_control_port_address),
      .tse_mac_control_port_read                                                   (tse_mac_control_port_read),
      .tse_mac_control_port_readdata                                               (tse_mac_control_port_readdata),
      .tse_mac_control_port_readdata_from_sa                                       (tse_mac_control_port_readdata_from_sa),
      .tse_mac_control_port_reset                                                  (tse_mac_control_port_reset),
      .tse_mac_control_port_waitrequest                                            (tse_mac_control_port_waitrequest),
      .tse_mac_control_port_waitrequest_from_sa                                    (tse_mac_control_port_waitrequest_from_sa),
      .tse_mac_control_port_write                                                  (tse_mac_control_port_write),
      .tse_mac_control_port_writedata                                              (tse_mac_control_port_writedata)
    );

  tse_mac_transmit_arbitrator the_tse_mac_transmit
    (
      .clk                            (pll_sys_clk),
      .reset_n                        (pll_sys_clk_reset_n),
      .sgdma_tx_out_data              (sgdma_tx_out_data),
      .sgdma_tx_out_empty             (sgdma_tx_out_empty),
      .sgdma_tx_out_endofpacket       (sgdma_tx_out_endofpacket),
      .sgdma_tx_out_error             (sgdma_tx_out_error),
      .sgdma_tx_out_startofpacket     (sgdma_tx_out_startofpacket),
      .sgdma_tx_out_valid             (sgdma_tx_out_valid),
      .tse_mac_transmit_data          (tse_mac_transmit_data),
      .tse_mac_transmit_empty         (tse_mac_transmit_empty),
      .tse_mac_transmit_endofpacket   (tse_mac_transmit_endofpacket),
      .tse_mac_transmit_error         (tse_mac_transmit_error),
      .tse_mac_transmit_ready         (tse_mac_transmit_ready),
      .tse_mac_transmit_ready_from_sa (tse_mac_transmit_ready_from_sa),
      .tse_mac_transmit_startofpacket (tse_mac_transmit_startofpacket),
      .tse_mac_transmit_valid         (tse_mac_transmit_valid)
    );

  tse_mac_receive_arbitrator the_tse_mac_receive
    (
      .clk                           (pll_sys_clk),
      .reset_n                       (pll_sys_clk_reset_n),
      .sgdma_rx_in_ready_from_sa     (sgdma_rx_in_ready_from_sa),
      .tse_mac_receive_data          (tse_mac_receive_data),
      .tse_mac_receive_empty         (tse_mac_receive_empty),
      .tse_mac_receive_endofpacket   (tse_mac_receive_endofpacket),
      .tse_mac_receive_error         (tse_mac_receive_error),
      .tse_mac_receive_ready         (tse_mac_receive_ready),
      .tse_mac_receive_startofpacket (tse_mac_receive_startofpacket),
      .tse_mac_receive_valid         (tse_mac_receive_valid)
    );

  tse_mac the_tse_mac
    (
      .address      (tse_mac_control_port_address),
      .clk          (pll_sys_clk),
      .ff_rx_clk    (pll_sys_clk),
      .ff_rx_data   (tse_mac_receive_data),
      .ff_rx_dval   (tse_mac_receive_valid),
      .ff_rx_eop    (tse_mac_receive_endofpacket),
      .ff_rx_mod    (tse_mac_receive_empty),
      .ff_rx_rdy    (tse_mac_receive_ready),
      .ff_rx_sop    (tse_mac_receive_startofpacket),
      .ff_tx_clk    (pll_sys_clk),
      .ff_tx_data   (tse_mac_transmit_data),
      .ff_tx_eop    (tse_mac_transmit_endofpacket),
      .ff_tx_err    (tse_mac_transmit_error),
      .ff_tx_mod    (tse_mac_transmit_empty),
      .ff_tx_rdy    (tse_mac_transmit_ready),
      .ff_tx_sop    (tse_mac_transmit_startofpacket),
      .ff_tx_wren   (tse_mac_transmit_valid),
      .led_an       (led_an_from_the_tse_mac),
      .led_char_err (led_char_err_from_the_tse_mac),
      .led_col      (led_col_from_the_tse_mac),
      .led_crs      (led_crs_from_the_tse_mac),
      .led_disp_err (led_disp_err_from_the_tse_mac),
      .led_link     (led_link_from_the_tse_mac),
      .mdc          (mdc_from_the_tse_mac),
      .mdio_in      (mdio_in_to_the_tse_mac),
      .mdio_oen     (mdio_oen_from_the_tse_mac),
      .mdio_out     (mdio_out_from_the_tse_mac),
      .read         (tse_mac_control_port_read),
      .readdata     (tse_mac_control_port_readdata),
      .ref_clk      (ref_clk_to_the_tse_mac),
      .reset        (tse_mac_control_port_reset),
      .rx_err       (tse_mac_receive_error),
      .rxp          (rxp_to_the_tse_mac),
      .txp          (txp_from_the_tse_mac),
      .waitrequest  (tse_mac_control_port_waitrequest),
      .write        (tse_mac_control_port_write),
      .writedata    (tse_mac_control_port_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  DE4_SOPC_reset_pll_peripheral_clk_domain_synch_module DE4_SOPC_reset_pll_peripheral_clk_domain_synch
    (
      .clk      (pll_peripheral_clk),
      .data_in  (1'b1),
      .data_out (pll_peripheral_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    0 |
    cpu_jtag_debug_module_resetrequest_from_sa |
    cpu_jtag_debug_module_resetrequest_from_sa |
    0 |
    pll_s1_resetrequest_from_sa |
    pll_s1_resetrequest_from_sa);

  //reset is asserted asynchronously and deasserted synchronously
  DE4_SOPC_reset_pll_sys_clk_domain_synch_module DE4_SOPC_reset_pll_sys_clk_domain_synch
    (
      .clk      (pll_sys_clk),
      .data_in  (1'b1),
      .data_out (pll_sys_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  DE4_SOPC_reset_ext_clk_domain_synch_module DE4_SOPC_reset_ext_clk_domain_synch
    (
      .clk      (ext_clk),
      .data_in  (1'b1),
      .data_out (ext_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //DE4_SOPC_clock_0_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign DE4_SOPC_clock_0_out_endofpacket = 0;

  //DE4_SOPC_clock_1_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign DE4_SOPC_clock_1_out_endofpacket = 0;

  //peripheral_clock_crossing_m1_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign peripheral_clock_crossing_m1_endofpacket = 0;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ext_flash_lane0_module (
                                // inputs:
                                 data,
                                 rdaddress,
                                 rdclken,
                                 wraddress,
                                 wrclock,
                                 wren,

                                // outputs:
                                 q
                              )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 23: 0] rdaddress;
  input            rdclken;
  input   [ 23: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [16777215: 0];
  wire    [  7: 0] q;
  reg     [ 23: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("ext_flash_lane0.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "ext_flash_lane0.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 24,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ext_flash_lane1_module (
                                // inputs:
                                 data,
                                 rdaddress,
                                 rdclken,
                                 wraddress,
                                 wrclock,
                                 wren,

                                // outputs:
                                 q
                              )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 23: 0] rdaddress;
  input            rdclken;
  input   [ 23: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [16777215: 0];
  wire    [  7: 0] q;
  reg     [ 23: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("ext_flash_lane1.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "ext_flash_lane1.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 24,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ext_flash (
                   // inputs:
                    address,
                    read_n,
                    select_n,
                    write_n,

                   // outputs:
                    data
                 )
;

  inout   [ 15: 0] data;
  input   [ 23: 0] address;
  input            read_n;
  input            select_n;
  input            write_n;

  wire    [ 15: 0] data;
  wire    [  7: 0] data_0;
  wire    [  7: 0] data_1;
  wire    [ 15: 0] logic_vector_gasket;
  wire    [  7: 0] q_0;
  wire    [  7: 0] q_1;
  //s1, which is an e_ptf_slave

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign logic_vector_gasket = data;
  assign data_0 = logic_vector_gasket[7 : 0];
  //ext_flash_lane0, which is an e_ram
  ext_flash_lane0_module ext_flash_lane0
    (
      .data      (data_0),
      .q         (q_0),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data_1 = logic_vector_gasket[15 : 8];
  //ext_flash_lane1, which is an e_ram
  ext_flash_lane1_module ext_flash_lane1
    (
      .data      (data_1),
      .q         (q_1),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data = (~select_n & ~read_n)? {q_1,
    q_0}: {16{1'bz}};


//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/91/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/91/quartus/eda/sim_lib/220model.v"
`include "c:/altera/91/quartus/eda/sim_lib/sgate.v"
`include "C:/altera/91/quartus/eda/sim_lib/stratixiigx_hssi_atoms.v"
`include "C:/altera/91/quartus/eda/sim_lib/stratixiv_hssi_atoms.v"
`include "tse_mac.vo"
`include "tse_mac_loopback.v"
`include "read_RAM_busy_pio.v"
`include "descriptor_memory.v"
`include "pll.v"
`include "altpllpll.v"
`include "sysid.v"
`include "DE4_SOPC_clock_1.v"
`include "high_res_timer.v"
`include "read_RAM_address.v"
`include "sys_timer.v"
`include "acq_busy_pio.v"
`include "peripheral_clock_crossing.v"
`include "led_pio.v"
`include "jtag_uart.v"
`include "ADC_data_pio.v"
`include "DE4_SOPC_clock_0.v"
`include "sgdma_rx.v"
`include "cpu_test_bench.v"
`include "cpu_mult_cell.v"
`include "cpu_oci_test_bench.v"
`include "cpu_jtag_debug_module_tck.v"
`include "cpu_jtag_debug_module_sysclk.v"
`include "cpu_jtag_debug_module_wrapper.v"
`include "cpu.v"
`include "onchip_memory.v"
`include "sw_pio.v"
`include "sgdma_tx.v"
`include "seven_seg_pio.v"
`include "pb_pio.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             DE4_SOPC_clock_0_in_endofpacket_from_sa;
  wire             DE4_SOPC_clock_0_out_endofpacket;
  wire             DE4_SOPC_clock_1_in_endofpacket_from_sa;
  wire             DE4_SOPC_clock_1_out_endofpacket;
  wire             clk;
  reg              ext_clk;
  wire    [ 24: 0] flash_tristate_bridge_address;
  wire    [ 15: 0] flash_tristate_bridge_data;
  wire             flash_tristate_bridge_readn;
  wire             flash_tristate_bridge_writen;
  wire    [ 15: 0] in_port_to_the_ADC_data_pio;
  wire             in_port_to_the_acq_busy_pio;
  wire    [  3: 0] in_port_to_the_pb_pio;
  wire    [  7: 0] in_port_to_the_sw_pio;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             led_an_from_the_tse_mac;
  wire             led_char_err_from_the_tse_mac;
  wire             led_col_from_the_tse_mac;
  wire             led_crs_from_the_tse_mac;
  wire             led_disp_err_from_the_tse_mac;
  wire             led_link_from_the_tse_mac;
  wire             mdc_from_the_tse_mac;
  wire             mdio_in_to_the_tse_mac;
  wire             mdio_oen_from_the_tse_mac;
  wire             mdio_out_from_the_tse_mac;
  wire    [  7: 0] out_port_from_the_led_pio;
  wire    [ 10: 0] out_port_from_the_read_RAM_address;
  wire             out_port_from_the_read_RAM_busy_pio;
  wire    [ 15: 0] out_port_from_the_seven_seg_pio;
  wire             peripheral_clock_crossing_m1_endofpacket;
  wire             peripheral_clock_crossing_s1_endofpacket_from_sa;
  wire             pll_peripheral_clk;
  wire             pll_sys_clk;
  wire             ref_clk_to_the_tse_mac;
  reg              reset_n;
  wire             rxp_to_the_tse_mac;
  wire             select_n_to_the_ext_flash;
  wire             txp_from_the_tse_mac;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  DE4_SOPC DUT
    (
      .ext_clk                             (ext_clk),
      .flash_tristate_bridge_address       (flash_tristate_bridge_address),
      .flash_tristate_bridge_data          (flash_tristate_bridge_data),
      .flash_tristate_bridge_readn         (flash_tristate_bridge_readn),
      .flash_tristate_bridge_writen        (flash_tristate_bridge_writen),
      .in_port_to_the_ADC_data_pio         (in_port_to_the_ADC_data_pio),
      .in_port_to_the_acq_busy_pio         (in_port_to_the_acq_busy_pio),
      .in_port_to_the_pb_pio               (in_port_to_the_pb_pio),
      .in_port_to_the_sw_pio               (in_port_to_the_sw_pio),
      .led_an_from_the_tse_mac             (led_an_from_the_tse_mac),
      .led_char_err_from_the_tse_mac       (led_char_err_from_the_tse_mac),
      .led_col_from_the_tse_mac            (led_col_from_the_tse_mac),
      .led_crs_from_the_tse_mac            (led_crs_from_the_tse_mac),
      .led_disp_err_from_the_tse_mac       (led_disp_err_from_the_tse_mac),
      .led_link_from_the_tse_mac           (led_link_from_the_tse_mac),
      .mdc_from_the_tse_mac                (mdc_from_the_tse_mac),
      .mdio_in_to_the_tse_mac              (mdio_in_to_the_tse_mac),
      .mdio_oen_from_the_tse_mac           (mdio_oen_from_the_tse_mac),
      .mdio_out_from_the_tse_mac           (mdio_out_from_the_tse_mac),
      .out_port_from_the_led_pio           (out_port_from_the_led_pio),
      .out_port_from_the_read_RAM_address  (out_port_from_the_read_RAM_address),
      .out_port_from_the_read_RAM_busy_pio (out_port_from_the_read_RAM_busy_pio),
      .out_port_from_the_seven_seg_pio     (out_port_from_the_seven_seg_pio),
      .pll_peripheral_clk                  (pll_peripheral_clk),
      .pll_sys_clk                         (pll_sys_clk),
      .ref_clk_to_the_tse_mac              (ref_clk_to_the_tse_mac),
      .reset_n                             (reset_n),
      .rxp_to_the_tse_mac                  (rxp_to_the_tse_mac),
      .select_n_to_the_ext_flash           (select_n_to_the_ext_flash),
      .txp_from_the_tse_mac                (txp_from_the_tse_mac)
    );

  ext_flash the_ext_flash
    (
      .address  (flash_tristate_bridge_address[24 : 1]),
      .data     (flash_tristate_bridge_data),
      .read_n   (flash_tristate_bridge_readn),
      .select_n (select_n_to_the_ext_flash),
      .write_n  (flash_tristate_bridge_writen)
    );

  tse_mac_loopback the_tse_mac_loopback
    (
      .ref_clk (ref_clk_to_the_tse_mac),
      .rxp     (rxp_to_the_tse_mac),
      .txp     (txp_from_the_tse_mac)
    );

  initial
    ext_clk = 1'b0;
  always
    #10 ext_clk <= ~ext_clk;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on