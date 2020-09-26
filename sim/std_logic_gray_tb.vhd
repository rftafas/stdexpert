----------------------------------------------------------------------------------
--Copyright 2020 Ricardo F Tafas Jr

--Licensed under the Apache License, Version 2.0 (the "License"); you may not
--use this file except in compliance with the License. You may obtain a copy of
--the License at

--   http://www.apache.org/licenses/LICENSE-2.0

--Unless required by applicable law or agreed to in writing, software distributed
--under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
--OR CONDITIONS OF ANY KIND, either express or implied. See the License for
--the specific language governing permissions and limitations under the License.
----------------------------------------------------------------------------------
-- altera vhdl_input_version vhdl_2008
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
library expert;
	use expert.std_logic_gray.all;
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

		constant tmp_slice    : std_logic_vector(23 downto 16) := x"05";

	begin

			main : process
				variable tmp_svl1    : std_logic_vector(7 downto 0) := x"04";
				variable tmp_svl2    : std_logic_vector(7 downto 0) := x"06";
				variable tmp_gv      : gray_vector(7 downto 0)      := x"06";
				variable tmp_int1    : integer := 4;
				variable tmp_uns1    : unsigned(7 downto 0) := x"04";

		  begin
		    test_runner_setup(runner, runner_cfg);

				while test_suite loop
					if run("Sanity check for system.") then
						report "System Sane. Begin tests.";
						check_true(true, result("Sanity check for system."));

					elsif run("Testing gray_encoder(std_logic_vector)") then
						check_equal( gray_encoder(tmp_svl1),tmp_svl2,result("gray_encoder(std_logic_vector)"));

					elsif run("Testing gray_decoder(std_logic_vector)") then
						check_equal( gray_decoder(tmp_svl2), tmp_svl1,result("gray_encoder(std_logic_vector)"));

					elsif run("testing constant creation") then
						tmp_gv := create_gray_vector("00000110");
						for j in tmp_gv'range loop
							check_equal(tmp_gv(j),tmp_svl2(j), result("create_gray_vector(00000110)"));
						end loop;
						check_equal(translate2svl(tmp_gv),tmp_svl2, result("translate2svl(tmp_gv)"));

					elsif run("to_gray_vector(std_logic_vector)") then
						info(to_string(tmp_svl1));
						info(to_string(translate2svl(to_gray_vector(tmp_svl1))));
						check_true(to_gray_vector(tmp_svl1) = tmp_gv,result("to_gray_vector(std_logic_vector)"));

					elsif run("to_gray_vector(unsigned)") then
						info(to_string(tmp_uns1));
						info(to_string(translate2svl(to_gray_vector(tmp_uns1))));
						check_true(to_gray_vector(tmp_uns1)   = tmp_gv,result("to_gray_vector(unsigned)"));

					elsif run("to_gray_vector(integer)") then
						info(to_string(tmp_int1));
						info(to_string(translate2svl(to_gray_vector(tmp_int1,8))));
						check_true(to_gray_vector(tmp_int1,8) = tmp_gv,result("to_gray_vector(integer,integer)"));

					elsif run("From gray_vector functions") then
						check_true(to_std_logic_vector(tmp_gv) = tmp_svl1,result("to_unsigned(gray_vector)"));
						check_true(to_unsigned(tmp_gv)         = tmp_uns1,result("to_unsigned(gray_vector)"));
						check_true(to_integer(tmp_gv)          = tmp_int1,result("to_integer(gray_vector)"));

					elsif run("Testing '+'") then
						tmp_int1 := to_integer(tmp_gv + tmp_gv);
						check_equal(tmp_int1,8,result("gray_vector + gray_vector"));
						tmp_int1 := to_integer(tmp_gv + 4);
						check_equal(tmp_int1,8,result("gray_vector + integer"));
						tmp_int1 := to_integer(tmp_gv + tmp_uns1);
						check_equal(tmp_int1,8,result("gray_vector + unsigned"));
						tmp_int1 := to_integer(tmp_gv + tmp_svl1);
						check_equal(tmp_int1,8,result("gray_vector + std_logic_vector"));

					elsif run("Testing '-'") then
						tmp_int1 := to_integer(tmp_gv - tmp_gv);
						check_equal(tmp_int1,0,result("gray_vector - gray_vector"));
						tmp_int1 := to_integer(tmp_gv - 4);
						check_equal(tmp_int1,0,result("gray_vector - integer"));
						tmp_int1 := to_integer(tmp_gv - tmp_uns1);
						check_equal(tmp_int1,0,result("gray_vector - unsigned"));
						tmp_int1 := to_integer(tmp_gv - tmp_svl1);
						check_equal(tmp_int1,0,result("gray_vector - std_logic_vector"));

					elsif run("Testing '*'") then
						Info("Operator '*' not implemented for GALOIS_VECTOR");

					elsif run("Testing '/'") then
						Info("Operator '/' not implemented for GALOIS_VECTOR");

					elsif run("Testing 'mod'") then
						Info("Operator 'mod' not implemented for GALOIS_VECTOR");


					elsif run("Testing 'rem'") then
						Info("Operator 'rem' not implemented for GALOIS_VECTOR");


					elsif run("Testing '='") then
						check_true(tmp_gv = tmp_gv, result("std_logic_vector = integer"));
						check_false(tmp_gv = (tmp_gv+1), result("std_logic_vector = integer."));

					elsif run("Testing '/='") then
						check_true(tmp_gv /= (tmp_gv+1), result("std_logic_vector /= integer"));
						check_false(tmp_gv /= tmp_gv, result("std_logic_vector /= integer."));

					elsif run("Testing '>'") then
						check_true(tmp_gv+1 > tmp_gv, result("std_logic_vector > integer"));
						check_false(tmp_gv > tmp_gv, result("std_logic_vector > integer."));

					elsif run("Testing '<'") then
						check_true(tmp_gv < tmp_gv+1, result("std_logic_vector < integer"));
						check_false(tmp_gv < tmp_gv, result("std_logic_vector < integer."));

					elsif run("Testing '<='") then
						check_true(tmp_gv <= tmp_gv, result("std_logic_vector <= integer"));
						check_false(tmp_gv+1 <= tmp_gv, result("std_logic_vector <= integer."));

					elsif run("Testing '>='") then
						check_true(tmp_gv >= tmp_gv, result("std_logic_vector >= integer"));
						check_false(tmp_gv >= tmp_gv+1, result("std_logic_vector >= integer."));

					elsif run("Testing 'rol'") then
						Info("Operator 'rol' not implemented for GALOIS_VECTOR");

					elsif run("Testing 'ror'") then
						Info("Operator 'ror' not implemented for GALOIS_VECTOR");

					end if;

				end loop;
		    test_runner_cleanup(runner); -- Simulation ends here
		  end process;

	end simulation;
