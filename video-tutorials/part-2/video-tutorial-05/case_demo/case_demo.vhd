library ieee;
use ieee.std_logic_1164.all;

entity case_demo is
	port (
		a : in std_logic_vector(2 downto 0);
		hi, mid, lo : out std_logic
	);
end case_demo;

architecture beh_arch of case_demo is
begin
	process(a)
	begin
		hi <= '0';
		mid <= '0';
		lo <= '0';
		case a is
			when "100"|"101"|"110"|"111" =>
				hi <= '1';
			when "010"|"011" =>
				mid <= '1';
			when others =>
				lo <= '1';
		end case;
	end process;
end beh_arch;