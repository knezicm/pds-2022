-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     3-MODE BARREL SHIFTER TESTBENCH
--
-- description:
--
--   This file implements three-mode barrel shifter self-checking testbench.
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

entity three_mode_barrel_shifter_tb is
end three_mode_barrel_shifter_tb;

architecture arch of three_mode_barrel_shifter_tb is
  component three_mode_barrel_shifter
    port (
       A_i   : in  std_logic_vector(7 downto 0);
       LAR_i : in  std_logic_vector(1 downto 0);
       AMT_i : in  std_logic_vector(2 downto 0);
       Y_o   : out std_logic_vector(7 downto 0)
    );
  end component;
  signal tstA_i : std_logic_vector(7 downto 0);
  signal tstLAR_i : std_logic_vector(1 downto 0);
  signal tstAMT_i : std_logic_vector(2 downto 0);
  signal tstY_o : std_logic_vector(7 downto 0);
begin

  -- uut instantation
  uut : three_mode_barrel_shifter
     port map (
      A_i   => tstA_i,
      LAR_i => tstLAR_i,
      AMT_i => tstAMT_i,
      Y_o   => tstY_o);
  -- stimulus generator
  process
  begin
  -- logical shifting
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "000";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "001";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "010";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "011";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "100";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "101";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "110";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "00";
    tstAMT_i <= "111";
    wait for 20 ns;
   -- arithmetical shifting
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "000";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "001";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "010";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "011";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "100";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "101";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "110";
    wait for 20 ns;
    tstA_i <= "10000000";
    tstLAR_i <= "01";
    tstAMT_i <= "111";
    wait for 20 ns;
  end process;
  -- verifier
  process
    variable error_status : boolean;
  begin
    wait on tstA_i;
    wait for 10 ns;
    if ((tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "000" and tstY_o = "10000000") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "001" and tstY_o = "01000000") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "010" and tstY_o = "00100000") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "011" and tstY_o = "00010000") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "100" and tstY_o = "00001000") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "101" and tstY_o = "00000100") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "110" and tstY_o = "00000010") or
        (tstA_i = "10000000" and tstLAR_i = "00" and tstAMT_i = "111" and tstY_o = "00000001") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "000" and tstY_o = "10000000") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "001" and tstY_o = "11000000") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "010" and tstY_o = "11100000") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "011" and tstY_o = "11110000") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "100" and tstY_o = "11111000") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "101" and tstY_o = "11111100") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "110" and tstY_o = "11111110") or
        (tstA_i = "10000000" and tstLAR_i = "01" and tstAMT_i = "111" and tstY_o = "11111111"))
    then
      error_status := false;
    else
      error_status := true;
    end if;
    assert not error_status
        report "Test failed!"
        severity note;
  end process;
end arch;
