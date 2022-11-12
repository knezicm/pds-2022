library ieee;
use ieee.std_logic_1164.all;

	
entity full_sub is
	
	port
	(
	   
		a :in std_logic_vector(2 downto 0);
		r,p1: out std_logic
		
	);
end full_sub;



architecture sel_arch of full_sub is

begin
    with a select
	 r<= '0' when "000"|"011"|"101"|"110",
	     '1' when "001"|"010"|"100"|"111",
		  '0' when others;
	
	 with a select
	 p1<= '0' when "000"|"100"|"101"|"110",
	      '1' when "001"|"010"|"011"|"111",
			'0' when others;
	 
end sel_arch;


