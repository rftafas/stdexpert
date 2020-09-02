library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package std_text is

	--Operadores
	function "%"   (l:string;  r: integer          ) return string;
	function "%"   (l:string;  r: std_logic_vector ) return string;
	function "%"   (l:string;  r: signed           ) return string;
	function "%"   (l:string;  r: unsigned         ) return string;

end std_text;

package body std_text is

	function "%"   (l:string;  r: integer ) return string is
	begin

	end "%";

end std_text;
