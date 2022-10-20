library ieee;
use ieee.std_logic_1164.all;

entity not1 is
	port
	(
		i1	: in  std_logic;
		o1	: out std_logic
	);
end not1;

architecture beh_arch of not1 is
begin
	o1 <= not i1;
end beh_arch;
