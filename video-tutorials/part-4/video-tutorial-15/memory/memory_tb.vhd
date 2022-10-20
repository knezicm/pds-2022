library ieee;
use ieee.std_logic_1164.all;

entity memory_tb is
end memory_tb;

architecture tb_arch of memory_tb is

	component memory
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port (
			clk		: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);
	end component;
	
	constant T : time := 20 ns;
	constant num_cycles : natural := 10;
	constant DATA_WIDTH : natural := 8;
	constant ADDR_WIDTH : natural := 6;
	
	signal clk : std_logic;
	signal addr : natural range 0 to 2**ADDR_WIDTH - 1;
	signal data : std_logic_vector((DATA_WIDTH-1) downto 0);
	signal we : std_logic;
	signal q : std_logic_vector((DATA_WIDTH -1) downto 0);

begin

	-- uut instantiation
	uut: memory
		generic map(DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
		port map(clk => clk, addr => addr, data => data, we => we, q => q);

	-- stimulus for continous clock
	process
	begin
		for i in 1 to num_cycles loop
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
		end loop;
		wait;
	end process;
	
	-- stimulus generation
	process
	
		procedure readmem(
			constant addr_in : in natural;
			constant expect : in std_logic_vector
		) is
		begin
			we <= '0';
			addr <= addr_in;
			wait for 20 ns;
			assert (data = expect)
				report "Test failed!"
				severity Error;
		end readmem;
		
		procedure writemem(
			constant addr_in : in natural;
			constant data_in : in std_logic_vector
		) is
		begin
			we <= '1';
			addr <= addr_in;
			data <= data_in;
			wait for 20 ns;
		end writemem;
		
	begin
		-- writing
		we <= '1';
		addr <= 8;
		data <= "10100110";
		wait for 20 ns;
		-- reading
		we <= '0';
		wait for 20 ns;
		-- procedure write
		writemem(22, "00001111");
		-- procedure read
		readmem(22, "00001111");
		wait;
	end process;

end tb_arch;
