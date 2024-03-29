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
-- DESCRIPTION
-- VHDL2008 came with the NUMERIC_STD package. It comes as a replacement of STD_LOGIC_ARITH,
-- STD_LOGIC_SIGNED and STD_LOGIC_UNSIGNED.
-- This comes as a very annoying issue:
-- 1) to address a memory from its std_logic_vector port, one must:
-- ram_output <= ram_signal(to_integer(unsigned(ram_addr)));
-- 2) you cannot create counters with std_logic
-- and so on.
-- This library is very like the STD_LOGIC_ARITH, except it is compatible to NUMERIC_STD
-- and should be used with it.
-- IMPORTANT: it does not implement STD_LOGIC_SIGNED. Signed numbers usually must be properly treated.
----------------------------------------------------------------------------------
-- Features:
--1) fixes the annoying "TO_INTEGER", "TO_SIGNED" and "TO_UNSIGNED" typecasts.
--2) defines +, -, * for std_logic types. Always UNSIGNED. Usually we just want to convert indexing
--   using STD_LOGIC_VECTORs. and to be honest, if you are doing math with STD_LOGIC without carefully
--   evaluating the type you are using, you are doing it wrong.
----------------------------------------------------------------------------------
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package std_logic_expert is

	type range_t is record
		high  : integer;
		low   : integer;
	end record range_t;

	type range_vector is array (NATURAL RANGE <>) of std_logic;
	type std_logic_array is array (NATURAL RANGE <>) of std_logic_vector;

	--Use this function whenever you get overload problems. Overload problems also
	--plague numeric_std. If one wants to create a vector and just it and add to mathematical
	--functions or comparators, it is best to specify what king of constant is being created.
	--NOTE: of course, one can use prefixes, but not all tools are found of them.
	--prefix usage example: if data = std_logic_vector'("0011001100") then
	function create_std_logic_vector ( input : std_logic_vector ) return std_logic_vector;
	function create_unsigned         ( input : std_logic_vector ) return unsigned;
	function create_signed           ( input : std_logic_vector ) return signed;

	function to_integer         ( input : std_logic_vector       ) return integer;
	function to_std_logic_vector( input : integer; size : integer) return std_logic_vector;
	function to_std_logic_vector( input : std_logic              ) return std_logic_vector;
	function to_std_logic_vector( input : unsigned               ) return std_logic_vector;
	function to_unsigned        ( input : std_logic_vector       ) return unsigned;
	function to_signed          ( input : std_logic_vector       ) return signed;

	function "+" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "+" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "+" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "+" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "+" (l:integer         ; r: std_logic_vector) return integer;

	function "-" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "-" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "-" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "-" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "-" (l:integer         ; r: std_logic_vector) return integer;

	function "*" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "*" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "*" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "*" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "*" (l:integer         ; r: std_logic_vector) return integer;

	function "/" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "/" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "/" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "/" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "/" (l:integer         ; r: std_logic_vector) return integer;

	function "mod" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "mod" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "mod" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "mod" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "mod" (l:integer         ; r: std_logic_vector) return integer;

	function "rem" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	function "rem" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "rem" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "rem" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	function "rem" (l:integer         ; r: std_logic_vector) return integer;

	function "=" (l:std_logic_vector; r: integer)          return boolean;
	function "=" (l:integer;          r: std_logic_vector) return boolean;
	function "=" (l:std_logic_vector; r: unsigned)         return boolean;
	function "=" (l:unsigned;         r: std_logic_vector) return boolean;

	function "/=" (l:std_logic_vector; r: integer)          return boolean;
	function "/=" (l:integer;          r: std_logic_vector) return boolean;
	function "/=" (l:std_logic_vector; r: unsigned)         return boolean;
	function "/=" (l:unsigned;         r: std_logic_vector) return boolean;

	function ">" (l:std_logic_vector; r: integer         ) return boolean;
	function ">" (l:integer;          r: std_logic_vector) return boolean;
	function ">" (l:std_logic_vector; r: unsigned        ) return boolean;
	function ">" (l:unsigned;         r: std_logic_vector) return boolean;

	function "<" (l:std_logic_vector; r: integer         ) return boolean;
	function "<" (l:integer;          r: std_logic_vector) return boolean;
	function "<" (l:std_logic_vector; r: unsigned        ) return boolean;
	function "<" (l:unsigned;         r: std_logic_vector) return boolean;

	function ">=" (l:std_logic_vector; r: integer         ) return boolean;
	function ">=" (l:integer;          r: std_logic_vector) return boolean;
	function ">=" (l:std_logic_vector; r: unsigned        ) return boolean;
	function ">=" (l:unsigned;         r: std_logic_vector) return boolean;

	function "<=" (l:std_logic_vector; r: integer         ) return boolean;
	function "<=" (l:integer;          r: std_logic_vector) return boolean;
	function "<=" (l:std_logic_vector; r: unsigned        ) return boolean;
	function "<=" (l:unsigned;         r: std_logic_vector) return boolean;

	--Shift operators
	function "rol" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "rol" (l:std_logic_vector; r: unsigned) return std_logic_vector;
	function "rol" (l:integer_vector;   r: integer ) return integer_vector;
	function "rol" (l:integer_vector;   r: unsigned) return integer_vector;

	function "ror" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "ror" (l:std_logic_vector; r: unsigned) return std_logic_vector;
	function "ror" (l:integer_vector;   r:  integer) return integer_vector;
  	function "ror" (l:integer_vector;   r: unsigned) return integer_vector;

	--index operations
	function size_of    ( input : integer                          ) return integer;
	function size_of    ( input : integer;          word : integer ) return integer;
	function index_of   ( input : std_logic_vector                 ) return integer;
	function range_of   ( input : integer;         	word : integer ) return range_t;

	function get_slice  (
		input : std_logic_vector;
		word  : integer;
		index : integer
	) return std_logic_vector;

	function set_slice (
		input  : std_logic_vector;
		input2 : std_logic_vector;
		index  : integer
	) return std_logic_vector;

	function to_range   (	input : std_logic_vector ) return range_t;
	function index_of_1 (	input : std_logic_vector ) return integer;
	function index_of_0 (	input : std_logic_vector ) return integer;
	function all_1      (	input : integer          ) return std_logic_vector;
	function all_0      (	input : integer          ) return std_logic_vector;

end std_logic_expert;

package body std_logic_expert is

	----------------------------------------------------------------------------------------------
  	--CREATES STD_LOGIC_VECTOR CONSTANTS TO LET NO DOUBTS DUE TO OVERLOADING.
	function create_std_logic_vector( input : std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(input'length-1 downto 0);
	begin
		tmp := input;
		return tmp;
	end create_std_logic_vector;

	function create_unsigned( input : std_logic_vector) return unsigned is
		variable tmp : unsigned(input'length-1 downto 0);
	begin
		tmp := unsigned(input);
		return tmp;
	end create_unsigned;

	function create_signed( input : std_logic_vector) return signed is
		variable tmp : signed(input'length-1 downto 0);
	begin
		tmp := signed(input);
		return tmp;
	end create_signed;
	----------------------------------------------------------------------------------------------
	--TO INTEGER
	function to_integer( input : std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := to_integer(unsigned(input));
		return tmp;
	end to_integer;

  	--TO STD_LOGIC_VECTOR
	function to_std_logic_vector( input : integer; size : integer) return std_logic_vector is
		variable tmp : std_logic_vector(size-1 downto 0);
  	begin
		assert size > 0
			report "Vector size on conversion must be greater than 0."
			severity failure;
		assert size > 1
			report "Vector size on conversion is 1."
			severity warning;
		assert input >= 0
			report "Only positives integer allowed when converting from INTEGER to STD_LOGIC_VECTOR."
			severity failure;
	--contrato para o input não ser maior que 2**size-1
    	tmp := std_logic_vector(to_unsigned(input,size));
		return tmp;
  	end to_std_logic_vector;

	function to_std_logic_vector( input : unsigned ) return std_logic_vector is
		variable tmp : std_logic_vector(input'length-1 downto 0);
	begin
		tmp := std_logic_vector(input);
		return tmp;
	end to_std_logic_vector;

	function to_std_logic_vector( input : std_logic ) return std_logic_vector is
		variable tmp : std_logic_vector(0 downto 0);
	begin
		tmp(0) := input;
			return tmp;
	end to_std_logic_vector;

  -- INTEGER TO UNSIGNED
	function to_unsigned( input : std_logic_vector) return unsigned is
		variable tmp : unsigned(input'length-1 downto 0);
	begin
		tmp := unsigned(input);
			return tmp;
	end to_unsigned;

	function to_signed( input : std_logic_vector) return signed is
		variable tmp : signed(input'length-1 downto 0);
	begin
		tmp := signed(input);
			return tmp;
	end to_signed;

--------------------------------------------------------------------------------------------------------
-- Operator: +
--------------------------------------------------------------------------------------------------------
	function "+" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		report "Result of adding vector is 1 bit wider." severity note;
		tmp := std_logic_vector(unsigned(l)+r);
		return tmp;
	end "+";

	function "+" (l:unsigned;         r: std_logic_vector) return unsigned is
		variable tmp : unsigned(l'range);
	begin
		tmp := l + unsigned(r);
		return tmp;
	end "+";

	function "+" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l)+unsigned(r));
		return tmp;
	end "+";

	function "+" (l:std_logic_vector; r: integer         ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) + to_unsigned(r,l'length));
		return tmp;
	end "+";

	function "+" (l:integer         ; r: std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := l + to_integer(unsigned(r));
		return tmp;
	end "+";

--------------------------------------------------------------------------------------------------------
-- Operator: -
--------------------------------------------------------------------------------------------------------
  function "-" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
  	variable tmp : std_logic_vector(l'range);
  begin
		tmp := std_logic_vector(unsigned(l)-r);
		return tmp;
  end "-";

  function "-" (l:unsigned;         r: std_logic_vector) return unsigned is
  	variable tmp : unsigned(l'range);
  begin
		tmp := l-unsigned(r);
		return tmp;
  end "-";

   function "-" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
  	 variable tmp : std_logic_vector(l'range);
   begin
		 tmp := std_logic_vector(unsigned(l)-unsigned(r));
		 return tmp;
   end "-";

  function "-" (l:std_logic_vector; r: integer         ) return std_logic_vector is
  	variable tmp : std_logic_vector(l'range);
  begin
		tmp := std_logic_vector(unsigned(l)-to_unsigned(r,l'length));
		return tmp;
  end "-";

  function "-" (l:integer         ; r: std_logic_vector) return integer is
  	variable tmp : integer;
  begin
	tmp := l-to_integer(unsigned(r));
	return tmp;
  end "-";

--------------------------------------------------------------------------------------------------------
-- Operator: *
--------------------------------------------------------------------------------------------------------
  	function "*" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
		variable tmp : std_logic_vector(l'length + r'length - 1 downto 0);
	begin
	 tmp := std_logic_vector(unsigned(l) * r);
	 return tmp;
	end "*";

	function "*" (l:unsigned;         r: std_logic_vector) return unsigned is
		variable tmp : unsigned(l'length + r'length - 1 downto 0);
	begin
		tmp := (l * unsigned(r));
		return tmp;
	end "*";

	function "*" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(l'length + r'length - 1 downto 0);
	begin
		tmp := std_logic_vector(unsigned(l) * unsigned(r));
		return tmp;
	end "*";

	function "*" (l:std_logic_vector; r: integer         ) return std_logic_vector is
		variable tmp : std_logic_vector(2 * l'length - 1 downto 0);
	begin
		tmp := std_logic_vector(unsigned(l) * to_unsigned(r,l'length));
		return tmp;
	end "*";

	function "*" (l:integer         ; r: std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := l * to_integer(unsigned(r));
		return tmp;
	end "*";

--------------------------------------------------------------------------------------------------------
-- Operator: /
--------------------------------------------------------------------------------------------------------
	function "/" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l)/r);
		return tmp;
	end "/";

	function "/" (l:unsigned;         r: std_logic_vector) return unsigned is
		variable tmp : unsigned(l'range);
	begin
		tmp := l/unsigned(r);
		return tmp;
	end "/";

	function "/" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l)/unsigned(r));
		return tmp;
	end "/";

	function "/" (l:std_logic_vector; r: integer         ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l)/to_unsigned(r,l'length));
		return tmp;
	end "/";

	function "/" (l:integer         ; r: std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := l/to_integer(unsigned(r));
		return tmp;
	end "/";

--------------------------------------------------------------------------------------------------------
-- Operator: mod
--------------------------------------------------------------------------------------------------------
	function "mod" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) mod r);
		return tmp;
	end "mod";

	function "mod" (l:unsigned;         r: std_logic_vector) return unsigned is
		variable tmp : unsigned(l'range);
	begin
		tmp := l mod unsigned(r);
		return tmp;
	end "mod";

	function "mod" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) mod unsigned(r));
		return tmp;
	end "mod";

	function "mod" (l:std_logic_vector; r: integer         ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) mod to_unsigned(r,l'length));
		return tmp;
	end "mod";

	function "mod" (l:integer         ; r: std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := l mod to_integer(unsigned(r));
		return tmp;
	end "mod";

--------------------------------------------------------------------------------------------------------
-- Operator: rem
--------------------------------------------------------------------------------------------------------
	function "rem" (l:std_logic_vector; r: unsigned        ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) rem r);
		return tmp;
	end "rem";

	function "rem" (l:unsigned;         r: std_logic_vector) return unsigned is
		variable tmp : unsigned(l'range);
	begin
		tmp := l rem unsigned(r);
		return tmp;
	end "rem";

	function "rem" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) rem unsigned(r));
		return tmp;
	end "rem";

	function "rem" (l:std_logic_vector; r: integer         ) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := std_logic_vector(unsigned(l) rem to_unsigned(r,l'length));
		return tmp;
	end "rem";

	function "rem" (l:integer         ; r: std_logic_vector) return integer is
		variable tmp : integer;
	begin
		tmp := l rem to_integer(unsigned(r));
		return tmp;
	end "rem";

--------------------------------------------------------------------------------------------------------
-- Operator: =
--------------------------------------------------------------------------------------------------------
	function "=" (l:std_logic_vector; r: integer) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) = r then
			tmp := true;
		end if;
		return tmp;
	end "=";

	function "=" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) = l then
			tmp := true;
		end if;
		return tmp;
	end "=";

	function "=" (l:std_logic_vector; r: unsigned) return boolean is
	 	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) = r then
			tmp := true;
		end if;
		return tmp;
	end "=";

	function "=" (l:unsigned; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) = l then
			tmp := true;
		end if;
		return tmp;
	end "=";

--------------------------------------------------------------------------------------------------------
-- Operator: /=
--------------------------------------------------------------------------------------------------------
	function "/=" (l:std_logic_vector; r: integer) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) /= r then
			tmp := true;
		end if;
		return tmp;
	end "/=";

	function "/=" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) /= l then
			tmp := true;
		end if;
		return tmp;
	end "/=";

	function "/=" (l:std_logic_vector; r: unsigned) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) /= r then
			tmp := true;
		end if;
		return tmp;
	end "/=";

	function "/=" (l:unsigned; r: std_logic_vector) return boolean is
		 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) /= l then
			tmp := true;
		end if;
		return tmp;
	end "/=";

--------------------------------------------------------------------------------------------------------
-- Operator: >
--------------------------------------------------------------------------------------------------------
	function ">" (l:std_logic_vector; r: integer) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) > r then
			tmp := true;
		end if;
		return tmp;
	end ">";

	function ">" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if l > unsigned(r) then
		 	tmp := true;
		end if;
		return tmp;
	end ">";

	function ">" (l:std_logic_vector; r: unsigned) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) > r then
		 	tmp := true;
		end if;
		return tmp;
	end ">";

	function ">" (l:unsigned; r: std_logic_vector) return boolean is
	 	variable tmp : boolean;
	begin
		tmp := false;
		if l > unsigned(r) then
			tmp := true;
		end if;
		return tmp;
	end ">";

--------------------------------------------------------------------------------------------------------
-- Operator: <
--------------------------------------------------------------------------------------------------------
	function "<" (l:std_logic_vector; r: integer) return boolean is
		variable tmp : boolean;
	begin
	 tmp := false;
	 if unsigned(l) < r then
		tmp := true;
	 end if;
	 return tmp;
	end "<";

	function "<" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if l < unsigned(r) then
		 tmp := true;
		end if;
		return tmp;
	end "<";

	function "<" (l:std_logic_vector; r: unsigned) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) < r then
		 tmp := true;
		end if;
		return tmp;
	end "<";

	function "<" (l:unsigned; r: std_logic_vector) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if l < unsigned(r) then
		tmp := true;
		end if;
		return tmp;
	end "<";

--------------------------------------------------------------------------------------------------------
-- Operator: >=
--------------------------------------------------------------------------------------------------------
	function ">=" (l:std_logic_vector; r: integer) return boolean is
	begin
	 return to_integer(l) >= r;
	end ">=";

	function ">=" (l:integer; r: std_logic_vector) return boolean is
	begin
		return l >= to_integer(r);
	end ">=";

	function ">=" (l:std_logic_vector; r: unsigned) return boolean is
	begin
		return to_integer(l) >= to_integer(r);
	end ">=";

	function ">=" (l:unsigned; r: std_logic_vector) return boolean is
	begin
		return to_integer(l) >= to_integer(r);
	end ">=";

--------------------------------------------------------------------------------------------------------
-- Operator: <=
--------------------------------------------------------------------------------------------------------
	function "<=" (l:std_logic_vector; r: integer) return boolean is
	begin
	 	return to_integer(l) <= r;
	end "<=";

	function "<=" (l:integer; r: std_logic_vector) return boolean is
	begin
		return l <= to_integer(r);
	end "<=";

	function "<=" (l:std_logic_vector; r: unsigned) return boolean is
	begin
		return to_integer(l) <= to_integer(r);
	end "<=";

	function "<=" (l:unsigned; r: std_logic_vector) return boolean is
	begin
		return to_integer(l) <= to_integer(r);
	end "<=";

--------------------------------------------------------------------------------------------------------
-- Operator: SLA / SRA
--------------------------------------------------------------------------------------------------------
	function "rol" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l rol tmp1;
		return tmp2;
	end "rol";

	function "rol" (l:std_logic_vector; r: unsigned) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l rol tmp1;
		return tmp2;
	end "rol";

	function "rol" (l:integer_vector; r: integer) return integer_vector is
    	variable tmp2 : integer_vector(l'range);
  	begin
		tmp2 := l;
		if r > 0 then
			for j in 1 to r loop
				tmp2 := tmp2(0) & tmp2(tmp2'high downto 1);
			end loop;
		end if;
		return tmp2;
  	end "rol";

	function "rol" (l:integer_vector; r: unsigned) return integer_vector is
		variable tmp1 : integer;
    	variable tmp2 : integer_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l rol tmp1;
		return tmp2;
	end "rol";

	function "ror" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l ror tmp1;
		return tmp2;
	end "ror";

	function "ror" (l:std_logic_vector; r: unsigned) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l ror tmp1;
		return tmp2;
	end "ror";

	function "ror" (l:integer_vector; r: integer) return integer_vector is
		variable tmp2 : integer_vector(l'range);
  	begin
		tmp2 := l;
		if r > 0 then
			for j in 1 to r loop
				tmp2 := tmp2(tmp2'high-1 downto 0) & tmp2(tmp2'high);
			end loop;
		end if;
		return tmp2;
  	end "ror";

	function "ror" (l:integer_vector; r: unsigned) return integer_vector is
		variable tmp1 : integer;
		variable tmp2 : integer_vector(l'range);
  	begin
		tmp1 := to_integer(r);
		tmp2 := l ror tmp1;
		return tmp2;
  	end "ror";

--------------------------------------------------------------------------------------------------------
-- Operator: Index & Bus Operators
--------------------------------------------------------------------------------------------------------
	function size_of (input: integer) return integer is
	begin
		if input < 2 then
			return 1;
		end if;
		return integer(ceil(log2(real(input+1))));
	end size_of;

	function size_of (input : integer; word : integer) return integer is
		variable tmp : real;
	begin
		if input < 2**word then
			return 1;
		end if;
		tmp := log2(real(input+1));
		tmp := tmp / real(word);
		return integer(ceil(tmp));
	end size_of;

	function index_of (	input : std_logic_vector ) return integer is
		variable tmp : integer;
	begin
		if input'low < input'high then
			tmp := input'low / input'length;
		else
			tmp := input'high / input'length;
		end if;
		return tmp;
	end index_of;

	--Returns a range of a vector on custom "range_t" type, as ranges are not VHDL objects.
	function range_of (	input : integer; word : integer ) return range_t is
		variable tmp : range_t;
	begin
		tmp.high := (input+1)*word-1;
		tmp.low  := input*word;
		return tmp;
	end range_of;

	function get_slice (input : std_logic_vector; word: integer; index: integer) return std_logic_vector is
		variable range_v   : range_t;
		variable input_tmp : std_logic_vector(input'length-1 downto 0);
		variable out_tmp   : std_logic_vector(word-1 downto 0) := (others=>'0');
		variable index_tmp : integer := 0;
	begin
		input_tmp := input;
		range_v   := range_of(index,word);
		assert input_tmp'length > range_v.high
			report "Vector out of range. Will fill with 0."
			severity warning;

		for j in range_v.low to range_v.high loop
			if j < input_tmp'length then
				out_tmp(index_tmp) := input_tmp(j);
			end if;
			index_tmp := index_tmp + 1;
		end loop;

		return out_tmp;
	end get_slice;

	function set_slice (input : std_logic_vector; input2: std_logic_vector; index: integer) return std_logic_vector is
		variable range_v    : range_t;
		variable input_tmp  : std_logic_vector(input'length-1 downto 0);
		variable input2_tmp : std_logic_vector(input2'length-1 downto 0);
		variable index_tmp  : integer := 0;
	begin
		input_tmp := input;
		input2_tmp := input2;
		range_v   := range_of(index,input2'length);

		assert input_tmp'length > range_v.high
			report "Vector out of range. Will discard excess bits."
			severity warning;

		for j in range_v.low to range_v.high loop
			if j < input_tmp'length then
				input_tmp(j) := input2(index_tmp);
			end if;
			index_tmp := index_tmp + 1;
		end loop;

		return input_tmp;
	end set_slice;

	function to_range (	input : std_logic_vector ) return range_t is
		variable tmp : range_t;
	begin
		tmp.high := input'high;
		tmp.low  := input'low;
		return tmp;
	end to_range;

	function index_of_1 (	input : std_logic_vector ) return integer is
		variable tmp : integer := 0;
	begin
		for j in 0 to input'high loop
			if input(j) = '1' then
				tmp := j;
			end if;
		end loop;
		return tmp;
	end index_of_1;

	function index_of_0 (	input : std_logic_vector ) return integer is
		variable tmp : integer;
	begin
		for j in 0 to input'high loop
			if input(j) = '0' then
				tmp := j;
			end if;
		end loop;
		return tmp;
	end index_of_0;

	function all_1 (	input : integer ) return std_logic_vector is
		variable tmp : std_logic_vector(input-1 downto 0) := (others=>'1');
	begin
		return tmp;
	end all_1;

	function all_0 (	input : integer ) return std_logic_vector is
		variable tmp : std_logic_vector(input-1 downto 0) := (others=>'0');
	begin
		return tmp;
	end all_0;

end std_logic_expert;
