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
	use expert.std_logic_expert.all;
library vunit_lib;
	context vunit_lib.vunit_context;


entity std_logic_expert_tb is
	generic (runner_cfg : string);
end std_logic_expert_tb;

architecture simulation of std_logic_expert_tb is

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

	assert TOP_svl + ONE_svl = ZERO_svl
		report "Error on + operator between 2 std_logic"
		severity failure;

		main : process
			variable range_v     : range_t;
			variable tmp_svl1    : std_logic_vector(7 downto 0) := x"05";
			variable tmp_svl2    : std_logic_vector(0 downto 0) := "0";
			variable tmp_uns1    : unsigned(7 downto 0) := x"05";
			variable tmp_sig1    : signed(7 downto 0) := x"05";
			variable tmp_int1    : integer := 5;
			variable tmp_int2    : integer := 6;
			variable tmp_int_vec : integer_vector(7 downto 0) := (0=>0,1=>1,2=>2,3=>3,4=>4,5=>5,6=>6,7=>7);
			variable large_slice  : std_logic_vector(1023 downto 0) := (others=>'0');

	  begin
	    test_runner_setup(runner, runner_cfg);
			tmp_svl1 := x"05";

			while test_suite loop
				if run("Sanity check for system.") then
					report "System Sane. Begin tests.";
					check_true(true, result("Sanity check for system."));
				elsif run("testing starndized typecasts") then
					check_equal(to_integer(tmp_svl1),5,result("to_integer(std_logic_vector)"));
					check_equal(tmp_int1,to_std_logic_vector(5,8),result("to_std_logic_vector(integer,size)"));
					check_equal(to_std_logic_vector('0'),tmp_svl2,result("to_std_logic_vector(std_logic)"));
					check_equal(to_unsigned(tmp_svl1),tmp_uns1,result("to_unsigned(std_logic_vector)"));
					check_equal(to_signed(tmp_svl1),tmp_sig1,result("to_signed(std_logic_vector)"));

			  elsif run("testing constant creation") then
					check_equal(tmp_svl1,create_std_logic_vector("00000101"), result("create_std_logic_vector(std_logic_vector)"));
					check_equal(tmp_uns1,create_unsigned("00000101"), result("create_unsigned(std_logic_vector)"));
					check_equal(tmp_sig1,create_signed("00000101"), result("create_signed(std_logic_vector)"));

				elsif run("Testing '+'") then
					tmp_int1 := to_integer(tmp_svl1 + tmp_svl1);
					check_equal(tmp_int1,10,result("std_logic_vector + std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 + 5);
					check_equal(tmp_int1,10,result("std_logic_vector + integer"));
					tmp_int1 := 5 + tmp_svl1;
					check_equal(tmp_int1,10,result("integer + std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 + tmp_uns1);
					check_equal(tmp_int1,10,result("std_logic_vector + unsigned"));
					tmp_int1 := to_integer(tmp_uns1 + tmp_svl1);
					check_equal(tmp_int1,10,result("unsigned + std_logic_vector"));

				elsif run("Testing '-'") then
					tmp_int1 := to_integer(tmp_svl1 - tmp_svl1);
					check_equal(tmp_int1,0,result("std_logic_vector - std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 - 5);
					check_equal(tmp_int1,0,result("std_logic_vector - integer"));
					tmp_int1 := 5 - tmp_svl1;
					check_equal(tmp_int1,0,result("integer - std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 - tmp_uns1);
					check_equal(tmp_int1,0,result("std_logic_vector - unsigned"));
					tmp_int1 := to_integer(tmp_uns1 - tmp_svl1);
					check_equal(tmp_int1,0,result("unsigned - std_logic_vector"));

				elsif run("Testing '*'") then
					tmp_int1 := to_integer(tmp_svl1 * tmp_svl1);
					check_equal(tmp_int1,25,result("std_logic_vector * std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 * 5);
					check_equal(tmp_int1,25,result("std_logic_vector * integer"));
					tmp_int1 := 5 * tmp_svl1;
					check_equal(tmp_int1,25,result("integer * std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 * tmp_uns1);
					check_equal(tmp_int1,25,result("std_logic_vector * unsigned"));
					tmp_int1 := to_integer(tmp_uns1 * tmp_svl1);
					check_equal(tmp_int1,25,result("unsigned * std_logic_vector"));

				elsif run("Testing '/'") then
					tmp_int1 := to_integer(tmp_svl1 / tmp_svl1);
					check_equal(tmp_int1,1,result("std_logic_vector / std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 / 5);
					check_equal(tmp_int1,1,result("std_logic_vector / integer"));
					tmp_int1 := 5 / tmp_svl1;
					check_equal(tmp_int1,1,result("integer / std_logic_vector"));
					tmp_int1 := to_integer(tmp_svl1 / tmp_uns1);
					check_equal(tmp_int1,1,result("std_logic_vector / unsigned"));
					tmp_int1 := to_integer(tmp_uns1 / tmp_svl1);
					check_equal(tmp_int1,1,result("unsigned / std_logic_vector"));

				elsif run("Testing 'mod'") then
					tmp_int1 := to_integer((tmp_svl1+1) mod 5);
					check_equal(tmp_int1,1,result("std_logic_vector mod integer"));
					tmp_int1 := 6 mod tmp_svl1;
					check_equal(tmp_int1,1,result("integer mod std_logic_vector"));
					tmp_int1 := to_integer( (tmp_svl1+1) mod tmp_uns1);
					check_equal(tmp_int1,1,result("std_logic_vector mod unsigned"));
					tmp_int1 := to_integer( to_unsigned(6,8) mod tmp_svl1 );
					check_equal(tmp_int1,1,result("unsigned mod std_logic_vector"));
					tmp_int1 := to_integer( (tmp_svl1+1) mod tmp_svl1 );
					check_equal(tmp_int1,1,result("std_logic_vector mod std_logic_vector"));

				elsif run("Testing 'rem'") then
					tmp_int1 := to_integer((tmp_svl1+1) rem 5);
					check_equal(tmp_int1,1,result("std_logic_vector rem integer"));
					tmp_int1 := 6 rem tmp_svl1;
					check_equal(tmp_int1,1,result("integer rem std_logic_vector"));
					tmp_int1 := to_integer( (tmp_svl1+1) rem tmp_uns1);
					check_equal(tmp_int1,1,result("std_logic_vector rem unsigned"));
					tmp_int1 := to_integer( to_unsigned(6,8) rem tmp_svl1 );
					check_equal(tmp_int1,1,result("unsigned rem std_logic_vector"));
					tmp_int1 := to_integer( (tmp_svl1+1) rem tmp_svl1 );
					check_equal(tmp_int1,1,result("std_logic_vector rem std_logic_vector"));


				elsif run("Testing '='") then
					check_true(tmp_svl1 = 5, result("std_logic_vector = integer"));
					check_false(tmp_svl1 = 6, result("std_logic_vector = integer."));
					check_true( 5 = tmp_svl1, result("integer = std_logic_vector."));
					check_false(6 = tmp_svl1, result("integer = std_logic_vector."));
					check_true( tmp_svl1 = to_unsigned(5,8), result("std_logic_vector = unsigned."));
					check_false(tmp_svl1 = to_unsigned(6,8), result("std_logic_vector = unsigned."));
					check_true( to_unsigned(5,8) = tmp_svl1, result("unsigned = std_logic_vector."));
					check_false(to_unsigned(6,8) = tmp_svl1, result("unsigned = std_logic_vector."));
					check_true( to_std_logic_vector(5,8) = tmp_svl1, result("std_logic_vector = std_logic_vector."));
					check_false(to_std_logic_vector(6,8) = tmp_svl1, result("std_logic_vector = std_logic_vector."));
					check_true( tmp_svl1 = tmp_svl1, result("std_logic_vector = std_logic_vector."));
					check_false( (tmp_svl1+1) = tmp_svl1, result("std_logic_vector = std_logic_vector."));

				elsif run("Testing '>'") then
					check_true(tmp_svl1 > 4, result("std_logic_vector > integer"));
					check_false(tmp_svl1 > 6, result("std_logic_vector > integer."));
					check_true( 6 > tmp_svl1, result("integer > std_logic_vector."));
					check_false(4 > tmp_svl1, result("integer > std_logic_vector."));
					check_true( tmp_svl1 > to_unsigned(4,8), result("std_logic_vector > unsigned."));
					check_false(tmp_svl1 > to_unsigned(6,8), result("std_logic_vector > unsigned."));
					check_true( to_unsigned(6,8) > tmp_svl1, result("unsigned > std_logic_vector."));
					check_false(to_unsigned(4,8) > tmp_svl1, result("unsigned > std_logic_vector."));
					check_true( to_std_logic_vector(6,8) > tmp_svl1, result("std_logic_vector > std_logic_vector."));
					check_false(to_std_logic_vector(4,8) > tmp_svl1, result("std_logic_vector > std_logic_vector."));

				elsif run("Testing '<'") then
					check_true(tmp_svl1 < 6, result("std_logic_vector < integer"));
					check_false(tmp_svl1 < 4, result("std_logic_vector < integer."));
					check_true( 4 < tmp_svl1, result("integer < std_logic_vector."));
					check_false(6 < tmp_svl1, result("integer < std_logic_vector."));
					check_true( tmp_svl1 < to_unsigned(6,8), result("std_logic_vector < unsigned."));
					check_false(tmp_svl1 < to_unsigned(4,8), result("std_logic_vector < unsigned."));
					check_true( to_unsigned(4,8) < tmp_svl1, result("unsigned < std_logic_vector."));
					check_false(to_unsigned(6,8) < tmp_svl1, result("unsigned < std_logic_vector."));
					check_true( to_std_logic_vector(4,8) < tmp_svl1, result("std_logic_vector < std_logic_vector."));
					check_false(to_std_logic_vector(6,8) < tmp_svl1, result("std_logic_vector < std_logic_vector."));

				--elsif run("Testing '>='") then
				--elsif run("Testing '<='") then
				elsif run("Testing 'rol'") then
					check_equal( (tmp_svl1 rol to_std_logic_vector(4,8)), ( tmp_svl1(3 downto 0) & tmp_svl1(7 downto 4) ) ,result("integer rol std_logic_vector"));
					check_equal( (tmp_svl1 rol to_unsigned(4,8)), ( tmp_svl1(3 downto 0) & tmp_svl1(7 downto 4) ) ,result("integer rol std_logic_vector"));
					check_true ( (tmp_int_vec rol 4)=( tmp_int_vec(3 downto 0) & tmp_int_vec(7 downto 4) ) ,result("integer_vector rol integer"));

				elsif run("Testing 'ror'") then
					check_equal( (tmp_svl1 ror to_std_logic_vector(4,8)), ( tmp_svl1(3 downto 0) & tmp_svl1(7 downto 4) ) ,result("integer rol std_logic_vector"));
					check_equal( (tmp_svl1 ror to_unsigned(4,8)), ( tmp_svl1(3 downto 0) & tmp_svl1(7 downto 4) ) ,result("integer rol std_logic_vector"));
					check_true ( (tmp_int_vec ror 4)=( tmp_int_vec(3 downto 0) & tmp_int_vec(7 downto 4) ) ,result("integer_vector rol integer"));

				elsif run("Testing size_of(integer)") then
					check_equal( size_of(0), 1,result("size_of(0)"));
					check_equal( size_of(1), 1,result("size_of(1)"));
					check_equal( size_of(2), 2,result("size_of(2)"));
					check_equal( size_of(256), 9,result("size_of(integer)"));
					check_equal( size_of(257), 9,result("size_of(integer)"));

				elsif run("Testing size_of(integer,word_size_integer)") then
					check_equal( size_of(0,8), 1,result("size_of(integer,integer)"));
					check_equal( size_of(1,8), 1,result("size_of(integer,integer)"));
					check_equal( size_of(255,8), 1,result("size_of(integer,integer)"));
					check_equal( size_of(256,8), 2,result("size_of(integer,integer)"));
					check_equal( size_of(1024,8), 2,result("size_of(integer,integer)"));
					check_equal( size_of(65535,8), 2,result("size_of(integer,integer)"));
					check_equal( size_of(65536,8), 3,result("size_of(integer,integer)"));

				elsif run("Testing index_of(std_logic_vector)") then
					check_equal( index_of(tmp_slice),2,result("size_of(integer,integer)"));

				elsif run("Testing range_of(position, word_size_integer)") then
					range_v     := range_of(1, 8);
					check_equal( range_v.high, 15,result("range_of(std_logic_vector)"));
					check_equal( range_v.low, 8,result("range_of(std_logic_vector)"));
					range_v     := range_of(5, 8);
					check_equal( range_v.high, 47,result("range_of(std_logic_vector)"));
					check_equal( range_v.low, 40,result("range_of(std_logic_vector)"));

				elsif run("Testing set_slice(std_logic_vector, value_to_add, index)") then
					range_v     := range_of(5, 8);
					large_slice := set_slice(large_slice,tmp_svl1,5);
					check_equal( large_slice(range_v.high downto range_v.low), tmp_svl1,result("set_slice(std_logic_vector,std_logic_vector,integer)"));

				elsif run("Testing get_slice(std_logic_vector, word_size_integer, index)") then
					large_slice := set_slice(large_slice,tmp_svl1,5);
					check_equal( get_slice(large_slice,8,5),tmp_svl1,result("get_slice(std_logic_vector,integer,integer)"));

				elsif run("Testing to_range(std_logic_vector)") then
					range_v := to_range(tmp_slice);
					check_equal( range_v.high, tmp_slice'high,result("to_range(std_logic_vector)"));
					check_equal( range_v.low, tmp_slice'low,result("to_range(std_logic_vector)"));

				elsif run("Testing index_of_1(std_logic_vector)") then
					check_equal(index_of_1(tmp_svl1),2,result("index_of_1(00000101)"));

				elsif run("Testing index_of_0(11001100)") then
					check_equal(index_of_0(create_std_logic_vector("11001100")),5,result("all_1(8)"));

				elsif run("Testing all_1(integer)") then
					check_equal(all_1(8),TOP_svl,result("all_1(8)"));

				elsif run("Testing all_0(integer)") then
					check_equal(all_0(8),ZERO_svl,result("all_0(8)"));

				end if;

			end loop;
	    test_runner_cleanup(runner); -- Simulation ends here
	  end process;

end simulation;
