-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:   eight_bit_multiplier
--
-- description:
--
--   This file implements a simple multiplier between two 8-bit number.
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 


entity eight_bit_multiplier is
  port (
  A_i   : in  std_logic_vector(7 downto 0);
  B_i   : in  std_logic_vector(7 downto 0);
  RES_o : out std_logic_vector(15 downto 0)
);
end eight_bit_multiplier;

architecture multipler of eight_bit_multiplier is

	--variable BA : UNSIGNED ((A_i'length + B_i' length - 1) downto 0);
	
	begin
	process ( B_i, A_i)
	
	variable PA : unsigned (15 downto 0) := "0000000000000000";
	variable i  : integer := 0;

	begin
		while i < 8 loop 
			if ( B_i(i) = '1') then
				PA := PA + ( shift_left(unsigned(A_i), 1));
			end if;
			i := i + 1;
		end loop;
		RES_o <= std_logic_vector(PA);
	end process;
	
	
end architecture multipler;