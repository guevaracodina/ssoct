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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_interrupt_vector_compute_result is 
        port (
              -- inputs:
                 signal estatus : IN STD_LOGIC;
                 signal ipending : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_interrupt_vector_compute_result;


architecture europa of cpu_interrupt_vector_compute_result is
                signal result_no_interrupts :  STD_LOGIC;
                signal result_offset :  STD_LOGIC_VECTOR (30 DOWNTO 0);

begin

  result_no_interrupts <= to_std_logic((((ipending = std_logic_vector'("00000000000000000000000000000000"))) OR (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(estatus))) = std_logic_vector'("00000000000000000000000000000000")))));
  result_offset <= A_EXT (A_WE_StdLogicVector((std_logic'(ipending(0)) = '1'), std_logic_vector'("00000000000000000000000000000000"), A_WE_StdLogicVector((std_logic'(ipending(1)) = '1'), std_logic_vector'("00000000000000000000000000001000"), A_WE_StdLogicVector((std_logic'(ipending(2)) = '1'), std_logic_vector'("00000000000000000000000000010000"), A_WE_StdLogicVector((std_logic'(ipending(3)) = '1'), std_logic_vector'("00000000000000000000000000011000"), A_WE_StdLogicVector((std_logic'(ipending(5)) = '1'), std_logic_vector'("00000000000000000000000000101000"), A_WE_StdLogicVector((std_logic'(ipending(6)) = '1'), std_logic_vector'("00000000000000000000000000110000"), std_logic_vector'("00000000000000000000000001000000"))))))), 31);
  result <= Std_Logic_Vector'(A_ToStdLogicVector(result_no_interrupts) & result_offset);

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity interrupt_vector is 
        port (
              -- inputs:
                 signal estatus : IN STD_LOGIC;
                 signal ipending : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity interrupt_vector;


architecture europa of interrupt_vector is
component cpu_interrupt_vector_compute_result is 
           port (
                 -- inputs:
                    signal estatus : IN STD_LOGIC;
                    signal ipending : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_interrupt_vector_compute_result;

                signal internal_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --interrupt_vector, which is an e_custom_instruction_slave
  --the_cpu_interrupt_vector_compute_result, which is an e_instance
  the_cpu_interrupt_vector_compute_result : cpu_interrupt_vector_compute_result
    port map(
      result => internal_result,
      estatus => estatus,
      ipending => ipending
    );


  --vhdl renameroo for output signals
  result <= internal_result;

end europa;

