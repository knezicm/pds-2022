library ieee;
use ieee.std_logic_1164.all;

entity nand2 is
port (
	i_A : in std_logic;
	i_B : in std_logic;
	o_Y : out std_logic
	
);
end nand2;

architecture behav of nand2 is
begin
   o_Y <= i_A nand i_B;
end behav;
