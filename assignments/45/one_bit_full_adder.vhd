library ieee;
use ieee.std_logic_1164.all;
entity one_bit_full_adder is
	port
	(
		A, B, Ci: in std_logic;
      Co, SUM: out std_logic
	);
end one_bit_full_adder;

architecture one_bit_full_adder_beh of one_bit_full_adder is
begin
	SUM <= '0' when (A='0' and B='0' and Ci='0') or (A='0' and B='1' and Ci='1') or (A='1' and B='0' and Ci='1')
							or (A='1' and B='1' and Ci='0') else
			 '1';
				
	Co <= '0' when (A='0' and B='0' and Ci='0') or (A='0' and B='0' and Ci='1') or (A='0' and B='1' and Ci='0')
							or (A='1' and B='0' and Ci='0') else
			'1';
end one_bit_full_adder_beh;