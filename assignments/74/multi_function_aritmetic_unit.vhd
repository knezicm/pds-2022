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


architecture arch of multi_function_aritmetic_unit is
  signal tmp1, tmp2, tmp3, tmp4 : std_logic_vector(15 downto 0);

  component adder
    port (
      a_i : in  std_logic_vector(15 downto 0);
      b_i : in  std_logic_vector(15 downto 0);
      c_o : out std_logic_vector(15 downto 0));
  end component;

  component sub
    port (
      a_i : in  std_logic_vector(15 downto 0);
      b_i : in  std_logic_vector(15 downto 0);
      c_o : out std_logic_vector(15 downto 0));
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
    port map (
      a_i => A_i,
      b_i => B_i,
      c_o => tmp1);

  u2 : sub
    port map(
      a_i => A_i,
      b_i => B_i,
      c_o => tmp2);

  u3 : inc
    port map(
      a_i => A_i,
      c_o => tmp3);

  u4 : dec
    port map (
      a_i => A_i,
      c_o => tmp4);

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


end arch;

-----------------------------------------------------------------------------
-- architecture arch_version_two of multi_function_aritmetic_unit is
--
--  component sub1
--    port (
--      a_i : in  std_logic_vector(15 downto 0);
--      b_i : in  std_logic_vector(15 downto 0);
--      c_i : in  std_logic_vector(15 downto 0);
--      y_o : out std_logic_vector(15 downto 0));
--  end component;
--
-- begin
--  u : sub1
--
--    port map  (
--      a_i => A_i,
--      b_i => B_i,
--      c_i => CTRL_i,
--      y_o => RES_o);
-- end arch_version_two;
--
--
--
--
--
-- configuration multi_function_aritmetic_unit_cfg of multi_function_aritmetic_unit is
--  for arch_version_one
--  end for;
-- end multi_function_aritmetic_unit_cfg;
-----------------------------------------------------------------------------
