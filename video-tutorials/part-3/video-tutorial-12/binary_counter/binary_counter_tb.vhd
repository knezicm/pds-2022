library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity binary_counter_tb is
end binary_counter_tb;

architecture tb_arch of binary_counter_tb is
	component binary_counter
		port(
			clk, reset : in std_logic;
			max_pulse : out std_logic;
			q : out std_logic_vector(3 downto 0)
		);
	end component;
	
	constant N : integer := 4;
	constant T : time := 20 ns;
	
	signal clk, reset : std_logic;
	signal max_pulse : std_logic;
	signal q : std_logic_vector(N-1 downto 0);
	
	-- total samples to store in file
	constant num_of_clocks : integer := 30;
	signal i : integer := 0;	-- loop variable
	file output_buf : text;
begin
	
	-- uut instantiation
	uut: binary_counter
		port map(clk => clk, reset => reset, max_pulse => max_pulse, q => q);
	
	-- stimulus generator for reset
	reset <= '1', '0' after T/2;
	
	-- stimulus for continous clock
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
		
		-- store 30 samples into the output file
		if (i = num_of_clocks) then
			file_close(output_buf);
			wait;
		else
			i <= i + 1;
		end if;
	end process;
	
	-- save data into the output file : path relative to Modelsim project directory
	file_open(output_buf, "data_files/binary_counter_data.csv", write_mode);
	process(clk)
		variable write_col_to_output_buf : line;			-- one line at the time
	begin
		if (rising_edge(clk) and (reset /= '1')) then	-- avoid reset
			-- write the header to the output file
			if (i = 0) then
				write(write_col_to_output_buf, string'("max_pulse,q"));
				writeline(output_buf, write_col_to_output_buf);
			end if;
			
			write(write_col_to_output_buf, max_pulse);
			write(write_col_to_output_buf, string'(","));
			-- (un)signed values cannot be saved into the file
			-- so we convert them into integer or std_logic_vector
			write(write_col_to_output_buf, to_integer(unsigned(q)));
			writeline(output_buf, write_col_to_output_buf);
		end if;
	end process;
	
end tb_arch;
