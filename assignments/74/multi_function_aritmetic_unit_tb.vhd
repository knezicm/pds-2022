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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity multi_function_aritmetic_unit_tb is

end multi_function_aritmetic_unit_tb;



architecture arch of multi_function_aritmetic_unit_tb is

  component multi_function_aritmetic_unit


    port (
     A_i    : in  std_logic_vector(15 downto 0);
     B_i    : in  std_logic_vector(15 downto 0);
     CTRL_i : in  std_logic_vector(1 downto 0);
     RES_o  : out std_logic_vector(15 downto 0));

  end component;

  signal test1_in, test2_in, test_out : std_logic_vector(15 downto 0);
  signal ctrl_in                      : std_logic_vector(1 downto 0);

begin

  ut : multi_function_aritmetic_unit
    port map (
      A_i    => test1_in,
      B_i    => test2_in,
      CTRL_i => ctrl_in,
      RES_o  => test_out);



  tb : process

  begin

    test1_in <= "0000000000000000";
    test2_in <= "0000000000000000";
    ctrl_in  <= "00";

    for k in 0 to 3 loop
      wait for 10 ns;
      for i in 0 to 15 loop
        for j in 0 to 15 loop
          wait for 10 ns;


          if(ctrl_in = "00") then
            assert to_integer(unsigned(test_out)) = to_integer(unsigned(test1_in)) +to_integer(unsigned(test2_in))
            report " Error!"
            severity error;

          elsif (ctrl_in = "01") then
            if(to_integer(unsigned(test1_in)) > to_integer(unsigned(test2_in))) then
              assert to_integer(unsigned(test_out)) = to_integer(unsigned(test1_in)) -to_integer(unsigned(test2_in))
              report " Error!"
              severity error;
            end if;

          elsif (ctrl_in = "10") then
            assert to_integer(unsigned(test_out)) = to_integer(unsigned(test1_in)) + 1
            report
            " Error!" severity error;
          else
            if(to_integer(unsigned(test1_in)) > 1) then
              assert to_integer(unsigned(test_out)) = to_integer(unsigned(test1_in)) -1
              report " Error!"
              severity error;
            end if;
          end if;
          test1_in <= std_logic_vector(unsigned(test1_in) + 1);

        end loop;

        test2_in <= std_logic_vector(unsigned(test1_in) + 1);
        test1_in <= "0000000000000000";
      end loop;

      test1_in <= "0000000000000000";
      test2_in <= "0000000000000000";
      ctrl_in <= std_logic_vector(unsigned(ctrl_in) + 1);

    end loop;

    wait;

  end process;
end arch;
