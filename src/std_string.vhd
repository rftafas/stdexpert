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
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package std_string is

	type std_logic_string is array (POSITIVE RANGE <> ) of std_logic_vector(7 downto 0);
	type integer_string   is array (POSITIVE RANGE <> ) of integer range 0 to 255;

	--constant string_map : string(1 to 256) := character'range;

	--VHDL2008 already have functions to convert to string and to hexa_string.
	--to_string and to_hstring from all 'standard' types.
	--For GALOIS_VECTOR and for GREY_VECTOR, we can convert to STD_LOGIC_VECTOR first.

	-- FROM STRING
	-- function to_std_logic_string (input:string) return std_logic_string;
	-- function to_integer_string   (input:string) return integer_string;

	-- TO_STRING
	-- function to_string (input:std_logic_string) return string;


	--Operadores
	function string_replace(l:string; r:string)  return string;
	function string_match  (l:string; r:string)  return boolean;
	function string_length (l:string) 					 return integer;
	function string_padding(l:string; r:positive)return string;

	--TO DO: must overload this with all other string types. There will be pain.

	--function get_char_code (input:character) return integer;

end std_string;

package body std_string is

	-- function to_std_logic_string (input:string) return std_logic_string is
	-- 	variable tmp : to_std_logic_string(input'range);
	-- begin
	-- 	for j in input'range loop
	-- 		tmp(j) := to_std_logic_vector(get_char_code(input(j))-1,8);
	-- 	end loop;
	-- 	return tmp;
	-- end to_std_logic_string;

	function string_replace(l:string; r:string) return string is
		variable ignore   : boolean := false;
		variable tag      : boolean := false;
		variable pointer  : integer := 0;
		variable str_tmp1 : string(l'length downto 1);
		variable str_tmp2 : string(r'length downto 1);
		variable out_tmp  : string(l'length+r'length downto 1);
	begin
		str_tmp1 := l;
		str_tmp2 := r;

		scan_loop : for j in str_tmp1'high downto 1 loop
			if ignore then
				ignore := false;
			elsif str_tmp1(j) = '\' then
				ignore := true;
				next;
			elsif str_tmp1(j) = '%' then
				tag := true;
				next;
			elsif (str_tmp1(j) = 'r' or str_tmp1(j) = 'R') and tag then
				pointer := j;
				exit scan_loop;
			else
				pointer := 0;
				tag     := false;
			end if;
		end loop;

		if pointer = 0 then
			out_tmp := (others=>nul);
			assert true;
				report "Could not find %r on string."
				severity failure;
		elsif pointer = 1 then
			out_tmp(out_tmp'high-2 downto 1) := str_tmp1(str_tmp1'high downto 3) & r;
		elsif pointer = str_tmp1'high-1 then
			out_tmp(out_tmp'high-2 downto 1) := str_tmp2 & str_tmp1(str_tmp1'high-2 downto 1);
		else
			out_tmp(out_tmp'high-2 downto 1) := str_tmp1(str_tmp1'high downto pointer+2) & str_tmp2 & str_tmp1(pointer-1 downto 1);
		end if;
		return out_tmp(out_tmp'high-2 downto 1);
	end string_replace;

	function string_match(l:string; r:string) return boolean is
		variable match    : boolean := false;
		variable str_tmp1 : string(l'length downto 1);
		variable str_tmp2 : string(r'length downto 1);
	begin
		str_tmp1 := l;
		str_tmp2 := r;
		scan_loop : for j in str_tmp2'high downto str_tmp1'high loop
			next when str_tmp2(j downto j-str_tmp1'high+1) /= str_tmp1;
			match := true;
			exit scan_loop;
		end loop;
		return match;
	end string_match;

	function string_length (l:string) 					return integer is
	begin
		return l'length;
	end string_length;

	function string_padding(l:string; r:positive) return string is
		variable tmp : string(1 to r) := (others=>nul);
	begin
		assert l'length < r
			report "Input larger than result size."
			severity failure;
		tmp(r-l'length+1 to r) := l;
		return tmp;
	end string_padding;

--	function get_char_code (input:character) return integer is
--		variable tmp : integer := 0;
--	begin
--			char_loop : for j in string_map'range loop
--				tmp := j;
--				exit char_loop when input = string_map(j);
--			end loop;
--			return j;
--	end get_char_code;

end std_string;
