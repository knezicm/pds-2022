library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- radi se o neoznacenim podacima

entity four_bit_comparator is  --entitet zadan tekstom zadatka
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          o_AGTB : out std_logic;
          o_AEQB : out std_logic;
          o_ALTB : out std_logic);
end four_bit_comparator;

architecture arch_four_bit_comparator of four_bit_comparator is

-- ukljucivanje prethodno definisane komponente

component two_bit_comparator 
	port (
	A, B : in std_logic_vector (2 downto 0);
	AGTB : out std_logic; -- if A > B
	AEQB : out std_logic; -- if A = B
	ALTB : out std_logic -- if A < B
	);
end component;

signal equal1, greater1, less1, equal2, greater2, less2, temp1, temp2: std_logic; -- pomocni signali za strukturni opis hardvera

begin

	comparator1: two_bit_comparator
		port map (A(0) => i_A(2), A(1) => i_A(3), B(0) => i_B(2), B(1) => i_B(3), AEQB => equal1, AGTB => greater1, ALTB => less1);
		
	comparator2: two_bit_comparator
		port map (A(0) => i_A(0), A(1) => i_A(1), B(0) => i_B(0), B(1) => i_B(1), AEQB => equal2, AGTB => greater2, ALTB => less2);
		
		temp1 <= equal1 and greater2;
		temp2 <= equal1 and less2;
		o_AEQB <= equal1 and equal2;
		o_AGTB <= temp1 or greater1;
		o_ALTB <= temp2 or less1;		
		
end arch_four_bit_comparator;
