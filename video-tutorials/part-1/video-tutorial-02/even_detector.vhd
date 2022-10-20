library ieee;
use ieee.std_logic_1164.all;

entity even_detector is
	port
	(
		a	: in  std_logic_vector(2 downto 0);
		even	: out std_logic
	);
end even_detector;

architecture xor_arch of even_detector is
	signal odd : std_logic;
begin
	odd <= a(2) xor a(1) xor a(0);
	even <= not odd;
end xor_arch;

architecture sop_arch of even_detector is
	signal p1, p2, p3, p4 : std_logic;
begin
	even <= (p1 or p2) or (p3 or p4);
	p1 <= (not a(2)) and (not a(1)) and (not a(0));
	p2 <= (not a(2)) and a(1) and a(0);
	p3 <= a(2) and (not a(1)) and a(0);
	p4 <= a(2) and a(1) and (not a(0));
end sop_arch;

architecture str_arch of even_detector is

	component xor2
		port(
			i1, i2 : in std_logic;
			o1 : out std_logic
		);
	end component;
		
	component not1
		port(
			i1 : in std_logic;
			o1 : out std_logic
		);
	end component;

	signal s1, s2 : std_logic;
begin
	u1: xor2
		port map(i1 => a(0), i2 => a(1), o1 => s1);
	u2: xor2
		port map(i1 => a(2), i2 => s1, o1 => s2);
	u3: not1
		port map(i1 => s2, o1 => even);
end str_arch;

configuration even_detector_cfg of even_detector is
	for sop_arch
	end for;
end even_detector_cfg;
