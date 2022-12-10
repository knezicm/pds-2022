-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:   Preamble detector
--
-- description:
--
-- This VHDL project presents a full VHDL code for Moore FSM sequence detector.
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
-- !Use standard library
library ieee;
use ieee.std_logic_1164.all;
-- !@brief In digital communications, a synchronization bit sequence known as
-- !a preamble is often used. The entity describes all the necessary input and
-- !output signals needed to realize this circuit.

-- !@details More details about this element.
entity preamble_detector is
  port (
  clk_i   : in  std_logic;  -- !Clock input 
  rst_i   : in  std_logic;  -- !Reset signal: When the input signal is '1' then the detector is in the reset state and cannot receive the signal.
  data_i  : in  std_logic;  -- !Input data: Each clock signal is followed by input data.
  match_o : out std_logic   -- !Output data: When the sequence appears at the output, we have a high logic level for one clock period.
);
end preamble_detector;

-- !@brief Architecture definition of the preamble_detector: a state machine that detects the bit sequence "10101010" on the serial input.
-- !@details More details about this element.

architecture arch of preamble_detector is

-- !Defintion of Moore state type
  type t_moore_state is
   (idle, state1, state2, state3, state4, state5, state6, state7, state8);
  signal state_reg, state_next : t_moore_state;

begin
-- !State register--
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;
-- !Next_state logic--
  process(state_reg, data_i)
  begin
    case state_reg is
      when idle =>
        if data_i = '1' then
          state_next <= state1;
        else
          state_next <= idle;
        end if;
      when state1 =>
        if data_i = '0' then
          state_next <= state2;
        else
          state_next <= state1;
        end if;
      when state2 =>
        if data_i = '1' then
          state_next <= state3;
        else
          state_next <= idle;
        end if;
      when state3 =>
        if data_i = '0' then
          state_next <= state4;
        else
          state_next <= state1;
        end if;
      when state4 =>
        if data_i = '1' then
          state_next <= state5;
        else
          state_next <= idle;
        end if;
      when state5 =>
        if data_i = '0' then
          state_next <= state6;
        else
          state_next <= state1;
        end if;
      when state6 =>
        if data_i = '1' then
          state_next <= state7;
        else
          state_next <= idle;
        end if;
      when state7 =>
        if data_i = '0' then
          state_next <= state8;
        else
          state_next <= state1;
        end if;
      when state8 =>
        if data_i = '1' then
          state_next <= state1;
        else
          state_next <= idle;
        end if;
    end case;
  end process;
-- !Moore output logic
  process(state_reg)
  begin
    match_o <= '0';
    case state_reg is
      when idle =>
        match_o <= '0';
      when state1 =>
        match_o <= '0';
      when state2 =>
        match_o <= '0';
      when state3 =>
        match_o <= '0';
      when state4 =>
        match_o <= '0';
      when state5 =>
        match_o <= '0';
      when state6 =>
        match_o <= '0';
      when state7 =>
        match_o <= '0';
      when state8 =>
        match_o <= '1';
    end case;
  end process;
end arch;
