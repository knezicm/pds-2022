-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     MULTI_FUNCTION_ARITMETIC_UNIT_TB
--
-- description:
--
--   This file represent testbench  of MULTI_FUNCTION_ARITMETIC_UNIT circuit.
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
--!@file
--!@brief nrzi_encoder_tb   testbench
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--!@brief nrzi_encoder_tb is testbench of nrzi_encoder entity
--!@details Entity nzri_encoder_tb is simple testbench entity
entity nrzi_encoder_tb is
end nrzi_encoder_tb;

--!@brief  Architecture definitin of nrzi_encoder_tb entity
--!@details This architecture is used to test nrzi_encoder functionality

architecture arch of nrzi_encoder_tb is
  component nrzi_encoder is
    port(
           clk_i  : in  std_logic;
           rst_i  : in  std_logic;
           data_i : in  std_logic;
           data_o : out std_logic);
  end component;

  constant c_T           : time := 30 ns;
  signal test_in         : std_logic := '0';
  signal test_out        : std_logic;
  signal clk_in          : std_logic;
  signal rst_in          : std_logic;
  signal i               : integer   := 0;
  signal a               : std_logic_vector( 7 downto 0) := "01011101";
  signal k               : integer   := 0;
  signal x               : std_logic := '0';
  constant c_NUM_OF_CLOCKS : integer   := 8;


begin

  ut : nrzi_encoder
    port map (
      clk_i  => clk_in,
      rst_i  => rst_in,
      data_i => test_in,
      data_o => test_out);

  rst_in <= '1', '0' after 10 ns;

  tb1 : process
  begin
    test_in <= a(k);
    clk_in  <= '0';
    wait for 10 ns;
    clk_in  <= '1';
    wait for 5 ns;
    if rst_in = '0' then
      if test_in = '1' then
        assert test_out = not(x)
          report "Error not x=" & std_logic'image(x) & "test_out=" & std_logic'image(test_out)
          severity error;
      else
        assert test_out = x
        report "Error x"
        severity error;
      end if;
    end if;
    wait for 5 ns;

    if i = c_NUM_OF_CLOCKS then
      wait;
    else
      i <= i+1;
      k <= k+1;
    end if;

    x <= test_out;

  end process tb1;

end arch;
