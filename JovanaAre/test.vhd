-----------------------------------------------------------------------------
-- ETF Banja Luka Projektovanje digitalnih sistema
-- And gate
-- URL of the project
-----------------------------------------------------------------------------
--
-- unit name: test
--
-- description:
--
-- This unit implements and gate
--
-----------------------------------------------------------------------------
-- Copyright (c) 2022 ETF Banja Luka Projektovanje digitalnih sistema
-----------------------------------------------------------------------------
-- LICENSE NAME
-----------------------------------------------------------------------------
-- LICENSE NOTICE
--
--
--
--
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity test is
  port(
       a_i      : in  std_logic;  -- First input
       b_i      : in  std_logic;  -- Second input
       result_o : out std_logic); -- Output
end test;

architecture arch of test is
begin
  result_o <= a_i and b_i;
end arch;
