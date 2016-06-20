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

entity ddr_sdram_0_example_driver is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal local_rdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal local_rdata_valid : IN STD_LOGIC;
                 signal local_ready : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal burst_begin : OUT STD_LOGIC;
                 signal local_bank_addr : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal local_be : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal local_col_addr : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal local_cs_addr : OUT STD_LOGIC;
                 signal local_read_req : OUT STD_LOGIC;
                 signal local_row_addr : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal local_size : OUT STD_LOGIC;
                 signal local_wdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal local_write_req : OUT STD_LOGIC;
                 signal pnf_per_byte : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal pnf_persist : OUT STD_LOGIC;
                 signal test_complete : OUT STD_LOGIC
              );
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of ddr_sdram_0_example_driver : entity is "MESSAGE_DISABLE=12300;MESSAGE_DISABLE=14130;MESSAGE_DISABLE=14110";
end entity ddr_sdram_0_example_driver;


architecture europa of ddr_sdram_0_example_driver is
  component example_lfsr8 is
GENERIC (
      seed : NATURAL
      );
    PORT (
    signal data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal pause : IN STD_LOGIC;
        signal enable : IN STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal ldata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        signal load : IN STD_LOGIC
      );
  end component example_lfsr8;
                signal LOCAL_BURST_LEN_s :  STD_LOGIC;
                signal MAX_BANK :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal MAX_CHIPSEL :  STD_LOGIC;
                signal MAX_COL :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal MAX_ROW :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal MIN_CHIPSEL :  STD_LOGIC;
                signal avalon_burst_mode :  STD_LOGIC;
                signal avalon_read_burst_max_address :  STD_LOGIC;
                signal bank_addr :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal be :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal burst_beat_count :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal col_addr :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal compare :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal compare_reg :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal compare_valid :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal compare_valid_reg :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cs_addr :  STD_LOGIC;
                signal dgen_data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dgen_enable :  STD_LOGIC;
                signal dgen_ldata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dgen_load :  STD_LOGIC;
                signal dgen_pause :  STD_LOGIC;
                signal last_rdata_valid :  STD_LOGIC;
                signal last_wdata_req :  STD_LOGIC;
                signal pnf_persist1 :  STD_LOGIC;
                signal reached_max_address :  STD_LOGIC;
                signal reached_max_count :  STD_LOGIC;
                signal read_req :  STD_LOGIC;
                signal reads_remaining :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal reset_address :  STD_LOGIC;
                signal row_addr :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal size :  STD_LOGIC;
                signal state :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal wait_first_write_data :  STD_LOGIC;
                signal wdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal wdata_req :  STD_LOGIC;
                signal write_req :  STD_LOGIC;
                signal writes_remaining :  STD_LOGIC_VECTOR (7 DOWNTO 0);

begin

  avalon_burst_mode <= std_logic'('0');
  MIN_CHIPSEL <= std_logic'('0');
  MAX_CHIPSEL <= std_logic'('0');
  MAX_ROW <= std_logic_vector'("0000000000011");
  MAX_BANK <= std_logic_vector'("11");
  MAX_COL <= std_logic_vector'("000010000");
  --


  local_cs_addr <= cs_addr;
  local_row_addr <= row_addr;
  local_bank_addr <= bank_addr;
  local_col_addr <= col_addr;
  local_write_req <= write_req;
  local_read_req <= read_req;
  local_wdata <= wdata;
  wdata <= dgen_data;
  --The LOCAL_BURST_LEN_s is a signal used insted of the parameter LOCAL_BURST_LEN
  LOCAL_BURST_LEN_s <= std_logic'('1');
  --LOCAL INTERFACE (AVALON)
  wdata_req <= write_req AND local_ready;
  -- Generate new data (enable lfsr) when writing or reading valid data
  dgen_pause <= NOT ((wdata_req OR local_rdata_valid));
  --


  local_be <= be;
  be <= A_REP(std_logic'('1'), 4);
  pnf_per_byte <= compare_valid_reg;
  local_size <= size;
  --FIX
  size <= LOCAL_BURST_LEN_s;
  reached_max_address <= to_std_logic(((((((std_logic_vector'("00000000000000000000000000000000000000000000000000000000") & (col_addr))>=(((std_logic_vector'("00000000000000000000000000000000000000000000000000000000") & (MAX_COL)) - (std_logic_vector'("0") & (((std_logic_vector'("00000000000000000000000000000001") * std_logic_vector'("00000000000000000000000000000010"))))))))) AND ((row_addr = MAX_ROW))) AND ((bank_addr = MAX_BANK))) AND ((std_logic'(cs_addr) = std_logic'(MAX_CHIPSEL)))));
  avalon_read_burst_max_address <= to_std_logic(((((((std_logic_vector'("00000000000000000000000000000000000000000000000000000000") & (col_addr))>=(((std_logic_vector'("00000000000000000000000000000000000000000000000000000000") & (MAX_COL)) - (std_logic_vector'("0") & (((std_logic_vector'("00000000000000000000000000000001") * std_logic_vector'("00000000000000000000000000000100"))))))))) AND ((row_addr = MAX_ROW))) AND ((bank_addr = MAX_BANK))) AND ((std_logic'(cs_addr) = std_logic'(MAX_CHIPSEL)))));
  LFSRGEN_0_lfsr_inst : example_lfsr8
    generic map(
      seed => 1
    )
    port map(
            clk => clk,
            data => dgen_data(7 DOWNTO 0),
            enable => dgen_enable,
            ldata => dgen_ldata(7 DOWNTO 0),
            load => dgen_load,
            pause => dgen_pause,
            reset_n => reset_n
    );

  -- 8 bit comparator per local byte lane
  compare(0) <= to_std_logic((dgen_data(7 DOWNTO 0) = local_rdata(7 DOWNTO 0)));
  LFSRGEN_1_lfsr_inst : example_lfsr8
    generic map(
      seed => 11
    )
    port map(
            clk => clk,
            data => dgen_data(15 DOWNTO 8),
            enable => dgen_enable,
            ldata => dgen_ldata(15 DOWNTO 8),
            load => dgen_load,
            pause => dgen_pause,
            reset_n => reset_n
    );

  -- 8 bit comparator per local byte lane
  compare(1) <= to_std_logic((dgen_data(15 DOWNTO 8) = local_rdata(15 DOWNTO 8)));
  LFSRGEN_2_lfsr_inst : example_lfsr8
    generic map(
      seed => 21
    )
    port map(
            clk => clk,
            data => dgen_data(23 DOWNTO 16),
            enable => dgen_enable,
            ldata => dgen_ldata(23 DOWNTO 16),
            load => dgen_load,
            pause => dgen_pause,
            reset_n => reset_n
    );

  -- 8 bit comparator per local byte lane
  compare(2) <= to_std_logic((dgen_data(23 DOWNTO 16) = local_rdata(23 DOWNTO 16)));
  LFSRGEN_3_lfsr_inst : example_lfsr8
    generic map(
      seed => 31
    )
    port map(
            clk => clk,
            data => dgen_data(31 DOWNTO 24),
            enable => dgen_enable,
            ldata => dgen_ldata(31 DOWNTO 24),
            load => dgen_load,
            pause => dgen_pause,
            reset_n => reset_n
    );

  -- 8 bit comparator per local byte lane
  compare(3) <= to_std_logic((dgen_data(31 DOWNTO 24) = local_rdata(31 DOWNTO 24)));
  --
  -------------------------------------------------------------------
  --Main clocked process
  -------------------------------------------------------------------
  --Read / Write control state machine & address counter
  -------------------------------------------------------------------
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      --Reset - asynchronously force all register outputs LOW
      state <= std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('0')));
      write_req <= std_logic'('0');
      read_req <= std_logic'('0');
      burst_begin <= std_logic'('0');
      burst_beat_count <= std_logic_vector'("000");
      cs_addr <= std_logic'('0');
      row_addr <= std_logic_vector'("0000000000000");
      bank_addr <= std_logic_vector'("00");
      col_addr <= std_logic_vector'("000000000");
      dgen_enable <= std_logic'('0');
      dgen_load <= std_logic'('0');
      wait_first_write_data <= std_logic'('0');
      reached_max_count <= std_logic'('0');
      test_complete <= std_logic'('0');
      writes_remaining <= std_logic_vector'("00000000");
      reads_remaining <= std_logic_vector'("00000000");
      reset_address <= std_logic'('0');
    elsif clk'event and clk = '1' then
      reset_address <= std_logic'('0');
      reached_max_count <= reached_max_address;
      read_req <= std_logic'('0');
      write_req <= std_logic'('0');
      dgen_load <= std_logic'('0');
      test_complete <= std_logic'('0');
      if std_logic'(last_wdata_req) = '1' then 
        wait_first_write_data <= std_logic'('0');
      end if;
      if std_logic'((write_req AND local_ready)) = '1' then 
        if std_logic'(wdata_req) = '1' then 
          writes_remaining <= A_EXT (((std_logic_vector'("00000000000000000000000000") & (writes_remaining)) + (std_logic_vector'("0") & ((((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(size))) - std_logic_vector'("000000000000000000000000000000001")))))), 8);
        else
          writes_remaining <= A_EXT (((std_logic_vector'("0") & (writes_remaining)) + (std_logic_vector'("00000000") & (A_TOSTDLOGICVECTOR(size)))), 8);
        end if;
      elsif std_logic'(((wdata_req) AND to_std_logic((((std_logic_vector'("000000000000000000000000") & (writes_remaining))>std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        --size
        writes_remaining <= A_EXT (((std_logic_vector'("0") & (writes_remaining)) - (std_logic_vector'("00000000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 8);
      else
        writes_remaining <= writes_remaining;
      end if;
      if std_logic'((read_req AND local_ready)) = '1' then 
        if std_logic'(local_rdata_valid) = '1' then 
          reads_remaining <= A_EXT (((std_logic_vector'("00000000000000000000000000") & (reads_remaining)) + (std_logic_vector'("0") & ((((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(size))) - std_logic_vector'("000000000000000000000000000000001")))))), 8);
        else
          reads_remaining <= A_EXT (((std_logic_vector'("0") & (reads_remaining)) + (std_logic_vector'("00000000") & (A_TOSTDLOGICVECTOR(size)))), 8);
        end if;
      elsif std_logic'(((local_rdata_valid) AND to_std_logic((((std_logic_vector'("000000000000000000000000") & (reads_remaining))>std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        reads_remaining <= A_EXT (((std_logic_vector'("0") & (reads_remaining)) - (std_logic_vector'("00000000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 8);
      else
        reads_remaining <= reads_remaining;
      end if;
      case state is
          when std_logic_vector'("0000") => 
              reached_max_count <= std_logic'('0');
              if (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(avalon_burst_mode))) = std_logic_vector'("00000000000000000000000000000000") then 
                if std_logic_vector'("00000000000000000000000000000001") = std_logic_vector'("00000000000000000000000000000000") then 
                  state <= std_logic_vector'("0101");
                else
                  state <= std_logic_vector'("0001");
                end if;
              else
                burst_begin <= std_logic'('1');
                write_req <= std_logic'('1');
                state <= std_logic_vector'("1010");
              end if;
              dgen_enable <= std_logic'('1');
              --Reset just in case!
              writes_remaining <= std_logic_vector'("00000000");
              reads_remaining <= std_logic_vector'("00000000");
          -- when std_logic_vector'("0000") 
      
          when std_logic_vector'("0001") => 
              write_req <= std_logic'('1');
              dgen_enable <= std_logic'('1');
              if std_logic'((local_ready AND write_req)) = '1' then 
                if std_logic'(reached_max_count) = '1' then 
                  state <= std_logic_vector'("0010");
                  write_req <= std_logic'('0');
                  reset_address <= std_logic'('1');
                end if;
              end if;
          -- when std_logic_vector'("0001") 
      
          when std_logic_vector'("1010") => 
              reset_address <= std_logic'('0');
              write_req <= std_logic'('1');
              burst_begin <= std_logic'('0');
              if std_logic'(local_ready) = '1' then 
                burst_beat_count <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (burst_beat_count)) + std_logic_vector'("000000000000000000000000000000001")), 3);
                state <= std_logic_vector'("1100");
              end if;
          -- when std_logic_vector'("1010") 
      
          when std_logic_vector'("1011") => 
              reset_address <= std_logic'('0');
              read_req <= std_logic'('1');
              if std_logic'(NOT(local_ready)) = '1' then 
                burst_begin <= std_logic'('0');
                state <= std_logic_vector'("1101");
              end if;
              if std_logic'(avalon_read_burst_max_address) = '1' then 
                read_req <= std_logic'('0');
                reset_address <= std_logic'('1');
                test_complete <= std_logic'('1');
                burst_beat_count <= std_logic_vector'("000");
                state <= std_logic_vector'("0100");
              end if;
          -- when std_logic_vector'("1011") 
      
          when std_logic_vector'("1100") => 
              write_req <= std_logic'('1');
              if std_logic'(local_ready) = '1' then 
                if (std_logic_vector'("000000000000000000000000000000") & (burst_beat_count)) = ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(size))) - std_logic_vector'("000000000000000000000000000000001")) then 
                  if std_logic'(reached_max_count) = '1' then 
                    write_req <= std_logic'('0');
                    burst_beat_count <= std_logic_vector'("000");
                    reset_address <= std_logic'('1');
                    dgen_enable <= std_logic'('0');
                    state <= std_logic_vector'("0010");
                  else
                    burst_begin <= std_logic'('1');
                    write_req <= std_logic'('1');
                    burst_beat_count <= std_logic_vector'("000");
                    state <= std_logic_vector'("1010");
                  end if;
                else
                  burst_beat_count <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (burst_beat_count)) + std_logic_vector'("000000000000000000000000000000001")), 3);
                end if;
              end if;
          -- when std_logic_vector'("1100") 
      
          when std_logic_vector'("1101") => 
              read_req <= std_logic'('1');
              if std_logic'(local_ready) = '1' then 
                burst_begin <= std_logic'('1');
                read_req <= std_logic'('1');
                state <= std_logic_vector'("1011");
              elsif std_logic'(avalon_read_burst_max_address) = '1' then 
                read_req <= std_logic'('0');
                reset_address <= std_logic'('1');
                test_complete <= std_logic'('1');
                dgen_enable <= std_logic'('0');
                state <= std_logic_vector'("0100");
              end if;
          -- when std_logic_vector'("1101") 
      
          when std_logic_vector'("0010") => 
              if (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(avalon_burst_mode))) = std_logic_vector'("00000000000000000000000000000000") then 
                if (std_logic_vector'("000000000000000000000000") & (writes_remaining)) = std_logic_vector'("00000000000000000000000000000000") then 
                  state <= std_logic_vector'("0011");
                  dgen_enable <= std_logic'('0');
                end if;
              else
                dgen_enable <= std_logic'('1');
                burst_begin <= std_logic'('1');
                read_req <= std_logic'('1');
                reset_address <= std_logic'('0');
                state <= std_logic_vector'("1011");
              end if;
          -- when std_logic_vector'("0010") 
      
          when std_logic_vector'("0011") => 
              read_req <= std_logic'('1');
              dgen_enable <= std_logic'('1');
              if std_logic'((local_ready AND read_req)) = '1' then 
                if std_logic'(reached_max_count) = '1' then 
                  state <= std_logic_vector'("0100");
                  read_req <= std_logic'('0');
                  reset_address <= std_logic'('1');
                end if;
              end if;
          -- when std_logic_vector'("0011") 
      
          when std_logic_vector'("0100") => 
              if (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(avalon_burst_mode))) = std_logic_vector'("00000000000000000000000000000000") then 
                if (std_logic_vector'("000000000000000000000000") & (reads_remaining)) = std_logic_vector'("00000000000000000000000000000000") then 
                  state <= std_logic_vector'("0000");
                  dgen_enable <= std_logic'('0');
                  test_complete <= std_logic'('1');
                end if;
              else
                if (std_logic_vector'("000000000000000000000000") & (reads_remaining)) = std_logic_vector'("00000000000000000000000000000001") then 
                  dgen_enable <= std_logic'('0');
                end if;
                if (std_logic_vector'("000000000000000000000000") & (reads_remaining)) = std_logic_vector'("00000000000000000000000000000000") then 
                  dgen_enable <= std_logic'('1');
                  burst_begin <= std_logic'('1');
                  write_req <= std_logic'('1');
                  read_req <= std_logic'('0');
                  reset_address <= std_logic'('0');
                  burst_beat_count <= std_logic_vector'("000");
                  state <= std_logic_vector'("1010");
                end if;
              end if;
          -- when std_logic_vector'("0100") 
      
          when std_logic_vector'("0101") => 
              write_req <= std_logic'('1');
              dgen_enable <= std_logic'('1');
              wait_first_write_data <= std_logic'('1');
              if std_logic'(local_ready) = '1' then 
                state <= std_logic_vector'("0110");
                write_req <= std_logic'('0');
              end if;
          -- when std_logic_vector'("0101") 
      
          when std_logic_vector'("0110") => 
              if (std_logic_vector'("000000000000000000000000") & (writes_remaining)) = std_logic_vector'("00000000000000000000000000000000") then 
                state <= std_logic_vector'("0111");
                dgen_load <= std_logic'('1');
              end if;
          -- when std_logic_vector'("0110") 
      
          when std_logic_vector'("0111") => 
              read_req <= std_logic'('1');
              dgen_enable <= std_logic'('1');
              if std_logic'(local_ready) = '1' then 
                state <= std_logic_vector'("1000");
                read_req <= std_logic'('0');
              end if;
          -- when std_logic_vector'("0111") 
      
          when std_logic_vector'("1000") => 
              if (std_logic_vector'("000000000000000000000000") & (reads_remaining)) = std_logic_vector'("00000000000000000000000000000000") then 
                if true then 
                  reset_address <= std_logic'('1');
                  dgen_enable <= std_logic'('0');
                  state <= std_logic_vector'("0000");
                  test_complete <= std_logic'('1');
                else
                  state <= std_logic_vector'("0101");
                end if;
              end if;
          -- when std_logic_vector'("1000") 
      
          when others => 
          -- when others 
      
      end case; -- state
      if std_logic'(reset_address) = '1' then 
        --(others => '0')
        cs_addr <= MIN_CHIPSEL;
        row_addr <= std_logic_vector'("0000000000000");
        bank_addr <= std_logic_vector'("00");
        col_addr <= std_logic_vector'("000000000");
      elsif std_logic'(((((((local_ready AND write_req)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000000001")))))) OR ((((local_ready AND read_req)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000000011"))))))) OR (((local_ready) AND to_std_logic((((((((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000000111"))) OR (((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000001010")))) OR (((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000001011")))) OR (((std_logic_vector'("0000000000000000000000000000") & (state)) = std_logic_vector'("00000000000000000000000000001101")))))))))) = '1' then 
        if col_addr>=MAX_COL then 
          col_addr <= std_logic_vector'("000000000");
          if row_addr = MAX_ROW then 
            row_addr <= std_logic_vector'("0000000000000");
            if bank_addr = MAX_BANK then 
              bank_addr <= std_logic_vector'("00");
              if std_logic'(cs_addr) = std_logic'(MAX_CHIPSEL) then 
                --reached_max_count <= TRUE
                --(others => '0')
                cs_addr <= MIN_CHIPSEL;
              else
                cs_addr <= Vector_To_Std_Logic(((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cs_addr))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))));
              end if;
            else
              bank_addr <= A_EXT (((std_logic_vector'("0") & (bank_addr)) + (std_logic_vector'("00") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 2);
            end if;
          else
            row_addr <= A_EXT (((std_logic_vector'("0") & (row_addr)) + (std_logic_vector'("0000000000000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 13);
          end if;
        else
          col_addr <= A_EXT (((std_logic_vector'("00000000000000000000000000000000000000000000000000000000") & (col_addr)) + (std_logic_vector'("0") & (((std_logic_vector'("00000000000000000000000000000001") * std_logic_vector'("00000000000000000000000000000010")))))), 9);
        end if;
      end if;
    end if;

  end process;

  --------------------------------------------------------------
  --LFSR re-load data storage
  --Comparator masking and test pass signal generation
  --------------------------------------------------------------
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dgen_ldata <= std_logic_vector'("00000000000000000000000000000000");
      last_wdata_req <= std_logic'('0');
      --all ones
      compare_valid <= A_REP(std_logic'('1'), 4);
      --all ones
      compare_valid_reg <= A_REP(std_logic'('1'), 4);
      pnf_persist <= std_logic'('1');
      pnf_persist1 <= std_logic'('1');
      --all ones
      compare_reg <= A_REP(std_logic'('1'), 4);
      last_rdata_valid <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_wdata_req <= wdata_req;
      last_rdata_valid <= local_rdata_valid;
      compare_reg <= compare;
      if std_logic'(wdata_req) = '1' then 
        --Store the data from the first write in a burst 
        --Used to reload the lfsr for the first read in a burst in WRITE 1, READ 1 mode

        if std_logic'(wait_first_write_data) = '1' then 
          dgen_ldata <= dgen_data;
        end if;
      end if;
      --Enable the comparator result when read data is valid
      if std_logic'(last_rdata_valid) = '1' then 
        compare_valid <= compare_reg;
      end if;
      --Create the overall persistent passnotfail output
      if std_logic'(NOT and_reduce(compare_valid)) = '1' then 
        pnf_persist1 <= std_logic'('0');
      end if;
      --Extra register stage to help Tco / Fmax on comparator output pins
      compare_valid_reg <= compare_valid;
      pnf_persist <= pnf_persist1;
    end if;

  end process;


end europa;

