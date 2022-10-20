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

architecture two_seg_arch of binary_counter is
	signal r_reg : unsigned(3 downto 0);
	signal r_next : unsigned(3 downto 0);
begin
	-- register segment
	process(clk, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_reg <= r_next;
		end if;
	end process;
	-- next-state logic segment
	r_next <= r_reg + 1;
	-- output logic segment
	q <= std_logic_vector(r_reg);
	max_pulse <= '1' when r_reg = "1111" else
					 '0';
end two_seg_arch;

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

configuration binary_counter_cfg of binary_counter is
	for two_seg_arch
	end for;
end binary_counter_cfg;
