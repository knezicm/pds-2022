-----------------------------------------------------------------------------
-- faculty of electrical engineering
-- pds 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     leading_zero_counter_unit_tb
--
-- description:
--
--   this file implements testbench for 16-bit leading zero counter
--
-----------------------------------------------------------------------------
-- copyright (c) 2022 faculty of electrical engineering
-----------------------------------------------------------------------------
-- the mit license
-----------------------------------------------------------------------------
-- copyright 2022 faculty of electrical engineering
--
-- permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "software"),
-- to deal in the software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the software, and to permit persons to whom
-- the software is furnished to do so, subject to the following conditions:
--
-- the above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the software.
--
-- the software is provided "as is", without warranty of any kind, express or
-- implied, including but not limited to the warranties of merchantability,
-- fitness for a particular purpose and noninfringement. in no event shall
-- the authors or copyright holders be liable for any claim, damages or other
-- liability, whether in an action of contract, tort or otherwise,
-- arising from, out of or in connection with the software or the use or
-- other dealings in the software
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity leading_zero_counter_unit_tb is
end leading_zero_counter_unit_tb;
architecture arch of leading_zero_counter_unit_tb is
  signal input_data_i  : std_logic_vector(15 downto 0);
  signal output_data_o : std_logic_vector(4 downto 0);
  component leading_zero_counter_unit
    port (
    input_data_i  : in std_logic_vector(15 downto 0);
    output_data_o : out std_logic_vector(4 downto 0)
    );
  end component;
begin
  i1 : leading_zero_counter_unit
  port map (
-- list connections between master ports and signals
  input_data_i  => input_data_i,
  output_data_o => output_data_o
  );
  init : process
-- variable declarations
  begin
-- code that executes only once
    wait;
  end process init;
  always : process
-- optional sensitivity list
-- (        )
-- variable declarations
  begin
    for i in 0 to 65536 loop
      input_data_i <= std_logic_vector(to_unsigned(i,16));
      wait for 100 ns;
      if output_data_o(4) = '1' then
        if input_data_i /= "0000000000000000" then
          assert false report "error for all zero" severity error;
        end if;
      end if;
      if output_data_o = "00000" then
        if input_data_i(15) /= '1' then
          assert false report "error for 0 zeros" severity error;
        end if;
      elsif output_data_o = "00001" then
        if input_data_i(14) /= '1' then
          assert false report "error for 1 zeros" severity error;
        end if;
      elsif output_data_o = "00010" then
        if input_data_i(13) /= '1' then
          assert false report "error for 2 zeros" severity error;
        end if;
      elsif output_data_o = "00011" then
        if input_data_i(12) /= '1' then
          assert false report "error for 3 zeros" severity error;
        end if;
      elsif output_data_o = "00100" then
        if input_data_i(11) /= '1' then
          assert false report "error for 4 zeros" severity error;
        end if;
      elsif output_data_o = "00101" then
        if input_data_i(10) /= '1' then
          assert false report "error for 5 zeros" severity error;
        end if;
      elsif output_data_o = "00110" then
        if input_data_i(9) /= '1' then
          assert false report "error for 6 zeros" severity error;
        end if;
      elsif output_data_o = "00111" then
        if input_data_i(8) /= '1' then
          assert false report "error for 7 zeros" severity error;
        end if;
      elsif output_data_o = "01000" then
        if input_data_i(7) /= '1' then
          assert false report "error for 8 zeros" severity error;
        end if;
      elsif output_data_o = "01001" then
        if input_data_i(6) /= '1' then
          assert false report "error for 9 zeros" severity error;
        end if;
      elsif output_data_o = "01010" then
        if input_data_i(5) /= '1' then
          assert false report "error for 10 zeros" severity error;
        end if;
      elsif output_data_o = "01011" then
        if input_data_i(4) /= '1' then
          assert false report "error for 11 zeros" severity error;
        end if;
      elsif output_data_o = "01100" then
        if input_data_i(3) /= '1' then
          assert false report "error for 12 zeros" severity error;
        end if;
      elsif output_data_o = "01101" then
        if input_data_i(2) /= '1' then
          assert false report "error for 13 zeros" severity error;
        end if;
      elsif output_data_o = "01110" then
        if input_data_i(1) /= '1' then
          assert false report "error for 14 zeros" severity error;
        end if;
      elsif output_data_o = "01111" then
        if input_data_i(0) /= '1' then
          assert false report "error for 15 zeros" severity error;
        end if;
      end if;
    end loop;
    wait;
  end process always;
end arch;
