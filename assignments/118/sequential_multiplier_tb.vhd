library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity sequential_multiplier_tb is
end sequential_multiplier_tb;

architecture arch of sequential_multiplier_tb is

  signal clk_i_test        : std_logic;
  signal ready_o_test      : std_logic;
  signal c_o_test          : std_logic_vector(15 downto 0);
  signal c_check_o_test    : std_logic_vector(15 downto 0);
  signal rst_i_test        : std_logic;
  signal start_i_test      : std_logic;
  signal a_i_test          : std_logic_vector(7 downto 0);
  signal b_i_test          : std_logic_vector(7 downto 0);

  component sequential_multiplier
    port(
      clk_i        : in  std_logic;
      ready_o      : out std_logic;
      c_o          : out std_logic_vector(15 downto 0);
      rst_i        : in  std_logic;
      start_i      : in  std_logic;
      a_i          : in  std_logic_vector(7 downto 0);
      b_i          : in  std_logic_vector(7 downto 0));
  end component;

  constant c_T          : time := 2 ns;
  constant c_NUM_0F_CLK : integer := 2621440;
  signal i : integer := 0;
  signal j : integer := 0;
  file output_buf : text;
begin

  uut : sequential_multiplier
    port map(
      a_i     => a_i_test,
      b_i     => b_i_test,
      clk_i   => clk_i_test,
      rst_i   => rst_i_test,
      start_i => start_i_test,
      ready_o => ready_o_test,
      c_o     => c_o_test);


  rst_i_test <= '1', '0' after c_T/2;

  clk : process
  begin
    clk_i_test <= '0';
    wait for c_T/2;
    clk_i_test <= '1';
    wait for c_T/2;

    if i = c_NUM_0F_CLK then
      file_close(output_buf);
      wait;
    else
      i <= i + 1;
    end if;
  end process clk;

  loop_test : process
    variable result : unsigned(15 downto 0);
  begin

    for i in 0 to 255 loop
      b_i_test <= std_logic_vector(to_unsigned(i,8));
      for j in 0 to 255 loop
        start_i_test <= '1';
        a_i_test <= std_logic_vector(to_unsigned(j,8));
        result := to_unsigned(i,8)*to_unsigned(j,8);
        c_check_o_test <= std_logic_vector(result);
        wait for 1 ns;
        start_i_test <= '0';
        wait for 79 ns;
        start_i_test <= '0';
      end loop;
    end loop;
    wait;

  end process loop_test;

  file_open(output_buf, "data_files/test2.csv", write_mode);


  test : process(clk_i_test)
    variable write_col_to_output_buf : line;
    variable counter                 : integer := 25;
    variable temp                    : integer := 0;


  begin
    if rising_edge(clk_i_test) and (rst_i_test /= '1')  then

      if i = 0 then
        write(write_col_to_output_buf, string'("mnozilac,mnozitelj,proizvod,status_testa"));
        writeline(output_buf, write_col_to_output_buf);
      end if;

      temp := 0;

      if i = counter and (to_integer(unsigned(c_check_o_test)) = to_integer(unsigned(c_o_test))) then
        write(write_col_to_output_buf, to_integer(unsigned(a_i_test)));
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, to_integer(unsigned(b_i_test)));
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, to_integer(unsigned(c_o_test)));
        write(write_col_to_output_buf, string'(","));
        counter := counter + 40;
        write(write_col_to_output_buf, string'("OK"));
        writeline(output_buf, write_col_to_output_buf);
      elsif i = counter and (to_integer(unsigned(c_check_o_test)) /= to_integer(unsigned(c_o_test))) then
        write(write_col_to_output_buf, to_integer(unsigned(a_i_test)));
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, to_integer(unsigned(b_i_test)));
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, to_integer(unsigned(c_o_test)));
        write(write_col_to_output_buf, string'(","));
        counter := counter + 40;
        write(write_col_to_output_buf, string'("X"));
        writeline(output_buf, write_col_to_output_buf);
      end if;
    end if;
  end process test;

end arch;