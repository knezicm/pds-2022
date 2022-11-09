library ieee;

use ieee.std_logic_1164.all;


entity four_bit_full_subtractor is
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          i_C : in std_logic;
          o_SUB : out std_logic_vector(3 downto 0);
          o_C : out std_logic);
end four_bit_full_subtractor;


architecture arc of four_bit_full_subtractor is

	component one_bit_full_subtractor
		port
		(
			-- Input ports
			x	: in  std_logic;
			y	: in  std_logic;
			bin: in std_logic;
			
			-- Output ports
			d	: out std_logic;
			bout : out std_logic
		);
	end component;
	

	signal s0_s1 : std_logic;
	signal s1_s2 : std_logic;
	signal s2_s3 : std_logic;

begin
	sub1 : one_bit_full_subtractor port map(x => i_A(0),y => i_B(0),bin => i_C , d => o_SUB(0),bout => s0_s1);
	sub2 : one_bit_full_subtractor port map(x => i_A(1),y => i_B(1),bin => s0_s1	, d => o_SUB(1),bout => s1_s2);
	sub3 : one_bit_full_subtractor port map(x => i_A(2),y => i_B(2),bin => s1_s2 , d => o_SUB(2),bout => s2_s3);
	sub4 : one_bit_full_subtractor port map(x => i_A(3),y => i_B(3),bin => s2_s3 , d => o_SUB(3),bout => o_C);
	
end arc;
