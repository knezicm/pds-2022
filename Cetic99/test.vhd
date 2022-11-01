library ieee;

use ieee.std_logic_1164.all;

entity popusi is

	port
	(
		-- Input ports
		sw1	: in  std_logic;
		led1	: out  std_logic
	);
end popusi;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture pup of popusi is

	-- Declarations (optional)

begin

	led1<= sw1;
end pup;

