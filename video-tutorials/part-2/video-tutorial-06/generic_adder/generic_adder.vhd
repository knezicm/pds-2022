library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

entity generic_adder is
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
end generic_adder;

architecture str_arch of generic_adder is

component fulladder
	port(
		a 		: in std_logic;
		b 		: in std_logic;
		cin	: in std_logic;
		s 		: out std_logic;
		cout 	: out std_logic
	);
end component;
	
signal wire : std_logic_vector(0 to width);

begin
	
	wire(0) <= carry_in;
	carry_out <= wire(width);
	
	g1:
	for i in 0 to width-1 generate
		f_add: fulladder port map (a(i), b(i), wire(i), sum(i), wire(i+1));
	end generate;

end str_arch;

--architecture beh_arch of generic_adder is
--
--signal result : std_logic_vector(width downto 0);
--
--begin
--
--	result <= ('0' & a) + ('0' & b) + carry_in;
--	sum <= result(width-1 downto 0);
--	carry_out <= result(width);
--
--end beh_arch;
--
--configuration generic_adder_cfg of generic_adder is
--	for str_arch
--	end for;
--end generic_adder_cfg;
