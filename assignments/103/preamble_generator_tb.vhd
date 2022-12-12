-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: preamble_generator
--
-- description:
--
--   This file implements preamble generator
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
--! @brief Preamble generator.
-----------------------------------------------------------------------------

--! Use standard library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements.
use ieee.numeric_std.all;

--! @brief Entity for preamble generator.
--! @details This entity contains clock and reset inputs,
--! input for triggering preamble generation and output port on which preamble is generated.
entity preamble_generator is
  port (
    clk_i   : in  std_logic; --! Input clock signal.
    rst_i   : in  std_logic; --! It resets the system when set to logic '1'.
    start_i : in  std_logic; --! It triggers preamble generation when is set to logic '1' for one clock period.
    data_o  : out std_logic  --! Output signal on which generated preamble sequence appears.
  );
end preamble_generator;

--! @brief Architecture definition of the preamble generator.
--! @details This design is realized like a Moore machine with a finite number of states by using look-ahead output method.
--! When start_i is set to logic '1', a sequence of bits "10101010" appears on the output (data_o).
architecture arch of preamble_generator is
  type t_mc_sm is (idle, write1, write2, write3, write4, write5, write6, write7, write8); --! States of FSM.
  signal state_reg  : t_mc_sm; --! Current state of register.
  signal state_next : t_mc_sm; --! Next state of register.
  signal out_next   : std_logic; --! Temp signal for data_o_reg.
  signal data_o_reg : std_logic; --! Temp signal for data_o.
begin
  --! State register.
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

  --! Next-state logic.
  process(state_reg, start_i)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= write1;
        else
          state_next <= idle;
        end if;
      when write1 =>
        state_next <= write2;
      when write2 =>
        state_next <= write3;
      when write3 =>
        state_next <= write4;
      when write4 =>
        state_next <= write5;
      when write5 =>
        state_next <= write6;
      when write6 =>
        state_next <= write7;
      when write7 =>
        state_next <= write8;
      when write8 =>
        state_next <= idle;
    end case;
  end process;

  --! Look-ahead output logic
  process(state_next)
  begin
    out_next <= '0';
    case state_next is
      when idle =>
      when write1 =>
        out_next <= '1';
      when write2 =>
        out_next <= '0';
      when write3 =>
        out_next <= '1';
      when write4 =>
        out_next <= '0';
      when write5 =>
        out_next <= '1';
      when write6 =>
        out_next <= '0';
      when write7 =>
        out_next <= '1';
      when write8 =>
        out_next <= '0';
    end case;
  end process;
  
  --! Output buffer.
--  process(clk_i, rst_i)
--  begin
--    if rst_i = '1' then
--      data_o_reg <= '0';
--    elsif rising_edge(clk_i) then
--      data_o_reg <= out_next;
--    end if;
--  end process;

  --! Output.
  data_o <= not out_next;
end arch;
