-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: signed_to_sign_magnitude_converter
--
-- description:
--
--   This file implements an 8-bit signed number converter
--   from two's complement form to sign-magnitude form.
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
entity signed_to_sign_magnitude_converter is
  port(
    SIGN_BIN_i  : in  std_logic_vector(7 downto 0);
    SIGN_MAG_o  : out std_logic_vector(7 downto 0)
    );
end signed_to_sign_magnitude_converter;

architecture arch of signed_to_sign_magnitude_converter is
  component seven_bit_comparator
    port
    (
        a_i : in  std_logic_vector(6 downto 0);
        y_o : out std_logic
    );
  end component;
  signal zero : std_logic;
begin
  comp : seven_bit_comparator port map(
    a_i => SIGN_BIN_i(6 downto 0),
    y_o => zero);
  p1 : process(SIGN_BIN_i)
  begin
    if zero = '1' then
      SIGN_MAG_o <= (others => '0');
    elsif SIGN_BIN_i(7) = '1' then
      SIGN_MAG_o <= '1' & std_logic_vector(not(signed (SIGN_BIN_i(6 downto 0))) + 1);
    else
      SIGN_MAG_o <= SIGN_BIN_i;
    end if;
  end process p1;
end arch;
