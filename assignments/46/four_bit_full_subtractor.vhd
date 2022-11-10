library ieee;
use ieee.std_logic_1164.all;


entity four_bit_full_subtractor is
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          i_C : in std_logic;
          o_SUB : out std_logic_vector(3 downto 0);
          o_C : out std_logic);
end four_bit_full_subtractor;

architecture fullsub_arch of four_bit_full_subtractor is 

component  one_bit_full_subtractor 
port ( X, Y, Bin : in std_logic;
         D, Bout : out std_logic
		 );
end component;

signal B : std_logic_vector(2 downto 0);
begin

	s0 : one_bit_full_subtractor
	port map (X => i_A (0), Y => i_B(0), Bin => i_C, D =>o_SUB(0), Bout => B(0));
	s1 : one_bit_full_subtractor
		port map (X => i_A (1), Y => i_B(1), Bin =>B(0) , D=>o_SUB(1) , Bout =>B(1));
	s2 : one_bit_full_subtractor
		port map (X => i_A (2), Y => i_B(2), Bin =>B(1), D=>o_SUB(2) , Bout =>B(2));
	s3 : one_bit_full_subtractor
		port map (X => i_A (3), Y => i_B(3), Bin =>B(2), D=>o_SUB(3) , Bout =>o_C);
end fullsub_arch;
	