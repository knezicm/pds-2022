library ieee;
use ieee.std_logic_1164.all;
-- Uncomment for file-based testbench
--use std.textio.all;
--use ieee.std_logic_textio.all;

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
	-- Uncomment for file-based testbench
--	signal even_actual : std_logic;
	
	-- Comment for file-based testbench
   type test_vector is record
       a : std_logic_vector(2 downto 0);
       even : std_logic;
   end record;
   
	-- Comment for file-based testbench
   type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
		-- a,  even		-- positional method is used here
		("000", '1'),	-- alternatively, you can use (a => "000", even => '1')
		("001", '0'),
		("010", '0'),
		("011", '1'),
		("100", '0'),
		("101", '1'),
		("110", '1'),
		("111", '0')
	);
	
	-- Uncomment for file-based testbench
	-- buffers for storing the text from input and for output files
--	file input_buf : text;
--	file output_buf : text;
	
begin

	-- uut instantiation
	uut: even_detector
		port map(a => test_in, even => test_out);
	
	-- Comment for file-based testbench
	-- stimulus generator and verifier
	process
	begin
		for i in test_vectors'range loop
			test_in <= test_vectors(i).a;	-- signal a = i_th row value of test vector array
			wait for 200 ns;
			
			assert (test_out = test_vectors(i).even)
				report "Test vector " & integer'image(i) & " failed " &
						 " for input a = " & std_logic'image(test_in(2)) &
						 std_logic'image(test_in(1)) & std_logic'image(test_in(0)) & "! Expected " &
						 std_logic'image(test_vectors(i).even) & " and it was " & std_logic'image(test_out) & "."
						 severity error;
		end loop;
		wait;
	end process;
	
	-- Uncomment for file-based testbench
	-- file-based stimulus generator and verifier
--	process
--		variable read_col_from_input_buf : line;	-- read one line at the time from input_buf
--		variable write_col_to_output_buf : line;	-- write one line at the time to output_buf
--		variable val_a : std_logic_vector(2 downto 0);
--		variable val_even : std_logic;
--		variable val_comma : character;				-- for commas between data items in file
--		variable good_num : boolean;
--	begin
--		-- Reading data
--		-- Provide a relative path to input file with respect to main project folder
--		file_open(input_buf, "data_files/even_detector_input.csv", read_mode);
--		
--		-- Writing data
--		file_open(output_buf, "data_files/even_detector_output.csv", write_mode);
--		
--		write(write_col_to_output_buf,
--				string'("#a,even_actual,even,even_test_results"));
--		writeline(output_buf, write_col_to_output_buf);
--		
--		while not endfile(input_buf) loop
--			readline(input_buf, read_col_from_input_buf);
--			read(read_col_from_input_buf, val_a, good_num);
--			next when not good_num;	-- skip the header lines
--			
--			read(read_col_from_input_buf, val_comma);	-- read in the space char
--			read(read_col_from_input_buf, val_even, good_num);
--			assert good_num report "Bad value assigned to val_even";
--			
--			-- Pass the variable to the signal
--			test_in <= val_a;
--			even_actual <= val_even;
--			
--			wait for 200 ns;
--			
--			write(write_col_to_output_buf, test_in);
--			write(write_col_to_output_buf, string'(","));
--			write(write_col_to_output_buf, even_actual);
--			write(write_col_to_output_buf, string'(","));
--			write(write_col_to_output_buf, test_out);
--			write(write_col_to_output_buf, string'(","));
--			
--			-- Display Error or OK according to the result
--			if (even_actual /= test_out) then
--				write(write_col_to_output_buf, string'("Error"));
--			else
--				write(write_col_to_output_buf, string'("OK"));
--			end if;
--			
--			writeline(output_buf, write_col_to_output_buf);			
--		end loop;
--		
--		-- Close files
--		file_close(input_buf);
--		file_close(output_buf);
--		wait;
--	end process;

end tb_arch;
