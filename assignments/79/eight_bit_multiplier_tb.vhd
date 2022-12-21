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
use ieee.numeric_std.all;

entity eight_bit_multiplier_tb is
end eight_bit_multiplier_tb;
architecture arch of eight_bit_multiplier_tb is
-- constants
-- signals
  signal A_i : std_logic_vector(7 downto 0);
  signal B_i : std_logic_vector(7 downto 0);
  signal RES_o : std_logic_vector(15 downto 0);
  component eight_bit_multiplier
    port (
      A_i   : in std_logic_vector(7 downto 0);
      B_i   : in std_logic_vector(7 downto 0);
      RES_o : out std_logic_vector(15 downto 0)
);
  end component;
begin
  i1 : eight_bit_multiplier
  port map (
-- list connections between master ports and signals
    A_i   => A_i,
    B_i   => B_i,
    RES_o => RES_o
  );
  init : process
  -- variable declarations
  begin
    for i in 0 to 255 loop -- 16 multiplier values
      A_i <= std_logic_vector(to_unsigned(i,8));
      for j in 1 to 255 loop -- 16 multiplicand values
        B_i <= std_logic_vector(to_unsigned(j,8));
        wait for 10 ns;
        assert (to_integer(UNSIGNED(RES_o)) = (i * j)) report "Incorrect product" severity NOTE;
        wait for 10 ns;
      end loop;
    end loop;
    wait;
  end process init;
  always : process
  begin
    -- optional sensitivity list
    -- (        )
    -- variable declarationsBEGIN
        -- code executes for every event on sensitivity list
    wait;
  end process always;
end arch;
