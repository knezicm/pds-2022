library ieee;
use ieee.std_logic_1164.all;

entity not_gate is
port 
	(
		a : in std_logic;
		b : out std_logic
		
		);
end not_gate;

architecture beh_arch of not_gate is 
begin
		b <= not a;
end beh_arch;
		