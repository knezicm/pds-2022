-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:    MULTI_FUNCTION_ARITMETIC_UNIT
--
-- description:
--
--   This file describe circuit that can do following operation: +, -, +1, -1 .
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

entity multi_function_aritmetic_unit is
  port (
         A_i    : in  std_logic_vector(15 downto 0);
         B_i    : in  std_logic_vector(15 downto 0);
         CTRL_i : in  std_logic_vector(1 downto 0);
         RES_o  : out std_logic_vector(15 downto 0));

end multi_function_aritmetic_unit;


architecture arch_version_one of multi_function_aritmetic_unit is
  signal tmp1, tmp2, tmp3, tmp4 : std_logic_vector(15 downto 0);

  component adder

    port (
      a_i, b_i : in std_logic_vector(15 downto 0);
      c_o      : out std_logic_vector(15 downto 0));

  end component;

  component sub

    port (
      a_i, b_i	: in std_logic_vector(15 downto 0);
       c_o      : out std_logic_vector(15 downto 0));

  end component;


  component dec

    port (
      a_i       : in  std_logic_vector(15 downto 0);
      c_o       : out std_logic_vector(15 downto 0));

  end component;



  component inc
    port (
      a_i       : in  std_logic_vector(15 downto 0);
      c_o       : out std_logic_vector(15 downto 0));

  end component;







begin

  u1 : adder
    port map( 
      a_i(0)  => A_i(0),
      a_i(1)  => A_i(1),
      a_i(2)  => A_i(2),
      a_i(3)  => A_i(3),
      a_i(4)  => A_i(4),
      a_i(5)  => A_i(5),
      a_i(6)  => A_i(6),
      a_i(7)  => A_i(7),
      a_i(8)  => A_i(8),
      a_i(9)  => A_i(9),
      a_i(10) => A_i(10),
      a_i(11) => A_i(11),
      a_i(12) => A_i(12),
      a_i(13) => A_i(13),
      a_i(14) => A_i(14),
      a_i(15) => A_i(15),
      b_i(0)  => B_i(0),
      b_i(1)  => B_i(1),
      b_i(2)  => B_i(2),
      b_i(3)  => B_i(3),
      b_i(4)  => B_i(4),
      b_i(5)  => B_i(5),
      b_i(6)  => B_i(6),
      b_i(7)  => B_i(7),
      b_i(8)  => B_i(8), 
      b_i(9)  => B_i(9), 
      b_i(10) => B_i(10),
      b_i(11) => B_i(11),
      b_i(12) => B_i(12),
      b_i(13) => B_i(13),
      b_i(14) => B_i(14),
      b_i(15) => B_i(15),
      c_o(0)  => tmp1(0), 
      c_o(1)  => tmp1(1),
      c_o(2)  => tmp1(2),
      c_o(3)  => tmp1(3),
      c_o(4)  => tmp1(4),
      c_o(5)  => tmp1(5),
      c_o(6)  => tmp1(6),
      c_o(7)  => tmp1(7), 
      c_o(8)  => tmp1(8),
      c_o(9)  => tmp1(9),
      c_o(10) => tmp1(10),
      c_o(11) => tmp1(11),
      c_o(12) => tmp1(12),
      c_o(13) => tmp1(13),
      c_o(14) => tmp1(14),
      c_o(15) => tmp1(15));

  u2 : sub
    port map( 
      a_i(0)  => A_i(0),
      a_i(1)  => A_i(1),
      a_i(2)  => A_i(2),
      a_i(3)  => A_i(3),
      a_i(4)  => A_i(4),
      a_i(5)  => A_i(5),
      a_i(6)  => A_i(6),
      a_i(7)  => A_i(7),
      a_i(8)  => A_i(8),
      a_i(9)  => A_i(9),
      a_i(10) => A_i(10),
      a_i(11) => A_i(11),
      a_i(12) => A_i(12),
      a_i(13) => A_i(13),
      a_i(14) => A_i(14),
      a_i(15) => A_i(15),
      b_i(0)  => B_i(0),
      b_i(1)  => B_i(1),
      b_i(2)  => B_i(2),
      b_i(3)  => B_i(3),
      b_i(4)  => B_i(4),
      b_i(5)  => B_i(5),
      b_i(6)  => B_i(6),
      b_i(7)  => B_i(7),
      b_i(8)  => B_i(8), 
      b_i(9)  => B_i(9), 
      b_i(10) => B_i(10),
      b_i(11) => B_i(11),
      b_i(12) => B_i(12),
      b_i(13) => B_i(13),
      b_i(14) => B_i(14),
      b_i(15) => B_i(15),
      c_o(0)  => tmp2(0), 
      c_o(1)  => tmp2(1),
      c_o(2)  => tmp2(2),
      c_o(3)  => tmp2(3),
      c_o(4)  => tmp2(4),
      c_o(5)  => tmp2(5),
      c_o(6)  => tmp2(6),
      c_o(7)  => tmp2(7), 
      c_o(8)  => tmp2(8),
      c_o(9)  => tmp2(9),
      c_o(10) => tmp2(10),
      c_o(11) => tmp2(11),
      c_o(12) => tmp2(12),
      c_o(13) => tmp2(13),
      c_o(14) => tmp2(14),
      c_o(15) => tmp2(15));

  u3 : inc
    port map( 
      a_i(0)  => A_i(0),
      a_i(1)  => A_i(1),
      a_i(2)  => A_i(2),
      a_i(3)  => A_i(3),
      a_i(4)  => A_i(4),
      a_i(5)  => A_i(5),
      a_i(6)  => A_i(6),
      a_i(7)  => A_i(7),
      a_i(8)  => A_i(8),
      a_i(9)  => A_i(9),
      a_i(10) => A_i(10),
      a_i(11) => A_i(11),
      a_i(12) => A_i(12),
      a_i(13) => A_i(13),
      a_i(14) => A_i(14),
      a_i(15) => A_i(15),
      c_o(0)  => tmp3(0), 
      c_o(1)  => tmp3(1),
      c_o(2)  => tmp3(2),
      c_o(3)  => tmp3(3),
      c_o(4)  => tmp3(4),
      c_o(5)  => tmp3(5),
      c_o(6)  => tmp3(6),
      c_o(7)  => tmp3(7), 
      c_o(8)  => tmp3(8),
      c_o(9)  => tmp3(9),
      c_o(10) => tmp3(10),
      c_o(11) => tmp3(11),
      c_o(12) => tmp3(12),
      c_o(13) => tmp3(13),
      c_o(14) => tmp3(14),
      c_o(15) => tmp3(15));

  u4 : dec
    port map( 
      a_i(0)  => A_i(0),
      a_i(1)  => A_i(1),
      a_i(2)  => A_i(2),
      a_i(3)  => A_i(3),
      a_i(4)  => A_i(4),
      a_i(5)  => A_i(5),
      a_i(6)  => A_i(6),
      a_i(7)  => A_i(7),
      a_i(8)  => A_i(8),
      a_i(9)  => A_i(9),
      a_i(10) => A_i(10),
      a_i(11) => A_i(11),
      a_i(12) => A_i(12),
      a_i(13) => A_i(13),
      a_i(14) => A_i(14),
      a_i(15) => A_i(15),
      c_o(0)  => tmp4(0), 
      c_o(1)  => tmp4(1),
      c_o(2)  => tmp4(2),
      c_o(3)  => tmp4(3),
      c_o(4)  => tmp4(4),
      c_o(5)  => tmp4(5),
      c_o(6)  => tmp4(6),
      c_o(7)  => tmp4(7), 
      c_o(8)  => tmp4(8),
      c_o(9)  => tmp4(9),
      c_o(10) => tmp4(10),
      c_o(11) => tmp4(11),
      c_o(12) => tmp4(12),
      c_o(13) => tmp4(13),
      c_o(14) => tmp4(14),
      c_o(15) => tmp4(15));

  multipr : process(A_i, B_i, CTRL_i, tmp1, tmp2, tmp3, tmp4) is
  begin

    case CTRL_i is
      when "00"   =>   RES_o <= tmp1;
      when "01"   =>   RES_o <= tmp2;
      when "10"   =>   RES_o <= tmp3;
      when "11"   =>   RES_o <= tmp4;
      when others =>   RES_o <= "0000000000000000";
    end case;

  end process multipr;


end arch_version_one;


architecture arch_version_two of multi_function_aritmetic_unit is

  component sub1

    port (
      a_i, b_i	: in  std_logic_vector (15 downto 0);
      c_i       : in std_logic_vector(1 downto 0);
      y_o	: out std_logic_vector (15 downto 0));

  end component;

begin

  u : sub1
    port map  (
      a_i(0)  => A_i(0),
      a_i(1)  => A_i(1),
      a_i(2)  => A_i(2),
      a_i(3)  => A_i(3),
      a_i(4)  => A_i(4),
      a_i(5)  => A_i(5),
      a_i(6)  => A_i(6),
      a_i(7)  => A_i(7),
      a_i(8)  => A_i(8),
      a_i(9)  => A_i(9),
      a_i(10) => A_i(10),
      a_i(11) => A_i(11),
      a_i(12) => A_i(12),
      a_i(13) => A_i(13),
      a_i(14) => A_i(14),
      a_i(15) => A_i(15),
      b_i(0)  => B_i(0),
      b_i(1)  => B_i(1),
      b_i(2)  => B_i(2),
      b_i(3)  => B_i(3),
      b_i(4)  => B_i(4),
      b_i(5)  => B_i(5),
      b_i(6)  => B_i(6),
      b_i(7)  => B_i(7),
      b_i(8)  => B_i(8),
      b_i(9)  => B_i(9),
      b_i(10) => B_i(10),
      b_i(11) => B_i(11),
      b_i(12) => B_i(12),
      b_i(13) => B_i(13),
      b_i(14) => B_i(14),
      b_i(15) => B_i(15),
      c_i(0)  => CTRL_i(0),
      c_i(1)  => CTRL_i(1),
      y_o(0)  => RES_o(0), 
      y_o(1)  => RES_o(1), 
      y_o(2)  => RES_o(2), 
      y_o(3)  => RES_o(3),
      y_o(4)  => RES_o(4), 
      y_o(5)  => RES_o(5),
      y_o(6)  => RES_o(6), 
      y_o(7)  => RES_o(7),
      y_o(8)  => RES_o(8),
      y_o(9)  => RES_o(9),
      y_o(10) => RES_o(10),
      y_o(11) => RES_o(11),
      y_o(12) => RES_o(12), 
      y_o(13) => RES_o(13),
      y_o(14) => RES_o(14),
      y_o(15) => RES_o(15));


end arch_version_two;





configuration multi_function_aritmetic_unit_cfg of multi_function_aritmetic_unit is
  for arch_version_one
  end for;
end multi_function_aritmetic_unit_cfg;
