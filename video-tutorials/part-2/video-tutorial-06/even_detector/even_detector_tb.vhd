library ieee;
use ieee.std_logic_1164.all;

entity even_detector_tb is
end even_detector_tb;

architecture tb_arch of even_detector_tb is
	component even_detector
		port(
			a : in std_logic_vector(2 downto 0);
			even : out std_logic
		);
	end component;
	signal test_in : std_logic_vector(2 downto 0);
	signal test_out : std_logic;
	
begin

	-- uut instantiation
	uut: even_detector
		port map(a => test_in, even => test_out);
	
	-- stimulus generator
	process
	begin
		test_in <= "000";
		wait for 200 ns;
		test_in <= "001";
		wait for 200 ns;
		test_in <= "010";
		wait for 200 ns;
		test_in <= "011";
		wait for 200 ns;
		test_in <= "100";
		wait for 200 ns;
		test_in <= "101";
		wait for 200 ns;
		test_in <= "110";
		wait for 200 ns;
		test_in <= "111";
		wait for 200 ns;
		wait;
	end process;
	
	-- verifier
	process
		variable error_status : boolean;
	begin
		wait on test_in;
		wait for 100 ns;
		if ((test_in = "000" and test_out = '1') or
			 (test_in = "001" and test_out = '0') or
			 (test_in = "010" and test_out = '0') or
			 (test_in = "011" and test_out = '1') or
			 (test_in = "100" and test_out = '0') or
			 (test_in = "101" and test_out = '1') or
			 (test_in = "110" and test_out = '1') or
			 (test_in = "111" and test_out = '0'))
		then
			error_status := false;
		else
			error_status := true;
		end if;
		
		-- report an error
		assert not error_status
			report "Test failed!"
			severity note;
	end process;

end tb_arch;
