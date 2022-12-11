-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:   Preamble detector
--
-- description:
--
-- This VHDL project presents a testbench code for Moore FSM sequence detector.
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

entity preamble_detector_vhd_tst is
end preamble_detector_vhd_tst;
architecture arch of preamble_detector_vhd_tst is
-- constants
-- signals
  signal clk_i : STD_LOGIC := '0';
  signal data_i : STD_LOGIC := '0';
  signal match_o : STD_LOGIC := '0';
  signal rst_i : STD_LOGIC := '0';
  component preamble_detector
    port(
       clk_i : in STD_LOGIC;
       data_i : in STD_LOGIC;
       match_o : out STD_LOGIC;
       rst_i : in STD_LOGIC
);
  end component;

  constant c_CLOCK_PERIOD : time := 10 ns;

begin
  i1 : preamble_detector
port map (
-- list connections between master ports and signals
clk_i   => clk_i,
data_i  => data_i,
match_o => match_o,
rst_i   => rst_i
);
-- Clock process definitions
  clock_process : process
  begin
    clk_i <= '0';
    wait for c_CLOCK_PERIOD/2;
    clk_i <= '1';
    wait for c_CLOCK_PERIOD/2;
  end process clock_process;

  init : process
-- variable declarations
  begin
-- hold reset state for 100 ns.
    data_i <= '0';
    rst_i <= '1';
    wait for 30 ns;
    rst_i <= '0';
    wait for 40 ns;

    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait for 10 ns;
    data_i <= '1';
    wait for 10 ns;
    data_i <= '0';
    wait;
  end process init;
  always : process
-- optional sensitivity list
-- (        )
-- variable declarations
  begin
-- code executes for every event on sensitivity list
    wait;
  end process always;
end arch;
