-- altera vhdl_input_version vhdl_2008

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
library expert;
	use expert.std_logic_expert.all;
library vunit_lib;
	context vunit_lib.vunit_context;


entity std_logic_gray_tb is
	generic (runner_cfg : string);
end std_logic_gray_tb;

architecture simulation of std_logic_gray_tb is

	signal vector_unsigned : unsigned(7 downto 0)         := x"55";
	signal vector_signed   : signed(7 downto 0)           := x"f5";
	signal vector_integer  : integer                      := 32;
	signal vector_svl      : std_logic_vector(7 downto 0) := x"f5";

	constant ONE_svl     : std_logic_vector(7 downto 0) := (0 => '1', others => '0');
	constant ZERO_svl    : std_logic_vector(7 downto 0) := (others => '0');
	constant TOP_svl     : std_logic_vector(7 downto 0) := (others => '1');

	signal test_tmp : boolean;

begin

	assert TOP_svl + ONE_svl = ZERO_svl
		report "Error on + operator between 2 std_logic"
		severity failure;

		main : process
			variable tmp_svl1    : std_logic_vector(7 downto 0) := x"05";
			variable tmp_svl2    : std_logic_vector(7 downto 0) := x"05";
			variable tmp_int1    : integer := 5;
			variable tmp_int2    : integer := 6;

	  begin
	    test_runner_setup(runner, runner_cfg);
			tmp_svl1 := x"05";

			while test_suite loop
				if run("Sanity check for system.") then
					report "System Sane. Begin tests.";
					check_true(true, result("Sanity check for system."));
				elsif run("Testing '=' comparator for std_logic_vector") then

					check_true(tmp_svl1 = 5, result("comparator std_logic_vector/integer."));
					check_false(tmp_svl1 = 6, result("comparator std_logic_vector/integer."));

					check_true( 5 = tmp_svl1, result("comparator integer/std_logic_vector."));
					check_false(6 = tmp_svl1, result("comparator integer/std_logic_vector."));

					check_true( tmp_svl1 = to_unsigned(5,8), result("comparator std_logic_vector/unsigned."));
					check_false(tmp_svl1 = to_unsigned(6,8), result("comparator std_logic_vector/unsigned."));

					check_true( to_unsigned(5,8) = tmp_svl1, result("comparator unsigned/std_logic_vector."));
					check_false(to_unsigned(6,8) = tmp_svl1, result("comparator unsigned/std_logic_vector."));

					check_true( to_std_logic_vector(5,8) = tmp_svl1, result("comparator std_logic_vector/std_logic_vector."));
					check_false(to_std_logic_vector(6,8) = tmp_svl1, result("comparator std_logic_vector/std_logic_vector."));

				elsif run("Testing '>' comparator for std_logic_vector") then
					check_true( tmp_svl1 > 4, result("comparator std_logic_vector/integer."));
					check_false(tmp_svl1 > 6, result("comparator std_logic_vector/integer."));

					check_true( 6 > tmp_svl1, result("comparator integer/std_logic_vector."));
					check_false(4 > tmp_svl1, result("comparator integer/std_logic_vector."));

					check_true( tmp_svl1 > to_unsigned(4,8), result("comparator std_logic_vector/unsigned."));
					check_false(tmp_svl1 > to_unsigned(6,8), result("comparator std_logic_vector/unsigned."));

					check_true( to_unsigned(6,8) > tmp_svl1, result("comparator unsigned/std_logic_vector."));
					check_false(to_unsigned(4,8) > tmp_svl1, result("comparator unsigned/std_logic_vector."));

				--elsif run("testing sum between std_logic_vector") then
				elsif run("testing sum between std_logic_vector") then
										  tmp_svl1 := tmp_svl1 + tmp_svl1;
					  -- tmp_int1 := to_integer(unsigned(tmp_svl1));
						check_equal(tmp_int1,10,result("test"));
				elsif run("testing sum with integer") then

				end if;

			end loop;
	    test_runner_cleanup(runner); -- Simulation ends here
	  end process;

end simulation;
