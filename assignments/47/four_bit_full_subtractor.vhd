library ieee;
use ieee.std_logic_1164.all;


entity four_bit_full_subtractor is

    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          i_C : in std_logic;
          o_SUB : out std_logic_vector(3 downto 0);
          o_C : out std_logic
			 
			 );
			 
end four_bit_full_subtractor;


architecture str_arch of four_bit_full_subtractor is

component full_sub
	port
	(
	
		a :in std_logic_vector(2 downto 0);
		r,p1: out std_logic
	);

end component;
signal s3, s2, s1 : std_logic;

begin

	f3: full_sub
	   port map( p1=>o_C, a(2)=>i_A(3), a(1)=>i_B(3), r=>o_SUB(3), a(0)=>s3);
	f2: full_sub
	   port map( p1=>s3, a(2)=>i_A(2), a(1)=>i_B(2), r=>o_SUB(2), a(0)=>s2);                   
	f1: full_sub
	   port map( p1=>s2, a(2)=>i_A(1), a(1)=>i_B(1), r=>o_SUB(1), a(0)=>s1);                               
	f0: full_sub
	   port map( p1=>s1, a(2)=>i_A(0), a(1)=>i_B(0), r=>o_SUB(0), a(0)=>i_C);                          

end str_arch;



