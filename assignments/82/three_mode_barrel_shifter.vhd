-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     3-MODE BARREL SHIFTER
--
-- description:
--
--   This file implements three-mode barrel shifter logic
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
entity three_mode_barrel_shifter is
  port (
  A_i   : in  std_logic_vector(7 downto 0);
  LAR_i : in  std_logic_vector(1 downto 0);
  AMT_i : in  std_logic_vector(2 downto 0);
  Y_o   : out std_logic_vector(7 downto 0)
);
end three_mode_barrel_shifter;

architecture shifter_arch of three_mode_barrel_shifter is
   signal out1, out2, out3 : std_logic_vector(7 downto 0);
   signal bit1 : std_logic;
   signal bit2: std_logic_vector(1 downto 0);
   signal bit4: std_logic_vector(3 downto 0);
	
begin

  with LAR_i select
	bit1 <= '0'  when "00",
			A_i(7) when "01",
			A_i(0) when others;
  out1 <= bit1 & A_i(7 downto 1) when AMT_i(0)='1' else
			  A_i;

  with LAR_i select
	bit2 <= "00" when "00",
		   (others => out1(7)) when "01",
		   out1(1 downto 0)    when others;
  out2<= bit2 & out1(7 downto 2) when AMT_i(1)='1' else
			  out1;

  with LAR_i select
	bit4 <= "0000" when "00",
		  (others => out2(7)) when "01",
		  out2(3 downto 0)    when others;
  out3 <= bit4 & out2(7 downto 4)when AMT_i(2)='1' else
			  out2;
			  
  Y_o <= out3;
end shifter_arch;