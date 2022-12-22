-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:    MULTI_FUNCTION_ARITMETIC_UNIT
--
-- description:
--
--   This file describe circuit that can do following operation: +, -, +1, -1 .
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
--!@file
--!@brief nrzi_encoder
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--!@brief nrzi_encoder entity (encoder of input signal)
--!@details This entity represent Non return to zero Inverted encoder of input signal.

entity nrzi_encoder is
  port (
  clk_i  : in  std_logic;   --!Clock input
  rst_i  : in  std_logic;   --!Reset input
  data_i : in  std_logic;   --!Input for data signal
  data_o : out std_logic);  --!Output of nrzi_encoder
end nrzi_encoder;

--!@brief  Architecture description of nrzi_encoder entity
--!@details This architecture represent encoding of input signal.
--!@details If the input signal is '0', then output of nrzi_encoder  block will remain same.
--!But if input signal is '1', then output of NRZI block will change state.


architecture arch of nrzi_encoder is
  type t_nrzi_type is (idle, one, zero);

  signal state_reg  : t_nrzi_type;
  signal state_next : t_nrzi_type;
  signal tmp_out    : std_logic;


begin

  pr1 : process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif clk_i'event and clk_i = '1' then
      state_reg <= state_next;
    end if;
  end process pr1;

  pr2 : process(state_reg, data_i)
  begin
    case state_reg is
      when idle =>
        if data_i = '1' then
          state_next <= one;
        else
          state_next <= zero;
        end if;
      when one =>
        if data_i = '1' then
          state_next <= zero;
        else
          state_next <= one;
        end if;
      when zero =>
        if data_i = '1' then
          state_next <= one;
        else
          state_next <= zero;
        end if;
    end case;
  end process pr2;

  pr3 : process(state_reg)
  begin
    data_o <= '0';

    case state_reg is
      when idle =>
      when one  => data_o <= '1';
      when zero => data_o <= '0';
    end case;
  end process pr3;

end arch;
