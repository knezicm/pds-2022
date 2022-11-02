library ieee;
use ieee.std_logic_1164.all;


entity test is
port (

	a  : in std_logic;
	b  : in std_logic;
	output : out std_logic
	);
end test;


architecture test_arch of test is
begin
	output <= a+b;
end test_arch;
