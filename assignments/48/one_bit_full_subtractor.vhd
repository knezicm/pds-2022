-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;



-- Commonly imported packages:

	-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
	use ieee.std_logic_1164.all;
	
entity one_bit_full_subtractor is
	port
	(
		-- Input ports
		x	: in  std_logic;
		y	: in  std_logic;
		bin : in std_logic;
		
		-- Output ports
		d	: out std_logic;
		bout : out std_logic
	);
end one_bit_full_subtractor;


architecture arc of one_bit_full_subtractor is

begin

	d <= '1' when ((x='0' and y='0' and bin='1') 
					or (x='0' and y='1' and bin='0' )	
					or (x='1' and y='0' and bin='0')
					or (x='1' and y='1' and bin='1')) else
				'0';
				
	bout <= '1' when ( (x='0' and y='0' and bin='1') 
						or(x='0' and y='1' and bin='0')
						or (x='0' and y='1' and bin='1')
						or(x='1' and y='1' and bin='1')) else
						'0' ;

end arc;






