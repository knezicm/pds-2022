library ieee;
use ieee.std_logic_1164.all;

entity prio42 is
   port(
      r4: in std_logic_vector(3 downto 0);
      code2: out std_logic_vector(1 downto 0);
      act42: out std_logic
   );
end prio42;

architecture cascade_arch of prio42 is
begin
   code2 <= "11"  when r4(3)='1'  else
            "10"  when r4(2)='1'  else
            "01"  when r4(1)='1'  else
            "00";
   act42 <= r4(3) or r4(2) or r4(1) or r4(0);
end cascade_arch;