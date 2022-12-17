-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     SUB1
--
-- description:
--
--   This file describe unit that is capable of: addition, substraction, incrementation, decrementation
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
use ieee.numeric_std.all;


entity sub1 is
  port (
    a_i : in  std_logic_vector(15 downto 0);
    b_i : in  std_logic_vector(15 downto 0);
    c_i : in  std_logic_vector(1 downto 0);
    y_o : out std_logic_vector(15 downto 0));

end sub1;

architecture arch of sub1 is


begin

  sub1_pr : process(a_i, b_i, c_i) is
  begin
    case c_i is
      when "00"   =>   y_o <= std_logic_vector( unsigned(a_i) + unsigned(b_i));
      when "01"   =>   y_o <= std_logic_vector(unsigned(a_i) - unsigned(b_i));
      when "10"   =>   y_o <= std_logic_vector(unsigned(a_i) + 1);
      when "11"   =>   y_o <= std_logic_vector(unsigned(a_i) - 1);
      when others => y_o <= std_logic_vector( unsigned(a_i) + unsigned(b_i));
    end case;
  end process sub1_pr;

end arch;
