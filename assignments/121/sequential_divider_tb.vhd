-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     sequential_divider
--
-- description:
--
--   This file implements sequential_divider_tb.
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

entity sequential_divider_tb is
end sequential_divider_tb;
architecture arch of sequential_divider_tb is
  signal a_i     : std_logic_vector(7 downto 0);
  signal b_i     : std_logic_vector(7 downto 0);
  signal clk_i   : std_logic;
  signal q_o     : std_logic_vector(7 downto 0);
  signal r_o     : std_logic_vector(7 downto 0);
  signal ready_o : std_logic;
  signal rst_i   : std_logic;
  signal start_i : std_logic;
  component sequential_divider
    port (
      a_i     : in  std_logic_vector(7 downto 0);
      b_i     : in  std_logic_vector(7 downto 0);
      clk_i   : in  std_logic;
      q_o     : out std_logic_vector(7 downto 0);
      r_o     : out std_logic_vector(7 downto 0);
      ready_o : out std_logic;
      rst_i   : in  std_logic;
      start_i : in  std_logic
    );
  end component;
begin
  i1 : sequential_divider
  port map(
    a_i     => a_i,
    b_i     => b_i,
    clk_i   => clk_i,
    q_o     => q_o,
    r_o     => r_o,
    ready_o => ready_o,
    rst_i   => rst_i,
    start_i => start_i
  );
  init : process
  begin
    wait;
  end process init;
  always : process
  begin
    clk_i <= '0';
    rst_i <= '0';
    wait for 100 ns;
    for i in 0 to 18 loop
      for j in 0 to 255 loop
        a_i     <= std_logic_vector(to_unsigned(i, 8));
        b_i     <= std_logic_vector(to_unsigned(j, 8));
        start_i <= '1';
        clk_i   <= '1';
        wait for 100 ns;
        clk_i <= '0';
        wait for 100 ns;
        start_i <= '0';
        clk_i   <= '1';
        wait for 100 ns;
        while ready_o = '0' loop
          clk_i <= '0';
          wait for 50 ns;
          clk_i <= '1';
          wait for 50 ns;
        end loop;

        if j = 0 then
          assert q_o = "11111111" and r_o = "11111111"
          report "A=" & integer'image(to_integer(unsigned(a_i)))
            & ", B=" & integer'image(to_integer(unsigned(b_i)))
            & "EXPECTED q_o=" & integer'image(255)
            & "ACTUAL q_o=" & integer'image(to_integer(unsigned(q_o)))
            & "EXPECTED r_o=" & integer'image(255)
            & "ACTUAL r_o=" & integer'image(to_integer(unsigned(r_o)))
            severity error;
        else
          assert to_integer(unsigned(a_i)) / to_integer(unsigned(b_i)) = to_integer(unsigned(q_o))
          report "A=" & integer'image(to_integer(unsigned(a_i)))
            & ", B=" & integer'image(to_integer(unsigned(b_i)))
            & "EXPECTED q_o=" & integer'image(to_integer(unsigned(a_i)) / to_integer(unsigned(b_i)))
            & "ACTUAL q_o=" & integer'image(to_integer(unsigned(q_o)))
            severity error;
        end if;
      end loop;
    end loop;

    wait;
  end process always;
end arch;
