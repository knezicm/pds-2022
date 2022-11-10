library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;  -- ukljucena biblioteka kako bih mogao koristiti aritmeticke operacije

entity two_bit_comparator is 
port (
	
	A, B : in std_logic_vector (2 downto 0);
	AGTB : out std_logic; -- if A > B
	AEQB : out std_logic; -- if A = B
	ALTB : out std_logic -- if A < B
	);
end entity two_bit_comparator;

architecture arch_comparator of two_bit_comparator is

begin

--konkurente kondicione naredbe

	AEQB <= '1' when (A = B) else 
			  '0';
	AGTB <= '1' when (A > B) else 
			  '0';
	ALTB <= '1' when (A < B) else 
			  '0';
end arch_comparator;
