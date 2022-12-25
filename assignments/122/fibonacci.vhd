-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: fibonacci
--
-- description:
--
--   This file implements fibonacci sequence generator
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
--! @brief Preamble generator
-----------------------------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for fibonacci
--! @details This entity contains clock and reset inputs,
--! input for setting size of fibonacci array, input for start generator and
--! output ready for generating sequnce and output on witch sequence is generated.
entity fibonacci is
  port (
    clk_i   : in  std_logic; --! Input clock signal
    rst_i   : in  std_logic; --! It resets the system when set to logic '1'.
    start_i : in  std_logic; --! It triggers sequence generation when is set to logic '1' for one clock period
    n_i     : in  std_logic_vector(5 downto 0); --! Input for defining size of fibonacci array
    r_o     : out std_logic_vector(42 downto 0); --! Output signal on which generated preamble sequence appears.
    ready_o : out std_logic  --! When it is set to logic '1', system is ready for generating fibonacci array.
  );
end fibonacci;

--! @brief Architecture definition of the fibonacci
--! @details This design is realized like a Moore machine with a finite number of states by using look-ahead output method.
--! When start_i is set to logic '1', a sequence of bits "10101010" appears on the output (data_o).
architecture arch of fibonacci is
  type t_state is (idle, n0, load, op); --! States of FSM
  signal state_reg : t_state; --! Current state of register
  signal state_next : t_state; --! Next state of register
  signal n_0 : std_logic; --! It is '1' when n_i is set to "0"
  signal count_0 : std_logic; --! It is '1' when is generating fibonacci sequance is over
  signal a_reg, a_next : unsigned(42 downto 0); --! Temp signal for calculating next member of fibonacci array
  signal b_reg, b_next : unsigned(42 downto 0); --! Temp signal for calculating next member of fibonacci array
  signal r_reg, r_next : unsigned(42 downto 0); --! Temp output signal
  signal n_reg, n_next : unsigned(5 downto 0); --! Temp signal for size of fibonacci array
  signal adder_out : unsigned(42 downto 0); --! Temp signal for adding signals
  signal sub_out : unsigned(5 downto 0); --! Temp signal for subbing signal
begin
  -- control path: state register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;
  -- control path: next-state / output logic
  process(state_reg, start_i, n_0, count_0)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          if n_0 = '1' then
            state_next <= n0;
          else
            state_next <= load;
          end if;
        else
          state_next <= idle;
        end if;
      when n0 =>
        state_next <= idle;
      when load =>
        state_next <= op;
      when op =>
        if count_0 = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
    end case;
  end process;
  -- control path: output logic
  ready_o <= '1' when state_reg = idle else '0';
  -- data path: data register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      a_reg <= (others => '0');
      b_reg <= (others => '0');
      r_reg <= (others => '0');
      n_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      a_reg <= a_next;
      b_reg <= b_next;
      r_reg <= r_next;
      n_reg <= n_next;
    end if;
  end process;
  -- data path: routing multipexer
  process(state_reg, a_reg, b_reg, r_reg, n_reg, n_i, adder_out, sub_out)
  begin
    case state_reg is
      when idle =>
        a_next <= a_reg;
        b_next <= b_reg;
        n_next <= n_reg;
        r_next <= r_reg;
      when n0 =>
        a_next <= (others => '0');
        b_next <= (0 => '1', others => '0');
        r_next <= (others => '0');
        n_next <= (others => '0');
      when load =>
        a_next <= (others => '0');
        b_next <= (0 => '1', others => '0');
        r_next <= (others => '0');
        n_next <= unsigned(n_i);
      when op =>
        r_next <= a_reg;
        a_next <= b_reg;
        b_next <= adder_out;
        n_next <= sub_out;
    end case;
  end process;
  -- data path: functional units
  adder_out <= a_reg + b_reg;
  sub_out <= n_reg - 1;
  -- data path: status
  n_0 <= '1' when n_i = "000000" else '0';
  count_0 <= '1' when n_next = "000000" else '0';
  -- data path: output
  r_o <= std_logic_vector(r_reg);
end arch;
