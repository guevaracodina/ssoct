-- *************************************************************************
-- File : gmii_mii_mux
-- *************************************************************************
-- This program is controlled by a written license agreement.
-- Unauthorized Reproduction or Use is Expressly Prohibited. 
-- Copyright (c) 2002 MoreThanIP.com, Germany
-- Designed by : Daniel Koehler
-- dkoehler@morethanip.com
-- *************************************************************************
--  Ethernet Switch
-- *************************************************************************
-- Description: Mux the MII/GMII in combined 10/100/1000 PHY Interface and
--              implement the MII/GMII clock switch.
--
-- Version    : $Id: gmii_mii_mux.vhd,v 1.1 2006/12/17 09:56:43 ttchong Exp $
-- *************************************************************************

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;

entity gmii_mii_mux is port (

                 -- PHY Interface
                 
                 reset_rx_clk   : in std_logic;
                 rx_clk         : in std_logic;
                 phy_rx_col     : in std_logic;
                 phy_rx_crs     : in std_logic;
                 phy_rx_d       : in std_logic_vector(7 downto 0);
                 phy_rx_dv      : in std_logic;
                 phy_rx_err     : in std_logic;
                 
                 reset_tx_clk   : in std_logic;
                 tx_clk_ref125  : in std_logic;         -- 125 MHz TX local reference clock
                 tx_clk_mac     : out std_logic;        -- on-chip TX clock to use by the MAC
                 tx_clk         : in std_logic;         -- 2.5/25 MHz TX clock from PHY
                 gtx_clk        : out std_logic;        -- GMII tx clock (wired from PLD_CLOCKOUT with clock buffers)
                 phy_tx_d       : out std_logic_vector(7 downto 0);
                 phy_tx_en      : out std_logic;
                 phy_tx_err     : out std_logic;
                 
                 mdio_in        : out std_logic;        -- to MAC
                 mdio_out       : in  std_logic;
                 mdio_oen       : in  std_logic;       
                 mdio           : inout std_logic;      -- wire MDC directly from MAC, therefore not visible here.
                 
                 -- Local MII Interface
                 
                 m_rx_col       : out std_logic;
                 m_rx_crs       : out std_logic;
                 m_rx_d         : out std_logic_vector(3 downto 0);
                 m_rx_dv        : out std_logic;
                 m_rx_err       : out std_logic;

                 m_tx_d        : in std_logic_vector(3 downto 0);
                 m_tx_en       : in std_logic;
                 m_tx_err      : in std_logic;

                 -- Local GMII Interface

                 gm_rx_d        : out std_logic_vector(7 downto 0);
                 gm_rx_dv       : out std_logic;
                 gm_rx_err      : out std_logic;

                 gm_tx_d        : in std_logic_vector(7 downto 0);
                 gm_tx_en       : in std_logic;
                 gm_tx_err      : in std_logic;

                 eth_mode       : in std_logic);         -- from MAC configuration: 1: Gigabit, 0: 10/100
                 
end entity gmii_mii_mux;

architecture struct of gmii_mii_mux is

        component ddr_o port (
		datain_h	: in std_logic ;
		datain_l	: in std_logic ;
		outclock	: in std_logic ;
		dataout		: out std_logic );
        end component;

        -- control 
        
        signal  mode_reg1       : std_logic;
        signal  mode_reg2       : std_logic;
        
         -- RX input registers
         
         signal gm_rx_d_r  : std_logic_vector(7 downto 0);
         signal gm_rx_dv_r : std_logic;           
         signal gm_rx_err_r: std_logic; 
         
         signal tx_clk_int : std_logic; -- TX clock Mux

         attribute keep: boolean;
         attribute keep of tx_clk_int: signal is true;
         
         signal gnd     : std_logic;
         signal vcc     : std_logic;
begin

        -- MDIO Tristate
        -- -------------
        
        mdio_in   <= mdio;
              
        mdio <= mdio_out when mdio_oen='0' else 'Z';
        

        -- RX input regs to be moved into I/O
        -- ----------------------------------
        
        process(reset_rx_clk,rx_clk)
        begin
                if(reset_rx_clk='1') then
          
                        gm_rx_d_r   <= (others => '0');
                        gm_rx_dv_r  <= '0';
                        gm_rx_err_r <= '0';
                  
                elsif(rx_clk'event and rx_clk='1') then
                  
                        gm_rx_d_r  <= phy_rx_d;
                        gm_rx_dv_r <= phy_rx_dv;
                        gm_rx_err_r<= phy_rx_err;

                end if;
        
        end process;
        
        m_rx_col  <= phy_rx_col;
        m_rx_crs  <= phy_rx_crs;
                  
        m_rx_d    <= gm_rx_d_r(3 downto 0);
        m_rx_dv   <= gm_rx_dv_r;
        m_rx_err  <= gm_rx_err_r;

        gm_rx_d   <= gm_rx_d_r;
        gm_rx_dv  <= gm_rx_dv_r;
        gm_rx_err <= gm_rx_err_r;

        -- TX Clock Mux
        -- ------------
              
        process(reset_tx_clk, tx_clk_ref125)
        begin
                if(reset_tx_clk='1') then
                        
                        mode_reg1 <= '0';
                        mode_reg2 <= '0';
                        
                elsif(tx_clk_ref125'event and tx_clk_ref125='1') then

                        -- clock domain crossing

                        mode_reg1 <= eth_mode;
                        mode_reg2 <= mode_reg1;
                        
                end if;
        
        end process;
 
        tx_clk_int <= tx_clk when mode_reg2='0' else tx_clk_ref125;

        tx_clk_mac <= tx_clk_int;
        
        -- Data Output Mux
        -- ---------------
        process(reset_tx_clk, tx_clk_int)
        begin
          if(reset_tx_clk='1') then
                  
                  phy_tx_d   <= (others => '0');
                  phy_tx_en  <= '0';
                  phy_tx_err <= '0';
                  
          elsif(tx_clk_int'event and tx_clk_int='1') then
                  
                  if( mode_reg2='1' ) then
                          
                          phy_tx_d  <= gm_tx_d;
                          phy_tx_en <= gm_tx_en;
                          phy_tx_err<= gm_tx_err;
                          
                  else
                          phy_tx_d  <= "0000" & m_tx_d;
                          phy_tx_en <= m_tx_en;
                          phy_tx_err<= m_tx_err;
                          
                  end if;
                  
          end if;
        end process;

        -- GMII clock driver
        gnd <= '0';
        vcc <= '1';
        
        phy_ckgen:ddr_o port map (
		datain_h        => vcc,
		datain_l	=> gnd,
		outclock	=> tx_clk_int,
		dataout		=> gtx_clk );


        
end struct;
