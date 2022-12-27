-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     sequential_divider
--
-- description:
--
--   This file implements sequential_divider.
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
--!
--! \file sequential_divider.vhd
--! \brief VHDL implementation of sequential_divider.
--! \author Nikola Cetic
--! \date 2022
--! This file implements a sequential divider entity.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

--! \brief Sequential divider entity
--!
--! \details This entity implements a sequential divider that performs integer division
--! on two 8-bit inputs and produces an 8-bit quotient and an 8-bit remainder.
--! The divider has a start input and a ready output to control the division process.
--!
--! \param clk_i   Clock input
--! \param rst_i   Reset input
--! \param start_i Start input
--! \param a_i     Dividend input (8-bit)
--! \param b_i     Divisor input (8-bit)
--! \param q_o     Quotient output (8-bit)
--! \param r_o     Remainder output (8-bit)
--! \param ready_o Ready output
entity sequential_divider is
  port (
    clk_i   : in  std_logic;
    rst_i   : in  std_logic;
    start_i : in  std_logic;
    a_i     : in  std_logic_vector(7 downto 0);
    b_i     : in  std_logic_vector(7 downto 0);
    q_o     : out std_logic_vector(7 downto 0);
    r_o     : out std_logic_vector(7 downto 0);
    ready_o : out std_logic
  );
end sequential_divider;

--! \brief Sequential divider architecture
--!
--! \details This architecture implements the state machine and combinational logic
--! for the sequential divider. It uses a series of registers to store intermediate
--! values and a state machine to control the flow of the division process.
architecture arch of sequential_divider is
  --! \brief State type
  --!
  --! This type defines the possible states of the sequential divider.
  type t_state is (idle, load, cmp, write_res, mul, sub, take_next);
  signal state_reg, state_next : t_state;
  signal gt_reg, gt_next       : std_logic;
  signal rem_reg, rem_next     : unsigned(7 downto 0);
  signal sub_reg, sub_next     : unsigned(7 downto 0);
  signal a_reg, a_next         : unsigned(7 downto 0);
  signal b_reg, b_next         : unsigned(7 downto 0);
  signal n_reg, n_next         : unsigned(2 downto 0);
  signal r_reg, r_next         : unsigned(7 downto 0);
  signal q_reg, q_next         : unsigned(7 downto 0);
  signal count_reg, count_next : unsigned(3 downto 0);
begin
  --! \brief Control path: state register
  --!
  --! \details This process updates the state register based on the clock and reset inputs.
  --! If the reset input is high, the state is set to the idle state.
  --! If the clock input is rising, the state is updated to the next state.
  process (clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;
  --! \brief Control path: combinational logic
  --!
  --! \details This process updates the next state based on the current state and other inputs.
  --! The next state is determined by a state machine that implements the division process.
  process (state_reg, start_i, count_next, b_next)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= load;
        else
          state_next <= idle;
        end if;
      when load =>
        state_next <= cmp;
      when cmp =>
        if b_next = "00000000" then
          state_next <= idle;
          --count_next <= "0000";
        elsif count_next = "0000" then
          state_next <= idle;
        else
          state_next <= write_res;
        end if;
      when write_res =>
        state_next <= mul;
      when mul =>
        state_next <= sub;
      when sub =>
        if count_next = "0000" then
          state_next <= idle;
        else
          state_next <= take_next;
        end if;
      when take_next =>
        state_next <= cmp;
    end case;
  end process;
  -- control path: output logic
  ready_o <= '1' when state_reg = idle else
             '0';
  --! \brief Data path: data register
  --!
  --! \details This process updates the data registers based on the clock and reset inputs.
  --! If the reset input is high, the registers are all set to zero.
  --! If the clock input is rising, the registers are updated to the next values.
  process (clk_i, rst_i)
  begin
    if rst_i = '1' then
      a_reg     <= (others => '0');
      b_reg     <= (others => '0');
      n_reg     <= "111";
      r_reg     <= (others => '0');
      q_reg     <= (others => '0');
      rem_reg   <= (others => '0');
      gt_reg    <= '0';
      sub_reg   <= (others => '0');
      count_reg <= "0000";
    elsif rising_edge(clk_i) then
      a_reg     <= a_next;
      b_reg     <= b_next;
      n_reg     <= n_next;
      r_reg     <= r_next;
      q_reg     <= q_next;
      rem_reg   <= rem_next;
      gt_reg    <= gt_next;
      sub_reg   <= sub_next;
      count_reg <= count_next;
    end if;
  end process;

  --! \brief Data path: combinational logic
  --!
  --! \details This process updates the next values for the data registers based on the current state
  --! and the values of the inputs and other registers. The next values are determined
  --! by the combinational logic needed to implement the division process.
  process (state_reg, a_reg, b_reg, rem_reg, n_reg, q_reg, gt_reg, sub_reg, r_reg, count_reg, a_i, b_i)
    variable q_next_v   : unsigned(7 downto 0);
    variable rem_next_v : unsigned(7 downto 0);
  begin
    rem_next   <= rem_reg;
    q_next     <= q_reg;
    gt_next    <= gt_reg;
    n_next     <= n_reg;
    sub_next   <= sub_reg;
    a_next     <= a_reg;
    b_next     <= b_reg;
    r_next     <= r_reg;
    count_next <= count_reg;
    case state_reg is
      when idle =>
      when load =>
        a_next <= unsigned(a_i);
        b_next <= unsigned(b_i);
        r_next <= (others        => '0');
        rem_next_v    := (others => '0');
        rem_next_v(0) := a_i(7);
        rem_next   <= rem_next_v;
        n_next     <= "111";
        count_next <= "1000";
      when cmp =>
        if b_next = "00000000" then
          count_next <= "0000";
          rem_next   <= "11111111";
          q_next     <= "11111111";
        elsif rem_reg >= b_reg then
          gt_next <= '1';
        else
          gt_next <= '0';
        end if;
      when write_res =>
        q_next_v    := shift_left(q_reg, 1);
        q_next_v(0) := gt_reg;
        q_next <= q_next_v;
      when mul =>
        if gt_reg = '1' then
          sub_next <= b_reg;
        else
          sub_next <= (others => '0');
        end if;
      when sub =>
        rem_next   <= rem_reg - sub_reg;
        n_next     <= n_reg - 1;
        count_next <= count_reg - 1;
      when take_next =>
        rem_next_v    := shift_left(rem_reg, 1);
        rem_next_v(0) := a_reg(to_integer(n_reg));
        rem_next <= rem_next_v;
    end case;
  end process;
  -- data path: output
  q_o <= std_logic_vector(q_reg);
  r_o <= std_logic_vector(rem_reg);
end arch;

configuration conf of sequential_divider is
  for arch
  end for;
end conf;
