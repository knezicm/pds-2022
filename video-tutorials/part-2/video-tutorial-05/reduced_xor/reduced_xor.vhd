library ieee;
use ieee.std_logic_1164.all;

entity reduced_xor is
	port(
		a : in std_logic_vector(3 downto 0);
		y : out std_logic
	);
end reduced_xor;

architecture demo_arch of reduced_xor is
	constant WIDTH : integer := 4;
	signal tmp : std_logic_vector(WIDTH-1 downto 0);
begin
	process(a, tmp)
	begin
		tmp(0) <= a(0);
		for i in 1 to (WIDTH-1) loop
			tmp(i) <= a(i) xor tmp(i-1);
		end loop;
	end process;
	y <= tmp(WIDTH-1);	
end demo_arch;