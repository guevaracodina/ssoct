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

entity performance_counter is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity performance_counter;


architecture europa of performance_counter is
                signal clk_en :  STD_LOGIC;
                signal event_counter_0 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal event_counter_1 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal event_counter_2 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal event_counter_3 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal global_enable :  STD_LOGIC;
                signal global_reset :  STD_LOGIC;
                signal go_strobe_0 :  STD_LOGIC;
                signal go_strobe_1 :  STD_LOGIC;
                signal go_strobe_2 :  STD_LOGIC;
                signal go_strobe_3 :  STD_LOGIC;
                signal read_mux_out :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal stop_strobe_0 :  STD_LOGIC;
                signal stop_strobe_1 :  STD_LOGIC;
                signal stop_strobe_2 :  STD_LOGIC;
                signal stop_strobe_3 :  STD_LOGIC;
                signal time_counter_0 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal time_counter_1 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal time_counter_2 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal time_counter_3 :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal time_counter_enable_0 :  STD_LOGIC;
                signal time_counter_enable_1 :  STD_LOGIC;
                signal time_counter_enable_2 :  STD_LOGIC;
                signal time_counter_enable_3 :  STD_LOGIC;
                signal write_strobe :  STD_LOGIC;

begin

  --control_slave, which is an e_avalon_slave
  clk_en <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
  write_strobe <= write AND begintransfer;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_0 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((time_counter_enable_0 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          time_counter_0 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          time_counter_0 <= A_EXT (((std_logic_vector'("0") & (time_counter_0)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      event_counter_0 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((go_strobe_0 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          event_counter_0 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          event_counter_0 <= A_EXT (((std_logic_vector'("0") & (event_counter_0)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  stop_strobe_0 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000000")))) AND write_strobe;
  go_strobe_0 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000001")))) AND write_strobe;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_enable_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((stop_strobe_0 OR global_reset)) = '1' then 
          time_counter_enable_0 <= std_logic'('0');
        elsif std_logic'(go_strobe_0) = '1' then 
          time_counter_enable_0 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  global_enable <= time_counter_enable_0 OR go_strobe_0;
  global_reset <= stop_strobe_0 AND writedata(0);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_1 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((time_counter_enable_1 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          time_counter_1 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          time_counter_1 <= A_EXT (((std_logic_vector'("0") & (time_counter_1)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      event_counter_1 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((go_strobe_1 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          event_counter_1 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          event_counter_1 <= A_EXT (((std_logic_vector'("0") & (event_counter_1)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  stop_strobe_1 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000100")))) AND write_strobe;
  go_strobe_1 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000101")))) AND write_strobe;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_enable_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((stop_strobe_1 OR global_reset)) = '1' then 
          time_counter_enable_1 <= std_logic'('0');
        elsif std_logic'(go_strobe_1) = '1' then 
          time_counter_enable_1 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_2 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((time_counter_enable_2 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          time_counter_2 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          time_counter_2 <= A_EXT (((std_logic_vector'("0") & (time_counter_2)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      event_counter_2 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((go_strobe_2 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          event_counter_2 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          event_counter_2 <= A_EXT (((std_logic_vector'("0") & (event_counter_2)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  stop_strobe_2 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001000")))) AND write_strobe;
  go_strobe_2 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001001")))) AND write_strobe;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_enable_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((stop_strobe_2 OR global_reset)) = '1' then 
          time_counter_enable_2 <= std_logic'('0');
        elsif std_logic'(go_strobe_2) = '1' then 
          time_counter_enable_2 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_3 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((time_counter_enable_3 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          time_counter_3 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          time_counter_3 <= A_EXT (((std_logic_vector'("0") & (time_counter_3)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      event_counter_3 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((((go_strobe_3 AND global_enable)) OR global_reset)) = '1' then 
        if std_logic'(global_reset) = '1' then 
          event_counter_3 <= std_logic_vector'("0000000000000000000000000000000000000000000000000000000000000000");
        else
          event_counter_3 <= A_EXT (((std_logic_vector'("0") & (event_counter_3)) + std_logic_vector'("00000000000000000000000000000000000000000000000000000000000000001")), 64);
        end if;
      end if;
    end if;

  end process;

  stop_strobe_3 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001100")))) AND write_strobe;
  go_strobe_3 <= to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001101")))) AND write_strobe;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      time_counter_enable_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((stop_strobe_3 OR global_reset)) = '1' then 
          time_counter_enable_3 <= std_logic'('0');
        elsif std_logic'(go_strobe_3) = '1' then 
          time_counter_enable_3 <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  read_mux_out <= A_EXT ((((((((((((std_logic_vector'("00000000000000000000000000000000") & ((((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000000")))), 32) AND time_counter_0(31 DOWNTO 0))) OR ((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000001")))), 32) AND time_counter_0(63 DOWNTO 32)))))) OR (((std_logic_vector'("00000000000000000000000000000000") & (A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000010")))), 32))) AND event_counter_0))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000100")))), 32) AND time_counter_1(31 DOWNTO 0)))))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000101")))), 32) AND time_counter_1(63 DOWNTO 32)))))) OR (((std_logic_vector'("00000000000000000000000000000000") & (A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000110")))), 32))) AND event_counter_1))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001000")))), 32) AND time_counter_2(31 DOWNTO 0)))))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001001")))), 32) AND time_counter_2(63 DOWNTO 32)))))) OR (((std_logic_vector'("00000000000000000000000000000000") & (A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001010")))), 32))) AND event_counter_2))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001100")))), 32) AND time_counter_3(31 DOWNTO 0)))))) OR (std_logic_vector'("00000000000000000000000000000000") & (((A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001101")))), 32) AND time_counter_3(63 DOWNTO 32)))))) OR (((std_logic_vector'("00000000000000000000000000000000") & (A_REP(to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000001110")))), 32))) AND event_counter_3))), 32);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        readdata <= read_mux_out;
      end if;
    end if;

  end process;


end europa;

