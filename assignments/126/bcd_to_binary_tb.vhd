-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     bcd_to_binary_tb
--
-- description:
--
--   This file implements testbench for bcd to binary converter.
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

entity bcd_to_binary_tb is
end bcd_to_binary_tb;


architecture arch of bcd_to_binary_tb is
  component bcd_to_binary
    port(
    clk_i    : in  std_logic;
    rst_i    : in  std_logic;
    start_i  : in  std_logic;
    bcd1_i   : in  std_logic_vector(3 downto 0);
    bcd2_i   : in  std_logic_vector(3 downto 0);
    binary_o : out std_logic_vector(6 downto 0);
    ready_o  : out std_logic);
  end component;

  signal clk_i_test    : std_logic;
  signal rst_i_test    : std_logic;
  signal ready_o_test  : std_logic;
  signal start_i_test  : std_logic := '0';
  signal bcd1_i_test   : std_logic_vector(3 downto 0) := "0000";
  signal bcd2_i_test   : std_logic_vector(3 downto 0) := "0000";
  signal binary_o_test : std_logic_vector(6 downto 0);
  signal i : integer := 0;
  signal j : integer := 0;

  constant c_NUM_OF_CLK : integer := 100;
  constant c_CONV_TIME  : integer := 15;

begin
  rst_i_test <= '1', '0' after 10 ns;

  uut : bcd_to_binary port map(
    clk_i    => clk_i_test,
    rst_i    => rst_i_test,
    start_i  => start_i_test,
    bcd1_i   => bcd1_i_test,
    bcd2_i   => bcd2_i_test,
    ready_o  => ready_o_test,
    binary_o => binary_o_test
    );

  clk : process
  begin
    clk_i_test <= '0';
    wait for 10 ns;
    clk_i_test <= '1';
    wait for 10 ns;

    if i = c_NUM_OF_CLK then
      wait;
    end if;
  end process clk;


  input_assigning : process(clk_i_test)
  begin
    if rising_edge(clk_i_test)  then
      if j < c_CONV_TIME then
        j <= j + 1;
        start_i_test <= '0';
      else
        i <= i + 1;
        j <= 0;
        start_i_test <= '1';
        if to_integer(unsigned(bcd2_i_test)) = 9 then
          bcd1_i_test <= std_logic_vector(unsigned(bcd1_i_test) + 1);
          bcd2_i_test <= "0000";
        else
          bcd2_i_test <= std_logic_vector(unsigned(bcd2_i_test) + 1);
        end if;
      end if;
    end if;
  end process input_assigning;


  output_checks : process(ready_o_test)
  begin
    if rising_edge(ready_o_test) then
      assert to_integer(unsigned(binary_o_test)) = to_integer(unsigned(bcd1_i_test)*10) + to_integer(unsigned      (bcd2_i_test))
      report "Input bcd vector= "&integer'image(to_integer(unsigned(bcd1_i_test)*10 + unsigned(bcd2_i_test)))&
      " Output vector= "&integer'image(to_integer(unsigned(binary_o_test)))
      severity error;
    end if;
  end process output_checks;
end arch;
