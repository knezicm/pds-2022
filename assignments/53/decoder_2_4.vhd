library ieee;
use ieee.std_logic_1164.all;

entity decoder_2_4 is
port(
	i_A : in std_logic_vector(1 downto 0);
	i_E : in std_logic;
	o_Y : out std_logic_vector(3 downto 0)
	);
end decoder_2_4;

architecture arch_decoder_2_4 of decoder_2_4 is
signal tmp : std_logic_vector(3 downto 0);
begin
	with i_A select
		tmp <="1000" when "11",
				"0100" when "10",
				"0010" when "01",
				"0001" when "00",
				"0000" when others;
	with i_E select
		o_Y <=tmp when '1',
				"0000" when others;
end arch_decoder_2_4;
			