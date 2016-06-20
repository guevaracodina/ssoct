--Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity NiosII_stratixII_2s60_RoHS_TSE_SGDMA is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal clk_to_tse_pll : IN STD_LOGIC;
                 signal in_port_to_the_button_pio : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal phy_rx_clk : IN STD_LOGIC;
                 signal phy_rx_col : IN STD_LOGIC;
                 signal phy_rx_crs : IN STD_LOGIC;
                 signal phy_rx_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal phy_rx_dv : IN STD_LOGIC;
                 signal phy_rx_err : IN STD_LOGIC;
                 signal phy_tx_clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rxd_to_the_uart1 : IN STD_LOGIC;

              -- outputs:
                 signal LCD_E_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_RS_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_RW_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_data_to_and_from_the_lcd_display : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal PLD_CLKOUT : OUT STD_LOGIC;
                 signal adsc_n_to_the_ext_ssram : OUT STD_LOGIC;
                 signal bidir_port_to_and_from_the_reconfig_request_pio : INOUT STD_LOGIC;
                 signal bw_n_to_the_ext_ssram : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal bwe_n_to_the_ext_ssram : OUT STD_LOGIC;
                 signal chipenable1_n_to_the_ext_ssram : OUT STD_LOGIC;
                 signal clk_to_sdram : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal clk_to_sdram_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_a : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal ddr_ba : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_cas_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_cke : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_cs_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_dm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal ddr_dqs : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_ras_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ddr_we_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ext_flash_enet_bus_address : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
                 signal ext_flash_enet_bus_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal ext_ssram_bus_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal ext_ssram_bus_data : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_debug_offchip_trace_clk_from_the_cpu : OUT STD_LOGIC;
                 signal jtag_debug_offchip_trace_data_from_the_cpu : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal jtag_debug_trigout_from_the_cpu : OUT STD_LOGIC;
                 signal mdc : OUT STD_LOGIC;
                 signal mdio : INOUT STD_LOGIC;
                 signal out_port_from_the_led_pio_n : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal out_port_from_the_seven_seg_pio : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal outputenable_n_to_the_ext_ssram : OUT STD_LOGIC;
                 signal phy_tx_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal phy_tx_en : OUT STD_LOGIC;
                 signal phy_tx_err : OUT STD_LOGIC;
                 signal pll_c1_out : OUT STD_LOGIC;
                 signal read_n_to_the_ext_flash : OUT STD_LOGIC;
                 signal select_n_to_the_ext_flash : OUT STD_LOGIC;
                 signal txd_from_the_uart1 : OUT STD_LOGIC;
                 signal write_n_to_the_ext_flash : OUT STD_LOGIC
              );
end entity NiosII_stratixII_2s60_RoHS_TSE_SGDMA;


architecture europa of NiosII_stratixII_2s60_RoHS_TSE_SGDMA is
  component NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc is
PORT (
    signal ddr_dq_to_and_from_the_ddr_sdram_0 : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        signal m_tx_err_from_the_tse_mac : OUT STD_LOGIC;
        signal bwe_n_to_the_ext_ssram : OUT STD_LOGIC;
        signal pll_c2_out : OUT STD_LOGIC;
        signal bidir_port_to_and_from_the_reconfig_request_pio : INOUT STD_LOGIC;
        signal ddr_a_from_the_ddr_sdram_0 : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal ddr_we_n_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal ext_ssram_bus_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
        signal ena_10_from_the_tse_mac : OUT STD_LOGIC;
        signal ddr_cke_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal select_n_to_the_ext_flash : OUT STD_LOGIC;
        signal bw_n_to_the_ext_ssram : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal ext_ssram_bus_data : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal jtag_debug_offchip_trace_data_from_the_cpu : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
        signal mdio_oen_from_the_tse_mac : OUT STD_LOGIC;
        signal eth_mode_from_the_tse_mac : OUT STD_LOGIC;
        signal ddr_ras_n_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal clk_to_sdram_n_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal ddr_dqs_to_and_from_the_ddr_sdram_0 : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal pll_c0_out : OUT STD_LOGIC;
        signal read_n_to_the_ext_flash : OUT STD_LOGIC;
        signal txd_from_the_uart1 : OUT STD_LOGIC;
        signal stratix_dll_control_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal ext_flash_enet_bus_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal ddr_dm_from_the_ddr_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal write_n_to_the_ext_flash : OUT STD_LOGIC;
        signal jtag_debug_offchip_trace_clk_from_the_cpu : OUT STD_LOGIC;
        signal gm_tx_en_from_the_tse_mac : OUT STD_LOGIC;
        signal ddr_cas_n_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal mdc_from_the_tse_mac : OUT STD_LOGIC;
        signal LCD_RW_from_the_lcd_display : OUT STD_LOGIC;
        signal m_tx_en_from_the_tse_mac : OUT STD_LOGIC;
        signal adsc_n_to_the_ext_ssram : OUT STD_LOGIC;
        signal ext_flash_enet_bus_address : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
        signal outputenable_n_to_the_ext_ssram : OUT STD_LOGIC;
        signal gm_tx_d_from_the_tse_mac : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal clk_to_sdram_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal ddr_ba_from_the_ddr_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal LCD_RS_from_the_lcd_display : OUT STD_LOGIC;
        signal pll_c1_out : OUT STD_LOGIC;
        signal tse_pll_c0_out : OUT STD_LOGIC;
        signal m_tx_d_from_the_tse_mac : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal out_port_from_the_led_pio : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal ddr_cs_n_from_the_ddr_sdram_0 : OUT STD_LOGIC;
        signal jtag_debug_trigout_from_the_cpu : OUT STD_LOGIC;
        signal out_port_from_the_seven_seg_pio : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        signal gm_tx_err_from_the_tse_mac : OUT STD_LOGIC;
        signal chipenable1_n_to_the_ext_ssram : OUT STD_LOGIC;
        signal LCD_data_to_and_from_the_lcd_display : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal LCD_E_from_the_lcd_display : OUT STD_LOGIC;
        signal mdio_out_from_the_tse_mac : OUT STD_LOGIC;
        signal m_rx_d_to_the_tse_mac : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal gm_rx_dv_to_the_tse_mac : IN STD_LOGIC;
        signal gm_rx_err_to_the_tse_mac : IN STD_LOGIC;
        signal set_1000_to_the_tse_mac : IN STD_LOGIC;
        signal gm_rx_d_to_the_tse_mac : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal clk_to_tse_pll : IN STD_LOGIC;
        signal m_rx_col_to_the_tse_mac : IN STD_LOGIC;
        signal m_rx_crs_to_the_tse_mac : IN STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal mdio_in_to_the_tse_mac : IN STD_LOGIC;
        signal m_rx_err_to_the_tse_mac : IN STD_LOGIC;
        signal set_10_to_the_tse_mac : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal tx_clk_to_the_tse_mac : IN STD_LOGIC;
        signal in_port_to_the_button_pio : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal m_rx_en_to_the_tse_mac : IN STD_LOGIC;
        signal rx_clk_to_the_tse_mac : IN STD_LOGIC;
        signal write_clk_to_the_ddr_sdram_0 : IN STD_LOGIC;
        signal rxd_to_the_uart1 : IN STD_LOGIC;
        signal dqsupdate_to_the_ddr_sdram_0 : IN STD_LOGIC;
        signal dqs_delay_ctrl_to_the_ddr_sdram_0 : IN STD_LOGIC_VECTOR (5 DOWNTO 0)
      );
  end component NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc;
  component ddr_sdram_0_auk_ddr_dll is
PORT (
    signal delayctrlout : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        signal dqsupdate : OUT STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal stratix_dll_control : IN STD_LOGIC
      );
  end component ddr_sdram_0_auk_ddr_dll;
  component gmii_mii_mux is
PORT (
    signal m_rx_dv : OUT STD_LOGIC;
        signal mdio : INOUT STD_LOGIC;
        signal tx_clk_mac : OUT STD_LOGIC;
        signal m_rx_d : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal gm_rx_dv : OUT STD_LOGIC;
        signal m_rx_col : OUT STD_LOGIC;
        signal gm_rx_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal phy_tx_en : OUT STD_LOGIC;
        signal m_rx_crs : OUT STD_LOGIC;
        signal mdio_in : OUT STD_LOGIC;
        signal phy_tx_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal m_rx_err : OUT STD_LOGIC;
        signal phy_tx_err : OUT STD_LOGIC;
        signal gm_rx_err : OUT STD_LOGIC;
        signal gtx_clk : OUT STD_LOGIC;
        signal gm_tx_en : IN STD_LOGIC;
        signal m_tx_en : IN STD_LOGIC;
        signal m_tx_err : IN STD_LOGIC;
        signal tx_clk : IN STD_LOGIC;
        signal gm_tx_err : IN STD_LOGIC;
        signal rx_clk : IN STD_LOGIC;
        signal phy_rx_err : IN STD_LOGIC;
        signal mdio_out : IN STD_LOGIC;
        signal tx_clk_ref125 : IN STD_LOGIC;
        signal m_tx_d : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal reset_rx_clk : IN STD_LOGIC;
        signal reset_tx_clk : IN STD_LOGIC;
        signal mdio_oen : IN STD_LOGIC;
        signal phy_rx_dv : IN STD_LOGIC;
        signal gm_tx_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal eth_mode : IN STD_LOGIC;
        signal phy_rx_crs : IN STD_LOGIC;
        signal phy_rx_col : IN STD_LOGIC;
        signal phy_rx_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
      );
  end component gmii_mii_mux;
                signal delayctrlout :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal dqsupdate :  STD_LOGIC;
                signal ena_10_from_the_tse_mac :  STD_LOGIC;
                signal eth_mode :  STD_LOGIC;
                signal eth_mode_from_the_tse_mac :  STD_LOGIC;
                signal gm_rx_d :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal gm_rx_d_to_the_tse_mac :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal gm_rx_dv :  STD_LOGIC;
                signal gm_rx_dv_to_the_tse_mac :  STD_LOGIC;
                signal gm_rx_err :  STD_LOGIC;
                signal gm_rx_err_to_the_tse_mac :  STD_LOGIC;
                signal gm_tx_d :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal gm_tx_d_from_the_tse_mac :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal gm_tx_en :  STD_LOGIC;
                signal gm_tx_en_from_the_tse_mac :  STD_LOGIC;
                signal gm_tx_err :  STD_LOGIC;
                signal gm_tx_err_from_the_tse_mac :  STD_LOGIC;
                signal gtx_clk :  STD_LOGIC;
                signal internal_LCD_E_from_the_lcd_display :  STD_LOGIC;
                signal internal_LCD_RS_from_the_lcd_display :  STD_LOGIC;
                signal internal_LCD_RW_from_the_lcd_display :  STD_LOGIC;
                signal internal_adsc_n_to_the_ext_ssram :  STD_LOGIC;
                signal internal_bw_n_to_the_ext_ssram :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_bwe_n_to_the_ext_ssram :  STD_LOGIC;
                signal internal_chipenable1_n_to_the_ext_ssram :  STD_LOGIC;
                signal internal_ddr_a :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal internal_ddr_ba :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_ddr_dm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_ext_flash_enet_bus_address :  STD_LOGIC_VECTOR (23 DOWNTO 0);
                signal internal_ext_ssram_bus_address :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal internal_jtag_debug_offchip_trace_clk_from_the_cpu :  STD_LOGIC;
                signal internal_jtag_debug_offchip_trace_data_from_the_cpu :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal internal_jtag_debug_trigout_from_the_cpu :  STD_LOGIC;
                signal internal_out_port_from_the_seven_seg_pio :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_outputenable_n_to_the_ext_ssram :  STD_LOGIC;
                signal internal_phy_tx_d :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_phy_tx_en :  STD_LOGIC;
                signal internal_phy_tx_err :  STD_LOGIC;
                signal internal_pll_c1_out :  STD_LOGIC;
                signal internal_read_n_to_the_ext_flash :  STD_LOGIC;
                signal internal_select_n_to_the_ext_flash :  STD_LOGIC;
                signal internal_txd_from_the_uart1 :  STD_LOGIC;
                signal internal_write_n_to_the_ext_flash :  STD_LOGIC;
                signal m_rx_col :  STD_LOGIC;
                signal m_rx_col_to_the_tse_mac :  STD_LOGIC;
                signal m_rx_crs :  STD_LOGIC;
                signal m_rx_crs_to_the_tse_mac :  STD_LOGIC;
                signal m_rx_d :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal m_rx_d_to_the_tse_mac :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal m_rx_dv :  STD_LOGIC;
                signal m_rx_en_to_the_tse_mac :  STD_LOGIC;
                signal m_rx_err :  STD_LOGIC;
                signal m_rx_err_to_the_tse_mac :  STD_LOGIC;
                signal m_tx_d :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal m_tx_d_from_the_tse_mac :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal m_tx_en :  STD_LOGIC;
                signal m_tx_en_from_the_tse_mac :  STD_LOGIC;
                signal m_tx_err :  STD_LOGIC;
                signal m_tx_err_from_the_tse_mac :  STD_LOGIC;
                signal mdc_from_the_tse_mac :  STD_LOGIC;
                signal mdio_in :  STD_LOGIC;
                signal mdio_in_to_the_tse_mac :  STD_LOGIC;
                signal mdio_oen :  STD_LOGIC;
                signal mdio_oen_from_the_tse_mac :  STD_LOGIC;
                signal mdio_out :  STD_LOGIC;
                signal mdio_out_from_the_tse_mac :  STD_LOGIC;
                signal out_port_from_the_led_pio :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal pll_c0_out :  STD_LOGIC;
                signal pll_c2_out :  STD_LOGIC;
                signal ref125 :  STD_LOGIC;
                signal reset :  STD_LOGIC;
                signal reset_rx_clk :  STD_LOGIC;
                signal reset_tx_clk :  STD_LOGIC;
                signal rx_clk :  STD_LOGIC;
                signal rx_clk_to_the_tse_mac :  STD_LOGIC;
                signal set_1000_to_the_tse_mac :  STD_LOGIC;
                signal set_10_to_the_tse_mac :  STD_LOGIC;
                signal single_bit_clk_to_sdram :  STD_LOGIC;
                signal single_bit_clk_to_sdram_n :  STD_LOGIC;
                signal single_bit_ddr_cas_n :  STD_LOGIC;
                signal single_bit_ddr_cke :  STD_LOGIC;
                signal single_bit_ddr_cs_n :  STD_LOGIC;
                signal single_bit_ddr_ras_n :  STD_LOGIC;
                signal single_bit_ddr_we_n :  STD_LOGIC;
                signal stratix_dll_control :  STD_LOGIC;
                signal tse_pll_c0_out :  STD_LOGIC;
                signal tx_clk :  STD_LOGIC;
                signal tx_clk_mac :  STD_LOGIC;
                signal tx_clk_ref125 :  STD_LOGIC;
                signal tx_clk_to_the_tse_mac :  STD_LOGIC;
                signal write_clk_to_the_ddr_sdram_0 :  STD_LOGIC;

begin

  NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc_instance : NiosII_stratixII_2s60_RoHS_TSE_SGDMA_sopc
    port map(
            LCD_E_from_the_lcd_display => internal_LCD_E_from_the_lcd_display,
            LCD_RS_from_the_lcd_display => internal_LCD_RS_from_the_lcd_display,
            LCD_RW_from_the_lcd_display => internal_LCD_RW_from_the_lcd_display,
            LCD_data_to_and_from_the_lcd_display => LCD_data_to_and_from_the_lcd_display,
            adsc_n_to_the_ext_ssram => internal_adsc_n_to_the_ext_ssram,
            bidir_port_to_and_from_the_reconfig_request_pio => bidir_port_to_and_from_the_reconfig_request_pio,
            bw_n_to_the_ext_ssram => internal_bw_n_to_the_ext_ssram,
            bwe_n_to_the_ext_ssram => internal_bwe_n_to_the_ext_ssram,
            chipenable1_n_to_the_ext_ssram => internal_chipenable1_n_to_the_ext_ssram,
            clk => clk,
            clk_to_sdram_from_the_ddr_sdram_0 => single_bit_clk_to_sdram,
            clk_to_sdram_n_from_the_ddr_sdram_0 => single_bit_clk_to_sdram_n,
            clk_to_tse_pll => clk_to_tse_pll,
            ddr_a_from_the_ddr_sdram_0 => internal_ddr_a,
            ddr_ba_from_the_ddr_sdram_0 => internal_ddr_ba,
            ddr_cas_n_from_the_ddr_sdram_0 => single_bit_ddr_cas_n,
            ddr_cke_from_the_ddr_sdram_0 => single_bit_ddr_cke,
            ddr_cs_n_from_the_ddr_sdram_0 => single_bit_ddr_cs_n,
            ddr_dm_from_the_ddr_sdram_0 => internal_ddr_dm,
            ddr_dq_to_and_from_the_ddr_sdram_0 => ddr_dq,
            ddr_dqs_to_and_from_the_ddr_sdram_0 => ddr_dqs,
            ddr_ras_n_from_the_ddr_sdram_0 => single_bit_ddr_ras_n,
            ddr_we_n_from_the_ddr_sdram_0 => single_bit_ddr_we_n,
            dqs_delay_ctrl_to_the_ddr_sdram_0 => delayctrlout,
            dqsupdate_to_the_ddr_sdram_0 => dqsupdate,
            ena_10_from_the_tse_mac => ena_10_from_the_tse_mac,
            eth_mode_from_the_tse_mac => eth_mode_from_the_tse_mac,
            ext_flash_enet_bus_address => internal_ext_flash_enet_bus_address,
            ext_flash_enet_bus_data => ext_flash_enet_bus_data,
            ext_ssram_bus_address => internal_ext_ssram_bus_address,
            ext_ssram_bus_data => ext_ssram_bus_data,
            gm_rx_d_to_the_tse_mac => gm_rx_d_to_the_tse_mac,
            gm_rx_dv_to_the_tse_mac => gm_rx_dv_to_the_tse_mac,
            gm_rx_err_to_the_tse_mac => gm_rx_err_to_the_tse_mac,
            gm_tx_d_from_the_tse_mac => gm_tx_d_from_the_tse_mac,
            gm_tx_en_from_the_tse_mac => gm_tx_en_from_the_tse_mac,
            gm_tx_err_from_the_tse_mac => gm_tx_err_from_the_tse_mac,
            in_port_to_the_button_pio => in_port_to_the_button_pio,
            jtag_debug_offchip_trace_clk_from_the_cpu => internal_jtag_debug_offchip_trace_clk_from_the_cpu,
            jtag_debug_offchip_trace_data_from_the_cpu => internal_jtag_debug_offchip_trace_data_from_the_cpu,
            jtag_debug_trigout_from_the_cpu => internal_jtag_debug_trigout_from_the_cpu,
            m_rx_col_to_the_tse_mac => m_rx_col_to_the_tse_mac,
            m_rx_crs_to_the_tse_mac => m_rx_crs_to_the_tse_mac,
            m_rx_d_to_the_tse_mac => m_rx_d_to_the_tse_mac,
            m_rx_en_to_the_tse_mac => m_rx_en_to_the_tse_mac,
            m_rx_err_to_the_tse_mac => m_rx_err_to_the_tse_mac,
            m_tx_d_from_the_tse_mac => m_tx_d_from_the_tse_mac,
            m_tx_en_from_the_tse_mac => m_tx_en_from_the_tse_mac,
            m_tx_err_from_the_tse_mac => m_tx_err_from_the_tse_mac,
            mdc_from_the_tse_mac => mdc_from_the_tse_mac,
            mdio_in_to_the_tse_mac => mdio_in_to_the_tse_mac,
            mdio_oen_from_the_tse_mac => mdio_oen_from_the_tse_mac,
            mdio_out_from_the_tse_mac => mdio_out_from_the_tse_mac,
            out_port_from_the_led_pio => out_port_from_the_led_pio,
            out_port_from_the_seven_seg_pio => internal_out_port_from_the_seven_seg_pio,
            outputenable_n_to_the_ext_ssram => internal_outputenable_n_to_the_ext_ssram,
            pll_c0_out => pll_c0_out,
            pll_c1_out => internal_pll_c1_out,
            pll_c2_out => pll_c2_out,
            read_n_to_the_ext_flash => internal_read_n_to_the_ext_flash,
            reset_n => reset_n,
            rx_clk_to_the_tse_mac => rx_clk_to_the_tse_mac,
            rxd_to_the_uart1 => rxd_to_the_uart1,
            select_n_to_the_ext_flash => internal_select_n_to_the_ext_flash,
            set_1000_to_the_tse_mac => set_1000_to_the_tse_mac,
            set_10_to_the_tse_mac => set_10_to_the_tse_mac,
            stratix_dll_control_from_the_ddr_sdram_0 => stratix_dll_control,
            tse_pll_c0_out => tse_pll_c0_out,
            tx_clk_to_the_tse_mac => tx_clk_to_the_tse_mac,
            txd_from_the_uart1 => internal_txd_from_the_uart1,
            write_clk_to_the_ddr_sdram_0 => write_clk_to_the_ddr_sdram_0,
            write_n_to_the_ext_flash => internal_write_n_to_the_ext_flash
    );

  clk_to_sdram <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_clk_to_sdram));
  clk_to_sdram_n <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_clk_to_sdram_n));
  ddr_cs_n <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_ddr_cs_n));
  ddr_cke <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_ddr_cke));
  ddr_ras_n <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_ddr_ras_n));
  ddr_cas_n <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_ddr_cas_n));
  ddr_we_n <= std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(single_bit_ddr_we_n));
  write_clk_to_the_ddr_sdram_0 <= pll_c2_out;
  ddr_sdram_0_auk_ddr_dll_instance : ddr_sdram_0_auk_ddr_dll
    port map(
            clk => write_clk_to_the_ddr_sdram_0,
            delayctrlout => delayctrlout,
            dqsupdate => dqsupdate,
            reset_n => reset_n,
            stratix_dll_control => stratix_dll_control
    );

  gmii_mii_mux_instance : gmii_mii_mux
    port map(
            eth_mode => eth_mode,
            gm_rx_d => gm_rx_d,
            gm_rx_dv => gm_rx_dv,
            gm_rx_err => gm_rx_err,
            gm_tx_d => gm_tx_d,
            gm_tx_en => gm_tx_en,
            gm_tx_err => gm_tx_err,
            gtx_clk => gtx_clk,
            m_rx_col => m_rx_col,
            m_rx_crs => m_rx_crs,
            m_rx_d => m_rx_d,
            m_rx_dv => m_rx_dv,
            m_rx_err => m_rx_err,
            m_tx_d => m_tx_d,
            m_tx_en => m_tx_en,
            m_tx_err => m_tx_err,
            mdio => mdio,
            mdio_in => mdio_in,
            mdio_oen => mdio_oen,
            mdio_out => mdio_out,
            phy_rx_col => phy_rx_col,
            phy_rx_crs => phy_rx_crs,
            phy_rx_d => phy_rx_d,
            phy_rx_dv => phy_rx_dv,
            phy_rx_err => phy_rx_err,
            phy_tx_d => internal_phy_tx_d,
            phy_tx_en => internal_phy_tx_en,
            phy_tx_err => internal_phy_tx_err,
            reset_rx_clk => reset_rx_clk,
            reset_tx_clk => reset_tx_clk,
            rx_clk => rx_clk,
            tx_clk => tx_clk,
            tx_clk_mac => tx_clk_mac,
            tx_clk_ref125 => tx_clk_ref125
    );

  ref125 <= tse_pll_c0_out;
  gm_rx_d_to_the_tse_mac <= gm_rx_d;
  gm_rx_dv_to_the_tse_mac <= gm_rx_dv;
  gm_rx_err_to_the_tse_mac <= gm_rx_err;
  m_rx_col_to_the_tse_mac <= m_rx_col;
  m_rx_crs_to_the_tse_mac <= m_rx_crs;
  m_rx_d_to_the_tse_mac <= m_rx_d;
  m_rx_en_to_the_tse_mac <= m_rx_dv;
  m_rx_err_to_the_tse_mac <= m_rx_err;
  mdio_in_to_the_tse_mac <= mdio_in;
  rx_clk_to_the_tse_mac <= rx_clk;
  set_1000_to_the_tse_mac <= std_logic'('0');
  set_10_to_the_tse_mac <= std_logic'('0');
  tx_clk_to_the_tse_mac <= tx_clk_mac;
  eth_mode <= eth_mode_from_the_tse_mac;
  gm_tx_d <= gm_tx_d_from_the_tse_mac;
  gm_tx_en <= gm_tx_en_from_the_tse_mac;
  gm_tx_err <= gm_tx_err_from_the_tse_mac;
  m_tx_d <= m_tx_d_from_the_tse_mac;
  m_tx_en <= m_tx_en_from_the_tse_mac;
  m_tx_err <= m_tx_err_from_the_tse_mac;
  mdc <= mdc_from_the_tse_mac;
  mdio_oen <= mdio_oen_from_the_tse_mac;
  mdio_out <= mdio_out_from_the_tse_mac;
  reset <= NOT reset_n;
  rx_clk <= phy_rx_clk;
  tx_clk_ref125 <= ref125;
  reset_rx_clk <= reset;
  reset_tx_clk <= reset;
  tx_clk <= phy_tx_clk;
  PLD_CLKOUT <= gtx_clk;
  out_port_from_the_led_pio_n <= NOT out_port_from_the_led_pio;
  --vhdl renameroo for output signals
  LCD_E_from_the_lcd_display <= internal_LCD_E_from_the_lcd_display;
  --vhdl renameroo for output signals
  LCD_RS_from_the_lcd_display <= internal_LCD_RS_from_the_lcd_display;
  --vhdl renameroo for output signals
  LCD_RW_from_the_lcd_display <= internal_LCD_RW_from_the_lcd_display;
  --vhdl renameroo for output signals
  adsc_n_to_the_ext_ssram <= internal_adsc_n_to_the_ext_ssram;
  --vhdl renameroo for output signals
  bw_n_to_the_ext_ssram <= internal_bw_n_to_the_ext_ssram;
  --vhdl renameroo for output signals
  bwe_n_to_the_ext_ssram <= internal_bwe_n_to_the_ext_ssram;
  --vhdl renameroo for output signals
  chipenable1_n_to_the_ext_ssram <= internal_chipenable1_n_to_the_ext_ssram;
  --vhdl renameroo for output signals
  ddr_a <= internal_ddr_a;
  --vhdl renameroo for output signals
  ddr_ba <= internal_ddr_ba;
  --vhdl renameroo for output signals
  ddr_dm <= internal_ddr_dm;
  --vhdl renameroo for output signals
  ext_flash_enet_bus_address <= internal_ext_flash_enet_bus_address;
  --vhdl renameroo for output signals
  ext_ssram_bus_address <= internal_ext_ssram_bus_address;
  --vhdl renameroo for output signals
  jtag_debug_offchip_trace_clk_from_the_cpu <= internal_jtag_debug_offchip_trace_clk_from_the_cpu;
  --vhdl renameroo for output signals
  jtag_debug_offchip_trace_data_from_the_cpu <= internal_jtag_debug_offchip_trace_data_from_the_cpu;
  --vhdl renameroo for output signals
  jtag_debug_trigout_from_the_cpu <= internal_jtag_debug_trigout_from_the_cpu;
  --vhdl renameroo for output signals
  out_port_from_the_seven_seg_pio <= internal_out_port_from_the_seven_seg_pio;
  --vhdl renameroo for output signals
  outputenable_n_to_the_ext_ssram <= internal_outputenable_n_to_the_ext_ssram;
  --vhdl renameroo for output signals
  phy_tx_d <= internal_phy_tx_d;
  --vhdl renameroo for output signals
  phy_tx_en <= internal_phy_tx_en;
  --vhdl renameroo for output signals
  phy_tx_err <= internal_phy_tx_err;
  --vhdl renameroo for output signals
  pll_c1_out <= internal_pll_c1_out;
  --vhdl renameroo for output signals
  read_n_to_the_ext_flash <= internal_read_n_to_the_ext_flash;
  --vhdl renameroo for output signals
  select_n_to_the_ext_flash <= internal_select_n_to_the_ext_flash;
  --vhdl renameroo for output signals
  txd_from_the_uart1 <= internal_txd_from_the_uart1;
  --vhdl renameroo for output signals
  write_n_to_the_ext_flash <= internal_write_n_to_the_ext_flash;

end europa;

