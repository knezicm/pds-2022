library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_counter is
	port(
		clk, reset : in std_logic;
		m : in std_logic_vector(3 downto 0);
		q : out std_logic_vector(3 downto 0)
	);
end prog_counter;

architecture two_seg_clear_arch of prog_counter is
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
	r_next <= (others => '0') when r_reg = (unsigned(m) - 1) else
				 r_reg + 1;
	-- output logic segment
	q <= std_logic_vector(r_reg);
end two_seg_clear_arch;

architecture two_seg_effi_arch of prog_counter is
	signal r_reg : unsigned(3 downto 0);
	signal r_next, r_inc : unsigned(3 downto 0);
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
	r_inc <= r_reg + 1;
	r_next <= (others => '0') when r_inc = unsigned(m) else
				 r_inc;
	-- output logic segment
	q <= std_logic_vector(r_reg);
end two_seg_effi_arch;

architecture one_seg_arch of prog_counter is
	signal r_reg : unsigned(3 downto 0);
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_reg <= r_reg + 1;
			if (r_reg = unsigned(m)) then
				r_reg <= (others => '0');
			end if;
		end if;
	end process;
	q <= std_logic_vector(r_reg);
end one_seg_arch;

architecture variable_arch of prog_counter is
	signal r_reg : unsigned(3 downto 0);
begin
	process(clk, reset)
		variable r_temp : unsigned(3 downto 0);
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_temp := r_reg + 1;
			if (r_temp = unsigned(m)) then
				r_reg <= (others => '0');
			else
				r_reg <= r_temp;
			end if;
		end if;
	end process;
	q <= std_logic_vector(r_reg);
end variable_arch;

configuration prog_counter_cfg of prog_counter is
	for two_seg_clear_arch
	end for;
end prog_counter_cfg;
