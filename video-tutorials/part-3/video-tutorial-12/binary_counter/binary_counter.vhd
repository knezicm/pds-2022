library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is
	port(
		clk, reset : in std_logic;
		max_pulse : out std_logic;
		q : out std_logic_vector(3 downto 0)
	);
end binary_counter;

architecture one_seg_arch of binary_counter is
	signal r_reg : unsigned(3 downto 0);
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_reg <= r_reg + 1;
			if (r_reg = "1111") then
				max_pulse <= '1';
			else
				max_pulse <= '0';
			end if;
		end if;
	end process;
	q <= std_logic_vector(r_reg);
end one_seg_arch;
