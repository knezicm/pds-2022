library ieee;
use ieee.std_logic_1164.all;

entity one_bit_full_subtractor is
   port( X, Y, Bin : in std_logic;
         D, Bout : out std_logic
		 );
			
end one_bit_full_subtractor;


architecture sub_arch of one_bit_full_subtractor is
begin
	
	  D <= X xor Y xor Bin;
	  Bout <= (Bin and (X xnor Y)) or ( (not X) and Y);

end sub_arch;
