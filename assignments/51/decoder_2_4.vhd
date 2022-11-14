library ieee;
use ieee.std_logic_1164.all;

entity decoder_2_4 is
    port (a : in std_logic_vector(1 downto 0);
          e : in std_logic;
          o : out std_logic_vector(3 downto 0)
			 );
end decoder_2_4;

architecture bhv of decoder_2_4 is
begin

o(0) <= ( e and (not a(1)) and (not a(0)));
o(1) <= ( e and (not a(1)) and a(0));
o(2) <= ( e and a(1) and (not a(0)));
o(3) <= ( e and a(1) and a(0));
end bhv;
