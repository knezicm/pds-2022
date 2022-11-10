library ieee;
use ieee.std_logic_1164.all;

entity one_bit_full_adder is
  port ( i_A : in std_logic;
			i_B : in std_logic;
			i_C : in std_logic;
			o_SUM : out std_logic;
			o_C : out std_logic);
end one_bit_full_adder;

architecture basic_logic_gates_arch of one_bit_full_adder is
begin
		o_SUM <= ( not i_A and not i_B and i_C ) or
					( not i_A and i_B and not i_C ) or
					( i_A and not i_B and not i_C ) or
					( i_A and i_B and i_C);
		
		o_C <= ( not i_A and i_B and i_C) or
				 ( i_A and not i_B and i_C) or
				 (i_A and i_B and not i_C) or
				 (i_A and i_B and i_C);
				 
end basic_logic_gates_arch;