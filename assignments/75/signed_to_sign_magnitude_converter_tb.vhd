-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: signed_to_sign_magnitude_converter_tb
--
-- description:
--
--   This file implements testbench for signed to sign-magnitude converter.
--
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

entity signed_to_sign_magnitude_converter_tb is
end signed_to_sign_magnitude_converter_tb;
architecture arch of signed_to_sign_magnitude_converter_tb is
  signal SIGN_BIN_i : std_logic_vector(7 downto 0);
  signal SIGN_MAG_o : std_logic_vector(7 downto 0);
  component signed_to_sign_magnitude_converter
    port(
      SIGN_BIN_i : in std_logic_vector(7 downto 0);
      SIGN_MAG_o : out std_logic_vector(7 downto 0)
       );
  end component;
begin
  i1 : signed_to_sign_magnitude_converter port map(
    SIGN_BIN_i => SIGN_BIN_i,
    SIGN_MAG_o => SIGN_MAG_o);
  init : process
    variable tmp : integer := -127;
  begin
    SIGN_BIN_i <= (others => '0');
    wait for 50 ns;
    assert (SIGN_MAG_o = "00000000") report "Error at " &
      integer'image(to_integer(signed(SIGN_BIN_i))) & " and at " &
      integer'image(to_integer(signed(SIGN_MAG_o))) severity error;
    wait for 50 ns;
    SIGN_BIN_i <= "10000000";
    assert (SIGN_MAG_o = "00000000") report "Error at " &
      integer'image(to_integer(signed(SIGN_BIN_i))) & " and at " &
      integer'image(to_integer(signed(SIGN_MAG_o))) severity error;
    wait for 50 ns;
    SIGN_BIN_i <= "11111111";
    wait for 50 ns;
    for i in -127 to 127 loop
      wait for 50 ns;
      if tmp = 0 then
      else
        SIGN_BIN_i <= std_logic_vector(to_signed(tmp,8));
        wait for 50 ns;
      end if;
      if SIGN_BIN_i(7) = '1' then
        wait for 50 ns;
        assert (SIGN_MAG_o = '1' & std_logic_vector(not(signed(SIGN_BIN_i(6 downto 0))) + 1)) report "Error,value is" &
        integer'image(to_integer(signed(SIGN_BIN_i))) & "and value of number(sign-magnitude form) is" &
        integer'image(to_integer(signed(SIGN_MAG_o))) severity error;
      else
        wait for 50 ns;
        assert (SIGN_MAG_o = SIGN_BIN_i) report "Error,value of number(two's complement form) is" &
        integer'image(to_integer(signed(SIGN_BIN_i))) & "and value of number(sign-magnitude form) is" &
        integer'image(to_integer(signed(SIGN_MAG_o))) severity error;
      end if;
      tmp := tmp + 1;
    end loop;
    wait for 50 ns;
    report "Test completed.";
    wait;
  end process init;
end arch;
