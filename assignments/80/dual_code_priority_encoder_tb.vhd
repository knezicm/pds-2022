-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     dual_code_priority_encoder_tb
--
-- description:
--
--   This file implements a testbench file for dual-code priority encoder logic.
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

use ieee.std_logic_arith.all;

entity dual_code_priority_encoder_tb is
end dual_code_priority_encoder_tb;

architecture tb_arch of dual_code_priority_encoder_tb is
  component dual_code_priority_encoder
    port (
      REQ_i    : in std_logic_vector(7 downto 0);
      CODE1_o  : out std_logic_vector(2 downto 0);
      CODE2_o  : out std_logic_vector(2 downto 0);
      VALID1_o : out std_logic;
      VALID2_o : out std_logic
     );
  end component;
  signal REQ_test             : std_logic_vector(7 downto 0);
  signal CODE1_test, CODE2_test  : std_logic_vector(2 downto 0);
  signal VALID1_test,VALID2_test : std_logic;

begin

     -- uut instantiation
  uut : dual_code_priority_encoder port map (
    REQ_i => REQ_test,
    CODE1_o => CODE1_test,
    CODE2_o => CODE2_test,
    VALID1_o => VALID1_test,
    VALID2_o => VALID2_test
  );

  -- verifier
  process
    variable error_status : boolean;
  begin
       -- initialize value
    REQ_test <= (others => '0');
    for i in 0 to 255 loop
      REQ_test <= std_logic_vector(to_unsigned(i,8));
      wait for 1 ns;
      if(REQ_test(7) = '1' and CODE1_test = "111") then
        if(REQ_test(6) = '1' and CODE2_test = "110") then
          error_status := false;
        elsif(REQ_test(5) = '1' and CODE2_test = "101") then
          error_status := false;
        elsif(REQ_test(4) = '1' and CODE2_test = "100") then
          error_status := false;
        elsif(REQ_test(3) = '1' and CODE2_test = "011") then
          error_status := false;
        elsif(REQ_test(2) = '1' and CODE2_test = "010") then
          error_status := false;
        elsif(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(6 downto 0) = "0000000" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(6) = '1' and CODE1_test = "110") then
        if(REQ_test(5) = '1' and CODE2_test = "101") then
          error_status := false;
        elsif(REQ_test(4) = '1' and CODE2_test = "100") then
          error_status := false;
        elsif(REQ_test(3) = '1' and CODE2_test = "011") then
          error_status := false;
        elsif(REQ_test(2) = '1' and CODE2_test = "010") then
          error_status := false;
        elsif(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(5 downto 0) = "000000" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(5) = '1' and CODE1_test = "101") then
        if(REQ_test(4) = '1' and CODE2_test = "100") then
          error_status := false;
        elsif(REQ_test(3) = '1' and CODE2_test = "011") then
          error_status := false;
        elsif(REQ_test(2) = '1' and CODE2_test = "010") then
          error_status := false;
        elsif(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(4 downto 0) = "00000" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(4) = '1' and CODE1_test = "100") then
        if(REQ_test(3) = '1' and CODE2_test = "011") then
          error_status := false;
        elsif(REQ_test(2) = '1' and CODE2_test = "010") then
          error_status := false;
        elsif(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(3 downto 0) = "0000" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(3) = '1' and CODE1_test = "011") then
        if(REQ_test(2) = '1' and CODE2_test = "010") then
          error_status := false;
        elsif(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(2 downto 0) = "000" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(2) = '1' and CODE1_test = "010") then
        if(REQ_test(1) = '1' and CODE2_test = "001") then
          error_status := false;
        elsif(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(1 downto 0) = "00" and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(1) = '1' and CODE1_test = "001") then
        if(REQ_test(0) = '1' and CODE2_test = "000") then
          error_status := false;
        elsif(REQ_test(0) = '0' and VALID2_test = '0') then
          error_status := false;
        else
          error_status := true;
        end if;
      elsif(REQ_test(0) = '1' and CODE1_test = "000" and VALID2_test = '0') then
        error_status := false;
      elsif(REQ_test = "00000000" and VALID1_test = '0') then
        error_status := false;
      else
        error_status := true;
      end if;

         -- report an error
      assert not error_status
                report "Test failed!"
             severity note;
      wait for 20 ns;
    end loop;
    report "Test completed.";
    wait;
  end process;
end tb_arch;
