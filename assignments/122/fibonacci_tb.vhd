-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name: fibonacci_tb
--
-- description:
--
--   This file implements testbench for fibonacci sequence generator
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

entity fibonacci_tb is
end fibonacci_tb;
architecture arch of fibonacci_tb is
  -- constants
  -- signals
  constant c_T : time := 20 ns;

  signal clk_i   : std_logic;
  signal n_i     : std_logic_vector(5 downto 0);
  signal r_o     : std_logic_vector(42 downto 0);
  signal ready_o : std_logic;
  signal rst_i   : std_logic;
  signal start_i : std_logic;

  signal count             : std_logic_vector(5 downto 0)  := (others => '0');
  signal r_o_pom, a        : std_logic_vector(42 downto 0) := (others => '0');
  signal b                 : std_logic_vector(42 downto 0) := (others => '0');
  signal v_start2          : std_logic                     := '0';
  constant c_NUM_OF_CLOCKS : integer                       := 320;
  signal i                 : integer                       := 0; -- loop variable
  component fibonacci
    port (
      clk_i   : in  std_logic;
      n_i     : in  std_logic_vector(5 downto 0);
      r_o     : out std_logic_vector(42 downto 0);
      ready_o : out std_logic;
      rst_i   : in  std_logic;
      start_i : in  std_logic
    );
  end component;
begin
  i1 : fibonacci
  port map(
    -- list connections between master ports and signals
    clk_i   => clk_i,
    n_i     => n_i,
    r_o     => r_o,
    ready_o => ready_o,
    rst_i   => rst_i,
    start_i => start_i
  );

  -- stimulus generator for reset
  rst_i <= '1', '0' after c_T/2;

  -- stimulus for continous clock
  process
  begin
    clk_i <= '0';
    wait for c_T/2;
    clk_i <= '1';
    wait for c_T/2;

    if i = c_NUM_OF_CLOCKS then
      wait;
    else
      i <= i + 1;
    end if;
  end process;

  init : process
    -- variable declarations
  begin
    -- code that executes only once
    wait;
  end process init;
  always : process (clk_i)
    variable v_start1 : std_logic                     := '0';
    variable v_r_o    : std_logic_vector(42 downto 0) := (others => '0');
  begin
    n_i <= "111111";
    if rising_edge(clk_i) and (rst_i /= '1') then
      if i = 3 then
        start_i <= '1';
        v_start1 := '1';
        count <= (others => '0');
      else
        start_i <= '0';
      end if;
      if v_start1 = '1' and start_i = '0' then
        v_start1 := '0';
        v_start2 <= '1';
      end if;
      if v_start2 = '1' and start_i = '0' then
        count   <= "000001";
        r_o_pom <= (others  => '0');
        v_r_o := (others    => '0');
        a        <= (others => '0');
        b        <= (0      => '1', others => '0');
        v_start2 <= '0';
      end if;
      if count >= "000001" and count <= std_logic_vector(unsigned(n_i) + 1) then
        assert r_o = r_o_pom report "incorrect value! Expected: " &
        integer'image(to_integer(unsigned(r_o_pom))) & ", Actual: " &
        integer'image(to_integer(unsigned(r_o))) severity error;
        v_r_o := std_logic_vector(unsigned(a) + unsigned(b));
        r_o_pom <= a;
        a       <= b;
        b       <= v_r_o;
        count   <= std_logic_vector(unsigned(count) + 1);
      end if;
    end if;
  end process always;
end arch;
