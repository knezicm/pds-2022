library ieee;
use ieee.std_logic_1164.all;

entity process_demo is
	port
	(
		a	: in  std_logic_vector(7 downto 0);
		b	: in  std_logic_vector(7 downto 0);
--		gt, lt	: out std_logic;
		eq	: out std_logic
	);
end process_demo;

architecture beh_arch of process_demo is
begin
	process(a, b)
	begin
			if (a = b) then
				eq <= '1';
			else
				eq <= '0';
			end if;

--			gt <= '0';
--			eq <= '0';
--			lt <= '0';
--			if (a > b) then
--				gt <= '1';
--			elsif (a = b) then
--				eq <= '1';
--			else
--				lt <= '1';
--			end if;
	end process;
end beh_arch;
	