library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_mult is
	port(
		clk, reset : in std_logic;
		start : in std_logic;
		a_in, b_in : in std_logic_vector(7 downto 0);
		ready : out std_logic;
		r : out std_logic_vector(15 downto 0)
	);
end seq_mult;

architecture multi_seg_arch of seq_mult is
	constant WIDTH : integer := 8;
	type state_type is (idle, ab0, load, op);
	signal state_reg, state_next : state_type;
	signal a_is_0, b_is_0, count_0 : std_logic;
	signal a_reg, a_next : unsigned(WIDTH-1 downto 0);
	signal n_reg, n_next : unsigned(WIDTH-1 downto 0);
	signal r_reg, r_next : unsigned(2*WIDTH-1 downto 0);
	signal adder_out : unsigned(2*WIDTH-1 downto 0);
	signal sub_out : unsigned(WIDTH-1 downto 0);
begin
	-- control path: state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= idle;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	-- control path: next-state / output logic
	process(state_reg, start, a_is_0, b_is_0, count_0)
	begin
		case state_reg is
			when idle =>
				if start = '1' then
					if (a_is_0 = '1' or b_is_0 = '1') then
						state_next <= ab0;
					else
						state_next <= load;
					end if;
				else
					state_next <= idle;
				end if;
			when ab0 =>
				state_next <= idle;
			when load =>
				state_next <= op;
			when op =>
				if count_0 = '1' then
					state_next <= idle;
				else
					state_next <= op;
				end if;
		end case;
	end process;
	-- control path: output logic
	ready <= '1' when state_reg = idle else '0';
	-- data path: data register
	process(clk, reset)
	begin
		if (reset = '1') then
			a_reg <= (others => '0');
			n_reg <= (others => '0');
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			a_reg <= a_next;
			n_reg <= n_next;
			r_reg <= r_next;
		end if;
	end process;
	-- data path: routing multipexer
	process(state_reg, a_reg, n_reg, r_reg,
			  a_in, b_in, adder_out, sub_out)
	begin
		case state_reg is
			when idle =>
				a_next <= a_reg;
				n_next <= n_reg;
				r_next <= r_reg;
			when ab0 =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
			when load =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
			when op =>
				a_next <= a_reg;
				n_next <= sub_out;
				r_next <= adder_out;
		end case;
	end process;
	-- data path: functional units
	adder_out <= ("00000000" & a_reg) + r_reg;
	sub_out <= n_reg - 1;
	-- data path: status
	a_is_0 <= '1' when a_in = "00000000" else '0';
	b_is_0 <= '1' when b_in = "00000000" else '0';
	count_0 <= '1' when n_next = "00000000" else '0';
	-- data path: output
	r <= std_logic_vector(r_reg);
end multi_seg_arch;

architecture four_seg_arch of seq_mult is
	constant WIDTH : integer := 8;
	type state_type is (idle, ab0, load, op);
	signal state_reg, state_next : state_type;
	signal a_reg, a_next : unsigned(WIDTH-1 downto 0);
	signal n_reg, n_next : unsigned(WIDTH-1 downto 0);
	signal r_reg, r_next : unsigned(2*WIDTH-1 downto 0);
begin
	-- control path: state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= idle;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	-- control path: combinational logic
	process(state_reg, start, a_in, b_in, n_next)
	begin
		ready <= '0';	-- default value
		case state_reg is
			when idle =>
				if start = '1' then
					if (a_in = "00000000" or b_in = "00000000") then
						state_next <= ab0;
					else
						state_next <= load;
					end if;
				else
					state_next <= idle;
				end if;
				ready <= '1';
			when ab0 =>
				state_next <= idle;
			when load =>
				state_next <= op;
			when op =>
				if n_next = "00000000" then
					state_next <= idle;
				else
					state_next <= op;
				end if;
		end case;
	end process;
	-- data path: data register
	process(clk, reset)
	begin
		if (reset = '1') then
			a_reg <= (others => '0');
			n_reg <= (others => '0');
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			a_reg <= a_next;
			n_reg <= n_next;
			r_reg <= r_next;
		end if;
	end process;
	-- data path: combinational circuit
	process(state_reg, a_reg, n_reg, r_reg, a_in, b_in)
	begin
		-- default values
		a_next <= a_reg;
		n_next <= n_reg;
		r_next <= r_reg;
		case state_reg is
			when idle =>
			when ab0 =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
			when load =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
			when op =>
				n_next <= n_reg - 1;
				r_next <= ("00000000" & a_reg) + r_reg;
		end case;
	end process;
	-- data path: output
	r <= std_logic_vector(r_reg);
end four_seg_arch;

architecture two_seg_arch of seq_mult is
	constant WIDTH : integer := 8;
	type state_type is (idle, ab0, load, op);
	signal state_reg, state_next : state_type;
	signal a_reg, a_next : unsigned(WIDTH-1 downto 0);
	signal n_reg, n_next : unsigned(WIDTH-1 downto 0);
	signal r_reg, r_next : unsigned(2*WIDTH-1 downto 0);
begin
	-- state and data registers
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= idle;
			a_reg <= (others => '0');
			n_reg <= (others => '0');
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			state_reg <= state_next;
			a_reg <= a_next;
			n_reg <= n_next;
			r_reg <= r_next;
		end if;
	end process;
	-- combinational logic
	process(state_reg, start, a_in, b_in, a_reg, n_reg, r_reg, n_next)
	begin
		-- default values
		a_next <= a_reg;
		n_next <= n_reg;
		r_next <= r_reg;
		ready <= '0';
		case state_reg is
			when idle =>
				if start = '1' then
					if (a_in = "00000000" or b_in = "00000000") then
						state_next <= ab0;
					else
						state_next <= load;
					end if;
				else
					state_next <= idle;
				end if;
				ready <= '1';
			when ab0 =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
				state_next <= idle;
			when load =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
				state_next <= op;
			when op =>
				n_next <= n_reg - 1;
				r_next <= ("00000000" & a_reg) + r_reg;
				if n_next = "00000000" then
					state_next <= idle;
				else
					state_next <= op;
				end if;
		end case;
	end process;
	-- data path: output
	r <= std_logic_vector(r_reg);
end two_seg_arch;

architecture one_seg_arch of seq_mult is
	constant WIDTH : integer := 8;
	type state_type is (idle, ab0, load, op);
	signal state_reg : state_type;
	signal a_reg, n_reg : unsigned(WIDTH-1 downto 0);
	signal r_reg : unsigned(2*WIDTH-1 downto 0);
begin
	process(clk, reset)
		variable n_next : unsigned(WIDTH-1 downto 0);
	begin
		if (reset = '1') then
			state_reg <= idle;
			a_reg <= (others => '0');
			n_reg <= (others => '0');
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			case state_reg is
				when idle =>
					if start = '1' then
						if (a_in = "00000000" or b_in = "00000000") then
							state_reg <= ab0;
						else
							state_reg <= load;
						end if;
					else
						state_reg <= idle;
					end if;
				when ab0 =>
					a_reg <= unsigned(a_in);
					n_reg <= unsigned(b_in);
					r_reg <= (others => '0');
					state_reg <= idle;
				when load =>
					a_reg <= unsigned(a_in);
					n_reg <= unsigned(b_in);
					r_reg <= (others => '0');
					state_reg <= op;
				when op =>
					n_next := n_reg - 1;
					n_reg <= n_next;
					r_reg <= ("00000000" & a_reg) + r_reg;
					if n_next = "00000000" then
						state_reg <= idle;
					end if;
			end case;
		end if;
	end process;
	ready <= '1' when (state_reg = idle) else '0';
	r <= std_logic_vector(r_reg);
end one_seg_arch;

architecture sharing_arch of seq_mult is
	constant WIDTH : integer := 8;
	type state_type is (idle, ab0, load, op1, op2);
	signal state_reg, state_next : state_type;
	signal a_reg, a_next : unsigned(WIDTH-1 downto 0);
	signal n_reg, n_next : unsigned(WIDTH-1 downto 0);
	signal r_reg, r_next : unsigned(2*WIDTH-1 downto 0);
	signal adder_src1, adder_src2 : unsigned(2*WIDTH-1 downto 0);
	signal adder_out : unsigned(2*WIDTH-1 downto 0);
begin
	-- state and data registers
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= idle;
			a_reg <= (others => '0');
			n_reg <= (others => '0');
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			state_reg <= state_next;
			a_reg <= a_next;
			n_reg <= n_next;
			r_reg <= r_next;
		end if;
	end process;
	-- next-state / output and data path routing logic
	process(state_reg, start, a_in, b_in, a_reg, n_reg, r_reg,
			  adder_out, n_next)
	begin
		-- default values
		a_next <= a_reg;
		n_next <= n_reg;
		r_next <= r_reg;
		ready <= '0';
		case state_reg is
			when idle =>
				if start = '1' then
					if (a_in = "00000000" or b_in = "00000000") then
						state_next <= ab0;
					else
						state_next <= load;
					end if;
				else
					state_next <= idle;
				end if;
				ready <= '1';
			when ab0 =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
				state_next <= idle;
			when load =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(b_in);
				r_next <= (others => '0');
				state_next <= op1;
			when op1 =>
				r_next <= adder_out;
				state_next <= op2;
			when op2 =>
				n_next <= adder_out(WIDTH-1 downto 0);
				if n_next = "00000000" then
					state_next <= idle;
				else
					state_next <= op1;
				end if;
		end case;
	end process;
	-- data path input routing and functional units
	process(state_reg, r_reg, a_reg, n_reg)
	begin
		if (state_reg = op1) then
			adder_src1 <= r_reg;
			adder_src2 <= "00000000" & a_reg;
		else	-- for op2 state
			adder_src1 <= "00000000" & n_reg;
			adder_src2 <= (others => '1');
		end if;
	end process;
	adder_out <= adder_src1 + adder_src2;
	-- data path: output
	r <= std_logic_vector(r_reg);
end sharing_arch;

configuration seq_mult_cfg of seq_mult is
	for multi_seg_arch
	end for;
end seq_mult_cfg;
