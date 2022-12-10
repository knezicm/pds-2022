-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: preamble_generator_tb
--
-- description:
--
--   This file implements testbench for preamble generator
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
--! @file
--! @brief Preamble generator testbench
-----------------------------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for preamble generator testbench
entity preamble_generator_tb is
end preamble_generator_tb;

--! @brief Architecture definition of the preamble generator testbench
--! @details Generating 30 cycles of clock signal and for certain moments of the simulation seting start_i to '1'.
architecture arch of preamble_generator_tb is
  component preamble_generator
    port(
      clk_i   : in  std_logic;
      rst_i   : in  std_logic;
      start_i : in  std_logic;
      data_o  : out std_logic
    );
  end component;

  constant c_T : time := 20 ns;

  signal clk_i, rst_i, start_i, data_o, data_o_pom : std_logic;

  constant c_NUM_OF_CLOCKS : integer := 30;
  signal i, count : integer := 0; --! loop variable
begin

  --! uut instantiation
  uut : preamble_generator port map (
    clk_i   => clk_i,
    rst_i   => rst_i,
    start_i => start_i,
    data_o  => data_o
  );

  --! stimulus generator for reset
  rst_i <= '1', '0' after c_T/2;

  -- ! stimulus for continous clock
  process
  begin
    clk_i <= '0';
    wait for c_T/2;
    clk_i <= '1';
    wait for c_T/2;

    if i = 0 or i = 16 then
      start_i <= '1';
    else
      start_i <= '0';
    end if;

    if i = c_NUM_OF_CLOCKS then
      wait;
    else
      i <= i + 1;
    end if;
  end process;

  clk_process : process (clk_i)
  begin
    if rising_edge(clk_i) and (rst_i /= '1') then -- avoid reset
      if start_i = '1' then
        count <= 1;
        data_o_pom <= '1';
      end if;
      if count > 0 and count < 9 then
        if data_o /= data_o_pom then
          assert false report "incorrect value! Expected: " &
            std_logic'image(data_o_pom) & ", but got: " &
            std_logic'image(data_o) severity error;
        end if;
        count <= count + 1;
        data_o_pom <= not data_o_pom;
      end if;
    end if;
  end process clk_process;
end arch;
