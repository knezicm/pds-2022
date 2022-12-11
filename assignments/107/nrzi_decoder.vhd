--! \file nrzi_decoder_tb.vhd
--! \brief This file Implements testbench for nrzi_decoder.
--!
--! This file is part of the PDS-2022 project
--! \author Nikola Cetic
-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     nrzi_decoder
--
-- description:
--
--   This file implements nrzi_decoder.
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
library ieee;
use ieee.std_logic_1164.all;

--! \brief Creates NRZI decoder.
--! Entity is created using Moore FSM with 4 states.
--! States: zero_zero, zero_one, one_zero,one_one
--!

entity nrzi_decoder is
  port (
  clk_i  : in  std_logic; --! clk_i input clock
  rst_i  : in  std_logic; --! rst_i reset active on '1'
  data_i : in  std_logic; --! data_i input data in NRZI format
  data_o : out std_logic  --! data_o output data in NRZ(L)
);
end nrzi_decoder;

architecture arch of nrzi_decoder is

  type t_states is (zero_zero, zero_one, one_zero, one_one);
  signal state_reg  : t_states;
  signal state_next : t_states;

begin
  -- state register
  process(clk_i,rst_i) is
  begin
    if rst_i = '1' then
      state_reg <= zero_zero;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

  -- next_state logic
  process(state_reg,data_i) is
  begin
    case state_reg is
      when zero_zero =>
        if data_i = '0' then
          state_next <= zero_zero;
        elsif data_i = '1' then
          state_next <= zero_one;
        end if;
      when zero_one =>
        if data_i = '0' then
          state_next <= one_zero;
        elsif data_i = '1' then
          state_next <= one_one;
        end if;
      when one_zero =>
        if data_i = '0' then
          state_next <= zero_zero;
        elsif data_i = '1' then
          state_next <= zero_one;
        end if;
      when one_one =>
        if data_i = '0' then
          state_next <= one_zero;
        elsif data_i = '1' then
          state_next <= one_one;
        end if;
    end case;
  end process;

  -- Moore output logic
  process(state_reg) is
  begin
    data_o <= '0';
    case state_reg is
      when zero_zero =>
        data_o <= '0';
      when zero_one =>
        data_o <= '1';
      when one_zero =>
        data_o <= '1';
      when one_one =>
        data_o <= '0';
    end case;
  end process;
end arch;
