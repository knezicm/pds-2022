library ieee;
use ieee.std_logic_1164.all;

entity decoder_2_4 is
    port (i_A : in std_logic_vector(1 downto 0);
          i_E : in std_logic;
          o_Y : out std_logic_vector(3 downto 0)
			 );
end decoder_2_4;

architecture bhv of decoder_2_4 is
begin

o_Y(0) <= ( i_E and (not i_A(1)) and (not i_A(0)));
o_Y(1) <= ( i_E and (not i_A(1)) and i_A(0));
o_Y(2) <= ( i_E and i_A(1) and (not i_A(0)));
o_Y(3) <= ( i_E and i_A(1) and i_A(0));
end bhv;
