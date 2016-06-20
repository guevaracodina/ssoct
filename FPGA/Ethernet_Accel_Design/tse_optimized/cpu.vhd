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

entity cpu_ic_data_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal rdclken : IN STD_LOGIC;
                 signal rdclock : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal wrclock : IN STD_LOGIC;
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_ic_data_module;


architecture europa of cpu_ic_data_module is
--synthesis translate_off
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clocken1 : IN STD_LOGIC;
        signal clock1 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal clock0 : IN STD_LOGIC;
        signal address_b : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal clocken0 : IN STD_LOGIC;
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
--synthesis translate_on
--synthesis read_comments_as_HDL on
--  component altsyncram is
--GENERIC (
--      address_reg_b : STRING;
--        maximum_depth : NATURAL;
--        numwords_a : NATURAL;
--        numwords_b : NATURAL;
--        operation_mode : STRING;
--        outdata_reg_b : STRING;
--        ram_block_type : STRING;
--        read_during_write_mode_mixed_ports : STRING;
--        width_a : NATURAL;
--        width_b : NATURAL;
--        widthad_a : NATURAL;
--        widthad_b : NATURAL
--      );
--    PORT (
--    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
--        signal wren_a : IN STD_LOGIC;
--        signal clocken1 : IN STD_LOGIC;
--        signal clock1 : IN STD_LOGIC;
--        signal address_a : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
--        signal clock0 : IN STD_LOGIC;
--        signal address_b : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
--        signal clocken0 : IN STD_LOGIC;
--        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
--      );
--  end component altsyncram;
--synthesis read_comments_as_HDL off
                signal ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal wrclken :  STD_LOGIC;

begin

  wrclken <= std_logic'('1');
  q <= ram_q;
--synthesis translate_off
    the_altsyncram : altsyncram
      generic map(
        address_reg_b => "CLOCK1",
        maximum_depth => 0,
        numwords_a => 8192,
        numwords_b => 8192,
        operation_mode => "DUAL_PORT",
        outdata_reg_b => "UNREGISTERED",
        ram_block_type => "AUTO",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        width_a => 32,
        width_b => 32,
        widthad_a => 13,
        widthad_b => 13
      )
      port map(
                address_a => wraddress,
                address_b => rdaddress,
                clock0 => wrclock,
                clock1 => rdclock,
                clocken0 => wrclken,
                clocken1 => rdclken,
                data_a => data,
                q_b => ram_q,
                wren_a => wren
      );

--synthesis translate_on
--synthesis read_comments_as_HDL on
--    the_altsyncram : altsyncram
--      generic map(
--        address_reg_b => "CLOCK1",
--        maximum_depth => 0,
--        numwords_a => 8192,
--        numwords_b => 8192,
--        operation_mode => "DUAL_PORT",
--        outdata_reg_b => "UNREGISTERED",
--        ram_block_type => "AUTO",
--        read_during_write_mode_mixed_ports => "DONT_CARE",
--        width_a => 32,
--        width_b => 32,
--        widthad_a => 13,
--        widthad_b => 13
--      )
--      port map(
--                address_a => wraddress,
--                address_b => rdaddress,
--                clock0 => wrclock,
--                clock1 => rdclock,
--                clocken0 => wrclken,
--                clocken1 => rdclken,
--                data_a => data,
--                q_b => ram_q,
--                wren_a => wren
--      );
--
--synthesis read_comments_as_HDL off

end europa;



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

entity cpu_ic_tag_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal rden : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (20 DOWNTO 0)
              );
end entity cpu_ic_tag_module;


architecture europa of cpu_ic_tag_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        init_file : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
        signal rden_b : IN STD_LOGIC
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (20 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      init_file => lpm_file,
      maximum_depth => 0,
      numwords_a => 1024,
      numwords_b => 1024,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 21,
      width_b => 21,
      widthad_a => 10,
      widthad_b => 10
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            rden_b => rden,
            wren_a => wren
    );


end europa;



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

entity cpu_bht_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal rden : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
              );
end entity cpu_bht_module;


architecture europa of cpu_bht_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        init_file : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        signal rden_b : IN STD_LOGIC
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      init_file => lpm_file,
      maximum_depth => 0,
      numwords_a => 256,
      numwords_b => 256,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 2,
      width_b => 2,
      widthad_a => 8,
      widthad_b => 8
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            rden_b => rden,
            wren_a => wren
    );


end europa;



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

entity cpu_register_bank_a_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_register_bank_a_module;


architecture europa of cpu_register_bank_a_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        init_file : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      init_file => lpm_file,
      maximum_depth => 0,
      numwords_a => 32,
      numwords_b => 32,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 32,
      width_b => 32,
      widthad_a => 5,
      widthad_b => 5
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            wren_a => wren
    );


end europa;



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

entity cpu_register_bank_b_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_register_bank_b_module;


architecture europa of cpu_register_bank_b_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        init_file : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      init_file => lpm_file,
      maximum_depth => 0,
      numwords_a => 32,
      numwords_b => 32,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 32,
      width_b => 32,
      widthad_a => 5,
      widthad_b => 5
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            wren_a => wren
    );


end europa;



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

entity cpu_dc_tag_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal wraddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (14 DOWNTO 0)
              );
end entity cpu_dc_tag_module;


architecture europa of cpu_dc_tag_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        init_file : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (14 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (14 DOWNTO 0)
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (14 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      init_file => lpm_file,
      maximum_depth => 0,
      numwords_a => 1024,
      numwords_b => 1024,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 15,
      width_b => 15,
      widthad_a => 10,
      widthad_b => 10
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            wren_a => wren
    );


end europa;



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

entity cpu_dc_data_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal wraddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_dc_data_module;


architecture europa of cpu_dc_data_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        width_byteena_a : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal byteena_a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      maximum_depth => 0,
      numwords_a => 8192,
      numwords_b => 8192,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "DONT_CARE",
      width_a => 32,
      width_b => 32,
      width_byteena_a => 4,
      widthad_a => 13,
      widthad_b => 13
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            byteena_a => byteenable,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            wren_a => wren
    );


end europa;



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

entity cpu_dc_victim_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal clock : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal rden : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_dc_victim_module;


architecture europa of cpu_dc_victim_module is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        rdcontrol_reg_b : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal rden_b : IN STD_LOGIC
      );
  end component altsyncram;
                signal ram_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  q <= ram_q;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      maximum_depth => 0,
      numwords_a => 8,
      numwords_b => 8,
      operation_mode => "DUAL_PORT",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      rdcontrol_reg_b => "CLOCK0",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 32,
      width_b => 32,
      widthad_a => 3,
      widthad_b => 3
    )
    port map(
            address_a => wraddress,
            address_b => rdaddress,
            clock0 => clock,
            data_a => data,
            q_b => ram_q,
            rden_b => rden,
            wren_a => wren
    );


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

entity cpu_nios2_oci_debug is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal dbrk_break : IN STD_LOGIC;
                 signal debugreq : IN STD_LOGIC;
                 signal hbreak_enabled : IN STD_LOGIC;
                 signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal ocireg_ers : IN STD_LOGIC;
                 signal ocireg_mrs : IN STD_LOGIC;
                 signal reset : IN STD_LOGIC;
                 signal st_ready_test_idle : IN STD_LOGIC;
                 signal take_action_ocimem_a : IN STD_LOGIC;
                 signal take_action_ocireg : IN STD_LOGIC;
                 signal xbrk_break : IN STD_LOGIC;

              -- outputs:
                 signal debugack : OUT STD_LOGIC;
                 signal monitor_error : OUT STD_LOGIC;
                 signal monitor_go : OUT STD_LOGIC;
                 signal monitor_ready : OUT STD_LOGIC;
                 signal oci_hbreak_req : OUT STD_LOGIC;
                 signal resetlatch : OUT STD_LOGIC;
                 signal resetrequest : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_debug;


architecture europa of cpu_nios2_oci_debug is
                signal internal_debugack :  STD_LOGIC;
                signal internal_resetlatch :  STD_LOGIC;
                signal jtag_break :  STD_LOGIC;
                signal probepresent :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of jtag_break : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of monitor_error : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of monitor_go : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of monitor_ready : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of probepresent : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of resetlatch : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of resetrequest : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";

begin

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      probepresent <= std_logic'('0');
      resetrequest <= std_logic'('0');
      jtag_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(take_action_ocimem_a) = '1' then 
        resetrequest <= jdo(22);
        jtag_break <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jdo(21)) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(jdo(20)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_break))))));
        probepresent <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jdo(19)) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(jdo(18)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(probepresent))))));
        internal_resetlatch <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jdo(24)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_resetlatch)))));
      elsif std_logic'(reset) = '1' then 
        jtag_break <= probepresent;
        internal_resetlatch <= std_logic'('1');
      elsif std_logic'(((NOT internal_debugack AND debugreq) AND probepresent)) = '1' then 
        jtag_break <= std_logic'('1');
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      monitor_ready <= std_logic'('0');
      monitor_error <= std_logic'('0');
      monitor_go <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((take_action_ocimem_a AND jdo(25))) = '1' then 
        monitor_ready <= std_logic'('0');
      elsif std_logic'((take_action_ocireg AND ocireg_mrs)) = '1' then 
        monitor_ready <= std_logic'('1');
      end if;
      if std_logic'((take_action_ocimem_a AND jdo(25))) = '1' then 
        monitor_error <= std_logic'('0');
      elsif std_logic'((take_action_ocireg AND ocireg_ers)) = '1' then 
        monitor_error <= std_logic'('1');
      end if;
      if std_logic'((take_action_ocimem_a AND jdo(23))) = '1' then 
        monitor_go <= std_logic'('1');
      elsif std_logic'(st_ready_test_idle) = '1' then 
        monitor_go <= std_logic'('0');
      end if;
    end if;

  end process;

  oci_hbreak_req <= ((jtag_break OR dbrk_break) OR xbrk_break) OR debugreq;
  internal_debugack <= NOT hbreak_enabled;
  --vhdl renameroo for output signals
  debugack <= internal_debugack;
  --vhdl renameroo for output signals
  resetlatch <= internal_resetlatch;

end europa;



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

entity cpu_ociram_lpm_dram_bdp_component_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal address_a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal address_b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal byteena_a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal clock0 : IN STD_LOGIC;
                 signal clock1 : IN STD_LOGIC;
                 signal clocken0 : IN STD_LOGIC;
                 signal clocken1 : IN STD_LOGIC;
                 signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal data_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal wren_a : IN STD_LOGIC;
                 signal wren_b : IN STD_LOGIC;

              -- outputs:
                 signal q_a : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_ociram_lpm_dram_bdp_component_module;


architecture europa of cpu_ociram_lpm_dram_bdp_component_module is
  component altsyncram is
GENERIC (
      address_aclr_a : STRING;
        address_aclr_b : STRING;
        address_reg_b : STRING;
        indata_aclr_a : STRING;
        indata_aclr_b : STRING;
        init_file : STRING;
        intended_device_family : STRING;
        lpm_type : STRING;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_aclr_a : STRING;
        outdata_aclr_b : STRING;
        outdata_reg_a : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        width_byteena_a : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL;
        wrcontrol_aclr_a : STRING;
        wrcontrol_aclr_b : STRING
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal q_a : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal data_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal clock0 : IN STD_LOGIC;
        signal clocken0 : IN STD_LOGIC;
        signal byteena_a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal clocken1 : IN STD_LOGIC;
        signal wren_b : IN STD_LOGIC;
        signal clock1 : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
                signal internal_q_a :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_q_b :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  the_altsyncram : altsyncram
    generic map(
      address_aclr_a => "NONE",
      address_aclr_b => "NONE",
      address_reg_b => "CLOCK1",
      indata_aclr_a => "NONE",
      indata_aclr_b => "NONE",
      init_file => lpm_file,
      intended_device_family => "STRATIXII",
      lpm_type => "altsyncram",
      numwords_a => 256,
      numwords_b => 256,
      operation_mode => "BIDIR_DUAL_PORT",
      outdata_aclr_a => "NONE",
      outdata_aclr_b => "NONE",
      outdata_reg_a => "UNREGISTERED",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 32,
      width_b => 32,
      width_byteena_a => 4,
      widthad_a => 8,
      widthad_b => 8,
      wrcontrol_aclr_a => "NONE",
      wrcontrol_aclr_b => "NONE"
    )
    port map(
            address_a => address_a,
            address_b => address_b,
            byteena_a => byteena_a,
            clock0 => clock0,
            clock1 => clock1,
            clocken0 => clocken0,
            clocken1 => clocken1,
            data_a => data_a,
            data_b => data_b,
            q_a => internal_q_a,
            q_b => internal_q_b,
            wren_a => wren_a,
            wren_b => wren_b
    );

  --vhdl renameroo for output signals
  q_a <= internal_q_a;
  --vhdl renameroo for output signals
  q_b <= internal_q_b;

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

entity cpu_nios2_ocimem is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal debugaccess : IN STD_LOGIC;
                 signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal resetrequest : IN STD_LOGIC;
                 signal take_action_ocimem_a : IN STD_LOGIC;
                 signal take_action_ocimem_b : IN STD_LOGIC;
                 signal take_no_action_ocimem_a : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal MonDReg : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal oci_ram_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_nios2_ocimem;


architecture europa of cpu_nios2_ocimem is
component cpu_ociram_lpm_dram_bdp_component_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal address_a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal address_b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal byteena_a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal clock0 : IN STD_LOGIC;
                    signal clock1 : IN STD_LOGIC;
                    signal clocken0 : IN STD_LOGIC;
                    signal clocken1 : IN STD_LOGIC;
                    signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal data_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal wren_a : IN STD_LOGIC;
                    signal wren_b : IN STD_LOGIC;

                 -- outputs:
                    signal q_a : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_ociram_lpm_dram_bdp_component_module;

                signal MonAReg :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal MonRd :  STD_LOGIC;
                signal MonRd1 :  STD_LOGIC;
                signal MonWr :  STD_LOGIC;
                signal avalon :  STD_LOGIC;
                signal cfgdout :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_MonDReg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_oci_ram_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal module_input2 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal module_input3 :  STD_LOGIC;
                signal module_input4 :  STD_LOGIC;
                signal module_input5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input6 :  STD_LOGIC;
                signal sramdout :  STD_LOGIC_VECTOR (31 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of MonDReg, MonAReg, MonRd1, MonRd, MonWr : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";
  --synthesis translate_off
constant cpu_ociram_lpm_dram_bdp_component_lpm_file : string := "cpu_ociram_default_contents.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_ociram_lpm_dram_bdp_component_lpm_file : string := "cpu_ociram_default_contents.mif";
--synthesis read_comments_as_HDL off


begin

  avalon <= begintransfer AND NOT resetrequest;
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      MonWr <= std_logic'('0');
      MonRd <= std_logic'('0');
      MonRd1 <= std_logic'('0');
      MonAReg <= std_logic_vector'("00000000000");
      internal_MonDReg <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(take_no_action_ocimem_a) = '1' then 
        MonAReg(10 DOWNTO 2) <= A_EXT (((std_logic_vector'("000000000000000000000000") & (MonAReg(10 DOWNTO 2))) + std_logic_vector'("000000000000000000000000000000001")), 9);
        MonRd <= std_logic'('1');
      elsif std_logic'(take_action_ocimem_a) = '1' then 
        MonAReg(10 DOWNTO 2) <= Std_Logic_Vector'(A_ToStdLogicVector(jdo(17)) & jdo(33 DOWNTO 26));
        MonRd <= std_logic'('1');
      elsif std_logic'(take_action_ocimem_b) = '1' then 
        MonAReg(10 DOWNTO 2) <= A_EXT (((std_logic_vector'("000000000000000000000000") & (MonAReg(10 DOWNTO 2))) + std_logic_vector'("000000000000000000000000000000001")), 9);
        internal_MonDReg <= jdo(34 DOWNTO 3);
        MonWr <= std_logic'('1');
      else
        if std_logic'(NOT avalon) = '1' then 
          MonWr <= std_logic'('0');
          MonRd <= std_logic'('0');
        end if;
        if std_logic'(MonRd1) = '1' then 
          internal_MonDReg <= A_WE_StdLogicVector((std_logic'(MonAReg(10)) = '1'), cfgdout, sramdout);
        end if;
      end if;
      MonRd1 <= MonRd;
    end if;

  end process;

  --cpu_ociram_lpm_dram_bdp_component, which is an nios_tdp_ram
  cpu_ociram_lpm_dram_bdp_component : cpu_ociram_lpm_dram_bdp_component_module
    generic map(
      lpm_file => cpu_ociram_lpm_dram_bdp_component_lpm_file
    )
    port map(
      q_a => internal_oci_ram_readdata,
      q_b => sramdout,
      address_a => module_input1,
      address_b => module_input2,
      byteena_a => byteenable,
      clock0 => clk,
      clock1 => clk,
      clocken0 => module_input3,
      clocken1 => module_input4,
      data_a => writedata,
      data_b => module_input5,
      wren_a => module_input6,
      wren_b => MonWr
    );

  module_input1 <= address(7 DOWNTO 0);
  module_input2 <= MonAReg(9 DOWNTO 2);
  module_input3 <= std_logic'('1');
  module_input4 <= std_logic'('1');
  module_input5 <= internal_MonDReg(31 DOWNTO 0);
  module_input6 <= ((chipselect AND write) AND debugaccess) AND NOT address(8);

  cfgdout <= A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("000"))), std_logic_vector'("00000010000000000000000000100000"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("001"))), std_logic_vector'("00000100000001000001110000011100"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("010"))), std_logic_vector'("00000001000001010000000100000001"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("011"))), std_logic_vector'("00000000000000000000000000000111"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("100"))), std_logic_vector'("00100000000000000000111100001111"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("101"))), std_logic_vector'("00000110000000000000000000000000"), A_WE_StdLogicVector(((MonAReg(4 DOWNTO 2) = std_logic_vector'("110"))), std_logic_vector'("00000000000000000000000000000000"), std_logic_vector'("00000000000000000000000000000000"))))))));
  --vhdl renameroo for output signals
  MonDReg <= internal_MonDReg;
  --vhdl renameroo for output signals
  oci_ram_readdata <= internal_oci_ram_readdata;

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

entity cpu_nios2_avalon_reg is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal debugaccess : IN STD_LOGIC;
                 signal monitor_error : IN STD_LOGIC;
                 signal monitor_go : IN STD_LOGIC;
                 signal monitor_ready : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal oci_ienable : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal oci_reg_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal oci_single_step_mode : OUT STD_LOGIC;
                 signal ocireg_ers : OUT STD_LOGIC;
                 signal ocireg_mrs : OUT STD_LOGIC;
                 signal take_action_ocireg : OUT STD_LOGIC
              );
end entity cpu_nios2_avalon_reg;


architecture europa of cpu_nios2_avalon_reg is
                signal internal_oci_ienable1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_oci_single_step_mode1 :  STD_LOGIC;
                signal internal_take_action_ocireg :  STD_LOGIC;
                signal oci_reg_00_addressed :  STD_LOGIC;
                signal oci_reg_01_addressed :  STD_LOGIC;
                signal ocireg_sstep :  STD_LOGIC;
                signal take_action_oci_intr_mask_reg :  STD_LOGIC;
                signal write_strobe :  STD_LOGIC;

begin

  oci_reg_00_addressed <= to_std_logic((address = std_logic_vector'("100000000")));
  oci_reg_01_addressed <= to_std_logic((address = std_logic_vector'("100000001")));
  write_strobe <= (chipselect AND write) AND debugaccess;
  internal_take_action_ocireg <= write_strobe AND oci_reg_00_addressed;
  take_action_oci_intr_mask_reg <= write_strobe AND oci_reg_01_addressed;
  ocireg_ers <= writedata(1);
  ocireg_mrs <= writedata(0);
  ocireg_sstep <= writedata(3);
  oci_reg_readdata <= A_WE_StdLogicVector((std_logic'(oci_reg_00_addressed) = '1'), Std_Logic_Vector'(std_logic_vector'("0000000000000000000000000000") & A_ToStdLogicVector(internal_oci_single_step_mode1) & A_ToStdLogicVector(monitor_go) & A_ToStdLogicVector(monitor_ready) & A_ToStdLogicVector(monitor_error)), A_WE_StdLogicVector((std_logic'(oci_reg_01_addressed) = '1'), internal_oci_ienable1, std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_oci_single_step_mode1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(internal_take_action_ocireg) = '1' then 
        internal_oci_single_step_mode1 <= ocireg_sstep;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_oci_ienable1 <= A_REP(std_logic'('1'), 32);
    elsif clk'event and clk = '1' then
      if std_logic'(take_action_oci_intr_mask_reg) = '1' then 
        internal_oci_ienable1 <= writedata OR NOT (std_logic_vector'("00000000000000000000000101101111"));
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  oci_ienable <= internal_oci_ienable1;
  --vhdl renameroo for output signals
  oci_single_step_mode <= internal_oci_single_step_mode1;
  --vhdl renameroo for output signals
  take_action_ocireg <= internal_take_action_ocireg;

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

entity cpu_nios2_oci_break is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal dbrk_break : IN STD_LOGIC;
                 signal dbrk_goto0 : IN STD_LOGIC;
                 signal dbrk_goto1 : IN STD_LOGIC;
                 signal dbrk_hit0 : IN STD_LOGIC;
                 signal dbrk_hit1 : IN STD_LOGIC;
                 signal dbrk_hit2 : IN STD_LOGIC;
                 signal dbrk_hit3 : IN STD_LOGIC;
                 signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal take_action_break_a : IN STD_LOGIC;
                 signal take_action_break_b : IN STD_LOGIC;
                 signal take_action_break_c : IN STD_LOGIC;
                 signal take_no_action_break_a : IN STD_LOGIC;
                 signal take_no_action_break_b : IN STD_LOGIC;
                 signal take_no_action_break_c : IN STD_LOGIC;
                 signal xbrk_goto0 : IN STD_LOGIC;
                 signal xbrk_goto1 : IN STD_LOGIC;

              -- outputs:
                 signal break_readreg : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal dbrk0 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk1 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk2 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk3 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk_hit0_latch : OUT STD_LOGIC;
                 signal dbrk_hit1_latch : OUT STD_LOGIC;
                 signal dbrk_hit2_latch : OUT STD_LOGIC;
                 signal dbrk_hit3_latch : OUT STD_LOGIC;
                 signal trigbrktype : OUT STD_LOGIC;
                 signal trigger_state_0 : OUT STD_LOGIC;
                 signal trigger_state_1 : OUT STD_LOGIC;
                 signal xbrk0 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk1 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk2 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk3 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk_ctrl0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity cpu_nios2_oci_break;


architecture europa of cpu_nios2_oci_break is
                signal break_a_wpr :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal break_a_wpr_high_bits :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal break_a_wpr_low_bits :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal break_b_rr :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal break_c_rr :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal dbrk0_high_value :  STD_LOGIC;
                signal dbrk0_low_value :  STD_LOGIC;
                signal dbrk1_high_value :  STD_LOGIC;
                signal dbrk1_low_value :  STD_LOGIC;
                signal dbrk2_high_value :  STD_LOGIC;
                signal dbrk2_low_value :  STD_LOGIC;
                signal dbrk3_high_value :  STD_LOGIC;
                signal dbrk3_low_value :  STD_LOGIC;
                signal internal_dbrk0 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal internal_dbrk1 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal internal_dbrk2 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal internal_dbrk3 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal internal_trigger_state_0 :  STD_LOGIC;
                signal internal_trigger_state_1 :  STD_LOGIC;
                signal internal_xbrk0 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_xbrk1 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_xbrk2 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_xbrk3 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal take_action_any_break :  STD_LOGIC;
                signal trigger_state :  STD_LOGIC;
                signal xbrk0_value :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal xbrk1_value :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal xbrk2_value :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal xbrk3_value :  STD_LOGIC_VECTOR (31 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of break_readreg : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of dbrk0 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of dbrk1 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of dbrk2 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of dbrk3 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of dbrk_hit0_latch : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of dbrk_hit1_latch : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of dbrk_hit2_latch : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of dbrk_hit3_latch : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of trigbrktype : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk0 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk1 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk2 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk3 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk_ctrl0 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk_ctrl1 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk_ctrl2 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of xbrk_ctrl3 : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";

begin

  break_a_wpr <= jdo(35 DOWNTO 32);
  break_a_wpr_high_bits <= break_a_wpr(3 DOWNTO 2);
  break_a_wpr_low_bits <= break_a_wpr(1 DOWNTO 0);
  break_b_rr <= jdo(33 DOWNTO 32);
  break_c_rr <= jdo(33 DOWNTO 32);
  take_action_any_break <= (take_action_break_a OR take_action_break_b) OR take_action_break_c;
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      xbrk_ctrl0 <= std_logic_vector'("00000000");
      xbrk_ctrl1 <= std_logic_vector'("00000000");
      xbrk_ctrl2 <= std_logic_vector'("00000000");
      xbrk_ctrl3 <= std_logic_vector'("00000000");
      trigbrktype <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        trigbrktype <= std_logic'('0');
      elsif std_logic'(dbrk_break) = '1' then 
        trigbrktype <= std_logic'('1');
      end if;
      if std_logic'(take_action_break_b) = '1' then 
        if ((break_b_rr = std_logic_vector'("00"))) AND ((std_logic_vector'("00000000000000000000000000000100")>=std_logic_vector'("00000000000000000000000000000001"))) then 
          xbrk_ctrl0(0) <= jdo(27);
          xbrk_ctrl0(1) <= jdo(28);
          xbrk_ctrl0(2) <= jdo(29);
          xbrk_ctrl0(3) <= jdo(30);
          xbrk_ctrl0(4) <= jdo(21);
          xbrk_ctrl0(5) <= jdo(20);
          xbrk_ctrl0(6) <= jdo(19);
          xbrk_ctrl0(7) <= jdo(18);
        end if;
        if ((break_b_rr = std_logic_vector'("01"))) AND ((std_logic_vector'("00000000000000000000000000000100")>=std_logic_vector'("00000000000000000000000000000010"))) then 
          xbrk_ctrl1(0) <= jdo(27);
          xbrk_ctrl1(1) <= jdo(28);
          xbrk_ctrl1(2) <= jdo(29);
          xbrk_ctrl1(3) <= jdo(30);
          xbrk_ctrl1(4) <= jdo(21);
          xbrk_ctrl1(5) <= jdo(20);
          xbrk_ctrl1(6) <= jdo(19);
          xbrk_ctrl1(7) <= jdo(18);
        end if;
        if ((break_b_rr = std_logic_vector'("10"))) AND ((std_logic_vector'("00000000000000000000000000000100")>=std_logic_vector'("00000000000000000000000000000011"))) then 
          xbrk_ctrl2(0) <= jdo(27);
          xbrk_ctrl2(1) <= jdo(28);
          xbrk_ctrl2(2) <= jdo(29);
          xbrk_ctrl2(3) <= jdo(30);
          xbrk_ctrl2(4) <= jdo(21);
          xbrk_ctrl2(5) <= jdo(20);
          xbrk_ctrl2(6) <= jdo(19);
          xbrk_ctrl2(7) <= jdo(18);
        end if;
        if ((break_b_rr = std_logic_vector'("11"))) AND ((std_logic_vector'("00000000000000000000000000000100")>=std_logic_vector'("00000000000000000000000000000100"))) then 
          xbrk_ctrl3(0) <= jdo(27);
          xbrk_ctrl3(1) <= jdo(28);
          xbrk_ctrl3(2) <= jdo(29);
          xbrk_ctrl3(3) <= jdo(30);
          xbrk_ctrl3(4) <= jdo(21);
          xbrk_ctrl3(5) <= jdo(20);
          xbrk_ctrl3(6) <= jdo(19);
          xbrk_ctrl3(7) <= jdo(18);
        end if;
      end if;
    end if;

  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        dbrk_hit0_latch <= std_logic'('0');
      elsif std_logic'((dbrk_hit0 AND internal_dbrk0(69))) = '1' then 
        dbrk_hit0_latch <= std_logic'('1');
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_dbrk0 <= std_logic_vector'("000000000000000000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((take_action_break_a AND to_std_logic((break_a_wpr_low_bits = std_logic_vector'("00"))))) = '1' then 
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000010") then 
          internal_dbrk0(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
        end if;
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000011") then 
          internal_dbrk0(63 DOWNTO 32) <= jdo(31 DOWNTO 0);
        end if;
      elsif std_logic'((take_action_break_c AND to_std_logic((break_c_rr = std_logic_vector'("00"))))) = '1' then 
        internal_dbrk0(65) <= jdo(23);
        internal_dbrk0(66) <= jdo(24);
        internal_dbrk0(67) <= jdo(25);
        internal_dbrk0(68) <= jdo(26);
        internal_dbrk0(69) <= jdo(27);
        internal_dbrk0(70) <= jdo(28);
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk0(64) <= jdo(22);
        end if;
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk0(71) <= jdo(29);
          internal_dbrk0(72) <= jdo(30);
          internal_dbrk0(73) <= jdo(31);
        end if;
        internal_dbrk0(74) <= jdo(21);
        internal_dbrk0(75) <= jdo(20);
        internal_dbrk0(76) <= jdo(19);
        internal_dbrk0(77) <= jdo(18);
      end if;
    end if;

  end process;

  dbrk0_low_value <= Vector_To_Std_Logic(internal_dbrk0(27 DOWNTO 0));
  dbrk0_high_value <= Vector_To_Std_Logic(internal_dbrk0(63 DOWNTO 32));
  process (clk)
  begin
    if clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        dbrk_hit1_latch <= std_logic'('0');
      elsif std_logic'((dbrk_hit1 AND internal_dbrk1(69))) = '1' then 
        dbrk_hit1_latch <= std_logic'('1');
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_dbrk1 <= std_logic_vector'("000000000000000000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((take_action_break_a AND to_std_logic((break_a_wpr_low_bits = std_logic_vector'("01"))))) = '1' then 
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000010") then 
          internal_dbrk1(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
        end if;
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000011") then 
          internal_dbrk1(63 DOWNTO 32) <= jdo(31 DOWNTO 0);
        end if;
      elsif std_logic'((take_action_break_c AND to_std_logic((break_c_rr = std_logic_vector'("01"))))) = '1' then 
        internal_dbrk1(65) <= jdo(23);
        internal_dbrk1(66) <= jdo(24);
        internal_dbrk1(67) <= jdo(25);
        internal_dbrk1(68) <= jdo(26);
        internal_dbrk1(69) <= jdo(27);
        internal_dbrk1(70) <= jdo(28);
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk1(64) <= jdo(22);
        end if;
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk1(71) <= jdo(29);
          internal_dbrk1(72) <= jdo(30);
          internal_dbrk1(73) <= jdo(31);
        end if;
        internal_dbrk1(74) <= jdo(21);
        internal_dbrk1(75) <= jdo(20);
        internal_dbrk1(76) <= jdo(19);
        internal_dbrk1(77) <= jdo(18);
      end if;
    end if;

  end process;

  dbrk1_low_value <= Vector_To_Std_Logic(internal_dbrk1(27 DOWNTO 0));
  dbrk1_high_value <= Vector_To_Std_Logic(internal_dbrk1(63 DOWNTO 32));
  process (clk)
  begin
    if clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        dbrk_hit2_latch <= std_logic'('0');
      elsif std_logic'((dbrk_hit2 AND internal_dbrk2(69))) = '1' then 
        dbrk_hit2_latch <= std_logic'('1');
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_dbrk2 <= std_logic_vector'("000000000000000000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((take_action_break_a AND to_std_logic((break_a_wpr_low_bits = std_logic_vector'("10"))))) = '1' then 
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000010") then 
          internal_dbrk2(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
        end if;
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000011") then 
          internal_dbrk2(63 DOWNTO 32) <= jdo(31 DOWNTO 0);
        end if;
      elsif std_logic'((take_action_break_c AND to_std_logic((break_c_rr = std_logic_vector'("10"))))) = '1' then 
        internal_dbrk2(65) <= jdo(23);
        internal_dbrk2(66) <= jdo(24);
        internal_dbrk2(67) <= jdo(25);
        internal_dbrk2(68) <= jdo(26);
        internal_dbrk2(69) <= jdo(27);
        internal_dbrk2(70) <= jdo(28);
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk2(64) <= jdo(22);
        end if;
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk2(71) <= jdo(29);
          internal_dbrk2(72) <= jdo(30);
          internal_dbrk2(73) <= jdo(31);
        end if;
        internal_dbrk2(74) <= jdo(21);
        internal_dbrk2(75) <= jdo(20);
        internal_dbrk2(76) <= jdo(19);
        internal_dbrk2(77) <= jdo(18);
      end if;
    end if;

  end process;

  dbrk2_low_value <= Vector_To_Std_Logic(internal_dbrk2(27 DOWNTO 0));
  dbrk2_high_value <= Vector_To_Std_Logic(internal_dbrk2(63 DOWNTO 32));
  process (clk)
  begin
    if clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        dbrk_hit3_latch <= std_logic'('0');
      elsif std_logic'((dbrk_hit3 AND internal_dbrk3(69))) = '1' then 
        dbrk_hit3_latch <= std_logic'('1');
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_dbrk3 <= std_logic_vector'("000000000000000000000000000000000000000000000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((take_action_break_a AND to_std_logic((break_a_wpr_low_bits = std_logic_vector'("11"))))) = '1' then 
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000010") then 
          internal_dbrk3(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
        end if;
        if (std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000011") then 
          internal_dbrk3(63 DOWNTO 32) <= jdo(31 DOWNTO 0);
        end if;
      elsif std_logic'((take_action_break_c AND to_std_logic((break_c_rr = std_logic_vector'("11"))))) = '1' then 
        internal_dbrk3(65) <= jdo(23);
        internal_dbrk3(66) <= jdo(24);
        internal_dbrk3(67) <= jdo(25);
        internal_dbrk3(68) <= jdo(26);
        internal_dbrk3(69) <= jdo(27);
        internal_dbrk3(70) <= jdo(28);
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk3(64) <= jdo(22);
        end if;
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          internal_dbrk3(71) <= jdo(29);
          internal_dbrk3(72) <= jdo(30);
          internal_dbrk3(73) <= jdo(31);
        end if;
        internal_dbrk3(74) <= jdo(21);
        internal_dbrk3(75) <= jdo(20);
        internal_dbrk3(76) <= jdo(19);
        internal_dbrk3(77) <= jdo(18);
      end if;
    end if;

  end process;

  dbrk3_low_value <= Vector_To_Std_Logic(internal_dbrk3(27 DOWNTO 0));
  dbrk3_high_value <= Vector_To_Std_Logic(internal_dbrk3(63 DOWNTO 32));
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_xbrk0 <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((take_action_break_a AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic(((break_a_wpr_low_bits = std_logic_vector'("00")))))) = '1' then 
        internal_xbrk0(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
      end if;
    end if;

  end process;

  xbrk0_value <= std_logic_vector'("0000") & (internal_xbrk0);
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_xbrk1 <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((take_action_break_a AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic(((break_a_wpr_low_bits = std_logic_vector'("01")))))) = '1' then 
        internal_xbrk1(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
      end if;
    end if;

  end process;

  xbrk1_value <= std_logic_vector'("0000") & (internal_xbrk1);
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_xbrk2 <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((take_action_break_a AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic(((break_a_wpr_low_bits = std_logic_vector'("10")))))) = '1' then 
        internal_xbrk2(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
      end if;
    end if;

  end process;

  xbrk2_value <= std_logic_vector'("0000") & (internal_xbrk2);
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_xbrk3 <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((take_action_break_a AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (break_a_wpr_high_bits)) = std_logic_vector'("00000000000000000000000000000000"))))) AND to_std_logic(((break_a_wpr_low_bits = std_logic_vector'("11")))))) = '1' then 
        internal_xbrk3(27 DOWNTO 0) <= A_EXT (jdo(31 DOWNTO 0), 28);
      end if;
    end if;

  end process;

  xbrk3_value <= std_logic_vector'("0000") & (internal_xbrk3);
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      break_readreg <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(take_action_any_break) = '1' then 
        break_readreg <= jdo(31 DOWNTO 0);
      elsif std_logic'(take_no_action_break_a) = '1' then 
        case break_a_wpr_high_bits is
            when std_logic_vector'("00") => 
                case break_a_wpr_low_bits is -- synthesis full_case
                    when std_logic_vector'("00") => 
                        break_readreg <= xbrk0_value;
                    -- when std_logic_vector'("00") 
                
                    when std_logic_vector'("01") => 
                        break_readreg <= xbrk1_value;
                    -- when std_logic_vector'("01") 
                
                    when std_logic_vector'("10") => 
                        break_readreg <= xbrk2_value;
                    -- when std_logic_vector'("10") 
                
                    when std_logic_vector'("11") => 
                        break_readreg <= xbrk3_value;
                    -- when std_logic_vector'("11") 
                
                    when others => 
                    -- when others 
                
                end case; -- break_a_wpr_low_bits
            -- when std_logic_vector'("00") 
        
            when std_logic_vector'("01") => 
                break_readreg <= std_logic_vector'("00000000000000000000000000000000");
            -- when std_logic_vector'("01") 
        
            when std_logic_vector'("10") => 
                case break_a_wpr_low_bits is -- synthesis full_case
                    when std_logic_vector'("00") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk0_low_value));
                    -- when std_logic_vector'("00") 
                
                    when std_logic_vector'("01") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk1_low_value));
                    -- when std_logic_vector'("01") 
                
                    when std_logic_vector'("10") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk2_low_value));
                    -- when std_logic_vector'("10") 
                
                    when std_logic_vector'("11") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk3_low_value));
                    -- when std_logic_vector'("11") 
                
                    when others => 
                    -- when others 
                
                end case; -- break_a_wpr_low_bits
            -- when std_logic_vector'("10") 
        
            when std_logic_vector'("11") => 
                case break_a_wpr_low_bits is -- synthesis full_case
                    when std_logic_vector'("00") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk0_high_value));
                    -- when std_logic_vector'("00") 
                
                    when std_logic_vector'("01") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk1_high_value));
                    -- when std_logic_vector'("01") 
                
                    when std_logic_vector'("10") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk2_high_value));
                    -- when std_logic_vector'("10") 
                
                    when std_logic_vector'("11") => 
                        break_readreg <= std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk3_high_value));
                    -- when std_logic_vector'("11") 
                
                    when others => 
                    -- when others 
                
                end case; -- break_a_wpr_low_bits
            -- when std_logic_vector'("11") 
        
            when others => 
            -- when others 
        
        end case; -- break_a_wpr_high_bits
      elsif std_logic'(take_no_action_break_b) = '1' then 
        break_readreg <= jdo(31 DOWNTO 0);
      elsif std_logic'(take_no_action_break_c) = '1' then 
        break_readreg <= jdo(31 DOWNTO 0);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      trigger_state <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((internal_trigger_state_1 AND ((xbrk_goto0 OR dbrk_goto0)))) = '1' then 
        trigger_state <= std_logic'('0');
      elsif std_logic'((internal_trigger_state_0 AND ((xbrk_goto1 OR dbrk_goto1)))) = '1' then 
        trigger_state <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  internal_trigger_state_0 <= NOT trigger_state;
  internal_trigger_state_1 <= trigger_state;
  --vhdl renameroo for output signals
  dbrk0 <= internal_dbrk0;
  --vhdl renameroo for output signals
  dbrk1 <= internal_dbrk1;
  --vhdl renameroo for output signals
  dbrk2 <= internal_dbrk2;
  --vhdl renameroo for output signals
  dbrk3 <= internal_dbrk3;
  --vhdl renameroo for output signals
  trigger_state_0 <= internal_trigger_state_0;
  --vhdl renameroo for output signals
  trigger_state_1 <= internal_trigger_state_1;
  --vhdl renameroo for output signals
  xbrk0 <= internal_xbrk0;
  --vhdl renameroo for output signals
  xbrk1 <= internal_xbrk1;
  --vhdl renameroo for output signals
  xbrk2 <= internal_xbrk2;
  --vhdl renameroo for output signals
  xbrk3 <= internal_xbrk3;

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

entity cpu_nios2_oci_xbrk is 
        port (
              -- inputs:
                 signal D_en : IN STD_LOGIC;
                 signal E_en : IN STD_LOGIC;
                 signal E_valid : IN STD_LOGIC;
                 signal F_pc : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal M_en : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal trigger_state_0 : IN STD_LOGIC;
                 signal trigger_state_1 : IN STD_LOGIC;
                 signal xbrk0 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk1 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk2 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk3 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal xbrk_ctrl0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal xbrk_ctrl3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- outputs:
                 signal xbrk_break : OUT STD_LOGIC;
                 signal xbrk_goto0 : OUT STD_LOGIC;
                 signal xbrk_goto1 : OUT STD_LOGIC;
                 signal xbrk_traceoff : OUT STD_LOGIC;
                 signal xbrk_traceon : OUT STD_LOGIC;
                 signal xbrk_trigout : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_xbrk;


architecture europa of cpu_nios2_oci_xbrk is
                signal D_cpu_addr_en :  STD_LOGIC;
                signal E_cpu_addr_en :  STD_LOGIC;
                signal E_xbrk_goto0 :  STD_LOGIC;
                signal E_xbrk_goto1 :  STD_LOGIC;
                signal E_xbrk_traceoff :  STD_LOGIC;
                signal E_xbrk_traceon :  STD_LOGIC;
                signal E_xbrk_trigout :  STD_LOGIC;
                signal M_xbrk_goto0 :  STD_LOGIC;
                signal M_xbrk_goto1 :  STD_LOGIC;
                signal M_xbrk_traceoff :  STD_LOGIC;
                signal M_xbrk_traceon :  STD_LOGIC;
                signal M_xbrk_trigout :  STD_LOGIC;
                signal cpu_i_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal xbrk0_armed :  STD_LOGIC;
                signal xbrk0_break_hit :  STD_LOGIC;
                signal xbrk0_goto0_hit :  STD_LOGIC;
                signal xbrk0_goto1_hit :  STD_LOGIC;
                signal xbrk0_toff_hit :  STD_LOGIC;
                signal xbrk0_ton_hit :  STD_LOGIC;
                signal xbrk0_tout_hit :  STD_LOGIC;
                signal xbrk1_armed :  STD_LOGIC;
                signal xbrk1_break_hit :  STD_LOGIC;
                signal xbrk1_goto0_hit :  STD_LOGIC;
                signal xbrk1_goto1_hit :  STD_LOGIC;
                signal xbrk1_toff_hit :  STD_LOGIC;
                signal xbrk1_ton_hit :  STD_LOGIC;
                signal xbrk1_tout_hit :  STD_LOGIC;
                signal xbrk2_armed :  STD_LOGIC;
                signal xbrk2_break_hit :  STD_LOGIC;
                signal xbrk2_goto0_hit :  STD_LOGIC;
                signal xbrk2_goto1_hit :  STD_LOGIC;
                signal xbrk2_toff_hit :  STD_LOGIC;
                signal xbrk2_ton_hit :  STD_LOGIC;
                signal xbrk2_tout_hit :  STD_LOGIC;
                signal xbrk3_armed :  STD_LOGIC;
                signal xbrk3_break_hit :  STD_LOGIC;
                signal xbrk3_goto0_hit :  STD_LOGIC;
                signal xbrk3_goto1_hit :  STD_LOGIC;
                signal xbrk3_toff_hit :  STD_LOGIC;
                signal xbrk3_ton_hit :  STD_LOGIC;
                signal xbrk3_tout_hit :  STD_LOGIC;
                signal xbrk_break_hit :  STD_LOGIC;
                signal xbrk_goto0_hit :  STD_LOGIC;
                signal xbrk_goto1_hit :  STD_LOGIC;
                signal xbrk_hit0 :  STD_LOGIC;
                signal xbrk_hit1 :  STD_LOGIC;
                signal xbrk_hit2 :  STD_LOGIC;
                signal xbrk_hit3 :  STD_LOGIC;
                signal xbrk_toff_hit :  STD_LOGIC;
                signal xbrk_ton_hit :  STD_LOGIC;
                signal xbrk_tout_hit :  STD_LOGIC;

begin

  cpu_i_address <= F_pc & std_logic_vector'("00");
  D_cpu_addr_en <= D_en;
  E_cpu_addr_en <= E_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      xbrk_hit0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_cpu_addr_en) = '1' then 
        xbrk_hit0 <= to_std_logic((cpu_i_address = xbrk0(27 DOWNTO 0)));
      end if;
    end if;

  end process;

  xbrk0_break_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(0);
  xbrk0_ton_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(3);
  xbrk0_toff_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(2);
  xbrk0_tout_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(1);
  xbrk0_goto0_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(6);
  xbrk0_goto1_hit <= (xbrk_hit0 AND xbrk0_armed) AND xbrk_ctrl0(7);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      xbrk_hit1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_cpu_addr_en) = '1' then 
        xbrk_hit1 <= to_std_logic((cpu_i_address = xbrk1(27 DOWNTO 0)));
      end if;
    end if;

  end process;

  xbrk1_break_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(0);
  xbrk1_ton_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(3);
  xbrk1_toff_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(2);
  xbrk1_tout_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(1);
  xbrk1_goto0_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(6);
  xbrk1_goto1_hit <= (xbrk_hit1 AND xbrk1_armed) AND xbrk_ctrl1(7);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      xbrk_hit2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_cpu_addr_en) = '1' then 
        xbrk_hit2 <= to_std_logic((cpu_i_address = xbrk2(27 DOWNTO 0)));
      end if;
    end if;

  end process;

  xbrk2_break_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(0);
  xbrk2_ton_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(3);
  xbrk2_toff_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(2);
  xbrk2_tout_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(1);
  xbrk2_goto0_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(6);
  xbrk2_goto1_hit <= (xbrk_hit2 AND xbrk2_armed) AND xbrk_ctrl2(7);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      xbrk_hit3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_cpu_addr_en) = '1' then 
        xbrk_hit3 <= to_std_logic((cpu_i_address = xbrk3(27 DOWNTO 0)));
      end if;
    end if;

  end process;

  xbrk3_break_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(0);
  xbrk3_ton_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(3);
  xbrk3_toff_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(2);
  xbrk3_tout_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(1);
  xbrk3_goto0_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(6);
  xbrk3_goto1_hit <= (xbrk_hit3 AND xbrk3_armed) AND xbrk_ctrl3(7);
  xbrk_break_hit <= (((xbrk0_break_hit) OR (xbrk1_break_hit)) OR (xbrk2_break_hit)) OR (xbrk3_break_hit);
  xbrk_ton_hit <= (((xbrk0_ton_hit) OR (xbrk1_ton_hit)) OR (xbrk2_ton_hit)) OR (xbrk3_ton_hit);
  xbrk_toff_hit <= (((xbrk0_toff_hit) OR (xbrk1_toff_hit)) OR (xbrk2_toff_hit)) OR (xbrk3_toff_hit);
  xbrk_tout_hit <= (((xbrk0_tout_hit) OR (xbrk1_tout_hit)) OR (xbrk2_tout_hit)) OR (xbrk3_tout_hit);
  xbrk_goto0_hit <= (((xbrk0_goto0_hit) OR (xbrk1_goto0_hit)) OR (xbrk2_goto0_hit)) OR (xbrk3_goto0_hit);
  xbrk_goto1_hit <= (((xbrk0_goto1_hit) OR (xbrk1_goto1_hit)) OR (xbrk2_goto1_hit)) OR (xbrk3_goto1_hit);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      xbrk_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        xbrk_break <= xbrk_break_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_xbrk_traceon <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        E_xbrk_traceon <= xbrk_ton_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_xbrk_traceoff <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        E_xbrk_traceoff <= xbrk_toff_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_xbrk_trigout <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        E_xbrk_trigout <= xbrk_tout_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_xbrk_goto0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        E_xbrk_goto0 <= xbrk_goto0_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_xbrk_goto1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_cpu_addr_en) = '1' then 
        E_xbrk_goto1 <= xbrk_goto1_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_xbrk_traceon <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_xbrk_traceon <= E_xbrk_traceon AND E_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_xbrk_traceoff <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_xbrk_traceoff <= E_xbrk_traceoff AND E_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_xbrk_trigout <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_xbrk_trigout <= E_xbrk_trigout AND E_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_xbrk_goto0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_xbrk_goto0 <= E_xbrk_goto0 AND E_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_xbrk_goto1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_xbrk_goto1 <= E_xbrk_goto1 AND E_valid;
      end if;
    end if;

  end process;

  xbrk_traceon <= M_xbrk_traceon;
  xbrk_traceoff <= M_xbrk_traceoff;
  xbrk_trigout <= M_xbrk_trigout;
  xbrk_goto0 <= M_xbrk_goto0;
  xbrk_goto1 <= M_xbrk_goto1;
  xbrk0_armed <= ((xbrk_ctrl0(4) AND trigger_state_0)) OR ((xbrk_ctrl0(5) AND trigger_state_1));
  xbrk1_armed <= ((xbrk_ctrl1(4) AND trigger_state_0)) OR ((xbrk_ctrl1(5) AND trigger_state_1));
  xbrk2_armed <= ((xbrk_ctrl2(4) AND trigger_state_0)) OR ((xbrk_ctrl2(5) AND trigger_state_1));
  xbrk3_armed <= ((xbrk_ctrl3(4) AND trigger_state_0)) OR ((xbrk_ctrl3(5) AND trigger_state_1));

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

entity cpu_nios2_oci_match_single is 
        port (
              -- inputs:
                 signal addr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal dbrk : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                 signal read : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal match_single : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_match_single;


architecture europa of cpu_nios2_oci_match_single is
                signal match_single_combinatorial :  STD_LOGIC;

begin

  match_single_combinatorial <= (((NOT dbrk(67) OR to_std_logic(((addr = dbrk(27 DOWNTO 0)))))) AND ((NOT dbrk(68) OR to_std_logic(((data = dbrk(63 DOWNTO 32))))))) AND ((((dbrk(66) AND read)) OR ((dbrk(65) AND write))));
  match_single <= match_single_combinatorial;

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

entity cpu_nios2_oci_match_paired is 
        port (
              -- inputs:
                 signal addr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal dbrka : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                 signal dbrkb : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                 signal read : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal match_paired : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_match_paired;


architecture europa of cpu_nios2_oci_match_paired is
                signal match_paired_combinatorial :  STD_LOGIC;

begin

  match_paired_combinatorial <= (((NOT dbrka(67) OR to_std_logic(((((addr>=dbrka(27 DOWNTO 0))) AND ((addr<=dbrkb(27 DOWNTO 0)))))))) AND ((NOT dbrka(68) OR to_std_logic(((((((data XOR dbrka(63 DOWNTO 32))) AND dbrkb(63 DOWNTO 32))) = std_logic_vector'("00000000000000000000000000000000"))))))) AND ((((dbrka(66) AND read)) OR ((dbrka(65) AND write))));
  match_paired <= match_paired_combinatorial;

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

entity cpu_nios2_oci_dbrk is 
        port (
              -- inputs:
                 signal A_ctrl_ld : IN STD_LOGIC;
                 signal A_ctrl_st : IN STD_LOGIC;
                 signal A_en : IN STD_LOGIC;
                 signal A_mem_baddr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_valid : IN STD_LOGIC;
                 signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal dbrk0 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk1 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk2 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal dbrk3 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                 signal debugack : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal trigger_state_0 : IN STD_LOGIC;
                 signal trigger_state_1 : IN STD_LOGIC;

              -- outputs:
                 signal cpu_d_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal cpu_d_read : OUT STD_LOGIC;
                 signal cpu_d_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_d_wait : OUT STD_LOGIC;
                 signal cpu_d_write : OUT STD_LOGIC;
                 signal cpu_d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal dbrk_break : OUT STD_LOGIC;
                 signal dbrk_goto0 : OUT STD_LOGIC;
                 signal dbrk_goto1 : OUT STD_LOGIC;
                 signal dbrk_hit0 : OUT STD_LOGIC;
                 signal dbrk_hit1 : OUT STD_LOGIC;
                 signal dbrk_hit2 : OUT STD_LOGIC;
                 signal dbrk_hit3 : OUT STD_LOGIC;
                 signal dbrk_traceme : OUT STD_LOGIC;
                 signal dbrk_traceoff : OUT STD_LOGIC;
                 signal dbrk_traceon : OUT STD_LOGIC;
                 signal dbrk_trigout : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_dbrk;


architecture europa of cpu_nios2_oci_dbrk is
component cpu_nios2_oci_match_single is 
           port (
                 -- inputs:
                    signal addr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal dbrk : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal match_single : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_match_single;

component cpu_nios2_oci_match_paired is 
           port (
                 -- inputs:
                    signal addr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal dbrka : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                    signal dbrkb : IN STD_LOGIC_VECTOR (73 DOWNTO 0);
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal match_paired : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_match_paired;

                signal cpu_d_read_valid :  STD_LOGIC;
                signal dbrk0_armed :  STD_LOGIC;
                signal dbrk0_break_pulse :  STD_LOGIC;
                signal dbrk0_goto0 :  STD_LOGIC;
                signal dbrk0_goto1 :  STD_LOGIC;
                signal dbrk0_traceme :  STD_LOGIC;
                signal dbrk0_traceoff :  STD_LOGIC;
                signal dbrk0_traceon :  STD_LOGIC;
                signal dbrk0_trigout :  STD_LOGIC;
                signal dbrk1_armed :  STD_LOGIC;
                signal dbrk1_break_pulse :  STD_LOGIC;
                signal dbrk1_goto0 :  STD_LOGIC;
                signal dbrk1_goto1 :  STD_LOGIC;
                signal dbrk1_traceme :  STD_LOGIC;
                signal dbrk1_traceoff :  STD_LOGIC;
                signal dbrk1_traceon :  STD_LOGIC;
                signal dbrk1_trigout :  STD_LOGIC;
                signal dbrk2_armed :  STD_LOGIC;
                signal dbrk2_break_pulse :  STD_LOGIC;
                signal dbrk2_goto0 :  STD_LOGIC;
                signal dbrk2_goto1 :  STD_LOGIC;
                signal dbrk2_traceme :  STD_LOGIC;
                signal dbrk2_traceoff :  STD_LOGIC;
                signal dbrk2_traceon :  STD_LOGIC;
                signal dbrk2_trigout :  STD_LOGIC;
                signal dbrk3_armed :  STD_LOGIC;
                signal dbrk3_break_pulse :  STD_LOGIC;
                signal dbrk3_goto0 :  STD_LOGIC;
                signal dbrk3_goto1 :  STD_LOGIC;
                signal dbrk3_traceme :  STD_LOGIC;
                signal dbrk3_traceoff :  STD_LOGIC;
                signal dbrk3_traceon :  STD_LOGIC;
                signal dbrk3_trigout :  STD_LOGIC;
                signal dbrk_break_pulse :  STD_LOGIC;
                signal dbrk_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dbrk_hit0_match_paired :  STD_LOGIC;
                signal dbrk_hit0_match_single :  STD_LOGIC;
                signal dbrk_hit1_match_single :  STD_LOGIC;
                signal dbrk_hit2_match_paired :  STD_LOGIC;
                signal dbrk_hit2_match_single :  STD_LOGIC;
                signal dbrk_hit3_match_single :  STD_LOGIC;
                signal internal_cpu_d_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_cpu_d_read :  STD_LOGIC;
                signal internal_cpu_d_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_cpu_d_wait :  STD_LOGIC;
                signal internal_cpu_d_write :  STD_LOGIC;
                signal internal_cpu_d_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_dbrk_break :  STD_LOGIC;
                signal internal_dbrk_hit0 :  STD_LOGIC;
                signal internal_dbrk_hit1 :  STD_LOGIC;
                signal internal_dbrk_hit2 :  STD_LOGIC;
                signal internal_dbrk_hit3 :  STD_LOGIC;
                signal module_input10 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input11 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input12 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input13 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input14 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input7 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input8 :  STD_LOGIC_VECTOR (73 DOWNTO 0);
                signal module_input9 :  STD_LOGIC_VECTOR (73 DOWNTO 0);

begin

  internal_cpu_d_address <= A_mem_baddr;
  internal_cpu_d_readdata <= A_wr_data_filtered;
  internal_cpu_d_read <= A_ctrl_ld AND A_valid;
  internal_cpu_d_writedata <= A_st_data;
  internal_cpu_d_write <= A_ctrl_st AND A_valid;
  internal_cpu_d_wait <= NOT A_en;
  dbrk_data <= A_WE_StdLogicVector((std_logic'(internal_cpu_d_write) = '1'), internal_cpu_d_writedata, internal_cpu_d_readdata);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_dbrk_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_dbrk_break <= A_WE_StdLogic((std_logic'(internal_dbrk_break) = '1'), NOT debugack, dbrk_break_pulse);
    end if;

  end process;

  internal_dbrk_hit0 <= A_WE_StdLogic((std_logic'(dbrk0(64)) = '1'), dbrk_hit0_match_paired, dbrk_hit0_match_single);
  cpu_d_read_valid <= internal_cpu_d_read AND NOT internal_cpu_d_wait;
  --cpu_nios2_oci_dbrk_hit0_match_single, which is an e_instance
  cpu_nios2_oci_dbrk_hit0_match_single : cpu_nios2_oci_match_single
    port map(
      match_single => dbrk_hit0_match_single,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrk => module_input7,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input7 <= dbrk0(73 DOWNTO 0);

  dbrk0_trigout <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(70);
  dbrk0_break_pulse <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(69);
  dbrk0_armed <= ((dbrk0(74) AND trigger_state_0)) OR ((dbrk0(75) AND trigger_state_1));
  dbrk0_traceoff <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(71);
  dbrk0_traceon <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(72);
  dbrk0_traceme <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(73);
  dbrk0_goto0 <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(76);
  dbrk0_goto1 <= (internal_dbrk_hit0 AND dbrk0_armed) AND dbrk0(77);
  --cpu_nios2_oci_dbrk_hit1_match_single, which is an e_instance
  cpu_nios2_oci_dbrk_hit1_match_single : cpu_nios2_oci_match_single
    port map(
      match_single => dbrk_hit1_match_single,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrk => module_input8,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input8 <= dbrk1(73 DOWNTO 0);

  dbrk1_trigout <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(70);
  dbrk1_break_pulse <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(69);
  dbrk1_armed <= ((dbrk1(74) AND trigger_state_0)) OR ((dbrk1(75) AND trigger_state_1));
  dbrk1_traceoff <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(71);
  dbrk1_traceon <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(72);
  dbrk1_traceme <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(73);
  dbrk1_goto0 <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(76);
  dbrk1_goto1 <= (internal_dbrk_hit1 AND dbrk1_armed) AND dbrk1(77);
  --cpu_nios2_oci_dbrk_hit0_match_paired, which is an e_instance
  cpu_nios2_oci_dbrk_hit0_match_paired : cpu_nios2_oci_match_paired
    port map(
      match_paired => dbrk_hit0_match_paired,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrka => module_input9,
      dbrkb => module_input10,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input9 <= dbrk0(73 DOWNTO 0);
  module_input10 <= dbrk1(73 DOWNTO 0);

  internal_dbrk_hit1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(dbrk0(64)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk_hit1_match_single)))));
  internal_dbrk_hit2 <= A_WE_StdLogic((std_logic'(dbrk2(64)) = '1'), dbrk_hit2_match_paired, dbrk_hit2_match_single);
  --cpu_nios2_oci_dbrk_hit2_match_single, which is an e_instance
  cpu_nios2_oci_dbrk_hit2_match_single : cpu_nios2_oci_match_single
    port map(
      match_single => dbrk_hit2_match_single,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrk => module_input11,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input11 <= dbrk2(73 DOWNTO 0);

  dbrk2_trigout <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(70);
  dbrk2_break_pulse <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(69);
  dbrk2_armed <= ((dbrk2(74) AND trigger_state_0)) OR ((dbrk2(75) AND trigger_state_1));
  dbrk2_traceoff <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(71);
  dbrk2_traceon <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(72);
  dbrk2_traceme <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(73);
  dbrk2_goto0 <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(76);
  dbrk2_goto1 <= (internal_dbrk_hit2 AND dbrk2_armed) AND dbrk2(77);
  --cpu_nios2_oci_dbrk_hit3_match_single, which is an e_instance
  cpu_nios2_oci_dbrk_hit3_match_single : cpu_nios2_oci_match_single
    port map(
      match_single => dbrk_hit3_match_single,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrk => module_input12,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input12 <= dbrk3(73 DOWNTO 0);

  dbrk3_trigout <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(70);
  dbrk3_break_pulse <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(69);
  dbrk3_armed <= ((dbrk3(74) AND trigger_state_0)) OR ((dbrk3(75) AND trigger_state_1));
  dbrk3_traceoff <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(71);
  dbrk3_traceon <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(72);
  dbrk3_traceme <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(73);
  dbrk3_goto0 <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(76);
  dbrk3_goto1 <= (internal_dbrk_hit3 AND dbrk3_armed) AND dbrk3(77);
  --cpu_nios2_oci_dbrk_hit2_match_paired, which is an e_instance
  cpu_nios2_oci_dbrk_hit2_match_paired : cpu_nios2_oci_match_paired
    port map(
      match_paired => dbrk_hit2_match_paired,
      addr => internal_cpu_d_address,
      data => dbrk_data,
      dbrka => module_input13,
      dbrkb => module_input14,
      read => cpu_d_read_valid,
      write => internal_cpu_d_write
    );

  module_input13 <= dbrk2(73 DOWNTO 0);
  module_input14 <= dbrk3(73 DOWNTO 0);

  internal_dbrk_hit3 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(dbrk2(64)) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(dbrk_hit3_match_single)))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbrk_trigout <= std_logic'('0');
      dbrk_break_pulse <= std_logic'('0');
      dbrk_traceoff <= std_logic'('0');
      dbrk_traceon <= std_logic'('0');
      dbrk_traceme <= std_logic'('0');
      dbrk_goto0 <= std_logic'('0');
      dbrk_goto1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      dbrk_trigout <= ((dbrk0_trigout OR dbrk1_trigout) OR dbrk2_trigout) OR dbrk3_trigout;
      dbrk_break_pulse <= ((dbrk0_break_pulse OR dbrk1_break_pulse) OR dbrk2_break_pulse) OR dbrk3_break_pulse;
      dbrk_traceoff <= ((dbrk0_traceoff OR dbrk1_traceoff) OR dbrk2_traceoff) OR dbrk3_traceoff;
      dbrk_traceon <= ((dbrk0_traceon OR dbrk1_traceon) OR dbrk2_traceon) OR dbrk3_traceon;
      dbrk_traceme <= ((dbrk0_traceme OR dbrk1_traceme) OR dbrk2_traceme) OR dbrk3_traceme;
      dbrk_goto0 <= ((dbrk0_goto0 OR dbrk1_goto0) OR dbrk2_goto0) OR dbrk3_goto0;
      dbrk_goto1 <= ((dbrk0_goto1 OR dbrk1_goto1) OR dbrk2_goto1) OR dbrk3_goto1;
    end if;

  end process;

  --vhdl renameroo for output signals
  cpu_d_address <= internal_cpu_d_address;
  --vhdl renameroo for output signals
  cpu_d_read <= internal_cpu_d_read;
  --vhdl renameroo for output signals
  cpu_d_readdata <= internal_cpu_d_readdata;
  --vhdl renameroo for output signals
  cpu_d_wait <= internal_cpu_d_wait;
  --vhdl renameroo for output signals
  cpu_d_write <= internal_cpu_d_write;
  --vhdl renameroo for output signals
  cpu_d_writedata <= internal_cpu_d_writedata;
  --vhdl renameroo for output signals
  dbrk_break <= internal_dbrk_break;
  --vhdl renameroo for output signals
  dbrk_hit0 <= internal_dbrk_hit0;
  --vhdl renameroo for output signals
  dbrk_hit1 <= internal_dbrk_hit1;
  --vhdl renameroo for output signals
  dbrk_hit2 <= internal_dbrk_hit2;
  --vhdl renameroo for output signals
  dbrk_hit3 <= internal_dbrk_hit3;

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

entity cpu_nios2_oci_itrace is 
        port (
              -- inputs:
                 signal A_cmp_result : IN STD_LOGIC;
                 signal A_ctrl_exception : IN STD_LOGIC;
                 signal A_en : IN STD_LOGIC;
                 signal A_op_beq : IN STD_LOGIC;
                 signal A_op_bge : IN STD_LOGIC;
                 signal A_op_bgeu : IN STD_LOGIC;
                 signal A_op_blt : IN STD_LOGIC;
                 signal A_op_bltu : IN STD_LOGIC;
                 signal A_op_bne : IN STD_LOGIC;
                 signal A_op_br : IN STD_LOGIC;
                 signal A_op_bret : IN STD_LOGIC;
                 signal A_op_call : IN STD_LOGIC;
                 signal A_op_callr : IN STD_LOGIC;
                 signal A_op_eret : IN STD_LOGIC;
                 signal A_op_jmp : IN STD_LOGIC;
                 signal A_op_jmpi : IN STD_LOGIC;
                 signal A_op_ret : IN STD_LOGIC;
                 signal A_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal A_valid : IN STD_LOGIC;
                 signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal dbrk_traceoff : IN STD_LOGIC;
                 signal dbrk_traceon : IN STD_LOGIC;
                 signal debugack : IN STD_LOGIC;
                 signal jdo : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal take_action_tracectrl : IN STD_LOGIC;
                 signal trc_enb : IN STD_LOGIC;
                 signal xbrk_traceoff : IN STD_LOGIC;
                 signal xbrk_traceon : IN STD_LOGIC;
                 signal xbrk_wrap_traceoff : IN STD_LOGIC;

              -- outputs:
                 signal dct_buffer : OUT STD_LOGIC_VECTOR (29 DOWNTO 0);
                 signal dct_count : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal itm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal trc_ctrl : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal trc_on : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_itrace;


architecture europa of cpu_nios2_oci_itrace is
                signal advanced_exception :  STD_LOGIC;
                signal cond_dct_taken :  STD_LOGIC;
                signal d1_debugack :  STD_LOGIC;
                signal dct_code :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal dct_is_taken :  STD_LOGIC;
                signal excaddr :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal instr_retired :  STD_LOGIC;
                signal internal_dct_buffer :  STD_LOGIC_VECTOR (29 DOWNTO 0);
                signal internal_dct_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_trc_ctrl :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_trc_on :  STD_LOGIC;
                signal is_cond_dct :  STD_LOGIC;
                signal is_dct :  STD_LOGIC;
                signal is_exception :  STD_LOGIC;
                signal is_fast_tlb_miss_exception :  STD_LOGIC;
                signal is_idct :  STD_LOGIC;
                signal is_uncond_dct :  STD_LOGIC;
                signal not_in_debug_mode :  STD_LOGIC;
                signal pending_excaddr :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pending_exctype :  STD_LOGIC;
                signal pending_frametype :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal record_dct_outcome_in_sync :  STD_LOGIC;
                signal record_itrace :  STD_LOGIC;
                signal retired_pcb :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sync_code :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sync_interval :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal sync_pending :  STD_LOGIC;
                signal sync_timer :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal sync_timer_next :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal synced :  STD_LOGIC;
                signal trc_clear :  STD_LOGIC;
                signal trc_ctrl_reg :  STD_LOGIC_VECTOR (10 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of d1_debugack : signal is "SUPPRESS_DA_RULE_INTERNAL=D103";
attribute ALTERA_ATTRIBUTE of dct_buffer : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of dct_count : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of itm : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of pending_exctype : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of pending_frametype : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of sync_timer : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of trc_clear : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of trc_ctrl_reg : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";

begin

  is_cond_dct <= ((((A_op_bge OR A_op_blt) OR A_op_bne) OR A_op_bgeu) OR A_op_bltu) OR A_op_beq;
  is_uncond_dct <= (A_op_br OR A_op_call) OR A_op_jmpi;
  is_dct <= is_cond_dct OR is_uncond_dct;
  cond_dct_taken <= A_cmp_result;
  dct_is_taken <= is_uncond_dct OR ((is_cond_dct AND cond_dct_taken));
  is_idct <= (((A_op_jmp OR A_op_callr) OR A_op_ret) OR A_op_eret) OR A_op_bret;
  retired_pcb <= std_logic_vector'("0000") & (A_pcb);
  not_in_debug_mode <= NOT d1_debugack;
  instr_retired <= A_valid AND A_en;
  advanced_exception <= std_logic'('0');
  is_exception <= A_ctrl_exception;
  is_fast_tlb_miss_exception <= std_logic'('0');
  excaddr <= A_wr_data_filtered;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_debugack <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(instr_retired) = '1' then 
        d1_debugack <= debugack;
      end if;
    end if;

  end process;

  sync_code <= internal_trc_ctrl(3 DOWNTO 2);
  sync_interval <= Std_Logic_Vector'(A_ToStdLogicVector((sync_code(1) AND sync_code(0))) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector((sync_code(1) AND NOT sync_code(0))) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector((NOT sync_code(1) AND sync_code(0))) & std_logic_vector'("00"));
  sync_pending <= to_std_logic(((std_logic_vector'("0000000000000000000000000") & (sync_timer)) = std_logic_vector'("00000000000000000000000000000000")));
  record_dct_outcome_in_sync <= dct_is_taken AND sync_pending;
  sync_timer_next <= A_EXT (A_WE_StdLogicVector((std_logic'(sync_pending) = '1'), (std_logic_vector'("00000000000000000000000000") & (sync_timer)), (((std_logic_vector'("00000000000000000000000000") & (sync_timer)) - std_logic_vector'("000000000000000000000000000000001")))), 7);
  record_itrace <= internal_trc_on AND internal_trc_ctrl(4);
  synced <= to_std_logic((pending_frametype /= std_logic_vector'("1010")));
  dct_code <= Std_Logic_Vector'(A_ToStdLogicVector(is_cond_dct) & A_ToStdLogicVector(dct_is_taken));
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      trc_clear <= std_logic'('0');
    elsif clk'event and clk = '1' then
      trc_clear <= (NOT trc_enb AND take_action_tracectrl) AND jdo(4);
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      itm <= std_logic_vector'("000000000000000000000000000000000000");
      internal_dct_buffer <= std_logic_vector'("000000000000000000000000000000");
      internal_dct_count <= std_logic_vector'("0000");
      sync_timer <= std_logic_vector'("0000000");
      pending_frametype <= std_logic_vector'("0000");
      pending_exctype <= std_logic'('0');
      pending_excaddr <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((trc_clear OR ((NOT(or_reduce(std_logic_vector'("00000000000000000000000000000001"))) AND NOT(or_reduce(std_logic_vector'("00000000000000000000000000000001"))))))) = '1' then 
        itm <= std_logic_vector'("000000000000000000000000000000000000");
        internal_dct_buffer <= std_logic_vector'("000000000000000000000000000000");
        internal_dct_count <= std_logic_vector'("0000");
        sync_timer <= std_logic_vector'("0000000");
        pending_frametype <= std_logic_vector'("0000");
        pending_exctype <= std_logic'('0');
        pending_excaddr <= std_logic_vector'("00000000000000000000000000000000");
      elsif std_logic'((instr_retired OR advanced_exception)) = '1' then 
        if std_logic'(NOT record_itrace) = '1' then 
          pending_frametype <= std_logic_vector'("1010");
        elsif std_logic'(is_exception) = '1' then 
          pending_frametype <= std_logic_vector'("0010");
          pending_excaddr <= excaddr;
          if std_logic'(is_fast_tlb_miss_exception) = '1' then 
            pending_exctype <= std_logic'('1');
          else
            pending_exctype <= std_logic'('0');
          end if;
        elsif std_logic'(is_idct) = '1' then 
          pending_frametype <= std_logic_vector'("1001");
        elsif std_logic'(record_dct_outcome_in_sync) = '1' then 
          pending_frametype <= std_logic_vector'("1000");
        else
          pending_frametype <= std_logic_vector'("0000");
        end if;
        if std_logic'((to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (internal_dct_count)) /= std_logic_vector'("00000000000000000000000000000000")))) AND ((((NOT record_itrace OR is_idct) OR is_exception) OR record_dct_outcome_in_sync)))) = '1' then 
          itm <= Std_Logic_Vector'(std_logic_vector'("0001") & internal_dct_buffer & std_logic_vector'("00"));
          internal_dct_buffer <= std_logic_vector'("000000000000000000000000000000");
          internal_dct_count <= std_logic_vector'("0000");
          sync_timer <= sync_timer_next;
        else
          if std_logic'((((record_itrace AND ((is_dct AND to_std_logic(((internal_dct_count /= std_logic_vector'("1111"))))))) AND NOT record_dct_outcome_in_sync) AND NOT advanced_exception)) = '1' then 
            internal_dct_buffer <= dct_code & internal_dct_buffer(29 DOWNTO 2);
            internal_dct_count <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (internal_dct_count)) + std_logic_vector'("000000000000000000000000000000001")), 4);
          end if;
          if std_logic'(((record_itrace AND synced) AND to_std_logic(((pending_frametype = std_logic_vector'("0010")))))) = '1' then 
            itm <= Std_Logic_Vector'(std_logic_vector'("0010") & pending_excaddr(31 DOWNTO 1) & A_ToStdLogicVector(pending_exctype));
          elsif std_logic'((record_itrace AND to_std_logic(((pending_frametype /= std_logic_vector'("0000")))))) = '1' then 
            itm <= pending_frametype & retired_pcb;
            sync_timer <= sync_interval;
          elsif std_logic'(((record_itrace AND synced) AND is_dct)) = '1' then 
            if internal_dct_count = std_logic_vector'("1111") then 
              itm <= Std_Logic_Vector'(std_logic_vector'("0001") & dct_code & internal_dct_buffer);
              internal_dct_buffer <= std_logic_vector'("000000000000000000000000000000");
              internal_dct_count <= std_logic_vector'("0000");
              sync_timer <= sync_timer_next;
            else
              itm <= std_logic_vector'("000000000000000000000000000000000000");
            end if;
          else
            itm <= std_logic_vector'("000000000000000000000000000000000000");
          end if;
        end if;
      else
        itm <= std_logic_vector'("000000000000000000000000000000000000");
      end if;
    end if;

  end process;

  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      trc_ctrl_reg(0) <= std_logic'('0');
      trc_ctrl_reg(1) <= std_logic'('0');
      trc_ctrl_reg(3 DOWNTO 2) <= std_logic_vector'("00");
      trc_ctrl_reg(4) <= std_logic'('0');
      trc_ctrl_reg(7 DOWNTO 5) <= std_logic_vector'("000");
      trc_ctrl_reg(8) <= std_logic'('1');
      trc_ctrl_reg(9) <= std_logic'('0');
      trc_ctrl_reg(10) <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(take_action_tracectrl) = '1' then 
        trc_ctrl_reg(0) <= jdo(5);
        trc_ctrl_reg(1) <= jdo(6);
        trc_ctrl_reg(3 DOWNTO 2) <= jdo(8 DOWNTO 7);
        trc_ctrl_reg(4) <= jdo(9);
        trc_ctrl_reg(9) <= jdo(14);
        trc_ctrl_reg(10) <= jdo(2);
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          trc_ctrl_reg(7 DOWNTO 5) <= jdo(12 DOWNTO 10);
        end if;
        if ((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001"))) /= std_logic_vector'("00000000000000000000000000000000") then 
          trc_ctrl_reg(8) <= jdo(13);
        end if;
      elsif std_logic'(xbrk_wrap_traceoff) = '1' then 
        trc_ctrl_reg(1) <= std_logic'('0');
        trc_ctrl_reg(0) <= std_logic'('0');
      elsif std_logic'((dbrk_traceoff OR xbrk_traceoff)) = '1' then 
        trc_ctrl_reg(1) <= std_logic'('0');
      elsif std_logic'((trc_ctrl_reg(0) AND ((dbrk_traceon OR xbrk_traceon)))) = '1' then 
        trc_ctrl_reg(1) <= std_logic'('1');
      end if;
    end if;

  end process;

  internal_trc_ctrl <= A_EXT (A_WE_StdLogicVector((std_logic'(((or_reduce(std_logic_vector'("00000000000000000000000000000001")) OR or_reduce(std_logic_vector'("00000000000000000000000000000001"))))) = '1'), (std_logic_vector'("000000000000000") & (Std_Logic_Vector'(std_logic_vector'("000000") & trc_ctrl_reg))), std_logic_vector'("00000000000000000000000000000000")), 16);
  internal_trc_on <= internal_trc_ctrl(1) AND ((internal_trc_ctrl(9) OR not_in_debug_mode));
  --vhdl renameroo for output signals
  dct_buffer <= internal_dct_buffer;
  --vhdl renameroo for output signals
  dct_count <= internal_dct_count;
  --vhdl renameroo for output signals
  trc_ctrl <= internal_trc_ctrl;
  --vhdl renameroo for output signals
  trc_on <= internal_trc_on;

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

entity cpu_nios2_oci_td_mode is 
        port (
              -- inputs:
                 signal ctrl : IN STD_LOGIC_VECTOR (8 DOWNTO 0);

              -- outputs:
                 signal td_mode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
              );
end entity cpu_nios2_oci_td_mode;


architecture europa of cpu_nios2_oci_td_mode is
                signal ctrl_bits_for_mux :  STD_LOGIC_VECTOR (2 DOWNTO 0);

begin

  ctrl_bits_for_mux <= ctrl(7 DOWNTO 5);
  process (ctrl_bits_for_mux)
  begin
      case ctrl_bits_for_mux is
          when std_logic_vector'("000") => 
              td_mode <= std_logic_vector'("0000");
          -- when std_logic_vector'("000") 
      
          when std_logic_vector'("001") => 
              td_mode <= std_logic_vector'("1000");
          -- when std_logic_vector'("001") 
      
          when std_logic_vector'("010") => 
              td_mode <= std_logic_vector'("0100");
          -- when std_logic_vector'("010") 
      
          when std_logic_vector'("011") => 
              td_mode <= std_logic_vector'("1100");
          -- when std_logic_vector'("011") 
      
          when std_logic_vector'("100") => 
              td_mode <= std_logic_vector'("0010");
          -- when std_logic_vector'("100") 
      
          when std_logic_vector'("101") => 
              td_mode <= std_logic_vector'("1010");
          -- when std_logic_vector'("101") 
      
          when std_logic_vector'("110") => 
              td_mode <= std_logic_vector'("0101");
          -- when std_logic_vector'("110") 
      
          when std_logic_vector'("111") => 
              td_mode <= std_logic_vector'("1111");
          -- when std_logic_vector'("111") 
      
          when others => 
          -- when others 
      
      end case; -- ctrl_bits_for_mux

  end process;


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

entity cpu_nios2_oci_dtrace is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_d_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal cpu_d_read : IN STD_LOGIC;
                 signal cpu_d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_d_wait : IN STD_LOGIC;
                 signal cpu_d_write : IN STD_LOGIC;
                 signal cpu_d_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal trc_ctrl : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal atm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal dtm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
              );
end entity cpu_nios2_oci_dtrace;


architecture europa of cpu_nios2_oci_dtrace is
component cpu_nios2_oci_td_mode is 
           port (
                 -- inputs:
                    signal ctrl : IN STD_LOGIC_VECTOR (8 DOWNTO 0);

                 -- outputs:
                    signal td_mode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                 );
end component cpu_nios2_oci_td_mode;

                signal cpu_d_address_0_padded :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_d_readdata_0_padded :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_d_writedata_0_padded :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input15 :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal record_load_addr :  STD_LOGIC;
                signal record_load_data :  STD_LOGIC;
                signal record_store_addr :  STD_LOGIC;
                signal record_store_data :  STD_LOGIC;
                signal td_mode_trc_ctrl :  STD_LOGIC_VECTOR (3 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of atm : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of dtm : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  cpu_d_writedata_0_padded <= cpu_d_writedata OR std_logic_vector'("00000000000000000000000000000000");
  cpu_d_readdata_0_padded <= cpu_d_readdata OR std_logic_vector'("00000000000000000000000000000000");
  cpu_d_address_0_padded <= (std_logic_vector'("0000") & (cpu_d_address)) OR std_logic_vector'("00000000000000000000000000000000");
  --cpu_nios2_oci_trc_ctrl_td_mode, which is an e_instance
  cpu_nios2_oci_trc_ctrl_td_mode : cpu_nios2_oci_td_mode
    port map(
      td_mode => td_mode_trc_ctrl,
      ctrl => module_input15
    );

  module_input15 <= trc_ctrl(8 DOWNTO 0);

  (record_load_addr, record_store_addr, record_load_data, record_store_data) <= td_mode_trc_ctrl;
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      atm <= std_logic_vector'("000000000000000000000000000000000000");
      dtm <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        if std_logic'(((cpu_d_write AND NOT cpu_d_wait) AND record_store_addr)) = '1' then 
          atm <= Std_Logic_Vector'(std_logic_vector'("0101") & cpu_d_address_0_padded);
        elsif std_logic'(((cpu_d_read AND NOT cpu_d_wait) AND record_load_addr)) = '1' then 
          atm <= Std_Logic_Vector'(std_logic_vector'("0100") & cpu_d_address_0_padded);
        else
          atm <= Std_Logic_Vector'(std_logic_vector'("0000") & cpu_d_address_0_padded);
        end if;
        if std_logic'(((cpu_d_write AND NOT cpu_d_wait) AND record_store_data)) = '1' then 
          dtm <= Std_Logic_Vector'(std_logic_vector'("0111") & cpu_d_writedata_0_padded);
        elsif std_logic'(((cpu_d_read AND NOT cpu_d_wait) AND record_load_data)) = '1' then 
          dtm <= Std_Logic_Vector'(std_logic_vector'("0110") & cpu_d_readdata_0_padded);
        else
          dtm <= Std_Logic_Vector'(std_logic_vector'("0000") & cpu_d_readdata_0_padded);
        end if;
      else
        atm <= std_logic_vector'("000000000000000000000000000000000000");
        dtm <= std_logic_vector'("000000000000000000000000000000000000");
      end if;
    end if;

  end process;


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

entity cpu_nios2_oci_compute_tm_count is 
        port (
              -- inputs:
                 signal atm_valid : IN STD_LOGIC;
                 signal dtm_valid : IN STD_LOGIC;
                 signal itm_valid : IN STD_LOGIC;

              -- outputs:
                 signal compute_tm_count : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
              );
end entity cpu_nios2_oci_compute_tm_count;


architecture europa of cpu_nios2_oci_compute_tm_count is
                signal switch_for_mux :  STD_LOGIC_VECTOR (2 DOWNTO 0);

begin

  switch_for_mux <= Std_Logic_Vector'(A_ToStdLogicVector(itm_valid) & A_ToStdLogicVector(atm_valid) & A_ToStdLogicVector(dtm_valid));
  process (switch_for_mux)
  begin
      case switch_for_mux is
          when std_logic_vector'("000") => 
              compute_tm_count <= std_logic_vector'("00");
          -- when std_logic_vector'("000") 
      
          when std_logic_vector'("001") => 
              compute_tm_count <= std_logic_vector'("01");
          -- when std_logic_vector'("001") 
      
          when std_logic_vector'("010") => 
              compute_tm_count <= std_logic_vector'("01");
          -- when std_logic_vector'("010") 
      
          when std_logic_vector'("011") => 
              compute_tm_count <= std_logic_vector'("10");
          -- when std_logic_vector'("011") 
      
          when std_logic_vector'("100") => 
              compute_tm_count <= std_logic_vector'("01");
          -- when std_logic_vector'("100") 
      
          when std_logic_vector'("101") => 
              compute_tm_count <= std_logic_vector'("10");
          -- when std_logic_vector'("101") 
      
          when std_logic_vector'("110") => 
              compute_tm_count <= std_logic_vector'("10");
          -- when std_logic_vector'("110") 
      
          when std_logic_vector'("111") => 
              compute_tm_count <= std_logic_vector'("11");
          -- when std_logic_vector'("111") 
      
          when others => 
          -- when others 
      
      end case; -- switch_for_mux

  end process;


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

entity cpu_nios2_oci_fifowp_inc is 
        port (
              -- inputs:
                 signal free2 : IN STD_LOGIC;
                 signal free3 : IN STD_LOGIC;
                 signal tm_count : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

              -- outputs:
                 signal fifowp_inc : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
              );
end entity cpu_nios2_oci_fifowp_inc;


architecture europa of cpu_nios2_oci_fifowp_inc is

begin

  process (free2, free3, tm_count)
  begin
      if std_logic'((free3 AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (tm_count)) = std_logic_vector'("00000000000000000000000000000011")))))) = '1' then 
        fifowp_inc <= std_logic_vector'("0011");
      elsif std_logic'((free2 AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (tm_count))>=std_logic_vector'("00000000000000000000000000000010")))))) = '1' then 
        fifowp_inc <= std_logic_vector'("0010");
      elsif (std_logic_vector'("000000000000000000000000000000") & (tm_count))>=std_logic_vector'("00000000000000000000000000000001") then 
        fifowp_inc <= std_logic_vector'("0001");
      else
        fifowp_inc <= std_logic_vector'("0000");
      end if;

  end process;


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

entity cpu_nios2_oci_fifocount_inc is 
        port (
              -- inputs:
                 signal empty : IN STD_LOGIC;
                 signal free2 : IN STD_LOGIC;
                 signal free3 : IN STD_LOGIC;
                 signal tm_count : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

              -- outputs:
                 signal fifocount_inc : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
              );
end entity cpu_nios2_oci_fifocount_inc;


architecture europa of cpu_nios2_oci_fifocount_inc is

begin

  process (empty, free2, free3, tm_count)
  begin
      if std_logic'(empty) = '1' then 
        fifocount_inc <= std_logic_vector'("000") & (tm_count(1 DOWNTO 0));
      elsif std_logic'((free3 AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (tm_count)) = std_logic_vector'("00000000000000000000000000000011")))))) = '1' then 
        fifocount_inc <= std_logic_vector'("00010");
      elsif std_logic'((free2 AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (tm_count))>=std_logic_vector'("00000000000000000000000000000010")))))) = '1' then 
        fifocount_inc <= std_logic_vector'("00001");
      elsif (std_logic_vector'("000000000000000000000000000000") & (tm_count))>=std_logic_vector'("00000000000000000000000000000001") then 
        fifocount_inc <= std_logic_vector'("00000");
      else
        fifocount_inc <= A_REP(std_logic'('1'), 5);
      end if;

  end process;


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

entity cpu_nios2_oci_fifo is 
        port (
              -- inputs:
                 signal atm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal dbrk_traceme : IN STD_LOGIC;
                 signal dbrk_traceoff : IN STD_LOGIC;
                 signal dbrk_traceon : IN STD_LOGIC;
                 signal dct_buffer : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
                 signal dct_count : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal dtm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal itm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal test_ending : IN STD_LOGIC;
                 signal test_has_ended : IN STD_LOGIC;
                 signal trc_on : IN STD_LOGIC;

              -- outputs:
                 signal tw : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
              );
end entity cpu_nios2_oci_fifo;


architecture europa of cpu_nios2_oci_fifo is
component cpu_nios2_oci_compute_tm_count is 
           port (
                 -- inputs:
                    signal atm_valid : IN STD_LOGIC;
                    signal dtm_valid : IN STD_LOGIC;
                    signal itm_valid : IN STD_LOGIC;

                 -- outputs:
                    signal compute_tm_count : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
                 );
end component cpu_nios2_oci_compute_tm_count;

component cpu_nios2_oci_fifowp_inc is 
           port (
                 -- inputs:
                    signal free2 : IN STD_LOGIC;
                    signal free3 : IN STD_LOGIC;
                    signal tm_count : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

                 -- outputs:
                    signal fifowp_inc : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                 );
end component cpu_nios2_oci_fifowp_inc;

component cpu_nios2_oci_fifocount_inc is 
           port (
                 -- inputs:
                    signal empty : IN STD_LOGIC;
                    signal free2 : IN STD_LOGIC;
                    signal free3 : IN STD_LOGIC;
                    signal tm_count : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

                 -- outputs:
                    signal fifocount_inc : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
                 );
end component cpu_nios2_oci_fifocount_inc;

component cpu_oci_test_bench is 
           port (
                 -- inputs:
                    signal dct_buffer : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
                    signal dct_count : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal test_ending : IN STD_LOGIC;
                    signal test_has_ended : IN STD_LOGIC
                 );
end component cpu_oci_test_bench;

                signal atm_valid :  STD_LOGIC;
                signal compute_tm_count_tm_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal dtm_valid :  STD_LOGIC;
                signal empty :  STD_LOGIC;
                signal fifo_0 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_0_enable :  STD_LOGIC;
                signal fifo_0_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_1 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_10 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_10_enable :  STD_LOGIC;
                signal fifo_10_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_11 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_11_enable :  STD_LOGIC;
                signal fifo_11_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_12 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_12_enable :  STD_LOGIC;
                signal fifo_12_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_13 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_13_enable :  STD_LOGIC;
                signal fifo_13_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_14 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_14_enable :  STD_LOGIC;
                signal fifo_14_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_15 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_15_enable :  STD_LOGIC;
                signal fifo_15_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_1_enable :  STD_LOGIC;
                signal fifo_1_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_2 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_2_enable :  STD_LOGIC;
                signal fifo_2_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_3 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_3_enable :  STD_LOGIC;
                signal fifo_3_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_4 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_4_enable :  STD_LOGIC;
                signal fifo_4_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_5 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_5_enable :  STD_LOGIC;
                signal fifo_5_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_6 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_6_enable :  STD_LOGIC;
                signal fifo_6_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_7 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_7_enable :  STD_LOGIC;
                signal fifo_7_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_8 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_8_enable :  STD_LOGIC;
                signal fifo_8_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_9 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_9_enable :  STD_LOGIC;
                signal fifo_9_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifo_read_mux :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fifocount :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal fifocount_inc_fifocount :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal fifohead :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal fiforp :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal fifowp :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal fifowp1 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal fifowp2 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal fifowp_inc_fifowp :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal free2 :  STD_LOGIC;
                signal free3 :  STD_LOGIC;
                signal itm_valid :  STD_LOGIC;
                signal ovf_pending :  STD_LOGIC;
                signal ovr_pending_atm :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal ovr_pending_dtm :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal tm_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal tm_count_ge1 :  STD_LOGIC;
                signal tm_count_ge2 :  STD_LOGIC;
                signal tm_count_ge3 :  STD_LOGIC;
                signal trc_this :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of fifocount : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of fiforp : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of fifowp : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of ovf_pending : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  trc_this <= (trc_on OR ((dbrk_traceon AND NOT dbrk_traceoff))) OR dbrk_traceme;
  itm_valid <= or_reduce(itm(35 DOWNTO 32));
  atm_valid <= or_reduce(atm(35 DOWNTO 32)) AND trc_this;
  dtm_valid <= or_reduce(dtm(35 DOWNTO 32)) AND trc_this;
  free2 <= NOT fifocount(4);
  free3 <= NOT fifocount(4) AND nand_reduce(fifocount(3 DOWNTO 0));
  empty <= NOT or_reduce(fifocount);
  fifowp1 <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (fifowp)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  fifowp2 <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (fifowp)) + std_logic_vector'("000000000000000000000000000000010")), 4);
  --cpu_nios2_oci_compute_tm_count_tm_count, which is an e_instance
  cpu_nios2_oci_compute_tm_count_tm_count : cpu_nios2_oci_compute_tm_count
    port map(
      compute_tm_count => compute_tm_count_tm_count,
      atm_valid => atm_valid,
      dtm_valid => dtm_valid,
      itm_valid => itm_valid
    );


  tm_count <= compute_tm_count_tm_count;
  --cpu_nios2_oci_fifowp_inc_fifowp, which is an e_instance
  cpu_nios2_oci_fifowp_inc_fifowp : cpu_nios2_oci_fifowp_inc
    port map(
      fifowp_inc => fifowp_inc_fifowp,
      free2 => free2,
      free3 => free3,
      tm_count => tm_count
    );


  --cpu_nios2_oci_fifocount_inc_fifocount, which is an e_instance
  cpu_nios2_oci_fifocount_inc_fifocount : cpu_nios2_oci_fifocount_inc
    port map(
      fifocount_inc => fifocount_inc_fifocount,
      empty => empty,
      free2 => free2,
      free3 => free3,
      tm_count => tm_count
    );


  --the_cpu_oci_test_bench, which is an e_instance
  the_cpu_oci_test_bench : cpu_oci_test_bench
    port map(
      dct_buffer => dct_buffer,
      dct_count => dct_count,
      test_ending => test_ending,
      test_has_ended => test_has_ended
    );


  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      fiforp <= std_logic_vector'("0000");
      fifowp <= std_logic_vector'("0000");
      fifocount <= std_logic_vector'("00000");
      ovf_pending <= std_logic'('1');
    elsif clk'event and clk = '1' then
      fifowp <= A_EXT (((std_logic_vector'("0") & (fifowp)) + (std_logic_vector'("0") & (fifowp_inc_fifowp))), 4);
      fifocount <= A_EXT (((std_logic_vector'("0") & (fifocount)) + (std_logic_vector'("0") & (fifocount_inc_fifocount))), 5);
      if std_logic'(NOT empty) = '1' then 
        fiforp <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (fiforp)) + std_logic_vector'("000000000000000000000000000000001")), 4);
      end if;
      if std_logic'(((NOT trc_this OR ((NOT free2 AND tm_count(1)))) OR ((NOT free3 AND (and_reduce(tm_count)))))) = '1' then 
        ovf_pending <= std_logic'('1');
      elsif std_logic'((atm_valid OR dtm_valid)) = '1' then 
        ovf_pending <= std_logic'('0');
      end if;
    end if;

  end process;

  fifohead <= fifo_read_mux;
  tw <= A_WE_StdLogicVector(((std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000")), ((A_WE_StdLogicVector((std_logic'(empty) = '1'), std_logic_vector'("0000"), fifohead(35 DOWNTO 32))) & fifohead(31 DOWNTO 0)), itm);
  fifo_0_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0000")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0000"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0000"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_0 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_0_enable) = '1' then 
        fifo_0 <= fifo_0_mux;
      end if;
    end if;

  end process;

  fifo_0_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0000")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0000")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0000")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0000")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0000")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0000")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_1_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0001")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0001"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0001"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_1 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_1_enable) = '1' then 
        fifo_1 <= fifo_1_mux;
      end if;
    end if;

  end process;

  fifo_1_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0001")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0001")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0001")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0001")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0001")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0001")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_2_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0010")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0010"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0010"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_2 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_2_enable) = '1' then 
        fifo_2 <= fifo_2_mux;
      end if;
    end if;

  end process;

  fifo_2_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0010")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0010")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0010")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0010")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0010")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0010")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_3_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0011")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0011"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0011"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_3 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_3_enable) = '1' then 
        fifo_3 <= fifo_3_mux;
      end if;
    end if;

  end process;

  fifo_3_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0011")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0011")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0011")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0011")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0011")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0011")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_4_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0100")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0100"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0100"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_4 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_4_enable) = '1' then 
        fifo_4 <= fifo_4_mux;
      end if;
    end if;

  end process;

  fifo_4_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0100")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0100")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0100")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0100")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0100")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0100")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_5_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0101")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0101"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0101"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_5 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_5_enable) = '1' then 
        fifo_5 <= fifo_5_mux;
      end if;
    end if;

  end process;

  fifo_5_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0101")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0101")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0101")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0101")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0101")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0101")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_6_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0110")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0110"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0110"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_6 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_6_enable) = '1' then 
        fifo_6 <= fifo_6_mux;
      end if;
    end if;

  end process;

  fifo_6_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0110")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0110")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0110")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0110")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0110")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0110")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_7_enable <= (((to_std_logic(((fifowp = std_logic_vector'("0111")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("0111"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("0111"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_7 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_7_enable) = '1' then 
        fifo_7 <= fifo_7_mux;
      end if;
    end if;

  end process;

  fifo_7_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0111")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0111")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("0111")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0111")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0111")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("0111")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_8_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1000")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1000"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1000"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_8 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_8_enable) = '1' then 
        fifo_8 <= fifo_8_mux;
      end if;
    end if;

  end process;

  fifo_8_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1000")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1000")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1000")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1000")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1000")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1000")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_9_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1001")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1001"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1001"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_9 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_9_enable) = '1' then 
        fifo_9 <= fifo_9_mux;
      end if;
    end if;

  end process;

  fifo_9_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1001")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1001")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1001")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1001")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1001")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1001")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_10_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1010")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1010"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1010"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_10 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_10_enable) = '1' then 
        fifo_10 <= fifo_10_mux;
      end if;
    end if;

  end process;

  fifo_10_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1010")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1010")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1010")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1010")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1010")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1010")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_11_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1011")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1011"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1011"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_11 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_11_enable) = '1' then 
        fifo_11 <= fifo_11_mux;
      end if;
    end if;

  end process;

  fifo_11_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1011")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1011")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1011")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1011")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1011")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1011")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_12_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1100")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1100"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1100"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_12 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_12_enable) = '1' then 
        fifo_12 <= fifo_12_mux;
      end if;
    end if;

  end process;

  fifo_12_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1100")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1100")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1100")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1100")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1100")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1100")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_13_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1101")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1101"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1101"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_13 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_13_enable) = '1' then 
        fifo_13 <= fifo_13_mux;
      end if;
    end if;

  end process;

  fifo_13_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1101")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1101")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1101")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1101")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1101")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1101")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_14_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1110")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1110"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1110"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_14 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_14_enable) = '1' then 
        fifo_14 <= fifo_14_mux;
      end if;
    end if;

  end process;

  fifo_14_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1110")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1110")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1110")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1110")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1110")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1110")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  fifo_15_enable <= (((to_std_logic(((fifowp = std_logic_vector'("1111")))) AND tm_count_ge1)) OR (((free2 AND to_std_logic(((fifowp1 = std_logic_vector'("1111"))))) AND tm_count_ge2))) OR (((free3 AND to_std_logic(((fifowp2 = std_logic_vector'("1111"))))) AND tm_count_ge3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_15 <= std_logic_vector'("000000000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(fifo_15_enable) = '1' then 
        fifo_15 <= fifo_15_mux;
      end if;
    end if;

  end process;

  fifo_15_mux <= A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1111")))) AND itm_valid))) = '1'), itm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1111")))) AND atm_valid))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp = std_logic_vector'("1111")))) AND dtm_valid))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1111")))) AND (((free2 AND itm_valid) AND atm_valid))))) = '1'), ovr_pending_atm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1111")))) AND (((free2 AND itm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, A_WE_StdLogicVector((std_logic'(((to_std_logic(((fifowp1 = std_logic_vector'("1111")))) AND (((free2 AND atm_valid) AND dtm_valid))))) = '1'), ovr_pending_dtm, ovr_pending_dtm))))));
  tm_count_ge1 <= or_reduce(tm_count);
  tm_count_ge2 <= tm_count(1);
  tm_count_ge3 <= and_reduce(tm_count);
  ovr_pending_atm <= Std_Logic_Vector'(A_ToStdLogicVector(ovf_pending) & atm(34 DOWNTO 0));
  ovr_pending_dtm <= Std_Logic_Vector'(A_ToStdLogicVector(ovf_pending) & dtm(34 DOWNTO 0));
  fifo_read_mux <= A_WE_StdLogicVector(((fiforp = std_logic_vector'("0000"))), fifo_0, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0001"))), fifo_1, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0010"))), fifo_2, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0011"))), fifo_3, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0100"))), fifo_4, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0101"))), fifo_5, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0110"))), fifo_6, A_WE_StdLogicVector(((fiforp = std_logic_vector'("0111"))), fifo_7, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1000"))), fifo_8, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1001"))), fifo_9, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1010"))), fifo_10, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1011"))), fifo_11, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1100"))), fifo_12, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1101"))), fifo_13, A_WE_StdLogicVector(((fiforp = std_logic_vector'("1110"))), fifo_14, fifo_15)))))))))))))));

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

entity cpu_nios2_oci_pib is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal clkx2 : IN STD_LOGIC;
                 signal jrst_n : IN STD_LOGIC;
                 signal tw : IN STD_LOGIC_VECTOR (35 DOWNTO 0);

              -- outputs:
                 signal tr_clk : OUT STD_LOGIC;
                 signal tr_data : OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
              );
end entity cpu_nios2_oci_pib;


architecture europa of cpu_nios2_oci_pib is
                signal phase :  STD_LOGIC;
                signal tr_clk_reg :  STD_LOGIC;
                signal tr_data_reg :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal x1 :  STD_LOGIC;
                signal x2 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of tr_clk_reg : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of tr_data_reg : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of x1 : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of x2 : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  phase <= x1 XOR x2;
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      x1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      x1 <= NOT x1;
    end if;

  end process;

  process (clkx2, jrst_n)
  begin
    if jrst_n = '0' then
      x2 <= std_logic'('0');
      tr_clk_reg <= std_logic'('0');
      tr_data_reg <= std_logic_vector'("000000000000000000");
    elsif clkx2'event and clkx2 = '1' then
      x2 <= x1;
      tr_clk_reg <= NOT phase;
      tr_data_reg <= A_WE_StdLogicVector((std_logic'(phase) = '1'), tw(17 DOWNTO 0), tw(35 DOWNTO 18));
    end if;

  end process;

  tr_clk <= Vector_To_Std_Logic(A_WE_StdLogicVector(((std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000")), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(tr_clk_reg))), std_logic_vector'("00000000000000000000000000000000")));
  tr_data <= A_EXT (A_WE_StdLogicVector(((std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000")), (std_logic_vector'("00000000000000") & (tr_data_reg)), std_logic_vector'("00000000000000000000000000000000")), 18);

end europa;



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

entity cpu_traceram_lpm_dram_bdp_component_module is 
        generic (
                 lpm_file : STRING := "UNUSED"
                 );
        port (
              -- inputs:
                 signal address_a : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal address_b : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal clock0 : IN STD_LOGIC;
                 signal clock1 : IN STD_LOGIC;
                 signal clocken0 : IN STD_LOGIC;
                 signal clocken1 : IN STD_LOGIC;
                 signal data_a : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal data_b : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal wren_a : IN STD_LOGIC;
                 signal wren_b : IN STD_LOGIC;

              -- outputs:
                 signal q_a : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal q_b : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
              );
end entity cpu_traceram_lpm_dram_bdp_component_module;


architecture europa of cpu_traceram_lpm_dram_bdp_component_module is
  component altsyncram is
GENERIC (
      address_aclr_a : STRING;
        address_aclr_b : STRING;
        address_reg_b : STRING;
        indata_aclr_a : STRING;
        indata_aclr_b : STRING;
        init_file : STRING;
        intended_device_family : STRING;
        lpm_type : STRING;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_aclr_a : STRING;
        outdata_aclr_b : STRING;
        outdata_reg_a : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL;
        wrcontrol_aclr_a : STRING;
        wrcontrol_aclr_b : STRING
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        signal q_a : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal data_b : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
        signal clock0 : IN STD_LOGIC;
        signal clocken0 : IN STD_LOGIC;
        signal clocken1 : IN STD_LOGIC;
        signal clock1 : IN STD_LOGIC;
        signal wren_b : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (35 DOWNTO 0)
      );
  end component altsyncram;
                signal internal_q_a1 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal internal_q_b1 :  STD_LOGIC_VECTOR (35 DOWNTO 0);

begin

  the_altsyncram : altsyncram
    generic map(
      address_aclr_a => "NONE",
      address_aclr_b => "NONE",
      address_reg_b => "CLOCK1",
      indata_aclr_a => "NONE",
      indata_aclr_b => "NONE",
      init_file => lpm_file,
      intended_device_family => "STRATIXII",
      lpm_type => "altsyncram",
      numwords_a => 128,
      numwords_b => 128,
      operation_mode => "BIDIR_DUAL_PORT",
      outdata_aclr_a => "NONE",
      outdata_aclr_b => "NONE",
      outdata_reg_a => "UNREGISTERED",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 36,
      width_b => 36,
      widthad_a => 7,
      widthad_b => 7,
      wrcontrol_aclr_a => "NONE",
      wrcontrol_aclr_b => "NONE"
    )
    port map(
            address_a => address_a,
            address_b => address_b,
            clock0 => clock0,
            clock1 => clock1,
            clocken0 => clocken0,
            clocken1 => clocken1,
            data_a => data_a,
            data_b => data_b,
            q_a => internal_q_a1,
            q_b => internal_q_b1,
            wren_a => wren_a,
            wren_b => wren_b
    );

  --vhdl renameroo for output signals
  q_a <= internal_q_a1;
  --vhdl renameroo for output signals
  q_b <= internal_q_b1;

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

entity cpu_nios2_oci_im is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                 signal jrst_n : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal take_action_tracectrl : IN STD_LOGIC;
                 signal take_action_tracemem_a : IN STD_LOGIC;
                 signal take_action_tracemem_b : IN STD_LOGIC;
                 signal take_no_action_tracemem_a : IN STD_LOGIC;
                 signal trc_ctrl : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal tw : IN STD_LOGIC_VECTOR (35 DOWNTO 0);

              -- outputs:
                 signal tracemem_on : OUT STD_LOGIC;
                 signal tracemem_trcdata : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal tracemem_tw : OUT STD_LOGIC;
                 signal trc_enb : OUT STD_LOGIC;
                 signal trc_im_addr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal trc_wrap : OUT STD_LOGIC;
                 signal xbrk_wrap_traceoff : OUT STD_LOGIC
              );
end entity cpu_nios2_oci_im;


architecture europa of cpu_nios2_oci_im is
component cpu_traceram_lpm_dram_bdp_component_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal address_a : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal address_b : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal clock0 : IN STD_LOGIC;
                    signal clock1 : IN STD_LOGIC;
                    signal clocken0 : IN STD_LOGIC;
                    signal clocken1 : IN STD_LOGIC;
                    signal data_a : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal data_b : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal wren_a : IN STD_LOGIC;
                    signal wren_b : IN STD_LOGIC;

                 -- outputs:
                    signal q_a : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal q_b : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
                 );
end component cpu_traceram_lpm_dram_bdp_component_module;

                signal internal_trc_enb :  STD_LOGIC;
                signal internal_trc_im_addr :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal internal_trc_wrap :  STD_LOGIC;
                signal module_input16 :  STD_LOGIC;
                signal module_input17 :  STD_LOGIC;
                signal module_input18 :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal module_input19 :  STD_LOGIC;
                signal trc_im_data :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal trc_jtag_addr :  STD_LOGIC_VECTOR (16 DOWNTO 0);
                signal trc_jtag_data :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal trc_on_chip :  STD_LOGIC;
                signal tw_valid :  STD_LOGIC;
                signal unused_bdpram_port_q_a :  STD_LOGIC_VECTOR (35 DOWNTO 0);
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of trc_im_addr : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";
attribute ALTERA_ATTRIBUTE of trc_jtag_addr : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of trc_wrap : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";
  constant cpu_traceram_lpm_dram_bdp_component_lpm_file : string := "";

begin

  trc_im_data <= tw;
  process (clk, jrst_n)
  begin
    if jrst_n = '0' then
      internal_trc_im_addr <= std_logic_vector'("0000000");
      internal_trc_wrap <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(NOT(or_reduce(std_logic_vector'("00000000000000000000000000000001")))) = '1' then 
        internal_trc_im_addr <= std_logic_vector'("0000000");
        internal_trc_wrap <= std_logic'('0');
      elsif std_logic'((take_action_tracectrl AND ((jdo(4) OR jdo(3))))) = '1' then 
        if std_logic'(jdo(4)) = '1' then 
          internal_trc_im_addr <= std_logic_vector'("0000000");
        end if;
        if std_logic'(jdo(3)) = '1' then 
          internal_trc_wrap <= std_logic'('0');
        end if;
      elsif std_logic'(((internal_trc_enb AND trc_on_chip) AND tw_valid)) = '1' then 
        internal_trc_im_addr <= A_EXT (((std_logic_vector'("00000000000000000000000000") & (internal_trc_im_addr)) + std_logic_vector'("000000000000000000000000000000001")), 7);
        if std_logic'(and_reduce(internal_trc_im_addr)) = '1' then 
          internal_trc_wrap <= std_logic'('1');
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      trc_jtag_addr <= std_logic_vector'("00000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((take_action_tracemem_a OR take_no_action_tracemem_a) OR take_action_tracemem_b)) = '1' then 
        trc_jtag_addr <= A_EXT (A_WE_StdLogicVector((std_logic'(take_action_tracemem_a) = '1'), (std_logic_vector'("0000000000000000") & (jdo(35 DOWNTO 19))), ((std_logic_vector'("0000000000000000") & (trc_jtag_addr)) + std_logic_vector'("000000000000000000000000000000001"))), 17);
      end if;
    end if;

  end process;

  internal_trc_enb <= trc_ctrl(0);
  trc_on_chip <= NOT trc_ctrl(8);
  tw_valid <= or_reduce(trc_im_data(35 DOWNTO 32));
  xbrk_wrap_traceoff <= trc_ctrl(10) AND internal_trc_wrap;
  tracemem_trcdata <= A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000001"))) /= std_logic_vector'("00000000000000000000000000000000")), trc_jtag_data, std_logic_vector'("000000000000000000000000000000000000"));
  tracemem_tw <= internal_trc_wrap;
  tracemem_on <= internal_trc_enb;
  --cpu_traceram_lpm_dram_bdp_component, which is an nios_tdp_ram
  cpu_traceram_lpm_dram_bdp_component : cpu_traceram_lpm_dram_bdp_component_module
    generic map(
      lpm_file => cpu_traceram_lpm_dram_bdp_component_lpm_file
    )
    port map(
      q_a => unused_bdpram_port_q_a,
      q_b => trc_jtag_data,
      address_a => internal_trc_im_addr,
      address_b => trc_jtag_addr (6 DOWNTO 0),
      clock0 => clk,
      clock1 => clk,
      clocken0 => module_input16,
      clocken1 => module_input17,
      data_a => trc_im_data,
      data_b => module_input18,
      wren_a => module_input19,
      wren_b => take_action_tracemem_b
    );

  module_input16 <= std_logic'('1');
  module_input17 <= std_logic'('1');
  module_input18 <= jdo(36 DOWNTO 1);
  module_input19 <= tw_valid AND internal_trc_enb;

  --vhdl renameroo for output signals
  trc_enb <= internal_trc_enb;
  --vhdl renameroo for output signals
  trc_im_addr <= internal_trc_im_addr;
  --vhdl renameroo for output signals
  trc_wrap <= internal_trc_wrap;

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

entity cpu_nios2_performance_monitors is 
end entity cpu_nios2_performance_monitors;


architecture europa of cpu_nios2_performance_monitors is

begin


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

entity cpu_nios2_oci is 
        port (
              -- inputs:
                 signal A_cmp_result : IN STD_LOGIC;
                 signal A_ctrl_exception : IN STD_LOGIC;
                 signal A_ctrl_ld : IN STD_LOGIC;
                 signal A_ctrl_st : IN STD_LOGIC;
                 signal A_en : IN STD_LOGIC;
                 signal A_mem_baddr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal A_op_beq : IN STD_LOGIC;
                 signal A_op_bge : IN STD_LOGIC;
                 signal A_op_bgeu : IN STD_LOGIC;
                 signal A_op_blt : IN STD_LOGIC;
                 signal A_op_bltu : IN STD_LOGIC;
                 signal A_op_bne : IN STD_LOGIC;
                 signal A_op_br : IN STD_LOGIC;
                 signal A_op_bret : IN STD_LOGIC;
                 signal A_op_call : IN STD_LOGIC;
                 signal A_op_callr : IN STD_LOGIC;
                 signal A_op_eret : IN STD_LOGIC;
                 signal A_op_jmp : IN STD_LOGIC;
                 signal A_op_jmpi : IN STD_LOGIC;
                 signal A_op_ret : IN STD_LOGIC;
                 signal A_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_valid : IN STD_LOGIC;
                 signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal D_en : IN STD_LOGIC;
                 signal E_en : IN STD_LOGIC;
                 signal E_valid : IN STD_LOGIC;
                 signal F_pc : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal M_en : IN STD_LOGIC;
                 signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal begintransfer : IN STD_LOGIC;
                 signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal debugaccess : IN STD_LOGIC;
                 signal hbreak_enabled : IN STD_LOGIC;
                 signal reset : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal test_ending : IN STD_LOGIC;
                 signal test_has_ended : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                 signal oci_hbreak_req : OUT STD_LOGIC;
                 signal oci_ienable : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal oci_single_step_mode : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal resetrequest : OUT STD_LOGIC;
                 signal tr_clk : OUT STD_LOGIC;
                 signal tr_data : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal trigout : OUT STD_LOGIC
              );
end entity cpu_nios2_oci;


architecture europa of cpu_nios2_oci is
component cpu_nios2_oci_debug is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal dbrk_break : IN STD_LOGIC;
                    signal debugreq : IN STD_LOGIC;
                    signal hbreak_enabled : IN STD_LOGIC;
                    signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal ocireg_ers : IN STD_LOGIC;
                    signal ocireg_mrs : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal st_ready_test_idle : IN STD_LOGIC;
                    signal take_action_ocimem_a : IN STD_LOGIC;
                    signal take_action_ocireg : IN STD_LOGIC;
                    signal xbrk_break : IN STD_LOGIC;

                 -- outputs:
                    signal debugack : OUT STD_LOGIC;
                    signal monitor_error : OUT STD_LOGIC;
                    signal monitor_go : OUT STD_LOGIC;
                    signal monitor_ready : OUT STD_LOGIC;
                    signal oci_hbreak_req : OUT STD_LOGIC;
                    signal resetlatch : OUT STD_LOGIC;
                    signal resetrequest : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_debug;

component cpu_nios2_ocimem is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal debugaccess : IN STD_LOGIC;
                    signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal resetrequest : IN STD_LOGIC;
                    signal take_action_ocimem_a : IN STD_LOGIC;
                    signal take_action_ocimem_b : IN STD_LOGIC;
                    signal take_no_action_ocimem_a : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal MonDReg : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal oci_ram_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_nios2_ocimem;

component cpu_nios2_avalon_reg is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal debugaccess : IN STD_LOGIC;
                    signal monitor_error : IN STD_LOGIC;
                    signal monitor_go : IN STD_LOGIC;
                    signal monitor_ready : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal oci_ienable : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal oci_reg_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal oci_single_step_mode : OUT STD_LOGIC;
                    signal ocireg_ers : OUT STD_LOGIC;
                    signal ocireg_mrs : OUT STD_LOGIC;
                    signal take_action_ocireg : OUT STD_LOGIC
                 );
end component cpu_nios2_avalon_reg;

component cpu_nios2_oci_break is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal dbrk_break : IN STD_LOGIC;
                    signal dbrk_goto0 : IN STD_LOGIC;
                    signal dbrk_goto1 : IN STD_LOGIC;
                    signal dbrk_hit0 : IN STD_LOGIC;
                    signal dbrk_hit1 : IN STD_LOGIC;
                    signal dbrk_hit2 : IN STD_LOGIC;
                    signal dbrk_hit3 : IN STD_LOGIC;
                    signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal take_action_break_a : IN STD_LOGIC;
                    signal take_action_break_b : IN STD_LOGIC;
                    signal take_action_break_c : IN STD_LOGIC;
                    signal take_no_action_break_a : IN STD_LOGIC;
                    signal take_no_action_break_b : IN STD_LOGIC;
                    signal take_no_action_break_c : IN STD_LOGIC;
                    signal xbrk_goto0 : IN STD_LOGIC;
                    signal xbrk_goto1 : IN STD_LOGIC;

                 -- outputs:
                    signal break_readreg : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal dbrk0 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk1 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk2 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk3 : OUT STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk_hit0_latch : OUT STD_LOGIC;
                    signal dbrk_hit1_latch : OUT STD_LOGIC;
                    signal dbrk_hit2_latch : OUT STD_LOGIC;
                    signal dbrk_hit3_latch : OUT STD_LOGIC;
                    signal trigbrktype : OUT STD_LOGIC;
                    signal trigger_state_0 : OUT STD_LOGIC;
                    signal trigger_state_1 : OUT STD_LOGIC;
                    signal xbrk0 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk1 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk2 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk3 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk_ctrl0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component cpu_nios2_oci_break;

component cpu_nios2_oci_xbrk is 
           port (
                 -- inputs:
                    signal D_en : IN STD_LOGIC;
                    signal E_en : IN STD_LOGIC;
                    signal E_valid : IN STD_LOGIC;
                    signal F_pc : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal M_en : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal trigger_state_0 : IN STD_LOGIC;
                    signal trigger_state_1 : IN STD_LOGIC;
                    signal xbrk0 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk1 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk2 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk3 : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal xbrk_ctrl0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal xbrk_ctrl3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- outputs:
                    signal xbrk_break : OUT STD_LOGIC;
                    signal xbrk_goto0 : OUT STD_LOGIC;
                    signal xbrk_goto1 : OUT STD_LOGIC;
                    signal xbrk_traceoff : OUT STD_LOGIC;
                    signal xbrk_traceon : OUT STD_LOGIC;
                    signal xbrk_trigout : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_xbrk;

component cpu_nios2_oci_dbrk is 
           port (
                 -- inputs:
                    signal A_ctrl_ld : IN STD_LOGIC;
                    signal A_ctrl_st : IN STD_LOGIC;
                    signal A_en : IN STD_LOGIC;
                    signal A_mem_baddr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_valid : IN STD_LOGIC;
                    signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal dbrk0 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk1 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk2 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal dbrk3 : IN STD_LOGIC_VECTOR (77 DOWNTO 0);
                    signal debugack : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal trigger_state_0 : IN STD_LOGIC;
                    signal trigger_state_1 : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_d_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal cpu_d_read : OUT STD_LOGIC;
                    signal cpu_d_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_d_wait : OUT STD_LOGIC;
                    signal cpu_d_write : OUT STD_LOGIC;
                    signal cpu_d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal dbrk_break : OUT STD_LOGIC;
                    signal dbrk_goto0 : OUT STD_LOGIC;
                    signal dbrk_goto1 : OUT STD_LOGIC;
                    signal dbrk_hit0 : OUT STD_LOGIC;
                    signal dbrk_hit1 : OUT STD_LOGIC;
                    signal dbrk_hit2 : OUT STD_LOGIC;
                    signal dbrk_hit3 : OUT STD_LOGIC;
                    signal dbrk_traceme : OUT STD_LOGIC;
                    signal dbrk_traceoff : OUT STD_LOGIC;
                    signal dbrk_traceon : OUT STD_LOGIC;
                    signal dbrk_trigout : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_dbrk;

component cpu_nios2_oci_itrace is 
           port (
                 -- inputs:
                    signal A_cmp_result : IN STD_LOGIC;
                    signal A_ctrl_exception : IN STD_LOGIC;
                    signal A_en : IN STD_LOGIC;
                    signal A_op_beq : IN STD_LOGIC;
                    signal A_op_bge : IN STD_LOGIC;
                    signal A_op_bgeu : IN STD_LOGIC;
                    signal A_op_blt : IN STD_LOGIC;
                    signal A_op_bltu : IN STD_LOGIC;
                    signal A_op_bne : IN STD_LOGIC;
                    signal A_op_br : IN STD_LOGIC;
                    signal A_op_bret : IN STD_LOGIC;
                    signal A_op_call : IN STD_LOGIC;
                    signal A_op_callr : IN STD_LOGIC;
                    signal A_op_eret : IN STD_LOGIC;
                    signal A_op_jmp : IN STD_LOGIC;
                    signal A_op_jmpi : IN STD_LOGIC;
                    signal A_op_ret : IN STD_LOGIC;
                    signal A_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal A_valid : IN STD_LOGIC;
                    signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal dbrk_traceoff : IN STD_LOGIC;
                    signal dbrk_traceon : IN STD_LOGIC;
                    signal debugack : IN STD_LOGIC;
                    signal jdo : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal take_action_tracectrl : IN STD_LOGIC;
                    signal trc_enb : IN STD_LOGIC;
                    signal xbrk_traceoff : IN STD_LOGIC;
                    signal xbrk_traceon : IN STD_LOGIC;
                    signal xbrk_wrap_traceoff : IN STD_LOGIC;

                 -- outputs:
                    signal dct_buffer : OUT STD_LOGIC_VECTOR (29 DOWNTO 0);
                    signal dct_count : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal itm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal trc_ctrl : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal trc_on : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_itrace;

component cpu_nios2_oci_dtrace is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_d_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal cpu_d_read : IN STD_LOGIC;
                    signal cpu_d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_d_wait : IN STD_LOGIC;
                    signal cpu_d_write : IN STD_LOGIC;
                    signal cpu_d_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal trc_ctrl : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal atm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal dtm : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
                 );
end component cpu_nios2_oci_dtrace;

component cpu_nios2_oci_fifo is 
           port (
                 -- inputs:
                    signal atm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal dbrk_traceme : IN STD_LOGIC;
                    signal dbrk_traceoff : IN STD_LOGIC;
                    signal dbrk_traceon : IN STD_LOGIC;
                    signal dct_buffer : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
                    signal dct_count : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal dtm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal itm : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal test_ending : IN STD_LOGIC;
                    signal test_has_ended : IN STD_LOGIC;
                    signal trc_on : IN STD_LOGIC;

                 -- outputs:
                    signal tw : OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
                 );
end component cpu_nios2_oci_fifo;

component cpu_nios2_oci_pib is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal clkx2 : IN STD_LOGIC;
                    signal jrst_n : IN STD_LOGIC;
                    signal tw : IN STD_LOGIC_VECTOR (35 DOWNTO 0);

                 -- outputs:
                    signal tr_clk : OUT STD_LOGIC;
                    signal tr_data : OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
                 );
end component cpu_nios2_oci_pib;

component cpu_nios2_oci_im is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal jdo : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal jrst_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal take_action_tracectrl : IN STD_LOGIC;
                    signal take_action_tracemem_a : IN STD_LOGIC;
                    signal take_action_tracemem_b : IN STD_LOGIC;
                    signal take_no_action_tracemem_a : IN STD_LOGIC;
                    signal trc_ctrl : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal tw : IN STD_LOGIC_VECTOR (35 DOWNTO 0);

                 -- outputs:
                    signal tracemem_on : OUT STD_LOGIC;
                    signal tracemem_trcdata : OUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal tracemem_tw : OUT STD_LOGIC;
                    signal trc_enb : OUT STD_LOGIC;
                    signal trc_im_addr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal trc_wrap : OUT STD_LOGIC;
                    signal xbrk_wrap_traceoff : OUT STD_LOGIC
                 );
end component cpu_nios2_oci_im;

component cpu_nios2_performance_monitors is 
end component cpu_nios2_performance_monitors;

component cpu_jtag_debug_module_wrapper is 
           port (
                 -- inputs:
                    signal MonDReg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal break_readreg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal dbrk_hit0_latch : IN STD_LOGIC;
                    signal dbrk_hit1_latch : IN STD_LOGIC;
                    signal dbrk_hit2_latch : IN STD_LOGIC;
                    signal dbrk_hit3_latch : IN STD_LOGIC;
                    signal debugack : IN STD_LOGIC;
                    signal monitor_error : IN STD_LOGIC;
                    signal monitor_ready : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal resetlatch : IN STD_LOGIC;
                    signal tracemem_on : IN STD_LOGIC;
                    signal tracemem_trcdata : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal tracemem_tw : IN STD_LOGIC;
                    signal trc_im_addr : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal trc_on : IN STD_LOGIC;
                    signal trc_wrap : IN STD_LOGIC;
                    signal trigbrktype : IN STD_LOGIC;
                    signal trigger_state_1 : IN STD_LOGIC;

                 -- outputs:
                    signal jdo : OUT STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal jrst_n : OUT STD_LOGIC;
                    signal st_ready_test_idle : OUT STD_LOGIC;
                    signal take_action_break_a : OUT STD_LOGIC;
                    signal take_action_break_b : OUT STD_LOGIC;
                    signal take_action_break_c : OUT STD_LOGIC;
                    signal take_action_ocimem_a : OUT STD_LOGIC;
                    signal take_action_ocimem_b : OUT STD_LOGIC;
                    signal take_action_tracectrl : OUT STD_LOGIC;
                    signal take_action_tracemem_a : OUT STD_LOGIC;
                    signal take_action_tracemem_b : OUT STD_LOGIC;
                    signal take_no_action_break_a : OUT STD_LOGIC;
                    signal take_no_action_break_b : OUT STD_LOGIC;
                    signal take_no_action_break_c : OUT STD_LOGIC;
                    signal take_no_action_ocimem_a : OUT STD_LOGIC;
                    signal take_no_action_tracemem_a : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_wrapper;

--synthesis read_comments_as_HDL on
--component cpu_ext_trace_pll_module is 
--           port (
--                 
--                    signal clk : IN STD_LOGIC;
--                    signal reset_n : IN STD_LOGIC;
--
--                 
--                    signal clkx2 : OUT STD_LOGIC
--                 );
--end component cpu_ext_trace_pll_module;
--
--synthesis read_comments_as_HDL off
                signal MonDReg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal atm :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal break_readreg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal clkx2 :  STD_LOGIC;
                signal cpu_d_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal cpu_d_read :  STD_LOGIC;
                signal cpu_d_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_d_wait :  STD_LOGIC;
                signal cpu_d_write :  STD_LOGIC;
                signal cpu_d_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dbrk0 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal dbrk1 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal dbrk2 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal dbrk3 :  STD_LOGIC_VECTOR (77 DOWNTO 0);
                signal dbrk_break :  STD_LOGIC;
                signal dbrk_goto0 :  STD_LOGIC;
                signal dbrk_goto1 :  STD_LOGIC;
                signal dbrk_hit0 :  STD_LOGIC;
                signal dbrk_hit0_latch :  STD_LOGIC;
                signal dbrk_hit1 :  STD_LOGIC;
                signal dbrk_hit1_latch :  STD_LOGIC;
                signal dbrk_hit2 :  STD_LOGIC;
                signal dbrk_hit2_latch :  STD_LOGIC;
                signal dbrk_hit3 :  STD_LOGIC;
                signal dbrk_hit3_latch :  STD_LOGIC;
                signal dbrk_traceme :  STD_LOGIC;
                signal dbrk_traceoff :  STD_LOGIC;
                signal dbrk_traceon :  STD_LOGIC;
                signal dbrk_trigout :  STD_LOGIC;
                signal dct_buffer :  STD_LOGIC_VECTOR (29 DOWNTO 0);
                signal dct_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal debugack :  STD_LOGIC;
                signal debugreq :  STD_LOGIC;
                signal dtm :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal dummy_sink :  STD_LOGIC;
                signal internal_oci_hbreak_req :  STD_LOGIC;
                signal internal_oci_ienable :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_oci_single_step_mode :  STD_LOGIC;
                signal internal_resetrequest :  STD_LOGIC;
                signal internal_tr_clk :  STD_LOGIC;
                signal internal_tr_data :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal itm :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal jdo :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal jrst_n :  STD_LOGIC;
                signal monitor_error :  STD_LOGIC;
                signal monitor_go :  STD_LOGIC;
                signal monitor_ready :  STD_LOGIC;
                signal oci_ram_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal oci_reg_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ocireg_ers :  STD_LOGIC;
                signal ocireg_mrs :  STD_LOGIC;
                signal resetlatch :  STD_LOGIC;
                signal st_ready_test_idle :  STD_LOGIC;
                signal take_action_break_a :  STD_LOGIC;
                signal take_action_break_b :  STD_LOGIC;
                signal take_action_break_c :  STD_LOGIC;
                signal take_action_ocimem_a :  STD_LOGIC;
                signal take_action_ocimem_b :  STD_LOGIC;
                signal take_action_ocireg :  STD_LOGIC;
                signal take_action_tracectrl :  STD_LOGIC;
                signal take_action_tracemem_a :  STD_LOGIC;
                signal take_action_tracemem_b :  STD_LOGIC;
                signal take_no_action_break_a :  STD_LOGIC;
                signal take_no_action_break_b :  STD_LOGIC;
                signal take_no_action_break_c :  STD_LOGIC;
                signal take_no_action_ocimem_a :  STD_LOGIC;
                signal take_no_action_tracemem_a :  STD_LOGIC;
                signal tracemem_on :  STD_LOGIC;
                signal tracemem_trcdata :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal tracemem_tw :  STD_LOGIC;
                signal trc_ctrl :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal trc_enb :  STD_LOGIC;
                signal trc_im_addr :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal trc_on :  STD_LOGIC;
                signal trc_wrap :  STD_LOGIC;
                signal trigbrktype :  STD_LOGIC;
                signal trigger_state_0 :  STD_LOGIC;
                signal trigger_state_1 :  STD_LOGIC;
                signal tw :  STD_LOGIC_VECTOR (35 DOWNTO 0);
                signal xbrk0 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal xbrk1 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal xbrk2 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal xbrk3 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal xbrk_break :  STD_LOGIC;
                signal xbrk_ctrl0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal xbrk_ctrl1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal xbrk_ctrl2 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal xbrk_ctrl3 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal xbrk_goto0 :  STD_LOGIC;
                signal xbrk_goto1 :  STD_LOGIC;
                signal xbrk_traceoff :  STD_LOGIC;
                signal xbrk_traceon :  STD_LOGIC;
                signal xbrk_trigout :  STD_LOGIC;
                signal xbrk_wrap_traceoff :  STD_LOGIC;

begin

  --the_cpu_nios2_oci_debug, which is an e_instance
  the_cpu_nios2_oci_debug : cpu_nios2_oci_debug
    port map(
      debugack => debugack,
      monitor_error => monitor_error,
      monitor_go => monitor_go,
      monitor_ready => monitor_ready,
      oci_hbreak_req => internal_oci_hbreak_req,
      resetlatch => resetlatch,
      resetrequest => internal_resetrequest,
      clk => clk,
      dbrk_break => dbrk_break,
      debugreq => debugreq,
      hbreak_enabled => hbreak_enabled,
      jdo => jdo,
      jrst_n => jrst_n,
      ocireg_ers => ocireg_ers,
      ocireg_mrs => ocireg_mrs,
      reset => reset,
      st_ready_test_idle => st_ready_test_idle,
      take_action_ocimem_a => take_action_ocimem_a,
      take_action_ocireg => take_action_ocireg,
      xbrk_break => xbrk_break
    );


  --the_cpu_nios2_ocimem, which is an e_instance
  the_cpu_nios2_ocimem : cpu_nios2_ocimem
    port map(
      MonDReg => MonDReg,
      oci_ram_readdata => oci_ram_readdata,
      address => address,
      begintransfer => begintransfer,
      byteenable => byteenable,
      chipselect => chipselect,
      clk => clk,
      debugaccess => debugaccess,
      jdo => jdo,
      jrst_n => jrst_n,
      resetrequest => internal_resetrequest,
      take_action_ocimem_a => take_action_ocimem_a,
      take_action_ocimem_b => take_action_ocimem_b,
      take_no_action_ocimem_a => take_no_action_ocimem_a,
      write => write,
      writedata => writedata
    );


  --the_cpu_nios2_avalon_reg, which is an e_instance
  the_cpu_nios2_avalon_reg : cpu_nios2_avalon_reg
    port map(
      oci_ienable => internal_oci_ienable,
      oci_reg_readdata => oci_reg_readdata,
      oci_single_step_mode => internal_oci_single_step_mode,
      ocireg_ers => ocireg_ers,
      ocireg_mrs => ocireg_mrs,
      take_action_ocireg => take_action_ocireg,
      address => address,
      chipselect => chipselect,
      clk => clk,
      debugaccess => debugaccess,
      monitor_error => monitor_error,
      monitor_go => monitor_go,
      monitor_ready => monitor_ready,
      reset_n => reset_n,
      write => write,
      writedata => writedata
    );


  --the_cpu_nios2_oci_break, which is an e_instance
  the_cpu_nios2_oci_break : cpu_nios2_oci_break
    port map(
      break_readreg => break_readreg,
      dbrk0 => dbrk0,
      dbrk1 => dbrk1,
      dbrk2 => dbrk2,
      dbrk3 => dbrk3,
      dbrk_hit0_latch => dbrk_hit0_latch,
      dbrk_hit1_latch => dbrk_hit1_latch,
      dbrk_hit2_latch => dbrk_hit2_latch,
      dbrk_hit3_latch => dbrk_hit3_latch,
      trigbrktype => trigbrktype,
      trigger_state_0 => trigger_state_0,
      trigger_state_1 => trigger_state_1,
      xbrk0 => xbrk0,
      xbrk1 => xbrk1,
      xbrk2 => xbrk2,
      xbrk3 => xbrk3,
      xbrk_ctrl0 => xbrk_ctrl0,
      xbrk_ctrl1 => xbrk_ctrl1,
      xbrk_ctrl2 => xbrk_ctrl2,
      xbrk_ctrl3 => xbrk_ctrl3,
      clk => clk,
      dbrk_break => dbrk_break,
      dbrk_goto0 => dbrk_goto0,
      dbrk_goto1 => dbrk_goto1,
      dbrk_hit0 => dbrk_hit0,
      dbrk_hit1 => dbrk_hit1,
      dbrk_hit2 => dbrk_hit2,
      dbrk_hit3 => dbrk_hit3,
      jdo => jdo,
      jrst_n => jrst_n,
      reset_n => reset_n,
      take_action_break_a => take_action_break_a,
      take_action_break_b => take_action_break_b,
      take_action_break_c => take_action_break_c,
      take_no_action_break_a => take_no_action_break_a,
      take_no_action_break_b => take_no_action_break_b,
      take_no_action_break_c => take_no_action_break_c,
      xbrk_goto0 => xbrk_goto0,
      xbrk_goto1 => xbrk_goto1
    );


  --the_cpu_nios2_oci_xbrk, which is an e_instance
  the_cpu_nios2_oci_xbrk : cpu_nios2_oci_xbrk
    port map(
      xbrk_break => xbrk_break,
      xbrk_goto0 => xbrk_goto0,
      xbrk_goto1 => xbrk_goto1,
      xbrk_traceoff => xbrk_traceoff,
      xbrk_traceon => xbrk_traceon,
      xbrk_trigout => xbrk_trigout,
      D_en => D_en,
      E_en => E_en,
      E_valid => E_valid,
      F_pc => F_pc,
      M_en => M_en,
      clk => clk,
      reset_n => reset_n,
      trigger_state_0 => trigger_state_0,
      trigger_state_1 => trigger_state_1,
      xbrk0 => xbrk0,
      xbrk1 => xbrk1,
      xbrk2 => xbrk2,
      xbrk3 => xbrk3,
      xbrk_ctrl0 => xbrk_ctrl0,
      xbrk_ctrl1 => xbrk_ctrl1,
      xbrk_ctrl2 => xbrk_ctrl2,
      xbrk_ctrl3 => xbrk_ctrl3
    );


  --the_cpu_nios2_oci_dbrk, which is an e_instance
  the_cpu_nios2_oci_dbrk : cpu_nios2_oci_dbrk
    port map(
      cpu_d_address => cpu_d_address,
      cpu_d_read => cpu_d_read,
      cpu_d_readdata => cpu_d_readdata,
      cpu_d_wait => cpu_d_wait,
      cpu_d_write => cpu_d_write,
      cpu_d_writedata => cpu_d_writedata,
      dbrk_break => dbrk_break,
      dbrk_goto0 => dbrk_goto0,
      dbrk_goto1 => dbrk_goto1,
      dbrk_hit0 => dbrk_hit0,
      dbrk_hit1 => dbrk_hit1,
      dbrk_hit2 => dbrk_hit2,
      dbrk_hit3 => dbrk_hit3,
      dbrk_traceme => dbrk_traceme,
      dbrk_traceoff => dbrk_traceoff,
      dbrk_traceon => dbrk_traceon,
      dbrk_trigout => dbrk_trigout,
      A_ctrl_ld => A_ctrl_ld,
      A_ctrl_st => A_ctrl_st,
      A_en => A_en,
      A_mem_baddr => A_mem_baddr,
      A_st_data => A_st_data,
      A_valid => A_valid,
      A_wr_data_filtered => A_wr_data_filtered,
      clk => clk,
      dbrk0 => dbrk0,
      dbrk1 => dbrk1,
      dbrk2 => dbrk2,
      dbrk3 => dbrk3,
      debugack => debugack,
      reset_n => reset_n,
      trigger_state_0 => trigger_state_0,
      trigger_state_1 => trigger_state_1
    );


  --the_cpu_nios2_oci_itrace, which is an e_instance
  the_cpu_nios2_oci_itrace : cpu_nios2_oci_itrace
    port map(
      dct_buffer => dct_buffer,
      dct_count => dct_count,
      itm => itm,
      trc_ctrl => trc_ctrl,
      trc_on => trc_on,
      A_cmp_result => A_cmp_result,
      A_ctrl_exception => A_ctrl_exception,
      A_en => A_en,
      A_op_beq => A_op_beq,
      A_op_bge => A_op_bge,
      A_op_bgeu => A_op_bgeu,
      A_op_blt => A_op_blt,
      A_op_bltu => A_op_bltu,
      A_op_bne => A_op_bne,
      A_op_br => A_op_br,
      A_op_bret => A_op_bret,
      A_op_call => A_op_call,
      A_op_callr => A_op_callr,
      A_op_eret => A_op_eret,
      A_op_jmp => A_op_jmp,
      A_op_jmpi => A_op_jmpi,
      A_op_ret => A_op_ret,
      A_pcb => A_pcb,
      A_valid => A_valid,
      A_wr_data_filtered => A_wr_data_filtered,
      clk => clk,
      dbrk_traceoff => dbrk_traceoff,
      dbrk_traceon => dbrk_traceon,
      debugack => debugack,
      jdo => jdo (15 DOWNTO 0),
      jrst_n => jrst_n,
      reset_n => reset_n,
      take_action_tracectrl => take_action_tracectrl,
      trc_enb => trc_enb,
      xbrk_traceoff => xbrk_traceoff,
      xbrk_traceon => xbrk_traceon,
      xbrk_wrap_traceoff => xbrk_wrap_traceoff
    );


  --the_cpu_nios2_oci_dtrace, which is an e_instance
  the_cpu_nios2_oci_dtrace : cpu_nios2_oci_dtrace
    port map(
      atm => atm,
      dtm => dtm,
      clk => clk,
      cpu_d_address => cpu_d_address,
      cpu_d_read => cpu_d_read,
      cpu_d_readdata => cpu_d_readdata,
      cpu_d_wait => cpu_d_wait,
      cpu_d_write => cpu_d_write,
      cpu_d_writedata => cpu_d_writedata,
      jrst_n => jrst_n,
      trc_ctrl => trc_ctrl
    );


  --the_cpu_nios2_oci_fifo, which is an e_instance
  the_cpu_nios2_oci_fifo : cpu_nios2_oci_fifo
    port map(
      tw => tw,
      atm => atm,
      clk => clk,
      dbrk_traceme => dbrk_traceme,
      dbrk_traceoff => dbrk_traceoff,
      dbrk_traceon => dbrk_traceon,
      dct_buffer => dct_buffer,
      dct_count => dct_count,
      dtm => dtm,
      itm => itm,
      jrst_n => jrst_n,
      reset_n => reset_n,
      test_ending => test_ending,
      test_has_ended => test_has_ended,
      trc_on => trc_on
    );


  --the_cpu_nios2_oci_pib, which is an e_instance
  the_cpu_nios2_oci_pib : cpu_nios2_oci_pib
    port map(
      tr_clk => internal_tr_clk,
      tr_data => internal_tr_data,
      clk => clk,
      clkx2 => clkx2,
      jrst_n => jrst_n,
      tw => tw
    );


  --the_cpu_nios2_oci_im, which is an e_instance
  the_cpu_nios2_oci_im : cpu_nios2_oci_im
    port map(
      tracemem_on => tracemem_on,
      tracemem_trcdata => tracemem_trcdata,
      tracemem_tw => tracemem_tw,
      trc_enb => trc_enb,
      trc_im_addr => trc_im_addr,
      trc_wrap => trc_wrap,
      xbrk_wrap_traceoff => xbrk_wrap_traceoff,
      clk => clk,
      jdo => jdo,
      jrst_n => jrst_n,
      reset_n => reset_n,
      take_action_tracectrl => take_action_tracectrl,
      take_action_tracemem_a => take_action_tracemem_a,
      take_action_tracemem_b => take_action_tracemem_b,
      take_no_action_tracemem_a => take_no_action_tracemem_a,
      trc_ctrl => trc_ctrl,
      tw => tw
    );


  trigout <= dbrk_trigout OR xbrk_trigout;
  readdata <= A_WE_StdLogicVector((std_logic'(address(8)) = '1'), oci_reg_readdata, oci_ram_readdata);
  jtag_debug_module_debugaccess_to_roms <= debugack;
  --the_cpu_jtag_debug_module_wrapper, which is an e_instance
  the_cpu_jtag_debug_module_wrapper : cpu_jtag_debug_module_wrapper
    port map(
      jdo => jdo,
      jrst_n => jrst_n,
      st_ready_test_idle => st_ready_test_idle,
      take_action_break_a => take_action_break_a,
      take_action_break_b => take_action_break_b,
      take_action_break_c => take_action_break_c,
      take_action_ocimem_a => take_action_ocimem_a,
      take_action_ocimem_b => take_action_ocimem_b,
      take_action_tracectrl => take_action_tracectrl,
      take_action_tracemem_a => take_action_tracemem_a,
      take_action_tracemem_b => take_action_tracemem_b,
      take_no_action_break_a => take_no_action_break_a,
      take_no_action_break_b => take_no_action_break_b,
      take_no_action_break_c => take_no_action_break_c,
      take_no_action_ocimem_a => take_no_action_ocimem_a,
      take_no_action_tracemem_a => take_no_action_tracemem_a,
      MonDReg => MonDReg,
      break_readreg => break_readreg,
      clk => clk,
      dbrk_hit0_latch => dbrk_hit0_latch,
      dbrk_hit1_latch => dbrk_hit1_latch,
      dbrk_hit2_latch => dbrk_hit2_latch,
      dbrk_hit3_latch => dbrk_hit3_latch,
      debugack => debugack,
      monitor_error => monitor_error,
      monitor_ready => monitor_ready,
      reset_n => reset_n,
      resetlatch => resetlatch,
      tracemem_on => tracemem_on,
      tracemem_trcdata => tracemem_trcdata,
      tracemem_tw => tracemem_tw,
      trc_im_addr => trc_im_addr,
      trc_on => trc_on,
      trc_wrap => trc_wrap,
      trigbrktype => trigbrktype,
      trigger_state_1 => trigger_state_1
    );


  --dummy sink, which is an e_mux
  dummy_sink <= debugack;
  debugreq <= std_logic'('0');
  --vhdl renameroo for output signals
  oci_hbreak_req <= internal_oci_hbreak_req;
  --vhdl renameroo for output signals
  oci_ienable <= internal_oci_ienable;
  --vhdl renameroo for output signals
  oci_single_step_mode <= internal_oci_single_step_mode;
  --vhdl renameroo for output signals
  resetrequest <= internal_resetrequest;
  --vhdl renameroo for output signals
  tr_clk <= internal_tr_clk;
  --vhdl renameroo for output signals
  tr_data <= internal_tr_data;
--synthesis translate_off
    internal_tr_clk <= std_logic'('0');
    internal_tr_data <= std_logic_vector'("000000000000000000");
    trigout <= std_logic'('0');
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    
--    the_cpu_ext_trace_pll_module : cpu_ext_trace_pll_module
--      port map(
--        clkx2 => clkx2,
--        clk => clk,
--        reset_n => reset_n
--      );
--
--
--synthesis read_comments_as_HDL off

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

entity cpu is 
        port (
              -- inputs:
                 signal E_ci_combo_result : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d_readdatavalid : IN STD_LOGIC;
                 signal d_waitrequest : IN STD_LOGIC;
                 signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal i_readdatavalid : IN STD_LOGIC;
                 signal i_waitrequest : IN STD_LOGIC;
                 signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                 signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal jtag_debug_module_clk : IN STD_LOGIC;
                 signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                 signal jtag_debug_module_reset : IN STD_LOGIC;
                 signal jtag_debug_module_select : IN STD_LOGIC;
                 signal jtag_debug_module_write : IN STD_LOGIC;
                 signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal E_ci_combo_a : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal E_ci_combo_b : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal E_ci_combo_c : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal E_ci_combo_dataa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_ci_combo_datab : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_ci_combo_estatus : OUT STD_LOGIC;
                 signal E_ci_combo_ipending : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_ci_combo_n : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal E_ci_combo_readra : OUT STD_LOGIC;
                 signal E_ci_combo_readrb : OUT STD_LOGIC;
                 signal E_ci_combo_status : OUT STD_LOGIC;
                 signal E_ci_combo_writerc : OUT STD_LOGIC;
                 signal d_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal d_read : OUT STD_LOGIC;
                 signal d_write : OUT STD_LOGIC;
                 signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal i_address : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal i_read : OUT STD_LOGIC;
                 signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                 signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_debug_module_resetrequest : OUT STD_LOGIC;
                 signal jtag_debug_offchip_trace_clk : OUT STD_LOGIC;
                 signal jtag_debug_offchip_trace_data : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal jtag_debug_trigout : OUT STD_LOGIC
              );
end entity cpu;


architecture europa of cpu is
component cpu_test_bench is 
           port (
                 -- inputs:
                    signal A_bstatus_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_cmp_result : IN STD_LOGIC;
                    signal A_ctrl_exception : IN STD_LOGIC;
                    signal A_ctrl_ld_non_bypass : IN STD_LOGIC;
                    signal A_dst_regnum : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal A_en : IN STD_LOGIC;
                    signal A_estatus_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_ienable_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_ipending_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_iw : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_mem_byte_en : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal A_op_hbreak : IN STD_LOGIC;
                    signal A_op_intr : IN STD_LOGIC;
                    signal A_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_status_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_valid : IN STD_LOGIC;
                    signal A_wr_data_unfiltered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_wr_dst_reg : IN STD_LOGIC;
                    signal E_add_br_to_taken_history_unfiltered : IN STD_LOGIC;
                    signal E_logic_result : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal E_valid : IN STD_LOGIC;
                    signal M_bht_ptr_unfiltered : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal M_bht_wr_data_unfiltered : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal M_bht_wr_en_unfiltered : IN STD_LOGIC;
                    signal M_mem_baddr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal M_target_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal M_valid : IN STD_LOGIC;
                    signal W_dst_regnum : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal W_iw : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal W_iw_custom_n : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal W_iw_op : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal W_iw_opx : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal W_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal W_valid : IN STD_LOGIC;
                    signal W_vinst : IN STD_LOGIC_VECTOR (263 DOWNTO 0);
                    signal W_wr_dst_reg : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal d_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal d_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : IN STD_LOGIC;
                    signal d_write : IN STD_LOGIC;
                    signal i_address : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal i_read : IN STD_LOGIC;
                    signal i_readdatavalid : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal A_wr_data_filtered : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal E_add_br_to_taken_history_filtered : OUT STD_LOGIC;
                    signal E_src1_eq_src2 : OUT STD_LOGIC;
                    signal M_bht_ptr_filtered : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal M_bht_wr_data_filtered : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal M_bht_wr_en_filtered : OUT STD_LOGIC;
                    signal test_has_ended : OUT STD_LOGIC
                 );
end component cpu_test_bench;

component cpu_ic_data_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                    signal rdclken : IN STD_LOGIC;
                    signal rdclock : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                    signal wrclock : IN STD_LOGIC;
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_ic_data_module;

component cpu_ic_tag_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal rden : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (20 DOWNTO 0)
                 );
end component cpu_ic_tag_module;

component cpu_bht_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal rden : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
                 );
end component cpu_bht_module;

component cpu_register_bank_a_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_register_bank_a_module;

component cpu_register_bank_b_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_register_bank_b_module;

component cpu_dc_tag_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal wraddress : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (14 DOWNTO 0)
                 );
end component cpu_dc_tag_module;

component cpu_dc_data_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                    signal wraddress : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_dc_data_module;

component cpu_dc_victim_module is 
           generic (
                    lpm_file : STRING := "UNUSED"
                    );
           port (
                 -- inputs:
                    signal clock : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal rden : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component cpu_dc_victim_module;

component cpu_mult_cell is 
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
end component cpu_mult_cell;

component cpu_nios2_oci is 
           port (
                 -- inputs:
                    signal A_cmp_result : IN STD_LOGIC;
                    signal A_ctrl_exception : IN STD_LOGIC;
                    signal A_ctrl_ld : IN STD_LOGIC;
                    signal A_ctrl_st : IN STD_LOGIC;
                    signal A_en : IN STD_LOGIC;
                    signal A_mem_baddr : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal A_op_beq : IN STD_LOGIC;
                    signal A_op_bge : IN STD_LOGIC;
                    signal A_op_bgeu : IN STD_LOGIC;
                    signal A_op_blt : IN STD_LOGIC;
                    signal A_op_bltu : IN STD_LOGIC;
                    signal A_op_bne : IN STD_LOGIC;
                    signal A_op_br : IN STD_LOGIC;
                    signal A_op_bret : IN STD_LOGIC;
                    signal A_op_call : IN STD_LOGIC;
                    signal A_op_callr : IN STD_LOGIC;
                    signal A_op_eret : IN STD_LOGIC;
                    signal A_op_jmp : IN STD_LOGIC;
                    signal A_op_jmpi : IN STD_LOGIC;
                    signal A_op_ret : IN STD_LOGIC;
                    signal A_pcb : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal A_valid : IN STD_LOGIC;
                    signal A_wr_data_filtered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal D_en : IN STD_LOGIC;
                    signal E_en : IN STD_LOGIC;
                    signal E_valid : IN STD_LOGIC;
                    signal F_pc : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal M_en : IN STD_LOGIC;
                    signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal debugaccess : IN STD_LOGIC;
                    signal hbreak_enabled : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal test_ending : IN STD_LOGIC;
                    signal test_has_ended : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal oci_hbreak_req : OUT STD_LOGIC;
                    signal oci_ienable : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal oci_single_step_mode : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal resetrequest : OUT STD_LOGIC;
                    signal tr_clk : OUT STD_LOGIC;
                    signal tr_data : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal trigout : OUT STD_LOGIC
                 );
end component cpu_nios2_oci;

                signal A_br_taken_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal A_bstatus_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_bstatus_reg_pie :  STD_LOGIC;
                signal A_bstatus_reg_pie_inst_nxt :  STD_LOGIC;
                signal A_bstatus_reg_pie_nxt :  STD_LOGIC;
                signal A_bstatus_reg_pie_wr_en :  STD_LOGIC;
                signal A_cmp_result :  STD_LOGIC;
                signal A_cpuid_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_ctrl_a_not_src :  STD_LOGIC;
                signal A_ctrl_a_not_src_nxt :  STD_LOGIC;
                signal A_ctrl_alu_force_xor :  STD_LOGIC;
                signal A_ctrl_alu_force_xor_nxt :  STD_LOGIC;
                signal A_ctrl_alu_signed_comparison :  STD_LOGIC;
                signal A_ctrl_alu_signed_comparison_nxt :  STD_LOGIC;
                signal A_ctrl_alu_subtract :  STD_LOGIC;
                signal A_ctrl_alu_subtract_nxt :  STD_LOGIC;
                signal A_ctrl_b_is_dst :  STD_LOGIC;
                signal A_ctrl_b_is_dst_nxt :  STD_LOGIC;
                signal A_ctrl_b_not_src :  STD_LOGIC;
                signal A_ctrl_b_not_src_nxt :  STD_LOGIC;
                signal A_ctrl_br :  STD_LOGIC;
                signal A_ctrl_br_cond :  STD_LOGIC;
                signal A_ctrl_br_cond_nxt :  STD_LOGIC;
                signal A_ctrl_br_nxt :  STD_LOGIC;
                signal A_ctrl_br_uncond :  STD_LOGIC;
                signal A_ctrl_br_uncond_nxt :  STD_LOGIC;
                signal A_ctrl_break :  STD_LOGIC;
                signal A_ctrl_break_nxt :  STD_LOGIC;
                signal A_ctrl_cmp :  STD_LOGIC;
                signal A_ctrl_cmp_nxt :  STD_LOGIC;
                signal A_ctrl_crst :  STD_LOGIC;
                signal A_ctrl_crst_nxt :  STD_LOGIC;
                signal A_ctrl_custom_combo :  STD_LOGIC;
                signal A_ctrl_custom_combo_nxt :  STD_LOGIC;
                signal A_ctrl_custom_multi :  STD_LOGIC;
                signal A_ctrl_custom_multi_nxt :  STD_LOGIC;
                signal A_ctrl_dc_addr_inv :  STD_LOGIC;
                signal A_ctrl_dc_addr_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_addr_nowb_inv :  STD_LOGIC;
                signal A_ctrl_dc_addr_nowb_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_addr_wb_inv :  STD_LOGIC;
                signal A_ctrl_dc_addr_wb_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_index_inv :  STD_LOGIC;
                signal A_ctrl_dc_index_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_index_nowb_inv :  STD_LOGIC;
                signal A_ctrl_dc_index_nowb_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_index_wb_inv :  STD_LOGIC;
                signal A_ctrl_dc_index_wb_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dc_nowb_inv :  STD_LOGIC;
                signal A_ctrl_dc_nowb_inv_nxt :  STD_LOGIC;
                signal A_ctrl_dcache_management :  STD_LOGIC;
                signal A_ctrl_dcache_management_nxt :  STD_LOGIC;
                signal A_ctrl_exception :  STD_LOGIC;
                signal A_ctrl_exception_nxt :  STD_LOGIC;
                signal A_ctrl_flush_pipe_always :  STD_LOGIC;
                signal A_ctrl_flush_pipe_always_nxt :  STD_LOGIC;
                signal A_ctrl_hi_imm16 :  STD_LOGIC;
                signal A_ctrl_hi_imm16_nxt :  STD_LOGIC;
                signal A_ctrl_ignore_dst :  STD_LOGIC;
                signal A_ctrl_ignore_dst_nxt :  STD_LOGIC;
                signal A_ctrl_illegal :  STD_LOGIC;
                signal A_ctrl_illegal_nxt :  STD_LOGIC;
                signal A_ctrl_implicit_dst_eretaddr :  STD_LOGIC;
                signal A_ctrl_implicit_dst_eretaddr_nxt :  STD_LOGIC;
                signal A_ctrl_implicit_dst_retaddr :  STD_LOGIC;
                signal A_ctrl_implicit_dst_retaddr_nxt :  STD_LOGIC;
                signal A_ctrl_invalidate_i :  STD_LOGIC;
                signal A_ctrl_invalidate_i_nxt :  STD_LOGIC;
                signal A_ctrl_jmp_direct :  STD_LOGIC;
                signal A_ctrl_jmp_direct_nxt :  STD_LOGIC;
                signal A_ctrl_jmp_indirect :  STD_LOGIC;
                signal A_ctrl_jmp_indirect_nxt :  STD_LOGIC;
                signal A_ctrl_late_result :  STD_LOGIC;
                signal A_ctrl_late_result_nxt :  STD_LOGIC;
                signal A_ctrl_ld :  STD_LOGIC;
                signal A_ctrl_ld16 :  STD_LOGIC;
                signal A_ctrl_ld16_nxt :  STD_LOGIC;
                signal A_ctrl_ld32 :  STD_LOGIC;
                signal A_ctrl_ld32_nxt :  STD_LOGIC;
                signal A_ctrl_ld8 :  STD_LOGIC;
                signal A_ctrl_ld8_ld16 :  STD_LOGIC;
                signal A_ctrl_ld8_ld16_nxt :  STD_LOGIC;
                signal A_ctrl_ld8_nxt :  STD_LOGIC;
                signal A_ctrl_ld_bypass :  STD_LOGIC;
                signal A_ctrl_ld_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_ld_dcache_management :  STD_LOGIC;
                signal A_ctrl_ld_dcache_management_nxt :  STD_LOGIC;
                signal A_ctrl_ld_io :  STD_LOGIC;
                signal A_ctrl_ld_io_nxt :  STD_LOGIC;
                signal A_ctrl_ld_non_bypass :  STD_LOGIC;
                signal A_ctrl_ld_non_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_ld_non_io :  STD_LOGIC;
                signal A_ctrl_ld_non_io_nxt :  STD_LOGIC;
                signal A_ctrl_ld_nxt :  STD_LOGIC;
                signal A_ctrl_ld_signed :  STD_LOGIC;
                signal A_ctrl_ld_signed_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st :  STD_LOGIC;
                signal A_ctrl_ld_st_bypass :  STD_LOGIC;
                signal A_ctrl_ld_st_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_bypass_or_dcache_management :  STD_LOGIC;
                signal A_ctrl_ld_st_bypass_or_dcache_management_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_io :  STD_LOGIC;
                signal A_ctrl_ld_st_io_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_non_bypass :  STD_LOGIC;
                signal A_ctrl_ld_st_non_bypass_non_st32 :  STD_LOGIC;
                signal A_ctrl_ld_st_non_bypass_non_st32_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_non_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_non_io :  STD_LOGIC;
                signal A_ctrl_ld_st_non_io_non_st32 :  STD_LOGIC;
                signal A_ctrl_ld_st_non_io_non_st32_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_non_io_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_non_st32 :  STD_LOGIC;
                signal A_ctrl_ld_st_non_st32_nxt :  STD_LOGIC;
                signal A_ctrl_ld_st_nxt :  STD_LOGIC;
                signal A_ctrl_logic :  STD_LOGIC;
                signal A_ctrl_logic_nxt :  STD_LOGIC;
                signal A_ctrl_mem :  STD_LOGIC;
                signal A_ctrl_mem16 :  STD_LOGIC;
                signal A_ctrl_mem16_nxt :  STD_LOGIC;
                signal A_ctrl_mem32 :  STD_LOGIC;
                signal A_ctrl_mem32_nxt :  STD_LOGIC;
                signal A_ctrl_mem8 :  STD_LOGIC;
                signal A_ctrl_mem8_nxt :  STD_LOGIC;
                signal A_ctrl_mem_data_access :  STD_LOGIC;
                signal A_ctrl_mem_data_access_nxt :  STD_LOGIC;
                signal A_ctrl_mem_nxt :  STD_LOGIC;
                signal A_ctrl_mul_shift_rot :  STD_LOGIC;
                signal A_ctrl_mul_shift_rot_nxt :  STD_LOGIC;
                signal A_ctrl_mul_shift_src1_signed :  STD_LOGIC;
                signal A_ctrl_mul_shift_src1_signed_nxt :  STD_LOGIC;
                signal A_ctrl_mul_shift_src2_signed :  STD_LOGIC;
                signal A_ctrl_mul_shift_src2_signed_nxt :  STD_LOGIC;
                signal A_ctrl_mulx :  STD_LOGIC;
                signal A_ctrl_mulx_nxt :  STD_LOGIC;
                signal A_ctrl_rdctl_inst :  STD_LOGIC;
                signal A_ctrl_rdctl_inst_nxt :  STD_LOGIC;
                signal A_ctrl_retaddr :  STD_LOGIC;
                signal A_ctrl_retaddr_nxt :  STD_LOGIC;
                signal A_ctrl_rot :  STD_LOGIC;
                signal A_ctrl_rot_nxt :  STD_LOGIC;
                signal A_ctrl_shift_right :  STD_LOGIC;
                signal A_ctrl_shift_right_nxt :  STD_LOGIC;
                signal A_ctrl_shift_rot :  STD_LOGIC;
                signal A_ctrl_shift_rot_nxt :  STD_LOGIC;
                signal A_ctrl_shift_rot_right :  STD_LOGIC;
                signal A_ctrl_shift_rot_right_nxt :  STD_LOGIC;
                signal A_ctrl_src2_choose_imm :  STD_LOGIC;
                signal A_ctrl_src2_choose_imm_nxt :  STD_LOGIC;
                signal A_ctrl_st :  STD_LOGIC;
                signal A_ctrl_st16 :  STD_LOGIC;
                signal A_ctrl_st16_nxt :  STD_LOGIC;
                signal A_ctrl_st8 :  STD_LOGIC;
                signal A_ctrl_st8_nxt :  STD_LOGIC;
                signal A_ctrl_st_bypass :  STD_LOGIC;
                signal A_ctrl_st_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_st_io :  STD_LOGIC;
                signal A_ctrl_st_io_nxt :  STD_LOGIC;
                signal A_ctrl_st_non_bypass :  STD_LOGIC;
                signal A_ctrl_st_non_bypass_nxt :  STD_LOGIC;
                signal A_ctrl_st_non_io :  STD_LOGIC;
                signal A_ctrl_st_non_io_nxt :  STD_LOGIC;
                signal A_ctrl_st_nxt :  STD_LOGIC;
                signal A_ctrl_supervisor_only :  STD_LOGIC;
                signal A_ctrl_supervisor_only_nxt :  STD_LOGIC;
                signal A_ctrl_uncond_cti_non_br :  STD_LOGIC;
                signal A_ctrl_uncond_cti_non_br_nxt :  STD_LOGIC;
                signal A_ctrl_unimp_nop :  STD_LOGIC;
                signal A_ctrl_unimp_nop_nxt :  STD_LOGIC;
                signal A_ctrl_unimp_trap :  STD_LOGIC;
                signal A_ctrl_unimp_trap_nxt :  STD_LOGIC;
                signal A_ctrl_unsigned_lo_imm16 :  STD_LOGIC;
                signal A_ctrl_unsigned_lo_imm16_nxt :  STD_LOGIC;
                signal A_ctrl_wrctl_inst :  STD_LOGIC;
                signal A_ctrl_wrctl_inst_nxt :  STD_LOGIC;
                signal A_data_ram_ld16_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal A_data_ram_ld_align_fill_bit :  STD_LOGIC;
                signal A_data_ram_ld_align_sign_bit :  STD_LOGIC;
                signal A_data_ram_ld_byte0_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_data_ram_ld_byte1_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_data_ram_ld_byte2_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_data_ram_ld_byte3_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_dc_actual_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal A_dc_dc_addr_wb_inv_done_nxt :  STD_LOGIC;
                signal A_dc_dc_addr_wb_inv_want_xfer :  STD_LOGIC;
                signal A_dc_dcache_management_done :  STD_LOGIC;
                signal A_dc_dcache_management_done_nxt :  STD_LOGIC;
                signal A_dc_dcache_management_wr_en :  STD_LOGIC;
                signal A_dc_desired_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal A_dc_dirty :  STD_LOGIC;
                signal A_dc_fill_active :  STD_LOGIC;
                signal A_dc_fill_active_nxt :  STD_LOGIC;
                signal A_dc_fill_byte_en :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_fill_done :  STD_LOGIC;
                signal A_dc_fill_dp_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_fill_dp_offset_en :  STD_LOGIC;
                signal A_dc_fill_dp_offset_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_fill_has_started :  STD_LOGIC;
                signal A_dc_fill_has_started_nxt :  STD_LOGIC;
                signal A_dc_fill_miss_offset_is_next :  STD_LOGIC;
                signal A_dc_fill_need_extra_stall :  STD_LOGIC;
                signal A_dc_fill_need_extra_stall_nxt :  STD_LOGIC;
                signal A_dc_fill_starting :  STD_LOGIC;
                signal A_dc_fill_starting_d1 :  STD_LOGIC;
                signal A_dc_fill_want_dmaster :  STD_LOGIC;
                signal A_dc_fill_want_xfer :  STD_LOGIC;
                signal A_dc_fill_wr_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_dc_hit :  STD_LOGIC;
                signal A_dc_index_wb_inv_done_nxt :  STD_LOGIC;
                signal A_dc_index_wb_inv_want_xfer :  STD_LOGIC;
                signal A_dc_potential_hazard_after_st :  STD_LOGIC;
                signal A_dc_rd_addr_cnt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_rd_addr_cnt_nxt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_rd_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_dc_rd_data_cnt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_rd_data_cnt_nxt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_rd_last_driven :  STD_LOGIC;
                signal A_dc_rd_last_transfer :  STD_LOGIC;
                signal A_dc_rd_last_transfer_d1 :  STD_LOGIC;
                signal A_dc_valid_st_bypass_hit :  STD_LOGIC;
                signal A_dc_valid_st_bypass_hit_wr_en :  STD_LOGIC;
                signal A_dc_valid_st_cache_hit :  STD_LOGIC;
                signal A_dc_want_fill :  STD_LOGIC;
                signal A_dc_want_xfer :  STD_LOGIC;
                signal A_dc_wb_active :  STD_LOGIC;
                signal A_dc_wb_active_nxt :  STD_LOGIC;
                signal A_dc_wb_en :  STD_LOGIC;
                signal A_dc_wb_line :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal A_dc_wb_rd_addr_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_wb_rd_addr_offset_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_wb_rd_addr_starting :  STD_LOGIC;
                signal A_dc_wb_rd_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_dc_wb_rd_data_first :  STD_LOGIC;
                signal A_dc_wb_rd_data_first_nxt :  STD_LOGIC;
                signal A_dc_wb_rd_data_starting :  STD_LOGIC;
                signal A_dc_wb_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal A_dc_wb_update_av_writedata :  STD_LOGIC;
                signal A_dc_wb_wr_active :  STD_LOGIC;
                signal A_dc_wb_wr_active_nxt :  STD_LOGIC;
                signal A_dc_wb_wr_starting :  STD_LOGIC;
                signal A_dc_wb_wr_want_dmaster :  STD_LOGIC;
                signal A_dc_wr_data_cnt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_wr_data_cnt_nxt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_dc_wr_last_driven :  STD_LOGIC;
                signal A_dc_wr_last_transfer :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_active :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_active_nxt :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_done :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_done_nxt :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_has_started :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_has_started_nxt :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_xfer_rd_addr_offset_match :  STD_LOGIC;
                signal A_dc_xfer_rd_addr_offset_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_xfer_rd_addr_starting :  STD_LOGIC;
                signal A_dc_xfer_rd_data_active :  STD_LOGIC;
                signal A_dc_xfer_rd_data_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_xfer_rd_data_offset_match :  STD_LOGIC;
                signal A_dc_xfer_rd_data_starting :  STD_LOGIC;
                signal A_dc_xfer_wr_active :  STD_LOGIC;
                signal A_dc_xfer_wr_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_dc_xfer_wr_data_nxt :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_dc_xfer_wr_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_dc_xfer_wr_starting :  STD_LOGIC;
                signal A_dst_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_dst_regnum_from_M :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_en :  STD_LOGIC;
                signal A_en_d1 :  STD_LOGIC;
                signal A_estatus_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_estatus_reg_pie :  STD_LOGIC;
                signal A_estatus_reg_pie_inst_nxt :  STD_LOGIC;
                signal A_estatus_reg_pie_nxt :  STD_LOGIC;
                signal A_estatus_reg_pie_wr_en :  STD_LOGIC;
                signal A_fwd_reg_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_ienable_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_ienable_reg_irq0 :  STD_LOGIC;
                signal A_ienable_reg_irq0_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq0_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq1 :  STD_LOGIC;
                signal A_ienable_reg_irq1_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq1_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq2 :  STD_LOGIC;
                signal A_ienable_reg_irq2_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq2_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq3 :  STD_LOGIC;
                signal A_ienable_reg_irq3_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq3_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq5 :  STD_LOGIC;
                signal A_ienable_reg_irq5_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq5_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq6 :  STD_LOGIC;
                signal A_ienable_reg_irq6_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq6_wr_en :  STD_LOGIC;
                signal A_ienable_reg_irq8 :  STD_LOGIC;
                signal A_ienable_reg_irq8_nxt :  STD_LOGIC;
                signal A_ienable_reg_irq8_wr_en :  STD_LOGIC;
                signal A_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal A_inst_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_inst_result_aligned :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_ipending_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_ipending_reg_irq0 :  STD_LOGIC;
                signal A_ipending_reg_irq0_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq0_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq1 :  STD_LOGIC;
                signal A_ipending_reg_irq1_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq1_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq2 :  STD_LOGIC;
                signal A_ipending_reg_irq2_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq2_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq3 :  STD_LOGIC;
                signal A_ipending_reg_irq3_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq3_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq5 :  STD_LOGIC;
                signal A_ipending_reg_irq5_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq5_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq6 :  STD_LOGIC;
                signal A_ipending_reg_irq6_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq6_wr_en :  STD_LOGIC;
                signal A_ipending_reg_irq8 :  STD_LOGIC;
                signal A_ipending_reg_irq8_nxt :  STD_LOGIC;
                signal A_ipending_reg_irq8_wr_en :  STD_LOGIC;
                signal A_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_iw_custom_readra :  STD_LOGIC;
                signal A_iw_custom_readrb :  STD_LOGIC;
                signal A_iw_custom_writerc :  STD_LOGIC;
                signal A_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal A_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal A_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal A_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal A_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal A_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal A_ld_align_byte1_fill :  STD_LOGIC;
                signal A_ld_align_byte2_byte3_fill :  STD_LOGIC;
                signal A_ld_align_sh16 :  STD_LOGIC;
                signal A_ld_align_sh8 :  STD_LOGIC;
                signal A_ld_bypass_delayed :  STD_LOGIC;
                signal A_ld_bypass_delayed_started :  STD_LOGIC;
                signal A_ld_bypass_done :  STD_LOGIC;
                signal A_mem16 :  STD_LOGIC;
                signal A_mem32 :  STD_LOGIC;
                signal A_mem8 :  STD_LOGIC;
                signal A_mem_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal A_mem_baddr_byte_field :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal A_mem_baddr_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal A_mem_baddr_line_offset_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal A_mem_baddr_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal A_mem_bypass_pending :  STD_LOGIC;
                signal A_mem_byte_en :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal A_mem_stall :  STD_LOGIC;
                signal A_mem_stall_nxt :  STD_LOGIC;
                signal A_mem_stall_start_nxt :  STD_LOGIC;
                signal A_mem_stall_stop_nxt :  STD_LOGIC;
                signal A_mul_cell_result :  STD_LOGIC_VECTOR (63 DOWNTO 0);
                signal A_mul_cell_result_lsw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_mul_cell_result_msw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_mul_cell_result_sel :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal A_mul_shift_rot_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_op_add :  STD_LOGIC;
                signal A_op_addi :  STD_LOGIC;
                signal A_op_and :  STD_LOGIC;
                signal A_op_andhi :  STD_LOGIC;
                signal A_op_andi :  STD_LOGIC;
                signal A_op_beq :  STD_LOGIC;
                signal A_op_bge :  STD_LOGIC;
                signal A_op_bgeu :  STD_LOGIC;
                signal A_op_blt :  STD_LOGIC;
                signal A_op_bltu :  STD_LOGIC;
                signal A_op_bne :  STD_LOGIC;
                signal A_op_br :  STD_LOGIC;
                signal A_op_break :  STD_LOGIC;
                signal A_op_bret :  STD_LOGIC;
                signal A_op_bswap_s1 :  STD_LOGIC;
                signal A_op_call :  STD_LOGIC;
                signal A_op_callr :  STD_LOGIC;
                signal A_op_cmpeq :  STD_LOGIC;
                signal A_op_cmpeqi :  STD_LOGIC;
                signal A_op_cmpge :  STD_LOGIC;
                signal A_op_cmpgei :  STD_LOGIC;
                signal A_op_cmpgeu :  STD_LOGIC;
                signal A_op_cmpgeui :  STD_LOGIC;
                signal A_op_cmplt :  STD_LOGIC;
                signal A_op_cmplti :  STD_LOGIC;
                signal A_op_cmpltu :  STD_LOGIC;
                signal A_op_cmpltui :  STD_LOGIC;
                signal A_op_cmpne :  STD_LOGIC;
                signal A_op_cmpnei :  STD_LOGIC;
                signal A_op_crst :  STD_LOGIC;
                signal A_op_custom :  STD_LOGIC;
                signal A_op_div :  STD_LOGIC;
                signal A_op_divu :  STD_LOGIC;
                signal A_op_eret :  STD_LOGIC;
                signal A_op_flushd :  STD_LOGIC;
                signal A_op_flushda :  STD_LOGIC;
                signal A_op_flushi :  STD_LOGIC;
                signal A_op_flushp :  STD_LOGIC;
                signal A_op_hbreak :  STD_LOGIC;
                signal A_op_initd :  STD_LOGIC;
                signal A_op_initda :  STD_LOGIC;
                signal A_op_initi :  STD_LOGIC;
                signal A_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal A_op_intr :  STD_LOGIC;
                signal A_op_jmp :  STD_LOGIC;
                signal A_op_jmpi :  STD_LOGIC;
                signal A_op_ldb :  STD_LOGIC;
                signal A_op_ldbio :  STD_LOGIC;
                signal A_op_ldbu :  STD_LOGIC;
                signal A_op_ldbuio :  STD_LOGIC;
                signal A_op_ldh :  STD_LOGIC;
                signal A_op_ldhio :  STD_LOGIC;
                signal A_op_ldhu :  STD_LOGIC;
                signal A_op_ldhuio :  STD_LOGIC;
                signal A_op_ldl :  STD_LOGIC;
                signal A_op_ldw :  STD_LOGIC;
                signal A_op_ldwio :  STD_LOGIC;
                signal A_op_mul :  STD_LOGIC;
                signal A_op_muli :  STD_LOGIC;
                signal A_op_mulxss :  STD_LOGIC;
                signal A_op_mulxsu :  STD_LOGIC;
                signal A_op_mulxuu :  STD_LOGIC;
                signal A_op_nextpc :  STD_LOGIC;
                signal A_op_nor :  STD_LOGIC;
                signal A_op_opx :  STD_LOGIC;
                signal A_op_or :  STD_LOGIC;
                signal A_op_orhi :  STD_LOGIC;
                signal A_op_ori :  STD_LOGIC;
                signal A_op_rdctl :  STD_LOGIC;
                signal A_op_ret :  STD_LOGIC;
                signal A_op_rol :  STD_LOGIC;
                signal A_op_roli :  STD_LOGIC;
                signal A_op_ror :  STD_LOGIC;
                signal A_op_rsv02 :  STD_LOGIC;
                signal A_op_rsv09 :  STD_LOGIC;
                signal A_op_rsv10 :  STD_LOGIC;
                signal A_op_rsv17 :  STD_LOGIC;
                signal A_op_rsv18 :  STD_LOGIC;
                signal A_op_rsv25 :  STD_LOGIC;
                signal A_op_rsv26 :  STD_LOGIC;
                signal A_op_rsv33 :  STD_LOGIC;
                signal A_op_rsv34 :  STD_LOGIC;
                signal A_op_rsv41 :  STD_LOGIC;
                signal A_op_rsv42 :  STD_LOGIC;
                signal A_op_rsv49 :  STD_LOGIC;
                signal A_op_rsv56 :  STD_LOGIC;
                signal A_op_rsv57 :  STD_LOGIC;
                signal A_op_rsv61 :  STD_LOGIC;
                signal A_op_rsv62 :  STD_LOGIC;
                signal A_op_rsv63 :  STD_LOGIC;
                signal A_op_rsvx00 :  STD_LOGIC;
                signal A_op_rsvx10 :  STD_LOGIC;
                signal A_op_rsvx15 :  STD_LOGIC;
                signal A_op_rsvx17 :  STD_LOGIC;
                signal A_op_rsvx20 :  STD_LOGIC;
                signal A_op_rsvx21 :  STD_LOGIC;
                signal A_op_rsvx25 :  STD_LOGIC;
                signal A_op_rsvx33 :  STD_LOGIC;
                signal A_op_rsvx34 :  STD_LOGIC;
                signal A_op_rsvx35 :  STD_LOGIC;
                signal A_op_rsvx42 :  STD_LOGIC;
                signal A_op_rsvx43 :  STD_LOGIC;
                signal A_op_rsvx44 :  STD_LOGIC;
                signal A_op_rsvx47 :  STD_LOGIC;
                signal A_op_rsvx50 :  STD_LOGIC;
                signal A_op_rsvx51 :  STD_LOGIC;
                signal A_op_rsvx55 :  STD_LOGIC;
                signal A_op_rsvx56 :  STD_LOGIC;
                signal A_op_rsvx60 :  STD_LOGIC;
                signal A_op_rsvx63 :  STD_LOGIC;
                signal A_op_sll :  STD_LOGIC;
                signal A_op_slli :  STD_LOGIC;
                signal A_op_sra :  STD_LOGIC;
                signal A_op_srai :  STD_LOGIC;
                signal A_op_srl :  STD_LOGIC;
                signal A_op_srli :  STD_LOGIC;
                signal A_op_stb :  STD_LOGIC;
                signal A_op_stbio :  STD_LOGIC;
                signal A_op_stc :  STD_LOGIC;
                signal A_op_sth :  STD_LOGIC;
                signal A_op_sthio :  STD_LOGIC;
                signal A_op_stw :  STD_LOGIC;
                signal A_op_stwio :  STD_LOGIC;
                signal A_op_sub :  STD_LOGIC;
                signal A_op_sync :  STD_LOGIC;
                signal A_op_trap :  STD_LOGIC;
                signal A_op_wrctl :  STD_LOGIC;
                signal A_op_xor :  STD_LOGIC;
                signal A_op_xorhi :  STD_LOGIC;
                signal A_op_xori :  STD_LOGIC;
                signal A_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal A_pipe_flush :  STD_LOGIC;
                signal A_pipe_flush_waddr :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal A_regnum_a_cmp_D :  STD_LOGIC;
                signal A_regnum_a_cmp_F :  STD_LOGIC;
                signal A_regnum_b_cmp_D :  STD_LOGIC;
                signal A_regnum_b_cmp_F :  STD_LOGIC;
                signal A_slow_inst_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_slow_inst_result_en :  STD_LOGIC;
                signal A_slow_inst_result_nxt :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_slow_inst_sel :  STD_LOGIC;
                signal A_slow_inst_sel_nxt :  STD_LOGIC;
                signal A_slow_ld16_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal A_slow_ld_byte0_data_aligned_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_slow_ld_byte1_data_aligned_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_slow_ld_byte2_data_aligned_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_slow_ld_byte3_data_aligned_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal A_slow_ld_data_aligned_nxt :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_slow_ld_data_fill_bit :  STD_LOGIC;
                signal A_slow_ld_data_sign_bit :  STD_LOGIC;
                signal A_slow_ld_data_sign_bit_16 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal A_slow_ld_data_unaligned :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_st_bypass_delayed :  STD_LOGIC;
                signal A_st_bypass_delayed_started :  STD_LOGIC;
                signal A_st_bypass_done :  STD_LOGIC;
                signal A_st_bypass_transfer_done :  STD_LOGIC;
                signal A_st_bypass_transfer_done_d1 :  STD_LOGIC;
                signal A_st_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_stall :  STD_LOGIC;
                signal A_status_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_status_reg_pie :  STD_LOGIC;
                signal A_status_reg_pie_inst_nxt :  STD_LOGIC;
                signal A_status_reg_pie_nxt :  STD_LOGIC;
                signal A_status_reg_pie_wr_en :  STD_LOGIC;
                signal A_valid :  STD_LOGIC;
                signal A_valid_crst :  STD_LOGIC;
                signal A_valid_wrctl_ienable :  STD_LOGIC;
                signal A_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal A_wr_data_filtered :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_wr_data_unfiltered :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_wr_dst_reg :  STD_LOGIC;
                signal A_wr_dst_reg_from_M :  STD_LOGIC;
                signal D_bht_data :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_bht_ptr :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal D_br_cond_pred_taken :  STD_LOGIC;
                signal D_br_offset_remaining :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal D_br_offset_sex :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal D_br_pred_not_taken :  STD_LOGIC;
                signal D_br_pred_taken :  STD_LOGIC;
                signal D_br_taken_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal D_br_taken_waddr :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_br_taken_waddr_partial :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal D_compare_op :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_control_reg_rddata_muxed :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_ctrl_a_is_src :  STD_LOGIC;
                signal D_ctrl_a_not_src :  STD_LOGIC;
                signal D_ctrl_a_not_src_nxt :  STD_LOGIC;
                signal D_ctrl_alu_force_xor :  STD_LOGIC;
                signal D_ctrl_alu_signed_comparison :  STD_LOGIC;
                signal D_ctrl_alu_subtract :  STD_LOGIC;
                signal D_ctrl_b_is_dst :  STD_LOGIC;
                signal D_ctrl_b_is_dst_nxt :  STD_LOGIC;
                signal D_ctrl_b_is_src :  STD_LOGIC;
                signal D_ctrl_b_not_src :  STD_LOGIC;
                signal D_ctrl_b_not_src_nxt :  STD_LOGIC;
                signal D_ctrl_br :  STD_LOGIC;
                signal D_ctrl_br_cond :  STD_LOGIC;
                signal D_ctrl_br_nxt :  STD_LOGIC;
                signal D_ctrl_br_uncond :  STD_LOGIC;
                signal D_ctrl_br_uncond_nxt :  STD_LOGIC;
                signal D_ctrl_break :  STD_LOGIC;
                signal D_ctrl_cmp :  STD_LOGIC;
                signal D_ctrl_crst :  STD_LOGIC;
                signal D_ctrl_custom_combo :  STD_LOGIC;
                signal D_ctrl_custom_multi :  STD_LOGIC;
                signal D_ctrl_exception :  STD_LOGIC;
                signal D_ctrl_flush_pipe_always :  STD_LOGIC;
                signal D_ctrl_hi_imm16 :  STD_LOGIC;
                signal D_ctrl_ignore_dst :  STD_LOGIC;
                signal D_ctrl_ignore_dst_nxt :  STD_LOGIC;
                signal D_ctrl_illegal :  STD_LOGIC;
                signal D_ctrl_implicit_dst_eretaddr :  STD_LOGIC;
                signal D_ctrl_implicit_dst_retaddr :  STD_LOGIC;
                signal D_ctrl_jmp_direct :  STD_LOGIC;
                signal D_ctrl_jmp_direct_nxt :  STD_LOGIC;
                signal D_ctrl_jmp_indirect :  STD_LOGIC;
                signal D_ctrl_late_result :  STD_LOGIC;
                signal D_ctrl_logic :  STD_LOGIC;
                signal D_ctrl_mul_shift_src1_signed :  STD_LOGIC;
                signal D_ctrl_mul_shift_src2_signed :  STD_LOGIC;
                signal D_ctrl_mulx :  STD_LOGIC;
                signal D_ctrl_retaddr :  STD_LOGIC;
                signal D_ctrl_rot :  STD_LOGIC;
                signal D_ctrl_shift_right :  STD_LOGIC;
                signal D_ctrl_shift_rot :  STD_LOGIC;
                signal D_ctrl_shift_rot_right :  STD_LOGIC;
                signal D_ctrl_src2_choose_imm :  STD_LOGIC;
                signal D_ctrl_supervisor_only :  STD_LOGIC;
                signal D_ctrl_uncond_cti_non_br :  STD_LOGIC;
                signal D_ctrl_unimp_nop :  STD_LOGIC;
                signal D_ctrl_unimp_trap :  STD_LOGIC;
                signal D_ctrl_unsigned_lo_imm16 :  STD_LOGIC;
                signal D_data_depend :  STD_LOGIC;
                signal D_dep_stall :  STD_LOGIC;
                signal D_dst_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_dstfield_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_en :  STD_LOGIC;
                signal D_extra_pc :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_extra_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal D_ic_fill_ignore :  STD_LOGIC;
                signal D_ic_fill_same_tag_line :  STD_LOGIC;
                signal D_ic_fill_starting :  STD_LOGIC;
                signal D_ic_fill_starting_d1 :  STD_LOGIC;
                signal D_ic_want_fill :  STD_LOGIC;
                signal D_ic_want_fill_unfiltered :  STD_LOGIC;
                signal D_ic_want_fill_unfiltered_is_x :  STD_LOGIC;
                signal D_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal D_inst_ram_hit :  STD_LOGIC;
                signal D_issue :  STD_LOGIC;
                signal D_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal D_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal D_iw_custom_readra :  STD_LOGIC;
                signal D_iw_custom_readrb :  STD_LOGIC;
                signal D_iw_custom_writerc :  STD_LOGIC;
                signal D_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal D_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal D_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal D_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal D_jmp_direct_target_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal D_jmp_direct_target_waddr :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_kill :  STD_LOGIC;
                signal D_logic_op :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_logic_op_raw :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_mem16 :  STD_LOGIC;
                signal D_mem32 :  STD_LOGIC;
                signal D_mem8 :  STD_LOGIC;
                signal D_op_add :  STD_LOGIC;
                signal D_op_addi :  STD_LOGIC;
                signal D_op_and :  STD_LOGIC;
                signal D_op_andhi :  STD_LOGIC;
                signal D_op_andi :  STD_LOGIC;
                signal D_op_beq :  STD_LOGIC;
                signal D_op_bge :  STD_LOGIC;
                signal D_op_bgeu :  STD_LOGIC;
                signal D_op_blt :  STD_LOGIC;
                signal D_op_bltu :  STD_LOGIC;
                signal D_op_bne :  STD_LOGIC;
                signal D_op_br :  STD_LOGIC;
                signal D_op_break :  STD_LOGIC;
                signal D_op_bret :  STD_LOGIC;
                signal D_op_bswap_s1 :  STD_LOGIC;
                signal D_op_call :  STD_LOGIC;
                signal D_op_callr :  STD_LOGIC;
                signal D_op_cmpeq :  STD_LOGIC;
                signal D_op_cmpeqi :  STD_LOGIC;
                signal D_op_cmpge :  STD_LOGIC;
                signal D_op_cmpgei :  STD_LOGIC;
                signal D_op_cmpgeu :  STD_LOGIC;
                signal D_op_cmpgeui :  STD_LOGIC;
                signal D_op_cmplt :  STD_LOGIC;
                signal D_op_cmplti :  STD_LOGIC;
                signal D_op_cmpltu :  STD_LOGIC;
                signal D_op_cmpltui :  STD_LOGIC;
                signal D_op_cmpne :  STD_LOGIC;
                signal D_op_cmpnei :  STD_LOGIC;
                signal D_op_crst :  STD_LOGIC;
                signal D_op_custom :  STD_LOGIC;
                signal D_op_div :  STD_LOGIC;
                signal D_op_divu :  STD_LOGIC;
                signal D_op_eret :  STD_LOGIC;
                signal D_op_flushd :  STD_LOGIC;
                signal D_op_flushda :  STD_LOGIC;
                signal D_op_flushi :  STD_LOGIC;
                signal D_op_flushp :  STD_LOGIC;
                signal D_op_hbreak :  STD_LOGIC;
                signal D_op_initd :  STD_LOGIC;
                signal D_op_initda :  STD_LOGIC;
                signal D_op_initi :  STD_LOGIC;
                signal D_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal D_op_intr :  STD_LOGIC;
                signal D_op_jmp :  STD_LOGIC;
                signal D_op_jmpi :  STD_LOGIC;
                signal D_op_ldb :  STD_LOGIC;
                signal D_op_ldbio :  STD_LOGIC;
                signal D_op_ldbu :  STD_LOGIC;
                signal D_op_ldbuio :  STD_LOGIC;
                signal D_op_ldh :  STD_LOGIC;
                signal D_op_ldhio :  STD_LOGIC;
                signal D_op_ldhu :  STD_LOGIC;
                signal D_op_ldhuio :  STD_LOGIC;
                signal D_op_ldl :  STD_LOGIC;
                signal D_op_ldw :  STD_LOGIC;
                signal D_op_ldwio :  STD_LOGIC;
                signal D_op_mul :  STD_LOGIC;
                signal D_op_muli :  STD_LOGIC;
                signal D_op_mulxss :  STD_LOGIC;
                signal D_op_mulxsu :  STD_LOGIC;
                signal D_op_mulxuu :  STD_LOGIC;
                signal D_op_nextpc :  STD_LOGIC;
                signal D_op_nor :  STD_LOGIC;
                signal D_op_opx :  STD_LOGIC;
                signal D_op_or :  STD_LOGIC;
                signal D_op_orhi :  STD_LOGIC;
                signal D_op_ori :  STD_LOGIC;
                signal D_op_rdctl :  STD_LOGIC;
                signal D_op_ret :  STD_LOGIC;
                signal D_op_rol :  STD_LOGIC;
                signal D_op_roli :  STD_LOGIC;
                signal D_op_ror :  STD_LOGIC;
                signal D_op_rsv02 :  STD_LOGIC;
                signal D_op_rsv09 :  STD_LOGIC;
                signal D_op_rsv10 :  STD_LOGIC;
                signal D_op_rsv17 :  STD_LOGIC;
                signal D_op_rsv18 :  STD_LOGIC;
                signal D_op_rsv25 :  STD_LOGIC;
                signal D_op_rsv26 :  STD_LOGIC;
                signal D_op_rsv33 :  STD_LOGIC;
                signal D_op_rsv34 :  STD_LOGIC;
                signal D_op_rsv41 :  STD_LOGIC;
                signal D_op_rsv42 :  STD_LOGIC;
                signal D_op_rsv49 :  STD_LOGIC;
                signal D_op_rsv56 :  STD_LOGIC;
                signal D_op_rsv57 :  STD_LOGIC;
                signal D_op_rsv61 :  STD_LOGIC;
                signal D_op_rsv62 :  STD_LOGIC;
                signal D_op_rsv63 :  STD_LOGIC;
                signal D_op_rsvx00 :  STD_LOGIC;
                signal D_op_rsvx10 :  STD_LOGIC;
                signal D_op_rsvx15 :  STD_LOGIC;
                signal D_op_rsvx17 :  STD_LOGIC;
                signal D_op_rsvx20 :  STD_LOGIC;
                signal D_op_rsvx21 :  STD_LOGIC;
                signal D_op_rsvx25 :  STD_LOGIC;
                signal D_op_rsvx33 :  STD_LOGIC;
                signal D_op_rsvx34 :  STD_LOGIC;
                signal D_op_rsvx35 :  STD_LOGIC;
                signal D_op_rsvx42 :  STD_LOGIC;
                signal D_op_rsvx43 :  STD_LOGIC;
                signal D_op_rsvx44 :  STD_LOGIC;
                signal D_op_rsvx47 :  STD_LOGIC;
                signal D_op_rsvx50 :  STD_LOGIC;
                signal D_op_rsvx51 :  STD_LOGIC;
                signal D_op_rsvx55 :  STD_LOGIC;
                signal D_op_rsvx56 :  STD_LOGIC;
                signal D_op_rsvx60 :  STD_LOGIC;
                signal D_op_rsvx63 :  STD_LOGIC;
                signal D_op_sll :  STD_LOGIC;
                signal D_op_slli :  STD_LOGIC;
                signal D_op_sra :  STD_LOGIC;
                signal D_op_srai :  STD_LOGIC;
                signal D_op_srl :  STD_LOGIC;
                signal D_op_srli :  STD_LOGIC;
                signal D_op_stb :  STD_LOGIC;
                signal D_op_stbio :  STD_LOGIC;
                signal D_op_stc :  STD_LOGIC;
                signal D_op_sth :  STD_LOGIC;
                signal D_op_sthio :  STD_LOGIC;
                signal D_op_stw :  STD_LOGIC;
                signal D_op_stwio :  STD_LOGIC;
                signal D_op_sub :  STD_LOGIC;
                signal D_op_sync :  STD_LOGIC;
                signal D_op_trap :  STD_LOGIC;
                signal D_op_wrctl :  STD_LOGIC;
                signal D_op_xor :  STD_LOGIC;
                signal D_op_xorhi :  STD_LOGIC;
                signal D_op_xori :  STD_LOGIC;
                signal D_pc :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_pc_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal D_pc_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal D_pc_plus_one :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal D_pc_tag_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal D_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal D_refetch :  STD_LOGIC;
                signal D_regnum_a_cmp_F :  STD_LOGIC;
                signal D_regnum_b_cmp_F :  STD_LOGIC;
                signal D_rf_a :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_rf_b :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_src1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_src1_hazard_A :  STD_LOGIC;
                signal D_src1_hazard_E :  STD_LOGIC;
                signal D_src1_hazard_M :  STD_LOGIC;
                signal D_src1_hazard_W :  STD_LOGIC;
                signal D_src1_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_src2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_src2_hazard_A :  STD_LOGIC;
                signal D_src2_hazard_E :  STD_LOGIC;
                signal D_src2_hazard_M :  STD_LOGIC;
                signal D_src2_hazard_W :  STD_LOGIC;
                signal D_src2_imm :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_src2_imm_sel :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal D_src2_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal D_stall :  STD_LOGIC;
                signal D_valid :  STD_LOGIC;
                signal D_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal D_wr_dst_reg :  STD_LOGIC;
                signal E_M_dc_line_offset_match :  STD_LOGIC;
                signal E_add_br_to_taken_history_filtered :  STD_LOGIC;
                signal E_add_br_to_taken_history_unfiltered :  STD_LOGIC;
                signal E_alu_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_arith_result :  STD_LOGIC_VECTOR (32 DOWNTO 0);
                signal E_arith_src1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_arith_src2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_bht_data :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal E_bht_ptr :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal E_br_actually_taken :  STD_LOGIC;
                signal E_br_cond_pred_taken :  STD_LOGIC;
                signal E_br_cond_taken_history :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal E_br_mispredict :  STD_LOGIC;
                signal E_br_result :  STD_LOGIC;
                signal E_br_taken_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal E_cancel :  STD_LOGIC;
                signal E_cmp_result :  STD_LOGIC;
                signal E_compare_op :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal E_control_reg_rddata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_ctrl_a_not_src :  STD_LOGIC;
                signal E_ctrl_a_not_src_nxt :  STD_LOGIC;
                signal E_ctrl_alu_force_xor :  STD_LOGIC;
                signal E_ctrl_alu_force_xor_nxt :  STD_LOGIC;
                signal E_ctrl_alu_signed_comparison :  STD_LOGIC;
                signal E_ctrl_alu_signed_comparison_nxt :  STD_LOGIC;
                signal E_ctrl_alu_subtract :  STD_LOGIC;
                signal E_ctrl_alu_subtract_nxt :  STD_LOGIC;
                signal E_ctrl_b_is_dst :  STD_LOGIC;
                signal E_ctrl_b_is_dst_nxt :  STD_LOGIC;
                signal E_ctrl_b_not_src :  STD_LOGIC;
                signal E_ctrl_b_not_src_nxt :  STD_LOGIC;
                signal E_ctrl_br :  STD_LOGIC;
                signal E_ctrl_br_cond :  STD_LOGIC;
                signal E_ctrl_br_cond_nxt :  STD_LOGIC;
                signal E_ctrl_br_nxt :  STD_LOGIC;
                signal E_ctrl_br_uncond :  STD_LOGIC;
                signal E_ctrl_br_uncond_nxt :  STD_LOGIC;
                signal E_ctrl_break :  STD_LOGIC;
                signal E_ctrl_break_nxt :  STD_LOGIC;
                signal E_ctrl_cmp :  STD_LOGIC;
                signal E_ctrl_cmp_nxt :  STD_LOGIC;
                signal E_ctrl_crst :  STD_LOGIC;
                signal E_ctrl_crst_nxt :  STD_LOGIC;
                signal E_ctrl_custom_combo :  STD_LOGIC;
                signal E_ctrl_custom_combo_nxt :  STD_LOGIC;
                signal E_ctrl_custom_multi :  STD_LOGIC;
                signal E_ctrl_custom_multi_nxt :  STD_LOGIC;
                signal E_ctrl_dc_addr_inv :  STD_LOGIC;
                signal E_ctrl_dc_addr_nowb_inv :  STD_LOGIC;
                signal E_ctrl_dc_addr_wb_inv :  STD_LOGIC;
                signal E_ctrl_dc_index_inv :  STD_LOGIC;
                signal E_ctrl_dc_index_nowb_inv :  STD_LOGIC;
                signal E_ctrl_dc_index_wb_inv :  STD_LOGIC;
                signal E_ctrl_dc_nowb_inv :  STD_LOGIC;
                signal E_ctrl_dcache_management :  STD_LOGIC;
                signal E_ctrl_exception :  STD_LOGIC;
                signal E_ctrl_exception_nxt :  STD_LOGIC;
                signal E_ctrl_flush_pipe_always :  STD_LOGIC;
                signal E_ctrl_flush_pipe_always_nxt :  STD_LOGIC;
                signal E_ctrl_hi_imm16 :  STD_LOGIC;
                signal E_ctrl_hi_imm16_nxt :  STD_LOGIC;
                signal E_ctrl_ignore_dst :  STD_LOGIC;
                signal E_ctrl_ignore_dst_nxt :  STD_LOGIC;
                signal E_ctrl_illegal :  STD_LOGIC;
                signal E_ctrl_illegal_nxt :  STD_LOGIC;
                signal E_ctrl_implicit_dst_eretaddr :  STD_LOGIC;
                signal E_ctrl_implicit_dst_eretaddr_nxt :  STD_LOGIC;
                signal E_ctrl_implicit_dst_retaddr :  STD_LOGIC;
                signal E_ctrl_implicit_dst_retaddr_nxt :  STD_LOGIC;
                signal E_ctrl_invalidate_i :  STD_LOGIC;
                signal E_ctrl_jmp_direct :  STD_LOGIC;
                signal E_ctrl_jmp_direct_nxt :  STD_LOGIC;
                signal E_ctrl_jmp_indirect :  STD_LOGIC;
                signal E_ctrl_jmp_indirect_nxt :  STD_LOGIC;
                signal E_ctrl_late_result :  STD_LOGIC;
                signal E_ctrl_late_result_nxt :  STD_LOGIC;
                signal E_ctrl_ld :  STD_LOGIC;
                signal E_ctrl_ld16 :  STD_LOGIC;
                signal E_ctrl_ld32 :  STD_LOGIC;
                signal E_ctrl_ld8 :  STD_LOGIC;
                signal E_ctrl_ld8_ld16 :  STD_LOGIC;
                signal E_ctrl_ld_bypass :  STD_LOGIC;
                signal E_ctrl_ld_dcache_management :  STD_LOGIC;
                signal E_ctrl_ld_io :  STD_LOGIC;
                signal E_ctrl_ld_non_bypass :  STD_LOGIC;
                signal E_ctrl_ld_non_io :  STD_LOGIC;
                signal E_ctrl_ld_signed :  STD_LOGIC;
                signal E_ctrl_ld_st :  STD_LOGIC;
                signal E_ctrl_ld_st_bypass :  STD_LOGIC;
                signal E_ctrl_ld_st_bypass_or_dcache_management :  STD_LOGIC;
                signal E_ctrl_ld_st_io :  STD_LOGIC;
                signal E_ctrl_ld_st_non_bypass :  STD_LOGIC;
                signal E_ctrl_ld_st_non_bypass_non_st32 :  STD_LOGIC;
                signal E_ctrl_ld_st_non_io :  STD_LOGIC;
                signal E_ctrl_ld_st_non_io_non_st32 :  STD_LOGIC;
                signal E_ctrl_ld_st_non_st32 :  STD_LOGIC;
                signal E_ctrl_logic :  STD_LOGIC;
                signal E_ctrl_logic_nxt :  STD_LOGIC;
                signal E_ctrl_mem :  STD_LOGIC;
                signal E_ctrl_mem16 :  STD_LOGIC;
                signal E_ctrl_mem32 :  STD_LOGIC;
                signal E_ctrl_mem8 :  STD_LOGIC;
                signal E_ctrl_mem_data_access :  STD_LOGIC;
                signal E_ctrl_mul_shift_src1_signed :  STD_LOGIC;
                signal E_ctrl_mul_shift_src1_signed_nxt :  STD_LOGIC;
                signal E_ctrl_mul_shift_src2_signed :  STD_LOGIC;
                signal E_ctrl_mul_shift_src2_signed_nxt :  STD_LOGIC;
                signal E_ctrl_mulx :  STD_LOGIC;
                signal E_ctrl_mulx_nxt :  STD_LOGIC;
                signal E_ctrl_rdctl_inst :  STD_LOGIC;
                signal E_ctrl_retaddr :  STD_LOGIC;
                signal E_ctrl_retaddr_nxt :  STD_LOGIC;
                signal E_ctrl_rot :  STD_LOGIC;
                signal E_ctrl_rot_nxt :  STD_LOGIC;
                signal E_ctrl_shift_right :  STD_LOGIC;
                signal E_ctrl_shift_right_nxt :  STD_LOGIC;
                signal E_ctrl_shift_rot :  STD_LOGIC;
                signal E_ctrl_shift_rot_nxt :  STD_LOGIC;
                signal E_ctrl_shift_rot_right :  STD_LOGIC;
                signal E_ctrl_shift_rot_right_nxt :  STD_LOGIC;
                signal E_ctrl_src2_choose_imm :  STD_LOGIC;
                signal E_ctrl_src2_choose_imm_nxt :  STD_LOGIC;
                signal E_ctrl_st :  STD_LOGIC;
                signal E_ctrl_st16 :  STD_LOGIC;
                signal E_ctrl_st8 :  STD_LOGIC;
                signal E_ctrl_st_bypass :  STD_LOGIC;
                signal E_ctrl_st_io :  STD_LOGIC;
                signal E_ctrl_st_non_bypass :  STD_LOGIC;
                signal E_ctrl_st_non_io :  STD_LOGIC;
                signal E_ctrl_supervisor_only :  STD_LOGIC;
                signal E_ctrl_supervisor_only_nxt :  STD_LOGIC;
                signal E_ctrl_uncond_cti_non_br :  STD_LOGIC;
                signal E_ctrl_uncond_cti_non_br_nxt :  STD_LOGIC;
                signal E_ctrl_unimp_nop :  STD_LOGIC;
                signal E_ctrl_unimp_nop_nxt :  STD_LOGIC;
                signal E_ctrl_unimp_trap :  STD_LOGIC;
                signal E_ctrl_unimp_trap_nxt :  STD_LOGIC;
                signal E_ctrl_unsigned_lo_imm16 :  STD_LOGIC;
                signal E_ctrl_unsigned_lo_imm16_nxt :  STD_LOGIC;
                signal E_ctrl_wrctl_inst :  STD_LOGIC;
                signal E_dst_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_en :  STD_LOGIC;
                signal E_eq :  STD_LOGIC;
                signal E_extra_pc :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal E_extra_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal E_fwd_reg_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_hbreak_req :  STD_LOGIC;
                signal E_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal E_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal E_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal E_iw_custom_readra :  STD_LOGIC;
                signal E_iw_custom_readrb :  STD_LOGIC;
                signal E_iw_custom_writerc :  STD_LOGIC;
                signal E_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal E_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal E_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal E_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal E_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal E_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal E_logic_op :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal E_logic_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_lt :  STD_LOGIC;
                signal E_mem16 :  STD_LOGIC;
                signal E_mem32 :  STD_LOGIC;
                signal E_mem8 :  STD_LOGIC;
                signal E_mem_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal E_mem_baddr_byte_field :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal E_mem_baddr_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal E_mem_baddr_line_offset_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal E_mem_baddr_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal E_mem_bypass_non_io :  STD_LOGIC;
                signal E_mem_byte_en :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal E_op_add :  STD_LOGIC;
                signal E_op_addi :  STD_LOGIC;
                signal E_op_and :  STD_LOGIC;
                signal E_op_andhi :  STD_LOGIC;
                signal E_op_andi :  STD_LOGIC;
                signal E_op_beq :  STD_LOGIC;
                signal E_op_bge :  STD_LOGIC;
                signal E_op_bgeu :  STD_LOGIC;
                signal E_op_blt :  STD_LOGIC;
                signal E_op_bltu :  STD_LOGIC;
                signal E_op_bne :  STD_LOGIC;
                signal E_op_br :  STD_LOGIC;
                signal E_op_break :  STD_LOGIC;
                signal E_op_bret :  STD_LOGIC;
                signal E_op_bswap_s1 :  STD_LOGIC;
                signal E_op_call :  STD_LOGIC;
                signal E_op_callr :  STD_LOGIC;
                signal E_op_cmpeq :  STD_LOGIC;
                signal E_op_cmpeqi :  STD_LOGIC;
                signal E_op_cmpge :  STD_LOGIC;
                signal E_op_cmpgei :  STD_LOGIC;
                signal E_op_cmpgeu :  STD_LOGIC;
                signal E_op_cmpgeui :  STD_LOGIC;
                signal E_op_cmplt :  STD_LOGIC;
                signal E_op_cmplti :  STD_LOGIC;
                signal E_op_cmpltu :  STD_LOGIC;
                signal E_op_cmpltui :  STD_LOGIC;
                signal E_op_cmpne :  STD_LOGIC;
                signal E_op_cmpnei :  STD_LOGIC;
                signal E_op_crst :  STD_LOGIC;
                signal E_op_custom :  STD_LOGIC;
                signal E_op_div :  STD_LOGIC;
                signal E_op_divu :  STD_LOGIC;
                signal E_op_eret :  STD_LOGIC;
                signal E_op_flushd :  STD_LOGIC;
                signal E_op_flushda :  STD_LOGIC;
                signal E_op_flushi :  STD_LOGIC;
                signal E_op_flushp :  STD_LOGIC;
                signal E_op_hbreak :  STD_LOGIC;
                signal E_op_initd :  STD_LOGIC;
                signal E_op_initda :  STD_LOGIC;
                signal E_op_initi :  STD_LOGIC;
                signal E_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal E_op_intr :  STD_LOGIC;
                signal E_op_jmp :  STD_LOGIC;
                signal E_op_jmpi :  STD_LOGIC;
                signal E_op_ldb :  STD_LOGIC;
                signal E_op_ldbio :  STD_LOGIC;
                signal E_op_ldbu :  STD_LOGIC;
                signal E_op_ldbuio :  STD_LOGIC;
                signal E_op_ldh :  STD_LOGIC;
                signal E_op_ldhio :  STD_LOGIC;
                signal E_op_ldhu :  STD_LOGIC;
                signal E_op_ldhuio :  STD_LOGIC;
                signal E_op_ldl :  STD_LOGIC;
                signal E_op_ldw :  STD_LOGIC;
                signal E_op_ldwio :  STD_LOGIC;
                signal E_op_mul :  STD_LOGIC;
                signal E_op_muli :  STD_LOGIC;
                signal E_op_mulxss :  STD_LOGIC;
                signal E_op_mulxsu :  STD_LOGIC;
                signal E_op_mulxuu :  STD_LOGIC;
                signal E_op_nextpc :  STD_LOGIC;
                signal E_op_nor :  STD_LOGIC;
                signal E_op_opx :  STD_LOGIC;
                signal E_op_or :  STD_LOGIC;
                signal E_op_orhi :  STD_LOGIC;
                signal E_op_ori :  STD_LOGIC;
                signal E_op_rdctl :  STD_LOGIC;
                signal E_op_ret :  STD_LOGIC;
                signal E_op_rol :  STD_LOGIC;
                signal E_op_roli :  STD_LOGIC;
                signal E_op_ror :  STD_LOGIC;
                signal E_op_rsv02 :  STD_LOGIC;
                signal E_op_rsv09 :  STD_LOGIC;
                signal E_op_rsv10 :  STD_LOGIC;
                signal E_op_rsv17 :  STD_LOGIC;
                signal E_op_rsv18 :  STD_LOGIC;
                signal E_op_rsv25 :  STD_LOGIC;
                signal E_op_rsv26 :  STD_LOGIC;
                signal E_op_rsv33 :  STD_LOGIC;
                signal E_op_rsv34 :  STD_LOGIC;
                signal E_op_rsv41 :  STD_LOGIC;
                signal E_op_rsv42 :  STD_LOGIC;
                signal E_op_rsv49 :  STD_LOGIC;
                signal E_op_rsv56 :  STD_LOGIC;
                signal E_op_rsv57 :  STD_LOGIC;
                signal E_op_rsv61 :  STD_LOGIC;
                signal E_op_rsv62 :  STD_LOGIC;
                signal E_op_rsv63 :  STD_LOGIC;
                signal E_op_rsvx00 :  STD_LOGIC;
                signal E_op_rsvx10 :  STD_LOGIC;
                signal E_op_rsvx15 :  STD_LOGIC;
                signal E_op_rsvx17 :  STD_LOGIC;
                signal E_op_rsvx20 :  STD_LOGIC;
                signal E_op_rsvx21 :  STD_LOGIC;
                signal E_op_rsvx25 :  STD_LOGIC;
                signal E_op_rsvx33 :  STD_LOGIC;
                signal E_op_rsvx34 :  STD_LOGIC;
                signal E_op_rsvx35 :  STD_LOGIC;
                signal E_op_rsvx42 :  STD_LOGIC;
                signal E_op_rsvx43 :  STD_LOGIC;
                signal E_op_rsvx44 :  STD_LOGIC;
                signal E_op_rsvx47 :  STD_LOGIC;
                signal E_op_rsvx50 :  STD_LOGIC;
                signal E_op_rsvx51 :  STD_LOGIC;
                signal E_op_rsvx55 :  STD_LOGIC;
                signal E_op_rsvx56 :  STD_LOGIC;
                signal E_op_rsvx60 :  STD_LOGIC;
                signal E_op_rsvx63 :  STD_LOGIC;
                signal E_op_sll :  STD_LOGIC;
                signal E_op_slli :  STD_LOGIC;
                signal E_op_sra :  STD_LOGIC;
                signal E_op_srai :  STD_LOGIC;
                signal E_op_srl :  STD_LOGIC;
                signal E_op_srli :  STD_LOGIC;
                signal E_op_stb :  STD_LOGIC;
                signal E_op_stbio :  STD_LOGIC;
                signal E_op_stc :  STD_LOGIC;
                signal E_op_sth :  STD_LOGIC;
                signal E_op_sthio :  STD_LOGIC;
                signal E_op_stw :  STD_LOGIC;
                signal E_op_stwio :  STD_LOGIC;
                signal E_op_sub :  STD_LOGIC;
                signal E_op_sync :  STD_LOGIC;
                signal E_op_trap :  STD_LOGIC;
                signal E_op_wrctl :  STD_LOGIC;
                signal E_op_xor :  STD_LOGIC;
                signal E_op_xorhi :  STD_LOGIC;
                signal E_op_xori :  STD_LOGIC;
                signal E_pc :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal E_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal E_regnum_a_cmp_D :  STD_LOGIC;
                signal E_regnum_a_cmp_F :  STD_LOGIC;
                signal E_regnum_b_cmp_D :  STD_LOGIC;
                signal E_regnum_b_cmp_F :  STD_LOGIC;
                signal E_sel_data_master :  STD_LOGIC;
                signal E_sh_cnt_col :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal E_sh_cnt_row :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal E_shift_rot_by_zero :  STD_LOGIC;
                signal E_shift_rot_col_zero :  STD_LOGIC;
                signal E_src1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_src1_eq_src2 :  STD_LOGIC;
                signal E_src1_mul_cell :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_src2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_src2_mul_cell :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_src2_reg :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_st_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal E_stall :  STD_LOGIC;
                signal E_stb_data :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal E_sth_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal E_valid :  STD_LOGIC;
                signal E_valid_from_D :  STD_LOGIC;
                signal E_valid_jmp_indirect :  STD_LOGIC;
                signal E_valid_prior_to_hbreak :  STD_LOGIC;
                signal E_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal E_wr_dst_reg :  STD_LOGIC;
                signal E_wr_dst_reg_from_D :  STD_LOGIC;
                signal F_bht_data :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal F_bht_ptr :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal F_bht_ptr_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal F_br_taken_waddr_partial :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal F_ctrl_a_not_src :  STD_LOGIC;
                signal F_ctrl_b_is_dst :  STD_LOGIC;
                signal F_ctrl_b_not_src :  STD_LOGIC;
                signal F_ctrl_br :  STD_LOGIC;
                signal F_ctrl_br_uncond :  STD_LOGIC;
                signal F_ctrl_ignore_dst :  STD_LOGIC;
                signal F_ctrl_jmp_direct :  STD_LOGIC;
                signal F_en :  STD_LOGIC;
                signal F_ic_data_rd_addr_nxt :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal F_ic_desired_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal F_ic_fill_same_tag_line :  STD_LOGIC;
                signal F_ic_hit :  STD_LOGIC;
                signal F_ic_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal F_ic_tag_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal F_ic_tag_rd :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal F_ic_tag_rd_addr_nxt :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal F_ic_valid :  STD_LOGIC;
                signal F_ic_valid_bits :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal F_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal F_inst_ram_hit :  STD_LOGIC;
                signal F_issue :  STD_LOGIC;
                signal F_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal F_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_a_rf :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_b_rf :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal F_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal F_iw_custom_readra :  STD_LOGIC;
                signal F_iw_custom_readrb :  STD_LOGIC;
                signal F_iw_custom_writerc :  STD_LOGIC;
                signal F_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal F_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal F_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal F_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal F_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal F_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_kill :  STD_LOGIC;
                signal F_mem16 :  STD_LOGIC;
                signal F_mem32 :  STD_LOGIC;
                signal F_mem8 :  STD_LOGIC;
                signal F_op_add :  STD_LOGIC;
                signal F_op_addi :  STD_LOGIC;
                signal F_op_and :  STD_LOGIC;
                signal F_op_andhi :  STD_LOGIC;
                signal F_op_andi :  STD_LOGIC;
                signal F_op_beq :  STD_LOGIC;
                signal F_op_bge :  STD_LOGIC;
                signal F_op_bgeu :  STD_LOGIC;
                signal F_op_blt :  STD_LOGIC;
                signal F_op_bltu :  STD_LOGIC;
                signal F_op_bne :  STD_LOGIC;
                signal F_op_br :  STD_LOGIC;
                signal F_op_break :  STD_LOGIC;
                signal F_op_bret :  STD_LOGIC;
                signal F_op_bswap_s1 :  STD_LOGIC;
                signal F_op_call :  STD_LOGIC;
                signal F_op_callr :  STD_LOGIC;
                signal F_op_cmpeq :  STD_LOGIC;
                signal F_op_cmpeqi :  STD_LOGIC;
                signal F_op_cmpge :  STD_LOGIC;
                signal F_op_cmpgei :  STD_LOGIC;
                signal F_op_cmpgeu :  STD_LOGIC;
                signal F_op_cmpgeui :  STD_LOGIC;
                signal F_op_cmplt :  STD_LOGIC;
                signal F_op_cmplti :  STD_LOGIC;
                signal F_op_cmpltu :  STD_LOGIC;
                signal F_op_cmpltui :  STD_LOGIC;
                signal F_op_cmpne :  STD_LOGIC;
                signal F_op_cmpnei :  STD_LOGIC;
                signal F_op_crst :  STD_LOGIC;
                signal F_op_custom :  STD_LOGIC;
                signal F_op_div :  STD_LOGIC;
                signal F_op_divu :  STD_LOGIC;
                signal F_op_eret :  STD_LOGIC;
                signal F_op_flushd :  STD_LOGIC;
                signal F_op_flushda :  STD_LOGIC;
                signal F_op_flushi :  STD_LOGIC;
                signal F_op_flushp :  STD_LOGIC;
                signal F_op_hbreak :  STD_LOGIC;
                signal F_op_initd :  STD_LOGIC;
                signal F_op_initda :  STD_LOGIC;
                signal F_op_initi :  STD_LOGIC;
                signal F_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal F_op_intr :  STD_LOGIC;
                signal F_op_jmp :  STD_LOGIC;
                signal F_op_jmpi :  STD_LOGIC;
                signal F_op_ldb :  STD_LOGIC;
                signal F_op_ldbio :  STD_LOGIC;
                signal F_op_ldbu :  STD_LOGIC;
                signal F_op_ldbuio :  STD_LOGIC;
                signal F_op_ldh :  STD_LOGIC;
                signal F_op_ldhio :  STD_LOGIC;
                signal F_op_ldhu :  STD_LOGIC;
                signal F_op_ldhuio :  STD_LOGIC;
                signal F_op_ldl :  STD_LOGIC;
                signal F_op_ldw :  STD_LOGIC;
                signal F_op_ldwio :  STD_LOGIC;
                signal F_op_mul :  STD_LOGIC;
                signal F_op_muli :  STD_LOGIC;
                signal F_op_mulxss :  STD_LOGIC;
                signal F_op_mulxsu :  STD_LOGIC;
                signal F_op_mulxuu :  STD_LOGIC;
                signal F_op_nextpc :  STD_LOGIC;
                signal F_op_nor :  STD_LOGIC;
                signal F_op_opx :  STD_LOGIC;
                signal F_op_or :  STD_LOGIC;
                signal F_op_orhi :  STD_LOGIC;
                signal F_op_ori :  STD_LOGIC;
                signal F_op_rdctl :  STD_LOGIC;
                signal F_op_ret :  STD_LOGIC;
                signal F_op_rol :  STD_LOGIC;
                signal F_op_roli :  STD_LOGIC;
                signal F_op_ror :  STD_LOGIC;
                signal F_op_rsv02 :  STD_LOGIC;
                signal F_op_rsv09 :  STD_LOGIC;
                signal F_op_rsv10 :  STD_LOGIC;
                signal F_op_rsv17 :  STD_LOGIC;
                signal F_op_rsv18 :  STD_LOGIC;
                signal F_op_rsv25 :  STD_LOGIC;
                signal F_op_rsv26 :  STD_LOGIC;
                signal F_op_rsv33 :  STD_LOGIC;
                signal F_op_rsv34 :  STD_LOGIC;
                signal F_op_rsv41 :  STD_LOGIC;
                signal F_op_rsv42 :  STD_LOGIC;
                signal F_op_rsv49 :  STD_LOGIC;
                signal F_op_rsv56 :  STD_LOGIC;
                signal F_op_rsv57 :  STD_LOGIC;
                signal F_op_rsv61 :  STD_LOGIC;
                signal F_op_rsv62 :  STD_LOGIC;
                signal F_op_rsv63 :  STD_LOGIC;
                signal F_op_rsvx00 :  STD_LOGIC;
                signal F_op_rsvx10 :  STD_LOGIC;
                signal F_op_rsvx15 :  STD_LOGIC;
                signal F_op_rsvx17 :  STD_LOGIC;
                signal F_op_rsvx20 :  STD_LOGIC;
                signal F_op_rsvx21 :  STD_LOGIC;
                signal F_op_rsvx25 :  STD_LOGIC;
                signal F_op_rsvx33 :  STD_LOGIC;
                signal F_op_rsvx34 :  STD_LOGIC;
                signal F_op_rsvx35 :  STD_LOGIC;
                signal F_op_rsvx42 :  STD_LOGIC;
                signal F_op_rsvx43 :  STD_LOGIC;
                signal F_op_rsvx44 :  STD_LOGIC;
                signal F_op_rsvx47 :  STD_LOGIC;
                signal F_op_rsvx50 :  STD_LOGIC;
                signal F_op_rsvx51 :  STD_LOGIC;
                signal F_op_rsvx55 :  STD_LOGIC;
                signal F_op_rsvx56 :  STD_LOGIC;
                signal F_op_rsvx60 :  STD_LOGIC;
                signal F_op_rsvx63 :  STD_LOGIC;
                signal F_op_sll :  STD_LOGIC;
                signal F_op_slli :  STD_LOGIC;
                signal F_op_sra :  STD_LOGIC;
                signal F_op_srai :  STD_LOGIC;
                signal F_op_srl :  STD_LOGIC;
                signal F_op_srli :  STD_LOGIC;
                signal F_op_stb :  STD_LOGIC;
                signal F_op_stbio :  STD_LOGIC;
                signal F_op_stc :  STD_LOGIC;
                signal F_op_sth :  STD_LOGIC;
                signal F_op_sthio :  STD_LOGIC;
                signal F_op_stw :  STD_LOGIC;
                signal F_op_stwio :  STD_LOGIC;
                signal F_op_sub :  STD_LOGIC;
                signal F_op_sync :  STD_LOGIC;
                signal F_op_trap :  STD_LOGIC;
                signal F_op_wrctl :  STD_LOGIC;
                signal F_op_xor :  STD_LOGIC;
                signal F_op_xorhi :  STD_LOGIC;
                signal F_op_xori :  STD_LOGIC;
                signal F_pc :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal F_pc_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal F_pc_nxt :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal F_pc_plus_one :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal F_pc_tag_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal F_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal F_pcb_nxt :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal F_ram_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal F_ram_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal F_ram_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal F_ram_iw_custom_readra :  STD_LOGIC;
                signal F_ram_iw_custom_readrb :  STD_LOGIC;
                signal F_ram_iw_custom_writerc :  STD_LOGIC;
                signal F_ram_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal F_ram_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal F_ram_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal F_ram_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal F_ram_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal F_ram_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal F_ram_mem16 :  STD_LOGIC;
                signal F_ram_mem32 :  STD_LOGIC;
                signal F_ram_mem8 :  STD_LOGIC;
                signal F_sel_instruction_master :  STD_LOGIC;
                signal F_stall :  STD_LOGIC;
                signal F_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal M_A_dc_line_match :  STD_LOGIC;
                signal M_A_dc_line_match_d1 :  STD_LOGIC;
                signal M_alu_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_bht_data :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_bht_ptr_filtered :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal M_bht_ptr_unfiltered :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal M_bht_wr_data_filtered :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_bht_wr_data_unfiltered :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_bht_wr_en_filtered :  STD_LOGIC;
                signal M_bht_wr_en_unfiltered :  STD_LOGIC;
                signal M_br_cond_taken_history :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal M_br_mispredict :  STD_LOGIC;
                signal M_br_taken_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_cancel :  STD_LOGIC;
                signal M_cmp_result :  STD_LOGIC;
                signal M_control_reg_rddata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_ctrl_a_not_src :  STD_LOGIC;
                signal M_ctrl_a_not_src_nxt :  STD_LOGIC;
                signal M_ctrl_alu_force_xor :  STD_LOGIC;
                signal M_ctrl_alu_force_xor_nxt :  STD_LOGIC;
                signal M_ctrl_alu_signed_comparison :  STD_LOGIC;
                signal M_ctrl_alu_signed_comparison_nxt :  STD_LOGIC;
                signal M_ctrl_alu_subtract :  STD_LOGIC;
                signal M_ctrl_alu_subtract_nxt :  STD_LOGIC;
                signal M_ctrl_b_is_dst :  STD_LOGIC;
                signal M_ctrl_b_is_dst_nxt :  STD_LOGIC;
                signal M_ctrl_b_not_src :  STD_LOGIC;
                signal M_ctrl_b_not_src_nxt :  STD_LOGIC;
                signal M_ctrl_br :  STD_LOGIC;
                signal M_ctrl_br_cond :  STD_LOGIC;
                signal M_ctrl_br_cond_nxt :  STD_LOGIC;
                signal M_ctrl_br_nxt :  STD_LOGIC;
                signal M_ctrl_br_uncond :  STD_LOGIC;
                signal M_ctrl_br_uncond_nxt :  STD_LOGIC;
                signal M_ctrl_break :  STD_LOGIC;
                signal M_ctrl_break_nxt :  STD_LOGIC;
                signal M_ctrl_cmp :  STD_LOGIC;
                signal M_ctrl_cmp_nxt :  STD_LOGIC;
                signal M_ctrl_crst :  STD_LOGIC;
                signal M_ctrl_crst_nxt :  STD_LOGIC;
                signal M_ctrl_custom_combo :  STD_LOGIC;
                signal M_ctrl_custom_combo_nxt :  STD_LOGIC;
                signal M_ctrl_custom_multi :  STD_LOGIC;
                signal M_ctrl_custom_multi_nxt :  STD_LOGIC;
                signal M_ctrl_dc_addr_inv :  STD_LOGIC;
                signal M_ctrl_dc_addr_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_addr_nowb_inv :  STD_LOGIC;
                signal M_ctrl_dc_addr_nowb_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_addr_wb_inv :  STD_LOGIC;
                signal M_ctrl_dc_addr_wb_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_index_inv :  STD_LOGIC;
                signal M_ctrl_dc_index_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_index_nowb_inv :  STD_LOGIC;
                signal M_ctrl_dc_index_nowb_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_index_wb_inv :  STD_LOGIC;
                signal M_ctrl_dc_index_wb_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dc_nowb_inv :  STD_LOGIC;
                signal M_ctrl_dc_nowb_inv_nxt :  STD_LOGIC;
                signal M_ctrl_dcache_management :  STD_LOGIC;
                signal M_ctrl_dcache_management_nxt :  STD_LOGIC;
                signal M_ctrl_exception :  STD_LOGIC;
                signal M_ctrl_exception_nxt :  STD_LOGIC;
                signal M_ctrl_flush_pipe_always :  STD_LOGIC;
                signal M_ctrl_flush_pipe_always_nxt :  STD_LOGIC;
                signal M_ctrl_hi_imm16 :  STD_LOGIC;
                signal M_ctrl_hi_imm16_nxt :  STD_LOGIC;
                signal M_ctrl_ignore_dst :  STD_LOGIC;
                signal M_ctrl_ignore_dst_nxt :  STD_LOGIC;
                signal M_ctrl_illegal :  STD_LOGIC;
                signal M_ctrl_illegal_nxt :  STD_LOGIC;
                signal M_ctrl_implicit_dst_eretaddr :  STD_LOGIC;
                signal M_ctrl_implicit_dst_eretaddr_nxt :  STD_LOGIC;
                signal M_ctrl_implicit_dst_retaddr :  STD_LOGIC;
                signal M_ctrl_implicit_dst_retaddr_nxt :  STD_LOGIC;
                signal M_ctrl_invalidate_i :  STD_LOGIC;
                signal M_ctrl_invalidate_i_nxt :  STD_LOGIC;
                signal M_ctrl_jmp_direct :  STD_LOGIC;
                signal M_ctrl_jmp_direct_nxt :  STD_LOGIC;
                signal M_ctrl_jmp_indirect :  STD_LOGIC;
                signal M_ctrl_jmp_indirect_nxt :  STD_LOGIC;
                signal M_ctrl_late_result :  STD_LOGIC;
                signal M_ctrl_late_result_nxt :  STD_LOGIC;
                signal M_ctrl_ld :  STD_LOGIC;
                signal M_ctrl_ld16 :  STD_LOGIC;
                signal M_ctrl_ld16_nxt :  STD_LOGIC;
                signal M_ctrl_ld32 :  STD_LOGIC;
                signal M_ctrl_ld32_nxt :  STD_LOGIC;
                signal M_ctrl_ld8 :  STD_LOGIC;
                signal M_ctrl_ld8_ld16 :  STD_LOGIC;
                signal M_ctrl_ld8_ld16_nxt :  STD_LOGIC;
                signal M_ctrl_ld8_nxt :  STD_LOGIC;
                signal M_ctrl_ld_bypass :  STD_LOGIC;
                signal M_ctrl_ld_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_ld_dcache_management :  STD_LOGIC;
                signal M_ctrl_ld_dcache_management_nxt :  STD_LOGIC;
                signal M_ctrl_ld_io :  STD_LOGIC;
                signal M_ctrl_ld_io_nxt :  STD_LOGIC;
                signal M_ctrl_ld_non_bypass :  STD_LOGIC;
                signal M_ctrl_ld_non_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_ld_non_io :  STD_LOGIC;
                signal M_ctrl_ld_non_io_nxt :  STD_LOGIC;
                signal M_ctrl_ld_nxt :  STD_LOGIC;
                signal M_ctrl_ld_signed :  STD_LOGIC;
                signal M_ctrl_ld_signed_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st :  STD_LOGIC;
                signal M_ctrl_ld_st_bypass :  STD_LOGIC;
                signal M_ctrl_ld_st_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_bypass_or_dcache_management :  STD_LOGIC;
                signal M_ctrl_ld_st_bypass_or_dcache_management_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_cache :  STD_LOGIC;
                signal M_ctrl_ld_st_io :  STD_LOGIC;
                signal M_ctrl_ld_st_io_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_non_bypass :  STD_LOGIC;
                signal M_ctrl_ld_st_non_bypass_non_st32 :  STD_LOGIC;
                signal M_ctrl_ld_st_non_bypass_non_st32_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_non_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_non_io :  STD_LOGIC;
                signal M_ctrl_ld_st_non_io_non_st32 :  STD_LOGIC;
                signal M_ctrl_ld_st_non_io_non_st32_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_non_io_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_non_st32 :  STD_LOGIC;
                signal M_ctrl_ld_st_non_st32_nxt :  STD_LOGIC;
                signal M_ctrl_ld_st_nxt :  STD_LOGIC;
                signal M_ctrl_logic :  STD_LOGIC;
                signal M_ctrl_logic_nxt :  STD_LOGIC;
                signal M_ctrl_mem :  STD_LOGIC;
                signal M_ctrl_mem16 :  STD_LOGIC;
                signal M_ctrl_mem16_nxt :  STD_LOGIC;
                signal M_ctrl_mem32 :  STD_LOGIC;
                signal M_ctrl_mem32_nxt :  STD_LOGIC;
                signal M_ctrl_mem8 :  STD_LOGIC;
                signal M_ctrl_mem8_nxt :  STD_LOGIC;
                signal M_ctrl_mem_data_access :  STD_LOGIC;
                signal M_ctrl_mem_data_access_nxt :  STD_LOGIC;
                signal M_ctrl_mem_nxt :  STD_LOGIC;
                signal M_ctrl_mul_shift_rot :  STD_LOGIC;
                signal M_ctrl_mul_shift_src1_signed :  STD_LOGIC;
                signal M_ctrl_mul_shift_src1_signed_nxt :  STD_LOGIC;
                signal M_ctrl_mul_shift_src2_signed :  STD_LOGIC;
                signal M_ctrl_mul_shift_src2_signed_nxt :  STD_LOGIC;
                signal M_ctrl_mulx :  STD_LOGIC;
                signal M_ctrl_mulx_nxt :  STD_LOGIC;
                signal M_ctrl_rdctl_inst :  STD_LOGIC;
                signal M_ctrl_rdctl_inst_nxt :  STD_LOGIC;
                signal M_ctrl_retaddr :  STD_LOGIC;
                signal M_ctrl_retaddr_nxt :  STD_LOGIC;
                signal M_ctrl_rot :  STD_LOGIC;
                signal M_ctrl_rot_nxt :  STD_LOGIC;
                signal M_ctrl_shift_right :  STD_LOGIC;
                signal M_ctrl_shift_right_nxt :  STD_LOGIC;
                signal M_ctrl_shift_rot :  STD_LOGIC;
                signal M_ctrl_shift_rot_nxt :  STD_LOGIC;
                signal M_ctrl_shift_rot_right :  STD_LOGIC;
                signal M_ctrl_shift_rot_right_nxt :  STD_LOGIC;
                signal M_ctrl_src2_choose_imm :  STD_LOGIC;
                signal M_ctrl_src2_choose_imm_nxt :  STD_LOGIC;
                signal M_ctrl_st :  STD_LOGIC;
                signal M_ctrl_st16 :  STD_LOGIC;
                signal M_ctrl_st16_nxt :  STD_LOGIC;
                signal M_ctrl_st8 :  STD_LOGIC;
                signal M_ctrl_st8_nxt :  STD_LOGIC;
                signal M_ctrl_st_bypass :  STD_LOGIC;
                signal M_ctrl_st_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_st_cache :  STD_LOGIC;
                signal M_ctrl_st_io :  STD_LOGIC;
                signal M_ctrl_st_io_nxt :  STD_LOGIC;
                signal M_ctrl_st_non_bypass :  STD_LOGIC;
                signal M_ctrl_st_non_bypass_nxt :  STD_LOGIC;
                signal M_ctrl_st_non_io :  STD_LOGIC;
                signal M_ctrl_st_non_io_nxt :  STD_LOGIC;
                signal M_ctrl_st_nxt :  STD_LOGIC;
                signal M_ctrl_supervisor_only :  STD_LOGIC;
                signal M_ctrl_supervisor_only_nxt :  STD_LOGIC;
                signal M_ctrl_uncond_cti_non_br :  STD_LOGIC;
                signal M_ctrl_uncond_cti_non_br_nxt :  STD_LOGIC;
                signal M_ctrl_unimp_nop :  STD_LOGIC;
                signal M_ctrl_unimp_nop_nxt :  STD_LOGIC;
                signal M_ctrl_unimp_trap :  STD_LOGIC;
                signal M_ctrl_unimp_trap_nxt :  STD_LOGIC;
                signal M_ctrl_unsigned_lo_imm16 :  STD_LOGIC;
                signal M_ctrl_unsigned_lo_imm16_nxt :  STD_LOGIC;
                signal M_ctrl_wrctl_inst :  STD_LOGIC;
                signal M_ctrl_wrctl_inst_nxt :  STD_LOGIC;
                signal M_data_ram_ld_align_sign_bit :  STD_LOGIC;
                signal M_data_ram_ld_align_sign_bit_16 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_data_ram_ld_align_sign_bit_16_hi :  STD_LOGIC;
                signal M_dc_actual_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal M_dc_desired_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal M_dc_dirty :  STD_LOGIC;
                signal M_dc_dirty_raw :  STD_LOGIC;
                signal M_dc_hit :  STD_LOGIC;
                signal M_dc_potential_hazard_after_st :  STD_LOGIC;
                signal M_dc_rd_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_dc_st_wr_en :  STD_LOGIC;
                signal M_dc_tag_entry :  STD_LOGIC_VECTOR (14 DOWNTO 0);
                signal M_dc_tag_match :  STD_LOGIC;
                signal M_dc_valid :  STD_LOGIC;
                signal M_dc_valid_st_bypass_hit :  STD_LOGIC;
                signal M_dc_valid_st_cache_hit :  STD_LOGIC;
                signal M_dc_want_fill :  STD_LOGIC;
                signal M_dc_want_mem_bypass_or_dcache_management :  STD_LOGIC;
                signal M_dst_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_en :  STD_LOGIC;
                signal M_exc_any :  STD_LOGIC;
                signal M_fwd_reg_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal M_inst_result :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal M_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal M_iw_custom_readra :  STD_LOGIC;
                signal M_iw_custom_readrb :  STD_LOGIC;
                signal M_iw_custom_writerc :  STD_LOGIC;
                signal M_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal M_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal M_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal M_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal M_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal M_ld_align_byte1_fill :  STD_LOGIC;
                signal M_ld_align_byte2_byte3_fill :  STD_LOGIC;
                signal M_ld_align_sh16 :  STD_LOGIC;
                signal M_ld_align_sh8 :  STD_LOGIC;
                signal M_mem16 :  STD_LOGIC;
                signal M_mem32 :  STD_LOGIC;
                signal M_mem8 :  STD_LOGIC;
                signal M_mem_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_mem_baddr_byte_field :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_mem_baddr_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal M_mem_baddr_line_offset_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal M_mem_baddr_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal M_mem_byte_en :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal M_mul_cell_result_sel :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal M_op_add :  STD_LOGIC;
                signal M_op_addi :  STD_LOGIC;
                signal M_op_and :  STD_LOGIC;
                signal M_op_andhi :  STD_LOGIC;
                signal M_op_andi :  STD_LOGIC;
                signal M_op_beq :  STD_LOGIC;
                signal M_op_bge :  STD_LOGIC;
                signal M_op_bgeu :  STD_LOGIC;
                signal M_op_blt :  STD_LOGIC;
                signal M_op_bltu :  STD_LOGIC;
                signal M_op_bne :  STD_LOGIC;
                signal M_op_br :  STD_LOGIC;
                signal M_op_break :  STD_LOGIC;
                signal M_op_bret :  STD_LOGIC;
                signal M_op_bswap_s1 :  STD_LOGIC;
                signal M_op_call :  STD_LOGIC;
                signal M_op_callr :  STD_LOGIC;
                signal M_op_cmpeq :  STD_LOGIC;
                signal M_op_cmpeqi :  STD_LOGIC;
                signal M_op_cmpge :  STD_LOGIC;
                signal M_op_cmpgei :  STD_LOGIC;
                signal M_op_cmpgeu :  STD_LOGIC;
                signal M_op_cmpgeui :  STD_LOGIC;
                signal M_op_cmplt :  STD_LOGIC;
                signal M_op_cmplti :  STD_LOGIC;
                signal M_op_cmpltu :  STD_LOGIC;
                signal M_op_cmpltui :  STD_LOGIC;
                signal M_op_cmpne :  STD_LOGIC;
                signal M_op_cmpnei :  STD_LOGIC;
                signal M_op_crst :  STD_LOGIC;
                signal M_op_custom :  STD_LOGIC;
                signal M_op_div :  STD_LOGIC;
                signal M_op_divu :  STD_LOGIC;
                signal M_op_eret :  STD_LOGIC;
                signal M_op_flushd :  STD_LOGIC;
                signal M_op_flushda :  STD_LOGIC;
                signal M_op_flushi :  STD_LOGIC;
                signal M_op_flushp :  STD_LOGIC;
                signal M_op_hbreak :  STD_LOGIC;
                signal M_op_initd :  STD_LOGIC;
                signal M_op_initda :  STD_LOGIC;
                signal M_op_initi :  STD_LOGIC;
                signal M_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal M_op_intr :  STD_LOGIC;
                signal M_op_jmp :  STD_LOGIC;
                signal M_op_jmpi :  STD_LOGIC;
                signal M_op_ldb :  STD_LOGIC;
                signal M_op_ldbio :  STD_LOGIC;
                signal M_op_ldbu :  STD_LOGIC;
                signal M_op_ldbuio :  STD_LOGIC;
                signal M_op_ldh :  STD_LOGIC;
                signal M_op_ldhio :  STD_LOGIC;
                signal M_op_ldhu :  STD_LOGIC;
                signal M_op_ldhuio :  STD_LOGIC;
                signal M_op_ldl :  STD_LOGIC;
                signal M_op_ldw :  STD_LOGIC;
                signal M_op_ldwio :  STD_LOGIC;
                signal M_op_mul :  STD_LOGIC;
                signal M_op_muli :  STD_LOGIC;
                signal M_op_mulxss :  STD_LOGIC;
                signal M_op_mulxsu :  STD_LOGIC;
                signal M_op_mulxuu :  STD_LOGIC;
                signal M_op_nextpc :  STD_LOGIC;
                signal M_op_nor :  STD_LOGIC;
                signal M_op_opx :  STD_LOGIC;
                signal M_op_or :  STD_LOGIC;
                signal M_op_orhi :  STD_LOGIC;
                signal M_op_ori :  STD_LOGIC;
                signal M_op_rdctl :  STD_LOGIC;
                signal M_op_ret :  STD_LOGIC;
                signal M_op_rol :  STD_LOGIC;
                signal M_op_roli :  STD_LOGIC;
                signal M_op_ror :  STD_LOGIC;
                signal M_op_rsv02 :  STD_LOGIC;
                signal M_op_rsv09 :  STD_LOGIC;
                signal M_op_rsv10 :  STD_LOGIC;
                signal M_op_rsv17 :  STD_LOGIC;
                signal M_op_rsv18 :  STD_LOGIC;
                signal M_op_rsv25 :  STD_LOGIC;
                signal M_op_rsv26 :  STD_LOGIC;
                signal M_op_rsv33 :  STD_LOGIC;
                signal M_op_rsv34 :  STD_LOGIC;
                signal M_op_rsv41 :  STD_LOGIC;
                signal M_op_rsv42 :  STD_LOGIC;
                signal M_op_rsv49 :  STD_LOGIC;
                signal M_op_rsv56 :  STD_LOGIC;
                signal M_op_rsv57 :  STD_LOGIC;
                signal M_op_rsv61 :  STD_LOGIC;
                signal M_op_rsv62 :  STD_LOGIC;
                signal M_op_rsv63 :  STD_LOGIC;
                signal M_op_rsvx00 :  STD_LOGIC;
                signal M_op_rsvx10 :  STD_LOGIC;
                signal M_op_rsvx15 :  STD_LOGIC;
                signal M_op_rsvx17 :  STD_LOGIC;
                signal M_op_rsvx20 :  STD_LOGIC;
                signal M_op_rsvx21 :  STD_LOGIC;
                signal M_op_rsvx25 :  STD_LOGIC;
                signal M_op_rsvx33 :  STD_LOGIC;
                signal M_op_rsvx34 :  STD_LOGIC;
                signal M_op_rsvx35 :  STD_LOGIC;
                signal M_op_rsvx42 :  STD_LOGIC;
                signal M_op_rsvx43 :  STD_LOGIC;
                signal M_op_rsvx44 :  STD_LOGIC;
                signal M_op_rsvx47 :  STD_LOGIC;
                signal M_op_rsvx50 :  STD_LOGIC;
                signal M_op_rsvx51 :  STD_LOGIC;
                signal M_op_rsvx55 :  STD_LOGIC;
                signal M_op_rsvx56 :  STD_LOGIC;
                signal M_op_rsvx60 :  STD_LOGIC;
                signal M_op_rsvx63 :  STD_LOGIC;
                signal M_op_sll :  STD_LOGIC;
                signal M_op_slli :  STD_LOGIC;
                signal M_op_sra :  STD_LOGIC;
                signal M_op_srai :  STD_LOGIC;
                signal M_op_srl :  STD_LOGIC;
                signal M_op_srli :  STD_LOGIC;
                signal M_op_stb :  STD_LOGIC;
                signal M_op_stbio :  STD_LOGIC;
                signal M_op_stc :  STD_LOGIC;
                signal M_op_sth :  STD_LOGIC;
                signal M_op_sthio :  STD_LOGIC;
                signal M_op_stw :  STD_LOGIC;
                signal M_op_stwio :  STD_LOGIC;
                signal M_op_sub :  STD_LOGIC;
                signal M_op_sync :  STD_LOGIC;
                signal M_op_trap :  STD_LOGIC;
                signal M_op_wrctl :  STD_LOGIC;
                signal M_op_xor :  STD_LOGIC;
                signal M_op_xorhi :  STD_LOGIC;
                signal M_op_xori :  STD_LOGIC;
                signal M_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_pipe_flush :  STD_LOGIC;
                signal M_pipe_flush_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_pipe_flush_baddr_nxt :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_pipe_flush_nxt :  STD_LOGIC;
                signal M_pipe_flush_waddr :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal M_pipe_flush_waddr_nxt :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal M_ram_rd_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_rdctl_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_regnum_a_cmp_D :  STD_LOGIC;
                signal M_regnum_a_cmp_F :  STD_LOGIC;
                signal M_regnum_b_cmp_D :  STD_LOGIC;
                signal M_regnum_b_cmp_F :  STD_LOGIC;
                signal M_sel_data_master :  STD_LOGIC;
                signal M_shift_rot_by_zero :  STD_LOGIC;
                signal M_src1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_src2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_st_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal M_st_dc_wr_en :  STD_LOGIC;
                signal M_stall :  STD_LOGIC;
                signal M_target_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal M_valid :  STD_LOGIC;
                signal M_valid_from_E :  STD_LOGIC;
                signal M_valid_mem_d1 :  STD_LOGIC;
                signal M_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal M_wr_dst_reg :  STD_LOGIC;
                signal M_wr_dst_reg_from_E :  STD_LOGIC;
                signal M_wrctl_bstatus :  STD_LOGIC;
                signal M_wrctl_data_bstatus_reg_pie :  STD_LOGIC;
                signal M_wrctl_data_estatus_reg_pie :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq0 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq1 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq2 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq3 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq5 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq6 :  STD_LOGIC;
                signal M_wrctl_data_ienable_reg_irq8 :  STD_LOGIC;
                signal M_wrctl_data_status_reg_pie :  STD_LOGIC;
                signal M_wrctl_estatus :  STD_LOGIC;
                signal M_wrctl_ienable :  STD_LOGIC;
                signal M_wrctl_status :  STD_LOGIC;
                signal W_br_taken_baddr :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal W_ctrl_a_not_src :  STD_LOGIC;
                signal W_ctrl_a_not_src_nxt :  STD_LOGIC;
                signal W_ctrl_alu_force_xor :  STD_LOGIC;
                signal W_ctrl_alu_force_xor_nxt :  STD_LOGIC;
                signal W_ctrl_alu_signed_comparison :  STD_LOGIC;
                signal W_ctrl_alu_signed_comparison_nxt :  STD_LOGIC;
                signal W_ctrl_alu_subtract :  STD_LOGIC;
                signal W_ctrl_alu_subtract_nxt :  STD_LOGIC;
                signal W_ctrl_b_is_dst :  STD_LOGIC;
                signal W_ctrl_b_is_dst_nxt :  STD_LOGIC;
                signal W_ctrl_b_not_src :  STD_LOGIC;
                signal W_ctrl_b_not_src_nxt :  STD_LOGIC;
                signal W_ctrl_br :  STD_LOGIC;
                signal W_ctrl_br_cond :  STD_LOGIC;
                signal W_ctrl_br_cond_nxt :  STD_LOGIC;
                signal W_ctrl_br_nxt :  STD_LOGIC;
                signal W_ctrl_br_uncond :  STD_LOGIC;
                signal W_ctrl_br_uncond_nxt :  STD_LOGIC;
                signal W_ctrl_break :  STD_LOGIC;
                signal W_ctrl_break_nxt :  STD_LOGIC;
                signal W_ctrl_cmp :  STD_LOGIC;
                signal W_ctrl_cmp_nxt :  STD_LOGIC;
                signal W_ctrl_crst :  STD_LOGIC;
                signal W_ctrl_crst_nxt :  STD_LOGIC;
                signal W_ctrl_custom_combo :  STD_LOGIC;
                signal W_ctrl_custom_combo_nxt :  STD_LOGIC;
                signal W_ctrl_custom_multi :  STD_LOGIC;
                signal W_ctrl_custom_multi_nxt :  STD_LOGIC;
                signal W_ctrl_dc_addr_inv :  STD_LOGIC;
                signal W_ctrl_dc_addr_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_addr_nowb_inv :  STD_LOGIC;
                signal W_ctrl_dc_addr_nowb_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_addr_wb_inv :  STD_LOGIC;
                signal W_ctrl_dc_addr_wb_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_index_inv :  STD_LOGIC;
                signal W_ctrl_dc_index_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_index_nowb_inv :  STD_LOGIC;
                signal W_ctrl_dc_index_nowb_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_index_wb_inv :  STD_LOGIC;
                signal W_ctrl_dc_index_wb_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dc_nowb_inv :  STD_LOGIC;
                signal W_ctrl_dc_nowb_inv_nxt :  STD_LOGIC;
                signal W_ctrl_dcache_management :  STD_LOGIC;
                signal W_ctrl_dcache_management_nxt :  STD_LOGIC;
                signal W_ctrl_exception :  STD_LOGIC;
                signal W_ctrl_exception_nxt :  STD_LOGIC;
                signal W_ctrl_flush_pipe_always :  STD_LOGIC;
                signal W_ctrl_flush_pipe_always_nxt :  STD_LOGIC;
                signal W_ctrl_hi_imm16 :  STD_LOGIC;
                signal W_ctrl_hi_imm16_nxt :  STD_LOGIC;
                signal W_ctrl_ignore_dst :  STD_LOGIC;
                signal W_ctrl_ignore_dst_nxt :  STD_LOGIC;
                signal W_ctrl_illegal :  STD_LOGIC;
                signal W_ctrl_illegal_nxt :  STD_LOGIC;
                signal W_ctrl_implicit_dst_eretaddr :  STD_LOGIC;
                signal W_ctrl_implicit_dst_eretaddr_nxt :  STD_LOGIC;
                signal W_ctrl_implicit_dst_retaddr :  STD_LOGIC;
                signal W_ctrl_implicit_dst_retaddr_nxt :  STD_LOGIC;
                signal W_ctrl_invalidate_i :  STD_LOGIC;
                signal W_ctrl_invalidate_i_nxt :  STD_LOGIC;
                signal W_ctrl_jmp_direct :  STD_LOGIC;
                signal W_ctrl_jmp_direct_nxt :  STD_LOGIC;
                signal W_ctrl_jmp_indirect :  STD_LOGIC;
                signal W_ctrl_jmp_indirect_nxt :  STD_LOGIC;
                signal W_ctrl_late_result :  STD_LOGIC;
                signal W_ctrl_late_result_nxt :  STD_LOGIC;
                signal W_ctrl_ld :  STD_LOGIC;
                signal W_ctrl_ld16 :  STD_LOGIC;
                signal W_ctrl_ld16_nxt :  STD_LOGIC;
                signal W_ctrl_ld32 :  STD_LOGIC;
                signal W_ctrl_ld32_nxt :  STD_LOGIC;
                signal W_ctrl_ld8 :  STD_LOGIC;
                signal W_ctrl_ld8_ld16 :  STD_LOGIC;
                signal W_ctrl_ld8_ld16_nxt :  STD_LOGIC;
                signal W_ctrl_ld8_nxt :  STD_LOGIC;
                signal W_ctrl_ld_dcache_management :  STD_LOGIC;
                signal W_ctrl_ld_dcache_management_nxt :  STD_LOGIC;
                signal W_ctrl_ld_io :  STD_LOGIC;
                signal W_ctrl_ld_io_nxt :  STD_LOGIC;
                signal W_ctrl_ld_non_io :  STD_LOGIC;
                signal W_ctrl_ld_non_io_nxt :  STD_LOGIC;
                signal W_ctrl_ld_nxt :  STD_LOGIC;
                signal W_ctrl_ld_signed :  STD_LOGIC;
                signal W_ctrl_ld_signed_nxt :  STD_LOGIC;
                signal W_ctrl_ld_st :  STD_LOGIC;
                signal W_ctrl_ld_st_io :  STD_LOGIC;
                signal W_ctrl_ld_st_io_nxt :  STD_LOGIC;
                signal W_ctrl_ld_st_non_io :  STD_LOGIC;
                signal W_ctrl_ld_st_non_io_non_st32 :  STD_LOGIC;
                signal W_ctrl_ld_st_non_io_non_st32_nxt :  STD_LOGIC;
                signal W_ctrl_ld_st_non_io_nxt :  STD_LOGIC;
                signal W_ctrl_ld_st_non_st32 :  STD_LOGIC;
                signal W_ctrl_ld_st_non_st32_nxt :  STD_LOGIC;
                signal W_ctrl_ld_st_nxt :  STD_LOGIC;
                signal W_ctrl_logic :  STD_LOGIC;
                signal W_ctrl_logic_nxt :  STD_LOGIC;
                signal W_ctrl_mem :  STD_LOGIC;
                signal W_ctrl_mem16 :  STD_LOGIC;
                signal W_ctrl_mem16_nxt :  STD_LOGIC;
                signal W_ctrl_mem32 :  STD_LOGIC;
                signal W_ctrl_mem32_nxt :  STD_LOGIC;
                signal W_ctrl_mem8 :  STD_LOGIC;
                signal W_ctrl_mem8_nxt :  STD_LOGIC;
                signal W_ctrl_mem_data_access :  STD_LOGIC;
                signal W_ctrl_mem_data_access_nxt :  STD_LOGIC;
                signal W_ctrl_mem_nxt :  STD_LOGIC;
                signal W_ctrl_mul_shift_rot :  STD_LOGIC;
                signal W_ctrl_mul_shift_rot_nxt :  STD_LOGIC;
                signal W_ctrl_mul_shift_src1_signed :  STD_LOGIC;
                signal W_ctrl_mul_shift_src1_signed_nxt :  STD_LOGIC;
                signal W_ctrl_mul_shift_src2_signed :  STD_LOGIC;
                signal W_ctrl_mul_shift_src2_signed_nxt :  STD_LOGIC;
                signal W_ctrl_mulx :  STD_LOGIC;
                signal W_ctrl_mulx_nxt :  STD_LOGIC;
                signal W_ctrl_rdctl_inst :  STD_LOGIC;
                signal W_ctrl_rdctl_inst_nxt :  STD_LOGIC;
                signal W_ctrl_retaddr :  STD_LOGIC;
                signal W_ctrl_retaddr_nxt :  STD_LOGIC;
                signal W_ctrl_rot :  STD_LOGIC;
                signal W_ctrl_rot_nxt :  STD_LOGIC;
                signal W_ctrl_shift_right :  STD_LOGIC;
                signal W_ctrl_shift_right_nxt :  STD_LOGIC;
                signal W_ctrl_shift_rot :  STD_LOGIC;
                signal W_ctrl_shift_rot_nxt :  STD_LOGIC;
                signal W_ctrl_shift_rot_right :  STD_LOGIC;
                signal W_ctrl_shift_rot_right_nxt :  STD_LOGIC;
                signal W_ctrl_src2_choose_imm :  STD_LOGIC;
                signal W_ctrl_src2_choose_imm_nxt :  STD_LOGIC;
                signal W_ctrl_st :  STD_LOGIC;
                signal W_ctrl_st16 :  STD_LOGIC;
                signal W_ctrl_st16_nxt :  STD_LOGIC;
                signal W_ctrl_st8 :  STD_LOGIC;
                signal W_ctrl_st8_nxt :  STD_LOGIC;
                signal W_ctrl_st_io :  STD_LOGIC;
                signal W_ctrl_st_io_nxt :  STD_LOGIC;
                signal W_ctrl_st_non_io :  STD_LOGIC;
                signal W_ctrl_st_non_io_nxt :  STD_LOGIC;
                signal W_ctrl_st_nxt :  STD_LOGIC;
                signal W_ctrl_supervisor_only :  STD_LOGIC;
                signal W_ctrl_supervisor_only_nxt :  STD_LOGIC;
                signal W_ctrl_uncond_cti_non_br :  STD_LOGIC;
                signal W_ctrl_uncond_cti_non_br_nxt :  STD_LOGIC;
                signal W_ctrl_unimp_nop :  STD_LOGIC;
                signal W_ctrl_unimp_nop_nxt :  STD_LOGIC;
                signal W_ctrl_unimp_trap :  STD_LOGIC;
                signal W_ctrl_unimp_trap_nxt :  STD_LOGIC;
                signal W_ctrl_unsigned_lo_imm16 :  STD_LOGIC;
                signal W_ctrl_unsigned_lo_imm16_nxt :  STD_LOGIC;
                signal W_ctrl_wrctl_inst :  STD_LOGIC;
                signal W_ctrl_wrctl_inst_nxt :  STD_LOGIC;
                signal W_dst_regnum :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_en :  STD_LOGIC;
                signal W_inst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal W_iw :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal W_iw_a :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_iw_b :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_iw_c :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_iw_control_regnum :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal W_iw_custom_n :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal W_iw_custom_readra :  STD_LOGIC;
                signal W_iw_custom_readrb :  STD_LOGIC;
                signal W_iw_custom_writerc :  STD_LOGIC;
                signal W_iw_imm16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal W_iw_imm26 :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal W_iw_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_iw_memsz :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal W_iw_op :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal W_iw_opx :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal W_iw_shift_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_iw_trap_break_imm5 :  STD_LOGIC_VECTOR (4 DOWNTO 0);
                signal W_mem16 :  STD_LOGIC;
                signal W_mem32 :  STD_LOGIC;
                signal W_mem8 :  STD_LOGIC;
                signal W_op_add :  STD_LOGIC;
                signal W_op_addi :  STD_LOGIC;
                signal W_op_and :  STD_LOGIC;
                signal W_op_andhi :  STD_LOGIC;
                signal W_op_andi :  STD_LOGIC;
                signal W_op_beq :  STD_LOGIC;
                signal W_op_bge :  STD_LOGIC;
                signal W_op_bgeu :  STD_LOGIC;
                signal W_op_blt :  STD_LOGIC;
                signal W_op_bltu :  STD_LOGIC;
                signal W_op_bne :  STD_LOGIC;
                signal W_op_br :  STD_LOGIC;
                signal W_op_break :  STD_LOGIC;
                signal W_op_bret :  STD_LOGIC;
                signal W_op_bswap_s1 :  STD_LOGIC;
                signal W_op_call :  STD_LOGIC;
                signal W_op_callr :  STD_LOGIC;
                signal W_op_cmpeq :  STD_LOGIC;
                signal W_op_cmpeqi :  STD_LOGIC;
                signal W_op_cmpge :  STD_LOGIC;
                signal W_op_cmpgei :  STD_LOGIC;
                signal W_op_cmpgeu :  STD_LOGIC;
                signal W_op_cmpgeui :  STD_LOGIC;
                signal W_op_cmplt :  STD_LOGIC;
                signal W_op_cmplti :  STD_LOGIC;
                signal W_op_cmpltu :  STD_LOGIC;
                signal W_op_cmpltui :  STD_LOGIC;
                signal W_op_cmpne :  STD_LOGIC;
                signal W_op_cmpnei :  STD_LOGIC;
                signal W_op_crst :  STD_LOGIC;
                signal W_op_custom :  STD_LOGIC;
                signal W_op_div :  STD_LOGIC;
                signal W_op_divu :  STD_LOGIC;
                signal W_op_eret :  STD_LOGIC;
                signal W_op_flushd :  STD_LOGIC;
                signal W_op_flushda :  STD_LOGIC;
                signal W_op_flushi :  STD_LOGIC;
                signal W_op_flushp :  STD_LOGIC;
                signal W_op_hbreak :  STD_LOGIC;
                signal W_op_initd :  STD_LOGIC;
                signal W_op_initda :  STD_LOGIC;
                signal W_op_initi :  STD_LOGIC;
                signal W_op_interrupt_vector_interrupt_vector :  STD_LOGIC;
                signal W_op_intr :  STD_LOGIC;
                signal W_op_jmp :  STD_LOGIC;
                signal W_op_jmpi :  STD_LOGIC;
                signal W_op_ldb :  STD_LOGIC;
                signal W_op_ldbio :  STD_LOGIC;
                signal W_op_ldbu :  STD_LOGIC;
                signal W_op_ldbuio :  STD_LOGIC;
                signal W_op_ldh :  STD_LOGIC;
                signal W_op_ldhio :  STD_LOGIC;
                signal W_op_ldhu :  STD_LOGIC;
                signal W_op_ldhuio :  STD_LOGIC;
                signal W_op_ldl :  STD_LOGIC;
                signal W_op_ldw :  STD_LOGIC;
                signal W_op_ldwio :  STD_LOGIC;
                signal W_op_mul :  STD_LOGIC;
                signal W_op_muli :  STD_LOGIC;
                signal W_op_mulxss :  STD_LOGIC;
                signal W_op_mulxsu :  STD_LOGIC;
                signal W_op_mulxuu :  STD_LOGIC;
                signal W_op_nextpc :  STD_LOGIC;
                signal W_op_nor :  STD_LOGIC;
                signal W_op_opx :  STD_LOGIC;
                signal W_op_or :  STD_LOGIC;
                signal W_op_orhi :  STD_LOGIC;
                signal W_op_ori :  STD_LOGIC;
                signal W_op_rdctl :  STD_LOGIC;
                signal W_op_ret :  STD_LOGIC;
                signal W_op_rol :  STD_LOGIC;
                signal W_op_roli :  STD_LOGIC;
                signal W_op_ror :  STD_LOGIC;
                signal W_op_rsv02 :  STD_LOGIC;
                signal W_op_rsv09 :  STD_LOGIC;
                signal W_op_rsv10 :  STD_LOGIC;
                signal W_op_rsv17 :  STD_LOGIC;
                signal W_op_rsv18 :  STD_LOGIC;
                signal W_op_rsv25 :  STD_LOGIC;
                signal W_op_rsv26 :  STD_LOGIC;
                signal W_op_rsv33 :  STD_LOGIC;
                signal W_op_rsv34 :  STD_LOGIC;
                signal W_op_rsv41 :  STD_LOGIC;
                signal W_op_rsv42 :  STD_LOGIC;
                signal W_op_rsv49 :  STD_LOGIC;
                signal W_op_rsv56 :  STD_LOGIC;
                signal W_op_rsv57 :  STD_LOGIC;
                signal W_op_rsv61 :  STD_LOGIC;
                signal W_op_rsv62 :  STD_LOGIC;
                signal W_op_rsv63 :  STD_LOGIC;
                signal W_op_rsvx00 :  STD_LOGIC;
                signal W_op_rsvx10 :  STD_LOGIC;
                signal W_op_rsvx15 :  STD_LOGIC;
                signal W_op_rsvx17 :  STD_LOGIC;
                signal W_op_rsvx20 :  STD_LOGIC;
                signal W_op_rsvx21 :  STD_LOGIC;
                signal W_op_rsvx25 :  STD_LOGIC;
                signal W_op_rsvx33 :  STD_LOGIC;
                signal W_op_rsvx34 :  STD_LOGIC;
                signal W_op_rsvx35 :  STD_LOGIC;
                signal W_op_rsvx42 :  STD_LOGIC;
                signal W_op_rsvx43 :  STD_LOGIC;
                signal W_op_rsvx44 :  STD_LOGIC;
                signal W_op_rsvx47 :  STD_LOGIC;
                signal W_op_rsvx50 :  STD_LOGIC;
                signal W_op_rsvx51 :  STD_LOGIC;
                signal W_op_rsvx55 :  STD_LOGIC;
                signal W_op_rsvx56 :  STD_LOGIC;
                signal W_op_rsvx60 :  STD_LOGIC;
                signal W_op_rsvx63 :  STD_LOGIC;
                signal W_op_sll :  STD_LOGIC;
                signal W_op_slli :  STD_LOGIC;
                signal W_op_sra :  STD_LOGIC;
                signal W_op_srai :  STD_LOGIC;
                signal W_op_srl :  STD_LOGIC;
                signal W_op_srli :  STD_LOGIC;
                signal W_op_stb :  STD_LOGIC;
                signal W_op_stbio :  STD_LOGIC;
                signal W_op_stc :  STD_LOGIC;
                signal W_op_sth :  STD_LOGIC;
                signal W_op_sthio :  STD_LOGIC;
                signal W_op_stw :  STD_LOGIC;
                signal W_op_stwio :  STD_LOGIC;
                signal W_op_sub :  STD_LOGIC;
                signal W_op_sync :  STD_LOGIC;
                signal W_op_trap :  STD_LOGIC;
                signal W_op_wrctl :  STD_LOGIC;
                signal W_op_xor :  STD_LOGIC;
                signal W_op_xorhi :  STD_LOGIC;
                signal W_op_xori :  STD_LOGIC;
                signal W_pcb :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal W_regnum_a_cmp_D :  STD_LOGIC;
                signal W_regnum_b_cmp_D :  STD_LOGIC;
                signal W_valid :  STD_LOGIC;
                signal W_vinst :  STD_LOGIC_VECTOR (263 DOWNTO 0);
                signal W_wr_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal W_wr_dst_reg :  STD_LOGIC;
                signal av_addr_accepted :  STD_LOGIC;
                signal av_rd_addr_accepted :  STD_LOGIC;
                signal av_wr_data_transfer :  STD_LOGIC;
                signal d_address_byte_field :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal d_address_byte_field_nxt :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal d_address_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal d_address_line_field_nxt :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal d_address_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal d_address_offset_field_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal d_address_tag_field :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal d_address_tag_field_nxt :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal d_byteenable_nxt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal d_read_nxt :  STD_LOGIC;
                signal d_readdata_d1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d_readdatavalid_d1 :  STD_LOGIC;
                signal d_write_nxt :  STD_LOGIC;
                signal d_writedata_nxt :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dc_data_rd_port_addr :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal dc_data_rd_port_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dc_data_rd_port_line_field :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal dc_data_rd_port_offset_field :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal dc_data_wr_port_addr :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal dc_data_wr_port_byte_en :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal dc_data_wr_port_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dc_data_wr_port_en :  STD_LOGIC;
                signal dc_line_dirty_off :  STD_LOGIC;
                signal dc_line_dirty_on :  STD_LOGIC;
                signal dc_line_valid_off :  STD_LOGIC;
                signal dc_line_valid_on :  STD_LOGIC;
                signal dc_tag_rd_port_addr :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal dc_tag_rd_port_data :  STD_LOGIC_VECTOR (14 DOWNTO 0);
                signal dc_tag_wr_port_addr :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal dc_tag_wr_port_data :  STD_LOGIC_VECTOR (14 DOWNTO 0);
                signal dc_tag_wr_port_en :  STD_LOGIC;
                signal hbreak_enabled :  STD_LOGIC;
                signal hbreak_req :  STD_LOGIC;
                signal i_read_nxt :  STD_LOGIC;
                signal i_readdata_d1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal i_readdatavalid_d1 :  STD_LOGIC;
                signal ic_fill_active :  STD_LOGIC;
                signal ic_fill_active_nxt :  STD_LOGIC;
                signal ic_fill_ap_cnt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal ic_fill_ap_cnt_nxt :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal ic_fill_ap_last_word :  STD_LOGIC;
                signal ic_fill_ap_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ic_fill_ap_offset_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ic_fill_done :  STD_LOGIC;
                signal ic_fill_dp_last_word :  STD_LOGIC;
                signal ic_fill_dp_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ic_fill_dp_offset_en :  STD_LOGIC;
                signal ic_fill_dp_offset_nxt :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ic_fill_initial_offset :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ic_fill_line :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal ic_fill_prevent_refill :  STD_LOGIC;
                signal ic_fill_prevent_refill_nxt :  STD_LOGIC;
                signal ic_fill_req_accepted :  STD_LOGIC;
                signal ic_fill_tag :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal ic_fill_valid_bit_new :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ic_fill_valid_bits :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ic_fill_valid_bits_en :  STD_LOGIC;
                signal ic_fill_valid_bits_nxt :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ic_tag_clr_valid_bits :  STD_LOGIC;
                signal ic_tag_clr_valid_bits_nxt :  STD_LOGIC;
                signal ic_tag_wraddress :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal ic_tag_wraddress_nxt :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal ic_tag_wrdata :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal ic_tag_wren :  STD_LOGIC;
                signal internal_d_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_d_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_d_read :  STD_LOGIC;
                signal internal_d_write :  STD_LOGIC;
                signal internal_d_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_i_address :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_i_read :  STD_LOGIC;
                signal internal_jtag_debug_module_debugaccess_to_roms :  STD_LOGIC;
                signal internal_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal internal_jtag_debug_offchip_trace_clk :  STD_LOGIC;
                signal internal_jtag_debug_offchip_trace_data :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal internal_jtag_debug_trigout :  STD_LOGIC;
                signal intr_req :  STD_LOGIC;
                signal latched_oci_tb_hbreak_req :  STD_LOGIC;
                signal latched_oci_tb_hbreak_req_next :  STD_LOGIC;
                signal module_input :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal oci_hbreak_req :  STD_LOGIC;
                signal oci_ienable :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal oci_single_step_mode :  STD_LOGIC;
                signal oci_tb_hbreak_req :  STD_LOGIC;
                signal reset_d1 :  STD_LOGIC;
                signal test_ending :  STD_LOGIC;
                signal test_has_ended :  STD_LOGIC;
                signal wait_for_one_post_bret_inst :  STD_LOGIC;
attribute ALTERA_IP_DEBUG_VISIBLE : boolean;
attribute ALTERA_IP_DEBUG_VISIBLE of A_iw : signal is true;
attribute ALTERA_IP_DEBUG_VISIBLE of A_pcb : signal is true;
attribute ALTERA_IP_DEBUG_VISIBLE of A_valid : signal is true;
  constant cpu_ic_data_lpm_file : string := "";
  --synthesis translate_off
constant cpu_ic_tag_lpm_file : string := "cpu_ic_tag_ram.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_ic_tag_lpm_file : string := "cpu_ic_tag_ram.mif";
--synthesis read_comments_as_HDL off

  --synthesis translate_off
constant cpu_bht_lpm_file : string := "cpu_bht_ram.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_bht_lpm_file : string := "cpu_bht_ram.mif";
--synthesis read_comments_as_HDL off

  --synthesis translate_off
constant cpu_register_bank_a_lpm_file : string := "cpu_rf_ram_a.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_register_bank_a_lpm_file : string := "cpu_rf_ram_a.mif";
--synthesis read_comments_as_HDL off

  --synthesis translate_off
constant cpu_register_bank_b_lpm_file : string := "cpu_rf_ram_b.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_register_bank_b_lpm_file : string := "cpu_rf_ram_b.mif";
--synthesis read_comments_as_HDL off

  --synthesis translate_off
constant cpu_dc_tag_lpm_file : string := "cpu_dc_tag_ram.hex";
--synthesis translate_on
--synthesis read_comments_as_HDL on
--constant cpu_dc_tag_lpm_file : string := "cpu_dc_tag_ram.mif";
--synthesis read_comments_as_HDL off

  constant cpu_dc_data_lpm_file : string := "";
  constant cpu_dc_victim_lpm_file : string := "";

begin

  --the_cpu_test_bench, which is an e_instance
  the_cpu_test_bench : cpu_test_bench
    port map(
      A_wr_data_filtered => A_wr_data_filtered,
      E_add_br_to_taken_history_filtered => E_add_br_to_taken_history_filtered,
      E_src1_eq_src2 => E_src1_eq_src2,
      M_bht_ptr_filtered => M_bht_ptr_filtered,
      M_bht_wr_data_filtered => M_bht_wr_data_filtered,
      M_bht_wr_en_filtered => M_bht_wr_en_filtered,
      test_has_ended => test_has_ended,
      A_bstatus_reg => A_bstatus_reg,
      A_cmp_result => A_cmp_result,
      A_ctrl_exception => A_ctrl_exception,
      A_ctrl_ld_non_bypass => A_ctrl_ld_non_bypass,
      A_dst_regnum => A_dst_regnum,
      A_en => A_en,
      A_estatus_reg => A_estatus_reg,
      A_ienable_reg => A_ienable_reg,
      A_ipending_reg => A_ipending_reg,
      A_iw => A_iw,
      A_mem_byte_en => A_mem_byte_en,
      A_op_hbreak => A_op_hbreak,
      A_op_intr => A_op_intr,
      A_pcb => A_pcb,
      A_st_data => A_st_data,
      A_status_reg => A_status_reg,
      A_valid => A_valid,
      A_wr_data_unfiltered => A_wr_data_unfiltered,
      A_wr_dst_reg => A_wr_dst_reg,
      E_add_br_to_taken_history_unfiltered => E_add_br_to_taken_history_unfiltered,
      E_logic_result => E_logic_result,
      E_valid => E_valid,
      M_bht_ptr_unfiltered => M_bht_ptr_unfiltered,
      M_bht_wr_data_unfiltered => M_bht_wr_data_unfiltered,
      M_bht_wr_en_unfiltered => M_bht_wr_en_unfiltered,
      M_mem_baddr => M_mem_baddr,
      M_target_pcb => M_target_pcb,
      M_valid => M_valid,
      W_dst_regnum => W_dst_regnum,
      W_iw => W_iw,
      W_iw_custom_n => W_iw_custom_n,
      W_iw_op => W_iw_op,
      W_iw_opx => W_iw_opx,
      W_pcb => W_pcb,
      W_valid => W_valid,
      W_vinst => W_vinst,
      W_wr_dst_reg => W_wr_dst_reg,
      clk => clk,
      d_address => internal_d_address,
      d_byteenable => internal_d_byteenable,
      d_read => internal_d_read,
      d_write => internal_d_write,
      i_address => internal_i_address,
      i_read => internal_i_read,
      i_readdatavalid => i_readdatavalid,
      reset_n => reset_n
    );


  F_iw_a <= F_iw(31 DOWNTO 27);
  F_iw_b <= F_iw(26 DOWNTO 22);
  F_iw_c <= F_iw(21 DOWNTO 17);
  F_iw_custom_n <= F_iw(13 DOWNTO 6);
  F_iw_custom_readra <= F_iw(16);
  F_iw_custom_readrb <= F_iw(15);
  F_iw_custom_writerc <= F_iw(14);
  F_iw_opx <= F_iw(16 DOWNTO 11);
  F_iw_op <= F_iw(5 DOWNTO 0);
  F_iw_shift_imm5 <= F_iw(10 DOWNTO 6);
  F_iw_trap_break_imm5 <= F_iw(10 DOWNTO 6);
  F_iw_imm5 <= F_iw(10 DOWNTO 6);
  F_iw_imm16 <= F_iw(21 DOWNTO 6);
  F_iw_imm26 <= F_iw(31 DOWNTO 6);
  F_iw_memsz <= F_iw(4 DOWNTO 3);
  F_iw_control_regnum <= F_iw(8 DOWNTO 6);
  F_mem8 <= to_std_logic((F_iw_memsz = std_logic_vector'("00")));
  F_mem16 <= to_std_logic((F_iw_memsz = std_logic_vector'("01")));
  F_mem32 <= to_std_logic((std_logic'(F_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  F_ram_iw_a <= F_ram_iw(31 DOWNTO 27);
  F_ram_iw_b <= F_ram_iw(26 DOWNTO 22);
  F_ram_iw_c <= F_ram_iw(21 DOWNTO 17);
  F_ram_iw_custom_n <= F_ram_iw(13 DOWNTO 6);
  F_ram_iw_custom_readra <= F_ram_iw(16);
  F_ram_iw_custom_readrb <= F_ram_iw(15);
  F_ram_iw_custom_writerc <= F_ram_iw(14);
  F_ram_iw_opx <= F_ram_iw(16 DOWNTO 11);
  F_ram_iw_op <= F_ram_iw(5 DOWNTO 0);
  F_ram_iw_shift_imm5 <= F_ram_iw(10 DOWNTO 6);
  F_ram_iw_trap_break_imm5 <= F_ram_iw(10 DOWNTO 6);
  F_ram_iw_imm5 <= F_ram_iw(10 DOWNTO 6);
  F_ram_iw_imm16 <= F_ram_iw(21 DOWNTO 6);
  F_ram_iw_imm26 <= F_ram_iw(31 DOWNTO 6);
  F_ram_iw_memsz <= F_ram_iw(4 DOWNTO 3);
  F_ram_iw_control_regnum <= F_ram_iw(8 DOWNTO 6);
  F_ram_mem8 <= to_std_logic((F_ram_iw_memsz = std_logic_vector'("00")));
  F_ram_mem16 <= to_std_logic((F_ram_iw_memsz = std_logic_vector'("01")));
  F_ram_mem32 <= to_std_logic((std_logic'(F_ram_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  D_iw_a <= D_iw(31 DOWNTO 27);
  D_iw_b <= D_iw(26 DOWNTO 22);
  D_iw_c <= D_iw(21 DOWNTO 17);
  D_iw_custom_n <= D_iw(13 DOWNTO 6);
  D_iw_custom_readra <= D_iw(16);
  D_iw_custom_readrb <= D_iw(15);
  D_iw_custom_writerc <= D_iw(14);
  D_iw_opx <= D_iw(16 DOWNTO 11);
  D_iw_op <= D_iw(5 DOWNTO 0);
  D_iw_shift_imm5 <= D_iw(10 DOWNTO 6);
  D_iw_trap_break_imm5 <= D_iw(10 DOWNTO 6);
  D_iw_imm5 <= D_iw(10 DOWNTO 6);
  D_iw_imm16 <= D_iw(21 DOWNTO 6);
  D_iw_imm26 <= D_iw(31 DOWNTO 6);
  D_iw_memsz <= D_iw(4 DOWNTO 3);
  D_iw_control_regnum <= D_iw(8 DOWNTO 6);
  D_mem8 <= to_std_logic((D_iw_memsz = std_logic_vector'("00")));
  D_mem16 <= to_std_logic((D_iw_memsz = std_logic_vector'("01")));
  D_mem32 <= to_std_logic((std_logic'(D_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  E_iw_a <= E_iw(31 DOWNTO 27);
  E_iw_b <= E_iw(26 DOWNTO 22);
  E_iw_c <= E_iw(21 DOWNTO 17);
  E_iw_custom_n <= E_iw(13 DOWNTO 6);
  E_iw_custom_readra <= E_iw(16);
  E_iw_custom_readrb <= E_iw(15);
  E_iw_custom_writerc <= E_iw(14);
  E_iw_opx <= E_iw(16 DOWNTO 11);
  E_iw_op <= E_iw(5 DOWNTO 0);
  E_iw_shift_imm5 <= E_iw(10 DOWNTO 6);
  E_iw_trap_break_imm5 <= E_iw(10 DOWNTO 6);
  E_iw_imm5 <= E_iw(10 DOWNTO 6);
  E_iw_imm16 <= E_iw(21 DOWNTO 6);
  E_iw_imm26 <= E_iw(31 DOWNTO 6);
  E_iw_memsz <= E_iw(4 DOWNTO 3);
  E_iw_control_regnum <= E_iw(8 DOWNTO 6);
  E_mem8 <= to_std_logic((E_iw_memsz = std_logic_vector'("00")));
  E_mem16 <= to_std_logic((E_iw_memsz = std_logic_vector'("01")));
  E_mem32 <= to_std_logic((std_logic'(E_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  M_iw_a <= M_iw(31 DOWNTO 27);
  M_iw_b <= M_iw(26 DOWNTO 22);
  M_iw_c <= M_iw(21 DOWNTO 17);
  M_iw_custom_n <= M_iw(13 DOWNTO 6);
  M_iw_custom_readra <= M_iw(16);
  M_iw_custom_readrb <= M_iw(15);
  M_iw_custom_writerc <= M_iw(14);
  M_iw_opx <= M_iw(16 DOWNTO 11);
  M_iw_op <= M_iw(5 DOWNTO 0);
  M_iw_shift_imm5 <= M_iw(10 DOWNTO 6);
  M_iw_trap_break_imm5 <= M_iw(10 DOWNTO 6);
  M_iw_imm5 <= M_iw(10 DOWNTO 6);
  M_iw_imm16 <= M_iw(21 DOWNTO 6);
  M_iw_imm26 <= M_iw(31 DOWNTO 6);
  M_iw_memsz <= M_iw(4 DOWNTO 3);
  M_iw_control_regnum <= M_iw(8 DOWNTO 6);
  M_mem8 <= to_std_logic((M_iw_memsz = std_logic_vector'("00")));
  M_mem16 <= to_std_logic((M_iw_memsz = std_logic_vector'("01")));
  M_mem32 <= to_std_logic((std_logic'(M_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  A_iw_a <= A_iw(31 DOWNTO 27);
  A_iw_b <= A_iw(26 DOWNTO 22);
  A_iw_c <= A_iw(21 DOWNTO 17);
  A_iw_custom_n <= A_iw(13 DOWNTO 6);
  A_iw_custom_readra <= A_iw(16);
  A_iw_custom_readrb <= A_iw(15);
  A_iw_custom_writerc <= A_iw(14);
  A_iw_opx <= A_iw(16 DOWNTO 11);
  A_iw_op <= A_iw(5 DOWNTO 0);
  A_iw_shift_imm5 <= A_iw(10 DOWNTO 6);
  A_iw_trap_break_imm5 <= A_iw(10 DOWNTO 6);
  A_iw_imm5 <= A_iw(10 DOWNTO 6);
  A_iw_imm16 <= A_iw(21 DOWNTO 6);
  A_iw_imm26 <= A_iw(31 DOWNTO 6);
  A_iw_memsz <= A_iw(4 DOWNTO 3);
  A_iw_control_regnum <= A_iw(8 DOWNTO 6);
  A_mem8 <= to_std_logic((A_iw_memsz = std_logic_vector'("00")));
  A_mem16 <= to_std_logic((A_iw_memsz = std_logic_vector'("01")));
  A_mem32 <= to_std_logic((std_logic'(A_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  W_iw_a <= W_iw(31 DOWNTO 27);
  W_iw_b <= W_iw(26 DOWNTO 22);
  W_iw_c <= W_iw(21 DOWNTO 17);
  W_iw_custom_n <= W_iw(13 DOWNTO 6);
  W_iw_custom_readra <= W_iw(16);
  W_iw_custom_readrb <= W_iw(15);
  W_iw_custom_writerc <= W_iw(14);
  W_iw_opx <= W_iw(16 DOWNTO 11);
  W_iw_op <= W_iw(5 DOWNTO 0);
  W_iw_shift_imm5 <= W_iw(10 DOWNTO 6);
  W_iw_trap_break_imm5 <= W_iw(10 DOWNTO 6);
  W_iw_imm5 <= W_iw(10 DOWNTO 6);
  W_iw_imm16 <= W_iw(21 DOWNTO 6);
  W_iw_imm26 <= W_iw(31 DOWNTO 6);
  W_iw_memsz <= W_iw(4 DOWNTO 3);
  W_iw_control_regnum <= W_iw(8 DOWNTO 6);
  W_mem8 <= to_std_logic((W_iw_memsz = std_logic_vector'("00")));
  W_mem16 <= to_std_logic((W_iw_memsz = std_logic_vector'("01")));
  W_mem32 <= to_std_logic((std_logic'(W_iw_memsz(1)) = std_logic'(std_logic'('1'))));
  F_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  F_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  F_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  F_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  F_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  F_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  F_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  F_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  F_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  F_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  F_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  F_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  F_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  F_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  F_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  F_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  F_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  F_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  F_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  F_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  F_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  F_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  F_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  F_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  F_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  F_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  F_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  F_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  F_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  F_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  F_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  F_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  F_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  F_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  F_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  F_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  F_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  F_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  F_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  F_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  F_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  F_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  F_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  F_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  F_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  F_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  F_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  F_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  F_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  F_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  F_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  F_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  F_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  F_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  F_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  F_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  F_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  F_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  F_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  F_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  F_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  F_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  F_op_eret <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  F_op_roli <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  F_op_rol <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  F_op_flushp <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  F_op_ret <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  F_op_nor <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  F_op_mulxuu <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  F_op_cmpge <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  F_op_bret <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  F_op_ror <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  F_op_flushi <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  F_op_jmp <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  F_op_and <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  F_op_cmplt <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  F_op_slli <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  F_op_sll <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  F_op_or <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  F_op_mulxsu <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  F_op_cmpne <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  F_op_srli <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  F_op_srl <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  F_op_nextpc <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  F_op_callr <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  F_op_xor <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  F_op_mulxss <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  F_op_cmpeq <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  F_op_divu <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  F_op_div <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  F_op_rdctl <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  F_op_mul <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  F_op_cmpgeu <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  F_op_initi <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  F_op_trap <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  F_op_wrctl <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  F_op_cmpltu <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  F_op_add <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  F_op_break <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  F_op_hbreak <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  F_op_sync <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  F_op_sub <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  F_op_srai <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  F_op_sra <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  F_op_intr <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  F_op_crst <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  F_op_rsvx00 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  F_op_rsvx10 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  F_op_rsvx15 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  F_op_rsvx17 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  F_op_rsvx20 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  F_op_rsvx21 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  F_op_rsvx25 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  F_op_rsvx33 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  F_op_rsvx34 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  F_op_rsvx35 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  F_op_rsvx42 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  F_op_rsvx43 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  F_op_rsvx44 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  F_op_rsvx47 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  F_op_rsvx50 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  F_op_rsvx51 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  F_op_rsvx55 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  F_op_rsvx56 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  F_op_rsvx60 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  F_op_rsvx63 <= F_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (F_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  F_op_bswap_s1 <= F_op_custom AND to_std_logic(((std_logic'(F_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  F_op_interrupt_vector_interrupt_vector <= F_op_custom AND to_std_logic(((std_logic'(F_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  F_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  F_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (F_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  D_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  D_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  D_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  D_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  D_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  D_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  D_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  D_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  D_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  D_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  D_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  D_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  D_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  D_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  D_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  D_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  D_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  D_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  D_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  D_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  D_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  D_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  D_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  D_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  D_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  D_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  D_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  D_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  D_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  D_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  D_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  D_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  D_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  D_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  D_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  D_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  D_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  D_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  D_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  D_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  D_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  D_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  D_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  D_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  D_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  D_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  D_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  D_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  D_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  D_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  D_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  D_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  D_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  D_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  D_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  D_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  D_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  D_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  D_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  D_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  D_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  D_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  D_op_eret <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  D_op_roli <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  D_op_rol <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  D_op_flushp <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  D_op_ret <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  D_op_nor <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  D_op_mulxuu <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  D_op_cmpge <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  D_op_bret <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  D_op_ror <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  D_op_flushi <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  D_op_jmp <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  D_op_and <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  D_op_cmplt <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  D_op_slli <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  D_op_sll <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  D_op_or <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  D_op_mulxsu <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  D_op_cmpne <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  D_op_srli <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  D_op_srl <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  D_op_nextpc <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  D_op_callr <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  D_op_xor <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  D_op_mulxss <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  D_op_cmpeq <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  D_op_divu <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  D_op_div <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  D_op_rdctl <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  D_op_mul <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  D_op_cmpgeu <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  D_op_initi <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  D_op_trap <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  D_op_wrctl <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  D_op_cmpltu <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  D_op_add <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  D_op_break <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  D_op_hbreak <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  D_op_sync <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  D_op_sub <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  D_op_srai <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  D_op_sra <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  D_op_intr <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  D_op_crst <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  D_op_rsvx00 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  D_op_rsvx10 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  D_op_rsvx15 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  D_op_rsvx17 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  D_op_rsvx20 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  D_op_rsvx21 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  D_op_rsvx25 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  D_op_rsvx33 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  D_op_rsvx34 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  D_op_rsvx35 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  D_op_rsvx42 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  D_op_rsvx43 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  D_op_rsvx44 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  D_op_rsvx47 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  D_op_rsvx50 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  D_op_rsvx51 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  D_op_rsvx55 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  D_op_rsvx56 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  D_op_rsvx60 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  D_op_rsvx63 <= D_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (D_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  D_op_bswap_s1 <= D_op_custom AND to_std_logic(((std_logic'(D_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  D_op_interrupt_vector_interrupt_vector <= D_op_custom AND to_std_logic(((std_logic'(D_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  D_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  D_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (D_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  E_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  E_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  E_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  E_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  E_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  E_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  E_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  E_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  E_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  E_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  E_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  E_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  E_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  E_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  E_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  E_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  E_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  E_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  E_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  E_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  E_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  E_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  E_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  E_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  E_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  E_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  E_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  E_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  E_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  E_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  E_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  E_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  E_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  E_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  E_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  E_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  E_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  E_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  E_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  E_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  E_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  E_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  E_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  E_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  E_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  E_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  E_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  E_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  E_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  E_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  E_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  E_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  E_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  E_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  E_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  E_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  E_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  E_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  E_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  E_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  E_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  E_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  E_op_eret <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  E_op_roli <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  E_op_rol <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  E_op_flushp <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  E_op_ret <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  E_op_nor <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  E_op_mulxuu <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  E_op_cmpge <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  E_op_bret <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  E_op_ror <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  E_op_flushi <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  E_op_jmp <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  E_op_and <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  E_op_cmplt <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  E_op_slli <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  E_op_sll <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  E_op_or <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  E_op_mulxsu <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  E_op_cmpne <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  E_op_srli <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  E_op_srl <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  E_op_nextpc <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  E_op_callr <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  E_op_xor <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  E_op_mulxss <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  E_op_cmpeq <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  E_op_divu <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  E_op_div <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  E_op_rdctl <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  E_op_mul <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  E_op_cmpgeu <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  E_op_initi <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  E_op_trap <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  E_op_wrctl <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  E_op_cmpltu <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  E_op_add <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  E_op_break <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  E_op_hbreak <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  E_op_sync <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  E_op_sub <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  E_op_srai <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  E_op_sra <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  E_op_intr <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  E_op_crst <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  E_op_rsvx00 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  E_op_rsvx10 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  E_op_rsvx15 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  E_op_rsvx17 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  E_op_rsvx20 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  E_op_rsvx21 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  E_op_rsvx25 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  E_op_rsvx33 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  E_op_rsvx34 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  E_op_rsvx35 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  E_op_rsvx42 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  E_op_rsvx43 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  E_op_rsvx44 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  E_op_rsvx47 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  E_op_rsvx50 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  E_op_rsvx51 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  E_op_rsvx55 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  E_op_rsvx56 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  E_op_rsvx60 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  E_op_rsvx63 <= E_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (E_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  E_op_bswap_s1 <= E_op_custom AND to_std_logic(((std_logic'(E_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  E_op_interrupt_vector_interrupt_vector <= E_op_custom AND to_std_logic(((std_logic'(E_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  E_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  E_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (E_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  M_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  M_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  M_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  M_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  M_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  M_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  M_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  M_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  M_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  M_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  M_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  M_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  M_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  M_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  M_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  M_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  M_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  M_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  M_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  M_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  M_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  M_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  M_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  M_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  M_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  M_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  M_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  M_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  M_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  M_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  M_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  M_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  M_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  M_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  M_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  M_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  M_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  M_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  M_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  M_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  M_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  M_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  M_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  M_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  M_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  M_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  M_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  M_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  M_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  M_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  M_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  M_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  M_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  M_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  M_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  M_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  M_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  M_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  M_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  M_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  M_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  M_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  M_op_eret <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  M_op_roli <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  M_op_rol <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  M_op_flushp <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  M_op_ret <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  M_op_nor <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  M_op_mulxuu <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  M_op_cmpge <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  M_op_bret <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  M_op_ror <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  M_op_flushi <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  M_op_jmp <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  M_op_and <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  M_op_cmplt <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  M_op_slli <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  M_op_sll <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  M_op_or <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  M_op_mulxsu <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  M_op_cmpne <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  M_op_srli <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  M_op_srl <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  M_op_nextpc <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  M_op_callr <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  M_op_xor <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  M_op_mulxss <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  M_op_cmpeq <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  M_op_divu <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  M_op_div <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  M_op_rdctl <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  M_op_mul <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  M_op_cmpgeu <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  M_op_initi <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  M_op_trap <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  M_op_wrctl <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  M_op_cmpltu <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  M_op_add <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  M_op_break <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  M_op_hbreak <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  M_op_sync <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  M_op_sub <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  M_op_srai <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  M_op_sra <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  M_op_intr <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  M_op_crst <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  M_op_rsvx00 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  M_op_rsvx10 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  M_op_rsvx15 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  M_op_rsvx17 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  M_op_rsvx20 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  M_op_rsvx21 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  M_op_rsvx25 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  M_op_rsvx33 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  M_op_rsvx34 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  M_op_rsvx35 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  M_op_rsvx42 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  M_op_rsvx43 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  M_op_rsvx44 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  M_op_rsvx47 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  M_op_rsvx50 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  M_op_rsvx51 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  M_op_rsvx55 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  M_op_rsvx56 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  M_op_rsvx60 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  M_op_rsvx63 <= M_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (M_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  M_op_bswap_s1 <= M_op_custom AND to_std_logic(((std_logic'(M_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  M_op_interrupt_vector_interrupt_vector <= M_op_custom AND to_std_logic(((std_logic'(M_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  M_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  M_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (M_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  A_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  A_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  A_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  A_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  A_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  A_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  A_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  A_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  A_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  A_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  A_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  A_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  A_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  A_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  A_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  A_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  A_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  A_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  A_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  A_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  A_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  A_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  A_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  A_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  A_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  A_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  A_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  A_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  A_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  A_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  A_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  A_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  A_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  A_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  A_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  A_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  A_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  A_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  A_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  A_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  A_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  A_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  A_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  A_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  A_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  A_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  A_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  A_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  A_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  A_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  A_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  A_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  A_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  A_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  A_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  A_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  A_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  A_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  A_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  A_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  A_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  A_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  A_op_eret <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  A_op_roli <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  A_op_rol <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  A_op_flushp <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  A_op_ret <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  A_op_nor <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  A_op_mulxuu <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  A_op_cmpge <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  A_op_bret <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  A_op_ror <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  A_op_flushi <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  A_op_jmp <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  A_op_and <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  A_op_cmplt <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  A_op_slli <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  A_op_sll <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  A_op_or <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  A_op_mulxsu <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  A_op_cmpne <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  A_op_srli <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  A_op_srl <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  A_op_nextpc <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  A_op_callr <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  A_op_xor <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  A_op_mulxss <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  A_op_cmpeq <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  A_op_divu <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  A_op_div <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  A_op_rdctl <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  A_op_mul <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  A_op_cmpgeu <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  A_op_initi <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  A_op_trap <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  A_op_wrctl <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  A_op_cmpltu <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  A_op_add <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  A_op_break <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  A_op_hbreak <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  A_op_sync <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  A_op_sub <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  A_op_srai <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  A_op_sra <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  A_op_intr <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  A_op_crst <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  A_op_rsvx00 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  A_op_rsvx10 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  A_op_rsvx15 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  A_op_rsvx17 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  A_op_rsvx20 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  A_op_rsvx21 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  A_op_rsvx25 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  A_op_rsvx33 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  A_op_rsvx34 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  A_op_rsvx35 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  A_op_rsvx42 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  A_op_rsvx43 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  A_op_rsvx44 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  A_op_rsvx47 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  A_op_rsvx50 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  A_op_rsvx51 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  A_op_rsvx55 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  A_op_rsvx56 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  A_op_rsvx60 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  A_op_rsvx63 <= A_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (A_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  A_op_bswap_s1 <= A_op_custom AND to_std_logic(((std_logic'(A_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  A_op_interrupt_vector_interrupt_vector <= A_op_custom AND to_std_logic(((std_logic'(A_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  A_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  A_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (A_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  W_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  W_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  W_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  W_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  W_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  W_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  W_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  W_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  W_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  W_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  W_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  W_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  W_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  W_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  W_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  W_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  W_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  W_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  W_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  W_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  W_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  W_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  W_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  W_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  W_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  W_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  W_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  W_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  W_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  W_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  W_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  W_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  W_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  W_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  W_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  W_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  W_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  W_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  W_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  W_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  W_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  W_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  W_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  W_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  W_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  W_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  W_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  W_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  W_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  W_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  W_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  W_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  W_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  W_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  W_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  W_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  W_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  W_op_rsv56 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  W_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  W_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  W_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  W_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  W_op_eret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  W_op_roli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  W_op_rol <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  W_op_flushp <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  W_op_ret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  W_op_nor <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  W_op_mulxuu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  W_op_cmpge <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  W_op_bret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  W_op_ror <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  W_op_flushi <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  W_op_jmp <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  W_op_and <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  W_op_cmplt <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  W_op_slli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  W_op_sll <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  W_op_or <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  W_op_mulxsu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  W_op_cmpne <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  W_op_srli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  W_op_srl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  W_op_nextpc <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  W_op_callr <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  W_op_xor <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  W_op_mulxss <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  W_op_cmpeq <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  W_op_divu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  W_op_div <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  W_op_rdctl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  W_op_mul <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  W_op_cmpgeu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  W_op_initi <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  W_op_trap <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  W_op_wrctl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  W_op_cmpltu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  W_op_add <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  W_op_break <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  W_op_hbreak <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  W_op_sync <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  W_op_sub <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  W_op_srai <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  W_op_sra <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  W_op_intr <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  W_op_crst <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  W_op_rsvx00 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  W_op_rsvx10 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  W_op_rsvx15 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  W_op_rsvx17 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  W_op_rsvx20 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  W_op_rsvx21 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  W_op_rsvx25 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  W_op_rsvx33 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  W_op_rsvx34 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  W_op_rsvx35 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  W_op_rsvx42 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  W_op_rsvx43 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  W_op_rsvx44 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  W_op_rsvx47 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  W_op_rsvx50 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  W_op_rsvx51 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  W_op_rsvx55 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  W_op_rsvx56 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  W_op_rsvx60 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  W_op_rsvx63 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  W_op_bswap_s1 <= W_op_custom AND to_std_logic(((std_logic'(W_iw_custom_n(0)) = std_logic'(std_logic'('0')))));
  W_op_interrupt_vector_interrupt_vector <= W_op_custom AND to_std_logic(((std_logic'(W_iw_custom_n(0)) = std_logic'(std_logic'('1')))));
  W_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  W_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  F_stall <= D_stall;
  F_en <= NOT F_stall;
  F_iw <= A_WE_StdLogicVector((std_logic'(((latched_oci_tb_hbreak_req AND hbreak_enabled))) = '1'), std_logic_vector'("00000000001111011010100000111010"), A_WE_StdLogicVector((std_logic'(std_logic'('0')) = '1'), std_logic_vector'("00000000000000011111000000111010"), A_WE_StdLogicVector((std_logic'((intr_req)) = '1'), std_logic_vector'("00000000001110111110100000111010"), F_ram_iw)));
  F_kill <= ((D_refetch OR M_pipe_flush) OR E_valid_jmp_indirect) OR ((((D_br_pred_taken OR D_ctrl_uncond_cti_non_br)) AND D_issue));
  F_br_taken_waddr_partial <= (std_logic_vector'("0") & (F_pc_plus_one(9 DOWNTO 0))) + (std_logic_vector'("0") & (F_ram_iw_imm16(11 DOWNTO 2)));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_inst_ram_hit <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_inst_ram_hit <= F_inst_ram_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_issue <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_issue <= F_issue;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_kill <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_kill <= F_kill;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_br_taken_waddr_partial <= std_logic_vector'("00000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_br_taken_waddr_partial <= F_br_taken_waddr_partial;
      end if;
    end if;

  end process;

  D_refetch <= NOT D_inst_ram_hit AND NOT D_kill;
  D_br_offset_sex <= A_REP(D_iw_imm16(15) , 16) & D_iw_imm16(15 DOWNTO 12);
  D_br_offset_remaining <= D_br_offset_sex(15 DOWNTO 0);
  D_br_taken_waddr <= A_EXT (Std_Logic_Vector'(((std_logic_vector'("0") & (((std_logic_vector'("0") & (D_pc_plus_one(25 DOWNTO 10))) + (std_logic_vector'("0") & (D_br_offset_remaining))))) + (std_logic_vector'("00000000000000000") & (A_TOSTDLOGICVECTOR(D_br_taken_waddr_partial(10))))) & D_br_taken_waddr_partial(9 DOWNTO 0)), 26);
  D_br_taken_baddr <= D_br_taken_waddr & std_logic_vector'("00");
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_br_taken_baddr <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_br_taken_baddr <= D_br_taken_baddr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_br_taken_baddr <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_br_taken_baddr <= E_br_taken_baddr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_br_taken_baddr <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_br_taken_baddr <= M_br_taken_baddr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_br_taken_baddr <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      W_br_taken_baddr <= A_br_taken_baddr;
    end if;

  end process;

  F_pcb_nxt <= F_pc_nxt & std_logic_vector'("00");
  F_pcb <= F_pc & std_logic_vector'("00");
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      F_pc <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(F_en) = '1' then 
        F_pc <= F_pc_nxt;
      end if;
    end if;

  end process;

  F_pc_plus_one <= A_EXT (((std_logic_vector'("0000000") & (F_pc)) + std_logic_vector'("000000000000000000000000000000001")), 26);
  F_ic_data_rd_addr_nxt <= F_pc_nxt(12 DOWNTO 0);
  --cpu_ic_data, which is an nios_dpram
  cpu_ic_data : cpu_ic_data_module
    generic map(
      lpm_file => cpu_ic_data_lpm_file
    )
    port map(
      q => F_ic_iw,
      data => i_readdata_d1,
      rdaddress => F_ic_data_rd_addr_nxt,
      rdclken => F_en,
      rdclock => clk,
      wraddress => module_input,
      wrclock => clk,
      wren => i_readdatavalid_d1
    );

  module_input <= ic_fill_line & ic_fill_dp_offset;

  F_ic_tag_rd_addr_nxt <= F_pc_nxt(12 DOWNTO 3);
  ic_tag_clr_valid_bits_nxt <= (((M_ctrl_invalidate_i AND M_valid)) OR D_ic_fill_starting) OR reset_d1;
  ic_fill_valid_bits_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(ic_tag_clr_valid_bits_nxt) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(D_ic_fill_starting_d1) = '1'), ic_fill_valid_bit_new, ((ic_fill_valid_bits OR ic_fill_valid_bit_new)))))), 8);
  ic_fill_valid_bits_en <= (ic_tag_clr_valid_bits_nxt OR D_ic_fill_starting_d1) OR i_readdatavalid_d1;
  ic_tag_wraddress_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(reset_d1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((M_ctrl_crst AND M_valid))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((M_ctrl_invalidate_i AND M_valid))) = '1'), M_alu_result(14 DOWNTO 5), A_WE_StdLogicVector((std_logic'(D_ic_fill_starting) = '1'), D_pc_line_field, ic_fill_line)))))), 10);
  ic_tag_wren <= ic_tag_clr_valid_bits OR i_readdatavalid_d1;
  ic_tag_wrdata <= ic_fill_tag & ic_fill_valid_bits;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      reset_d1 <= std_logic'('1');
    elsif clk'event and clk = '1' then
      reset_d1 <= std_logic'('0');
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_tag_clr_valid_bits <= std_logic'('1');
    elsif clk'event and clk = '1' then
      ic_tag_clr_valid_bits <= ic_tag_clr_valid_bits_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_valid_bits <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(ic_fill_valid_bits_en) = '1' then 
        ic_fill_valid_bits <= ic_fill_valid_bits_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_tag_wraddress <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      ic_tag_wraddress <= ic_tag_wraddress_nxt;
    end if;

  end process;

  --cpu_ic_tag, which is an nios_sdp_ram
  cpu_ic_tag : cpu_ic_tag_module
    generic map(
      lpm_file => cpu_ic_tag_lpm_file
    )
    port map(
      q => F_ic_tag_rd,
      clock => clk,
      data => ic_tag_wrdata,
      rdaddress => F_ic_tag_rd_addr_nxt,
      rden => F_en,
      wraddress => ic_tag_wraddress,
      wren => ic_tag_wren
    );


  F_ic_tag_field <= F_ic_tag_rd(20 DOWNTO 8);
  F_ic_valid_bits <= F_ic_tag_rd(7 DOWNTO 0);
  F_ic_desired_tag <= F_pc(25 DOWNTO 13);
  F_ic_valid <= A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("000"))), F_ic_valid_bits(0), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("001"))), F_ic_valid_bits(1), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("010"))), F_ic_valid_bits(2), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("011"))), F_ic_valid_bits(3), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("100"))), F_ic_valid_bits(4), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("101"))), F_ic_valid_bits(5), A_WE_StdLogic(((F_pc(2 DOWNTO 0) = std_logic_vector'("110"))), F_ic_valid_bits(6), F_ic_valid_bits(7))))))));
  F_ic_hit <= F_ic_valid AND to_std_logic(((F_ic_desired_tag = F_ic_tag_field)));
  F_pc_tag_field <= F_pc(25 DOWNTO 13);
  F_pc_line_field <= F_pc(12 DOWNTO 3);
  D_pc_tag_field <= D_pc(25 DOWNTO 13);
  D_pc_line_field <= D_pc(12 DOWNTO 3);
  D_pc_offset_field <= D_pc(2 DOWNTO 0);
  D_ic_want_fill_unfiltered <= (NOT D_inst_ram_hit AND NOT D_kill) AND NOT M_pipe_flush;
  ic_fill_prevent_refill_nxt <= D_ic_fill_starting OR ((ic_fill_prevent_refill AND NOT ((M_ctrl_invalidate_i AND M_valid))));
  F_ic_fill_same_tag_line <= to_std_logic((((F_pc_tag_field = ic_fill_tag)) AND ((F_pc_line_field = ic_fill_line))));
  D_ic_fill_ignore <= ic_fill_prevent_refill AND D_ic_fill_same_tag_line;
  D_ic_fill_starting <= (NOT ic_fill_active AND D_ic_want_fill) AND NOT D_ic_fill_ignore;
  ic_fill_done <= ic_fill_dp_last_word AND i_readdatavalid_d1;
  ic_fill_active_nxt <= D_ic_fill_starting OR ((ic_fill_active AND NOT ic_fill_done));
  ic_fill_dp_last_word <= to_std_logic((ic_fill_dp_offset_nxt = ic_fill_initial_offset));
  ic_fill_dp_offset_en <= D_ic_fill_starting_d1 OR i_readdatavalid_d1;
  ic_fill_dp_offset_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(D_ic_fill_starting_d1) = '1'), (std_logic_vector'("000000000000000000000000000000") & (ic_fill_initial_offset)), (((std_logic_vector'("000000000000000000000000000000") & (ic_fill_dp_offset)) + std_logic_vector'("000000000000000000000000000000001")))), 3);
  ic_fill_ap_offset_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(ic_fill_req_accepted) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (ic_fill_ap_offset)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(D_ic_fill_starting) = '1'), D_pc_offset_field, ic_fill_ap_offset)))), 3);
  ic_fill_ap_cnt_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(ic_fill_req_accepted) = '1'), (((std_logic_vector'("00000000000000000000000000000") & (ic_fill_ap_cnt)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(D_ic_fill_starting) = '1'), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000") & (ic_fill_ap_cnt)))))), 4);
  ic_fill_ap_last_word <= ic_fill_ap_cnt(3);
  ic_fill_req_accepted <= internal_i_read AND NOT i_waitrequest;
  i_read_nxt <= D_ic_fill_starting OR ((internal_i_read AND ((i_waitrequest OR NOT ic_fill_ap_last_word))));
  internal_i_address <= ic_fill_tag & ic_fill_line(9 DOWNTO 0) & ic_fill_ap_offset & std_logic_vector'("00");
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_ap_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      ic_fill_ap_offset <= ic_fill_ap_offset_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_ap_cnt <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      ic_fill_ap_cnt <= ic_fill_ap_cnt_nxt;
    end if;

  end process;

  ic_fill_valid_bit_new <= A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("000"))), std_logic_vector'("00000001"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("001"))), std_logic_vector'("00000010"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("010"))), std_logic_vector'("00000100"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("011"))), std_logic_vector'("00001000"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("100"))), std_logic_vector'("00010000"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("101"))), std_logic_vector'("00100000"), A_WE_StdLogicVector(((ic_fill_dp_offset_nxt = std_logic_vector'("110"))), std_logic_vector'("01000000"), std_logic_vector'("10000000"))))))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ic_fill_starting_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      D_ic_fill_starting_d1 <= D_ic_fill_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ic_fill_same_tag_line <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ic_fill_same_tag_line <= F_ic_fill_same_tag_line;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      ic_fill_active <= ic_fill_active_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_prevent_refill <= std_logic'('0');
    elsif clk'event and clk = '1' then
      ic_fill_prevent_refill <= ic_fill_prevent_refill_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_tag <= std_logic_vector'("0000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_ic_fill_starting) = '1' then 
        ic_fill_tag <= D_pc_tag_field;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_line <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_ic_fill_starting) = '1' then 
        ic_fill_line <= D_pc_line_field;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_initial_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_ic_fill_starting) = '1' then 
        ic_fill_initial_offset <= D_pc_offset_field;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ic_fill_dp_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(ic_fill_dp_offset_en) = '1' then 
        ic_fill_dp_offset <= ic_fill_dp_offset_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      i_readdata_d1 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      i_readdata_d1 <= i_readdata;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      i_readdatavalid_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      i_readdatavalid_d1 <= i_readdatavalid;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_i_read <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_i_read <= i_read_nxt;
    end if;

  end process;

  F_bht_ptr_nxt <= F_pc_nxt(7 DOWNTO 0) XOR M_br_cond_taken_history(7 DOWNTO 0);
  --cpu_bht, which is an nios_sdp_ram
  cpu_bht : cpu_bht_module
    generic map(
      lpm_file => cpu_bht_lpm_file
    )
    port map(
      q => F_bht_data,
      clock => clk,
      data => M_bht_wr_data_filtered,
      rdaddress => F_bht_ptr_nxt,
      rden => F_en,
      wraddress => M_bht_ptr_filtered,
      wren => M_bht_wr_en_filtered
    );


  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_bht_data <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_bht_data <= F_bht_data;
      end if;
    end if;

  end process;

  D_br_cond_pred_taken <= to_std_logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(D_bht_data(1)))) = std_logic_vector'("00000000000000000000000000000000")));
  D_br_pred_taken <= D_ctrl_br AND ((D_ctrl_br_uncond OR D_br_cond_pred_taken));
  D_br_pred_not_taken <= D_ctrl_br_cond AND NOT(D_br_cond_pred_taken);
  F_sel_instruction_master <= std_logic'('1');
  F_ram_iw <= F_ic_iw;
  F_inst_ram_hit <= ((F_ic_hit AND NOT (A_valid_crst))) OR NOT F_sel_instruction_master;
  F_issue <= F_inst_ram_hit AND NOT F_kill;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      F_bht_ptr <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(F_en) = '1' then 
        F_bht_ptr <= F_bht_ptr_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_bht_ptr <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_bht_ptr <= F_bht_ptr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_bht_data <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_bht_data <= D_bht_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_bht_ptr <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_bht_ptr <= D_bht_ptr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_bht_data <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_bht_data <= E_bht_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_bht_ptr_unfiltered <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_bht_ptr_unfiltered <= E_bht_ptr;
      end if;
    end if;

  end process;

  E_br_cond_pred_taken <= to_std_logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(E_bht_data(1)))) = std_logic_vector'("00000000000000000000000000000000")));
  E_br_actually_taken <= E_br_result;
  E_br_mispredict <= E_ctrl_br_cond AND to_std_logic(((std_logic'(E_br_cond_pred_taken) /= std_logic'(E_br_actually_taken))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_br_mispredict <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_br_mispredict <= E_br_mispredict;
      end if;
    end if;

  end process;

  E_br_cond_taken_history <= A_WE_StdLogicVector((std_logic'(E_add_br_to_taken_history_filtered) = '1'), Std_Logic_Vector'(M_br_cond_taken_history(6 DOWNTO 0) & A_ToStdLogicVector(E_br_actually_taken)), M_br_cond_taken_history);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_br_cond_taken_history <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_br_cond_taken_history <= E_br_cond_taken_history;
      end if;
    end if;

  end process;

  M_bht_wr_data_unfiltered <= A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("00") & A_ToStdLogicVector(std_logic'('0'))))), std_logic_vector'("01"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("00") & A_ToStdLogicVector(std_logic'('1'))))), std_logic_vector'("10"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("01") & A_ToStdLogicVector(std_logic'('0'))))), std_logic_vector'("01"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("01") & A_ToStdLogicVector(std_logic'('1'))))), std_logic_vector'("00"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("10") & A_ToStdLogicVector(std_logic'('0'))))), std_logic_vector'("11"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("10") & A_ToStdLogicVector(std_logic'('1'))))), std_logic_vector'("00"), A_WE_StdLogicVector(((((M_bht_data & A_ToStdLogicVector(((M_br_mispredict AND M_valid_from_E))))) = Std_Logic_Vector'(std_logic_vector'("11") & A_ToStdLogicVector(std_logic'('0'))))), std_logic_vector'("11"), std_logic_vector'("10"))))))));
  M_bht_wr_en_unfiltered <= M_ctrl_br_cond AND M_valid_from_E;
  E_add_br_to_taken_history_unfiltered <= E_ctrl_br_cond AND E_valid;
  F_iw_a_rf <= A_WE_StdLogicVector((std_logic'(D_en) = '1'), F_ram_iw_a, D_iw_a);
  F_iw_b_rf <= A_WE_StdLogicVector((std_logic'(D_en) = '1'), F_ram_iw_b, D_iw_b);
  --cpu_register_bank_a, which is an nios_sdp_ram
  cpu_register_bank_a : cpu_register_bank_a_module
    generic map(
      lpm_file => cpu_register_bank_a_lpm_file
    )
    port map(
      q => D_rf_a,
      clock => clk,
      data => A_wr_data_filtered,
      rdaddress => F_iw_a_rf,
      wraddress => A_dst_regnum,
      wren => A_wr_dst_reg
    );


  --cpu_register_bank_b, which is an nios_sdp_ram
  cpu_register_bank_b : cpu_register_bank_b_module
    generic map(
      lpm_file => cpu_register_bank_b_lpm_file
    )
    port map(
      q => D_rf_b,
      clock => clk,
      data => A_wr_data_filtered,
      rdaddress => F_iw_b_rf,
      wraddress => A_dst_regnum,
      wren => A_wr_dst_reg
    );


  E_mem_bypass_non_io <= E_arith_result(31);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_rd_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_rd_data <= M_dc_rd_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_actual_tag <= std_logic_vector'("0000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_actual_tag <= M_dc_actual_tag;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_hit <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_hit <= M_dc_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_valid_st_cache_hit <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_valid_st_cache_hit <= M_dc_valid_st_cache_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_valid_st_bypass_hit <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_valid_st_bypass_hit <= M_dc_valid_st_bypass_hit;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_potential_hazard_after_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_potential_hazard_after_st <= M_dc_potential_hazard_after_st;
      end if;
    end if;

  end process;

  M_ctrl_st_cache <= M_ctrl_st_non_bypass AND M_sel_data_master;
  M_ctrl_ld_st_cache <= M_ctrl_ld_st_non_bypass AND M_sel_data_master;
  E_mem_baddr_line_field <= E_mem_baddr(14 DOWNTO 5);
  E_mem_baddr_offset_field <= E_mem_baddr(4 DOWNTO 2);
  E_mem_baddr_line_offset_field <= E_mem_baddr(14 DOWNTO 2);
  E_mem_baddr_byte_field <= E_mem_baddr(1 DOWNTO 0);
  M_mem_baddr_line_field <= M_mem_baddr(14 DOWNTO 5);
  M_mem_baddr_offset_field <= M_mem_baddr(4 DOWNTO 2);
  M_mem_baddr_line_offset_field <= M_mem_baddr(14 DOWNTO 2);
  M_mem_baddr_byte_field <= M_mem_baddr(1 DOWNTO 0);
  A_mem_baddr_line_field <= A_mem_baddr(14 DOWNTO 5);
  A_mem_baddr_offset_field <= A_mem_baddr(4 DOWNTO 2);
  A_mem_baddr_line_offset_field <= A_mem_baddr(14 DOWNTO 2);
  A_mem_baddr_byte_field <= A_mem_baddr(1 DOWNTO 0);
  M_dc_st_wr_en <= (M_ctrl_st_cache AND M_valid) AND A_en;
  A_dc_dcache_management_wr_en <= (((A_ctrl_dc_index_inv OR ((A_ctrl_dc_addr_inv AND A_dc_hit)))) AND A_valid) AND A_en_d1;
  dc_tag_wr_port_data <= A_WE_StdLogicVector((std_logic'(A_dc_fill_starting_d1) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(A_ctrl_st) & A_ToStdLogicVector(dc_line_valid_on) & A_dc_desired_tag), A_WE_StdLogicVector((std_logic'(A_dc_dcache_management_wr_en) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(dc_line_dirty_off) & A_ToStdLogicVector(dc_line_valid_off) & M_dc_desired_tag), Std_Logic_Vector'(A_ToStdLogicVector(dc_line_dirty_on) & A_ToStdLogicVector(dc_line_valid_on) & M_dc_desired_tag)));
  dc_tag_wr_port_addr <= A_WE_StdLogicVector((std_logic'(((A_dc_fill_starting_d1 OR A_dc_dcache_management_wr_en))) = '1'), A_mem_baddr_line_field, M_mem_baddr_line_field);
  dc_tag_wr_port_en <= (A_dc_fill_starting_d1 OR A_dc_dcache_management_wr_en) OR M_dc_st_wr_en;
  dc_line_dirty_on <= std_logic'('1');
  dc_line_dirty_off <= std_logic'('0');
  dc_line_valid_on <= std_logic'('1');
  dc_line_valid_off <= std_logic'('0');
  M_dc_tag_entry <= dc_tag_rd_port_data;
  M_dc_dirty_raw <= M_dc_tag_entry(14);
  M_dc_valid <= M_dc_tag_entry(13);
  M_dc_actual_tag <= M_dc_tag_entry(12 DOWNTO 0);
  dc_tag_rd_port_addr <= A_WE_StdLogicVector((std_logic'(M_en) = '1'), E_mem_baddr_line_field, M_mem_baddr_line_field);
  --cpu_dc_tag, which is an nios_sdp_ram
  cpu_dc_tag : cpu_dc_tag_module
    generic map(
      lpm_file => cpu_dc_tag_lpm_file
    )
    port map(
      q => dc_tag_rd_port_data,
      clock => clk,
      data => dc_tag_wr_port_data,
      rdaddress => dc_tag_rd_port_addr,
      wraddress => dc_tag_wr_port_addr,
      wren => dc_tag_wr_port_en
    );


  M_dc_desired_tag <= M_mem_baddr(27 DOWNTO 15);
  A_dc_desired_tag <= A_mem_baddr(27 DOWNTO 15);
  M_dc_tag_match <= to_std_logic((M_dc_desired_tag = M_dc_actual_tag));
  M_dc_hit <= M_dc_tag_match AND M_dc_valid;
  M_dc_dirty <= M_dc_dirty_raw OR ((M_A_dc_line_match AND A_dc_valid_st_cache_hit));
  dc_data_rd_port_line_field <= A_WE_StdLogicVector((std_logic'(M_en) = '1'), E_mem_baddr_line_field, A_WE_StdLogicVector((std_logic'(A_dc_xfer_rd_addr_active) = '1'), A_mem_baddr_line_field, M_mem_baddr_line_field));
  dc_data_rd_port_offset_field <= A_WE_StdLogicVector((std_logic'(M_en) = '1'), E_mem_baddr_offset_field, A_WE_StdLogicVector((std_logic'(A_dc_xfer_rd_addr_active) = '1'), A_dc_xfer_rd_addr_offset, M_mem_baddr_offset_field));
  dc_data_rd_port_addr <= dc_data_rd_port_line_field & dc_data_rd_port_offset_field;
  M_dc_rd_data <= dc_data_rd_port_data;
  M_st_dc_wr_en <= (M_ctrl_st_cache AND M_valid) AND A_en;
  dc_data_wr_port_data <= A_WE_StdLogicVector((std_logic'(A_dc_fill_active) = '1'), A_dc_fill_wr_data, A_WE_StdLogicVector((std_logic'(A_dc_valid_st_bypass_hit_wr_en) = '1'), A_st_data, M_st_data));
  dc_data_wr_port_byte_en <= A_WE_StdLogicVector((std_logic'(A_dc_fill_active) = '1'), A_dc_fill_byte_en, A_WE_StdLogicVector((std_logic'(A_dc_valid_st_bypass_hit_wr_en) = '1'), A_mem_byte_en, M_mem_byte_en));
  dc_data_wr_port_addr <= A_WE_StdLogicVector((std_logic'(A_dc_fill_active) = '1'), (A_mem_baddr_line_field & A_dc_fill_dp_offset), A_WE_StdLogicVector((std_logic'(A_dc_valid_st_bypass_hit_wr_en) = '1'), A_mem_baddr_line_offset_field, M_mem_baddr_line_offset_field));
  dc_data_wr_port_en <= (A_WE_StdLogic((std_logic'(A_dc_fill_active) = '1'), d_readdatavalid_d1, M_st_dc_wr_en)) OR A_dc_valid_st_bypass_hit_wr_en;
  --cpu_dc_data, which is an nios_sdp_ram
  cpu_dc_data : cpu_dc_data_module
    generic map(
      lpm_file => cpu_dc_data_lpm_file
    )
    port map(
      q => dc_data_rd_port_data,
      byteenable => dc_data_wr_port_byte_en,
      clock => clk,
      data => dc_data_wr_port_data,
      rdaddress => dc_data_rd_port_addr,
      wraddress => dc_data_wr_port_addr,
      wren => dc_data_wr_port_en
    );


  E_M_dc_line_offset_match <= to_std_logic((E_mem_baddr_line_offset_field = M_mem_baddr_line_offset_field));
  M_A_dc_line_match <= to_std_logic((M_mem_baddr_line_field = A_mem_baddr_line_field));
  M_dc_valid_st_cache_hit <= (M_valid AND M_ctrl_st_cache) AND M_dc_hit;
  M_dc_valid_st_bypass_hit <= (M_valid AND M_ctrl_st_bypass) AND M_dc_hit;
  --cpu_dc_victim, which is an nios_sdp_ram
  cpu_dc_victim : cpu_dc_victim_module
    generic map(
      lpm_file => cpu_dc_victim_lpm_file
    )
    port map(
      q => A_dc_wb_rd_data,
      clock => clk,
      data => A_dc_xfer_wr_data,
      rdaddress => A_dc_wb_rd_addr_offset,
      rden => A_dc_wb_en,
      wraddress => A_dc_xfer_wr_offset,
      wren => A_dc_xfer_wr_active
    );


  M_dc_want_fill <= (M_valid AND M_ctrl_ld_st_cache) AND NOT M_dc_hit;
  A_dc_fill_starting <= (A_dc_want_fill AND NOT A_dc_fill_has_started) AND NOT A_dc_wb_active;
  A_dc_fill_has_started_nxt <= A_WE_StdLogic((std_logic'(A_en) = '1'), std_logic'('0'), ((A_dc_fill_starting OR A_dc_fill_has_started)));
  A_dc_fill_need_extra_stall_nxt <= (M_valid_mem_d1 AND M_A_dc_line_match_d1) AND to_std_logic(((std_logic_vector'("00000000000000000000000000000") & (M_mem_baddr_offset_field)) = std_logic_vector'("00000000000000000000000000000111")));
  A_dc_fill_done <= A_WE_StdLogic((std_logic'(A_dc_fill_need_extra_stall) = '1'), A_dc_rd_last_transfer_d1, A_dc_rd_last_transfer);
  A_dc_fill_active_nxt <= A_WE_StdLogic((std_logic'(A_dc_fill_active) = '1'), NOT A_dc_fill_done, A_dc_fill_starting);
  A_dc_fill_want_dmaster <= A_dc_fill_starting OR A_dc_fill_active;
  A_dc_fill_dp_offset_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(A_dc_fill_starting) = '1'), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("000000000000000000000000000000") & (A_dc_fill_dp_offset)) + std_logic_vector'("000000000000000000000000000000001")))), 3);
  A_dc_fill_dp_offset_en <= A_dc_fill_starting OR d_readdatavalid_d1;
  A_dc_fill_miss_offset_is_next <= A_dc_fill_active AND to_std_logic(((A_dc_fill_dp_offset = A_mem_baddr_offset_field)));
  A_dc_fill_byte_en <= A_WE_StdLogicVector((std_logic'(((A_ctrl_st AND A_dc_fill_miss_offset_is_next))) = '1'), NOT A_mem_byte_en, A_REP(std_logic'('1'), 4));
  A_dc_fill_wr_data <= d_readdata_d1;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_want_fill <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_want_fill <= M_dc_want_fill;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_fill_has_started <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_fill_has_started <= A_dc_fill_has_started_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_fill_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_fill_active <= A_dc_fill_active_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_fill_dp_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_dc_fill_dp_offset_en) = '1' then 
        A_dc_fill_dp_offset <= A_dc_fill_dp_offset_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_fill_starting_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_fill_starting_d1 <= A_dc_fill_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_valid_mem_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      M_valid_mem_d1 <= M_ctrl_ld_st AND M_valid;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_A_dc_line_match_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      M_A_dc_line_match_d1 <= M_A_dc_line_match;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_fill_need_extra_stall <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_fill_need_extra_stall <= A_dc_fill_need_extra_stall_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_rd_last_transfer_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_rd_last_transfer_d1 <= A_dc_rd_last_transfer;
    end if;

  end process;

  A_dc_wb_active_nxt <= A_WE_StdLogic((std_logic'(A_dc_wb_active) = '1'), NOT A_dc_wr_last_transfer, A_dc_xfer_rd_addr_starting);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_wb_active <= A_dc_wb_active_nxt;
    end if;

  end process;

  A_dc_fill_want_xfer <= A_dc_want_fill AND A_dc_dirty;
  A_dc_index_wb_inv_want_xfer <= (A_ctrl_dc_index_wb_inv AND A_valid) AND A_dc_dirty;
  A_dc_dc_addr_wb_inv_want_xfer <= ((A_ctrl_dc_addr_wb_inv AND A_valid) AND A_dc_dirty) AND A_dc_hit;
  A_dc_want_xfer <= (A_dc_fill_want_xfer OR A_dc_index_wb_inv_want_xfer) OR A_dc_dc_addr_wb_inv_want_xfer;
  A_dc_xfer_rd_addr_starting <= (A_dc_want_xfer AND NOT A_dc_xfer_rd_addr_has_started) AND NOT A_dc_wb_active;
  A_dc_xfer_rd_addr_has_started_nxt <= A_WE_StdLogic((std_logic'(A_en) = '1'), std_logic'('0'), ((A_dc_xfer_rd_addr_starting OR A_dc_xfer_rd_addr_has_started)));
  A_dc_xfer_rd_addr_done_nxt <= A_dc_xfer_rd_addr_active AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (A_dc_xfer_rd_addr_offset)) = ((std_logic_vector'("000000000000000000000000000000111") - std_logic_vector'("000000000000000000000000000000001"))))));
  A_dc_xfer_rd_addr_active_nxt <= A_WE_StdLogic((std_logic'(A_dc_xfer_rd_addr_active) = '1'), NOT A_dc_xfer_rd_addr_done, A_dc_xfer_rd_addr_starting);
  A_dc_xfer_rd_addr_offset_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(A_dc_xfer_rd_addr_starting) = '1'), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("000000000000000000000000000000") & (A_dc_xfer_rd_addr_offset)) + std_logic_vector'("000000000000000000000000000000001")))), 3);
  A_dc_xfer_rd_addr_offset_match <= A_ctrl_st AND to_std_logic(((A_dc_xfer_rd_addr_offset = A_mem_baddr_offset_field)));
  A_dc_xfer_wr_data_nxt <= A_WE_StdLogicVector((std_logic'(A_dc_xfer_rd_data_offset_match) = '1'), A_dc_rd_data, dc_data_rd_port_data);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_dirty <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dc_dirty <= M_dc_dirty;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_addr_has_started <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_addr_has_started <= A_dc_xfer_rd_addr_has_started_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_addr_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_addr_active <= A_dc_xfer_rd_addr_active_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_addr_done <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_addr_done <= A_dc_xfer_rd_addr_done_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_addr_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_addr_offset <= A_dc_xfer_rd_addr_offset_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_data_starting <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_data_starting <= A_dc_xfer_rd_addr_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_data_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_data_active <= A_dc_xfer_rd_addr_active;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_data_offset_match <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_data_offset_match <= A_dc_xfer_rd_addr_offset_match;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_rd_data_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      A_dc_xfer_rd_data_offset <= A_dc_xfer_rd_addr_offset;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_wr_starting <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_wr_starting <= A_dc_xfer_rd_data_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_wr_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_xfer_wr_active <= A_dc_xfer_rd_data_active;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_wr_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      A_dc_xfer_wr_data <= A_dc_xfer_wr_data_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_xfer_wr_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      A_dc_xfer_wr_offset <= A_dc_xfer_rd_data_offset;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_tag <= std_logic_vector'("0000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_dc_xfer_rd_data_starting) = '1' then 
        A_dc_wb_tag <= A_dc_actual_tag;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_line <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_dc_xfer_rd_data_starting) = '1' then 
        A_dc_wb_line <= A_mem_baddr_line_field;
      end if;
    end if;

  end process;

  A_dc_wb_en <= ((av_wr_data_transfer OR A_dc_wb_rd_addr_starting) OR A_dc_wb_rd_data_starting) OR A_dc_wb_wr_starting;
  A_dc_wb_rd_addr_offset_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(A_dc_wb_rd_addr_starting) = '1'), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("000000000000000000000000000000") & (A_dc_wb_rd_addr_offset)) + std_logic_vector'("000000000000000000000000000000001")))), 3);
  A_dc_wb_wr_starting <= A_dc_wb_rd_data_first AND NOT internal_d_read;
  A_dc_wb_wr_active_nxt <= A_WE_StdLogic((std_logic'(A_dc_wb_wr_active) = '1'), NOT A_dc_wr_last_transfer, A_dc_wb_wr_starting);
  A_dc_wb_wr_want_dmaster <= A_dc_wb_wr_starting OR A_dc_wb_wr_active;
  A_dc_wb_rd_data_first_nxt <= A_WE_StdLogic((std_logic'(A_dc_wb_rd_data_first) = '1'), NOT A_dc_wb_wr_starting, A_dc_wb_rd_data_starting);
  A_dc_wb_update_av_writedata <= A_dc_wb_wr_starting OR (((A_dc_wb_wr_active AND NOT A_dc_wr_last_driven) AND NOT d_waitrequest));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_rd_addr_starting <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_wb_rd_addr_starting <= A_dc_xfer_wr_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_rd_addr_offset <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_dc_wb_en) = '1' then 
        A_dc_wb_rd_addr_offset <= A_dc_wb_rd_addr_offset_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_rd_data_starting <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_wb_rd_data_starting <= A_dc_wb_rd_addr_starting;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_wr_active <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_wb_wr_active <= A_dc_wb_wr_active_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wb_rd_data_first <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_wb_rd_data_first <= A_dc_wb_rd_data_first_nxt;
    end if;

  end process;

  A_dc_index_wb_inv_done_nxt <= NOT A_dc_dirty OR A_dc_xfer_rd_addr_done;
  A_dc_dc_addr_wb_inv_done_nxt <= (NOT A_dc_dirty OR A_dc_xfer_rd_addr_done) OR NOT A_dc_hit;
  A_dc_dcache_management_done_nxt <= (A_valid AND NOT A_en) AND (((A_ctrl_dc_nowb_inv OR ((A_ctrl_dc_index_wb_inv AND A_dc_index_wb_inv_done_nxt))) OR ((A_ctrl_dc_addr_wb_inv AND A_dc_dc_addr_wb_inv_done_nxt))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_dcache_management_done <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_dc_dcache_management_done <= A_dc_dcache_management_done_nxt;
    end if;

  end process;

  M_dc_want_mem_bypass_or_dcache_management <= M_valid AND M_ctrl_ld_st_bypass_or_dcache_management;
  A_ld_bypass_done <= A_dc_rd_last_transfer;
  A_st_bypass_transfer_done <= A_dc_wr_last_transfer AND NOT A_dc_wb_active;
  A_st_bypass_done <= A_WE_StdLogic((std_logic'(A_dc_valid_st_bypass_hit) = '1'), A_st_bypass_transfer_done_d1, A_st_bypass_transfer_done);
  A_mem_bypass_pending <= (A_ctrl_ld_st_bypass AND A_valid) AND NOT A_en;
  A_dc_valid_st_bypass_hit_wr_en <= A_dc_valid_st_bypass_hit AND A_en_d1;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_bypass_delayed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ld_bypass_delayed <= (M_ctrl_ld_bypass AND M_valid) AND A_dc_wb_active;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_st_bypass_delayed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_st_bypass_delayed <= (M_ctrl_st_bypass AND M_valid) AND A_dc_wb_active;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_bypass_delayed_started <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_ld_bypass_delayed_started <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(A_en) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((A_ld_bypass_delayed AND NOT A_dc_wb_active)) OR A_ld_bypass_delayed_started)))))));
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_st_bypass_delayed_started <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_st_bypass_delayed_started <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(A_en) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((A_st_bypass_delayed AND NOT A_dc_wb_active)) OR A_st_bypass_delayed_started)))))));
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_st_bypass_transfer_done_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_st_bypass_transfer_done_d1 <= A_st_bypass_transfer_done;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_en_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_en_d1 <= A_en;
    end if;

  end process;

  d_address_tag_field_nxt <= A_WE_StdLogicVector((std_logic'(A_dc_wb_wr_want_dmaster) = '1'), A_dc_wb_tag, A_WE_StdLogicVector((std_logic'(((A_dc_fill_want_dmaster OR A_mem_bypass_pending))) = '1'), A_dc_desired_tag, M_dc_desired_tag));
  d_address_line_field_nxt <= A_WE_StdLogicVector((std_logic'(A_dc_wb_wr_want_dmaster) = '1'), A_dc_wb_line, A_WE_StdLogicVector((std_logic'(((A_dc_fill_want_dmaster OR A_mem_bypass_pending))) = '1'), A_mem_baddr_line_field, M_mem_baddr_line_field));
  d_address_byte_field_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(((A_dc_wb_wr_want_dmaster OR A_dc_fill_want_dmaster))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(A_mem_bypass_pending) = '1'), A_mem_baddr_byte_field, M_mem_baddr_byte_field)))), 2);
  d_byteenable_nxt <= A_WE_StdLogicVector((std_logic'(((A_dc_wb_wr_want_dmaster OR A_dc_fill_want_dmaster))) = '1'), A_REP(std_logic'('1'), 4), A_WE_StdLogicVector((std_logic'(A_mem_bypass_pending) = '1'), A_mem_byte_en, M_mem_byte_en));
  d_writedata_nxt <= A_WE_StdLogicVector((std_logic'(A_dc_wb_update_av_writedata) = '1'), A_dc_wb_rd_data, A_WE_StdLogicVector((std_logic'(A_dc_wb_wr_active) = '1'), internal_d_writedata, A_WE_StdLogicVector((std_logic'(A_mem_bypass_pending) = '1'), A_st_data, M_st_data)));
  d_write_nxt <= ((A_dc_wb_wr_starting OR ((((M_ctrl_st_bypass AND M_valid) AND A_en) AND NOT A_dc_wb_active))) OR (((A_st_bypass_delayed AND NOT A_st_bypass_delayed_started) AND NOT A_dc_wb_active))) OR ((internal_d_write AND ((d_waitrequest OR NOT A_dc_wr_last_driven))));
  internal_d_address <= d_address_tag_field & d_address_line_field(9 DOWNTO 0) & d_address_offset_field & d_address_byte_field;
  M_dc_potential_hazard_after_st <= (((E_M_dc_line_offset_match AND M_ctrl_st_cache) AND M_valid) AND E_ctrl_mem) AND E_valid;
  A_mem_stall_start_nxt <= A_en AND (((M_dc_want_fill OR M_dc_want_mem_bypass_or_dcache_management) OR M_dc_potential_hazard_after_st));
  A_mem_stall_stop_nxt <= (((((A_dc_fill_active AND A_dc_fill_done)) OR (A_dc_dcache_management_done)) OR ((A_ctrl_ld_bypass AND A_ld_bypass_done))) OR ((A_ctrl_st_bypass AND A_st_bypass_done))) OR ((A_dc_potential_hazard_after_st AND A_dc_valid_st_cache_hit));
  A_mem_stall_nxt <= A_WE_StdLogic((std_logic'(A_mem_stall) = '1'), NOT A_mem_stall_stop_nxt, A_mem_stall_start_nxt);
  A_dc_rd_data_cnt_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(d_readdatavalid_d1) = '1'), (((std_logic_vector'("00000000000000000000000000000") & (A_dc_rd_data_cnt)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(A_dc_fill_starting) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(A_dc_fill_active) = '1'), (std_logic_vector'("0000000000000000000000000000") & (A_dc_rd_data_cnt)), std_logic_vector'("00000000000000000000000000001000")))))), 4);
  A_dc_rd_last_transfer <= A_dc_rd_data_cnt(3) AND d_readdatavalid_d1;
  av_wr_data_transfer <= internal_d_write AND NOT d_waitrequest;
  A_dc_wr_data_cnt_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(av_wr_data_transfer) = '1'), (((std_logic_vector'("00000000000000000000000000000") & (A_dc_wr_data_cnt)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(A_dc_wb_wr_starting) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(A_dc_wb_wr_active) = '1'), (std_logic_vector'("0000000000000000000000000000") & (A_dc_wr_data_cnt)), std_logic_vector'("00000000000000000000000000001000")))))), 4);
  A_dc_wr_last_driven <= A_dc_wr_data_cnt(3);
  A_dc_wr_last_transfer <= (A_dc_wr_last_driven AND internal_d_write) AND NOT d_waitrequest;
  av_addr_accepted <= ((internal_d_read OR internal_d_write)) AND NOT d_waitrequest;
  d_address_offset_field_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(av_addr_accepted) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (d_address_offset_field)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(((A_dc_wb_wr_starting OR A_dc_fill_starting))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("00000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((A_dc_wb_wr_active OR A_dc_fill_active))) = '1'), d_address_offset_field, A_WE_StdLogicVector((std_logic'(A_mem_bypass_pending) = '1'), A_mem_baddr_offset_field, M_mem_baddr_offset_field)))))))), 3);
  d_read_nxt <= ((A_dc_fill_starting OR ((((M_ctrl_ld_bypass AND M_valid) AND A_en) AND NOT A_dc_wb_active))) OR (((A_ld_bypass_delayed AND NOT A_ld_bypass_delayed_started) AND NOT A_dc_wb_active))) OR ((internal_d_read AND ((d_waitrequest OR NOT A_dc_rd_last_driven))));
  av_rd_addr_accepted <= internal_d_read AND NOT d_waitrequest;
  A_dc_rd_addr_cnt_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(av_rd_addr_accepted) = '1'), (((std_logic_vector'("00000000000000000000000000000") & (A_dc_rd_addr_cnt)) + std_logic_vector'("000000000000000000000000000000001"))), (std_logic_vector'("0") & (A_WE_StdLogicVector((std_logic'(A_dc_fill_starting) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(A_dc_fill_active) = '1'), (std_logic_vector'("0000000000000000000000000000") & (A_dc_rd_addr_cnt)), std_logic_vector'("00000000000000000000000000001000")))))), 4);
  A_dc_rd_last_driven <= A_dc_rd_addr_cnt(3);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_rd_addr_cnt <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      A_dc_rd_addr_cnt <= A_dc_rd_addr_cnt_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_address_tag_field <= std_logic_vector'("0000000000000");
    elsif clk'event and clk = '1' then
      d_address_tag_field <= d_address_tag_field_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_address_line_field <= std_logic_vector'("0000000000");
    elsif clk'event and clk = '1' then
      d_address_line_field <= d_address_line_field_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_address_offset_field <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      d_address_offset_field <= d_address_offset_field_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_address_byte_field <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      d_address_byte_field <= d_address_byte_field_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_d_byteenable <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      internal_d_byteenable <= d_byteenable_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_d_writedata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      internal_d_writedata <= d_writedata_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_mem_stall <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_mem_stall <= A_mem_stall_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_rd_data_cnt <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      A_dc_rd_data_cnt <= A_dc_rd_data_cnt_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dc_wr_data_cnt <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      A_dc_wr_data_cnt <= A_dc_wr_data_cnt_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_readdata_d1 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      d_readdata_d1 <= d_readdata;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_d_write <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_d_write <= d_write_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_d_read <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_d_read <= d_read_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d_readdatavalid_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d_readdatavalid_d1 <= d_readdatavalid;
    end if;

  end process;

  A_slow_ld_data_unaligned <= d_readdata_d1;
  A_slow_ld_data_sign_bit_16 <= A_WE_StdLogicVector((std_logic'(A_mem_baddr(1)) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(A_slow_ld_data_unaligned(31)) & A_ToStdLogicVector(A_slow_ld_data_unaligned(23))), Std_Logic_Vector'(A_ToStdLogicVector(A_slow_ld_data_unaligned(15)) & A_ToStdLogicVector(A_slow_ld_data_unaligned(7))));
  A_slow_ld_data_sign_bit <= A_WE_StdLogic((std_logic'((((A_mem_baddr(0)) OR A_ctrl_ld16))) = '1'), A_slow_ld_data_sign_bit_16(1), A_slow_ld_data_sign_bit_16(0));
  A_slow_ld_data_fill_bit <= A_slow_ld_data_sign_bit AND A_ctrl_ld_signed;
  A_slow_ld16_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_sh16) = '1'), A_slow_ld_data_unaligned(31 DOWNTO 16), A_slow_ld_data_unaligned(15 DOWNTO 0));
  A_slow_ld_byte0_data_aligned_nxt <= A_WE_StdLogicVector((std_logic'(A_ld_align_sh8) = '1'), A_slow_ld16_data(15 DOWNTO 8), A_slow_ld16_data(7 DOWNTO 0));
  A_slow_ld_byte1_data_aligned_nxt <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte1_fill) = '1'), A_REP(A_slow_ld_data_fill_bit, 8), A_slow_ld16_data(15 DOWNTO 8));
  A_slow_ld_byte2_data_aligned_nxt <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte2_byte3_fill) = '1'), A_REP(A_slow_ld_data_fill_bit, 8), A_slow_ld_data_unaligned(23 DOWNTO 16));
  A_slow_ld_byte3_data_aligned_nxt <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte2_byte3_fill) = '1'), A_REP(A_slow_ld_data_fill_bit, 8), A_slow_ld_data_unaligned(31 DOWNTO 24));
  A_slow_ld_data_aligned_nxt <= A_slow_ld_byte3_data_aligned_nxt & A_slow_ld_byte2_data_aligned_nxt & A_slow_ld_byte1_data_aligned_nxt & A_slow_ld_byte0_data_aligned_nxt;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_data_ram_ld_align_sign_bit_16_hi <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_data_ram_ld_align_sign_bit_16_hi <= (E_mem_baddr(0)) OR E_ctrl_ld16;
      end if;
    end if;

  end process;

  M_data_ram_ld_align_sign_bit_16 <= A_WE_StdLogicVector((std_logic'(M_mem_baddr(1)) = '1'), Std_Logic_Vector'(A_ToStdLogicVector(M_ram_rd_data(31)) & A_ToStdLogicVector(M_ram_rd_data(23))), Std_Logic_Vector'(A_ToStdLogicVector(M_ram_rd_data(15)) & A_ToStdLogicVector(M_ram_rd_data(7))));
  M_data_ram_ld_align_sign_bit <= A_WE_StdLogic((std_logic'(M_data_ram_ld_align_sign_bit_16_hi) = '1'), M_data_ram_ld_align_sign_bit_16(1), M_data_ram_ld_align_sign_bit_16(0));
  A_data_ram_ld_align_fill_bit <= A_data_ram_ld_align_sign_bit AND A_ctrl_ld_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_data_ram_ld_align_sign_bit <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_data_ram_ld_align_sign_bit <= M_data_ram_ld_align_sign_bit;
      end if;
    end if;

  end process;

  A_data_ram_ld16_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_sh16) = '1'), A_inst_result(31 DOWNTO 16), A_inst_result(15 DOWNTO 0));
  A_data_ram_ld_byte0_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_sh8) = '1'), A_data_ram_ld16_data(15 DOWNTO 8), A_data_ram_ld16_data(7 DOWNTO 0));
  A_data_ram_ld_byte1_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte1_fill) = '1'), A_REP(A_data_ram_ld_align_fill_bit, 8), A_data_ram_ld16_data(15 DOWNTO 8));
  A_data_ram_ld_byte2_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte2_byte3_fill) = '1'), A_REP(A_data_ram_ld_align_fill_bit, 8), A_inst_result(23 DOWNTO 16));
  A_data_ram_ld_byte3_data <= A_WE_StdLogicVector((std_logic'(A_ld_align_byte2_byte3_fill) = '1'), A_REP(A_data_ram_ld_align_fill_bit, 8), A_inst_result(31 DOWNTO 24));
  A_inst_result_aligned <= A_data_ram_ld_byte3_data & A_data_ram_ld_byte2_data & A_data_ram_ld_byte1_data & A_data_ram_ld_byte0_data;
  E_arith_src1 <= Std_Logic_Vector'(A_ToStdLogicVector((E_src1(31) XOR E_ctrl_alu_signed_comparison)) & E_src1(30 DOWNTO 0));
  E_arith_src2 <= Std_Logic_Vector'(A_ToStdLogicVector((E_src2(31) XOR E_ctrl_alu_signed_comparison)) & E_src2(30 DOWNTO 0));
  E_arith_result <= A_WE_StdLogicVector((std_logic'(E_ctrl_alu_subtract) = '1'), ((std_logic_vector'("0") & (E_arith_src1)) - (std_logic_vector'("0") & (E_arith_src2))), ((std_logic_vector'("0") & (E_arith_src1)) + (std_logic_vector'("0") & (E_arith_src2))));
  E_mem_baddr <= E_arith_result(27 DOWNTO 0);
  E_logic_result <= A_WE_StdLogicVector(((E_logic_op = std_logic_vector'("00"))), (NOT ((E_src1 OR E_src2))), A_WE_StdLogicVector(((E_logic_op = std_logic_vector'("01"))), ((E_src1 AND E_src2)), A_WE_StdLogicVector(((E_logic_op = std_logic_vector'("10"))), ((E_src1 OR E_src2)), ((E_src1 XOR E_src2)))));
  E_eq <= E_src1_eq_src2;
  E_lt <= E_arith_result(32);
  E_cmp_result <= A_WE_StdLogic(((E_compare_op = std_logic_vector'("00"))), E_eq, A_WE_StdLogic(((E_compare_op = std_logic_vector'("01"))), NOT E_lt, A_WE_StdLogic(((E_compare_op = std_logic_vector'("10"))), E_lt, NOT E_eq)));
  E_br_result <= E_cmp_result;
  E_alu_result <= A_WE_StdLogicVector((std_logic'((E_ctrl_cmp)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(E_cmp_result))), A_WE_StdLogicVector((std_logic'((E_ctrl_logic)) = '1'), E_logic_result, A_WE_StdLogicVector((std_logic'((E_ctrl_retaddr)) = '1'), (std_logic_vector'("0000") & ((E_extra_pc & std_logic_vector'("00")))), A_WE_StdLogicVector((std_logic'((E_ctrl_custom_combo)) = '1'), E_ci_combo_result, E_arith_result(31 DOWNTO 0)))));
  E_stb_data <= E_src2_reg(7 DOWNTO 0);
  E_sth_data <= E_src2_reg(15 DOWNTO 0);
  E_st_data <= A_WE_StdLogicVector((std_logic'((E_mem8)) = '1'), (E_stb_data & E_stb_data & E_stb_data & E_stb_data), A_WE_StdLogicVector((std_logic'((E_mem16)) = '1'), (E_sth_data & E_sth_data), E_src2_reg));
  E_mem_byte_en <= A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("00") & std_logic_vector'("00")))), std_logic_vector'("0001"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("00") & std_logic_vector'("01")))), std_logic_vector'("0010"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("00") & std_logic_vector'("10")))), std_logic_vector'("0100"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("00") & std_logic_vector'("11")))), std_logic_vector'("1000"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("01") & std_logic_vector'("00")))), std_logic_vector'("0011"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("01") & std_logic_vector'("01")))), std_logic_vector'("0011"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("01") & std_logic_vector'("10")))), std_logic_vector'("1100"), A_WE_StdLogicVector((((E_iw_memsz & E_mem_baddr(1 DOWNTO 0)) = Std_Logic_Vector'(std_logic_vector'("01") & std_logic_vector'("11")))), std_logic_vector'("1100"), std_logic_vector'("1111")))))))));
  A_status_reg_pie_inst_nxt <= A_WE_StdLogic((std_logic'((((M_ctrl_exception OR M_ctrl_break) OR M_ctrl_crst))) = '1'), std_logic'('0'), A_WE_StdLogic((std_logic'(M_op_eret) = '1'), A_estatus_reg(0), A_WE_StdLogic((std_logic'(M_op_bret) = '1'), A_bstatus_reg(0), A_WE_StdLogic((std_logic'(M_wrctl_status) = '1'), M_wrctl_data_status_reg_pie, A_status_reg_pie))));
  A_estatus_reg_pie_inst_nxt <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(M_ctrl_crst) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(A_WE_StdLogic((std_logic'(M_ctrl_exception) = '1'), A_status_reg_pie, A_WE_StdLogic((std_logic'(M_wrctl_estatus) = '1'), M_wrctl_data_estatus_reg_pie, A_estatus_reg_pie)))))));
  A_bstatus_reg_pie_inst_nxt <= A_WE_StdLogic((std_logic'(M_ctrl_break) = '1'), A_status_reg_pie, A_WE_StdLogic((std_logic'(M_wrctl_bstatus) = '1'), M_wrctl_data_bstatus_reg_pie, A_bstatus_reg_pie));
  M_wrctl_status <= M_ctrl_wrctl_inst AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (M_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000000"))));
  M_wrctl_estatus <= M_ctrl_wrctl_inst AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (M_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000001"))));
  M_wrctl_bstatus <= M_ctrl_wrctl_inst AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (M_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000010"))));
  M_wrctl_ienable <= M_ctrl_wrctl_inst AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (M_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000011"))));
  M_wrctl_data_status_reg_pie <= M_alu_result(0);
  M_wrctl_data_estatus_reg_pie <= M_alu_result(0);
  M_wrctl_data_bstatus_reg_pie <= M_alu_result(0);
  M_wrctl_data_ienable_reg_irq0 <= M_alu_result(0);
  M_wrctl_data_ienable_reg_irq1 <= M_alu_result(1);
  M_wrctl_data_ienable_reg_irq2 <= M_alu_result(2);
  M_wrctl_data_ienable_reg_irq3 <= M_alu_result(3);
  M_wrctl_data_ienable_reg_irq5 <= M_alu_result(5);
  M_wrctl_data_ienable_reg_irq6 <= M_alu_result(6);
  M_wrctl_data_ienable_reg_irq8 <= M_alu_result(8);
  A_status_reg_pie_nxt <= A_WE_StdLogic((std_logic'(M_valid) = '1'), A_status_reg_pie_inst_nxt, A_status_reg_pie);
  A_status_reg_pie_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_status_reg_pie <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_status_reg_pie_wr_en) = '1' then 
        A_status_reg_pie <= A_status_reg_pie_nxt;
      end if;
    end if;

  end process;

  A_estatus_reg_pie_nxt <= A_WE_StdLogic((std_logic'(M_valid) = '1'), A_estatus_reg_pie_inst_nxt, A_estatus_reg_pie);
  A_estatus_reg_pie_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_estatus_reg_pie <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_estatus_reg_pie_wr_en) = '1' then 
        A_estatus_reg_pie <= A_estatus_reg_pie_nxt;
      end if;
    end if;

  end process;

  A_bstatus_reg_pie_nxt <= A_WE_StdLogic((std_logic'(M_valid) = '1'), A_bstatus_reg_pie_inst_nxt, A_bstatus_reg_pie);
  A_bstatus_reg_pie_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_bstatus_reg_pie <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_bstatus_reg_pie_wr_en) = '1' then 
        A_bstatus_reg_pie <= A_bstatus_reg_pie_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq0_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq0, A_ienable_reg_irq0);
  A_ienable_reg_irq0_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq0_wr_en) = '1' then 
        A_ienable_reg_irq0 <= A_ienable_reg_irq0_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq1_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq1, A_ienable_reg_irq1);
  A_ienable_reg_irq1_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq1_wr_en) = '1' then 
        A_ienable_reg_irq1 <= A_ienable_reg_irq1_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq2_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq2, A_ienable_reg_irq2);
  A_ienable_reg_irq2_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq2_wr_en) = '1' then 
        A_ienable_reg_irq2 <= A_ienable_reg_irq2_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq3_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq3, A_ienable_reg_irq3);
  A_ienable_reg_irq3_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq3_wr_en) = '1' then 
        A_ienable_reg_irq3 <= A_ienable_reg_irq3_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq5_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq5, A_ienable_reg_irq5);
  A_ienable_reg_irq5_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq5_wr_en) = '1' then 
        A_ienable_reg_irq5 <= A_ienable_reg_irq5_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq6_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq6, A_ienable_reg_irq6);
  A_ienable_reg_irq6_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq6_wr_en) = '1' then 
        A_ienable_reg_irq6 <= A_ienable_reg_irq6_nxt;
      end if;
    end if;

  end process;

  A_ienable_reg_irq8_nxt <= A_WE_StdLogic((std_logic'(((M_wrctl_ienable AND M_valid))) = '1'), M_wrctl_data_ienable_reg_irq8, A_ienable_reg_irq8);
  A_ienable_reg_irq8_wr_en <= A_en;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ienable_reg_irq8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ienable_reg_irq8_wr_en) = '1' then 
        A_ienable_reg_irq8 <= A_ienable_reg_irq8_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq0_nxt <= (d_irq(0) AND A_ienable_reg_irq0) AND oci_ienable(0);
  A_ipending_reg_irq0_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq0_wr_en) = '1' then 
        A_ipending_reg_irq0 <= A_ipending_reg_irq0_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq1_nxt <= (d_irq(1) AND A_ienable_reg_irq1) AND oci_ienable(1);
  A_ipending_reg_irq1_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq1_wr_en) = '1' then 
        A_ipending_reg_irq1 <= A_ipending_reg_irq1_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq2_nxt <= (d_irq(2) AND A_ienable_reg_irq2) AND oci_ienable(2);
  A_ipending_reg_irq2_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq2_wr_en) = '1' then 
        A_ipending_reg_irq2 <= A_ipending_reg_irq2_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq3_nxt <= (d_irq(3) AND A_ienable_reg_irq3) AND oci_ienable(3);
  A_ipending_reg_irq3_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq3_wr_en) = '1' then 
        A_ipending_reg_irq3 <= A_ipending_reg_irq3_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq5_nxt <= (d_irq(5) AND A_ienable_reg_irq5) AND oci_ienable(5);
  A_ipending_reg_irq5_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq5_wr_en) = '1' then 
        A_ipending_reg_irq5 <= A_ipending_reg_irq5_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq6_nxt <= (d_irq(6) AND A_ienable_reg_irq6) AND oci_ienable(6);
  A_ipending_reg_irq6_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq6_wr_en) = '1' then 
        A_ipending_reg_irq6 <= A_ipending_reg_irq6_nxt;
      end if;
    end if;

  end process;

  A_ipending_reg_irq8_nxt <= (d_irq(8) AND A_ienable_reg_irq8) AND oci_ienable(8);
  A_ipending_reg_irq8_wr_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ipending_reg_irq8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_ipending_reg_irq8_wr_en) = '1' then 
        A_ipending_reg_irq8 <= A_ipending_reg_irq8_nxt;
      end if;
    end if;

  end process;

  A_status_reg <= Std_Logic_Vector'(std_logic_vector'("0000000000000000000000000000000") & A_ToStdLogicVector(A_status_reg_pie));
  A_estatus_reg <= Std_Logic_Vector'(std_logic_vector'("0000000000000000000000000000000") & A_ToStdLogicVector(A_estatus_reg_pie));
  A_bstatus_reg <= Std_Logic_Vector'(std_logic_vector'("0000000000000000000000000000000") & A_ToStdLogicVector(A_bstatus_reg_pie));
  A_ienable_reg <= Std_Logic_Vector'(std_logic_vector'("00000000000000000000000") & A_ToStdLogicVector(A_ienable_reg_irq8) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(A_ienable_reg_irq6) & A_ToStdLogicVector(A_ienable_reg_irq5) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(A_ienable_reg_irq3) & A_ToStdLogicVector(A_ienable_reg_irq2) & A_ToStdLogicVector(A_ienable_reg_irq1) & A_ToStdLogicVector(A_ienable_reg_irq0));
  A_ipending_reg <= Std_Logic_Vector'(std_logic_vector'("00000000000000000000000") & A_ToStdLogicVector(A_ipending_reg_irq8) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(A_ipending_reg_irq6) & A_ToStdLogicVector(A_ipending_reg_irq5) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(A_ipending_reg_irq3) & A_ToStdLogicVector(A_ipending_reg_irq2) & A_ToStdLogicVector(A_ipending_reg_irq1) & A_ToStdLogicVector(A_ipending_reg_irq0));
  A_cpuid_reg <= Std_Logic_Vector'(std_logic_vector'("0000000000000000000000000000000") & A_ToStdLogicVector(std_logic'('0')));
  D_control_reg_rddata_muxed <= A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (D_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000000"))), A_status_reg, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (D_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000001"))), A_estatus_reg, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (D_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000010"))), A_bstatus_reg, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (D_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000011"))), A_ienable_reg, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (D_iw_control_regnum)) = std_logic_vector'("00000000000000000000000000000100"))), A_ipending_reg, A_cpuid_reg)))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_control_reg_rddata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_control_reg_rddata <= D_control_reg_rddata_muxed;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_control_reg_rddata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_control_reg_rddata <= E_control_reg_rddata;
      end if;
    end if;

  end process;

  M_rdctl_data <= M_control_reg_rddata;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      hbreak_enabled <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((M_valid AND M_en)) = '1' then 
        hbreak_enabled <= A_WE_StdLogic((std_logic'(M_ctrl_break) = '1'), std_logic'('0'), A_WE_StdLogic((std_logic'(M_op_bret) = '1'), std_logic'('1'), hbreak_enabled));
      end if;
    end if;

  end process;

  oci_tb_hbreak_req <= oci_hbreak_req;
  hbreak_req <= (((oci_tb_hbreak_req OR latched_oci_tb_hbreak_req)) AND hbreak_enabled) AND NOT (wait_for_one_post_bret_inst);
  E_hbreak_req <= hbreak_req AND NOT ((E_op_hbreak AND E_valid_prior_to_hbreak));
  latched_oci_tb_hbreak_req_next <= A_WE_StdLogic((std_logic'(latched_oci_tb_hbreak_req) = '1'), hbreak_enabled, ((hbreak_req AND E_valid_prior_to_hbreak)));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      latched_oci_tb_hbreak_req <= std_logic'('0');
    elsif clk'event and clk = '1' then
      latched_oci_tb_hbreak_req <= latched_oci_tb_hbreak_req_next;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      wait_for_one_post_bret_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      wait_for_one_post_bret_inst <= A_WE_StdLogic((std_logic'(((NOT hbreak_enabled AND oci_single_step_mode))) = '1'), std_logic'('1'), A_WE_StdLogic((std_logic'(((((E_en AND E_valid_prior_to_hbreak)) OR (NOT oci_single_step_mode)))) = '1'), std_logic'('0'), wait_for_one_post_bret_inst));
    end if;

  end process;

  D_pcb <= D_pc & std_logic_vector'("00");
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_pcb <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_pcb <= D_pcb;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_pcb <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_pcb <= E_pcb;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_pcb <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_pcb <= M_pcb;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_pcb <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      W_pcb <= A_pcb;
    end if;

  end process;

  D_dep_stall <= (D_data_depend AND D_issue) AND NOT M_pipe_flush;
  D_stall <= D_dep_stall OR E_stall;
  D_en <= NOT D_stall;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_iw <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_iw <= F_iw;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_pc <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_pc <= F_pc;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_pc_plus_one <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_pc_plus_one <= F_pc_plus_one;
      end if;
    end if;

  end process;

  D_valid <= (D_issue AND NOT D_data_depend) AND NOT M_pipe_flush;
  D_jmp_direct_target_waddr <= D_iw(31 DOWNTO 6);
  D_jmp_direct_target_baddr <= D_jmp_direct_target_waddr & std_logic_vector'("00");
  D_extra_pc <= A_WE_StdLogicVector((std_logic'(D_br_pred_not_taken) = '1'), D_br_taken_waddr, D_pc_plus_one);
  D_extra_pcb <= D_extra_pc & std_logic_vector'("00");
  E_stall <= M_stall;
  E_en <= NOT E_stall;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_valid_from_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_valid_from_D <= D_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_iw <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_iw <= D_iw;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_dst_regnum <= std_logic_vector'("00000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_dst_regnum <= D_dst_regnum;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_wr_dst_reg_from_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_wr_dst_reg_from_D <= D_wr_dst_reg;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_extra_pc <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_extra_pc <= D_extra_pc;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_pc <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_pc <= D_pc;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_valid_jmp_indirect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_valid_jmp_indirect <= D_ctrl_jmp_indirect AND D_valid;
      end if;
    end if;

  end process;

  E_extra_pcb <= E_extra_pc & std_logic_vector'("00");
  E_valid <= E_valid_from_D AND NOT E_cancel;
  E_wr_dst_reg <= E_wr_dst_reg_from_D AND NOT E_cancel;
  E_valid_prior_to_hbreak <= E_valid_from_D AND NOT M_pipe_flush;
  E_cancel <= M_pipe_flush OR E_hbreak_req;
  M_pipe_flush_nxt <= ((E_valid AND ((E_br_mispredict OR E_ctrl_flush_pipe_always)))) OR ((E_valid_prior_to_hbreak AND E_hbreak_req));
  M_pipe_flush_waddr_nxt <= A_EXT (A_WE_StdLogicVector((std_logic'(E_hbreak_req) = '1'), (std_logic_vector'("000000") & (E_pc)), A_WE_StdLogicVector((std_logic'(E_ctrl_jmp_indirect) = '1'), (std_logic_vector'("000000") & (E_src1(27 DOWNTO 2))), A_WE_StdLogicVector((std_logic'(E_ctrl_crst) = '1'), std_logic_vector'("00000001100000000000000000000000"), A_WE_StdLogicVector((std_logic'(E_ctrl_exception) = '1'), std_logic_vector'("00000000100000000000000000001000"), A_WE_StdLogicVector((std_logic'(E_ctrl_break) = '1'), std_logic_vector'("00000001110000000000000000001000"), (std_logic_vector'("000000") & (E_extra_pc))))))), 26);
  M_pipe_flush_baddr_nxt <= M_pipe_flush_waddr_nxt & std_logic_vector'("00");
  E_sel_data_master <= std_logic'('1');
  M_stall <= A_stall;
  M_en <= NOT M_stall;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_valid_from_E <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_valid_from_E <= E_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_iw <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_iw <= E_iw;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_mem_byte_en <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_mem_byte_en <= E_mem_byte_en;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_alu_result <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_alu_result <= E_alu_result;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_st_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_st_data <= E_st_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_dst_regnum <= std_logic_vector'("00000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_dst_regnum <= E_dst_regnum;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_cmp_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_cmp_result <= E_cmp_result;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_wr_dst_reg_from_E <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_wr_dst_reg_from_E <= E_wr_dst_reg;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_target_pcb <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_target_pcb <= E_src1(27 DOWNTO 0);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_pipe_flush <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_pipe_flush <= M_pipe_flush_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_pipe_flush_waddr <= std_logic_vector'("01100000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_pipe_flush_waddr <= M_pipe_flush_waddr_nxt;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_sel_data_master <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_sel_data_master <= E_sel_data_master;
      end if;
    end if;

  end process;

  M_pipe_flush_baddr <= M_pipe_flush_waddr & std_logic_vector'("00");
  M_mem_baddr <= M_alu_result(27 DOWNTO 0);
  M_exc_any <= std_logic'('0');
  M_ram_rd_data <= M_dc_rd_data;
  M_fwd_reg_data <= M_alu_result;
  M_inst_result <= A_WE_StdLogicVector((std_logic'((M_ctrl_rdctl_inst)) = '1'), M_rdctl_data, A_WE_StdLogicVector((std_logic'((M_ctrl_mem)) = '1'), M_ram_rd_data, M_alu_result));
  M_ld_align_sh16 <= (((M_ctrl_ld8 OR M_ctrl_ld16)) AND M_mem_baddr(1)) AND NOT M_exc_any;
  M_ld_align_sh8 <= (M_ctrl_ld8 AND M_mem_baddr(0)) AND NOT M_exc_any;
  M_ld_align_byte1_fill <= M_ctrl_ld8 AND NOT M_exc_any;
  M_ld_align_byte2_byte3_fill <= M_ctrl_ld8_ld16 AND NOT M_exc_any;
  M_cancel <= std_logic'('0');
  M_valid <= M_valid_from_E AND NOT M_cancel;
  M_wr_dst_reg <= M_wr_dst_reg_from_E AND NOT M_cancel;
  A_stall <= A_mem_stall;
  A_en <= NOT A_stall;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_valid <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_valid <= M_valid;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_iw <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_iw <= M_iw;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_inst_result <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_inst_result <= M_inst_result;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_mem_byte_en <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_mem_byte_en <= M_mem_byte_en;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_st_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_st_data <= M_st_data;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_dst_regnum_from_M <= std_logic_vector'("00000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_dst_regnum_from_M <= M_dst_regnum;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_align_sh16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ld_align_sh16 <= M_ld_align_sh16;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_align_sh8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ld_align_sh8 <= M_ld_align_sh8;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_align_byte1_fill <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ld_align_byte1_fill <= M_ld_align_byte1_fill;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ld_align_byte2_byte3_fill <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ld_align_byte2_byte3_fill <= M_ld_align_byte2_byte3_fill;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_cmp_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_cmp_result <= M_cmp_result;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_mem_baddr <= std_logic_vector'("0000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_mem_baddr <= M_mem_baddr;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_wr_dst_reg_from_M <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_wr_dst_reg_from_M <= M_wr_dst_reg;
      end if;
    end if;

  end process;

  A_pipe_flush <= std_logic'('0');
  A_pipe_flush_waddr <= std_logic_vector'("00000000000000000000000000");
  A_valid_crst <= std_logic'('0');
  A_slow_inst_result_en <= ((A_dc_fill_miss_offset_is_next OR A_ctrl_ld_bypass)) AND d_readdatavalid_d1;
  A_slow_inst_sel_nxt <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(A_en) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((A_ctrl_ld_bypass OR A_dc_want_fill))))));
  A_slow_inst_result_nxt <= A_slow_ld_data_aligned_nxt;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_slow_inst_sel <= std_logic'('0');
    elsif clk'event and clk = '1' then
      A_slow_inst_sel <= A_slow_inst_sel_nxt;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_slow_inst_result <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_slow_inst_result_en) = '1' then 
        A_slow_inst_result <= A_slow_inst_result_nxt;
      end if;
    end if;

  end process;

  A_wr_data_unfiltered <= A_WE_StdLogicVector((std_logic'((A_ctrl_mul_shift_rot)) = '1'), A_mul_shift_rot_result, A_WE_StdLogicVector((std_logic'((NOT A_slow_inst_sel)) = '1'), A_inst_result_aligned, A_slow_inst_result));
  A_fwd_reg_data <= A_wr_data_filtered;
  A_wr_dst_reg <= A_wr_dst_reg_from_M;
  A_dst_regnum <= A_dst_regnum_from_M;
  W_en <= std_logic'('1');
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_wr_data <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      W_wr_data <= A_wr_data_filtered;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_iw <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      W_iw <= A_iw;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_valid <= std_logic'('0');
    elsif clk'event and clk = '1' then
      W_valid <= A_valid AND A_en;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_wr_dst_reg <= std_logic'('0');
    elsif clk'event and clk = '1' then
      W_wr_dst_reg <= A_wr_dst_reg AND A_en;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_dst_regnum <= std_logic_vector'("00000");
    elsif clk'event and clk = '1' then
      W_dst_regnum <= A_dst_regnum;
    end if;

  end process;

  F_pc_nxt <= A_WE_StdLogicVector((std_logic'((A_pipe_flush)) = '1'), A_pipe_flush_waddr, A_WE_StdLogicVector((std_logic'((M_pipe_flush)) = '1'), M_pipe_flush_waddr, A_WE_StdLogicVector((std_logic'((E_valid_jmp_indirect)) = '1'), E_src1(27 DOWNTO 2), A_WE_StdLogicVector((std_logic'((D_refetch)) = '1'), D_pc, A_WE_StdLogicVector((std_logic'(((D_br_pred_taken AND D_issue))) = '1'), D_br_taken_waddr, A_WE_StdLogicVector((std_logic'(((D_ctrl_jmp_direct AND D_issue))) = '1'), D_jmp_direct_target_waddr, F_pc_plus_one))))));
  D_regnum_a_cmp_F <= to_std_logic(((F_ram_iw_a = D_dst_regnum))) AND D_wr_dst_reg;
  E_regnum_a_cmp_F <= to_std_logic(((F_ram_iw_a = E_dst_regnum))) AND E_wr_dst_reg;
  M_regnum_a_cmp_F <= to_std_logic(((F_ram_iw_a = M_dst_regnum))) AND M_wr_dst_reg;
  A_regnum_a_cmp_F <= to_std_logic(((F_ram_iw_a = A_dst_regnum))) AND A_wr_dst_reg;
  D_regnum_b_cmp_F <= to_std_logic(((F_ram_iw_b = D_dst_regnum))) AND D_wr_dst_reg;
  E_regnum_b_cmp_F <= to_std_logic(((F_ram_iw_b = E_dst_regnum))) AND E_wr_dst_reg;
  M_regnum_b_cmp_F <= to_std_logic(((F_ram_iw_b = M_dst_regnum))) AND M_wr_dst_reg;
  A_regnum_b_cmp_F <= to_std_logic(((F_ram_iw_b = A_dst_regnum))) AND A_wr_dst_reg;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_regnum_a_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_regnum_a_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), D_regnum_a_cmp_F, std_logic'('0'));
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_regnum_a_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_regnum_a_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), E_regnum_a_cmp_F, E_regnum_a_cmp_D);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_regnum_a_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_regnum_a_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), M_regnum_a_cmp_F, M_regnum_a_cmp_D);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_regnum_a_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      W_regnum_a_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), A_regnum_a_cmp_F, A_regnum_a_cmp_D);
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_regnum_b_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_regnum_b_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), D_regnum_b_cmp_F, std_logic'('0'));
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_regnum_b_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_regnum_b_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), E_regnum_b_cmp_F, E_regnum_b_cmp_D);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_regnum_b_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_regnum_b_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), M_regnum_b_cmp_F, M_regnum_b_cmp_D);
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_regnum_b_cmp_D <= std_logic'('0');
    elsif clk'event and clk = '1' then
      W_regnum_b_cmp_D <= A_WE_StdLogic((std_logic'(D_en) = '1'), A_regnum_b_cmp_F, A_regnum_b_cmp_D);
    end if;

  end process;

  D_ctrl_a_is_src <= NOT D_ctrl_a_not_src;
  D_ctrl_b_is_src <= NOT D_ctrl_b_not_src;
  D_src1_hazard_E <= E_regnum_a_cmp_D AND D_ctrl_a_is_src;
  D_src1_hazard_M <= M_regnum_a_cmp_D AND D_ctrl_a_is_src;
  D_src1_hazard_A <= A_regnum_a_cmp_D AND D_ctrl_a_is_src;
  D_src1_hazard_W <= W_regnum_a_cmp_D AND D_ctrl_a_is_src;
  D_src2_hazard_E <= E_regnum_b_cmp_D AND D_ctrl_b_is_src;
  D_src2_hazard_M <= M_regnum_b_cmp_D AND D_ctrl_b_is_src;
  D_src2_hazard_A <= A_regnum_b_cmp_D AND D_ctrl_b_is_src;
  D_src2_hazard_W <= W_regnum_b_cmp_D AND D_ctrl_b_is_src;
  D_data_depend <= ((((D_src1_hazard_E OR D_src2_hazard_E)) AND E_ctrl_late_result)) OR ((((D_src1_hazard_M OR D_src2_hazard_M)) AND M_ctrl_late_result));
  D_dstfield_regnum <= A_WE_StdLogicVector((std_logic'(D_ctrl_b_is_dst) = '1'), D_iw_b, D_iw_c);
  D_dst_regnum <= A_WE_StdLogicVector((std_logic'(D_ctrl_implicit_dst_retaddr) = '1'), std_logic_vector'("11111"), A_WE_StdLogicVector((std_logic'(D_ctrl_implicit_dst_eretaddr) = '1'), std_logic_vector'("11101"), D_dstfield_regnum));
  D_wr_dst_reg <= (to_std_logic((((std_logic_vector'("000000000000000000000000000") & (D_dst_regnum)) /= std_logic_vector'("00000000000000000000000000000000")))) AND NOT D_ctrl_ignore_dst) AND D_valid;
  E_fwd_reg_data <= E_alu_result;
  D_src1_reg <= A_WE_StdLogicVector((std_logic'((D_src1_hazard_E)) = '1'), E_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src1_hazard_M)) = '1'), M_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src1_hazard_A)) = '1'), A_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src1_hazard_W)) = '1'), W_wr_data, D_rf_a))));
  D_src1 <= D_src1_reg;
  D_src2_reg <= A_WE_StdLogicVector((std_logic'((D_src2_hazard_E)) = '1'), E_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src2_hazard_M)) = '1'), M_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src2_hazard_A)) = '1'), A_fwd_reg_data, A_WE_StdLogicVector((std_logic'((D_src2_hazard_W)) = '1'), W_wr_data, D_rf_b))));
  D_src2_imm_sel <= Std_Logic_Vector'(A_ToStdLogicVector(D_ctrl_hi_imm16) & A_ToStdLogicVector(D_ctrl_unsigned_lo_imm16));
  D_src2_imm <= A_WE_StdLogicVector(((D_src2_imm_sel = std_logic_vector'("00"))), (A_REP(D_iw_imm16(15) , 16) & D_iw_imm16), A_WE_StdLogicVector(((D_src2_imm_sel = std_logic_vector'("01"))), (A_REP(std_logic'('0'), 16) & D_iw_imm16), A_WE_StdLogicVector(((D_src2_imm_sel = std_logic_vector'("10"))), (D_iw_imm16 & std_logic_vector'("0000000000000000")), (A_REP(std_logic'('0'), 16) & std_logic_vector'("0000000000000000")))));
  D_src2 <= A_WE_StdLogicVector((std_logic'(D_ctrl_src2_choose_imm) = '1'), D_src2_imm, D_src2_reg);
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_src1 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_src1 <= D_src1;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_src2 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_src2 <= D_src2;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_src2_reg <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_src2_reg <= D_src2_reg;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_src1 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_src1 <= E_src1;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_src2 <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_src2 <= E_src2;
      end if;
    end if;

  end process;

  D_logic_op_raw <= A_WE_StdLogicVector((std_logic'(D_op_opx) = '1'), D_iw_opx(4 DOWNTO 3), D_iw_op(4 DOWNTO 3));
  D_logic_op <= A_WE_StdLogicVector((std_logic'(D_ctrl_alu_force_xor) = '1'), std_logic_vector'("11"), D_logic_op_raw);
  D_compare_op <= A_WE_StdLogicVector((std_logic'(D_op_opx) = '1'), D_iw_opx(4 DOWNTO 3), D_iw_op(4 DOWNTO 3));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_logic_op <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_logic_op <= D_logic_op;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_compare_op <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_compare_op <= D_compare_op;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_valid_wrctl_ienable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_valid_wrctl_ienable <= M_wrctl_ienable AND M_valid;
      end if;
    end if;

  end process;

  intr_req <= (A_status_reg_pie AND to_std_logic(((A_ipending_reg /= std_logic_vector'("00000000000000000000000000000000"))))) AND NOT A_valid_wrctl_ienable;
  E_shift_rot_col_zero <= to_std_logic(((std_logic_vector'("00000000000000000000000000000") & (E_src2(2 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000000")));
  E_sh_cnt_col <= A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0000"))), std_logic_vector'("00000001"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0001"))), std_logic_vector'("00000010"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0010"))), std_logic_vector'("00000100"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0011"))), std_logic_vector'("00001000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0100"))), std_logic_vector'("00010000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0101"))), std_logic_vector'("00100000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0110"))), std_logic_vector'("01000000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("0111"))), std_logic_vector'("10000000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1000"))), std_logic_vector'("00000001"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1001"))), std_logic_vector'("10000000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1010"))), std_logic_vector'("01000000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1011"))), std_logic_vector'("00100000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1100"))), std_logic_vector'("00010000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1101"))), std_logic_vector'("00001000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(2 DOWNTO 0)) = std_logic_vector'("1110"))), std_logic_vector'("00000100"), std_logic_vector'("00000010"))))))))))))))));
  E_sh_cnt_row <= A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0000"))), std_logic_vector'("0001"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0001"))), std_logic_vector'("0001"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0010"))), std_logic_vector'("0010"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0011"))), std_logic_vector'("0010"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0100"))), std_logic_vector'("0100"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0101"))), std_logic_vector'("0100"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0110"))), std_logic_vector'("1000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("0111"))), std_logic_vector'("1000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1000"))), std_logic_vector'("1000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1001"))), std_logic_vector'("0001"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1010"))), std_logic_vector'("0100"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1011"))), std_logic_vector'("1000"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1100"))), std_logic_vector'("0010"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1101"))), std_logic_vector'("0100"), A_WE_StdLogicVector(((Std_Logic_Vector'(A_ToStdLogicVector(E_ctrl_shift_rot_right) & E_src2(4 DOWNTO 3) & A_ToStdLogicVector(E_shift_rot_col_zero)) = std_logic_vector'("1110"))), std_logic_vector'("0001"), std_logic_vector'("0010"))))))))))))))));
  E_src2_mul_cell(0) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(0) AND E_sh_cnt_row(0))), E_src2(0));
  E_src2_mul_cell(1) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(1) AND E_sh_cnt_row(0))), E_src2(1));
  E_src2_mul_cell(2) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(2) AND E_sh_cnt_row(0))), E_src2(2));
  E_src2_mul_cell(3) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(3) AND E_sh_cnt_row(0))), E_src2(3));
  E_src2_mul_cell(4) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(4) AND E_sh_cnt_row(0))), E_src2(4));
  E_src2_mul_cell(5) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(5) AND E_sh_cnt_row(0))), E_src2(5));
  E_src2_mul_cell(6) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(6) AND E_sh_cnt_row(0))), E_src2(6));
  E_src2_mul_cell(7) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(7) AND E_sh_cnt_row(0))), E_src2(7));
  E_src2_mul_cell(8) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(0) AND E_sh_cnt_row(1))), E_src2(8));
  E_src2_mul_cell(9) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(1) AND E_sh_cnt_row(1))), E_src2(9));
  E_src2_mul_cell(10) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(2) AND E_sh_cnt_row(1))), E_src2(10));
  E_src2_mul_cell(11) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(3) AND E_sh_cnt_row(1))), E_src2(11));
  E_src2_mul_cell(12) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(4) AND E_sh_cnt_row(1))), E_src2(12));
  E_src2_mul_cell(13) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(5) AND E_sh_cnt_row(1))), E_src2(13));
  E_src2_mul_cell(14) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(6) AND E_sh_cnt_row(1))), E_src2(14));
  E_src2_mul_cell(15) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(7) AND E_sh_cnt_row(1))), E_src2(15));
  E_src2_mul_cell(16) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(0) AND E_sh_cnt_row(2))), E_src2(16));
  E_src2_mul_cell(17) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(1) AND E_sh_cnt_row(2))), E_src2(17));
  E_src2_mul_cell(18) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(2) AND E_sh_cnt_row(2))), E_src2(18));
  E_src2_mul_cell(19) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(3) AND E_sh_cnt_row(2))), E_src2(19));
  E_src2_mul_cell(20) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(4) AND E_sh_cnt_row(2))), E_src2(20));
  E_src2_mul_cell(21) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(5) AND E_sh_cnt_row(2))), E_src2(21));
  E_src2_mul_cell(22) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(6) AND E_sh_cnt_row(2))), E_src2(22));
  E_src2_mul_cell(23) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(7) AND E_sh_cnt_row(2))), E_src2(23));
  E_src2_mul_cell(24) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(0) AND E_sh_cnt_row(3))), E_src2(24));
  E_src2_mul_cell(25) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(1) AND E_sh_cnt_row(3))), E_src2(25));
  E_src2_mul_cell(26) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(2) AND E_sh_cnt_row(3))), E_src2(26));
  E_src2_mul_cell(27) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(3) AND E_sh_cnt_row(3))), E_src2(27));
  E_src2_mul_cell(28) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(4) AND E_sh_cnt_row(3))), E_src2(28));
  E_src2_mul_cell(29) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(5) AND E_sh_cnt_row(3))), E_src2(29));
  E_src2_mul_cell(30) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(6) AND E_sh_cnt_row(3))), E_src2(30));
  E_src2_mul_cell(31) <= A_WE_StdLogic((std_logic'(E_ctrl_shift_rot) = '1'), ((E_sh_cnt_col(7) AND E_sh_cnt_row(3))), E_src2(31));
  E_src1_mul_cell <= E_src1;
  E_shift_rot_by_zero <= to_std_logic(((std_logic_vector'("000000000000000000000000000") & (E_src2(4 DOWNTO 0))) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_shift_rot_by_zero <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_shift_rot_by_zero <= E_shift_rot_by_zero;
      end if;
    end if;

  end process;

  M_mul_cell_result_sel <= A_WE_StdLogicVector((std_logic'((M_ctrl_rot)) = '1'), std_logic_vector'("10"), A_WE_StdLogicVector((std_logic'(((((M_ctrl_shift_right AND NOT M_shift_rot_by_zero)) OR M_ctrl_mulx))) = '1'), std_logic_vector'("01"), std_logic_vector'("00")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_mul_cell_result_sel <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_mul_cell_result_sel <= M_mul_cell_result_sel;
      end if;
    end if;

  end process;

  A_mul_cell_result_lsw <= A_mul_cell_result(31 DOWNTO 0);
  A_mul_cell_result_msw <= A_mul_cell_result(63 DOWNTO 32);
  A_mul_shift_rot_result <= A_WE_StdLogicVector(((A_mul_cell_result_sel = std_logic_vector'("00"))), A_mul_cell_result_lsw, A_WE_StdLogicVector(((A_mul_cell_result_sel = std_logic_vector'("01"))), A_mul_cell_result_msw, A_WE_StdLogicVector(((A_mul_cell_result_sel = std_logic_vector'("10"))), ((A_mul_cell_result_msw OR A_mul_cell_result_lsw)), std_logic_vector'("00000000000000000000000000000000"))));
  --the_cpu_mult_cell, which is an e_instance
  the_cpu_mult_cell : cpu_mult_cell
    port map(
      A_mul_cell_result => A_mul_cell_result,
      A_en => A_en,
      E_ctrl_mul_shift_src1_signed => E_ctrl_mul_shift_src1_signed,
      E_ctrl_mul_shift_src2_signed => E_ctrl_mul_shift_src2_signed,
      E_src1_mul_cell => E_src1_mul_cell,
      E_src2_mul_cell => E_src2_mul_cell,
      M_en => M_en,
      clk => clk,
      reset_n => reset_n
    );


  E_ci_combo_dataa <= E_src1;
  E_ci_combo_datab <= E_src2;
  E_ci_combo_ipending <= A_ipending_reg;
  E_ci_combo_status <= A_status_reg(0);
  E_ci_combo_estatus <= A_estatus_reg(0);
  E_ci_combo_n <= E_iw_custom_n;
  E_ci_combo_a <= E_iw_a;
  E_ci_combo_b <= E_iw_b;
  E_ci_combo_c <= E_iw_c;
  E_ci_combo_readra <= E_iw_custom_readra;
  E_ci_combo_readrb <= E_iw_custom_readrb;
  E_ci_combo_writerc <= E_iw_custom_writerc;
  --custom_instruction_master, which is an e_custom_instruction_master
  E_ctrl_ld_bypass <= ((E_ctrl_ld_io OR ((E_ctrl_ld_non_io AND E_mem_bypass_non_io)))) AND E_sel_data_master;
  M_ctrl_ld_bypass_nxt <= E_ctrl_ld_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_bypass <= M_ctrl_ld_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_bypass_nxt <= M_ctrl_ld_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_bypass <= A_ctrl_ld_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st_bypass <= ((E_ctrl_st_io OR ((E_ctrl_st_non_io AND E_mem_bypass_non_io)))) AND E_sel_data_master;
  M_ctrl_st_bypass_nxt <= E_ctrl_st_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st_bypass <= M_ctrl_st_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st_bypass_nxt <= M_ctrl_st_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st_bypass <= A_ctrl_st_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_bypass <= ((E_ctrl_ld_st_io OR ((E_ctrl_ld_st_non_io AND E_mem_bypass_non_io)))) AND E_sel_data_master;
  M_ctrl_ld_st_bypass_nxt <= E_ctrl_ld_st_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_bypass <= M_ctrl_ld_st_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_bypass_nxt <= M_ctrl_ld_st_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_bypass <= A_ctrl_ld_st_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_bypass_or_dcache_management <= ((((E_ctrl_ld_st_io OR ((E_ctrl_ld_st_non_io AND E_mem_bypass_non_io)))) AND E_sel_data_master)) OR E_ctrl_dcache_management;
  M_ctrl_ld_st_bypass_or_dcache_management_nxt <= E_ctrl_ld_st_bypass_or_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_bypass_or_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_bypass_or_dcache_management <= M_ctrl_ld_st_bypass_or_dcache_management_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_bypass_or_dcache_management_nxt <= M_ctrl_ld_st_bypass_or_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_bypass_or_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_bypass_or_dcache_management <= A_ctrl_ld_st_bypass_or_dcache_management_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_non_bypass <= ((E_ctrl_ld_non_io AND NOT E_mem_bypass_non_io)) OR ((E_ctrl_ld AND NOT E_sel_data_master));
  M_ctrl_ld_non_bypass_nxt <= E_ctrl_ld_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_non_bypass <= M_ctrl_ld_non_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_non_bypass_nxt <= M_ctrl_ld_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_non_bypass <= A_ctrl_ld_non_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st_non_bypass <= ((E_ctrl_st_non_io AND NOT E_mem_bypass_non_io)) OR ((E_ctrl_st AND NOT E_sel_data_master));
  M_ctrl_st_non_bypass_nxt <= E_ctrl_st_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st_non_bypass <= M_ctrl_st_non_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st_non_bypass_nxt <= M_ctrl_st_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st_non_bypass <= A_ctrl_st_non_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_non_bypass <= ((E_ctrl_ld_st_non_io AND NOT E_mem_bypass_non_io)) OR ((E_ctrl_ld_st AND NOT E_sel_data_master));
  M_ctrl_ld_st_non_bypass_nxt <= E_ctrl_ld_st_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_non_bypass <= M_ctrl_ld_st_non_bypass_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_non_bypass_nxt <= M_ctrl_ld_st_non_bypass;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_non_bypass <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_non_bypass <= A_ctrl_ld_st_non_bypass_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_non_bypass_non_st32 <= ((E_ctrl_ld_st_non_io_non_st32 AND NOT E_mem_bypass_non_io)) OR ((E_ctrl_ld_st_non_st32 AND NOT E_sel_data_master));
  M_ctrl_ld_st_non_bypass_non_st32_nxt <= E_ctrl_ld_st_non_bypass_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_non_bypass_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_non_bypass_non_st32 <= M_ctrl_ld_st_non_bypass_non_st32_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_non_bypass_non_st32_nxt <= M_ctrl_ld_st_non_bypass_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_non_bypass_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_non_bypass_non_st32 <= A_ctrl_ld_st_non_bypass_non_st32_nxt;
      end if;
    end if;

  end process;

  --the_cpu_nios2_oci, which is an e_instance
  the_cpu_nios2_oci : cpu_nios2_oci
    port map(
      jtag_debug_module_debugaccess_to_roms => internal_jtag_debug_module_debugaccess_to_roms,
      oci_hbreak_req => oci_hbreak_req,
      oci_ienable => oci_ienable,
      oci_single_step_mode => oci_single_step_mode,
      readdata => internal_jtag_debug_module_readdata,
      resetrequest => internal_jtag_debug_module_resetrequest,
      tr_clk => internal_jtag_debug_offchip_trace_clk,
      tr_data => internal_jtag_debug_offchip_trace_data,
      trigout => internal_jtag_debug_trigout,
      A_cmp_result => A_cmp_result,
      A_ctrl_exception => A_ctrl_exception,
      A_ctrl_ld => A_ctrl_ld,
      A_ctrl_st => A_ctrl_st,
      A_en => A_en,
      A_mem_baddr => A_mem_baddr,
      A_op_beq => A_op_beq,
      A_op_bge => A_op_bge,
      A_op_bgeu => A_op_bgeu,
      A_op_blt => A_op_blt,
      A_op_bltu => A_op_bltu,
      A_op_bne => A_op_bne,
      A_op_br => A_op_br,
      A_op_bret => A_op_bret,
      A_op_call => A_op_call,
      A_op_callr => A_op_callr,
      A_op_eret => A_op_eret,
      A_op_jmp => A_op_jmp,
      A_op_jmpi => A_op_jmpi,
      A_op_ret => A_op_ret,
      A_pcb => A_pcb,
      A_st_data => A_st_data,
      A_valid => A_valid,
      A_wr_data_filtered => A_wr_data_filtered,
      D_en => D_en,
      E_en => E_en,
      E_valid => E_valid,
      F_pc => F_pc,
      M_en => M_en,
      address => jtag_debug_module_address,
      begintransfer => jtag_debug_module_begintransfer,
      byteenable => jtag_debug_module_byteenable,
      chipselect => jtag_debug_module_select,
      clk => jtag_debug_module_clk,
      debugaccess => jtag_debug_module_debugaccess,
      hbreak_enabled => hbreak_enabled,
      reset => jtag_debug_module_reset,
      reset_n => reset_n,
      test_ending => test_ending,
      test_has_ended => test_has_ended,
      write => jtag_debug_module_write,
      writedata => jtag_debug_module_writedata
    );


  --jtag_debug_module, which is an e_avalon_slave
  D_ctrl_unimp_trap <= D_op_div OR D_op_divu;
  E_ctrl_unimp_trap_nxt <= D_ctrl_unimp_trap;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_unimp_trap <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_unimp_trap <= E_ctrl_unimp_trap_nxt;
      end if;
    end if;

  end process;

  M_ctrl_unimp_trap_nxt <= E_ctrl_unimp_trap;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_unimp_trap <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_unimp_trap <= M_ctrl_unimp_trap_nxt;
      end if;
    end if;

  end process;

  A_ctrl_unimp_trap_nxt <= M_ctrl_unimp_trap;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_unimp_trap <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_unimp_trap <= A_ctrl_unimp_trap_nxt;
      end if;
    end if;

  end process;

  W_ctrl_unimp_trap_nxt <= A_ctrl_unimp_trap;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_unimp_trap <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_unimp_trap <= W_ctrl_unimp_trap_nxt;
      end if;
    end if;

  end process;

  D_ctrl_unimp_nop <= std_logic'('0');
  E_ctrl_unimp_nop_nxt <= D_ctrl_unimp_nop;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_unimp_nop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_unimp_nop <= E_ctrl_unimp_nop_nxt;
      end if;
    end if;

  end process;

  M_ctrl_unimp_nop_nxt <= E_ctrl_unimp_nop;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_unimp_nop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_unimp_nop <= M_ctrl_unimp_nop_nxt;
      end if;
    end if;

  end process;

  A_ctrl_unimp_nop_nxt <= M_ctrl_unimp_nop;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_unimp_nop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_unimp_nop <= A_ctrl_unimp_nop_nxt;
      end if;
    end if;

  end process;

  W_ctrl_unimp_nop_nxt <= A_ctrl_unimp_nop;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_unimp_nop <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_unimp_nop <= W_ctrl_unimp_nop_nxt;
      end if;
    end if;

  end process;

  D_ctrl_illegal <= std_logic'('0');
  E_ctrl_illegal_nxt <= D_ctrl_illegal;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_illegal <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_illegal <= E_ctrl_illegal_nxt;
      end if;
    end if;

  end process;

  M_ctrl_illegal_nxt <= E_ctrl_illegal;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_illegal <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_illegal <= M_ctrl_illegal_nxt;
      end if;
    end if;

  end process;

  A_ctrl_illegal_nxt <= M_ctrl_illegal;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_illegal <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_illegal <= A_ctrl_illegal_nxt;
      end if;
    end if;

  end process;

  W_ctrl_illegal_nxt <= A_ctrl_illegal;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_illegal <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_illegal <= W_ctrl_illegal_nxt;
      end if;
    end if;

  end process;

  D_ctrl_custom_combo <= D_op_bswap_s1 OR D_op_interrupt_vector_interrupt_vector;
  E_ctrl_custom_combo_nxt <= D_ctrl_custom_combo;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_custom_combo <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_custom_combo <= E_ctrl_custom_combo_nxt;
      end if;
    end if;

  end process;

  M_ctrl_custom_combo_nxt <= E_ctrl_custom_combo;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_custom_combo <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_custom_combo <= M_ctrl_custom_combo_nxt;
      end if;
    end if;

  end process;

  A_ctrl_custom_combo_nxt <= M_ctrl_custom_combo;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_custom_combo <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_custom_combo <= A_ctrl_custom_combo_nxt;
      end if;
    end if;

  end process;

  W_ctrl_custom_combo_nxt <= A_ctrl_custom_combo;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_custom_combo <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_custom_combo <= W_ctrl_custom_combo_nxt;
      end if;
    end if;

  end process;

  D_ctrl_custom_multi <= std_logic'('0');
  E_ctrl_custom_multi_nxt <= D_ctrl_custom_multi;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_custom_multi <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_custom_multi <= E_ctrl_custom_multi_nxt;
      end if;
    end if;

  end process;

  M_ctrl_custom_multi_nxt <= E_ctrl_custom_multi;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_custom_multi <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_custom_multi <= M_ctrl_custom_multi_nxt;
      end if;
    end if;

  end process;

  A_ctrl_custom_multi_nxt <= M_ctrl_custom_multi;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_custom_multi <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_custom_multi <= A_ctrl_custom_multi_nxt;
      end if;
    end if;

  end process;

  W_ctrl_custom_multi_nxt <= A_ctrl_custom_multi;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_custom_multi <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_custom_multi <= W_ctrl_custom_multi_nxt;
      end if;
    end if;

  end process;

  D_ctrl_supervisor_only <= ((((D_op_initi OR D_op_initd) OR D_op_eret) OR D_op_bret) OR D_op_wrctl) OR D_op_rdctl;
  E_ctrl_supervisor_only_nxt <= D_ctrl_supervisor_only;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_supervisor_only <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_supervisor_only <= E_ctrl_supervisor_only_nxt;
      end if;
    end if;

  end process;

  M_ctrl_supervisor_only_nxt <= E_ctrl_supervisor_only;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_supervisor_only <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_supervisor_only <= M_ctrl_supervisor_only_nxt;
      end if;
    end if;

  end process;

  A_ctrl_supervisor_only_nxt <= M_ctrl_supervisor_only;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_supervisor_only <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_supervisor_only <= A_ctrl_supervisor_only_nxt;
      end if;
    end if;

  end process;

  W_ctrl_supervisor_only_nxt <= A_ctrl_supervisor_only;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_supervisor_only <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_supervisor_only <= W_ctrl_supervisor_only_nxt;
      end if;
    end if;

  end process;

  E_ctrl_invalidate_i <= ((E_op_initi OR E_op_flushi) OR E_op_crst) OR E_op_rsvx63;
  M_ctrl_invalidate_i_nxt <= E_ctrl_invalidate_i;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_invalidate_i <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_invalidate_i <= M_ctrl_invalidate_i_nxt;
      end if;
    end if;

  end process;

  A_ctrl_invalidate_i_nxt <= M_ctrl_invalidate_i;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_invalidate_i <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_invalidate_i <= A_ctrl_invalidate_i_nxt;
      end if;
    end if;

  end process;

  W_ctrl_invalidate_i_nxt <= A_ctrl_invalidate_i;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_invalidate_i <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_invalidate_i <= W_ctrl_invalidate_i_nxt;
      end if;
    end if;

  end process;

  D_ctrl_jmp_indirect <= ((((((D_op_eret OR D_op_bret) OR D_op_rsvx17) OR D_op_rsvx25) OR D_op_ret) OR D_op_jmp) OR D_op_rsvx21) OR D_op_callr;
  E_ctrl_jmp_indirect_nxt <= D_ctrl_jmp_indirect;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_jmp_indirect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_jmp_indirect <= E_ctrl_jmp_indirect_nxt;
      end if;
    end if;

  end process;

  M_ctrl_jmp_indirect_nxt <= E_ctrl_jmp_indirect;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_jmp_indirect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_jmp_indirect <= M_ctrl_jmp_indirect_nxt;
      end if;
    end if;

  end process;

  A_ctrl_jmp_indirect_nxt <= M_ctrl_jmp_indirect;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_jmp_indirect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_jmp_indirect <= A_ctrl_jmp_indirect_nxt;
      end if;
    end if;

  end process;

  W_ctrl_jmp_indirect_nxt <= A_ctrl_jmp_indirect;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_jmp_indirect <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_jmp_indirect <= W_ctrl_jmp_indirect_nxt;
      end if;
    end if;

  end process;

  F_ctrl_jmp_direct <= F_op_call OR F_op_jmpi;
  D_ctrl_jmp_direct_nxt <= F_ctrl_jmp_direct;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_jmp_direct <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_jmp_direct <= D_ctrl_jmp_direct_nxt;
      end if;
    end if;

  end process;

  E_ctrl_jmp_direct_nxt <= D_ctrl_jmp_direct;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_jmp_direct <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_jmp_direct <= E_ctrl_jmp_direct_nxt;
      end if;
    end if;

  end process;

  M_ctrl_jmp_direct_nxt <= E_ctrl_jmp_direct;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_jmp_direct <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_jmp_direct <= M_ctrl_jmp_direct_nxt;
      end if;
    end if;

  end process;

  A_ctrl_jmp_direct_nxt <= M_ctrl_jmp_direct;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_jmp_direct <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_jmp_direct <= A_ctrl_jmp_direct_nxt;
      end if;
    end if;

  end process;

  W_ctrl_jmp_direct_nxt <= A_ctrl_jmp_direct;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_jmp_direct <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_jmp_direct <= W_ctrl_jmp_direct_nxt;
      end if;
    end if;

  end process;

  D_ctrl_mulx <= ((D_op_mulxuu OR D_op_rsvx15) OR D_op_mulxsu) OR D_op_mulxss;
  E_ctrl_mulx_nxt <= D_ctrl_mulx;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_mulx <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_mulx <= E_ctrl_mulx_nxt;
      end if;
    end if;

  end process;

  M_ctrl_mulx_nxt <= E_ctrl_mulx;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mulx <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mulx <= M_ctrl_mulx_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mulx_nxt <= M_ctrl_mulx;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mulx <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mulx <= A_ctrl_mulx_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mulx_nxt <= A_ctrl_mulx;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mulx <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mulx <= W_ctrl_mulx_nxt;
      end if;
    end if;

  end process;

  D_ctrl_implicit_dst_retaddr <= D_op_call OR D_op_rsv02;
  E_ctrl_implicit_dst_retaddr_nxt <= D_ctrl_implicit_dst_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_implicit_dst_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_implicit_dst_retaddr <= E_ctrl_implicit_dst_retaddr_nxt;
      end if;
    end if;

  end process;

  M_ctrl_implicit_dst_retaddr_nxt <= E_ctrl_implicit_dst_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_implicit_dst_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_implicit_dst_retaddr <= M_ctrl_implicit_dst_retaddr_nxt;
      end if;
    end if;

  end process;

  A_ctrl_implicit_dst_retaddr_nxt <= M_ctrl_implicit_dst_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_implicit_dst_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_implicit_dst_retaddr <= A_ctrl_implicit_dst_retaddr_nxt;
      end if;
    end if;

  end process;

  W_ctrl_implicit_dst_retaddr_nxt <= A_ctrl_implicit_dst_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_implicit_dst_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_implicit_dst_retaddr <= W_ctrl_implicit_dst_retaddr_nxt;
      end if;
    end if;

  end process;

  D_ctrl_implicit_dst_eretaddr <= D_op_div OR D_op_divu;
  E_ctrl_implicit_dst_eretaddr_nxt <= D_ctrl_implicit_dst_eretaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_implicit_dst_eretaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_implicit_dst_eretaddr <= E_ctrl_implicit_dst_eretaddr_nxt;
      end if;
    end if;

  end process;

  M_ctrl_implicit_dst_eretaddr_nxt <= E_ctrl_implicit_dst_eretaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_implicit_dst_eretaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_implicit_dst_eretaddr <= M_ctrl_implicit_dst_eretaddr_nxt;
      end if;
    end if;

  end process;

  A_ctrl_implicit_dst_eretaddr_nxt <= M_ctrl_implicit_dst_eretaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_implicit_dst_eretaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_implicit_dst_eretaddr <= A_ctrl_implicit_dst_eretaddr_nxt;
      end if;
    end if;

  end process;

  W_ctrl_implicit_dst_eretaddr_nxt <= A_ctrl_implicit_dst_eretaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_implicit_dst_eretaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_implicit_dst_eretaddr <= W_ctrl_implicit_dst_eretaddr_nxt;
      end if;
    end if;

  end process;

  D_ctrl_exception <= ((((D_op_trap OR D_op_rsvx44) OR D_op_div) OR D_op_divu) OR D_op_intr) OR D_op_rsvx60;
  E_ctrl_exception_nxt <= D_ctrl_exception;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_exception <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_exception <= E_ctrl_exception_nxt;
      end if;
    end if;

  end process;

  M_ctrl_exception_nxt <= E_ctrl_exception;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_exception <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_exception <= M_ctrl_exception_nxt;
      end if;
    end if;

  end process;

  A_ctrl_exception_nxt <= M_ctrl_exception;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_exception <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_exception <= A_ctrl_exception_nxt;
      end if;
    end if;

  end process;

  W_ctrl_exception_nxt <= A_ctrl_exception;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_exception <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_exception <= W_ctrl_exception_nxt;
      end if;
    end if;

  end process;

  D_ctrl_break <= D_op_break OR D_op_hbreak;
  E_ctrl_break_nxt <= D_ctrl_break;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_break <= E_ctrl_break_nxt;
      end if;
    end if;

  end process;

  M_ctrl_break_nxt <= E_ctrl_break;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_break <= M_ctrl_break_nxt;
      end if;
    end if;

  end process;

  A_ctrl_break_nxt <= M_ctrl_break;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_break <= A_ctrl_break_nxt;
      end if;
    end if;

  end process;

  W_ctrl_break_nxt <= A_ctrl_break;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_break <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_break <= W_ctrl_break_nxt;
      end if;
    end if;

  end process;

  D_ctrl_crst <= D_op_crst OR D_op_rsvx63;
  E_ctrl_crst_nxt <= D_ctrl_crst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_crst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_crst <= E_ctrl_crst_nxt;
      end if;
    end if;

  end process;

  M_ctrl_crst_nxt <= E_ctrl_crst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_crst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_crst <= M_ctrl_crst_nxt;
      end if;
    end if;

  end process;

  A_ctrl_crst_nxt <= M_ctrl_crst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_crst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_crst <= A_ctrl_crst_nxt;
      end if;
    end if;

  end process;

  W_ctrl_crst_nxt <= A_ctrl_crst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_crst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_crst <= W_ctrl_crst_nxt;
      end if;
    end if;

  end process;

  D_ctrl_uncond_cti_non_br <= ((((((((D_op_call OR D_op_jmpi) OR D_op_eret) OR D_op_bret) OR D_op_rsvx17) OR D_op_rsvx25) OR D_op_ret) OR D_op_jmp) OR D_op_rsvx21) OR D_op_callr;
  E_ctrl_uncond_cti_non_br_nxt <= D_ctrl_uncond_cti_non_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_uncond_cti_non_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_uncond_cti_non_br <= E_ctrl_uncond_cti_non_br_nxt;
      end if;
    end if;

  end process;

  M_ctrl_uncond_cti_non_br_nxt <= E_ctrl_uncond_cti_non_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_uncond_cti_non_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_uncond_cti_non_br <= M_ctrl_uncond_cti_non_br_nxt;
      end if;
    end if;

  end process;

  A_ctrl_uncond_cti_non_br_nxt <= M_ctrl_uncond_cti_non_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_uncond_cti_non_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_uncond_cti_non_br <= A_ctrl_uncond_cti_non_br_nxt;
      end if;
    end if;

  end process;

  W_ctrl_uncond_cti_non_br_nxt <= A_ctrl_uncond_cti_non_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_uncond_cti_non_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_uncond_cti_non_br <= W_ctrl_uncond_cti_non_br_nxt;
      end if;
    end if;

  end process;

  D_ctrl_retaddr <= ((((((((((D_op_call OR D_op_rsv02) OR D_op_nextpc) OR D_op_callr) OR D_op_trap) OR D_op_rsvx44) OR D_op_div) OR D_op_divu) OR D_op_intr) OR D_op_rsvx60) OR D_op_break) OR D_op_hbreak;
  E_ctrl_retaddr_nxt <= D_ctrl_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_retaddr <= E_ctrl_retaddr_nxt;
      end if;
    end if;

  end process;

  M_ctrl_retaddr_nxt <= E_ctrl_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_retaddr <= M_ctrl_retaddr_nxt;
      end if;
    end if;

  end process;

  A_ctrl_retaddr_nxt <= M_ctrl_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_retaddr <= A_ctrl_retaddr_nxt;
      end if;
    end if;

  end process;

  W_ctrl_retaddr_nxt <= A_ctrl_retaddr;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_retaddr <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_retaddr <= W_ctrl_retaddr_nxt;
      end if;
    end if;

  end process;

  D_ctrl_shift_right <= ((D_op_srli OR D_op_srl) OR D_op_srai) OR D_op_sra;
  E_ctrl_shift_right_nxt <= D_ctrl_shift_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_shift_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_shift_right <= E_ctrl_shift_right_nxt;
      end if;
    end if;

  end process;

  M_ctrl_shift_right_nxt <= E_ctrl_shift_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_shift_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_shift_right <= M_ctrl_shift_right_nxt;
      end if;
    end if;

  end process;

  A_ctrl_shift_right_nxt <= M_ctrl_shift_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_shift_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_shift_right <= A_ctrl_shift_right_nxt;
      end if;
    end if;

  end process;

  W_ctrl_shift_right_nxt <= A_ctrl_shift_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_shift_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_shift_right <= W_ctrl_shift_right_nxt;
      end if;
    end if;

  end process;

  D_ctrl_shift_rot_right <= ((((((D_op_srli OR D_op_srl) OR D_op_srai) OR D_op_sra) OR D_op_rsvx10) OR D_op_ror) OR D_op_rsvx42) OR D_op_rsvx43;
  E_ctrl_shift_rot_right_nxt <= D_ctrl_shift_rot_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_shift_rot_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_shift_rot_right <= E_ctrl_shift_rot_right_nxt;
      end if;
    end if;

  end process;

  M_ctrl_shift_rot_right_nxt <= E_ctrl_shift_rot_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_shift_rot_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_shift_rot_right <= M_ctrl_shift_rot_right_nxt;
      end if;
    end if;

  end process;

  A_ctrl_shift_rot_right_nxt <= M_ctrl_shift_rot_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_shift_rot_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_shift_rot_right <= A_ctrl_shift_rot_right_nxt;
      end if;
    end if;

  end process;

  W_ctrl_shift_rot_right_nxt <= A_ctrl_shift_rot_right;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_shift_rot_right <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_shift_rot_right <= W_ctrl_shift_rot_right_nxt;
      end if;
    end if;

  end process;

  D_ctrl_shift_rot <= ((((((((((((((D_op_slli OR D_op_rsvx50) OR D_op_sll) OR D_op_rsvx51) OR D_op_roli) OR D_op_rsvx34) OR D_op_rol) OR D_op_rsvx35) OR D_op_srli) OR D_op_srl) OR D_op_srai) OR D_op_sra) OR D_op_rsvx10) OR D_op_ror) OR D_op_rsvx42) OR D_op_rsvx43;
  E_ctrl_shift_rot_nxt <= D_ctrl_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_shift_rot <= E_ctrl_shift_rot_nxt;
      end if;
    end if;

  end process;

  M_ctrl_shift_rot_nxt <= E_ctrl_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_shift_rot <= M_ctrl_shift_rot_nxt;
      end if;
    end if;

  end process;

  A_ctrl_shift_rot_nxt <= M_ctrl_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_shift_rot <= A_ctrl_shift_rot_nxt;
      end if;
    end if;

  end process;

  W_ctrl_shift_rot_nxt <= A_ctrl_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_shift_rot <= W_ctrl_shift_rot_nxt;
      end if;
    end if;

  end process;

  D_ctrl_rot <= ((((((D_op_roli OR D_op_rsvx34) OR D_op_rol) OR D_op_rsvx35) OR D_op_rsvx10) OR D_op_ror) OR D_op_rsvx42) OR D_op_rsvx43;
  E_ctrl_rot_nxt <= D_ctrl_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_rot <= E_ctrl_rot_nxt;
      end if;
    end if;

  end process;

  M_ctrl_rot_nxt <= E_ctrl_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_rot <= M_ctrl_rot_nxt;
      end if;
    end if;

  end process;

  A_ctrl_rot_nxt <= M_ctrl_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_rot <= A_ctrl_rot_nxt;
      end if;
    end if;

  end process;

  W_ctrl_rot_nxt <= A_ctrl_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_rot <= W_ctrl_rot_nxt;
      end if;
    end if;

  end process;

  D_ctrl_logic <= ((((((((D_op_and OR D_op_or) OR D_op_xor) OR D_op_nor) OR D_op_andhi) OR D_op_orhi) OR D_op_xorhi) OR D_op_andi) OR D_op_ori) OR D_op_xori;
  E_ctrl_logic_nxt <= D_ctrl_logic;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_logic <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_logic <= E_ctrl_logic_nxt;
      end if;
    end if;

  end process;

  M_ctrl_logic_nxt <= E_ctrl_logic;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_logic <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_logic <= M_ctrl_logic_nxt;
      end if;
    end if;

  end process;

  A_ctrl_logic_nxt <= M_ctrl_logic;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_logic <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_logic <= A_ctrl_logic_nxt;
      end if;
    end if;

  end process;

  W_ctrl_logic_nxt <= A_ctrl_logic;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_logic <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_logic <= W_ctrl_logic_nxt;
      end if;
    end if;

  end process;

  D_ctrl_hi_imm16 <= (D_op_andhi OR D_op_orhi) OR D_op_xorhi;
  E_ctrl_hi_imm16_nxt <= D_ctrl_hi_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_hi_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_hi_imm16 <= E_ctrl_hi_imm16_nxt;
      end if;
    end if;

  end process;

  M_ctrl_hi_imm16_nxt <= E_ctrl_hi_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_hi_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_hi_imm16 <= M_ctrl_hi_imm16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_hi_imm16_nxt <= M_ctrl_hi_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_hi_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_hi_imm16 <= A_ctrl_hi_imm16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_hi_imm16_nxt <= A_ctrl_hi_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_hi_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_hi_imm16 <= W_ctrl_hi_imm16_nxt;
      end if;
    end if;

  end process;

  D_ctrl_unsigned_lo_imm16 <= (((((((((((D_op_cmpgeui OR D_op_cmpltui) OR D_op_andi) OR D_op_ori) OR D_op_xori) OR D_op_roli) OR D_op_rsvx10) OR D_op_slli) OR D_op_srli) OR D_op_rsvx34) OR D_op_rsvx42) OR D_op_rsvx50) OR D_op_srai;
  E_ctrl_unsigned_lo_imm16_nxt <= D_ctrl_unsigned_lo_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_unsigned_lo_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_unsigned_lo_imm16 <= E_ctrl_unsigned_lo_imm16_nxt;
      end if;
    end if;

  end process;

  M_ctrl_unsigned_lo_imm16_nxt <= E_ctrl_unsigned_lo_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_unsigned_lo_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_unsigned_lo_imm16 <= M_ctrl_unsigned_lo_imm16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_unsigned_lo_imm16_nxt <= M_ctrl_unsigned_lo_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_unsigned_lo_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_unsigned_lo_imm16 <= A_ctrl_unsigned_lo_imm16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_unsigned_lo_imm16_nxt <= A_ctrl_unsigned_lo_imm16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_unsigned_lo_imm16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_unsigned_lo_imm16 <= W_ctrl_unsigned_lo_imm16_nxt;
      end if;
    end if;

  end process;

  D_ctrl_cmp <= ((((((((((((D_op_cmpgei OR D_op_cmplti) OR D_op_cmpnei) OR D_op_cmpgeui) OR D_op_cmpltui) OR D_op_cmpeqi) OR D_op_rsvx00) OR D_op_cmpge) OR D_op_cmplt) OR D_op_cmpne) OR D_op_cmpgeu) OR D_op_cmpltu) OR D_op_cmpeq) OR D_op_rsvx56;
  E_ctrl_cmp_nxt <= D_ctrl_cmp;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_cmp <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_cmp <= E_ctrl_cmp_nxt;
      end if;
    end if;

  end process;

  M_ctrl_cmp_nxt <= E_ctrl_cmp;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_cmp <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_cmp <= M_ctrl_cmp_nxt;
      end if;
    end if;

  end process;

  A_ctrl_cmp_nxt <= M_ctrl_cmp;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_cmp <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_cmp <= A_ctrl_cmp_nxt;
      end if;
    end if;

  end process;

  W_ctrl_cmp_nxt <= A_ctrl_cmp;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_cmp <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_cmp <= W_ctrl_cmp_nxt;
      end if;
    end if;

  end process;

  D_ctrl_br_cond <= ((((((((D_op_bge OR D_op_rsv10) OR D_op_blt) OR D_op_bne) OR D_op_rsv62) OR D_op_bgeu) OR D_op_rsv42) OR D_op_bltu) OR D_op_beq) OR D_op_rsv34;
  E_ctrl_br_cond_nxt <= D_ctrl_br_cond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_br_cond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_br_cond <= E_ctrl_br_cond_nxt;
      end if;
    end if;

  end process;

  M_ctrl_br_cond_nxt <= E_ctrl_br_cond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_br_cond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_br_cond <= M_ctrl_br_cond_nxt;
      end if;
    end if;

  end process;

  A_ctrl_br_cond_nxt <= M_ctrl_br_cond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_br_cond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_br_cond <= A_ctrl_br_cond_nxt;
      end if;
    end if;

  end process;

  W_ctrl_br_cond_nxt <= A_ctrl_br_cond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_br_cond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_br_cond <= W_ctrl_br_cond_nxt;
      end if;
    end if;

  end process;

  F_ctrl_br_uncond <= F_op_br OR F_op_rsv02;
  D_ctrl_br_uncond_nxt <= F_ctrl_br_uncond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_br_uncond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_br_uncond <= D_ctrl_br_uncond_nxt;
      end if;
    end if;

  end process;

  E_ctrl_br_uncond_nxt <= D_ctrl_br_uncond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_br_uncond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_br_uncond <= E_ctrl_br_uncond_nxt;
      end if;
    end if;

  end process;

  M_ctrl_br_uncond_nxt <= E_ctrl_br_uncond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_br_uncond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_br_uncond <= M_ctrl_br_uncond_nxt;
      end if;
    end if;

  end process;

  A_ctrl_br_uncond_nxt <= M_ctrl_br_uncond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_br_uncond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_br_uncond <= A_ctrl_br_uncond_nxt;
      end if;
    end if;

  end process;

  W_ctrl_br_uncond_nxt <= A_ctrl_br_uncond;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_br_uncond <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_br_uncond <= W_ctrl_br_uncond_nxt;
      end if;
    end if;

  end process;

  F_ctrl_br <= ((((((F_op_br OR F_op_bge) OR F_op_blt) OR F_op_bne) OR F_op_beq) OR F_op_bgeu) OR F_op_bltu) OR F_op_rsv62;
  D_ctrl_br_nxt <= F_ctrl_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_br <= D_ctrl_br_nxt;
      end if;
    end if;

  end process;

  E_ctrl_br_nxt <= D_ctrl_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_br <= E_ctrl_br_nxt;
      end if;
    end if;

  end process;

  M_ctrl_br_nxt <= E_ctrl_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_br <= M_ctrl_br_nxt;
      end if;
    end if;

  end process;

  A_ctrl_br_nxt <= M_ctrl_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_br <= A_ctrl_br_nxt;
      end if;
    end if;

  end process;

  W_ctrl_br_nxt <= A_ctrl_br;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_br <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_br <= W_ctrl_br_nxt;
      end if;
    end if;

  end process;

  D_ctrl_alu_subtract <= ((((((((((((((D_op_sub OR D_op_rsvx25) OR D_op_cmplti) OR D_op_cmpltui) OR D_op_cmplt) OR D_op_cmpltu) OR D_op_blt) OR D_op_bltu) OR D_op_cmpgei) OR D_op_cmpgeui) OR D_op_cmpge) OR D_op_cmpgeu) OR D_op_bge) OR D_op_rsv10) OR D_op_bgeu) OR D_op_rsv42;
  E_ctrl_alu_subtract_nxt <= D_ctrl_alu_subtract;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_alu_subtract <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_alu_subtract <= E_ctrl_alu_subtract_nxt;
      end if;
    end if;

  end process;

  M_ctrl_alu_subtract_nxt <= E_ctrl_alu_subtract;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_alu_subtract <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_alu_subtract <= M_ctrl_alu_subtract_nxt;
      end if;
    end if;

  end process;

  A_ctrl_alu_subtract_nxt <= M_ctrl_alu_subtract;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_alu_subtract <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_alu_subtract <= A_ctrl_alu_subtract_nxt;
      end if;
    end if;

  end process;

  W_ctrl_alu_subtract_nxt <= A_ctrl_alu_subtract;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_alu_subtract <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_alu_subtract <= W_ctrl_alu_subtract_nxt;
      end if;
    end if;

  end process;

  D_ctrl_alu_signed_comparison <= ((((D_op_cmpge OR D_op_cmpgei) OR D_op_cmplt) OR D_op_cmplti) OR D_op_bge) OR D_op_blt;
  E_ctrl_alu_signed_comparison_nxt <= D_ctrl_alu_signed_comparison;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_alu_signed_comparison <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_alu_signed_comparison <= E_ctrl_alu_signed_comparison_nxt;
      end if;
    end if;

  end process;

  M_ctrl_alu_signed_comparison_nxt <= E_ctrl_alu_signed_comparison;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_alu_signed_comparison <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_alu_signed_comparison <= M_ctrl_alu_signed_comparison_nxt;
      end if;
    end if;

  end process;

  A_ctrl_alu_signed_comparison_nxt <= M_ctrl_alu_signed_comparison;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_alu_signed_comparison <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_alu_signed_comparison <= A_ctrl_alu_signed_comparison_nxt;
      end if;
    end if;

  end process;

  W_ctrl_alu_signed_comparison_nxt <= A_ctrl_alu_signed_comparison;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_alu_signed_comparison <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_alu_signed_comparison <= W_ctrl_alu_signed_comparison_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld8 <= ((E_op_ldb OR E_op_ldbu) OR E_op_ldbio) OR E_op_ldbuio;
  M_ctrl_ld8_nxt <= E_ctrl_ld8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld8 <= M_ctrl_ld8_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld8_nxt <= M_ctrl_ld8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld8 <= A_ctrl_ld8_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld8_nxt <= A_ctrl_ld8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld8 <= W_ctrl_ld8_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld16 <= ((E_op_ldhu OR E_op_ldh) OR E_op_ldhio) OR E_op_ldhuio;
  M_ctrl_ld16_nxt <= E_ctrl_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld16 <= M_ctrl_ld16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld16_nxt <= M_ctrl_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld16 <= A_ctrl_ld16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld16_nxt <= A_ctrl_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld16 <= W_ctrl_ld16_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld8_ld16 <= ((((((E_op_ldb OR E_op_ldbu) OR E_op_ldbio) OR E_op_ldbuio) OR E_op_ldhu) OR E_op_ldh) OR E_op_ldhio) OR E_op_ldhuio;
  M_ctrl_ld8_ld16_nxt <= E_ctrl_ld8_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld8_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld8_ld16 <= M_ctrl_ld8_ld16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld8_ld16_nxt <= M_ctrl_ld8_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld8_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld8_ld16 <= A_ctrl_ld8_ld16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld8_ld16_nxt <= A_ctrl_ld8_ld16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld8_ld16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld8_ld16 <= W_ctrl_ld8_ld16_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld32 <= ((E_op_ldw OR E_op_ldl) OR E_op_ldwio) OR E_op_rsv63;
  M_ctrl_ld32_nxt <= E_ctrl_ld32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld32 <= M_ctrl_ld32_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld32_nxt <= M_ctrl_ld32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld32 <= A_ctrl_ld32_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld32_nxt <= A_ctrl_ld32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld32 <= W_ctrl_ld32_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_signed <= ((((((E_op_ldb OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63;
  M_ctrl_ld_signed_nxt <= E_ctrl_ld_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_signed <= M_ctrl_ld_signed_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_signed_nxt <= M_ctrl_ld_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_signed <= A_ctrl_ld_signed_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_signed_nxt <= A_ctrl_ld_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_signed <= W_ctrl_ld_signed_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld <= ((((((((((E_op_ldb OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio;
  M_ctrl_ld_nxt <= E_ctrl_ld;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld <= M_ctrl_ld_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_nxt <= M_ctrl_ld;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld <= A_ctrl_ld_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_nxt <= A_ctrl_ld;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld <= W_ctrl_ld_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_dcache_management <= ((((((((((((((E_op_initd OR E_op_initda) OR E_op_flushd) OR E_op_flushda) OR E_op_ldb) OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio;
  M_ctrl_ld_dcache_management_nxt <= E_ctrl_ld_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_dcache_management <= M_ctrl_ld_dcache_management_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_dcache_management_nxt <= M_ctrl_ld_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_dcache_management <= A_ctrl_ld_dcache_management_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_dcache_management_nxt <= A_ctrl_ld_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_dcache_management <= W_ctrl_ld_dcache_management_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_non_io <= ((((E_op_ldbu OR E_op_ldhu) OR E_op_ldb) OR E_op_ldh) OR E_op_ldw) OR E_op_ldl;
  M_ctrl_ld_non_io_nxt <= E_ctrl_ld_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_non_io <= M_ctrl_ld_non_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_non_io_nxt <= M_ctrl_ld_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_non_io <= A_ctrl_ld_non_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_non_io_nxt <= A_ctrl_ld_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_non_io <= W_ctrl_ld_non_io_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st8 <= E_op_stb OR E_op_stbio;
  M_ctrl_st8_nxt <= E_ctrl_st8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st8 <= M_ctrl_st8_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st8_nxt <= M_ctrl_st8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st8 <= A_ctrl_st8_nxt;
      end if;
    end if;

  end process;

  W_ctrl_st8_nxt <= A_ctrl_st8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_st8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_st8 <= W_ctrl_st8_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st16 <= ((E_op_sth OR E_op_rsv09) OR E_op_sthio) OR E_op_rsv41;
  M_ctrl_st16_nxt <= E_ctrl_st16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st16 <= M_ctrl_st16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st16_nxt <= M_ctrl_st16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st16 <= A_ctrl_st16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_st16_nxt <= A_ctrl_st16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_st16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_st16 <= W_ctrl_st16_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st <= ((((((E_op_stb OR E_op_sth) OR E_op_stw) OR E_op_stc) OR E_op_stbio) OR E_op_sthio) OR E_op_stwio) OR E_op_rsv61;
  M_ctrl_st_nxt <= E_ctrl_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st <= M_ctrl_st_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st_nxt <= M_ctrl_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st <= A_ctrl_st_nxt;
      end if;
    end if;

  end process;

  W_ctrl_st_nxt <= A_ctrl_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_st <= W_ctrl_st_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st_non_io <= ((E_op_stb OR E_op_sth) OR E_op_stw) OR E_op_stc;
  M_ctrl_st_non_io_nxt <= E_ctrl_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st_non_io <= M_ctrl_st_non_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st_non_io_nxt <= M_ctrl_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st_non_io <= A_ctrl_st_non_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_st_non_io_nxt <= A_ctrl_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_st_non_io <= W_ctrl_st_non_io_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st <= ((((((((((((((((((E_op_ldb OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio) OR E_op_stb) OR E_op_sth) OR E_op_stw) OR E_op_stc) OR E_op_stbio) OR E_op_sthio) OR E_op_stwio) OR E_op_rsv61;
  M_ctrl_ld_st_nxt <= E_ctrl_ld_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st <= M_ctrl_ld_st_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_nxt <= M_ctrl_ld_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st <= A_ctrl_ld_st_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_st_nxt <= A_ctrl_ld_st;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_st <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_st <= W_ctrl_ld_st_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_io <= ((((((((((((E_op_ldbuio OR E_op_ldhuio) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_stbio) OR E_op_rsv33) OR E_op_sthio) OR E_op_rsv41) OR E_op_stwio) OR E_op_rsv49) OR E_op_rsv61) OR E_op_rsv57;
  M_ctrl_ld_st_io_nxt <= E_ctrl_ld_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_io <= M_ctrl_ld_st_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_io_nxt <= M_ctrl_ld_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_io <= A_ctrl_ld_st_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_st_io_nxt <= A_ctrl_ld_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_st_io <= W_ctrl_ld_st_io_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_non_io <= ((((((((E_op_ldbu OR E_op_ldhu) OR E_op_ldb) OR E_op_ldh) OR E_op_ldw) OR E_op_ldl) OR E_op_stb) OR E_op_sth) OR E_op_stw) OR E_op_stc;
  M_ctrl_ld_st_non_io_nxt <= E_ctrl_ld_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_non_io <= M_ctrl_ld_st_non_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_non_io_nxt <= M_ctrl_ld_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_non_io <= A_ctrl_ld_st_non_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_st_non_io_nxt <= A_ctrl_ld_st_non_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_st_non_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_st_non_io <= W_ctrl_ld_st_non_io_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_non_io_non_st32 <= ((((((E_op_stb OR E_op_sth) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldb) OR E_op_ldh) OR E_op_ldw) OR E_op_ldl;
  M_ctrl_ld_st_non_io_non_st32_nxt <= E_ctrl_ld_st_non_io_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_non_io_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_non_io_non_st32 <= M_ctrl_ld_st_non_io_non_st32_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_non_io_non_st32_nxt <= M_ctrl_ld_st_non_io_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_non_io_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_non_io_non_st32 <= A_ctrl_ld_st_non_io_non_st32_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_st_non_io_non_st32_nxt <= A_ctrl_ld_st_non_io_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_st_non_io_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_st_non_io_non_st32 <= W_ctrl_ld_st_non_io_non_st32_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_st_non_st32 <= ((((((((((((((((E_op_ldb OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio) OR E_op_stb) OR E_op_stbio) OR E_op_sth) OR E_op_rsv09) OR E_op_sthio) OR E_op_rsv41;
  M_ctrl_ld_st_non_st32_nxt <= E_ctrl_ld_st_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_st_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_st_non_st32 <= M_ctrl_ld_st_non_st32_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_st_non_st32_nxt <= M_ctrl_ld_st_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_st_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_st_non_st32 <= A_ctrl_ld_st_non_st32_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_st_non_st32_nxt <= A_ctrl_ld_st_non_st32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_st_non_st32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_st_non_st32 <= W_ctrl_ld_st_non_st32_nxt;
      end if;
    end if;

  end process;

  E_ctrl_mem <= ((((((((((((((((((((((E_op_initd OR E_op_initda) OR E_op_flushd) OR E_op_flushda) OR E_op_ldb) OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio) OR E_op_stb) OR E_op_sth) OR E_op_stw) OR E_op_stc) OR E_op_stbio) OR E_op_sthio) OR E_op_stwio) OR E_op_rsv61;
  M_ctrl_mem_nxt <= E_ctrl_mem;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mem <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mem <= M_ctrl_mem_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mem_nxt <= M_ctrl_mem;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mem <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mem <= A_ctrl_mem_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mem_nxt <= A_ctrl_mem;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mem <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mem <= W_ctrl_mem_nxt;
      end if;
    end if;

  end process;

  E_ctrl_mem_data_access <= ((((((((((((((((((((E_op_flushda OR E_op_initda) OR E_op_ldb) OR E_op_ldh) OR E_op_ldl) OR E_op_ldw) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63) OR E_op_ldbu) OR E_op_ldhu) OR E_op_ldbuio) OR E_op_ldhuio) OR E_op_stb) OR E_op_sth) OR E_op_stw) OR E_op_stc) OR E_op_stbio) OR E_op_sthio) OR E_op_stwio) OR E_op_rsv61;
  M_ctrl_mem_data_access_nxt <= E_ctrl_mem_data_access;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mem_data_access <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mem_data_access <= M_ctrl_mem_data_access_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mem_data_access_nxt <= M_ctrl_mem_data_access;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mem_data_access <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mem_data_access <= A_ctrl_mem_data_access_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mem_data_access_nxt <= A_ctrl_mem_data_access;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mem_data_access <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mem_data_access <= W_ctrl_mem_data_access_nxt;
      end if;
    end if;

  end process;

  E_ctrl_mem8 <= ((((E_op_ldb OR E_op_ldbu) OR E_op_ldbio) OR E_op_ldbuio) OR E_op_stb) OR E_op_stbio;
  M_ctrl_mem8_nxt <= E_ctrl_mem8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mem8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mem8 <= M_ctrl_mem8_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mem8_nxt <= M_ctrl_mem8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mem8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mem8 <= A_ctrl_mem8_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mem8_nxt <= A_ctrl_mem8;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mem8 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mem8 <= W_ctrl_mem8_nxt;
      end if;
    end if;

  end process;

  E_ctrl_mem16 <= ((((((E_op_ldhu OR E_op_ldh) OR E_op_ldhio) OR E_op_ldhuio) OR E_op_sth) OR E_op_rsv09) OR E_op_sthio) OR E_op_rsv41;
  M_ctrl_mem16_nxt <= E_ctrl_mem16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mem16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mem16 <= M_ctrl_mem16_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mem16_nxt <= M_ctrl_mem16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mem16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mem16 <= A_ctrl_mem16_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mem16_nxt <= A_ctrl_mem16;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mem16 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mem16 <= W_ctrl_mem16_nxt;
      end if;
    end if;

  end process;

  E_ctrl_mem32 <= ((((((((((E_op_ldw OR E_op_ldl) OR E_op_ldwio) OR E_op_rsv63) OR E_op_stw) OR E_op_rsv17) OR E_op_stc) OR E_op_rsv25) OR E_op_stwio) OR E_op_rsv49) OR E_op_rsv61) OR E_op_rsv57;
  M_ctrl_mem32_nxt <= E_ctrl_mem32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mem32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mem32 <= M_ctrl_mem32_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mem32_nxt <= M_ctrl_mem32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mem32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mem32 <= A_ctrl_mem32_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mem32_nxt <= A_ctrl_mem32;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mem32 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mem32 <= W_ctrl_mem32_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_index_nowb_inv <= E_op_initd OR E_op_rsv49;
  M_ctrl_dc_index_nowb_inv_nxt <= E_ctrl_dc_index_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_index_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_index_nowb_inv <= M_ctrl_dc_index_nowb_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_index_nowb_inv_nxt <= M_ctrl_dc_index_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_index_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_index_nowb_inv <= A_ctrl_dc_index_nowb_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_index_nowb_inv_nxt <= A_ctrl_dc_index_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_index_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_index_nowb_inv <= W_ctrl_dc_index_nowb_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_addr_nowb_inv <= E_op_initda OR E_op_rsv17;
  M_ctrl_dc_addr_nowb_inv_nxt <= E_ctrl_dc_addr_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_addr_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_addr_nowb_inv <= M_ctrl_dc_addr_nowb_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_addr_nowb_inv_nxt <= M_ctrl_dc_addr_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_addr_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_addr_nowb_inv <= A_ctrl_dc_addr_nowb_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_addr_nowb_inv_nxt <= A_ctrl_dc_addr_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_addr_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_addr_nowb_inv <= W_ctrl_dc_addr_nowb_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_index_wb_inv <= E_op_flushd OR E_op_rsv57;
  M_ctrl_dc_index_wb_inv_nxt <= E_ctrl_dc_index_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_index_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_index_wb_inv <= M_ctrl_dc_index_wb_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_index_wb_inv_nxt <= M_ctrl_dc_index_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_index_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_index_wb_inv <= A_ctrl_dc_index_wb_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_index_wb_inv_nxt <= A_ctrl_dc_index_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_index_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_index_wb_inv <= W_ctrl_dc_index_wb_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_addr_wb_inv <= E_op_flushda OR E_op_rsv25;
  M_ctrl_dc_addr_wb_inv_nxt <= E_ctrl_dc_addr_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_addr_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_addr_wb_inv <= M_ctrl_dc_addr_wb_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_addr_wb_inv_nxt <= M_ctrl_dc_addr_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_addr_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_addr_wb_inv <= A_ctrl_dc_addr_wb_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_addr_wb_inv_nxt <= A_ctrl_dc_addr_wb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_addr_wb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_addr_wb_inv <= W_ctrl_dc_addr_wb_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_index_inv <= ((E_op_initd OR E_op_rsv49) OR E_op_flushd) OR E_op_rsv57;
  M_ctrl_dc_index_inv_nxt <= E_ctrl_dc_index_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_index_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_index_inv <= M_ctrl_dc_index_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_index_inv_nxt <= M_ctrl_dc_index_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_index_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_index_inv <= A_ctrl_dc_index_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_index_inv_nxt <= A_ctrl_dc_index_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_index_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_index_inv <= W_ctrl_dc_index_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_addr_inv <= ((E_op_initda OR E_op_rsv17) OR E_op_flushda) OR E_op_rsv25;
  M_ctrl_dc_addr_inv_nxt <= E_ctrl_dc_addr_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_addr_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_addr_inv <= M_ctrl_dc_addr_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_addr_inv_nxt <= M_ctrl_dc_addr_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_addr_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_addr_inv <= A_ctrl_dc_addr_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_addr_inv_nxt <= A_ctrl_dc_addr_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_addr_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_addr_inv <= W_ctrl_dc_addr_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dc_nowb_inv <= ((E_op_initd OR E_op_rsv49) OR E_op_initda) OR E_op_rsv17;
  M_ctrl_dc_nowb_inv_nxt <= E_ctrl_dc_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dc_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dc_nowb_inv <= M_ctrl_dc_nowb_inv_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dc_nowb_inv_nxt <= M_ctrl_dc_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dc_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dc_nowb_inv <= A_ctrl_dc_nowb_inv_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dc_nowb_inv_nxt <= A_ctrl_dc_nowb_inv;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dc_nowb_inv <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dc_nowb_inv <= W_ctrl_dc_nowb_inv_nxt;
      end if;
    end if;

  end process;

  E_ctrl_dcache_management <= ((((((E_op_initd OR E_op_rsv49) OR E_op_flushd) OR E_op_rsv57) OR E_op_initda) OR E_op_rsv17) OR E_op_flushda) OR E_op_rsv25;
  M_ctrl_dcache_management_nxt <= E_ctrl_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_dcache_management <= M_ctrl_dcache_management_nxt;
      end if;
    end if;

  end process;

  A_ctrl_dcache_management_nxt <= M_ctrl_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_dcache_management <= A_ctrl_dcache_management_nxt;
      end if;
    end if;

  end process;

  W_ctrl_dcache_management_nxt <= A_ctrl_dcache_management;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_dcache_management <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_dcache_management <= W_ctrl_dcache_management_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ld_io <= ((((E_op_ldbuio OR E_op_ldhuio) OR E_op_ldbio) OR E_op_ldhio) OR E_op_ldwio) OR E_op_rsv63;
  M_ctrl_ld_io_nxt <= E_ctrl_ld_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ld_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ld_io <= M_ctrl_ld_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ld_io_nxt <= M_ctrl_ld_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ld_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ld_io <= A_ctrl_ld_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ld_io_nxt <= A_ctrl_ld_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ld_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ld_io <= W_ctrl_ld_io_nxt;
      end if;
    end if;

  end process;

  E_ctrl_st_io <= ((((((E_op_stbio OR E_op_rsv33) OR E_op_sthio) OR E_op_rsv41) OR E_op_stwio) OR E_op_rsv49) OR E_op_rsv61) OR E_op_rsv57;
  M_ctrl_st_io_nxt <= E_ctrl_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_st_io <= M_ctrl_st_io_nxt;
      end if;
    end if;

  end process;

  A_ctrl_st_io_nxt <= M_ctrl_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_st_io <= A_ctrl_st_io_nxt;
      end if;
    end if;

  end process;

  W_ctrl_st_io_nxt <= A_ctrl_st_io;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_st_io <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_st_io <= W_ctrl_st_io_nxt;
      end if;
    end if;

  end process;

  F_ctrl_a_not_src <= ((F_op_call OR F_op_jmpi)) OR ((F_op_custom AND NOT F_iw_custom_readra));
  D_ctrl_a_not_src_nxt <= F_ctrl_a_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_a_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_a_not_src <= D_ctrl_a_not_src_nxt;
      end if;
    end if;

  end process;

  E_ctrl_a_not_src_nxt <= D_ctrl_a_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_a_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_a_not_src <= E_ctrl_a_not_src_nxt;
      end if;
    end if;

  end process;

  M_ctrl_a_not_src_nxt <= E_ctrl_a_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_a_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_a_not_src <= M_ctrl_a_not_src_nxt;
      end if;
    end if;

  end process;

  A_ctrl_a_not_src_nxt <= M_ctrl_a_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_a_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_a_not_src <= A_ctrl_a_not_src_nxt;
      end if;
    end if;

  end process;

  W_ctrl_a_not_src_nxt <= A_ctrl_a_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_a_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_a_not_src <= W_ctrl_a_not_src_nxt;
      end if;
    end if;

  end process;

  F_ctrl_b_not_src <= ((((((((((((((((((((((((((((((((((((((((F_op_addi OR F_op_muli) OR F_op_andhi) OR F_op_orhi) OR F_op_xorhi) OR F_op_andi) OR F_op_ori) OR F_op_xori) OR F_op_call) OR F_op_rsv56) OR F_op_cmpgei) OR F_op_cmplti) OR F_op_cmpnei) OR F_op_cmpgeui) OR F_op_cmpltui) OR F_op_cmpeqi) OR F_op_jmpi) OR F_op_rsv09) OR F_op_rsv17) OR F_op_rsv25) OR F_op_rsv33) OR F_op_rsv41) OR F_op_rsv49) OR F_op_rsv57) OR F_op_ldb) OR F_op_ldh) OR F_op_ldl) OR F_op_ldw) OR F_op_ldbio) OR F_op_ldhio) OR F_op_ldwio) OR F_op_rsv63) OR F_op_ldbu) OR F_op_ldhu) OR F_op_ldbuio) OR F_op_ldhuio) OR F_op_initd) OR F_op_initda) OR F_op_flushd) OR F_op_flushda)) OR ((F_op_custom AND NOT F_iw_custom_readrb));
  D_ctrl_b_not_src_nxt <= F_ctrl_b_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_b_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_b_not_src <= D_ctrl_b_not_src_nxt;
      end if;
    end if;

  end process;

  E_ctrl_b_not_src_nxt <= D_ctrl_b_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_b_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_b_not_src <= E_ctrl_b_not_src_nxt;
      end if;
    end if;

  end process;

  M_ctrl_b_not_src_nxt <= E_ctrl_b_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_b_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_b_not_src <= M_ctrl_b_not_src_nxt;
      end if;
    end if;

  end process;

  A_ctrl_b_not_src_nxt <= M_ctrl_b_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_b_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_b_not_src <= A_ctrl_b_not_src_nxt;
      end if;
    end if;

  end process;

  W_ctrl_b_not_src_nxt <= A_ctrl_b_not_src;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_b_not_src <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_b_not_src <= W_ctrl_b_not_src_nxt;
      end if;
    end if;

  end process;

  F_ctrl_b_is_dst <= ((((((((((((((((((((((((((((((((((((((((F_op_addi OR F_op_muli) OR F_op_andhi) OR F_op_orhi) OR F_op_xorhi) OR F_op_andi) OR F_op_ori) OR F_op_xori) OR F_op_call) OR F_op_rsv56) OR F_op_cmpgei) OR F_op_cmplti) OR F_op_cmpnei) OR F_op_cmpgeui) OR F_op_cmpltui) OR F_op_cmpeqi) OR F_op_jmpi) OR F_op_rsv09) OR F_op_rsv17) OR F_op_rsv25) OR F_op_rsv33) OR F_op_rsv41) OR F_op_rsv49) OR F_op_rsv57) OR F_op_ldb) OR F_op_ldh) OR F_op_ldl) OR F_op_ldw) OR F_op_ldbio) OR F_op_ldhio) OR F_op_ldwio) OR F_op_rsv63) OR F_op_ldbu) OR F_op_ldhu) OR F_op_ldbuio) OR F_op_ldhuio) OR F_op_initd) OR F_op_initda) OR F_op_flushd) OR F_op_flushda)) AND NOT F_op_custom;
  D_ctrl_b_is_dst_nxt <= F_ctrl_b_is_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_b_is_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_b_is_dst <= D_ctrl_b_is_dst_nxt;
      end if;
    end if;

  end process;

  E_ctrl_b_is_dst_nxt <= D_ctrl_b_is_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_b_is_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_b_is_dst <= E_ctrl_b_is_dst_nxt;
      end if;
    end if;

  end process;

  M_ctrl_b_is_dst_nxt <= E_ctrl_b_is_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_b_is_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_b_is_dst <= M_ctrl_b_is_dst_nxt;
      end if;
    end if;

  end process;

  A_ctrl_b_is_dst_nxt <= M_ctrl_b_is_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_b_is_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_b_is_dst <= A_ctrl_b_is_dst_nxt;
      end if;
    end if;

  end process;

  W_ctrl_b_is_dst_nxt <= A_ctrl_b_is_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_b_is_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_b_is_dst <= W_ctrl_b_is_dst_nxt;
      end if;
    end if;

  end process;

  F_ctrl_ignore_dst <= ((((((((((((((((((((((((F_op_br OR F_op_bge) OR F_op_blt) OR F_op_bne) OR F_op_beq) OR F_op_bgeu) OR F_op_bltu) OR F_op_rsv62) OR F_op_stb) OR F_op_sth) OR F_op_stw) OR F_op_stc) OR F_op_stbio) OR F_op_sthio) OR F_op_stwio) OR F_op_rsv61) OR F_op_jmpi) OR F_op_rsv09) OR F_op_rsv17) OR F_op_rsv25) OR F_op_rsv33) OR F_op_rsv41) OR F_op_rsv49) OR F_op_rsv57)) OR ((F_op_custom AND NOT F_iw_custom_writerc));
  D_ctrl_ignore_dst_nxt <= F_ctrl_ignore_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      D_ctrl_ignore_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(D_en) = '1' then 
        D_ctrl_ignore_dst <= D_ctrl_ignore_dst_nxt;
      end if;
    end if;

  end process;

  E_ctrl_ignore_dst_nxt <= D_ctrl_ignore_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_ignore_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_ignore_dst <= E_ctrl_ignore_dst_nxt;
      end if;
    end if;

  end process;

  M_ctrl_ignore_dst_nxt <= E_ctrl_ignore_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_ignore_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_ignore_dst <= M_ctrl_ignore_dst_nxt;
      end if;
    end if;

  end process;

  A_ctrl_ignore_dst_nxt <= M_ctrl_ignore_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_ignore_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_ignore_dst <= A_ctrl_ignore_dst_nxt;
      end if;
    end if;

  end process;

  W_ctrl_ignore_dst_nxt <= A_ctrl_ignore_dst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_ignore_dst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_ignore_dst <= W_ctrl_ignore_dst_nxt;
      end if;
    end if;

  end process;

  D_ctrl_src2_choose_imm <= ((((((((((((((((((((((((((((((((((((((((((((((((((((((D_op_addi OR D_op_muli) OR D_op_andhi) OR D_op_orhi) OR D_op_xorhi) OR D_op_andi) OR D_op_ori) OR D_op_xori) OR D_op_call) OR D_op_rsv56) OR D_op_cmpgei) OR D_op_cmplti) OR D_op_cmpnei) OR D_op_cmpgeui) OR D_op_cmpltui) OR D_op_cmpeqi) OR D_op_jmpi) OR D_op_rsv09) OR D_op_rsv17) OR D_op_rsv25) OR D_op_rsv33) OR D_op_rsv41) OR D_op_rsv49) OR D_op_rsv57) OR D_op_ldb) OR D_op_ldh) OR D_op_ldl) OR D_op_ldw) OR D_op_ldbio) OR D_op_ldhio) OR D_op_ldwio) OR D_op_rsv63) OR D_op_ldbu) OR D_op_ldhu) OR D_op_ldbuio) OR D_op_ldhuio) OR D_op_initd) OR D_op_initda) OR D_op_flushd) OR D_op_flushda) OR D_op_stb) OR D_op_sth) OR D_op_stw) OR D_op_stc) OR D_op_stbio) OR D_op_sthio) OR D_op_stwio) OR D_op_rsv61) OR D_op_roli) OR D_op_rsvx10) OR D_op_slli) OR D_op_srli) OR D_op_rsvx34) OR D_op_rsvx42) OR D_op_rsvx50) OR D_op_srai;
  E_ctrl_src2_choose_imm_nxt <= D_ctrl_src2_choose_imm;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_src2_choose_imm <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_src2_choose_imm <= E_ctrl_src2_choose_imm_nxt;
      end if;
    end if;

  end process;

  M_ctrl_src2_choose_imm_nxt <= E_ctrl_src2_choose_imm;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_src2_choose_imm <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_src2_choose_imm <= M_ctrl_src2_choose_imm_nxt;
      end if;
    end if;

  end process;

  A_ctrl_src2_choose_imm_nxt <= M_ctrl_src2_choose_imm;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_src2_choose_imm <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_src2_choose_imm <= A_ctrl_src2_choose_imm_nxt;
      end if;
    end if;

  end process;

  W_ctrl_src2_choose_imm_nxt <= A_ctrl_src2_choose_imm;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_src2_choose_imm <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_src2_choose_imm <= W_ctrl_src2_choose_imm_nxt;
      end if;
    end if;

  end process;

  E_ctrl_wrctl_inst <= E_op_wrctl;
  M_ctrl_wrctl_inst_nxt <= E_ctrl_wrctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_wrctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_wrctl_inst <= M_ctrl_wrctl_inst_nxt;
      end if;
    end if;

  end process;

  A_ctrl_wrctl_inst_nxt <= M_ctrl_wrctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_wrctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_wrctl_inst <= A_ctrl_wrctl_inst_nxt;
      end if;
    end if;

  end process;

  W_ctrl_wrctl_inst_nxt <= A_ctrl_wrctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_wrctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_wrctl_inst <= W_ctrl_wrctl_inst_nxt;
      end if;
    end if;

  end process;

  E_ctrl_rdctl_inst <= E_op_rdctl;
  M_ctrl_rdctl_inst_nxt <= E_ctrl_rdctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_rdctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_rdctl_inst <= M_ctrl_rdctl_inst_nxt;
      end if;
    end if;

  end process;

  A_ctrl_rdctl_inst_nxt <= M_ctrl_rdctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_rdctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_rdctl_inst <= A_ctrl_rdctl_inst_nxt;
      end if;
    end if;

  end process;

  W_ctrl_rdctl_inst_nxt <= A_ctrl_rdctl_inst;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_rdctl_inst <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_rdctl_inst <= W_ctrl_rdctl_inst_nxt;
      end if;
    end if;

  end process;

  D_ctrl_mul_shift_src1_signed <= ((D_op_mulxss OR D_op_mulxsu) OR D_op_srai) OR D_op_sra;
  E_ctrl_mul_shift_src1_signed_nxt <= D_ctrl_mul_shift_src1_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_mul_shift_src1_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_mul_shift_src1_signed <= E_ctrl_mul_shift_src1_signed_nxt;
      end if;
    end if;

  end process;

  M_ctrl_mul_shift_src1_signed_nxt <= E_ctrl_mul_shift_src1_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mul_shift_src1_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mul_shift_src1_signed <= M_ctrl_mul_shift_src1_signed_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mul_shift_src1_signed_nxt <= M_ctrl_mul_shift_src1_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mul_shift_src1_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mul_shift_src1_signed <= A_ctrl_mul_shift_src1_signed_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mul_shift_src1_signed_nxt <= A_ctrl_mul_shift_src1_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mul_shift_src1_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mul_shift_src1_signed <= W_ctrl_mul_shift_src1_signed_nxt;
      end if;
    end if;

  end process;

  D_ctrl_mul_shift_src2_signed <= D_op_mulxss;
  E_ctrl_mul_shift_src2_signed_nxt <= D_ctrl_mul_shift_src2_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_mul_shift_src2_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_mul_shift_src2_signed <= E_ctrl_mul_shift_src2_signed_nxt;
      end if;
    end if;

  end process;

  M_ctrl_mul_shift_src2_signed_nxt <= E_ctrl_mul_shift_src2_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_mul_shift_src2_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_mul_shift_src2_signed <= M_ctrl_mul_shift_src2_signed_nxt;
      end if;
    end if;

  end process;

  A_ctrl_mul_shift_src2_signed_nxt <= M_ctrl_mul_shift_src2_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mul_shift_src2_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mul_shift_src2_signed <= A_ctrl_mul_shift_src2_signed_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mul_shift_src2_signed_nxt <= A_ctrl_mul_shift_src2_signed;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mul_shift_src2_signed <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mul_shift_src2_signed <= W_ctrl_mul_shift_src2_signed_nxt;
      end if;
    end if;

  end process;

  M_ctrl_mul_shift_rot <= (((((((((((((((((((((((M_op_muli OR M_op_mul) OR M_op_rsvx47) OR M_op_rsvx55) OR M_op_rsvx63) OR M_op_mulxuu) OR M_op_rsvx15) OR M_op_mulxsu) OR M_op_mulxss) OR M_op_slli) OR M_op_rsvx50) OR M_op_sll) OR M_op_rsvx51) OR M_op_roli) OR M_op_rsvx34) OR M_op_rol) OR M_op_rsvx35) OR M_op_srli) OR M_op_srl) OR M_op_srai) OR M_op_sra) OR M_op_rsvx10) OR M_op_ror) OR M_op_rsvx42) OR M_op_rsvx43;
  A_ctrl_mul_shift_rot_nxt <= M_ctrl_mul_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_mul_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_mul_shift_rot <= A_ctrl_mul_shift_rot_nxt;
      end if;
    end if;

  end process;

  W_ctrl_mul_shift_rot_nxt <= A_ctrl_mul_shift_rot;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_mul_shift_rot <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_mul_shift_rot <= W_ctrl_mul_shift_rot_nxt;
      end if;
    end if;

  end process;

  D_ctrl_flush_pipe_always <= ((((((((((((((D_op_flushp OR D_op_bret) OR D_op_initi) OR D_op_flushi) OR D_op_wrctl) OR D_op_eret) OR D_op_trap) OR D_op_rsvx44) OR D_op_div) OR D_op_divu) OR D_op_intr) OR D_op_rsvx60) OR D_op_break) OR D_op_hbreak) OR D_op_crst) OR D_op_rsvx63;
  E_ctrl_flush_pipe_always_nxt <= D_ctrl_flush_pipe_always;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_flush_pipe_always <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_flush_pipe_always <= E_ctrl_flush_pipe_always_nxt;
      end if;
    end if;

  end process;

  M_ctrl_flush_pipe_always_nxt <= E_ctrl_flush_pipe_always;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_flush_pipe_always <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_flush_pipe_always <= M_ctrl_flush_pipe_always_nxt;
      end if;
    end if;

  end process;

  A_ctrl_flush_pipe_always_nxt <= M_ctrl_flush_pipe_always;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_flush_pipe_always <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_flush_pipe_always <= A_ctrl_flush_pipe_always_nxt;
      end if;
    end if;

  end process;

  W_ctrl_flush_pipe_always_nxt <= A_ctrl_flush_pipe_always;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_flush_pipe_always <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_flush_pipe_always <= W_ctrl_flush_pipe_always_nxt;
      end if;
    end if;

  end process;

  D_ctrl_alu_force_xor <= ((((((((((((((D_op_cmpgei OR D_op_cmpgeui) OR D_op_cmpeqi) OR D_op_cmpge) OR D_op_cmpgeu) OR D_op_cmpeq) OR D_op_cmpnei) OR D_op_cmpne) OR D_op_bge) OR D_op_rsv10) OR D_op_bgeu) OR D_op_rsv42) OR D_op_beq) OR D_op_rsv34) OR D_op_bne) OR D_op_rsv62;
  E_ctrl_alu_force_xor_nxt <= D_ctrl_alu_force_xor;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_alu_force_xor <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_alu_force_xor <= E_ctrl_alu_force_xor_nxt;
      end if;
    end if;

  end process;

  M_ctrl_alu_force_xor_nxt <= E_ctrl_alu_force_xor;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_alu_force_xor <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_alu_force_xor <= M_ctrl_alu_force_xor_nxt;
      end if;
    end if;

  end process;

  A_ctrl_alu_force_xor_nxt <= M_ctrl_alu_force_xor;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_alu_force_xor <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_alu_force_xor <= A_ctrl_alu_force_xor_nxt;
      end if;
    end if;

  end process;

  W_ctrl_alu_force_xor_nxt <= A_ctrl_alu_force_xor;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_alu_force_xor <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_alu_force_xor <= W_ctrl_alu_force_xor_nxt;
      end if;
    end if;

  end process;

  D_ctrl_late_result <= ((((((((((((((((((((((((((((((((((((D_op_ldb OR D_op_ldh) OR D_op_ldl) OR D_op_ldw) OR D_op_ldbio) OR D_op_ldhio) OR D_op_ldwio) OR D_op_rsv63) OR D_op_ldbu) OR D_op_ldhu) OR D_op_ldbuio) OR D_op_ldhuio) OR D_op_slli) OR D_op_rsvx50) OR D_op_sll) OR D_op_rsvx51) OR D_op_roli) OR D_op_rsvx34) OR D_op_rol) OR D_op_rsvx35) OR D_op_srli) OR D_op_srl) OR D_op_srai) OR D_op_sra) OR D_op_rsvx10) OR D_op_ror) OR D_op_rsvx42) OR D_op_rsvx43) OR D_op_rdctl) OR D_op_muli) OR D_op_mul) OR D_op_rsvx47) OR D_op_rsvx55) OR D_op_rsvx63) OR D_op_mulxuu) OR D_op_rsvx15) OR D_op_mulxsu) OR D_op_mulxss;
  E_ctrl_late_result_nxt <= D_ctrl_late_result;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      E_ctrl_late_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(E_en) = '1' then 
        E_ctrl_late_result <= E_ctrl_late_result_nxt;
      end if;
    end if;

  end process;

  M_ctrl_late_result_nxt <= E_ctrl_late_result;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      M_ctrl_late_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(M_en) = '1' then 
        M_ctrl_late_result <= M_ctrl_late_result_nxt;
      end if;
    end if;

  end process;

  A_ctrl_late_result_nxt <= M_ctrl_late_result;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_ctrl_late_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_ctrl_late_result <= A_ctrl_late_result_nxt;
      end if;
    end if;

  end process;

  W_ctrl_late_result_nxt <= A_ctrl_late_result;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      W_ctrl_late_result <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(W_en) = '1' then 
        W_ctrl_late_result <= W_ctrl_late_result_nxt;
      end if;
    end if;

  end process;

  --data_master, which is an e_avalon_master
  --instruction_master, which is an e_avalon_master
  --vhdl renameroo for output signals
  d_address <= internal_d_address;
  --vhdl renameroo for output signals
  d_byteenable <= internal_d_byteenable;
  --vhdl renameroo for output signals
  d_read <= internal_d_read;
  --vhdl renameroo for output signals
  d_write <= internal_d_write;
  --vhdl renameroo for output signals
  d_writedata <= internal_d_writedata;
  --vhdl renameroo for output signals
  i_address <= internal_i_address;
  --vhdl renameroo for output signals
  i_read <= internal_i_read;
  --vhdl renameroo for output signals
  jtag_debug_module_debugaccess_to_roms <= internal_jtag_debug_module_debugaccess_to_roms;
  --vhdl renameroo for output signals
  jtag_debug_module_readdata <= internal_jtag_debug_module_readdata;
  --vhdl renameroo for output signals
  jtag_debug_module_resetrequest <= internal_jtag_debug_module_resetrequest;
  --vhdl renameroo for output signals
  jtag_debug_offchip_trace_clk <= internal_jtag_debug_offchip_trace_clk;
  --vhdl renameroo for output signals
  jtag_debug_offchip_trace_data <= internal_jtag_debug_offchip_trace_data;
  --vhdl renameroo for output signals
  jtag_debug_trigout <= internal_jtag_debug_trigout;
--synthesis translate_off
    F_inst <= A_WE_StdLogicVector((std_logic'((F_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((F_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((F_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((F_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((F_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((F_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((F_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((F_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((F_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((F_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((F_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((F_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((F_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((F_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((F_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((F_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((F_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((F_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((F_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((F_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((F_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((F_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((F_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((F_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((F_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((F_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((F_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((F_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((F_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((F_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((F_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((F_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((F_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((F_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((F_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((F_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((F_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((F_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((F_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((F_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((F_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((F_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((F_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((F_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((F_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((F_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((F_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((F_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((F_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((F_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((F_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((F_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((F_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((F_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((F_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((F_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((F_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((F_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((F_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((F_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((F_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((F_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((F_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((F_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((F_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((F_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((F_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((F_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((F_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((F_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((F_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((F_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((F_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((F_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((F_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((F_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((F_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((F_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((F_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((F_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((F_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    D_inst <= A_WE_StdLogicVector((std_logic'((D_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((D_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((D_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((D_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((D_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((D_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((D_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((D_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((D_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((D_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((D_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((D_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((D_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((D_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((D_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((D_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((D_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((D_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((D_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((D_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((D_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((D_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((D_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((D_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((D_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((D_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((D_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((D_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((D_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((D_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((D_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((D_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((D_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((D_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((D_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((D_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((D_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((D_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((D_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((D_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((D_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((D_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((D_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((D_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((D_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((D_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((D_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((D_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((D_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((D_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((D_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((D_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((D_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((D_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((D_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((D_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((D_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((D_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((D_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((D_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((D_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((D_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((D_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((D_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((D_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((D_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((D_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((D_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((D_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((D_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((D_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((D_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((D_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((D_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((D_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((D_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((D_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((D_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((D_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((D_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((D_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    E_inst <= A_WE_StdLogicVector((std_logic'((E_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((E_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((E_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((E_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((E_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((E_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((E_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((E_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((E_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((E_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((E_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((E_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((E_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((E_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((E_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((E_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((E_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((E_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((E_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((E_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((E_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((E_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((E_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((E_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((E_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((E_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((E_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((E_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((E_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((E_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((E_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((E_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((E_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((E_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((E_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((E_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((E_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((E_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((E_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((E_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((E_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((E_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((E_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((E_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((E_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((E_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((E_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((E_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((E_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((E_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((E_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((E_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((E_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((E_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((E_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((E_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((E_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((E_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((E_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((E_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((E_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((E_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((E_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((E_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((E_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((E_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((E_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((E_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((E_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((E_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((E_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((E_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((E_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((E_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((E_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((E_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((E_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((E_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((E_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((E_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((E_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    M_inst <= A_WE_StdLogicVector((std_logic'((M_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((M_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((M_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((M_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((M_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((M_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((M_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((M_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((M_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((M_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((M_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((M_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((M_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((M_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((M_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((M_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((M_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((M_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((M_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((M_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((M_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((M_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((M_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((M_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((M_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((M_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((M_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((M_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((M_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((M_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((M_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((M_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((M_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((M_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((M_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((M_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((M_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((M_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((M_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((M_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((M_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((M_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((M_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((M_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((M_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((M_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((M_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((M_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((M_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((M_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((M_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((M_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((M_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((M_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((M_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((M_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((M_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((M_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((M_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((M_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((M_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((M_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((M_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((M_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((M_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((M_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((M_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((M_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((M_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((M_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((M_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((M_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((M_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((M_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((M_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((M_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((M_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((M_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((M_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((M_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((M_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    A_inst <= A_WE_StdLogicVector((std_logic'((A_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((A_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((A_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((A_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((A_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((A_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((A_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((A_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((A_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((A_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((A_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((A_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((A_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((A_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((A_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((A_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((A_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((A_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((A_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((A_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((A_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((A_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((A_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((A_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((A_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((A_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((A_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((A_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((A_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((A_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((A_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((A_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((A_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((A_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((A_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((A_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((A_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((A_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((A_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((A_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((A_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((A_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((A_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((A_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((A_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((A_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((A_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((A_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((A_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((A_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((A_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((A_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((A_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((A_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((A_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((A_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((A_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((A_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((A_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((A_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((A_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((A_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((A_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((A_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((A_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((A_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((A_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((A_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((A_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((A_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((A_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((A_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((A_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((A_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((A_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((A_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((A_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((A_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((A_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((A_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((A_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    W_inst <= A_WE_StdLogicVector((std_logic'((W_op_call)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011000010110110001101100"), A_WE_StdLogicVector((std_logic'((W_op_jmpi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101010011011010111000001101001"), A_WE_StdLogicVector((std_logic'((W_op_ldbu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110001001110101"), A_WE_StdLogicVector((std_logic'((W_op_addi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011001000110010001101001"), A_WE_StdLogicVector((std_logic'((W_op_stb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001100010"), A_WE_StdLogicVector((std_logic'((W_op_br)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010"), A_WE_StdLogicVector((std_logic'((W_op_ldb)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010"), A_WE_StdLogicVector((std_logic'((W_op_cmpgei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101101001"), A_WE_StdLogicVector((std_logic'((W_op_ldhu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101100011001000110100001110101"), A_WE_StdLogicVector((std_logic'((W_op_andi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100001011011100110010001101001"), A_WE_StdLogicVector((std_logic'((W_op_sth)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001101000"), A_WE_StdLogicVector((std_logic'((W_op_bge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110011101100101"), A_WE_StdLogicVector((std_logic'((W_op_ldh)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000"), A_WE_StdLogicVector((std_logic'((W_op_cmplti)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001101001"), A_WE_StdLogicVector((std_logic'((W_op_initda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010010110111001101001011101000110010001100001"), A_WE_StdLogicVector((std_logic'((W_op_ori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((W_op_stw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010001110111"), A_WE_StdLogicVector((std_logic'((W_op_blt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110110001110100"), A_WE_StdLogicVector((std_logic'((W_op_ldw)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001110111"), A_WE_StdLogicVector((std_logic'((W_op_cmpnei)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011100110010101101001"), A_WE_StdLogicVector((std_logic'((W_op_flushda)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100110011011000111010101110011011010000110010001100001"), A_WE_StdLogicVector((std_logic'((W_op_xori)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001111000011011110111001001101001"), A_WE_StdLogicVector((std_logic'((W_op_bne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110111001100101"), A_WE_StdLogicVector((std_logic'((W_op_cmpeqi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001010111000101101001"), A_WE_StdLogicVector((std_logic'((W_op_ldbuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001100010011101010110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_muli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101101011101010110110001101001"), A_WE_StdLogicVector((std_logic'((W_op_stbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_beq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000100110010101110001"), A_WE_StdLogicVector((std_logic'((W_op_ldbio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011000100110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_cmpgeui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001100111011001010111010101101001"), A_WE_StdLogicVector((std_logic'((W_op_ldhuio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011000110010001101000011101010110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_andhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110000101101110011001000110100001101001"), A_WE_StdLogicVector((std_logic'((W_op_sthio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_bgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011001110110010101110101"), A_WE_StdLogicVector((std_logic'((W_op_ldhio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011010000110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_cmpltui)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100011011011010111000001101100011101000111010101101001"), A_WE_StdLogicVector((std_logic'((W_op_initd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001100100"), A_WE_StdLogicVector((std_logic'((W_op_orhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((W_op_stwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001101110100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_bltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011011000111010001110101"), A_WE_StdLogicVector((std_logic'((W_op_ldwio)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110110001100100011101110110100101101111"), A_WE_StdLogicVector((std_logic'((W_op_flushd)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001100100"), A_WE_StdLogicVector((std_logic'((W_op_xorhi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111100001101111011100100110100001101001"), A_WE_StdLogicVector((std_logic'((W_op_eret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100101011100100110010101110100"), A_WE_StdLogicVector((std_logic'((W_op_roli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110010011011110110110001101001"), A_WE_StdLogicVector((std_logic'((W_op_rol)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101101100"), A_WE_StdLogicVector((std_logic'((W_op_flushp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001110000"), A_WE_StdLogicVector((std_logic'((W_op_ret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110010101110100"), A_WE_StdLogicVector((std_logic'((W_op_nor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110111101110010"), A_WE_StdLogicVector((std_logic'((W_op_mulxuu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111010101110101"), A_WE_StdLogicVector((std_logic'((W_op_cmpge)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110011101100101"), A_WE_StdLogicVector((std_logic'((W_op_bret)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100010011100100110010101110100"), A_WE_StdLogicVector((std_logic'((W_op_ror)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100100110111101110010"), A_WE_StdLogicVector((std_logic'((W_op_flushi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001100110110001110101011100110110100001101001"), A_WE_StdLogicVector((std_logic'((W_op_jmp)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010100110110101110000"), A_WE_StdLogicVector((std_logic'((W_op_and)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110111001100100"), A_WE_StdLogicVector((std_logic'((W_op_cmplt)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110110001110100"), A_WE_StdLogicVector((std_logic'((W_op_slli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011011000110110001101001"), A_WE_StdLogicVector((std_logic'((W_op_sll)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110110110001101100"), A_WE_StdLogicVector((std_logic'((W_op_or)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110111101110010"), A_WE_StdLogicVector((std_logic'((W_op_mulxsu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110101"), A_WE_StdLogicVector((std_logic'((W_op_cmpne)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110111001100101"), A_WE_StdLogicVector((std_logic'((W_op_srli)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110110001101001"), A_WE_StdLogicVector((std_logic'((W_op_srl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001101100"), A_WE_StdLogicVector((std_logic'((W_op_nextpc)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011100110010101111000011101000111000001100011"), A_WE_StdLogicVector((std_logic'((W_op_callr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101100001011011000110110001110010"), A_WE_StdLogicVector((std_logic'((W_op_xor)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011110000110111101110010"), A_WE_StdLogicVector((std_logic'((W_op_mulxss)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100011110000111001101110011"), A_WE_StdLogicVector((std_logic'((W_op_cmpeq)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001101101101011100000110010101110001"), A_WE_StdLogicVector((std_logic'((W_op_divu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001100100011010010111011001110101"), A_WE_StdLogicVector((std_logic'((W_op_div)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011001000110100101110110"), A_WE_StdLogicVector((std_logic'((W_op_rdctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111001001100100011000110111010001101100"), A_WE_StdLogicVector((std_logic'((W_op_mul)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011011010111010101101100"), A_WE_StdLogicVector((std_logic'((W_op_cmpgeu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011001110110010101110101"), A_WE_StdLogicVector((std_logic'((W_op_initi)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110100101101110011010010111010001101001"), A_WE_StdLogicVector((std_logic'((W_op_trap)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110100011100100110000101110000"), A_WE_StdLogicVector((std_logic'((W_op_wrctl)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000111011101110010011000110111010001101100"), A_WE_StdLogicVector((std_logic'((W_op_cmpltu)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000110110110101110000011011000111010001110101"), A_WE_StdLogicVector((std_logic'((W_op_add)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011000010110010001100100"), A_WE_StdLogicVector((std_logic'((W_op_break)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((W_op_hbreak)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011010000110001001110010011001010110000101101011"), A_WE_StdLogicVector((std_logic'((W_op_sync)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011110010110111001100011"), A_WE_StdLogicVector((std_logic'((W_op_sub)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111010101100010"), A_WE_StdLogicVector((std_logic'((W_op_srai)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001110011011100100110000101101001"), A_WE_StdLogicVector((std_logic'((W_op_sra)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000011100110111001001100001"), A_WE_StdLogicVector((std_logic'((W_op_intr)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000001101001011011100111010001110010"), A_WE_StdLogicVector((std_logic'((W_op_bswap_s1)) = '1'), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000110001001110011011101110110000101110000010111110111001100110001"), A_WE_StdLogicVector((std_logic'((W_op_interrupt_vector_interrupt_vector)) = '1'), std_logic_vector'("011010010110111001110100011001010111001001110010011101010111000001110100010111110111011001100101011000110111010001101111011100100101111101101001011011100111010001100101011100100111001001110101011100000111010001011111011101100110010101100011011101000110111101110010"), std_logic_vector'("001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000010000100100000101000100")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
    F_vinst <= A_WE_StdLogicVector((std_logic'(F_inst_ram_hit) = '1'), F_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    D_vinst <= A_WE_StdLogicVector((std_logic'(D_issue) = '1'), D_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    E_vinst <= A_WE_StdLogicVector((std_logic'(E_valid) = '1'), E_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    M_vinst <= A_WE_StdLogicVector((std_logic'(M_valid) = '1'), M_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    A_vinst <= A_WE_StdLogicVector((std_logic'(A_valid) = '1'), A_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    W_vinst <= A_WE_StdLogicVector((std_logic'(W_valid) = '1'), W_inst, A_REP_VECTOR(std_logic_vector'("00101101"), 33));
    --Clearing 'X' data bits
    D_ic_want_fill_unfiltered_is_x <= A_WE_StdLogic(is_x(std_ulogic(D_ic_want_fill_unfiltered)), '1','0');
    D_ic_want_fill <= A_WE_StdLogic((std_logic'(D_ic_want_fill_unfiltered_is_x) = '1'), std_logic'('0'), D_ic_want_fill_unfiltered);
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    
--    D_ic_want_fill <= D_ic_want_fill_unfiltered;
--synthesis read_comments_as_HDL off

end europa;

