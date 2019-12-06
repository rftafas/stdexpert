library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

package std_logic_gray is

	type gray_vector is array (NATURAL RANGE <>) of STD_LOGIC;

	--CONVERSIONS to GRAY
	function to_gray_vector ( input : std_logic_vector	) return  gray_vector;
	function to_gray_vector ( input : unsigned       	  ) return  gray_vector;
	function to_gray_vector ( input : integer; size : integer) return gray_vector;

	--COMVERSIONS FROM GRAY
	function to_std_logic_vector ( input : gray_vector ) return std_logic_vector;
	function to_unsigned         ( input : gray_vector ) return unsigned;
	function to_integer          ( input : gray_vector ) return integer;

	--Operadores
	function "+"   (l:gray_vector; r: gray_vector      ) return gray_vector;
	function "+"   (l:gray_vector; r: integer          ) return gray_vector;
	function "+"   (l:gray_vector; r: unsigned         ) return gray_vector;
	function "+"   (l:gray_vector; r: std_logic_vector ) return gray_vector;

	function "-"   (l:gray_vector; r: gray_vector      ) return gray_vector;
	function "-"   (l:gray_vector; r: integer          ) return gray_vector;
	function "-"   (l:gray_vector; r: unsigned         ) return gray_vector;
	function "-"   (l:gray_vector; r: std_logic_vector ) return gray_vector;

	--function "*"   (l:gray_vector; r: gray_vector) return std_logic_vector;
	--function "/"   (l:gray_vector; r: gray_vector) return std_logic_vector;
	--function "mod" (l:gray_vector; r: gray_vector) return std_logic_vector;
	--function "rem" (l:gray_vector; r: gray_vector) return std_logic_vector;
	function "="   (l:gray_vector; r: gray_vector) return boolean;
	function "/="  (l:gray_vector; r: gray_vector) return boolean;
	function ">"   (l:gray_vector; r: gray_vector) return boolean;
	function "<"   (l:gray_vector; r: gray_vector) return boolean;
	function ">="  (l:gray_vector; r: gray_vector) return boolean;
	function "<="  (l:gray_vector; r: gray_vector) return boolean;

	--INTERNAL FUNCTIONS. NOT INTENDED TO BE USED DIRECTLY
	function gray_encoder   ( input : std_logic_vector ) return  std_logic_vector;
	function gray_decoder   ( input : std_logic_vector ) return  std_logic_vector;
	function translate2gray ( input : std_logic_vector ) return  gray_vector;
	function translate2svl  ( input : gray_vector	   ) return  std_logic_vector;

end std_logic_gray;

--a arquitetura
package body std_logic_gray is

	function to_gray_vector ( input : std_logic_vector ) return  gray_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := gray_encoder(tmp);
		return translate2gray(tmp);
	end to_gray_vector;

	function to_gray_vector ( input : unsigned       	) return  gray_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := std_logic_vector(input);
		tmp := gray_encoder(tmp);
		return translate2gray(tmp);
	end to_gray_vector;

	function to_gray_vector ( input : integer; size : integer       	) return  gray_vector is
		variable tmp : std_logic_vector(size-1 downto 0);
	begin
		tmp := std_logic_vector( to_unsigned(input,size) );
		tmp := gray_encoder(tmp);
		return translate2gray(tmp);
	end to_gray_vector;

	function to_std_logic_vector( input : gray_vector ) return std_logic_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := translate2svl(input);
		tmp := gray_decoder(tmp);
		return tmp;
	end to_std_logic_vector;

	function to_unsigned( input : gray_vector ) return unsigned is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := translate2svl(input);
		tmp := gray_decoder(tmp);
		return unsigned(tmp);
	end to_unsigned;

	function to_integer( input : gray_vector ) return integer is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := translate2svl(input);
		tmp := gray_decoder(tmp);
		return to_integer(unsigned(tmp));
	end to_integer;

	function "+" (l:gray_vector; r: gray_vector        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) + to_unsigned(r) );
		return tmp;
	end "+";

	function "+" (l:gray_vector; r: integer        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) + r );
		return tmp;
	end "+";

	function "+" (l:gray_vector; r: unsigned        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) + r );
		return tmp;
	end "+";

	function "+" (l:gray_vector; r: std_logic_vector        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) + unsigned(r) );
		return tmp;
	end "+";

	function "-" (l:gray_vector; r: gray_vector        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) - to_unsigned(r) );
		return tmp;
	end "-";

	function "-" (l:gray_vector; r: integer        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) - r );
		return tmp;
	end "-";

	function "-" (l:gray_vector; r: unsigned        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) - r );
		return tmp;
	end "-";

	function "-" (l:gray_vector; r: std_logic_vector        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray_vector( to_unsigned(l) - unsigned(r) );
		return tmp;
	end "-";

	function "=" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := translate2svl(l) = translate2svl(r);
		return tmp;
	end "=";

	function "/=" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := translate2svl(l) /= translate2svl(r);
		return tmp;
	end "/=";

	function ">" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) > to_unsigned(r);
		return tmp;
	end ">";

	function ">=" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) >= to_unsigned(r);
		return tmp;
	end ">=";

	function "<" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) < to_unsigned(r);
		return tmp;
	end "<";

	function "<=" (l:gray_vector; r: gray_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) <= to_unsigned(r);
		return tmp;
	end "<=";

------------------------------------------------------------------------------------------------------
--if someone wants to work with STD_LOGIC_VECTOR instead GRAY_VECTOR, one can use
--the following functions.
	function gray_encoder( input : std_logic_vector ) return  std_logic_vector is
		variable tmp  : std_logic_vector(input'range);
	begin
		for j in tmp'range loop
			if j = input'high then
				tmp(j) := input(j);
			else
				tmp(j) := input(j+1) xor input(j);
			end if;
		end loop;
		return tmp;
	end gray_encoder;

	function gray_decoder( input : std_logic_vector ) return  std_logic_vector is
		variable tmp  : std_logic_vector(input'range);
	begin
		for j in tmp'range loop
			if j = input'high then
				tmp(j) := input(j);
			else
				tmp(j) := tmp(j+1) xor input(j);
			end if;
		end loop;
		return tmp;
	end gray_decoder;

	function translate2gray ( input : std_logic_vector	) return  gray_vector is
		variable tmp  : gray_vector(input'range);
	begin
		for j in input'range loop
			tmp(j) := input(j);
		end loop;
		return tmp;
	end translate2gray;

	function translate2svl ( input : gray_vector	) return  std_logic_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		for j in input'range loop
			tmp(j) := input(j);
		end loop;
		return tmp;
	end translate2svl;


end std_logic_gray;
