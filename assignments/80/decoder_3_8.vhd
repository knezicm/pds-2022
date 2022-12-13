-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:    decoder_3_8
--
-- description:
--
--   This file implements a decoder_3_8 logic.
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

entity decoder_3_8 is
  port (
  CODE_i :  in std_logic_vector(2 downto 0);
  REQ_o  : out std_logic_vector(7 downto 0)
  );
end decoder_3_8;

architecture arch of decoder_3_8 is

begin

  decoding :  process(CODE_i)

  begin

    case CODE_i is
      when "111" => REQ_o <= "10000000";
      when "110" => REQ_o <= "01000000";
      when "101" => REQ_o <= "00100000";
      when "100" => REQ_o <= "00010000";
      when "011" => REQ_o <= "00001000";
      when "010" => REQ_o <= "00000100";
      when "001" => REQ_o <= "00000010";
      when "000" => REQ_o <= "00000001";
      when others => REQ_o <= "UUUUUUUU";
    end case;

  end process decoding;

end arch;
