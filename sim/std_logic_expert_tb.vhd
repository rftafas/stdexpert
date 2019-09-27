-- altera vhdl_input_version vhdl_2008

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
library work;
	use work.std_logic_expert.all;


entity std_logic_expert_tb is
end std_logic_expert_tb;

architecture simulation of std_logic_expert_tb is

	signal vector_unsigned : unsigned(7 downto 0)         := x"55";
	signal vector_signed   : signed(7 downto 0)           := x"f5";
	signal vector_integer  : integer                      := 32;
	signal vector_svl      : std_logic_vector(7 downto 0) := x"f5";
	
	constant ONE_svl     : std_logic_vector(7 downto 0) := (0 => '1', others => '0');
	constant ZERO_svl    : std_logic_vector(7 downto 0) := (others => '0');
	constant TOP_svl     : std_logic_vector(7 downto 0) := (others => '1');

	signal   counter_svl : std_logic_vector(3 downto 0) := "0000";
	signal factor1   : std_logic_vector(3 downto 0) := x"F";
	signal factor2   : std_logic_vector(3 downto 0) := x"2";
	signal product12 : std_logic_vector(7 downto 0) := x"FF";

begin

	assert TOP_svl + ONE_svl = ZERO_svl
		report "Error on + operator between 2 std_logic"
		severity failure;

	assert factor1 * factor2 = x"1E"
		report "Error on * operator between 2 std_logic"
		severity failure;

	process
	begin
		--testando a soma.
		wait for 10 ns;
		counter_svl <= counter_svl + ONE_svl(counter_svl'range);
		product12   <= factor1 * factor2;
		
	end process;
end simulation;