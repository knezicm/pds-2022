-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     LEADING ZERO COUNTER SELF-CHECKING TESTBENCH
--
-- description:
--
--   This file implements a leading zero counter testbench.
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

entity leading_zero_counter_tb is
end leading_zero_counter_tb;

architecture arch of leading_zero_counter_tb is

  component leading_zero_counter is
    port (
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;
      start_i  : in  std_logic;
      n_i      : in  std_logic_vector(15 downto 0);
      ready_o  : out std_logic;
      zeros_o  : out std_logic_vector(4 downto 0)
    );
  end component;

  constant c_TIME : time := 20 ns;
  signal i : integer := 0;

  type t_test_vector is record
    n   : std_logic_vector(15 downto 0);
    res : std_logic_vector(4 downto 0);
  end record t_test_vector;

  type t_test_vector_array is array (natural range <>) of t_test_vector;

  constant c_TEST_VECTOR : t_test_vector_array := (
    ("1010101010101010", "00000"),
    ("0101010101010101", "00001"),
    ("0010101010101010", "00010"),
    ("0001010101010101", "00011"),
    ("0000101010101010", "00100"),
    ("0000010101010101", "00101"),
    ("0000001010101010", "00110"),
    ("0000000101010101", "00111"),
    ("0000000010101010", "01000"),
    ("0000000001010101", "01001"),
    ("0000000000101010", "01010"),
    ("0000000000010101", "01011"),
    ("0000000000001010", "01100"),
    ("0000000000000101", "01101"),
    ("0000000000000010", "01110"),
    ("0000000000000001", "01111"),
    ("0000000000000000", "10000")
  );

  signal stop        : std_logic := '0';
  signal tststart_i  : std_logic;
  signal tstrst_i    : std_logic;
  signal tstclk_i    : std_logic;
  signal tstn_i      : std_logic_vector(15 downto 0);
  signal tstready_o  : std_logic;
  signal tstzeros_o  : std_logic_vector(4 downto 0) := "00000";
  signal result      : std_logic_vector(4 downto 0);

begin

  uut : leading_zero_counter
    port map (
      clk_i    => tstclk_i,
      rst_i    => tstrst_i,
      start_i  => tststart_i,
      n_i      => tstn_i,
      ready_o  => tstready_o,
      zeros_o  => tstzeros_o
    );

  tstrst_i <= '0';

  -- stimulus for continous clock
  process
  begin

    tstclk_i <= '0';
    wait for c_TIME / 2;
    tstclk_i <= '1';
    wait for c_TIME / 2;

    if stop = '1' then
      wait;
    end if;

  end process;

  -- stimulus generator
  process
  begin

    tstn_i <= c_TEST_VECTOR(i).n;
    result <= c_TEST_VECTOR(i).res;

    wait for c_TIME;

    tststart_i <= '1';

    wait for c_TIME;

    tststart_i <= '0';

    wait until tstready_o = '1';
    wait for c_TIME / 2;

    if i < c_TEST_VECTOR'length then
      i <= i + 1;
    else
      stop <= '1';
      report "Test completed."
      severity note;
      wait;
    end if;

  end process;

  -- check output
  process
  begin

    if stop = '1' then
      wait;
    end if;

    wait until tststart_i = '1';
    wait for c_TIME / 4;
    wait until tstready_o = '1';
    wait for c_TIME / 4;

-- enable output
    assert false
    report "Checking " & integer'image(to_integer(unsigned(tstzeros_o))) &
           " and " & integer'image(to_integer(unsigned(result)))
    severity note;

    assert (tstzeros_o = result)
      report "Error when result = " & integer'image(to_integer(unsigned(tstzeros_o))) & LF &
             " expected to be = " & integer'image(to_integer(unsigned(result)))
      severity error;
  end process;
end arch;
