#**************************************************************
# This .sbc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name CLK_M3 -period "50 MHZ" [get_ports {OSC_50_BANK3}]
create_clock -name CLK_M7 -period "50 MHZ" [get_ports {OSC_50_BANK7}]
create_clock -name {ADA_DCO} -period 8.0 [get_ports { ADA_DCO }]
create_clock -name CLK_ADC -period 8.0 [get_ports {PLL_CLKIN_p}]
create_clock -name CLK_50KHz -period "0.05 MHZ" [get_ports {GCLKIN}]

#**************************************************************
# Create Generated Clock
#**************************************************************
# derive_pll_clocks
derive_pll_clocks -create_base_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -exclusive -group [get_clocks {SOPC_INST|the_tse_mac|altera_tse_mac_pcs_pma_inst|the_altera_tse_pma_lvds_rx|altlvds_rx_component|auto_generated|pll|clk[0]}] 
set_clock_groups -exclusive -group [get_clocks {SOPC_INST|the_tse_mac|altera_tse_mac_pcs_pma_inst|the_altera_tse_pma_lvds_rx|altlvds_rx_component|auto_generated|pll|clk[1]}] 
set_clock_groups -exclusive -group [get_clocks {SOPC_INST|the_tse_mac|altera_tse_mac_pcs_pma_inst|the_altera_tse_pma_lvds_rx|altlvds_rx_component|auto_generated|rx[0]|clk0}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {SOPC_INST|the_pll|the_pll|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {pll_125_ins|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_write}] -to [get_registers {*|alt_jtag_atlantic:*|read_write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|td_shift[0]*}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|write_stalled*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_hd9:dffpipe19|dffe20a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_fd9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_ed9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_dd9:dffpipe12|dffe13a*}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_break:the_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[33]}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[0]}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[34]}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_ocimem:the_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_sysclk:the_cpu_jtag_debug_module_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_sysclk:the_cpu_jtag_debug_module_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*cpu:the_cpu|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_go}]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_writedata_d1*|*}] -to [get_registers *]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_nativeaddress_d1*|*}] -to [get_registers *]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_readdata_p1*}] -to [get_registers *]
set_false_path -from [get_keepers -nocase {*the*clock*|slave_readdata_p1*}] -to [get_registers *]
set_false_path -from [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_1000_base_x:top_1000_base_x_inst|altera_tse_pcs_control:U_REG|altera_tse_pcs_host_control:U_CTRL|state.STM_TYPE_TX_READ}] -to [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_1000_base_x:top_1000_base_x_inst|altera_tse_pcs_control:U_REG|altera_tse_pcs_host_control:U_CTRL|tx_rd_ack0}]
set_false_path -from [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_gen_host:top_gen_host_inst|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|pause_quant_reg[15]}] -to [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_gen_host:top_gen_host_inst|altera_tse_top_w_fifo_10_100_1000:U_MAC_TOP|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|gen_pause_muxc[7]}]
set_false_path -from [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_gen_host:top_gen_host_inst|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|pause_quant_reg[0]}] -to [get_keepers {DE4_SOPC:SOPC_INST|tse_mac:the_tse_mac|altera_tse_mac_pcs_pma:altera_tse_mac_pcs_pma_inst|altera_tse_mac_pcs_pma_ena:altera_tse_mac_pcs_pma_ena_inst|altera_tse_top_gen_host:top_gen_host_inst|altera_tse_top_w_fifo_10_100_1000:U_MAC_TOP|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|gen_pause_muxc[0]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*}] -to [get_registers *] 5
set_multicycle_path -setup -end -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*}] -to [get_registers *] 5
set_multicycle_path -setup -end -from [get_registers *] -to [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*}] 5
set_multicycle_path -hold -end -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*}] -to [get_registers *] 5
set_multicycle_path -hold -end -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*}] -to [get_registers *] 5
set_multicycle_path -hold -end -from [get_registers *] -to [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*}] 5


#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|dout_reg_sft*}] -to [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*}] 7.000
set_max_delay -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|eop_sft*}] -to [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*}] 7.000
set_max_delay -from [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|sop_reg*}] -to [get_registers {*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*}] 7.000


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



