library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arith_demo is
	port(
		a, b : in std_logic_vector(7 downto 0);
		--sum : out std_logic_vector(7 downto 0)
		prod : out std_logic_vector(15 downto 0)
	);
end arith_demo;

architecture beh_arch of arith_demo is
begin
	--sum <= std_logic_vector(unsigned(a) + unsigned(b));
	prod <= std_logic_vector(unsigned(a) * unsigned(b));
end beh_arch;