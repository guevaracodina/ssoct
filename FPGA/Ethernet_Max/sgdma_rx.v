//Legal Notice: (C)2012 Altera Corporation. All rights reserved.  Your
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

module control_status_slave_which_resides_within_sgdma_rx (
                                                            // inputs:
                                                             atlantic_error,
                                                             chain_run,
                                                             clk,
                                                             command_fifo_empty,
                                                             csr_address,
                                                             csr_chipselect,
                                                             csr_read,
                                                             csr_write,
                                                             csr_writedata,
                                                             desc_address_fifo_empty,
                                                             descriptor_write_busy,
                                                             descriptor_write_write,
                                                             owned_by_hw,
                                                             reset_n,
                                                             status_token_fifo_empty,
                                                             status_token_fifo_rdreq,
                                                             t_eop,
                                                             write_go,

                                                            // outputs:
                                                             csr_irq,
                                                             csr_readdata,
                                                             descriptor_pointer_lower_reg_out,
                                                             descriptor_pointer_upper_reg_out,
                                                             park,
                                                             run,
                                                             sw_reset
                                                          )
;

  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] descriptor_pointer_lower_reg_out;
  output  [ 31: 0] descriptor_pointer_upper_reg_out;
  output           park;
  output           run;
  output           sw_reset;
  input            atlantic_error;
  input            chain_run;
  input            clk;
  input            command_fifo_empty;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input            desc_address_fifo_empty;
  input            descriptor_write_busy;
  input            descriptor_write_write;
  input            owned_by_hw;
  input            reset_n;
  input            status_token_fifo_empty;
  input            status_token_fifo_rdreq;
  input            t_eop;
  input            write_go;

  reg              busy;
  reg              chain_completed;
  reg              chain_completed_int;
  wire             chain_completed_rise;
  wire             clear_chain_completed;
  wire             clear_descriptor_completed;
  wire             clear_eop_encountered;
  wire             clear_error;
  reg              clear_interrupt;
  wire             clear_run;
  reg     [ 31: 0] control_reg;
  wire             control_reg_en;
  wire             csr_control;
  reg              csr_irq;
  reg     [ 31: 0] csr_readdata;
  wire             csr_status;
  reg              delayed_chain_completed;
  reg              delayed_csr_write;
  reg     [  7: 0] delayed_descriptor_counter;
  reg              delayed_descriptor_write_write;
  reg              delayed_eop_encountered;
  reg              delayed_run;
  reg              descriptor_completed;
  reg     [  7: 0] descriptor_counter;
  reg     [ 31: 0] descriptor_pointer_lower_reg;
  wire             descriptor_pointer_lower_reg_en;
  wire    [ 31: 0] descriptor_pointer_lower_reg_out;
  reg     [ 31: 0] descriptor_pointer_upper_reg;
  wire             descriptor_pointer_upper_reg_en;
  wire    [ 31: 0] descriptor_pointer_upper_reg_out;
  wire             descriptor_write_write_fall;
  reg              eop_encountered;
  wire             eop_encountered_rise;
  reg              error;
  wire             ie_chain_completed;
  wire             ie_descriptor_completed;
  wire             ie_eop_encountered;
  wire             ie_error;
  wire             ie_global;
  wire             ie_max_desc_processed;
  wire    [  7: 0] max_desc_processed;
  wire             park;
  wire             run;
  wire    [ 31: 0] status_reg;
  wire             stop_dma_error;
  wire             sw_reset;
  //csr, which is an e_avalon_slave
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          csr_readdata <= 0;
      else if (csr_read)
          csr_readdata <= (csr_address == 4'b0) ? status_reg : (csr_address == {4'b0100}) ? control_reg : (csr_address == {4'b1100}) ? descriptor_pointer_upper_reg : (csr_address == {4'b1000}) ? descriptor_pointer_lower_reg : 32'b0;
    end


  //register outs
  assign descriptor_pointer_upper_reg_out = descriptor_pointer_upper_reg;
  assign descriptor_pointer_lower_reg_out = descriptor_pointer_lower_reg;
  //control register bits
  assign ie_error = control_reg[0];
  assign ie_eop_encountered = control_reg[1];
  assign ie_descriptor_completed = control_reg[2];
  assign ie_chain_completed = control_reg[3];
  assign ie_global = control_reg[4];
  assign run = control_reg[5] && !(stop_dma_error && error) && !chain_completed_int;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_run <= 0;
      else 
        delayed_run <= run;
    end


  assign stop_dma_error = control_reg[6];
  assign ie_max_desc_processed = control_reg[7];
  assign max_desc_processed = control_reg[15 : 8];
  assign sw_reset = control_reg[16];
  assign park = control_reg[17];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clear_interrupt <= 0;
      else 
        clear_interrupt <= control_reg_en ? csr_writedata[31] : 0;
    end


  //control register
  assign control_reg_en = (csr_address == { 4'b0100}) && csr_write && csr_chipselect;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          control_reg <= 0;
      else if (control_reg_en)
          control_reg <= {1'b0, csr_writedata[30 : 0]};
    end


  //descriptor_pointer_upper_reg
  assign descriptor_pointer_upper_reg_en = (csr_address == { 4'b1100}) && csr_write && csr_chipselect;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_pointer_upper_reg <= 0;
      else if (descriptor_pointer_upper_reg_en)
          descriptor_pointer_upper_reg <= csr_writedata;
    end


  //descriptor_pointer_lower_reg
  assign descriptor_pointer_lower_reg_en = (csr_address == { 4'b1000}) && csr_write && csr_chipselect;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_pointer_lower_reg <= 0;
      else if (descriptor_pointer_lower_reg_en)
          descriptor_pointer_lower_reg <= csr_writedata;
    end


  //status register
  assign status_reg = {27'b0, busy, chain_completed, descriptor_completed, eop_encountered, error};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          busy <= 0;
      else 
        busy <= ~command_fifo_empty || ~status_token_fifo_empty || ~desc_address_fifo_empty || chain_run || descriptor_write_busy || delayed_csr_write || owned_by_hw || write_go;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_completed <= 0;
      else if ((run && ~owned_by_hw && ~busy) || clear_chain_completed)
          chain_completed <= clear_chain_completed ? 1'b0 : ~delayed_csr_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_completed_int <= 0;
      else if ((run && ~owned_by_hw && ~busy) || clear_run)
          chain_completed_int <= clear_run ? 1'b0 : ~delayed_csr_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_csr_write <= 0;
      else 
        delayed_csr_write <= csr_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_completed <= 0;
      else if (descriptor_write_write_fall || clear_descriptor_completed)
          descriptor_completed <= ~clear_descriptor_completed;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          error <= 0;
      else if (atlantic_error || clear_error)
          error <= ~clear_error;
    end


  assign csr_status = csr_write && csr_chipselect && (csr_address == 4'b0);
  assign clear_chain_completed = csr_writedata[3] && csr_status;
  assign clear_descriptor_completed = csr_writedata[2] && csr_status;
  assign clear_error = csr_writedata[0] && csr_status;
  assign csr_control = csr_write && csr_chipselect && (csr_address == 4'h4);
  assign clear_run = !csr_writedata[5] && csr_control;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_eop_encountered <= 0;
      else 
        delayed_eop_encountered <= eop_encountered;
    end


  assign eop_encountered_rise = ~delayed_eop_encountered && eop_encountered;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_descriptor_write_write <= 0;
      else 
        delayed_descriptor_write_write <= descriptor_write_write;
    end


  assign descriptor_write_write_fall = delayed_descriptor_write_write && ~descriptor_write_write;
  //eop_encountered register
  assign clear_eop_encountered = csr_writedata[1] && csr_status;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_encountered <= 0;
      else if (t_eop || clear_eop_encountered)
          eop_encountered <= ~clear_eop_encountered;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_chain_completed <= 0;
      else 
        delayed_chain_completed <= chain_completed;
    end


  assign chain_completed_rise = ~delayed_chain_completed && chain_completed;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_counter <= 0;
      else if (status_token_fifo_rdreq)
          descriptor_counter <= descriptor_counter + 1'b1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_descriptor_counter <= 0;
      else 
        delayed_descriptor_counter <= descriptor_counter;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          csr_irq <= 0;
      else 
        csr_irq <= csr_irq ? ~clear_interrupt : (delayed_run && ie_global && ((ie_error && error) || (ie_eop_encountered && eop_encountered_rise) || (ie_descriptor_completed && descriptor_write_write_fall) || (ie_chain_completed && chain_completed_rise) || (ie_max_desc_processed && (descriptor_counter == max_desc_processed) && (delayed_descriptor_counter == max_desc_processed - 1) )));
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo (
                                                                         // inputs:
                                                                          clk,
                                                                          controlbitsfifo_data,
                                                                          controlbitsfifo_rdreq,
                                                                          controlbitsfifo_wrreq,
                                                                          reset,

                                                                         // outputs:
                                                                          controlbitsfifo_empty,
                                                                          controlbitsfifo_full,
                                                                          controlbitsfifo_q
                                                                       )
;

  output           controlbitsfifo_empty;
  output           controlbitsfifo_full;
  output  [  6: 0] controlbitsfifo_q;
  input            clk;
  input   [  6: 0] controlbitsfifo_data;
  input            controlbitsfifo_rdreq;
  input            controlbitsfifo_wrreq;
  input            reset;

  wire             controlbitsfifo_empty;
  wire             controlbitsfifo_full;
  wire    [  6: 0] controlbitsfifo_q;
  scfifo descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo
    (
      .aclr (reset),
      .clock (clk),
      .data (controlbitsfifo_data),
      .empty (controlbitsfifo_empty),
      .full (controlbitsfifo_full),
      .q (controlbitsfifo_q),
      .rdreq (controlbitsfifo_rdreq),
      .wrreq (controlbitsfifo_wrreq)
    );

  defparam descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.add_ram_output_register = "ON",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.intended_device_family = "STRATIXIV",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.lpm_numwords = 2,
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.lpm_showahead = "OFF",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.lpm_type = "scfifo",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.lpm_width = 7,
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.lpm_widthu = 1,
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.overflow_checking = "ON",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.underflow_checking = "ON",
           descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo_controlbitsfifo.use_eab = "OFF";


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_read_which_resides_within_sgdma_rx (
                                                       // inputs:
                                                        clk,
                                                        command_fifo_full,
                                                        controlbitsfifo_rdreq,
                                                        desc_address_fifo_full,
                                                        descriptor_pointer_lower_reg_out,
                                                        descriptor_pointer_upper_reg_out,
                                                        descriptor_read_readdata,
                                                        descriptor_read_readdatavalid,
                                                        descriptor_read_waitrequest,
                                                        reset,
                                                        reset_n,
                                                        run,

                                                       // outputs:
                                                        atlantic_channel,
                                                        chain_run,
                                                        command_fifo_data,
                                                        command_fifo_wrreq,
                                                        control,
                                                        controlbitsfifo_q,
                                                        desc_address_fifo_data,
                                                        desc_address_fifo_wrreq,
                                                        descriptor_read_address,
                                                        descriptor_read_read,
                                                        generate_eop,
                                                        next_desc,
                                                        owned_by_hw,
                                                        read_fixed_address,
                                                        write_fixed_address
                                                     )
;

  output  [  3: 0] atlantic_channel;
  output           chain_run;
  output  [103: 0] command_fifo_data;
  output           command_fifo_wrreq;
  output  [  7: 0] control;
  output  [  6: 0] controlbitsfifo_q;
  output  [ 31: 0] desc_address_fifo_data;
  output           desc_address_fifo_wrreq;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output           generate_eop;
  output  [ 31: 0] next_desc;
  output           owned_by_hw;
  output           read_fixed_address;
  output           write_fixed_address;
  input            clk;
  input            command_fifo_full;
  input            controlbitsfifo_rdreq;
  input            desc_address_fifo_full;
  input   [ 31: 0] descriptor_pointer_lower_reg_out;
  input   [ 31: 0] descriptor_pointer_upper_reg_out;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            reset;
  input            reset_n;
  input            run;

  wire    [  3: 0] atlantic_channel;
  wire    [ 15: 0] bytes_to_transfer;
  reg              chain_run;
  wire    [103: 0] command_fifo_data;
  reg              command_fifo_wrreq;
  wire             command_fifo_wrreq_in;
  wire    [  7: 0] control;
  wire    [  6: 0] controlbitsfifo_data;
  wire             controlbitsfifo_empty;
  wire             controlbitsfifo_full;
  wire    [  6: 0] controlbitsfifo_q;
  wire             controlbitsfifo_wrreq;
  reg              delayed_desc_reg_en;
  reg              delayed_run;
  reg     [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_wrreq;
  reg     [255: 0] desc_assembler;
  reg              desc_read_start;
  reg     [255: 0] desc_reg;
  wire             desc_reg_en;
  reg     [ 31: 0] descriptor_read_address;
  reg              descriptor_read_completed;
  wire             descriptor_read_completed_in;
  reg              descriptor_read_read;
  wire             fifos_not_full;
  wire             generate_eop;
  wire             got_one_descriptor;
  wire    [255: 0] init_descriptor;
  wire    [ 31: 0] next_desc;
  wire             owned_by_hw;
  reg     [  3: 0] posted_desc_counter;
  reg              posted_read_queued;
  wire    [ 31: 0] read_address;
  wire    [  7: 0] read_burst;
  wire             read_fixed_address;
  reg     [  3: 0] received_desc_counter;
  reg              run_rising_edge;
  wire             run_rising_edge_in;
  reg              started;
  wire             started_in;
  wire    [ 31: 0] write_address;
  wire    [  7: 0] write_burst;
  wire             write_fixed_address;
  //descriptor_read, which is an e_avalon_master
  //Control assignments
  assign command_fifo_wrreq_in = chain_run && fifos_not_full && delayed_desc_reg_en && owned_by_hw;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_fifo_wrreq <= 0;
      else 
        command_fifo_wrreq <= command_fifo_wrreq_in;
    end


  assign desc_address_fifo_wrreq = command_fifo_wrreq;
  assign fifos_not_full = ~command_fifo_full && ~desc_address_fifo_full;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_desc_reg_en <= 0;
      else 
        delayed_desc_reg_en <= desc_reg_en;
    end


  assign read_address = desc_reg[31 : 0];
  assign write_address = desc_reg[95 : 64];
  assign next_desc = desc_reg[159 : 128];
  assign bytes_to_transfer = desc_reg[207 : 192];
  assign read_burst = desc_reg[215 : 208];
  assign write_burst = desc_reg[223 : 216];
  assign control = desc_reg[255 : 248];
  assign command_fifo_data = {control, write_burst, read_burst, bytes_to_transfer, write_address, read_address};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_address_fifo_data <= 0;
      else if (desc_reg_en)
          desc_address_fifo_data <= next_desc;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          received_desc_counter <= 0;
      else 
        received_desc_counter <= (received_desc_counter == 8)? 0 : (descriptor_read_readdatavalid ? (received_desc_counter + 1) : received_desc_counter);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          posted_desc_counter <= 0;
      else 
        posted_desc_counter <= (desc_read_start & owned_by_hw & (posted_desc_counter != 8)) ? 8 : ((|posted_desc_counter & ~descriptor_read_waitrequest & fifos_not_full) ? (posted_desc_counter - 1) : posted_desc_counter);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_read_start <= 0;
      else if (~descriptor_read_waitrequest)
          desc_read_start <= desc_read_start ? 0 : ((~(desc_reg_en | delayed_desc_reg_en | command_fifo_wrreq | |received_desc_counter)) ? (chain_run & fifos_not_full & ~|posted_desc_counter & ~posted_read_queued) : 0);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_run <= 0;
      else 
        chain_run <= (run && owned_by_hw | (delayed_desc_reg_en | desc_reg_en) | |posted_desc_counter | |received_desc_counter) || run_rising_edge_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_read <= 0;
      else if (~descriptor_read_waitrequest)
          descriptor_read_read <= |posted_desc_counter & fifos_not_full;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_address <= 0;
      else if (~descriptor_read_waitrequest)
          descriptor_read_address <= (descriptor_read_read)? (descriptor_read_address + 4) : next_desc;
    end


  assign descriptor_read_completed_in = started ? (run && ~owned_by_hw && ~|posted_desc_counter) : descriptor_read_completed;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          posted_read_queued <= 0;
      else 
        posted_read_queued <= posted_read_queued ? ~(got_one_descriptor) : (descriptor_read_read);
    end


  //control bits
  assign generate_eop = control[0];
  assign read_fixed_address = control[1];
  assign write_fixed_address = control[2];
  assign atlantic_channel = control[6 : 3];
  assign owned_by_hw = control[7];
  assign got_one_descriptor = received_desc_counter == 8;
  //read descriptor
  assign desc_reg_en = chain_run && got_one_descriptor;
  assign init_descriptor = {1'b1, 31'b0, 32'b0, descriptor_pointer_upper_reg_out, descriptor_pointer_lower_reg_out, 128'b0};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_reg <= 0;
      else if (desc_reg_en || run_rising_edge_in)
          desc_reg <= run_rising_edge_in ? init_descriptor : desc_assembler;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_assembler <= 0;
      else if (descriptor_read_readdatavalid)
          desc_assembler <= desc_assembler >> 32 | {descriptor_read_readdata, 224'b0};
    end


  //descriptor_read_completed register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_completed <= 0;
      else 
        descriptor_read_completed <= descriptor_read_completed_in;
    end


  //started register
  assign started_in = (run_rising_edge || run_rising_edge_in) ? 1'b1 : (descriptor_read_completed ? 1'b0 : started);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          started <= 0;
      else 
        started <= started_in;
    end


  //delayed_run signal for the rising edge detector
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_run <= 0;
      else 
        delayed_run <= run;
    end


  //Run rising edge detector
  assign run_rising_edge_in = run & ~delayed_run;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          run_rising_edge <= 0;
      else if (run_rising_edge_in || desc_reg_en)
          run_rising_edge <= run_rising_edge_in;
    end


  //the_descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo, which is an e_instance
  descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo the_descriptor_read_which_resides_within_sgdma_rx_control_bits_fifo
    (
      .clk                   (clk),
      .controlbitsfifo_data  (controlbitsfifo_data),
      .controlbitsfifo_empty (controlbitsfifo_empty),
      .controlbitsfifo_full  (controlbitsfifo_full),
      .controlbitsfifo_q     (controlbitsfifo_q),
      .controlbitsfifo_rdreq (controlbitsfifo_rdreq),
      .controlbitsfifo_wrreq (controlbitsfifo_wrreq),
      .reset                 (reset)
    );

  assign controlbitsfifo_data = control[6 : 0];
  assign controlbitsfifo_wrreq = command_fifo_wrreq;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_write_which_resides_within_sgdma_rx (
                                                        // inputs:
                                                         clk,
                                                         controlbitsfifo_q,
                                                         desc_address_fifo_empty,
                                                         desc_address_fifo_q,
                                                         descriptor_write_waitrequest,
                                                         park,
                                                         reset_n,
                                                         status_token_fifo_data,
                                                         status_token_fifo_empty,
                                                         status_token_fifo_q,

                                                        // outputs:
                                                         atlantic_error,
                                                         controlbitsfifo_rdreq,
                                                         desc_address_fifo_rdreq,
                                                         descriptor_write_address,
                                                         descriptor_write_busy,
                                                         descriptor_write_write,
                                                         descriptor_write_writedata,
                                                         status_token_fifo_rdreq,
                                                         t_eop
                                                      )
;

  output           atlantic_error;
  output           controlbitsfifo_rdreq;
  output           desc_address_fifo_rdreq;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_busy;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output           status_token_fifo_rdreq;
  output           t_eop;
  input            clk;
  input   [  6: 0] controlbitsfifo_q;
  input            desc_address_fifo_empty;
  input   [ 31: 0] desc_address_fifo_q;
  input            descriptor_write_waitrequest;
  input            park;
  input            reset_n;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_empty;
  input   [ 23: 0] status_token_fifo_q;

  wire             atlantic_error;
  wire             can_write;
  wire             controlbitsfifo_rdreq;
  wire             desc_address_fifo_rdreq;
  reg     [ 31: 0] descriptor_write_address;
  wire             descriptor_write_busy;
  reg              descriptor_write_write;
  reg              descriptor_write_write0;
  reg     [ 31: 0] descriptor_write_writedata;
  wire             fifos_not_empty;
  wire    [  7: 0] status_reg;
  reg              status_token_fifo_rdreq;
  wire             status_token_fifo_rdreq_in;
  wire             t_eop;
  //descriptor_write, which is an e_avalon_master
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_writedata <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_writedata <= {park, controlbitsfifo_q, status_token_fifo_q};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_address <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_address <= desc_address_fifo_q + 28;
    end


  assign fifos_not_empty = ~status_token_fifo_empty && ~desc_address_fifo_empty;
  assign can_write = ~descriptor_write_waitrequest && fifos_not_empty;
  //write register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_write0 <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_write0 <= status_token_fifo_rdreq;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_write <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_write <= descriptor_write_write0;
    end


  //status_token_fifo_rdreq register
  assign status_token_fifo_rdreq_in = status_token_fifo_rdreq ? 1'b0 : can_write;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          status_token_fifo_rdreq <= 0;
      else 
        status_token_fifo_rdreq <= status_token_fifo_rdreq_in;
    end


  assign desc_address_fifo_rdreq = status_token_fifo_rdreq;
  assign descriptor_write_busy = descriptor_write_write0 | descriptor_write_write;
  assign status_reg = status_token_fifo_data[23 : 16];
  assign t_eop = status_reg[7];
  assign atlantic_error = status_reg[6] | status_reg[5] | status_reg[4] | status_reg[3] | status_reg[2] | status_reg[1] | status_reg[0];
  assign controlbitsfifo_rdreq = status_token_fifo_rdreq;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_chain (
                        // inputs:
                         clk,
                         command_fifo_empty,
                         command_fifo_full,
                         csr_address,
                         csr_chipselect,
                         csr_read,
                         csr_write,
                         csr_writedata,
                         desc_address_fifo_empty,
                         desc_address_fifo_full,
                         desc_address_fifo_q,
                         descriptor_read_readdata,
                         descriptor_read_readdatavalid,
                         descriptor_read_waitrequest,
                         descriptor_write_waitrequest,
                         reset,
                         reset_n,
                         status_token_fifo_data,
                         status_token_fifo_empty,
                         status_token_fifo_q,
                         write_go,

                        // outputs:
                         command_fifo_data,
                         command_fifo_wrreq,
                         csr_irq,
                         csr_readdata,
                         desc_address_fifo_data,
                         desc_address_fifo_rdreq,
                         desc_address_fifo_wrreq,
                         descriptor_read_address,
                         descriptor_read_read,
                         descriptor_write_address,
                         descriptor_write_write,
                         descriptor_write_writedata,
                         status_token_fifo_rdreq,
                         sw_reset
                      )
;

  output  [103: 0] command_fifo_data;
  output           command_fifo_wrreq;
  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] desc_address_fifo_data;
  output           desc_address_fifo_rdreq;
  output           desc_address_fifo_wrreq;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output           status_token_fifo_rdreq;
  output           sw_reset;
  input            clk;
  input            command_fifo_empty;
  input            command_fifo_full;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input            desc_address_fifo_empty;
  input            desc_address_fifo_full;
  input   [ 31: 0] desc_address_fifo_q;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            descriptor_write_waitrequest;
  input            reset;
  input            reset_n;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_empty;
  input   [ 23: 0] status_token_fifo_q;
  input            write_go;

  wire    [  3: 0] atlantic_channel;
  wire             atlantic_error;
  wire             chain_run;
  wire    [103: 0] command_fifo_data;
  wire             command_fifo_wrreq;
  wire    [  7: 0] control;
  wire    [  6: 0] controlbitsfifo_q;
  wire             controlbitsfifo_rdreq;
  wire             csr_irq;
  wire    [ 31: 0] csr_readdata;
  wire    [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_rdreq;
  wire             desc_address_fifo_wrreq;
  wire    [ 31: 0] descriptor_pointer_lower_reg_out;
  wire    [ 31: 0] descriptor_pointer_upper_reg_out;
  wire    [ 31: 0] descriptor_read_address;
  wire             descriptor_read_read;
  wire    [ 31: 0] descriptor_write_address;
  wire             descriptor_write_busy;
  wire             descriptor_write_write;
  wire    [ 31: 0] descriptor_write_writedata;
  wire             generate_eop;
  wire    [ 31: 0] next_desc;
  wire             owned_by_hw;
  wire             park;
  wire             read_fixed_address;
  wire             run;
  wire             status_token_fifo_rdreq;
  wire             sw_reset;
  wire             t_eop;
  wire             write_fixed_address;
  control_status_slave_which_resides_within_sgdma_rx the_control_status_slave_which_resides_within_sgdma_rx
    (
      .atlantic_error                   (atlantic_error),
      .chain_run                        (chain_run),
      .clk                              (clk),
      .command_fifo_empty               (command_fifo_empty),
      .csr_address                      (csr_address),
      .csr_chipselect                   (csr_chipselect),
      .csr_irq                          (csr_irq),
      .csr_read                         (csr_read),
      .csr_readdata                     (csr_readdata),
      .csr_write                        (csr_write),
      .csr_writedata                    (csr_writedata),
      .desc_address_fifo_empty          (desc_address_fifo_empty),
      .descriptor_pointer_lower_reg_out (descriptor_pointer_lower_reg_out),
      .descriptor_pointer_upper_reg_out (descriptor_pointer_upper_reg_out),
      .descriptor_write_busy            (descriptor_write_busy),
      .descriptor_write_write           (descriptor_write_write),
      .owned_by_hw                      (owned_by_hw),
      .park                             (park),
      .reset_n                          (reset_n),
      .run                              (run),
      .status_token_fifo_empty          (status_token_fifo_empty),
      .status_token_fifo_rdreq          (status_token_fifo_rdreq),
      .sw_reset                         (sw_reset),
      .t_eop                            (t_eop),
      .write_go                         (write_go)
    );

  descriptor_read_which_resides_within_sgdma_rx the_descriptor_read_which_resides_within_sgdma_rx
    (
      .atlantic_channel                 (atlantic_channel),
      .chain_run                        (chain_run),
      .clk                              (clk),
      .command_fifo_data                (command_fifo_data),
      .command_fifo_full                (command_fifo_full),
      .command_fifo_wrreq               (command_fifo_wrreq),
      .control                          (control),
      .controlbitsfifo_q                (controlbitsfifo_q),
      .controlbitsfifo_rdreq            (controlbitsfifo_rdreq),
      .desc_address_fifo_data           (desc_address_fifo_data),
      .desc_address_fifo_full           (desc_address_fifo_full),
      .desc_address_fifo_wrreq          (desc_address_fifo_wrreq),
      .descriptor_pointer_lower_reg_out (descriptor_pointer_lower_reg_out),
      .descriptor_pointer_upper_reg_out (descriptor_pointer_upper_reg_out),
      .descriptor_read_address          (descriptor_read_address),
      .descriptor_read_read             (descriptor_read_read),
      .descriptor_read_readdata         (descriptor_read_readdata),
      .descriptor_read_readdatavalid    (descriptor_read_readdatavalid),
      .descriptor_read_waitrequest      (descriptor_read_waitrequest),
      .generate_eop                     (generate_eop),
      .next_desc                        (next_desc),
      .owned_by_hw                      (owned_by_hw),
      .read_fixed_address               (read_fixed_address),
      .reset                            (reset),
      .reset_n                          (reset_n),
      .run                              (run),
      .write_fixed_address              (write_fixed_address)
    );

  descriptor_write_which_resides_within_sgdma_rx the_descriptor_write_which_resides_within_sgdma_rx
    (
      .atlantic_error               (atlantic_error),
      .clk                          (clk),
      .controlbitsfifo_q            (controlbitsfifo_q),
      .controlbitsfifo_rdreq        (controlbitsfifo_rdreq),
      .desc_address_fifo_empty      (desc_address_fifo_empty),
      .desc_address_fifo_q          (desc_address_fifo_q),
      .desc_address_fifo_rdreq      (desc_address_fifo_rdreq),
      .descriptor_write_address     (descriptor_write_address),
      .descriptor_write_busy        (descriptor_write_busy),
      .descriptor_write_waitrequest (descriptor_write_waitrequest),
      .descriptor_write_write       (descriptor_write_write),
      .descriptor_write_writedata   (descriptor_write_writedata),
      .park                         (park),
      .reset_n                      (reset_n),
      .status_token_fifo_data       (status_token_fifo_data),
      .status_token_fifo_empty      (status_token_fifo_empty),
      .status_token_fifo_q          (status_token_fifo_q),
      .status_token_fifo_rdreq      (status_token_fifo_rdreq),
      .t_eop                        (t_eop)
    );


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_command_grabber (
                                  // inputs:
                                   clk,
                                   command_fifo_empty,
                                   command_fifo_q,
                                   m_write_waitrequest,
                                   reset_n,
                                   write_go,

                                  // outputs:
                                   command_fifo_rdreq,
                                   generate_eop,
                                   write_command_data,
                                   write_command_valid
                                )
;

  output           command_fifo_rdreq;
  output           generate_eop;
  output  [ 56: 0] write_command_data;
  output           write_command_valid;
  input            clk;
  input            command_fifo_empty;
  input   [103: 0] command_fifo_q;
  input            m_write_waitrequest;
  input            reset_n;
  input            write_go;

  wire    [  3: 0] atlantic_channel;
  wire    [ 15: 0] bytes_to_transfer;
  wire             command_fifo_rdreq;
  wire             command_fifo_rdreq_in;
  reg              command_fifo_rdreq_reg;
  reg              command_valid;
  wire    [  7: 0] control;
  reg              delay1_command_valid;
  wire             generate_eop;
  wire    [ 31: 0] read_address;
  wire    [  7: 0] read_burst;
  wire             read_fixed_address;
  wire    [ 31: 0] write_address;
  wire    [  7: 0] write_burst;
  reg     [ 56: 0] write_command_data;
  wire             write_command_valid;
  wire             write_fixed_address;
  //Descriptor components
  assign read_address = command_fifo_q[31 : 0];
  assign write_address = command_fifo_q[63 : 32];
  assign bytes_to_transfer = command_fifo_q[79 : 64];
  assign read_burst = command_fifo_q[87 : 80];
  assign write_burst = command_fifo_q[95 : 88];
  assign control = command_fifo_q[103 : 96];
  //control bits
  assign generate_eop = control[0];
  assign read_fixed_address = control[1];
  assign write_fixed_address = control[2];
  assign atlantic_channel = control[6 : 3];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_command_data <= 0;
      else 
        write_command_data <= {~write_fixed_address, write_burst, bytes_to_transfer, write_address};
    end


  assign write_command_valid = command_valid;
  //command_fifo_rdreq register
  assign command_fifo_rdreq_in = (command_fifo_rdreq_reg || command_valid) ? 1'b0 : (~write_go && ~m_write_waitrequest);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_fifo_rdreq_reg <= 0;
      else if (~command_fifo_empty)
          command_fifo_rdreq_reg <= command_fifo_rdreq_in;
    end


  assign command_fifo_rdreq = command_fifo_rdreq_reg;
  //command_valid register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delay1_command_valid <= 0;
      else 
        delay1_command_valid <= command_fifo_rdreq_reg;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_valid <= 0;
      else 
        command_valid <= delay1_command_valid;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sixteen_bit_byteenable_FSM_which_resides_within_sgdma_rx (
                                                                  // inputs:
                                                                   byteenable_in,
                                                                   clk,
                                                                   reset_n,
                                                                   waitrequest_in,
                                                                   write_in,

                                                                  // outputs:
                                                                   byteenable_out,
                                                                   waitrequest_out
                                                                )
;

  output  [  1: 0] byteenable_out;
  output           waitrequest_out;
  input   [  1: 0] byteenable_in;
  input            clk;
  input            reset_n;
  input            waitrequest_in;
  input            write_in;

  wire    [  1: 0] byteenable_out;
  wire             waitrequest_out;
  assign byteenable_out = byteenable_in & {2{write_in}};
  assign waitrequest_out = waitrequest_in | ((write_in == 1) & (waitrequest_in == 1));

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module thirty_two_bit_byteenable_FSM_which_resides_within_sgdma_rx (
                                                                     // inputs:
                                                                      byteenable_in,
                                                                      clk,
                                                                      reset_n,
                                                                      waitrequest_in,
                                                                      write_in,

                                                                     // outputs:
                                                                      byteenable_out,
                                                                      waitrequest_out
                                                                   )
;

  output  [  3: 0] byteenable_out;
  output           waitrequest_out;
  input   [  3: 0] byteenable_in;
  input            clk;
  input            reset_n;
  input            waitrequest_in;
  input            write_in;

  wire             advance_to_next_state;
  wire    [  3: 0] byteenable_out;
  wire             full_lower_half_transfer;
  wire             full_upper_half_transfer;
  wire             full_word_transfer;
  wire             lower_enable;
  wire             lower_stall;
  wire             partial_lower_half_transfer;
  wire             partial_upper_half_transfer;
  reg              state_bit;
  wire             transfer_done;
  wire             two_stage_transfer;
  wire             upper_enable;
  wire             upper_stall;
  wire             waitrequest_out;
  assign partial_lower_half_transfer = byteenable_in[1 : 0] != 0;
  assign full_lower_half_transfer = byteenable_in[1 : 0] == {2 {1'b1}};
  assign partial_upper_half_transfer = byteenable_in[3 : 2] != 0;
  assign full_upper_half_transfer = byteenable_in[3 : 2] == {2 {1'b1}};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          state_bit <= 0;
      else if (transfer_done == 1)
          state_bit <= 0;
      else if (advance_to_next_state == 1)
          state_bit <= 1;
    end


  assign full_word_transfer = (full_lower_half_transfer == 1) & (full_upper_half_transfer == 1);
  assign two_stage_transfer = (full_word_transfer == 0) & (partial_lower_half_transfer == 1) & (partial_upper_half_transfer == 1);
  assign advance_to_next_state = (two_stage_transfer == 1) & (lower_stall == 0) & (write_in == 1) & (state_bit == 0) & (waitrequest_in == 0);
  assign transfer_done = ((full_word_transfer == 1) & (waitrequest_in == 0) & (write_in == 1)) | 
    ((two_stage_transfer == 0) & (lower_stall == 0) & (upper_stall == 0) & (write_in == 1) & (waitrequest_in == 0)) |
    ((two_stage_transfer == 1) & (state_bit == 1) & (upper_stall == 0) & (write_in == 1) & (waitrequest_in == 0));

  assign lower_enable = ((write_in == 1) & (full_word_transfer == 1)) |
    ((write_in == 1) & (two_stage_transfer == 0) & (partial_lower_half_transfer == 1)) |
    ((write_in == 1) & (two_stage_transfer == 1) & (partial_lower_half_transfer == 1) & (state_bit == 0));

  assign upper_enable = ((write_in == 1) & (full_word_transfer == 1)) |
    ((write_in == 1) & (two_stage_transfer == 0) & (partial_upper_half_transfer == 1)) |
    ((write_in == 1) & (two_stage_transfer == 1) & (partial_upper_half_transfer == 1) & (state_bit == 1));

  //lower_sixteen_bit_byteenable_FSM, which is an e_instance
  sixteen_bit_byteenable_FSM_which_resides_within_sgdma_rx lower_sixteen_bit_byteenable_FSM
    (
      .byteenable_in   (byteenable_in[1 : 0]),
      .byteenable_out  (byteenable_out[1 : 0]),
      .clk             (clk),
      .reset_n         (reset_n),
      .waitrequest_in  (waitrequest_in),
      .waitrequest_out (lower_stall),
      .write_in        (lower_enable)
    );

  //upper_sixteen_bit_byteenable_FSM, which is an e_instance
  sixteen_bit_byteenable_FSM_which_resides_within_sgdma_rx upper_sixteen_bit_byteenable_FSM
    (
      .byteenable_in   (byteenable_in[3 : 2]),
      .byteenable_out  (byteenable_out[3 : 2]),
      .clk             (clk),
      .reset_n         (reset_n),
      .waitrequest_in  (waitrequest_in),
      .waitrequest_out (upper_stall),
      .write_in        (upper_enable)
    );

  assign waitrequest_out = waitrequest_in | ((transfer_done == 0) & (write_in == 1));

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module byteenable_gen_which_resides_within_sgdma_rx (
                                                      // inputs:
                                                       byteenable_in,
                                                       clk,
                                                       reset_n,
                                                       waitrequest_in,
                                                       write_in,

                                                      // outputs:
                                                       byteenable_out,
                                                       waitrequest_out
                                                    )
;

  output  [  3: 0] byteenable_out;
  output           waitrequest_out;
  input   [  3: 0] byteenable_in;
  input            clk;
  input            reset_n;
  input            waitrequest_in;
  input            write_in;

  wire    [  3: 0] byteenable_out;
  wire             waitrequest_out;
  //the_thirty_two_bit_byteenable_FSM, which is an e_instance
  thirty_two_bit_byteenable_FSM_which_resides_within_sgdma_rx the_thirty_two_bit_byteenable_FSM
    (
      .byteenable_in   (byteenable_in),
      .byteenable_out  (byteenable_out),
      .clk             (clk),
      .reset_n         (reset_n),
      .waitrequest_in  (waitrequest_in),
      .waitrequest_out (waitrequest_out),
      .write_in        (write_in)
    );


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_m_write (
                          // inputs:
                           clk,
                           enough_data,
                           eop_found,
                           m_write_waitrequest,
                           reset_n,
                           sink_stream_data,
                           sink_stream_empty,
                           sink_stream_endofpacket,
                           sink_stream_error,
                           sink_stream_startofpacket,
                           sink_stream_valid,
                           status_token_fifo_full,
                           write_command_data,
                           write_command_valid,

                          // outputs:
                           m_write_address,
                           m_write_byteenable,
                           m_write_write,
                           m_write_writedata,
                           sink_stream_ready,
                           status_token_fifo_data,
                           status_token_fifo_wrreq,
                           write_go
                        )
;

  output  [ 31: 0] m_write_address;
  output  [  3: 0] m_write_byteenable;
  output           m_write_write;
  output  [ 31: 0] m_write_writedata;
  output           sink_stream_ready;
  output  [ 23: 0] status_token_fifo_data;
  output           status_token_fifo_wrreq;
  output           write_go;
  input            clk;
  input            enough_data;
  input            eop_found;
  input            m_write_waitrequest;
  input            reset_n;
  input   [ 31: 0] sink_stream_data;
  input   [  1: 0] sink_stream_empty;
  input            sink_stream_endofpacket;
  input   [  5: 0] sink_stream_error;
  input            sink_stream_startofpacket;
  input            sink_stream_valid;
  input            status_token_fifo_full;
  input   [ 56: 0] write_command_data;
  input            write_command_valid;

  wire    [ 15: 0] actual_bytes_transferred;
  wire    [  3: 0] all_one;
  reg     [  3: 0] burst_counter;
  wire             burst_counter_decrement;
  wire    [  3: 0] burst_counter_next;
  reg     [  3: 0] burst_counter_reg;
  wire    [  3: 0] burst_size;
  reg              byteenable_enable;
  wire    [ 15: 0] bytes_to_transfer;
  reg     [ 15: 0] counter;
  wire    [ 15: 0] counter_in;
  reg              delayed_write_command_valid;
  reg              delayed_write_go;
  wire             e_00;
  wire             e_01;
  wire             e_02;
  wire             e_03;
  wire             e_04;
  wire             e_05;
  wire             e_06;
  reg              eop_found_hold;
  reg              eop_reg;
  wire             increment;
  wire             increment_address;
  reg     [ 31: 0] m_write_address;
  wire    [  3: 0] m_write_byteenable;
  wire    [  3: 0] m_write_byteenable_in;
  reg     [  3: 0] m_write_byteenable_reg;
  wire             m_write_waitrequest_out;
  reg              m_write_write;
  reg              m_write_write_sig;
  reg     [ 31: 0] m_write_writedata;
  wire             m_writefifo_fill;
  wire    [  3: 0] shift0;
  wire    [  3: 0] shift1;
  wire    [  3: 0] shift2;
  wire    [  3: 0] shift3;
  wire             single_transfer;
  wire    [  3: 0] sink_stream_empty_shift;
  wire             sink_stream_ready;
  wire             sink_stream_really_valid;
  wire    [ 31: 0] start_address;
  reg     [  7: 0] status_reg;
  wire    [  7: 0] status_reg_in;
  wire    [ 23: 0] status_token_fifo_data;
  wire             status_token_fifo_wrreq;
  wire    [  7: 0] status_word;
  wire             t_eop;
  reg     [ 56: 0] write_command_data_reg;
  wire             write_go;
  reg              write_go_fall_reg;
  wire             write_go_fall_reg_in;
  reg              write_go_reg;
  wire             write_go_reg_in;
  wire             write_go_reg_in_teop;
  //m_write, which is an e_avalon_master
  assign burst_size = 1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_write <= 0;
      else if (~m_write_waitrequest_out)
          m_write_write <= write_go_reg & (sink_stream_really_valid | m_write_write_sig);
    end


  assign m_writefifo_fill = 1;
  //command input
  assign start_address = write_command_data_reg[31 : 0];
  assign bytes_to_transfer = write_command_data_reg[47 : 32];
  assign increment_address = write_command_data_reg[56];
  //increment or keep constant, the m_write_address depending on the command bit
  assign increment = write_go_reg & sink_stream_really_valid;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_writedata <= 0;
      else if (~m_write_waitrequest_out)
          m_write_writedata <= sink_stream_data;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_write_sig <= 0;
      else if (m_write_waitrequest_out)
          m_write_write_sig <= sink_stream_really_valid & ~m_write_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_address <= 0;
      else if (~m_write_waitrequest_out)
          m_write_address <= delayed_write_command_valid ? start_address : (increment_address ? (m_write_write ? (m_write_address + 4) : m_write_address) : start_address);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_found_hold <= 0;
      else if (write_go_reg)
          eop_found_hold <= eop_found_hold ? ~(sink_stream_endofpacket & sink_stream_really_valid) : eop_found;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          burst_counter_reg <= 0;
      else if (~m_write_waitrequest_out)
          burst_counter_reg <= burst_counter;
    end


  assign burst_counter_decrement = |burst_counter & write_go_reg & sink_stream_really_valid;
  assign burst_counter_next = burst_counter - 1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          burst_counter <= 0;
      else if (~|burst_counter & ~|burst_counter_reg & write_go_reg)
        begin
          if (enough_data)
              burst_counter <= burst_size;
          else if (eop_found_hold)
              burst_counter <= m_writefifo_fill;
        end
      else if (~m_write_waitrequest_out)
          if (burst_counter_decrement)
              burst_counter <= burst_counter_next;
    end


  assign shift3 = {3'b0, all_one[0]};
  assign shift2 = {2'b0, all_one[1 : 0]};
  assign shift1 = {1'b0, all_one[2 : 0]};
  assign shift0 = all_one;
  assign sink_stream_empty_shift = ((sink_stream_empty == 3) ? shift3 : 0) | ((sink_stream_empty == 2) ? shift2 : 0) | ((sink_stream_empty == 1) ? shift1 : 0) | ((sink_stream_empty == 0) ? shift0 : 0);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_byteenable_reg <= 0;
      else if (~m_write_waitrequest_out)
          m_write_byteenable_reg <= ((sink_stream_empty == 3) ? shift3 : 0) | ((sink_stream_empty == 2) ? shift2 : 0) | ((sink_stream_empty == 1) ? shift1 : 0) | ((sink_stream_empty == 0) ? shift0 : 0);
    end


  assign all_one = 4'b1111;
  assign m_write_byteenable_in = byteenable_enable ? m_write_byteenable_reg : all_one;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          byteenable_enable <= 0;
      else if (~m_write_waitrequest_out)
          byteenable_enable <= sink_stream_endofpacket;
    end


  assign sink_stream_ready = write_go_reg & ~m_write_waitrequest_out & ~eop_reg & (|bytes_to_transfer ? ~(counter >= bytes_to_transfer) : 1);
  //sink_stream_ready_sig
  //sink_stream_valid is only really valid when we're ready
  assign sink_stream_really_valid = sink_stream_valid && sink_stream_ready;
  //write_command_data_reg
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_command_data_reg <= 0;
      else if (write_command_valid)
          write_command_data_reg <= write_command_data;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_write_command_valid <= 0;
      else 
        delayed_write_command_valid <= write_command_valid;
    end


  //8-bits up-counter
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          counter <= 0;
      else if (~m_write_waitrequest_out)
          counter <= counter_in;
    end


  //write_go bit for all of this operation until count is up
  assign write_go_reg_in = (delayed_write_command_valid) ? 1'b1 : (counter >= bytes_to_transfer) ? 1'b0 : write_go_reg;
  assign write_go_reg_in_teop = eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : 1'b1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_reg <= 0;
      else 
        eop_reg <= eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : sink_stream_endofpacket & sink_stream_really_valid;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_go_reg <= 0;
      else if (~m_write_waitrequest_out)
          write_go_reg <= (write_go_reg && (bytes_to_transfer == 0)) ? write_go_reg_in_teop : write_go_reg_in;
    end


  assign write_go = write_go_reg;
  assign t_eop = (sink_stream_endofpacket && sink_stream_really_valid) && (bytes_to_transfer == 0);
  assign single_transfer = sink_stream_startofpacket & sink_stream_endofpacket;
  assign counter_in = (delayed_write_command_valid) ? 16'b0 : (increment ? (counter + 4 - (sink_stream_endofpacket ? sink_stream_empty : 0)) : counter);
  //status register
  assign status_reg_in = write_go_fall_reg ? 0 : (status_word | status_reg);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          status_reg <= 0;
      else 
        status_reg <= status_reg_in;
    end


  //actual_bytes_transferred register
  assign actual_bytes_transferred = counter;
  //status_token consists of the status signals and actual_bytes_transferred
  assign status_token_fifo_data = {status_reg, actual_bytes_transferred};
  assign status_word = {t_eop, e_06, e_05, e_04, e_03, e_02, e_01, e_00};
  assign e_00 = sink_stream_error[0];
  assign e_01 = sink_stream_error[1];
  assign e_02 = sink_stream_error[2];
  assign e_03 = sink_stream_error[3];
  assign e_04 = sink_stream_error[4];
  assign e_05 = sink_stream_error[5];
  assign e_06 = 1'b0;
  //delayed write go register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_write_go <= 0;
      else 
        delayed_write_go <= write_go_reg;
    end


  //write_go falling edge detector
  assign write_go_fall_reg_in = delayed_write_go && ~write_go_reg;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_go_fall_reg <= 0;
      else 
        write_go_fall_reg <= write_go_fall_reg_in;
    end


  assign status_token_fifo_wrreq = write_go_fall_reg && ~status_token_fifo_full;
  byteenable_gen_which_resides_within_sgdma_rx the_byteenable_gen_which_resides_within_sgdma_rx
    (
      .byteenable_in   (m_write_byteenable_in),
      .byteenable_out  (m_write_byteenable),
      .clk             (clk),
      .reset_n         (reset_n),
      .waitrequest_in  (m_write_waitrequest),
      .waitrequest_out (m_write_waitrequest_out),
      .write_in        (m_write_write)
    );


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_command_fifo (
                               // inputs:
                                clk,
                                command_fifo_data,
                                command_fifo_rdreq,
                                command_fifo_wrreq,
                                reset,

                               // outputs:
                                command_fifo_empty,
                                command_fifo_full,
                                command_fifo_q
                             )
;

  output           command_fifo_empty;
  output           command_fifo_full;
  output  [103: 0] command_fifo_q;
  input            clk;
  input   [103: 0] command_fifo_data;
  input            command_fifo_rdreq;
  input            command_fifo_wrreq;
  input            reset;

  wire             command_fifo_empty;
  wire             command_fifo_full;
  wire    [103: 0] command_fifo_q;
  scfifo sgdma_rx_command_fifo_command_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (command_fifo_data),
      .empty (command_fifo_empty),
      .full (command_fifo_full),
      .q (command_fifo_q),
      .rdreq (command_fifo_rdreq),
      .wrreq (command_fifo_wrreq)
    );

  defparam sgdma_rx_command_fifo_command_fifo.add_ram_output_register = "ON",
           sgdma_rx_command_fifo_command_fifo.intended_device_family = "STRATIXIV",
           sgdma_rx_command_fifo_command_fifo.lpm_numwords = 2,
           sgdma_rx_command_fifo_command_fifo.lpm_showahead = "OFF",
           sgdma_rx_command_fifo_command_fifo.lpm_type = "scfifo",
           sgdma_rx_command_fifo_command_fifo.lpm_width = 104,
           sgdma_rx_command_fifo_command_fifo.lpm_widthu = 1,
           sgdma_rx_command_fifo_command_fifo.overflow_checking = "ON",
           sgdma_rx_command_fifo_command_fifo.underflow_checking = "ON",
           sgdma_rx_command_fifo_command_fifo.use_eab = "ON";


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_desc_address_fifo (
                                    // inputs:
                                     clk,
                                     desc_address_fifo_data,
                                     desc_address_fifo_rdreq,
                                     desc_address_fifo_wrreq,
                                     reset,

                                    // outputs:
                                     desc_address_fifo_empty,
                                     desc_address_fifo_full,
                                     desc_address_fifo_q
                                  )
;

  output           desc_address_fifo_empty;
  output           desc_address_fifo_full;
  output  [ 31: 0] desc_address_fifo_q;
  input            clk;
  input   [ 31: 0] desc_address_fifo_data;
  input            desc_address_fifo_rdreq;
  input            desc_address_fifo_wrreq;
  input            reset;

  wire             desc_address_fifo_empty;
  wire             desc_address_fifo_full;
  wire    [ 31: 0] desc_address_fifo_q;
  scfifo sgdma_rx_desc_address_fifo_desc_address_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (desc_address_fifo_data),
      .empty (desc_address_fifo_empty),
      .full (desc_address_fifo_full),
      .q (desc_address_fifo_q),
      .rdreq (desc_address_fifo_rdreq),
      .wrreq (desc_address_fifo_wrreq)
    );

  defparam sgdma_rx_desc_address_fifo_desc_address_fifo.add_ram_output_register = "ON",
           sgdma_rx_desc_address_fifo_desc_address_fifo.intended_device_family = "STRATIXIV",
           sgdma_rx_desc_address_fifo_desc_address_fifo.lpm_numwords = 2,
           sgdma_rx_desc_address_fifo_desc_address_fifo.lpm_showahead = "OFF",
           sgdma_rx_desc_address_fifo_desc_address_fifo.lpm_type = "scfifo",
           sgdma_rx_desc_address_fifo_desc_address_fifo.lpm_width = 32,
           sgdma_rx_desc_address_fifo_desc_address_fifo.lpm_widthu = 1,
           sgdma_rx_desc_address_fifo_desc_address_fifo.overflow_checking = "ON",
           sgdma_rx_desc_address_fifo_desc_address_fifo.underflow_checking = "ON",
           sgdma_rx_desc_address_fifo_desc_address_fifo.use_eab = "OFF";


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx_status_token_fifo (
                                    // inputs:
                                     clk,
                                     reset,
                                     status_token_fifo_data,
                                     status_token_fifo_rdreq,
                                     status_token_fifo_wrreq,

                                    // outputs:
                                     status_token_fifo_empty,
                                     status_token_fifo_full,
                                     status_token_fifo_q
                                  )
;

  output           status_token_fifo_empty;
  output           status_token_fifo_full;
  output  [ 23: 0] status_token_fifo_q;
  input            clk;
  input            reset;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_rdreq;
  input            status_token_fifo_wrreq;

  wire             status_token_fifo_empty;
  wire             status_token_fifo_full;
  wire    [ 23: 0] status_token_fifo_q;
  scfifo sgdma_rx_status_token_fifo_status_token_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (status_token_fifo_data),
      .empty (status_token_fifo_empty),
      .full (status_token_fifo_full),
      .q (status_token_fifo_q),
      .rdreq (status_token_fifo_rdreq),
      .wrreq (status_token_fifo_wrreq)
    );

  defparam sgdma_rx_status_token_fifo_status_token_fifo.add_ram_output_register = "ON",
           sgdma_rx_status_token_fifo_status_token_fifo.intended_device_family = "STRATIXIV",
           sgdma_rx_status_token_fifo_status_token_fifo.lpm_numwords = 2,
           sgdma_rx_status_token_fifo_status_token_fifo.lpm_showahead = "OFF",
           sgdma_rx_status_token_fifo_status_token_fifo.lpm_type = "scfifo",
           sgdma_rx_status_token_fifo_status_token_fifo.lpm_width = 24,
           sgdma_rx_status_token_fifo_status_token_fifo.lpm_widthu = 1,
           sgdma_rx_status_token_fifo_status_token_fifo.overflow_checking = "ON",
           sgdma_rx_status_token_fifo_status_token_fifo.underflow_checking = "ON",
           sgdma_rx_status_token_fifo_status_token_fifo.use_eab = "ON";


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sgdma_rx (
                  // inputs:
                   clk,
                   csr_address,
                   csr_chipselect,
                   csr_read,
                   csr_write,
                   csr_writedata,
                   descriptor_read_readdata,
                   descriptor_read_readdatavalid,
                   descriptor_read_waitrequest,
                   descriptor_write_waitrequest,
                   in_data,
                   in_empty,
                   in_endofpacket,
                   in_error,
                   in_startofpacket,
                   in_valid,
                   m_write_waitrequest,
                   system_reset_n,

                  // outputs:
                   csr_irq,
                   csr_readdata,
                   descriptor_read_address,
                   descriptor_read_read,
                   descriptor_write_address,
                   descriptor_write_write,
                   descriptor_write_writedata,
                   in_ready,
                   m_write_address,
                   m_write_byteenable,
                   m_write_write,
                   m_write_writedata
                )
;

  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output           in_ready;
  output  [ 31: 0] m_write_address;
  output  [  3: 0] m_write_byteenable;
  output           m_write_write;
  output  [ 31: 0] m_write_writedata;
  input            clk;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            descriptor_write_waitrequest;
  input   [ 31: 0] in_data;
  input   [  3: 0] in_empty;
  input            in_endofpacket;
  input   [  5: 0] in_error;
  input            in_startofpacket;
  input            in_valid;
  input            m_write_waitrequest;
  input            system_reset_n;

  wire    [103: 0] command_fifo_data;
  wire             command_fifo_empty;
  wire             command_fifo_full;
  wire    [103: 0] command_fifo_q;
  wire             command_fifo_rdreq;
  wire             command_fifo_wrreq;
  wire             csr_irq;
  wire    [ 31: 0] csr_readdata;
  wire    [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_empty;
  wire             desc_address_fifo_full;
  wire    [ 31: 0] desc_address_fifo_q;
  wire             desc_address_fifo_rdreq;
  wire             desc_address_fifo_wrreq;
  wire    [ 31: 0] descriptor_read_address;
  wire             descriptor_read_read;
  wire    [ 31: 0] descriptor_write_address;
  wire             descriptor_write_write;
  wire    [ 31: 0] descriptor_write_writedata;
  wire             generate_eop;
  wire             in_ready;
  wire    [ 31: 0] m_write_address;
  wire    [  3: 0] m_write_byteenable;
  wire             m_write_write;
  wire    [ 31: 0] m_write_writedata;
  wire             reset;
  reg              reset_n;
  wire    [ 31: 0] sink_stream_data;
  wire    [  1: 0] sink_stream_empty;
  wire             sink_stream_endofpacket;
  wire    [  5: 0] sink_stream_error;
  wire             sink_stream_ready;
  wire             sink_stream_startofpacket;
  wire             sink_stream_valid;
  wire    [ 23: 0] status_token_fifo_data;
  wire             status_token_fifo_empty;
  wire             status_token_fifo_full;
  wire    [ 23: 0] status_token_fifo_q;
  wire             status_token_fifo_rdreq;
  wire             status_token_fifo_wrreq;
  wire             sw_reset;
  reg              sw_reset_d1;
  reg              sw_reset_request;
  wire    [ 56: 0] write_command_data;
  wire             write_command_valid;
  wire             write_go;
  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          reset_n <= 0;
      else 
        reset_n <= ~(~system_reset_n | sw_reset_request);
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          sw_reset_d1 <= 0;
      else if (sw_reset | sw_reset_request)
          sw_reset_d1 <= sw_reset & ~sw_reset_request;
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          sw_reset_request <= 0;
      else if (sw_reset | sw_reset_request)
          sw_reset_request <= sw_reset_d1 & ~sw_reset_request;
    end


  assign reset = ~reset_n;
  sgdma_rx_chain the_sgdma_rx_chain
    (
      .clk                           (clk),
      .command_fifo_data             (command_fifo_data),
      .command_fifo_empty            (command_fifo_empty),
      .command_fifo_full             (command_fifo_full),
      .command_fifo_wrreq            (command_fifo_wrreq),
      .csr_address                   (csr_address),
      .csr_chipselect                (csr_chipselect),
      .csr_irq                       (csr_irq),
      .csr_read                      (csr_read),
      .csr_readdata                  (csr_readdata),
      .csr_write                     (csr_write),
      .csr_writedata                 (csr_writedata),
      .desc_address_fifo_data        (desc_address_fifo_data),
      .desc_address_fifo_empty       (desc_address_fifo_empty),
      .desc_address_fifo_full        (desc_address_fifo_full),
      .desc_address_fifo_q           (desc_address_fifo_q),
      .desc_address_fifo_rdreq       (desc_address_fifo_rdreq),
      .desc_address_fifo_wrreq       (desc_address_fifo_wrreq),
      .descriptor_read_address       (descriptor_read_address),
      .descriptor_read_read          (descriptor_read_read),
      .descriptor_read_readdata      (descriptor_read_readdata),
      .descriptor_read_readdatavalid (descriptor_read_readdatavalid),
      .descriptor_read_waitrequest   (descriptor_read_waitrequest),
      .descriptor_write_address      (descriptor_write_address),
      .descriptor_write_waitrequest  (descriptor_write_waitrequest),
      .descriptor_write_write        (descriptor_write_write),
      .descriptor_write_writedata    (descriptor_write_writedata),
      .reset                         (reset),
      .reset_n                       (reset_n),
      .status_token_fifo_data        (status_token_fifo_data),
      .status_token_fifo_empty       (status_token_fifo_empty),
      .status_token_fifo_q           (status_token_fifo_q),
      .status_token_fifo_rdreq       (status_token_fifo_rdreq),
      .sw_reset                      (sw_reset),
      .write_go                      (write_go)
    );

  sgdma_rx_command_grabber the_sgdma_rx_command_grabber
    (
      .clk                 (clk),
      .command_fifo_empty  (command_fifo_empty),
      .command_fifo_q      (command_fifo_q),
      .command_fifo_rdreq  (command_fifo_rdreq),
      .generate_eop        (generate_eop),
      .m_write_waitrequest (m_write_waitrequest),
      .reset_n             (reset_n),
      .write_command_data  (write_command_data),
      .write_command_valid (write_command_valid),
      .write_go            (write_go)
    );

  sgdma_rx_m_write the_sgdma_rx_m_write
    (
      .clk                       (clk),
      .enough_data               (1'b1),
      .eop_found                 (1'b0),
      .m_write_address           (m_write_address),
      .m_write_byteenable        (m_write_byteenable),
      .m_write_waitrequest       (m_write_waitrequest),
      .m_write_write             (m_write_write),
      .m_write_writedata         (m_write_writedata),
      .reset_n                   (reset_n),
      .sink_stream_data          (sink_stream_data),
      .sink_stream_empty         (sink_stream_empty),
      .sink_stream_endofpacket   (sink_stream_endofpacket),
      .sink_stream_error         (sink_stream_error),
      .sink_stream_ready         (sink_stream_ready),
      .sink_stream_startofpacket (sink_stream_startofpacket),
      .sink_stream_valid         (sink_stream_valid),
      .status_token_fifo_data    (status_token_fifo_data),
      .status_token_fifo_full    (status_token_fifo_full),
      .status_token_fifo_wrreq   (status_token_fifo_wrreq),
      .write_command_data        (write_command_data),
      .write_command_valid       (write_command_valid),
      .write_go                  (write_go)
    );

  //the_sgdma_rx_command_fifo, which is an e_instance
  sgdma_rx_command_fifo the_sgdma_rx_command_fifo
    (
      .clk                (clk),
      .command_fifo_data  (command_fifo_data),
      .command_fifo_empty (command_fifo_empty),
      .command_fifo_full  (command_fifo_full),
      .command_fifo_q     (command_fifo_q),
      .command_fifo_rdreq (command_fifo_rdreq),
      .command_fifo_wrreq (command_fifo_wrreq),
      .reset              (reset)
    );

  //the_sgdma_rx_desc_address_fifo, which is an e_instance
  sgdma_rx_desc_address_fifo the_sgdma_rx_desc_address_fifo
    (
      .clk                     (clk),
      .desc_address_fifo_data  (desc_address_fifo_data),
      .desc_address_fifo_empty (desc_address_fifo_empty),
      .desc_address_fifo_full  (desc_address_fifo_full),
      .desc_address_fifo_q     (desc_address_fifo_q),
      .desc_address_fifo_rdreq (desc_address_fifo_rdreq),
      .desc_address_fifo_wrreq (desc_address_fifo_wrreq),
      .reset                   (reset)
    );

  //the_sgdma_rx_status_token_fifo, which is an e_instance
  sgdma_rx_status_token_fifo the_sgdma_rx_status_token_fifo
    (
      .clk                     (clk),
      .reset                   (reset),
      .status_token_fifo_data  (status_token_fifo_data),
      .status_token_fifo_empty (status_token_fifo_empty),
      .status_token_fifo_full  (status_token_fifo_full),
      .status_token_fifo_q     (status_token_fifo_q),
      .status_token_fifo_rdreq (status_token_fifo_rdreq),
      .status_token_fifo_wrreq (status_token_fifo_wrreq)
    );

  //descriptor_read, which is an e_avalon_master
  //descriptor_write, which is an e_avalon_master
  //csr, which is an e_avalon_slave
  //m_write, which is an e_avalon_master
  assign sink_stream_empty = in_empty;
  assign sink_stream_error = sink_stream_valid ? in_error : 0;
  //in, which is an e_atlantic_slave
  assign sink_stream_endofpacket = in_endofpacket;
  assign sink_stream_startofpacket = in_startofpacket;
  assign sink_stream_valid = in_valid;
  assign in_ready = sink_stream_ready;
  assign sink_stream_data = {in_data[7 : 0], in_data[15 : 8], in_data[23 : 16], in_data[31 : 24]};

endmodule

