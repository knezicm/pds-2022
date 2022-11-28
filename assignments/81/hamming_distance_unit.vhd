-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: hamming_distance_unit
--
-- description:
--
--   This file implements 8-bit (can be changed by changing the value of variable g_WIDTH (by default is 8))
--   hamming distance unit.
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

entity hamming_distance_unit is
  generic (
    g_WIDTH : natural := 8
  );
  port (
    A_i : in  std_logic_vector(g_WIDTH-1 downto 0);
    B_i : in  std_logic_vector(g_WIDTH-1 downto 0);
    Y_o : out std_logic_vector(3 downto 0)
  );
end hamming_distance_unit;

architecture arch of hamming_distance_unit is
  function log2_unsigned ( x : natural ) return natural
  is
    variable number : natural := x;
    variable log2 : natural := 0;
  begin
    while number > 1 loop
      number := number / 2;
      log2 := log2 + 1;
    end loop;
    return log2;
  end function log2_unsigned;

  constant c_LEVELS : natural := log2_unsigned(g_WIDTH);
  type MAT is array (g_WIDTH/2+1 downto 0 ) of unsigned(3 downto 0);
  signal xor_gates : std_logic_vector(g_WIDTH-1 downto 0);

begin

  process_adder_xor : process(A_i, B_i, xor_gates)
    variable v_count : MAT  := (others =>  ( others => '0'));
    variable v_temp : unsigned(3 downto 0) := (others => '0');
    variable v_out : unsigned(3 downto 0);
  begin
    for i in 0 to (g_WIDTH-1) loop
      xor_gates(i) <= A_i(i) xor B_i(i);
    end loop;
    v_out := (others => '0');
    for i in 0 to c_LEVELS loop
      if i = 0 then
        for j in 0 to (g_WIDTH/2-1) loop
          v_count(j) := (others => '0');
          for k in 2*j to (2*(j+1)-1) loop
            v_count(j) := v_count(j) + ("000" & xor_gates(k));
          end loop;
          v_out := v_out + v_count(j);
        end loop;
      elsif i = 1 then
        v_temp := (others => '0');
        for j in 0 to (g_WIDTH/4-1) loop
          v_temp := v_temp + v_count(j);
        end loop;
        v_count(g_WIDTH/2) := v_temp;
        v_temp := (others => '0');
        for j in g_WIDTH/4 to (g_WIDTH/2-1) loop
          v_temp := v_temp + v_count(j);
        end loop;
        v_count(g_WIDTH/2+1) := v_temp;
        v_out := v_count(g_WIDTH/2) + v_count(g_WIDTH/2+1);
      else
        v_out := v_out;
      end if;
    end loop;
    Y_o <= std_logic_vector(v_out);
  end process process_adder_xor;
end arch;
