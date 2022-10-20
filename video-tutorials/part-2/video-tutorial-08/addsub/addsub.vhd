library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub is
   port (
      a,b: in std_logic_vector(7 downto 0);
      ctrl: in std_logic;
      r: out  std_logic_vector(7 downto 0)
   );
end addsub;

architecture direct_arch of addsub is
   signal src0, src1, sum: signed(7 downto 0);
begin
   src0 <= signed(a);
   src1 <= signed(b);
   sum <= src0 + src1 when ctrl='0' else
          src0 - src1;
   r <= std_logic_vector(sum);
end direct_arch;

architecture shared_arch of addsub is
   signal src0, src1, sum: signed(8 downto 0);
   signal b_tmp: std_logic_vector(7 downto 0);
   signal cin: std_logic; -- carry-in bit
begin
   src0 <= signed(a & '1');
   b_tmp <= b when ctrl='0' else
            not b;
   cin <= '0' when ctrl='0' else
          '1';
   src1 <= signed(b_tmp & cin);
   sum <= src0 + src1;
   r <= std_logic_vector(sum(8 downto 1));
end shared_arch;

configuration addsub_cfg of addsub is
	for direct_arch
	end for;
end addsub_cfg;
