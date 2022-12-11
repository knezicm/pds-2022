--! \file nrzi_decoder_tb.vhd
--! \brief This file Implements testbench for nrzi_decoder.
--!
--! This file is part of the PDS-2022 project
--! \author Nikola Cetic

-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     nrzi_decoder_vhd_tst
--
-- description:
--
--   This file implements testbench for nrzi_decoder.
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

--! \brief Creates testbench.
--!

entity nrzi_decoder_tb is
end nrzi_decoder_tb;
architecture arch of nrzi_decoder_tb is

  signal clk_i  : std_logic;
  signal data_i : std_logic;
  signal data_o : std_logic;
  signal rst_i  : std_logic;
  component nrzi_decoder
    port (
    clk_i  : in std_logic;
    data_i : in std_logic;
    data_o : out std_logic;
    rst_i  : in std_logic
    );
  end component;
begin
  i1 : nrzi_decoder
  port map (
-- list connections between master ports and signals
  clk_i  => clk_i,
  data_i => data_i,
  data_o => data_o,
  rst_i  => rst_i
  );
  init : process
  begin
    rst_i  <= '0';
    clk_i  <= '0';
    data_i <= '0';
    wait for 100 ns;

    data_i <= '0';
    clk_i  <= '1';
    wait for 100 ns;
    clk_i  <= '0';
    wait for 100 ns;

    data_i <= '1';
    clk_i  <= '1';
    wait for 100 ns;
    clk_i  <= '0';
    wait for 100 ns;

    data_i <= '1';
    clk_i  <= '1';
    wait for 100 ns;
    clk_i  <= '0';
    wait for 100 ns;

    data_i <= '0';
    clk_i  <= '1';
    wait for 100 ns;
    clk_i  <= '0';
    wait for 100 ns;

    data_i <= '0';
    clk_i  <= '1';
    wait for 100 ns;
    clk_i <= '0';
    wait for 100 ns;

    clk_i <= '1';
    wait for 100 ns;
    clk_i <= '0';
    wait for 100 ns;

    clk_i <= '1';
    wait for 100 ns;
    clk_i <= '0';
    wait for 100 ns;

    wait;
  end process init;
  always : process
  begin

    wait;
  end process always;
end arch;
