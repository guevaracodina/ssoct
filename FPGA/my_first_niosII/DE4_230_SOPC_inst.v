  //Example instantiation for system 'DE4_230_SOPC'
  DE4_230_SOPC DE4_230_SOPC_inst
    (
      .clk_0                     (clk_0),
      .out_port_from_the_pio_LED (out_port_from_the_pio_LED),
      .reset_n                   (reset_n),
      .select_n_to_the_cfi_flash (select_n_to_the_cfi_flash),
      .tri_state_bridge_address  (tri_state_bridge_address),
      .tri_state_bridge_data     (tri_state_bridge_data),
      .tri_state_bridge_readn    (tri_state_bridge_readn),
      .tri_state_bridge_writen   (tri_state_bridge_writen)
    );

