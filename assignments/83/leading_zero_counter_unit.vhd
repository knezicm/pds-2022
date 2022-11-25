-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     leading_zero_counter_unit
--
-- description:
--
--   This file implements 16-bit Leading Zero Counter
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


entity leading_zero_counter_unit is
  port (
  INPUT_DATA_i  : in  std_logic_vector(15 downto 0);
  OUTPUT_DATA_o : out std_logic_vector(4 downto 0)
 );
end entity leading_zero_counter_unit;


architecture arch of leading_zero_counter_unit is


  component four_bit_lzc
    port (
    X_i  : in  std_logic_vector(3 downto 0);
    Q_o  : out std_logic_vector(1 downto 0);
    A_o  : out std_logic := '0'
    );
  end component;



  component four_bit_lze
    port (
    X_i : in std_logic_vector(3 downto 0);
    Q_o : out std_logic_vector(1 downto 0);
    A_o : out std_logic := '0'
    );
  end component;

  signal lower_bits         :     std_logic_vector(7 downto 0);
  signal nibble_zero_bits   :     std_logic_vector(3 downto 0);
  signal upper_bits         :     std_logic_vector(1 downto 0);
  signal all_zero           :     std_logic;

begin
  lze : four_bit_lze port map(X_i => nibble_zero_bits,
                              Q_o => upper_bits,
                              A_o => all_zero);

  g1 :
  for I in 0 to 3
  generate
    lzc : four_bit_lzc port map(
    X_i => INPUT_DATA_i((4*I)+3 downto 4*I),Q_o => lower_bits((2*I)+1 downto (2*I)),A_o => nibble_zero_bits(I));
  end generate g1;

  OUTPUT_DATA_o(4) <= all_zero;

  OUTPUT_DATA_o(3 downto 2) <= upper_bits(1 downto 0);
  OUTPUT_DATA_o(1 downto 0) <= lower_bits(7 downto 6) when upper_bits = "00" else
  lower_bits(5 downto 4) when upper_bits = "01" else
  lower_bits(3 downto 2) when upper_bits = "10" else
  lower_bits(1 downto 0);

end arch;
