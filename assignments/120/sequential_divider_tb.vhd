-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: sequential_divider_tb
-- description:
--
--   This file implements sequential divider testbench.
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

  signal clk_test   : std_logic;
  signal rst_test   : std_logic;
  signal start_test : std_logic;
  signal a_test     : std_logic_vector(7 downto 0);
  signal b_test     : std_logic_vector(7 downto 0);
  signal q_test     : std_logic_vector(7 downto 0);
  signal r_test     : std_logic_vector(7 downto 0);
  signal ready_test : std_logic;
  component sequential_divider
    port (
      clk_i   : in  std_logic;
      rst_i   : in  std_logic;
      start_i : in  std_logic;
      a_i     : in  std_logic_vector(7 downto 0);
      b_i     : in  std_logic_vector(7 downto 0);
      q_o     : out std_logic_vector(7 downto 0);
      r_o     : out std_logic_vector(7 downto 0);
      ready_o : out std_logic
    );
  end component;

-- uut instantiation
begin
  uut : sequential_divider
  port map(
    clk_i   => clk_test,
    rst_i   => rst_test,
    start_i => start_test,
    a_i     => a_test,
    b_i     => b_test,
    q_o     => q_test,
    r_o     => r_test,
    ready_o => ready_test
  );

-- Reset clock process - inactive

  rst_test <= '0';
-- Clock process
  process
  begin

    clk_test <= '0';
    wait for 10 ns;
    clk_test <= '1';
    wait for 10 ns;

  end process;

-- Generate stimulus process
  process
--  variable error_status : boolean;
  begin
  -- Loop input values
    for i in 0 to 255 loop
      for j in 0 to 255 loop
        a_test     <= std_logic_vector(to_unsigned(i, 8));
        b_test     <= std_logic_vector(to_unsigned(j, 8));
-- Activate process
        wait for 20 ns;
        start_test <= '1';
        wait for 20 ns;
        start_test <= '0';

        wait until ready_test = '1';
        wait for 10 ns;

        if b_test = "00000000"  then
          assert q_test = "11111111" and r_test = "11111111"
          report "CHECKING DIVISION WITH ZERO: " & "a_i = " & integer'image(to_integer(unsigned(a_test)))
            & ", b_i = " & integer'image(to_integer(unsigned(b_test)))
            & " expected value q_o =" & integer'image(255)
            & " actual value q_o=" & integer'image(to_integer(unsigned(q_test)))
            & " expected value r_o=" & integer'image(255)
            & " actual value r_o=" & integer'image(to_integer(unsigned(r_test)))
            severity note;
        else
          assert to_integer(unsigned(a_test)) / to_integer(unsigned(b_test)) = to_integer(unsigned(q_test))
          report "a_i =" & integer'image(to_integer(unsigned(a_test)))
            & ", b_i = " & integer'image(to_integer(unsigned(b_test)))
            & " expected value q_o =" & integer'image(to_integer(unsigned(a_test)) / to_integer(unsigned(b_test)))
            & " actual value q_o =" & integer'image(to_integer(unsigned(q_test)))
            & " expected value r_o=" & integer'image(to_integer(unsigned(a_test)) mod to_integer(unsigned(b_test)))
            & " actual value r_o=" & integer'image(to_integer(unsigned(r_test)))
            severity note;
        end if;
      end loop;
    end loop;
  end process;
end arch;
