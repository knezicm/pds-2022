library ieee;
use ieee.std_logic_1164.all;

entity reg is
	port(
		clk : in std_logic;
		reset : in std_logic;
		d : in std_logic_vector(7 downto 0);
		q : out std_logic_vector(7 downto 0)
	);
end reg;

architecture arch of reg is
begin

	process(clk, reset)
	begin
		if (reset = '1') then
			q <= (others => '0');
		elsif rising_edge(clk) then
			q <= d;
		end if;
	end process;

end arch;
