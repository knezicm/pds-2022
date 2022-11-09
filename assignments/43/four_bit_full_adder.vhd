library ieee;
use ieee.std_logic_1164.all;

entity four_bit_full_adder is
	port ( i_A : in std_logic_vector(3 downto 0);
			 i_B : in std_logic_vector(3 downto 0);
			 i_C : in std_logic;
			 o_SUM : out std_logic_vector(3 downto 0);
			 o_C : out std_logic);
end four_bit_full_adder;

architecture struct_arch of four_bit_full_adder is
component one_bit_full_adder 
		port ( i_A : in std_logic;
				 i_B : in std_logic;
				 i_C : in std_logic;
				 o_SUM : out std_logic;
				 o_C : out std_logic);
end component;

signal i_C1, i_C2, i_C3 : std_logic;
begin
U1 : one_bit_full_adder port map (i_A(0),i_B(0),i_C,o_SUM(0),i_C1);
U2 : one_bit_full_adder port map (i_A(1),i_B(1),i_C1,o_SUM(1),i_C2);
U3 : one_bit_full_adder port map (i_A(2),i_B(2),i_C2,o_SUM(2),i_C3);
U4 : one_bit_full_adder port map (i_A(3),i_B(3),i_C3,o_SUM(3),o_C);
end struct_arch;