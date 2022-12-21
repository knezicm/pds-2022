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
use ieee.numeric_std.all;
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
  signal tstA_i : std_logic_vector(7 downto 0) := "10000100";
  signal tstLAR_i : std_logic_vector(1 downto 0) := (others => '0');
  signal tstAMT_i : std_logic_vector(2 downto 0) := (others => '0');
  signal tstY_o : std_logic_vector(7 downto 0);
  signal tmpA_i : std_logic_vector(7 downto 0) := "10000100";

begin

  -- uut instantation
  uut : three_mode_barrel_shifter
     port map (
      A_i   => tstA_i,
      LAR_i => tstLAR_i,
      AMT_i => tstAMT_i,
      Y_o   => tstY_o);
  -- variable declarations
  process
    variable shifter : std_logic_vector(7 downto 0);
    variable error_status : boolean;
  begin
  -- rotation
    tstLAR_i <= "00";
    tmpA_i <= "10000100";
    tstAMT_i <= "000";
    wait for 20 ns;
    for i in 0 to 6 loop
      shifter := tmpA_i;
      for j in 0 to i loop
        tmpA_i(0) <= shifter(1);
        tmpA_i(1) <= shifter(2);
        tmpA_i(2) <= shifter(3);
        tmpA_i(3) <= shifter(4);
        tmpA_i(4) <= shifter(5);
        tmpA_i(5) <= shifter(6);
        tmpA_i(6) <= shifter(7);
        tmpA_i(7) <= shifter(0);
      end loop;
      tstAMT_i <= std_logic_vector(unsigned(tstAMT_i) + 1);
      if tstY_o = tmpA_i then
        error_status := false;
      else
        error_status := true;
      end if;
      assert not error_status
            report "Rotation test failed!"
            severity note;
      wait for 20 ns;
    end loop;
  -- logical shift
    wait for 20 ns;
    tstLAR_i <= "01";
    tmpA_i <= "10000100";
    tstAMT_i <= "000";
    wait for 20 ns;
    for i in 0 to 6 loop
      tmpA_i  <= std_logic_vector(shift_right(signed(tstA_i),to_integer(unsigned(tstAMT_i))+1));
      tstAMT_i <= std_logic_vector( unsigned(tstAMT_i) + 1 );
      if tstY_o = tmpA_i then
        error_status := false;
      else
        error_status := true;
      end if;
      assert not error_status
            report "Logical shift test failed!"
            severity note;
      wait for 20 ns;
    end loop;
  -- arithmetical shift
    wait for 20 ns;
    tstLAR_i <= "10";
    tmpA_i <= "10000100";
    tstAMT_i <= "000";
    wait for 20 ns;
    for i in 0 to 6 loop
      tmpA_i  <= std_logic_vector(shift_right(unsigned(tstA_i),to_integer(unsigned(tstAMT_i))+1));
      tstAMT_i <= std_logic_vector(unsigned(tstAMT_i) + 1);
      if tstY_o = tmpA_i then
        error_status := false;
      else
        error_status := true;
      end if;
      assert not error_status
            report "Arithmetical shift test failed!"
            severity note;
      wait for 20 ns;
    end loop;
  end process;

end arch;
