library ieee;

use ieee.std_logic_1164.all;

entity test is

	port
	(
		-- Input ports
		a,b	: in std_logic;

		-- Output port
		y	: out std_logic
	);
end test;

architecture test_beh of test is

begin

	y <= a or b;

end test_beh;

