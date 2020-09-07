-- this library supports ONLY GF(2^m). It does not support any other prime. Yes, of course it
-- can be adapted for it.
--
--(a+bi)+(c+di)=(a+c)+(b+d)i
--(a+bi)-(c+di)=(a-c)+(b-d)i
--(a+bi)*(c+di)=(a*c-b*d)+(a*d+b*c)i
--
-- For division, remember euler identity.
--(a+bi)/(c+di)
--hpa/hpc * e ^( teta-tetc )j
--we also know:
--hp^2 = ad^2 + op^2
--cos(teta)=a/hpa
--sin(teta)=b/hpa
--cos(tetc)=c/hpc
--sin(tetc)=d/hpc
--finally, we know trigonometric identities
--cos(a-b) = cosa.cosb+sina.sinb
--sen(a-b) = sina.cosb-sinb.cosa
--To perform a division without cos and sin, we do:
-- Qre =  hpa/hpc * cos(teta-tetc)
-- Qre =  hpa/hpc * [(a/hpa)*(c/hpc)+(b/hpa)*(d/hpc)]
-- Qre = 1/hpc * [a*(c/hpc)+b*(d/hpc)]
-- Qre = 1/hpc^2 * (a*c+b*d)
-- Qre = (a.c+b.d)/(c^2+d^2)
-- Qim = hpa/hpc * sin(teta-tetc)
-- Qim = hpa/hpc * [(b/hpa)*(c/hpc)-(d/hpc)*(a/hpa)]
-- Qim = 1/hpc * [b*(c/hpc)-a*(d/hpc)
-- Qim = 1/hpc^2 * (b.c-a.d)
-- Qim = (b.c-a.d)/(c^2+d^2)
--
-- Integer result:
-- Q = floor( (a.c+b.d)/(c^2+d^2) ) + floor( (a.c+b.d)/(c^2+d^2) ) * j
--
-- REM Result:
-- REM = REM( (a.c+b.d)/(c^2+d^2) ) + REM( (a.c+b.d)/(c^2+d^2) ) * j
--
-- Note that this result is different from polar coordinate result without care:
-- Q = floor(A/C) * e^j(teta-tetc)
-- REM = rem(A/C) * e^j(teta-tetc)
--
--To be the same, they should be:
--
--Q   = floor(A/C*cos) + j*floor(A/C*sin)
--REM =   rem(A/C*cos) + j*rem(A/C*sin)
--------------------------------------------------------------------------------------------------------------
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	use IEEE.math_real.all;

package synth_complex is

  type complex_integer is record
    re : integer;
    im : integer;
  end record complex_integer;

  type complex_signed is record
    re : signed;
    im : signed;
  end record complex_signed;

--  type complex_sfixed is record
--    re : sfixed;
--    im : sfixed;
--  end record complex_sfixed;

	constant i_complex_integer : complex_integer := (re => 0, im => 1);

--	function to_complex_integer ( input : integer         ) return complex_integer;
--	function to_complex_integer ( input : unsigned        ) return complex_integer;
--	function to_complex_integer ( input : signed          ) return complex_integer;
--	function to_complex_integer ( input : complex_signed  ) return complex_integer;
--	function to_complex_integer ( input : complex_sfixed  ) return complex_integer;

--	function to_complex_signed  ( input : integer         ) return complex_signed;
--	function to_complex_signed  ( input : unsigned        ) return complex_signed;
--	function to_complex_signed  ( input : signed          ) return complex_signed;
--	function to_complex_signed  ( input : complex_integer ) return complex_signed;
--	function to_complex_signed  ( input : complex_sfixed  ) return complex_signed;

--	function to_complex_sfixed     ( input : integer         ) return complex_sfixed;
--	function to_complex_sfixed     ( input : unsigned        ) return complex_sfixed;
--	function to_complex_sfixed     ( input : signed          ) return complex_sfixed;
--	function to_complex_sfixed     ( input : complex_integer ) return complex_sfixed;
--	function to_complex_sfixed     ( input : complex_signed  ) return complex_sfixed;

	--Operadores
--	function "+"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

	function "+"   (l:complex_integer; r: complex_integer  ) return complex_integer;
	function "+"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "+"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "+"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "+"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "+"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "+"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "+"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "+"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "+"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "+"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "+"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "-"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "-"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "-"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "-"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "-"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "-"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "-"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "-"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "-"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "-"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "-"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "-"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "-"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "*"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "*"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "*"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "*"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "*"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "*"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "*"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "*"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "*"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "*"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "*"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "*"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "*"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "/"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "/"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "/"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "/"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "/"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "/"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "/"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "/"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "/"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "/"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "/"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "/"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "/"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

end synth_complex;

package body synth_complex is

	--function to_complex_integer ( input : integer         ) return complex_integer;
	--function to_complex_integer ( input : unsigned        ) return complex_integer;
	--function to_complex_integer ( input : signed          ) return complex_integer;
	--function to_complex_integer ( input : complex_signed  ) return complex_integer;

	function to_complex_integer ( input : complex_signed ) return complex_integer is
		variable tmp : complex_integer;
	begin
		tmp.re := to_integer(input.re);
		tmp.im := to_integer(input.im);
		return tmp;
	end to_complex_integer;

--	function "+"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

	function "+"   (l:complex_integer; r: complex_integer  ) return complex_integer is
		variable tmp : complex_integer;
	begin
		tmp.re := l.re + r.re;
		tmp.im := l.im + r.im;
		return tmp;
	end "+";

	function "+"   (l:complex_integer; r: complex_signed   ) return complex_integer	is
		variable tmp : complex_integer;
	begin
		tmp := l + to_complex_integer(r);
		return tmp;
	end "+";

--	function "+"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "+"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "+"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "+"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "+"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "+"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "+"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "+"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "+"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "+"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "-"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "-"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "-"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "-"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "-"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "-"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "-"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "-"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "-"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "-"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "-"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "-"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "-"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "*"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "*"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "*"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "*"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "*"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "*"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "*"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "*"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "*"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "*"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "*"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "*"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "*"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

--	function "/"   (l:complex_sfixed;  r: complex_sfixed   ) return complex_integer;

--	function "/"   (l:complex_integer; r: complex_integer  ) return complex_integer;
--	function "/"   (l:complex_integer; r: complex_signed   ) return complex_integer;
--	function "/"   (l:complex_integer; r: signed           ) return complex_integer;
--	function "/"   (l:complex_integer; r: unsigned         ) return complex_integer;
--	function "/"   (l:complex_integer; r: integer          ) return complex_integer;
--	function "/"   (l:complex_integer; r: std_logic_vector ) return complex_integer;

--	function "/"   (l:complex_signed;  r: complex_signed   ) return complex_signed;
--	function "/"   (l:complex_signed;  r: complex_integer  ) return complex_signed;
--	function "/"   (l:complex_signed;  r: signed           ) return complex_signed;
--	function "/"   (l:complex_signed;  r: unsigned         ) return complex_signed;
--	function "/"   (l:complex_signed;  r: integer          ) return complex_signed;
--	function "/"   (l:complex_signed;  r: std_logic_vector ) return complex_signed;

end synth_complex;
