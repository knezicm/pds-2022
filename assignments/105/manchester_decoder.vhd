-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     manchester_decoder
--
-- description:
--
--   This file implements manchester decoder.
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
--! @file manchester_decoder.vhd
--! @brief This file implements Manchester decoding circuit.
--!
--! @author Tamara Lekic

library ieee;
use ieee.std_logic_1164.all;

--! @brief Entity for manchester_decoder.
--! @details The data and clock can be extracted by a manchester decoder.
--! This entity contains all the necessary input and output signals to realize this circuit.

entity manchester_decoder is
  port(
    clk_i   : in  std_logic; --! Clock input signal.
    data_i  : in  std_logic; --! The data_i is the input manchester data stream.
    data_o  : out std_logic; --! The data_o is the output data stream.
    valid_o : out std_logic --! The valid_o output indicates whether the data_o signal is valid.
);
end manchester_decoder;

--! @brief Architecture for manchester_decoder.
--! @details Architecture is implemented using Moore FSM with 5 states(idle, s0, s1, s2, s3).
--!
architecture arch of manchester_decoder is
  type t_manch_dec is (idle,s0,s1,s2,s3);
  signal state_reg,state_next : t_manch_dec;
begin
--! State register
  process(clk_i) is
  begin
    if rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;
--! Next-state logic
  process(state_reg,data_i) is
  begin
    case state_reg is
      when idle =>
        if data_i = '0' then
          state_next <= s0;
        elsif data_i = '1' then
          state_next <= s2;
        end if;
      when s0 =>
        if data_i = '0' then
          state_next <= s0;
        elsif data_i = '1' then
          state_next <= s1;
        end if;
      when s2 =>
        if data_i = '0' then
          state_next <= s3;
        elsif data_i = '1' then
          state_next <= s2;
        end if;
      when s1 =>
        if data_i = '1' then
          state_next <= s2;
        elsif data_i = '0' then
          state_next <= s3;
        end if;
      when s3 =>
        if data_i = '0' then
          state_next <= s0;
        elsif data_i = '1' then
          state_next <= s1;
        end if;
    end case;
  end process;
--! Moore output logic
  process(state_reg)
  begin
    data_o <= '0';
    valid_o <= '0';
    case state_reg is
      when idle =>
      when s0 =>
      when s2 =>
      when s1 =>
        valid_o <= '1';
      when s3 =>
        data_o <= '1';
        valid_o <= '1';
    end case;
  end process;
end arch;
