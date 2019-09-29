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

--declaramos a entidade
package std_logic_expert is

	--CONVERSIONS
	-- function toba ( input :         unsigned       		   ) return  integer;
	-- function toba ( input :           signed				   ) return  integer;
    function to_integer         ( input : std_logic_vector                ) return integer;
    function to_std_logic_vector( input :          integer; size : integer) return std_logic_vector;
    -- function toba  ( input :          integer; size : integer) return   signed;

	--MATH OPERATORS
	--function "+" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	--function "+" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "+" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	function "+" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	-- function "+" (l:integer         ; r: std_logic_vector) return integer;

	--function "-" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	--function "-" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "-" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	-- function "-" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	-- function "-" (l:integer         ; r: std_logic_vector) return integer;

	--function "*" (l:std_logic_vector; r: unsigned        ) return std_logic_vector;
	--function "*" (l:unsigned;         r: std_logic_vector) return unsigned;
	function "*" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector;
	-- function "*" (l:std_logic_vector; r: integer         ) return std_logic_vector;
	-- function "*" (l:integer         ; r: std_logic_vector) return integer;

	function "=" (l:std_logic_vector; r: integer)          return boolean;
	function "=" (l:integer;          r: std_logic_vector) return boolean;
	function "=" (l:std_logic_vector; r: unsigned)         return boolean;
	function "=" (l:unsigned;         r: std_logic_vector) return boolean;

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

end std_logic_expert;

--a arquitetura
package body std_logic_expert is

  -- --UNSIGNED TO INTEGER
  -- function integer( input : unsigned) return integer is
    -- variable tmp : integer;
  -- begin
    -- tmp := to_integer(input);
	-- return tmp;
  -- end integer;

  -- --SIGNED TO INTEGER
  -- function integer( input : signed) return integer is
    -- variable tmp : integer;
  -- begin
    -- tmp := to_integer(input);
	-- return tmp;
  -- end integer;

  --INTEGER TO STD_LOGIC_VECTOR
  function to_integer( input : std_logic_vector) return integer is
    variable tmp : integer;
  begin
    tmp := to_integer(unsigned(input));
	return tmp;
  end to_integer;

  --INTEGER TO UNSIGNED
  function to_std_logic_vector( input : integer; size : integer) return std_logic_vector is
    variable tmp : std_logic_vector(size-1 downto 0);
  begin
	assert size < 1
		report "Vector size on conversion must be greater than 0."
		severity failure;
	assert size = 1
		report "Vector size on conversion is 1."
		severity warning;
	assert input >= 0
		report "Only positives integer allowed when converting from INTEGER to UNSIGNED."
		severity failure;
	--contrato para o input não ser maior que 2**size-1
    tmp := std_logic_vector(to_unsigned(input,size));
	return tmp;
  end to_std_logic_vector;


  -- --INTEGER TO UNSIGNED
  -- function unsigned( input : integer; size : integer) return unsigned is
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
  -- function signed( input : integer, size : integer) return signed is
    -- variable tmp : unsigned(size-1 downto 0);
  -- begin
	-- --contrato para size sempre maior que zero.
	-- assert size < 1 report "Vector size on conversion must be greater than 0." severity failure;
	-- assert size = 1 report "Vector size on conversion is 1."                   severity warning;
    -- tmp := to_signed(input,size);
	-- return tmp;
  -- end signed;

  -- --INTEGER TO STD_LOGIC_VECTOR
  -- function std_logic_vector( input : integer, size : integer) return std_logic_vector is
    -- variable tmp : unsigned(size-1 downto 0);
  -- begin
	-- assert input >= 0 report "Only positives integer allowed when converting from INTEGER to STD_LOGIC_VECTOR." severity failure;
    -- tmp := std_logic_vector(to_unsigned(input,size));
	-- return tmp;
  -- end std_logic_vector;

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
	 tmp := std_logic_vector(unsigned(r)+unsigned(l));
	 return tmp;
   end "+";

  function "+" (l:std_logic_vector; r: integer         ) return std_logic_vector is
  	variable tmp : std_logic_vector(l'range);
  begin
	tmp := std_logic_vector(unsigned(r)+unsigned(l));
	return tmp;
  end "+";

  function "+" (l:integer         ; r: std_logic_vector) return std_logic_vector is
  	variable tmp : std_logic_vector(l'range);
  begin
	tmp := std_logic_vector(unsigned(r)+unsigned(l));
	return tmp;
  end "+";

	--------------------------------------------------------------------------------------------------------
	-- Operator: +
	--------------------------------------------------------------------------------------------------------
  -- function "-" (l:std_logic_vector; r: unsigned        ) return integer is
  	-- variable tmp : std_logic_vector(l'range);
  -- begin
	-- tmp := std_logic_vector(unsigned(r)+unsigned(l));
	-- return tmp;
  -- end "-";

  -- function "-" (l:unsigned;         r: std_logic_vector) return integer is
  	-- variable tmp : std_logic_vector(l'range);
  -- begin
	-- tmp := std_logic_vector(unsigned(r)+unsigned(l));
	-- return tmp;
  -- end "-";

   function "-" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
  	 variable tmp : std_logic_vector(l'range);
   begin
	 tmp := std_logic_vector(unsigned(r)+unsigned(l));
	 return tmp;
   end "-";

  -- function "-" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
  	-- variable tmp : std_logic_vector(l'range);
  -- begin
	-- tmp := std_logic_vector(unsigned(r)+unsigned(l));
	-- return tmp;
  -- end "-";

  -- function "-" (l:std_logic_vector; r: integer         ) return std_logic_vector is
  	-- variable tmp : std_logic_vector(l'range);
  -- begin
	-- tmp := std_logic_vector(unsigned(r)+unsigned(l));
	-- return tmp;
  -- end "-";

  -- function "-" (l:integer         ; r: std_logic_vector) return std_logic_vector is
  	-- variable tmp : std_logic_vector(l'range);
  -- begin
	-- tmp := std_logic_vector(unsigned(r)+unsigned(l));
	-- return tmp;
  -- end "-";

	--------------------------------------------------------------------------------------------------------
	-- Operator: +
	--------------------------------------------------------------------------------------------------------
  -- function "*" (l:std_logic_vector; r: unsigned        ) return integer;    -- f1
  -- function "*" (l:unsigned;         r: std_logic_vector) return integer;    -- f1
  -- function "*" (l:std_logic_vector; r: std_logic_vector) return integer;    -- f1
  function "*" (l:std_logic_vector; r: std_logic_vector) return std_logic_vector is
    variable tmp : std_logic_vector(l'length + r'length - 1 downto 0);
  begin
	 tmp := std_logic_vector(unsigned(r)* unsigned(l));
	 return tmp;
  end "*";
  -- function "*" (l:std_logic_vector; r: integer         ) return std_logic_vector;
  -- function "*" (l:integer         ; r: std_logic_vector) return std_logic_vector;

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
if unsigned(r) > l then
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
if unsigned(r) > l then
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
if unsigned(r) < l then
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
if unsigned(r) < l then
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

end std_logic_expert;
