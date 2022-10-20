library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
end generic_adder_tb;

architecture tb_arch of generic_adder_tb is

component generic_adder
	generic(
		width	: natural := 4
	);
	port(
		a 				: in  std_logic_vector(width-1 downto 0);
		b 				: in  std_logic_vector(width-1 downto 0);
		carry_in		: in 	std_logic;
		carry_out	: out std_logic;
		sum 			: out std_logic_vector(width-1 downto 0)
	);
end component;

constant width : natural := 4;
signal a_test : std_logic_vector(width-1 downto 0);
signal b_test : std_logic_vector(width-1 downto 0);
signal carry_in_test : std_logic;
signal sum_test : std_logic_vector(width downto 0);

begin

	-- uut instantiation
	uut: generic_adder
		generic map (width => width)
		port map(a => a_test, b => b_test, carry_in => carry_in_test,
					carry_out => sum_test(width), sum => sum_test(width-1 downto 0)
		);

	tb: process
	begin
		-- initialize values
		a_test <= "0000";
		b_test <= "0000";
		carry_in_test <= '0';
		
		-- loop over all possible values of a
		for i in 0 to 15 loop
			-- loop over all possible values of b
			for j in 0 to 15 loop
				-- wait for output to update
				wait for 10 ns;
				-- check the value of sum
				assert (to_integer(unsigned(sum_test)) = (to_integer(unsigned(a_test)) + to_integer(unsigned(b_test)))) report "Error, sum incorrect! Expected sum of " &
					integer'image((to_integer(unsigned(a_test))+to_integer(unsigned(b_test)))) & " for a = " &
					integer'image(to_integer(unsigned(a_test))) & " and b = " &
					integer'image(to_integer(unsigned(b_test))) & ", but was " &
					integer'image(to_integer(unsigned(sum_test))) severity error;
				-- increment to the next value of b
				b_test <= std_logic_vector(unsigned(b_test) + 1);
			end loop;
			-- increment to the next value of a
			a_test <= std_logic_vector(unsigned(a_test) + 1);
		end loop;
		
		-- echo to user that test is completed
		report "Test completed.";
		wait;	-- will wait forever
	end process;

end tb_arch;