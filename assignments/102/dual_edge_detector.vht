-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     dual_edge_detector_tb
--
-- description:
--
--   This file implements a testbench for dual-edge detector circuit.
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
use ieee.numeric_std.all;                                              
use ieee.std_logic_1164.all;                                

entity dual_edge_detector_vhd_tst is
end dual_edge_detector_vhd_tst;

architecture dual_edge_detector_arch of dual_edge_detector_vhd_tst is
                                                
-- signals  
  signal p_test      : std_logic;
  signal p_comp      : std_logic;
  signal indeks		: integer := 0;
  signal clk_test    : std_logic;
  signal rst_test    : std_logic;
  signal strobe_test : std_logic;                                                 

component dual_edge_detector is
    port (
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;
      strobe_i : in  std_logic;
      p_o      : out std_logic
    );
  end component;
  
   type mealy_test_vector is record
    strobe_v : std_logic;
    p_v      : std_logic;
  end record mealy_test_vector;
  
  type mealy_test_vector_array is array (natural range <>) of mealy_test_vector;

  constant C_MEALY_TEST_VECTORS : mealy_test_vector_array := (
    ('0', '0'),
    ('1', '1'),
    ('1', '0'),
    ('0', '0')
  );
  
 begin
 
 uut : dual_edge_detector
    port map(
      clk_i     =>  clk_test,
      rst_i     =>  rst_test,
      strobe_i  =>  strobe_test,
      p_o       =>  p_test
    );
	 
  -- clk initialization
  
  process
  begin

    clk_test <= '0';
    wait for 10 ns;
    clk_test <= '1';
    wait for 10 ns;

    if indeks = C_MEALY_TEST_VECTORS'length then
      wait;
    end if;
  end process;
  
    -- rst initialization
	 
  process
  begin
    rst_test <= '1';
    wait for 10 ns;
    rst_test <= '0';
    wait;
  end process;

  -- value assgination
  process
  begin

    strobe_test <= C_MEALY_TEST_VECTORS(indeks).strobe_v;
    p_comp   <= C_MEALY_TEST_VECTORS(indeks).p_v;
    wait for 10 ns;

    if indeks < C_MEALY_TEST_VECTORS'length then
      indeks <= indeks + 1;
    else
      wait;
    end if;
  end process;


  -- output compare
  process
    variable error_status : boolean;
  begin

    wait until clk_test'event;
    wait for 5 ns;

    if p_test = p_comp then
      error_status := false;
    else
      error_status := true;
    end if;

    assert not error_status
      report "Test failed!"
      severity note;

    if indeks = C_MEALY_TEST_VECTORS'length then
      report "Test completed.";
    end if;
  end process;
end dual_edge_detector_arch;