library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_syn_attributes.all;

entity memory is
	generic(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);
	port (
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end memory;

architecture beh_arch of memory is
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
	signal ram : memory_t;
	attribute ramstyle of ram : signal is "MLAB";
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;
begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr) <= data;
		end if;
		addr_reg <= addr;
	end if;
	end process;

	q <= ram(addr_reg);

end beh_arch;
