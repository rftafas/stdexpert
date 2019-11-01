library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

package std_logic_gray is

	type gray_vector is array (NATURAL RANGE <>) of STD_LOGIC;

	--CONVERSIONS to GRAY
	function to_gray ( input : std_logic_vector	) return  gray_vector;
	function to_gray ( input : unsigned       	) return  gray_vector;
	function to_gray ( input : bit_vector 		  ) return  gray_vector;
	function to_gray ( input : integer; size : integer) return gray_vector;

	--COMVERSIONS TO INTEGER
	function to_integer         ( input : gray_vector ) return integer;

	--Operadores
	function "+"   (l:gray_vector ; r: gray_vector  ) return gray_vector;
	function "+"   (l:gray_vector ; r: integer      ) return gray_vector;

	function "-"   (l:gray_vector; r: unsigned      ) return std_logic_vector;
	function "*"   (l:std_logic_vector; r: unsigned ) return std_logic_vector;
	function "/"   (l:std_logic_vector; r: unsigned	) return std_logic_vector;
	function "mod" (l:std_logic_vector; r: unsigned ) return std_logic_vector;
	function "rem" (l:std_logic_vector; r: unsigned ) return std_logic_vector;
	function "="   (l:std_logic_vector; r: integer  ) return boolean;
	function "/="  (l:std_logic_vector; r: integer  ) return boolean;
	function ">"   (l:std_logic_vector; r: integer  ) return boolean;
	function "<"   (l:std_logic_vector; r: integer  ) return boolean;
	function ">="  (l:std_logic_vector; r: integer  ) return boolean;
	function "<="  (l:std_logic_vector; r: integer  ) return boolean;

	--INTERNAL FUNCTIONS. NOT INTENDED TO BE USED DIRECTLY
	function temp_gray_f000 ( input : std_logic_vector	      ) return  std_logic_vector;
	function temp_gray_f001 ( input : std_logic_vector	      ) return  gray;
	function temp_gray_f002 ( input : gray            	      ) return  std_logic_vector;

end std_logic_gray;

--a arquitetura
package body std_logic_gray is



	function to_gray ( input : std_logic_vector       	) return  gray_vector is
		variable tmp  : gray_vector(input'range);
	begin
		tmp := temp_gray_f001(input);
	end to_gray;

	function to_gray ( input : unsigned       	) return  gray_vector is
		variable tmp  : gray_vector(input'range);
	begin
		tmp := temp_gray_f001(temp_gray_f000(std_logic_vector(input)));
	end to_gray;

	function to_gray ( input : integer; size : integer       	) return  gray_vector is
		variable tmp  : gray_vector(input'range);
	begin
		tmp := temp_gray_f001(temp_gray_f000(std_logic_vector(input,size)));
	end to_gray;

	------

	function to_std_logic_vector( input : gray_vector ) return std_logic_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := temp_gray_f001(input);
		return tmp;
	end to_std_logic_vector;

	function to_unsigned( input : gray_vector ) return unsigned is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := temp_gray_f001(input);
		tmp := temp_gray_f000(tmp);
		return unsigned(tmp);
	end to_unsigned;

	function to_integer( gray_vector ) return integer is
		variable tmp : std_logic_vector(input'range);
	begin
		tmp := temp_gray_f001(input);
		tmp := temp_gray_f000(tmp);
		return to_integer(tmp);
	end to_integer;

	function "+" (l:gray_vector; r: gray_vector        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray( to_unsigned(l) + to_unsigned(r) );
		return tmp;
	end "+";

	function "+" (l:gray_vector; r: integer        ) return gray_vector is
		variable tmp : gray_vector(l'range);
	begin
		tmp := to_gray( to_unsigned(l) + to_unsigned(r,l'length) );
		return tmp;
	end "+";

------------------------------------------------------------------------------------------------------
	--TO GRAY. this function performs the binary value conversion of a normal
	-- encoded bit vector and an gray encooded bit vector.
	function temp_gray_f000( input : std_logic_vector ) return  std_logic_vector is
		tmp  : std_logic_vector(input'range);
	begin
		tmp := to_unsigned(input,size);
		for j in tmp'range loop
			if j = input'high then
				tmp(j) := input(j);
			else
				tmp(j) := input(j+1) xor input(j);
			end if;
		end loop;
		return tmp;
	end temp_gray_f000;

	function temp_gray_f001 ( input : std_logic_vector	) return  gray_vector is
		tmp  : gray_vector(input'range);
	begin
		for j in input'range loop
			tmp(j) := input(j);
		end loop;
		return tmp;
	end temp_gray_f001;

	function temp_gray_f001 ( input : gray_vector	) return  std_logic_vector is
		tmp  : std_logic_vector(input'range);
	begin
		for j in input'range loop
			tmp(j) := input(j);
		end loop;
		return tmp;
	end temp_gray_f001;


end std_logic_gray;
