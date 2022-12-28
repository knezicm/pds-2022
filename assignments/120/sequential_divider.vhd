-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     SEQUENTIAL DIVIDER WITH REPEATED SUBTRACTION
--
-- description:
--
--   This file implements logic of sequential divider with repeated division.
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

-------------------------------------------------------
--! @file sequential_divider.vhd
--! @brief  This file implements logic of sequential divider with repeated subtraction, using Register-Transfer methodology.
--! @author Emanuela Buganik
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Sequential divider entity description
entity sequential_divider is
  port (
    clk_i   :  in std_logic; --! Clock input signal
    rst_i   :  in std_logic; --! Reset input signal
    start_i :  in std_logic; --! Activating process of division
    a_i     :  in std_logic_vector(7 downto 0);  --! Numerator(dividend)
    b_i     :  in std_logic_vector(7 downto 0);  --! Denominator(divisor)
    q_o     : out std_logic_vector(7 downto 0);  --! Quotient, result of division
    r_o     : out std_logic_vector(7 downto 0);  --! Remainder
    ready_o : out std_logic                      --! Signalizing whether process of division is over and new one can begin
);
end sequential_divider;

--! @brief Architecture definition of Sequential divider
--! @details Architecture is implemented using FSM
--! @details The value of b_i is successively subtracted from a_i until the remainder of a_i is less than b_i
architecture arch of sequential_divider is
  type t_state_type is (idle, load, op);
  signal state_reg, state_next : t_state_type;
  signal b_is_0, count_0 : std_logic;          --! Set signals if  b  & count are zeros
  signal b_reg, b_next : unsigned(7 downto 0);
  signal n_reg, n_next : unsigned(7 downto 0); --! Decrement numerator
  signal q_reg, q_next : unsigned(7 downto 0);
  signal rem_reg, rem_next : std_logic_vector(7 downto 0);
  signal tmp_rem : std_logic_vector(15 downto 0);
  signal remainder     : std_logic_vector(7 downto 0);
  signal adder_out     : unsigned(7 downto 0);
  signal sub_out       : unsigned(7 downto 0);

--! Control path : state register
begin
-- Clock process
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

--! Control path: next-state / output logic
-- Defining states
  process(state_reg, start_i, a_i, b_next, count_0)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= load;
-- if a_is_0 = '1' then
-- state_next <= a0;
-- elsif b_is_0 = '1' then
-- state_next <= b0;
-- elsif a_lt_b = '1' then
-- state_next <= a_lessthan_b;
        else
          state_next <= idle;
        end if;
-- when a0 =>
-- state_next <= idle;
-- when b0 =>
-- state_next <= idle;
-- when a_lessthan_b =>
-- state_next <= idle;
      when load =>
        state_next <= op;
      when op =>
        if b_next = "00000000" or a_i = "00000000" or count_0 = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
    end case;
  end process;
--! Control path : output logic
  ready_o <= '1' when state_reg = idle else '0';
--! Data path : data register
-- Defining states values depending on clock and reset signals
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      b_reg   <= (others => '0');
      n_reg   <= (others => '0');
      q_reg   <= (others => '0');
      rem_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      b_reg   <= b_next;
      n_reg   <= n_next;
      q_reg   <= q_next;
      rem_reg <= rem_next;
    end if;
  end process;
--! Data path : routing multiplexer (routing network)
-- Routing
  process(state_reg, b_reg, n_reg, q_reg, rem_reg, remainder, a_i, b_i, adder_out, sub_out)
  begin
    case state_reg is
      when idle =>
        b_next <= b_reg;
        n_next <= n_reg;
        q_next <= q_reg;
        rem_next  <= rem_reg;
-- when a0 => --! Zero divided by b
-- b_next <= unsigned(b_i);
-- n_next <= unsigned(a_i);
-- q_next <= (others => '0');
-- when b0 => --! Dividing by zero!
-- b_next <= unsigned(b_i);
-- n_next <= unsigned(a_i);
-- q_next <= "11111111";
      when load =>
        b_next  <= unsigned(b_i);
        n_next  <= unsigned(a_i);
        q_next  <= (others => '0');
        rem_next <= (others => '0');
      when op =>
        if b_reg = "00000000" then
          b_next   <= b_reg;
          n_next   <= unsigned(a_i);
          q_next   <= "11111111";
          rem_next <= "11111111";
        elsif a_i = "00000000" then
          b_next   <= (others => '0');
          n_next   <= (others => '0');
          q_next   <= (others => '0');
          rem_next <= (others => '0');
        else
          b_next  <= b_reg;
          n_next  <= sub_out;
          q_next  <= adder_out;
          rem_next  <= remainder;
        end if;
-- when a_lessthan_b =>
-- b_next <= unsigned(b_i);
-- n_next <= unsigned(a_i);
-- q_next <= (others => '0');
    end case;
  end process;
--! Data path : functional units

  sub_out <= n_reg - b_reg;
  adder_out <= q_reg + 1; --! Number of subtractions
  tmp_rem <= std_logic_vector(q_reg*b_reg);
  remainder <= std_logic_vector(unsigned(a_i) - unsigned(tmp_rem(7 downto 0)));
  --! Data path : status
-- a_is_0  <= '1' when a_i = "00000000" else '0';
-- b_is_0  <= '1' when b_i = "00000000" else '0';
-- a_lt_b  <= '1' when unsigned(a_i) < unsigned(b_i) else '0';
  count_0 <= '1' when n_reg < b_reg else '0';
--! Data path : output
  q_o  <= std_logic_vector(q_reg);
--! dividend = quotient*divisor + remainder
--  remainder  <= std_logic_vector(q_reg * b_reg);
--  r_o        <= std_logic_vector(unsigned(a_i) - unsigned(remainder(7 downto 0)));
  r_o <= std_logic_vector(rem_reg);
end arch;
