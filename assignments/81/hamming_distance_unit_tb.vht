-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: hamming_distance_unit_tb
--
-- description:
--
--   This file implements testbench for hamming distance unit.
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

entity hamming_distance_unit_tb is
end hamming_distance_unit_tb;
architecture arch of hamming_distance_unit_tb is
-- constants
-- signals
  signal A_i : STD_LOGIC_VECTOR(7 downto 0);
  signal B_i : STD_LOGIC_VECTOR(7 downto 0);
  signal Y_o : STD_LOGIC_VECTOR(3 downto 0);
  component hamming_distance_unit
    port (
      A_i : in STD_LOGIC_VECTOR(7 downto 0);
      B_i : in STD_LOGIC_VECTOR(7 downto 0);
      Y_o : out STD_LOGIC_VECTOR(3 downto 0)
    );
  end component;
begin
  i1 : hamming_distance_unit
  port map (
-- list connections between master ports and signals
    A_i => A_i,
    B_i => B_i,
    Y_o => Y_o
  );
  init : process
-- variable declarations
  begin
        -- code that executes only once
    wait;
  end process init;
  always : process
-- optional sensitivity list
-- (        )
-- variable declarations
    variable v_xor : unsigned (7 downto 0);
    variable v_count : unsigned(3 downto 0) := (others => '0');
  begin
    A_i <= (others => '0');
    B_i <= (others => '0');
    wait for 10 ns;
    for i in 0 to 255 loop
      for j in 0 to 255 loop
        B_i <= std_logic_vector(to_unsigned(j,8));
        v_xor := unsigned(A_i) xor unsigned(B_i);
        v_count := (others => '0');
        for k in 0 to 7 loop
          if v_xor(k) = '1' then
            v_count := v_count + 1;
          end if;
        end loop;
        if Y_o = "0000" then
          if not (std_logic_vector(v_count) = "0000") then
            assert false report "incorrect hamming distance! Expected: 0, but got: " &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0001" then
          if not (std_logic_vector(v_count) = "0001") then
            assert false report "incorrect hamming distance! Expected: 1, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0010" then
          if not (std_logic_vector(v_count) = "0010") then
            assert false report "incorrect hamming distance! Expected: 2, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0011" then
          if not (std_logic_vector(v_count) = "0011") then
            assert false report "incorrect hamming distance! Expected: 3, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0100" then
          if not (std_logic_vector(v_count) = "0100") then
            assert false report "incorrect hamming distance! Expected: 4, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0101" then
          if not (std_logic_vector(v_count) = "0101") then
            assert false report "incorrect hamming distance! Expected: 5, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0110" then
          if not (std_logic_vector(v_count) = "0110") then
            assert false report "incorrect hamming distance! Expected: 6, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "0111" then
          if not (std_logic_vector(v_count) = "0111") then
            assert false report "incorrect hamming distance! Expected: 7, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        elsif Y_o = "1000" then
          if not (std_logic_vector(v_count) = "1000") then
            assert false report "incorrect hamming distance! Expected: 0, but got: "  &
              integer'image(to_integer(v_count)) & "!" severity error;
          end if;
        end if;
        wait for 10 ns;
      end loop;
      A_i <= std_logic_vector(to_unsigned(i,8));
      wait for 10 ns;
    end loop;
    wait;
  end process always;
end arch;
