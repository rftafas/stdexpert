-- altera vhdl_input_version vhdl_2008

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
library expert;
	use expert.std_logic_expert.all;

entity modelsim_tb is
end modelsim_tb;

architecture simulation of modelsim_tb is

	signal numerador      : std_logic_vector(7 downto 0) := x"00";
  signal denominador    : std_logic_vector(7 downto 0) := x"00";
  signal quociente      : std_logic_vector(7 downto 0) := x"00";
  signal clk            : std_logic := '0';


begin

    clk <= not clk after 10 ns;

		main : process
	  begin
       for j in 255 downto 0 loop
         for k in 255 downto 1 loop
           numerador   <= std_logic_vector(to_unsigned(j,8));
           denominador <= std_logic_vector(to_unsigned(k,8));
           quociente   <= numerador / denominador;
           wait until rising_edge(clk);
         end loop;
       end loop;

	  end process;

end simulation;
