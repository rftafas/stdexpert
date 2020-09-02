library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package std_string is

	type std_logic_string is array (POSITIVE RANGE <> ) of std_logic_vector(7 downto 0);
	type integer_string   is array (POSITIVE RANGE <> ) of integer range 0 to 255;

	constant string_map : string(1 to 256) :=
		nul, soh, stx, etx, eot, enq, ack, bel,
		bs,  ht,  lf,  vt,  ff,  cr,  so,  si,
		dle, dc1, dc2, dc3, dc4, nak, syn, etb,
		can, em,  sub, esc, fsp, gsp, rsp, usp,

		' ', '!', '"', '#', '$', '%', '&', ''',
		'(', ')', '*', '+', ',', '-', '.', '/',
		'0', '1', '2', '3', '4', '5', '6', '7',
		'8', '9', ':', ';', '<', '=', '>', '?',

		'@', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
		'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
		'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
		'X', 'Y', 'Z', '[', '\', ']', '^', '_',

		'`', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
		'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
		'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
		'x', 'y', 'z', '{', '|', '}', '~', del,

		c128, c129, c130, c131, c132, c133, c134, c135,
		c136, c137, c138, c139, c140, c141, c142, c143,
		c144, c145, c146, c147, c148, c149, c150, c151,
		c152, c153, c154, c155, c156, c157, c158, c159,

		-- the character code for 160 is there (NBSP),
		-- but prints as no char

		' ', '¡', '¢', '£', '¤', '¥', '¦', '§',
		'¨', '©', 'ª', '«', '¬',  '­', '®', '¯',
		'°', '±', '²', '³', '´', 'µ', '¶', '·',
		'¸', '¹', 'º', '»', '¼', '½', '¾', '¿',

		'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç',
		'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï',
		'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×',
		'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß',

		'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç',
		'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï',
		'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷',
		'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ'
	);
	--VHDL2008 already have functions to convert to string and to hexa_string.
	--to_string and to_hstring from all 'standard' types.
	--For GALOIS_VECTOR and for GREY_VECTOR, we can convert to STD_LOGIC_VECTOR first.

	-- FROM STRING
	-- function to_std_logic_string (input:string) return std_logic_string;
	-- function to_integer_string   (input:string) return integer_string;

	-- TO_STRING
	-- function to_string (input:std_logic_string) return string;


	--Operadores
	function string_replace(l:string; r:string) return string;
	function string_match  (l:string; r:string) return boolean;
	--TO DO: must overload this with all other string types. There will be pain.

	function get_char_code (input:character) return integer;

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

		scan_loop : for j in str_tmp1'high downto 2 loop
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
			report "Could not find %r on string."
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

	function get_char_code (input:character) return integer is
		variable tmp : integer := 0;
	begin
			char_loop : for j in string_map'range loop
				tmp := j;
				exit char_loop when input = string_map(j);
			end loop;
			return j;
	end get_char_code;

end std_string;
