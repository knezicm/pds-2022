-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: sequential_multiplier
--
-- description:
--
--   This file implements sequential multiplier. The multiplication process
--   will be done by the shift-and-add sequential multiplication procedure.
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
--! @file sequential_multiplier.vhd
--! @brief This file implements sequential add-and-shift multiplier.
--! @author Tamara Lekic


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! @brief Entity description for sequential_multiplier.
--! @details This entity contains clock and reset inputs.
--! Multiplication begins with start_i input. Input data a_i and b_i are operands,
--! and output data c_o is product. Output ready_o indicates that the multiplier is ready for another set of data.


entity sequential_multiplier is
  port (
    clk_i   : in  std_logic; --! Clock input signal.
    rst_i   : in  std_logic; --! Reset input signal.
    start_i : in  std_logic; --! When start_i signal is set to '1', the multiplication process is activated.
    a_i     : in  std_logic_vector(7 downto 0); --! Input data(multiplicand).
    b_i     : in  std_logic_vector(7 downto 0); --! Input data(multiplier).
    c_o     : out std_logic_vector(15 downto 0); --! Output data(result of multiplication).
    ready_o : out std_logic --! when ready_o output is set to '1', a new multiplication process can start.
);
end sequential_multiplier;

--! @brief   Architecture definition for sequential_multiplier.
--! @details Architecture is implemented using FSM with 3 states(idle, load, op).
--! @details If observed right-most bit of a_i is '1', b_i is to be added to the previously calculated
--! partial result, and the calculated new sum must be shifted one place to the right.
--! This is called added_and_shifted. Repeating the above procedure, when all bits of a_i are shifted out,
--! the partial result becomes the final multiplication result.

architecture arch of sequential_multiplier is
  constant c_WIDTH : integer := 8;
  type t_seq_mul is (idle, load, op);
  signal state_reg, state_next : t_seq_mul;
  signal n0, a_0               : std_logic;
  signal sum_reg,sum_next      : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shift_reg, shift_next : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal n_reg, n_next         : std_logic_vector(2 downto 0);
  signal n                     : std_logic_vector(2 downto 0);
  signal added_and_shifted     : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shifted               : std_logic_vector(2*c_WIDTH-1 downto 0);
begin
--! Control path : state register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

--! Control path : next-state / output logic
  process(state_reg, start_i, n0)
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
        if n0 = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
    end case;
  end process;

--! Control path : output logic
  ready_o <= '1' when state_reg = idle else '0';

--! Data path : data register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      shift_reg <= (others => '0');
      sum_reg <= (others => '0');
      n_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      shift_reg <= shift_next;
      sum_reg <= sum_next;
      n_reg <= n_next;
    end if;
  end process;

--! Data path : routing multiplexer
  process(state_reg,n_reg, sum_reg, shift_reg, a_0, n, b_i, added_and_shifted, shifted)
  begin
    case state_reg is
      when idle =>
        shift_next <= shift_reg;
        sum_next <= sum_reg;
        n_next <= n_reg;
      when load =>
        shift_next <= "00000000" & b_i;
        sum_next <= (others => '0');
        n_next <= (others => '0');
      when op =>
        if a_0 = '1' then
          sum_next <= added_and_shifted;
        else
          sum_next <= sum_reg;
        end if;
        shift_next <= shifted;
        n_next <= n;
    end case;
  end process;

--! data path : functional units
  shifted <= shift_reg(14 downto 0) & '0';
  added_and_shifted <= std_logic_vector(unsigned(sum_reg) + unsigned(shift_reg));
  n <= std_logic_vector( unsigned(n_reg) + 1 );

--! Data path : status
  n0 <= '1' when n_reg = "111" else '0';
  a_0 <= '1' when a_i(to_integer(unsigned(n_reg))) = '1' else '0';

--! Data path : output
  c_o <= sum_reg;

end arch;
