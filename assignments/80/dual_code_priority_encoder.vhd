-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     dual_code_priority_encoder
--
-- description:
--
--   This file implements a dual-code priority encoder logic.
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


entity dual_code_priority_encoder is
  port (
   REQ_i    : in  std_logic_vector(7 downto 0);
   CODE1_o  : out std_logic_vector(2 downto 0);
   CODE2_o  : out std_logic_vector(2 downto 0);
   VALID1_o : out std_logic;
   VALID2_o : out std_logic
);
end dual_code_priority_encoder;

architecture arch of dual_code_priority_encoder is


  component priority_encoder_8_3 is
    port (
      REQ_i   : in std_logic_vector(7 downto 0);
     CODE_o  : out std_logic_vector(2 downto 0);
     VALID_o : out std_logic
);
  end component;

  component decoder_3_8 is
    port (
     CODE_i : in std_logic_vector(2 downto 0);
    REQ_o  : out std_logic_vector(7 downto 0)
);
  end component;

  signal encoder2_i : std_logic_vector(7 downto 0);
  signal decoder_o : std_logic_vector(7 downto 0);
  signal encoder1_o : std_logic_vector(2 downto 0);

begin

  U1_encoder : priority_encoder_8_3 port map(REQ_i => REQ_i,
                                            CODE_o => encoder1_o,
                                           VALID_o => VALID1_o);
  U2_decoder : decoder_3_8 port map(CODE_i => encoder1_o,
                                     REQ_o => decoder_o);

  encoder2_i(0) <= REQ_i(0) xor decoder_o(0);
  encoder2_i(1) <= REQ_i(1) xor decoder_o(1);
  encoder2_i(2) <= REQ_i(2) xor decoder_o(2);
  encoder2_i(3) <= REQ_i(3) xor decoder_o(3);
  encoder2_i(4) <= REQ_i(4) xor decoder_o(4);
  encoder2_i(5) <= REQ_i(5) xor decoder_o(5);
  encoder2_i(6) <= REQ_i(6) xor decoder_o(6);
  encoder2_i(7) <= REQ_i(7) xor decoder_o(7);

  CODE1_o <= encoder1_o;

  U3_encoder : priority_encoder_8_3 port map(REQ_i => encoder2_i,
                                            CODE_o => CODE2_o,
                                           VALID_o => VALID2_o);

end arch;
