--Legal Notice: (C)2009 Altera Corporation. All rights reserved.  Your
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

library altera_mf;
use altera_mf.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.all;

entity cpu_mult_cell is 
        port (
              -- inputs:
                 signal A_en : IN STD_LOGIC;
                 signal E_ctrl_mul_shift_src1_signed : IN STD_LOGIC;
                 signal E_ctrl_mul_shift_src2_signed : IN STD_LOGIC;
                 signal E_src1_mul_cell : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_src2_mul_cell : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal M_en : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal A_mul_cell_result : OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
              );
end entity cpu_mult_cell;


architecture europa of cpu_mult_cell is
  component altmult_add is
GENERIC (
      addnsub_multiplier_aclr1 : STRING;
        addnsub_multiplier_pipeline_aclr1 : STRING;
        addnsub_multiplier_register1 : STRING;
        dedicated_multiplier_circuitry : STRING;
        input_aclr_a0 : STRING;
        input_aclr_b0 : STRING;
        input_register_a0 : STRING;
        input_register_b0 : STRING;
        input_source_a0 : STRING;
        input_source_b0 : STRING;
        intended_device_family : STRING;
        lpm_type : STRING;
        multiplier1_direction : STRING;
        multiplier_register0 : STRING;
        number_of_multipliers : NATURAL;
        output_aclr : STRING;
        output_register : STRING;
        signed_aclr_a : STRING;
        signed_aclr_b : STRING;
        signed_pipeline_register_a : STRING;
        signed_pipeline_register_b : STRING;
        signed_register_a : STRING;
        signed_register_b : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        width_result : NATURAL
      );
    PORT (
    signal result : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
        signal signa : IN STD_LOGIC;
        signal ena0 : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal dataa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal datab : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal ena1 : IN STD_LOGIC;
        signal aclr0 : IN STD_LOGIC;
        signal clock1 : IN STD_LOGIC;
        signal aclr1 : IN STD_LOGIC;
        signal signb : IN STD_LOGIC
      );
  end component altmult_add;
                signal internal_A_mul_cell_result :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal mul_clr :  STD_LOGIC;

begin

  mul_clr <= NOT reset_n;
  the_altmult_add : altmult_add
    generic map(
      addnsub_multiplier_aclr1 => "UNUSED",
      addnsub_multiplier_pipeline_aclr1 => "UNUSED",
      addnsub_multiplier_register1 => "CLOCK0",
      dedicated_multiplier_circuitry => "YES",
      input_aclr_a0 => "ACLR0",
      input_aclr_b0 => "ACLR0",
      input_register_a0 => "CLOCK0",
      input_register_b0 => "CLOCK0",
      input_source_a0 => "DATAA",
      input_source_b0 => "DATAB",
      intended_device_family => "STRATIXII",
      lpm_type => "altmult_add",
      multiplier1_direction => "ADD",
      multiplier_register0 => "UNREGISTERED",
      number_of_multipliers => 1,
      output_aclr => "ACLR1",
      output_register => "CLOCK1",
      signed_aclr_a => "ACLR0",
      signed_aclr_b => "ACLR0",
      signed_pipeline_register_a => "UNREGISTERED",
      signed_pipeline_register_b => "UNREGISTERED",
      signed_register_a => "CLOCK0",
      signed_register_b => "CLOCK0",
      width_a => 32,
      width_b => 32,
      width_result => 64
    )
    port map(
            aclr0 => mul_clr,
            aclr1 => mul_clr,
            clock0 => clk,
            clock1 => clk,
            dataa => E_src1_mul_cell,
            datab => E_src2_mul_cell,
            ena0 => M_en,
            ena1 => A_en,
            result => internal_A_mul_cell_result,
            signa => E_ctrl_mul_shift_src1_signed,
            signb => E_ctrl_mul_shift_src2_signed
    );

  --vhdl renameroo for output signals
  A_mul_cell_result <= internal_A_mul_cell_result;

end europa;

