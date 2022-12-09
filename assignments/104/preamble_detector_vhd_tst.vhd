-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions
-- and other software and tools, and any partner logic
-- functions, and any output files from any of the foregoing
-- (including device programming or simulation files), and any
-- associated documentation or information are expressly subject
-- to the terms and conditions of the Intel Program License
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to
-- suit user's needs .Comments are provided in each section to help the user
-- fill out necessary details.
-- ***************************************************************************
-- Generated on "12/07/2022 00:28:54"

-- Vhdl Test Bench template for design  :  preamble_detector
--
-- Simulation tool : ModelSim (VHDL)
--

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
