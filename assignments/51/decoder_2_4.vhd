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
 
process(i_E, i_A)
begin
if (i_E = '0') then o_Y <= "0000";
elsif(i_E = '1' and i_A = "00") then  o_Y <= "0001"; 
elsif(i_E = '1' and i_A = "01") then o_Y <= "0010"; 
elsif(i_E = '1' and i_A = "10") then o_Y <= "0100"; 
elsif(i_E = '1' and i_A = "11") then o_Y <= "1000";
end if; 
end process;
end bhv;
