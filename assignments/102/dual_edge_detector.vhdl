-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: dual_edge_detector
--
-- description:
--
--   This file implements a dual-edge detector circuit using Melay FSM logic.
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
--! @file dual_edge_detector.vhd
--! @brief This file Implements  dual-edge detector.vhd
--! This file is part of the PDS-2022 project
--! @author Azra Elezovic

--! Use standard library
library ieee;
--! Use numeric elements
use ieee.std_logic_1164.all;


--! @brief Entity for dual-edge detector
--! @details This entity contains clock, reset, input signal
--!  and output signal
entity dual_edge_detector is
  port(
    clk_i      : in   std_logic; --! Input clock signal
    rst_i      : in   std_logic; --! Input reset signal
    strobe_i   : in   std_logic; --! Input signal which transitions we detect
    p_o        : out  std_logic  --! Output signal which detects transitions of input
  );
end dual_edge_detector;


--! @details This circuit is designed using Mealy FSM with 2 states: zero, one
--! The circuit detects transitions 0-1 and 1-0

architecture arch of dual_edge_detector is

    type mealy_state_type is
      (zero, one);
    signal state_reg, state_next : mealy_state_type;

 begin
  --! State register
  state_register : process(clk_i,rst_i)
  begin
    if rst_i = '1' then
      state_reg <= zero;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process state_register;

  --! Next state logic
  next_state : process(state_reg, strobe_i)
  begin
    case state_reg is
      when zero =>
        if strobe_i = '1'  then
          state_next <= one;
	    else
	      state_next <= zero;
        end if;
      when one =>
        if strobe_i = '0' then
          state_next <= zero;
        else
          state_next <= one;
        end if;
    end case;
  end process next_state;

  --! Output logic
  output_logic : process(state_reg, strobe_i)
  begin
    case state_reg is
      when zero =>
        if strobe_i = '0' then
	  p_o <= '0';
	else
	  p_o <= '1';
	end if;
      when one =>
        if strobe_i = '1' then
	  p_o <= '0';
	else
	   p_o <= '0';
	end if;
    end case;
  end process output_logic;
end arch;
