-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     MANCHESTER ENCODER SELF-CHECKING TESTBENCH
--
-- description:
--
--   This file implements Manchester encoder self-checking testbench.
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

-------------------------------------------------------
--! @file manchester_encoder_tb.vhd
--! @brief  This file implements Manchester encoder self-checking testbench.
--! @author Emanuela Buganik
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief Manchester_encoder_tb is testbench of manchester_encoder entity.

entity manchester_encoder_tb is
end manchester_encoder_tb;

architecture arch of manchester_encoder_tb is
  component manchester_encoder
    port (
      clk_i : in  std_logic;
      rst_i : in  std_logic;
      v_i   : in  std_logic;
      d_i   : in  std_logic;
      y_o   : out std_logic
      );
  end component;

--! Signals to assign to master ports
  signal tstclk_i : std_logic;
  signal tstrst_i : std_logic;
  signal tstv_i   : std_logic := '0';
  signal tstd_i   : std_logic := '0';
  signal tsty_o   : std_logic := '0';

--! Test signals to compare
-- signal valid_input : std_logic;
-- signal data_stream : std_logic;
  signal output      : std_logic;
  signal i : integer := 0; --! loop variable
  constant c_TIME : time := 20 ns;
-- variable error_status : boolean;

  type t_test_vector is record
  valid_input_v : std_logic;
  data_stream_v : std_logic;
  output_v      : std_logic;
end record t_test_vector;

  type t_test_vectors is array (natural range <>) of t_test_vector;
  constant c_TEST_VECTOR : t_test_vectors := (
  ('0','0','0'),
  ('0','1','0'),
  ('1','0','1'),
  ('1','1','1')
 );

--! uut instantiation
begin
  uut : manchester_encoder
    port map (
       clk_i => tstclk_i,
       rst_i => tstrst_i,
       v_i   => tstv_i,
       d_i   => tstd_i,
       y_o   => tsty_o);
--! Continuous clock process
  process
  begin
    tstclk_i <= '0';
    wait for c_TIME/2;
    tstclk_i <= '1';
    wait for c_TIME/2;

    if i = c_TEST_VECTOR'length then
      wait;
    end if;
  end process;

--! Reset clock process
  process
  begin
    tstrst_i <= '0';
    wait for 40 ns;
    tstrst_i <= '1';
    wait;
  end process;

--! Assigning values from vector array
  process
  begin
    tstv_i <= c_TEST_VECTOR(i).valid_input_v;
    tstd_i <= c_TEST_VECTOR(i).data_stream_v;
    output <= c_TEST_VECTOR(i).output_v;
    wait for 5 ns;

    if i < c_TEST_VECTOR'length then
      i <= i + 1;
    else
      wait;
    end if;
  end process;

--! Comparing output
  process
    variable error_status : boolean;
  begin

    wait until tstclk_i'event and tstclk_i = '1';
    wait for 5 ns;
    if tsty_o = output then
      error_status := false;
    else
      error_status := true;
    end if;

    assert not error_status
   report "Test failed!"
   severity note;

    if i = c_TEST_VECTOR'length then
      report "Test successfully completed!";
    end if;
  end process;
end arch;
