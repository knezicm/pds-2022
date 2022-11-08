library ieee;
use ieee.std_logic_1164.all;
entity four_bit_full_adder is
	port
	(
		i_A : in std_logic_vector(3 downto 0);
      i_B : in std_logic_vector(3 downto 0);
      i_C : in std_logic;
      o_SUM : out std_logic_vector(3 downto 0);
      o_C : out std_logic
	);
end four_bit_full_adder;

architecture four_bit_full_adder_beh of four_bit_full_adder is
	component one_bit_full_adder is
		port
		(
			A, B, Ci: in std_logic;
			Co, SUM: out std_logic
		);
	end component;
	signal o_C1, o_C2, o_C3 : std_logic;
begin
	u1 : one_bit_full_adder port map (A => i_A(0), B => i_B(0), Ci => i_C, Co => o_C1, SUM => o_SUM(0));
	u2 : one_bit_full_adder port map (A => i_A(1), B => i_B(1), Ci => o_C1, Co => o_C2, SUM => o_SUM(1));
	u3 : one_bit_full_adder port map (A => i_A(2), B => i_B(2), Ci => o_C2, Co => o_C3, SUM => o_SUM(2));
	u4 : one_bit_full_adder port map (A => i_A(3), B => i_B(3), Ci => o_C3, Co => o_C, SUM => o_SUM(3));
end four_bit_full_adder_beh;