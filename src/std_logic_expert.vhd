--------------------------------------------------------------------------------------------------------
--
-- Library name: REPO
-- Package name: STD_LOGIC_EXPERT
-- Author:       Ricardo F Tafas Jr
-- Company:      Repo Dinamica - www.repodinamica.com.br
-- THIS IS OPEN SOURCE CODE. You can clone it on GITHUB:
-- https://github.com/rftafas/std_logic_expert.git
--
--------------------------------------------------------------------------------------------------------
-- USAGE:
-- Library REPO;
-- USE REPO.STD_LOGIC_EXPERT.ALL
---------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------
-- Features:
--1) fixes the annoying "TO_INTEGER", "TO_SIGNED" and "TO_UNSIGNED" typecasts.
--2) defines +, -, * for std_logic types. Always UNSIGNED. Usually we just want to convert indexing
--   using STD_LOGIC_VECTORs. and to be honest, if you are doing math with STD_LOGIC without carefully
--   evaluating the type you are using, you are doing it wrong.
--------------------------------------------------------------------------------------------------------
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package std_logic_expert is

	-- Outputs from the FIFO.
  type range_t is record
    high  : integer;
    low   : integer;
  end record range_t;

	type range_vector is array (NATURAL RANGE <>) of std_logic;


	function to_integer         ( input : std_logic_vector       ) return integer;
	function to_std_logic_vector( input : integer; size : integer) return std_logic_vector;
	function to_std_logic_vector( input : std_logic              ) return std_logic_vector;

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
	--function "=" (l:std_logic_vector; r: unsigned)         return boolean;
	--function "=" (l:unsigned;         r: std_logic_vector) return boolean;

	function "/=" (l:std_logic_vector; r: integer)          return boolean;
	function "/=" (l:integer;          r: std_logic_vector) return boolean;
	--function "/=" (l:std_logic_vector; r: unsigned)         return boolean;
	--function "/=" (l:unsigned;         r: std_logic_vector) return boolean;

	function ">" (l:std_logic_vector; r: integer)          return boolean;
	function ">" (l:integer;          r: std_logic_vector) return boolean;
	function ">" (l:std_logic_vector; r: unsigned)         return boolean;
	function ">" (l:unsigned;         r: std_logic_vector) return boolean;

	function "<" (l:std_logic_vector; r: integer)          return boolean;
	function "<" (l:integer;          r: std_logic_vector) return boolean;
	function "<" (l:std_logic_vector; r: unsigned)         return boolean;
	function "<" (l:unsigned;         r: std_logic_vector) return boolean;

	function ">=" (l:std_logic_vector; r: integer)          return boolean;
	function ">=" (l:integer;          r: std_logic_vector) return boolean;
	function ">=" (l:std_logic_vector; r: unsigned)         return boolean;
	function ">=" (l:unsigned;         r: std_logic_vector) return boolean;

	function "<=" (l:std_logic_vector; r: integer)          return boolean;
	function "<=" (l:integer;          r: std_logic_vector) return boolean;
	function "<=" (l:std_logic_vector; r: unsigned)         return boolean;
	function "<=" (l:unsigned;         r: std_logic_vector) return boolean;

	function "sll" (l:std_logic_vector; r: integer) return std_logic_vector;
	function "sll" (l:std_logic_vector; r: unsigned) return std_logic_vector;
	function "srl" (l:std_logic_vector; r: integer) return std_logic_vector;
	function "srl" (l:std_logic_vector; r: unsigned) return std_logic_vector;


	--index operations
	function size_of    ( input : integer                          ) return integer;
	function size_of    ( input : integer;          word : integer ) return integer;
	function index_of   (	input : std_logic_vector                 ) return integer;
	function rebase     (	input : std_logic_vector                 ) return std_logic_vector;
	function range_of   (	input : integer;         	word : integer ) return range_t;
	function to_range   (	input : std_logic_vector                 ) return range_t;
	function index_of_1 (	input : std_logic_vector                 ) return integer;

end std_logic_expert;

--a arquitetura
package body std_logic_expert is

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

	function to_std_logic_vector( input : std_logic ) return std_logic_vector is
    variable tmp : std_logic_vector(0 downto 0);
  begin
    tmp(0) := input;
		return tmp;
  end to_std_logic_vector;

  -- --INTEGER TO UNSIGNED
  -- function to_unsigned( input : integer; size : integer) return unsigned is
    -- variable tmp : unsigned(size-1 downto 0);
  -- begin
	-- assert size < 1
		-- report "Vector size on conversion must be greater than 0."
		-- severity failure;
	-- assert size = 1
		-- report "Vector size on conversion is 1."
		-- severity warning;
	-- assert input >= 0
		-- report "Only positives integer allowed when converting from INTEGER to UNSIGNED."
		-- severity failure;
	-- --contrato para o input não ser maior que 2**size-1
    -- tmp := to_unsigned(input,size);
	-- return tmp;
  -- end unsigned;

  -- --INTEGER TO SIGNED
  -- function to_signed( input : integer, size : integer) return signed is
    -- variable tmp : unsigned(size-1 downto 0);
  -- begin
	-- --contrato para size sempre maior que zero.
	-- assert size < 1 report "Vector size on conversion must be greater than 0." severity failure;
	-- assert size = 1 report "Vector size on conversion is 1."                   severity warning;
    -- tmp := to_signed(input,size);
	-- return tmp;
  -- end signed;

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
		tmp := unsigned(l) mod r;
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
			tmp := unsigned(l) rem r;
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

	--  function "=" (l:std_logic_vector; r: unsigned) return boolean is
	-- 	 variable tmp : boolean;
	--  begin
	-- 	tmp := false;
	-- 	if unsigned(l) = r then
	-- 	 tmp := true;
	-- 	end if;
	-- 	return tmp;
	-- end "=";
	--
	-- function "=" (l:unsigned; r: std_logic_vector) return boolean is
	-- 	 variable tmp : boolean;
	--  begin
	--  tmp := false;
	--  if unsigned(r) = l then
	-- 	tmp := true;
	--  end if;
	--  return tmp;
	-- end "=";

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

	--  function "/=" (l:std_logic_vector; r: unsigned) return boolean is
	-- 	 variable tmp : boolean;
	--  begin
	-- 	tmp := false;
	-- 	if unsigned(l) /= r then
	-- 	 tmp := true;
	-- 	end if;
	-- 	return tmp;
	-- end "/=";
	--
	-- function "/=" (l:unsigned; r: std_logic_vector) return boolean is
	-- 	 variable tmp : boolean;
	--  begin
	--  tmp := false;
	--  if unsigned(r) /= l then
	-- 	tmp := true;
	--  end if;
	--  return tmp;
	-- end "/=";

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
		variable tmp : boolean;
	begin
	 tmp := false;
	 if unsigned(l) >= r then
		tmp := true;
	 end if;
	 return tmp;
	end ">=";

	function ">=" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) >= l then
		 tmp := true;
		end if;
		return tmp;
	end ">=";

	function ">=" (l:std_logic_vector; r: unsigned) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) >= r then
		 tmp := true;
		end if;
		return tmp;
	end ">=";

	function ">=" (l:unsigned; r: std_logic_vector) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) >= l then
		tmp := true;
		end if;
		return tmp;
	end ">=";
	--------------------------------------------------------------------------------------------------------
	-- Operator: <=
	--------------------------------------------------------------------------------------------------------
	function "<=" (l:std_logic_vector; r: integer) return boolean is
		variable tmp : boolean;
	begin
	 tmp := false;
	 if unsigned(l) <= r then
		tmp := true;
	 end if;
	 return tmp;
	end "<=";

	function "<=" (l:integer; r: std_logic_vector) return boolean is
		variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) <= l then
		 tmp := true;
		end if;
		return tmp;
	end "<=";

	function "<=" (l:std_logic_vector; r: unsigned) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(l) <= r then
		 tmp := true;
		end if;
		return tmp;
	end "<=";

	function "<=" (l:unsigned; r: std_logic_vector) return boolean is
	 variable tmp : boolean;
	begin
		tmp := false;
		if unsigned(r) <= l then
		tmp := true;
		end if;
		return tmp;
	end "<=";

	--------------------------------------------------------------------------------------------------------
	-- Operator: <=
	--------------------------------------------------------------------------------------------------------
	function "sll" (l:std_logic_vector; r: integer) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := l;
		for k in 0 to r-1 loop
			tmp := tmp(tmp'high-1 downto 0) & '0';
		end loop;
		return tmp;
	end "sll";

	function "sll" (l:std_logic_vector; r: unsigned) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l sll tmp1;
		return tmp2;
	end "sll";

	function "srl" (l:std_logic_vector; r: integer) return std_logic_vector is
		variable tmp : std_logic_vector(l'range);
	begin
		tmp := l;
		for k in 0 to r-1 loop
			tmp := '0' & tmp(tmp'high-1 downto 0);
		end loop;
		return tmp;
	end "srl";

	function "srl" (l:std_logic_vector; r: unsigned) return std_logic_vector is
		variable tmp1 : integer;
		variable tmp2 : std_logic_vector(l'range);
	begin
		tmp1 := to_integer(r);
		tmp2 := l srl tmp1;
		return tmp2;
	end "srl";

	--------------------------------------------------------------------------------------------------------
	-- Operator: Index & Bus Operators
	--------------------------------------------------------------------------------------------------------
	function size_of (input: integer) return integer is
	begin
		return integer(ceil(log2(real(input))));
	end size_of;

	function size_of (input : integer; word : integer) return integer is
		variable tmp : real;
	begin
		--remember: log(a/b) = log(a) - log(b)
		tmp := log2(real(input));
		tmp := tmp - log2(real(word));
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

	function rebase (	input : std_logic_vector ) return std_logic_vector is
		variable tmp : std_logic_vector(input'length-1 downto 0);
	begin
		tmp := input;
		return tmp;
	end rebase;

	--Returns a range of a vector on custom "range_t" type, as ranges are not VHDL objects.
	function range_of (	input : integer; word : integer ) return range_t is
		variable tmp : range_t;
	begin
		tmp.high := (input+1)*word-1;
		tmp.low  := input*word;
		return tmp;
	end range_of;

	function to_range (	input : std_logic_vector ) return range_t is
		variable tmp : range_t;
	begin
		tmp.high := input'high;
		tmp.low  := input'low;
		return tmp;
	end to_range;

	function index_of_1 (	input : std_logic_vector ) return integer is
		variable tmp : integer;
	begin
		for j in 0 to input'high loop
			if input(j) = '1' then
				tmp := j;
			end if;
		end loop;
		return tmp;
	end index_of_1;

end std_logic_expert;
