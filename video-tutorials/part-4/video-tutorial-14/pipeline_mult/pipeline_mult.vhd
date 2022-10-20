library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_mult is
	port(
		clk, reset: in std_logic;
		a, b: in std_logic_vector(4 downto 0);
		y: out std_logic_vector(9 downto 0)
	);
end pipeline_mult;

architecture nopipe_arch of pipeline_mult is
	constant WIDTH: integer := 5;
	signal a_reg, a_next, b_reg, b_next: std_logic_vector(WIDTH-1 downto 0);
	signal a0, a1, a2, a3: std_logic_vector(WIDTH-1 downto 0);
	signal b0, b1, b2, b3: std_logic_vector(WIDTH-1 downto 0);
	signal bv0, bv1, bv2, bv3, bv4: std_logic_vector(WIDTH-1 downto 0);
	signal bp0, bp1, bp2, bp3, bp4: unsigned(2*WIDTH-1 downto 0);
	signal pp0, pp1, pp2, pp3, pp4: unsigned(2*WIDTH-1 downto 0);
	signal y_reg, y_next: std_logic_vector(2*WIDTH-1 downto 0);
begin
	-- input and output registers
	process(clk, reset)
	begin
		if (reset = '1') then
			a_reg <= (others => '0');
			b_reg <= (others => '0');
			y_reg <= (others => '0');
		elsif rising_edge(clk) then
			a_reg <= a_next;
			b_reg <= b_next;
			y_reg <= y_next;
		end if;
	end process;
	a_next <= a;
	b_next <= b;
	-- stage 0
	bv0 <= (others => b_reg(0));
	bp0 <= unsigned("00000" & (bv0 and a_reg));
	pp0 <= bp0;
	a0 <= a_reg;
	b0 <= b_reg;
	-- stage 1
	bv1 <= (others => b0(1));
	bp1 <= unsigned("0000" & (bv1 and a0) & "0");
	pp1 <= pp0 + bp1;
	a1 <= a0;
	b1 <= b0;
	-- stage 2
	bv2 <= (others => b1(2));
	bp2 <= unsigned("000" & (bv2 and a1) & "00");
	pp2 <= pp1 + bp2;
	a2 <= a1;
	b2 <= b1;
	-- stage 3
	bv3 <= (others => b2(3));
	bp3 <= unsigned("00" & (bv3 and a2) & "000");
	pp3 <= pp2 + bp3;
	a3 <= a2;
	b3 <= b2;
	-- stage 4
	bv4 <= (others => b3(4));
	bp4 <= unsigned("0" & (bv4 and a3) & "0000");
	pp4 <= pp3 + bp4;
	-- output
	y_next <= std_logic_vector(pp4);
	y <= y_reg;
end nopipe_arch;

architecture pipe_arch of pipeline_mult is
	constant WIDTH: integer := 5;
	signal a_reg, a_next, b_reg, b_next: std_logic_vector(WIDTH-1 downto 0);
	signal a1_reg, a2_reg, a3_reg: std_logic_vector(WIDTH-1 downto 0);
	signal a0, a1_next, a2_next, a3_next: std_logic_vector(WIDTH-1 downto 0);
	signal b1_reg, b2_reg, b3_reg: std_logic_vector(WIDTH-1 downto 0);
	signal b0, b1_next, b2_next, b3_next: std_logic_vector(WIDTH-1 downto 0);
	signal bv0, bv1, bv2, bv3, bv4: std_logic_vector(WIDTH-1 downto 0);
	signal bp0, bp1, bp2, bp3, bp4: unsigned(2*WIDTH-1 downto 0);
	signal pp1_reg, pp2_reg, pp3_reg, pp4_reg: unsigned(2*WIDTH-1 downto 0);
	signal pp0, pp1_next, pp2_next, pp3_next, pp4_next: unsigned(2*WIDTH-1 downto 0);
begin
	-- pipeline registers
	process(clk, reset)
	begin
		if (reset = '1') then
			a_reg <= (others => '0');
			b_reg <= (others => '0');
			pp1_reg <= (others => '0');
			pp2_reg <= (others => '0');
			pp3_reg <= (others => '0');
			pp4_reg <= (others => '0');
			a1_reg <= (others => '0');
			a2_reg <= (others => '0');
			a3_reg <= (others => '0');
			b1_reg <= (others => '0');
			b2_reg <= (others => '0');
			b3_reg <= (others => '0');
		elsif rising_edge(clk) then
			a_reg <= a_next;
			b_reg <= b_next;
			pp1_reg <= pp1_next;
			pp2_reg <= pp2_next;
			pp3_reg <= pp3_next;
			pp4_reg <= pp4_next;
			a1_reg <= a1_next;
			a2_reg <= a2_next;
			a3_reg <= a3_next;
			b1_reg <= b1_next;
			b2_reg <= b2_next;
			b3_reg <= b3_next;
		end if;
	end process;
	a_next <= a;
	b_next <= b;
	-- merged stage 0 and stage 1 for pipeline
	-- stage 0 part
	bv0 <= (others => b_reg(0));
	bp0 <= unsigned("00000" & (bv0 and a_reg));
	pp0 <= bp0;
	a0 <= a_reg;
	b0 <= b_reg;
	-- stage 1 part
	bv1 <= (others => b0(1));
	bp1 <= unsigned("0000" & (bv1 and a0) & "0");
	pp1_next <= pp0 + bp1;
	a1_next <= a0;
	b1_next <= b0;
	-- stage 2
	bv2 <= (others => b1_reg(2));
	bp2 <= unsigned("000" & (bv2 and a1_reg) & "00");
	pp2_next <= pp1_reg + bp2;
	a2_next <= a1_reg;
	b2_next <= b1_reg;
	-- stage 3
	bv3 <= (others => b2_reg(3));
	bp3 <= unsigned("00" & (bv3 and a2_reg) & "000");
	pp3_next <= pp2_reg + bp3;
	a3_next <= a2_reg;
	b3_next <= b2_reg;
	-- stage 4
	bv4 <= (others => b3_reg(4));
	bp4 <= unsigned("0" & (bv4 and a3_reg) & "0000");
	pp4_next <= pp3_reg + bp4;
	-- output
	y <= std_logic_vector(pp4_reg);
end pipe_arch;

configuration pipeline_mult_cfg of pipeline_mult is
	for nopipe_arch
	end for;
end pipeline_mult_cfg;
