-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:   bcd_to_binary
--
-- description:
--
--   This file describe circuit that perform conversion from 8 bit BCD to 
--   7 bit BINARY
--   The main idea is to use following algorithm. First , initialise input
--   register bcd_reg with inputs 
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
--!@brief bcd_to_binary
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--!@brief bcd_to_binary entity (converter of input signal)
--!@details This entity represent converter of bcd input signal (2 x 4 bit signal) 
--!@details to binary(7 bit signal)
--!@details Input signals are clk_i (clock), rst_i (reset), start_i (start of conversion) and
--!@details input data signals bcd1_i, bcd2_i
--!@details On the output we have ready_o (status flag that represent end of conv) and binary_o
--!@details (converted input data)

entity bcd_to_binary is
  port (
    clk_i    : in std_logic;                    --!Clock input
	 rst_i    : in std_logic;                    --!Reset input
	 start_i  : in std_logic;                    --!Start of conv (input)
	 bcd1_i   : in std_logic_vector(3 downto 0); --!Input data (bcd1)
	 bcd2_i   : in std_logic_vector(3 downto 0); --!Input data (bcd2)
	 binary_o : out std_logic_vector(6 downto 0);--!Output of converter
	 ready_o  : out std_logic);                  --!Status flag(end of conv)

end bcd_to_binary;

--!@brief  Architecture description of bcd_to_binary
--!@details This architectur represent conversion of input data using RT methodology
--!@details Arch is using following  algorithm for conversion:
--!@details If start_i is '1' -> start of conversion 
--!@details Concetanate bcd1_i & bcd2_i to one vector and initialise
--!@details bcd_reg with them. Initialise output with '0000000'
--!@details 2.Shift bcd_reg LS bit to MS bit of binary_o
--!@details 3.If lower 4 bit of input data are greather than 4, then
--!@details substract 3 from them and do 2. point else just do 2. point.
--!@details Repeate 2 and 3 points 7-times
--!@details 4.Set ready_o to '1' (conversion finished)

architecture arch of bcd_to_binary is


  type bcd_type is (idle, load, shift, sub);

  signal state_reg      : bcd_type;
  signal state_next     : bcd_type;
  signal num_shift      : integer; 
  signal status_flag    : std_logic;
  signal out_reg        : std_logic_vector(6 downto 0);
  signal out_reg_next   : std_logic_vector(6 downto 0);
  signal bcd_reg        : std_logic_vector(7 downto 0);
  signal bcd_reg_next   : std_logic_vector(7 downto 0);
  signal num_shift_reg  : unsigned(3 downto 0);
  signal num_shift_next : unsigned(3 downto 0);
  signal n_tmp          : unsigned(3 downto 0);
  signal shift_res      : std_logic_vector(6 downto 0);
  signal shift_bcd      : std_logic_vector(7 downto 0);
  signal sub_bcd        : std_logic_vector(7 downto 0);
begin

-- CONTROL PATH
-- state register

  pr1 : process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif clk_i'event and clk_i = '1' then
      state_reg <= state_next;
    end if;
  end process pr1;

-- next_state logic
  pr2: process(state_reg, start_i, status_flag)
  begin
    case state_reg is
      when idle  =>
        if start_i = '1' then
          state_next <= load;
        else
          state_next <= idle;
        end if;
      when load  =>
        state_next   <= shift;
      when shift =>
        if status_flag = '1' then
          state_next <= idle;
        else
          state_next <= sub;
        end if;
      when sub   =>
        state_next   <= shift;
    end case;  
  end process pr2;
  
-- output logic

  ready_o <= '1' when state_reg = idle else '0';
  
-- DATA PATH
-- state reg
  pr4 : process(clk_i, rst_i)
  begin
    if rst_i = '1' then
	   out_reg       <= (others => '0');
		bcd_reg       <= (others => '0');
      num_shift_reg <= "0000";
    elsif clk_i'event and clk_i = '1' then
	   out_reg       <= out_reg_next;
		bcd_reg       <= bcd_reg_next;
      num_shift_reg <= num_shift_next;
    end if;
  end process pr4;
-- routing multiplexer
  pr5 : process(state_reg, out_reg, bcd_reg, num_shift_reg, bcd1_i, bcd2_i, n_tmp, sub_bcd, shift_res, shift_bcd)
  begin
    case state_reg is
	   when idle    =>
        out_reg_next   <= out_reg;
        bcd_reg_next   <= bcd_reg;
        num_shift_next <= num_shift_reg;
	   when load    =>
        out_reg_next   <= (others => '0');
        bcd_reg_next   <= bcd1_i & bcd2_i;
		  num_shift_next <= "0111";
		when shift  =>
        out_reg_next   <= shift_res;
        bcd_reg_next   <= bcd_reg;
        num_shift_next <= n_tmp;
      when sub    =>
        out_reg_next   <= out_reg;
        bcd_reg_next   <= sub_bcd;
        num_shift_next <= num_shift_reg;
    end case;
  end process pr5;

---- functional units
  shift_res           <= bcd_reg(0)&out_reg(6 downto 1);
  shift_bcd           <= '0' & bcd_reg(7 downto 1);
  n_tmp               <= num_shift_reg - 1;

  sub_bcd <= shift_bcd(7 downto 4)&std_logic_vector(unsigned(shift_bcd(3 downto 0)) - 3) when to_integer(unsigned(shift_bcd(3 downto 0))) >4 else shift_bcd;
-- status
  status_flag         <= '1' when num_shift_next = "0000" else '0';
-- output
  binary_o            <= out_reg; 

end arch;