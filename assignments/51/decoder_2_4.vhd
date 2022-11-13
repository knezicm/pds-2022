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
 
process(i_E,i_A)
begin
case i_A is
when "00" => o_Y <= "0001"; 
when "01" => o_Y <= "0010"; 
when "10" => o_Y <= "0100"; 
when "11" => o_Y <= "1000";
end case;
end process;
 
end bhv;