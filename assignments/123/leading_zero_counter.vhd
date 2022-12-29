-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     leading_zero_counter
--
-- description:
--
--   This file implements a leading zero counter circuit.
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
-----------------------------------------------------------------------------
--! @file
--! @brief Leading zero counter
-----------------------------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for leading zero counter circuit
--! @details This entity contains clock and reset inputs,
--! input for starting the process of counting leading zeros,
--! input data which leading zeros are counted,
--! output ready that indicates unactive state of circuit and
--! output for nubmer of leading zeros
entity leading_zero_counter is
  port(
    clk_i    : in  std_logic; --! Input clock signal
    rst_i    : in  std_logic; --! It resets the system when set to logic '1'.
    start_i  : in  std_logic; --! When set to logic '1', circuit goes into load state, ready_o then equals '0'
    n_i      : in  std_logic_vector(15 downto 0); --! Binary input which leading zeros are counted
    ready_o  : out std_logic; --! It indicates idle state when its equal to logic '1'
    zeros_o  : out std_logic_vector(4 downto 0) --! Number of leading zeros
  );
end leading_zero_counter;

--! @brief Architecture definition of leading zero counter
--! @details This design is realised on RTL using FSMD approach
architecture arch of leading_zero_counter is

  type t_state is (idle, load, op); --! States of FSM

  signal state_reg, state_next   : t_state; --! Current and next state of state register
  signal n_reg, n_next           : std_logic_vector(15 downto 0); --! Temp signals for loading the input data
  signal zeros_reg, zeros_next   : unsigned(4 downto 0); --! Temp signals for counting leading zeros
  signal zeros_count             : unsigned(4 downto 0); --! Temp signal for counting leading zeros
  signal index                   : natural range 15 downto 0; --! Temp signal for indexing input data
  signal bit_one                 : std_logic; --! Temp signal that indicates bit '1' in input data

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

  -- control path: next-state / output-logic
  process(state_reg, start_i, bit_one)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= load;
        else
          state_next <= idle;
        end if;
      when load =>
        state_next <= op;
      when op =>
        if bit_one = '1' then
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
      n_reg <= (others => '1');
      zeros_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      n_reg <= n_next;
      zeros_reg <= zeros_next;
    end if;
  end process;


  -- data path: routing multiplexer
  process(state_reg, n_reg, zeros_reg, n_i, zeros_count)
  begin
    case state_reg is
      when idle =>
        n_next <= n_reg;
        zeros_next <= zeros_reg;
      when load =>
        n_next <= n_i;
        zeros_next <= (others => '0');
      when op =>
        n_next <= n_reg;
        zeros_next <= zeros_count;
    end case;
  end process;

  -- data path: functional units
  zeros_count <= zeros_reg + 1 when n_reg(index) = '0' and zeros_reg < 16
                 else zeros_reg;

  -- data path: status
  bit_one <= '1' when n_reg(index) = '1' or zeros_reg = 16 else '0';
  index <= 15 - to_integer(zeros_reg) when zeros_reg < 16 else 0;

  -- data path: output
  zeros_o <= std_logic_vector(zeros_reg);
end arch;
