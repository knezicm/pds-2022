-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: binary_to_bcd
--
-- description:
--
--   Create Binary-to-BCD conversion circuit
--
-----------------------------------------------------------------------------
-- Copyright (c) 2022 Faculty of Electrical Engineering
-----------------------------------------------------------------------------
-- The MIT License
-----------------------------------------------------------------------------
-- Copyright 2022 Faculty of Electrical Engineering
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom
-- the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE
-----------------------------------------------------------------------------
--! @file
--! @brief Binary to BCD converter
-----------------------------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity convert binary nubmer to BCD code
--! @details The entity describes all the necessary input and
--! output signals needed to realize this circuit.
entity binary_to_bcd is
  port(
    clk_i    : in  std_logic;  --! Clock input signals.
    rst_i    : in  std_logic;  --! It resets the system when set to logic '1'.
    start_i  : in  std_logic;  --! It starts the system when set to logic '1'.
    binary_i : in  std_logic_vector(12 downto 0);  --! Binary input number.
    ready_o  : out std_logic; --! Output have logic state '1' when come in idle state.
    bcd1_o   : out std_logic_vector(3 downto 0); --! First BCD coded digit of the input number.
    bcd2_o   : out std_logic_vector(3 downto 0); --! Second BCD coded digit of the input number.
    bcd3_o   : out std_logic_vector(3 downto 0); --! Third BCD coded digit of the input number.
    bcd4_o   : out std_logic_vector(3 downto 0)  --! Fourth BCD coded digit of the input number.
 );
end binary_to_bcd;

--! @brief Architecture definition converting of the binary to BCD number.
--! @details There are the following steps to convert the binary number to BCD:
--! We will convert the binary number into BCD code.
architecture arch of binary_to_bcd is
  type   t_state is (idle, binary0, load, op);
  signal state_reg   : t_state;
  signal state_next  : t_state;
  signal binary_is_0 : std_logic;
  signal count_is_0  : std_logic;
  signal binary_reg  : unsigned(12 downto 0);
  signal binary_next : unsigned(12 downto 0);
  signal bcd1_reg    : unsigned(3 downto 0);
  signal bcd1_next   : unsigned(3 downto 0);
  signal bcd2_reg    : unsigned(3 downto 0);
  signal bcd2_next   : unsigned(3 downto 0);
  signal bcd3_reg    : unsigned(3 downto 0);
  signal bcd3_next   : unsigned(3 downto 0);
  signal bcd4_reg    : unsigned(3 downto 0);
  signal bcd4_next   : unsigned(3 downto 0);

begin
 --! control path: state register
  process(clk_i,rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;
 --! Control path: next-state/output logic
  process(state_reg, start_i, binary_is_0, count_is_0)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          if binary_is_0 = '1' then
            state_next <= binary0;
          else
            state_next <= load;
          end if;
        else
          state_next <= idle;
        end if;
      when binary0 =>
        state_next <= idle;
      when load =>
        state_next <= op;
      when op =>
        state_next <= idle;
    end case;
  end process;
--! Control path : output logic
  ready_o <= '1' when state_reg = idle else '0';
--! Data path : Data register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      binary_reg <= (others => '0');
      bcd1_reg <= (others => '0');
      bcd2_reg <= (others => '0');
      bcd3_reg <= (others => '0');
      bcd4_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      binary_reg <= binary_next;
      bcd1_reg <= bcd1_next;
      bcd2_reg <= bcd2_next;
      bcd3_reg <= bcd3_next;
      bcd4_reg <= bcd4_next;
    end if;
  end process;
--! Data path : routing multiplexer
  process(state_reg, binary_reg, bcd1_reg, bcd2_reg, bcd3_reg, bcd4_reg, binary_i)
    variable binary_temp : std_logic_vector(12 downto 0);
  begin
    case state_reg is
      when idle =>
        binary_next <= binary_reg;
        bcd1_next <= bcd1_reg;
        bcd2_next <= bcd2_reg;
        bcd3_next <= bcd3_reg;
        bcd4_next <= bcd4_reg;
      when binary0 =>
        binary_next <= unsigned(binary_i);
        bcd1_next <= (others => '0');
        bcd2_next <= (others => '0');
        bcd3_next <= (others => '0');
        bcd4_next <= (others => '0');
      when load =>
        binary_next <= unsigned(binary_i);
        bcd1_next <= (others => '0');
        bcd2_next <= (others => '0');
        bcd3_next <= (others => '0');
        bcd4_next <= (others => '0');
      when op =>
        binary_next <= binary_reg;
        binary_temp := std_logic_vector(binary_reg / 1000);
        bcd1_next <= unsigned(binary_temp(3 downto 0));
        binary_temp := std_logic_vector((binary_reg mod 1000) / 100);
        bcd2_next <= unsigned(binary_temp(3 downto 0));
        binary_temp := std_logic_vector((binary_reg mod 100) / 10);
        bcd3_next <= unsigned(binary_temp(3 downto 0));
        binary_temp := std_logic_vector(binary_reg mod 10);
        bcd4_next <= unsigned(binary_temp(3 downto 0));
    end case;
  end process;
--! Data path : Status
  binary_is_0 <= '1' when binary_i = "0000000000000" else '0';
--! Data path : Output
  bcd1_o <= std_logic_vector(bcd1_reg);
  bcd2_o <= std_logic_vector(bcd2_reg);
  bcd3_o <= std_logic_vector(bcd3_reg);
  bcd4_o <= std_logic_vector(bcd4_reg);
end arch;
