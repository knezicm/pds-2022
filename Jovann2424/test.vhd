library ieee;
use ieee.std_logic_1164.all;


entity test is
port (

	input  : in std_logic;
	output : out std_logic
	);
end test;

architecture test_arch of test is
	output <= input;
end test_arch;
