-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     manchester_decoder_tb
--
-- description:
--
--   This file implements testbench for manchester decoder.
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

entity manchester_decoder_tb is
end manchester_decoder_tb;

architecture arch of manchester_decoder_tb is
  signal clk_i_test   : std_logic;
  signal data_i_test  : std_logic;
  signal data_o_test  : std_logic;
  signal valid_o_test : std_logic;
  component manchester_decoder is
    port(
      clk_i   : in std_logic;
      data_i  : in std_logic;
      data_o  : out std_logic;
      valid_o : out std_logic
        );
  end component;

  constant c_T        : time := 10 ns;
  signal i            : integer := 0;
  signal data_o  : std_logic;
  signal valid_o : std_logic;

  type t_test_vector is record
    data_i   : std_logic;
    data_o   : std_logic;
    valid_o  : std_logic;
  end record t_test_vector;

  type t_test_vector_array is array (natural range <>) of t_test_vector;

  constant c_TEST_VECTORS : t_test_vector_array := (
    ('0','0','0'),
    ('0','0','1'),
    ('0','0','0'),
    ('0','0','0'),
    ('1','1','1'),
    ('0','0','1'),
    ('1','1','1'),
    ('1','0','0'),
    ('0','0','1'),
    ('0','0','0'),
    ('1','1','1'),
    ('0','0','1'),
    ('0','0','0'),
    ('1','1','1'),
    ('1','0','0'),
    ('0','0','1'),
    ('0','0','0'),
    ('1','1','1'),
    ('1','0','0')
   );

begin

  i1 : manchester_decoder
    port map(
      clk_i   => clk_i_test,
      data_i  => data_i_test,
      data_o  => data_o_test,
      valid_o => valid_o_test
    );

-- Stimulus for continous clock
  clk : process
  begin
    clk_i_test <= '0';
    wait for c_T/2;
    clk_i_test <= '1';
    wait for c_T/2;
    if i /= c_TEST_VECTORS'length -1 then
      i <= i + 1;
    else
      wait;
    end if;
  end process clk;

-- Stimulus generator
  init : process
  begin
    if i /= c_TEST_VECTORS'length -1 then
      data_i_test  <= c_TEST_VECTORS(i).data_i;
      data_o  <= c_TEST_VECTORS(i).data_o;
      valid_o <= C_TEST_VECTORS(i).valid_o;
      wait for  c_T;
    else
      wait;
    end if;
  end process init;

 -- Checking output
  process
  begin
    wait until clk_i_test'event and clk_i_test = '1';
    wait for 15 ns;
    assert(data_o_test = data_o and valid_o_test = valid_o)
       report "Test vector " & integer'image(i) & " failed. " &
              " Expected:data_o = " & std_logic'image(data_o_test) &
              " valid_o =" & std_logic'image(valid_o_test) &
              " Actual:data_o = " & std_logic'image(data_o) &
              " valid_o = " & std_logic'image(valid_o)
       severity error;

    if i = c_TEST_VECTORS'length -1 then
      report "Test completed.";
    end if;
  end process;
end arch;
