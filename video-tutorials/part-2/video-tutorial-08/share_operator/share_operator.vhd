library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity share_operator is
   port(
      a,b,c: in std_logic_vector(7 downto 0);
		ctrl: in std_logic;
      r: out std_logic_vector(7 downto 0)
    );
end share_operator;

architecture direct_arch1 of share_operator is
begin
   r <= std_logic_vector(unsigned(a) + unsigned(b)) when ctrl='0' else
		  std_logic_vector(unsigned(a) + unsigned(c));
end direct_arch1;

architecture shared_arch1 of share_operator is
	signal src0 : std_logic_vector(7 downto 0);
begin
   src0 <= b when ctrl='0' else
		     c;
	r <= std_logic_vector(unsigned(a) + unsigned(src0));
end shared_arch1;

configuration share_operator_cfg of share_operator is
	for direct_arch1
	end for;
end share_operator_cfg;

--entity share_operator is
--   port(
--      a,b,c,d: in std_logic_vector(7 downto 0);
--		ctrl: in std_logic_vector(1 downto 0);
--      r: out std_logic_vector(7 downto 0)
--    );
--end share_operator;
--
--architecture direct_arch2 of share_operator is
--begin
--	process(a,b,c,d)
--	begin
--		if ctrl = "00" then
--			r <= std_logic_vector(unsigned(a) + unsigned(b));
--		elsif ctrl = "01" then
--			r <= std_logic_vector(unsigned(a) + unsigned(c));
--		else
--			r <= std_logic_vector(unsigned(d) + 1);
--		end if;
--	end process;
--end direct_arch2;
--
--architecture shared_arch2 of share_operator is
--	signal src0, src1 : unsigned(7 downto 0);
--begin
--	process(a,b,c,d)
--	begin
--		if ctrl = "00" then
--			src0 <= unsigned(a);
--			src1 <= unsigned(b);
--		elsif ctrl = "01" then
--			src0 <= unsigned(a);
--			src1 <= unsigned(c);
--		else
--			src0 <= unsigned(a);
--			src1 <= "00000001";
--		end if;
--	end process;
--	r <= std_logic_vector(src0 + src1);
--end shared_arch2;
--
--architecture direct_arch3 of share_operator is
--begin
--	with ctrl select
--		r <= std_logic_vector(unsigned(a) + unsigned(b)) when "00",
--		     std_logic_vector(unsigned(a) + unsigned(c)) when "01",
--			  std_logic_vector(unsigned(d) + 1) when others;
--end direct_arch3;
--
--architecture shared_arch3 of share_operator is
--	signal src0, src1 : unsigned(7 downto 0);
--begin
--	with ctrl select
--		src0 <= unsigned(a) when "00"|"01",
--				  unsigned(d) when others;
--	with ctrl select
--		src1 <= unsigned(b) when "00",
--				  unsigned(c) when "01",
--				  "00000001" when others;
--	r <= std_logic_vector(src0 + src1);
--end shared_arch3;
--
--configuration share_operator_cfg of share_operator is
--	for direct_arch2
--	end for;
--end share_operator_cfg;

--entity share_operator is
--   port(
--      a,b,c,d: in std_logic_vector(7 downto 0);
--		ctrl: in std_logic;
--      x: out std_logic_vector(7 downto 0);
--		y: out std_logic_vector(7 downto 0)
--    );
--end share_operator;
--
--architecture direct_arch4 of share_operator is
--begin
--	process(a,b,c,d)
--	begin
--		if ctrl = '0' then
--			x <= std_logic_vector(unsigned(a) + unsigned(b));
--			y <= (others => '0');
--		else
--			x <= "00000001";
--			y <= std_logic_vector(unsigned(c) + unsigned(d));
--		end if;
--	end process;
--end direct_arch4;
--
--architecture shared_arch4 of share_operator is
--	signal src0, src1 : unsigned(7 downto 0);
--	signal sum : std_logic_vector(7 downto 0);
--begin
--	process(a,b,c,d)
--	begin
--		if ctrl = '0' then
--			src0 <= unsigned(a);
--			src1 <= unsigned(b);
--			x <= sum;
--			y <= (others => '0');
--		else
--			src0 <= unsigned(c);
--			src1 <= unsigned(d);
--			x <= "00000001";
--			y <= sum;
--		end if;
--	end process;
--	sum <= std_logic_vector(src0 + src1);
--end shared_arch4;
--
--configuration share_operator_cfg of share_operator is
--	for direct_arch4
--	end for;
--end share_operator_cfg;
