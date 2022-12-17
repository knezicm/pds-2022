-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:    priority_encoder_8_3
--
-- description:
--
--   This file implements a priority_8_3 encoder logic.
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

entity priority_encoder_8_3 is
  port (
 REQ_i   :  in std_logic_vector(7 downto 0);
 CODE_o  : out std_logic_vector(2 downto 0);
 VALID_o : out std_logic
 );
end priority_encoder_8_3;

architecture arch of priority_encoder_8_3 is

begin

  encoding : process(REQ_i)

  begin

    VALID_O <= '1';

    if REQ_i(7) = '1' then
      CODE_o <= "111";
    elsif REQ_i(6) = '1' then
      CODE_o <= "110";
    elsif REQ_i(5) = '1' then
      CODE_o <= "101";
    elsif REQ_i(4) = '1' then
      CODE_o <= "100";
    elsif REQ_i(3) = '1' then
      CODE_o <= "011";
    elsif REQ_i(2) = '1' then
      CODE_o <= "010";
    elsif REQ_i(1) = '1' then
      CODE_o <= "001";
    elsif REQ_i(0) = '1' then
      CODE_o <= "000";
    else
      VALID_o <= '0';
      CODE_o <= "UUU";
    end if;

  end process encoding;

end arch;
