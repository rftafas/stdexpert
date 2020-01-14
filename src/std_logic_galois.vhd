--USAGE:
-- must declare desider field. from there, we calculate the Galois word size,
-- galois vector size
-- needed for rest of operation.
--
--For example, for the classif GF(8) = x^8 + x^4 + x^3 + x + 1
--declare it like this:
--
--
--library expert;
--  package std_logic_galois_8 is new expert.std_logic_galois
--      generic map (
--          size => 8,
--          field => (8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0')
--      );
--  use expert.std_logic_galois_8.all
--
-- then you can use signals. Galois vector are composed by a field and a value. declare it like:
--
-- signal galois_number : galois_vector;
--
--and attribute it like this:
--
--galois_number.value <= x"AB";
--galois_number.field <= (8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0');
--
--or one can operate it with + and *
--
--galois_product <= galois_factor1 * galois_factor2;
--------------------------------------------------------------------------------------------------------------
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

package std_logic_galois is
	generic(
	    polynome_vector : std_logic_vector
	);

	--these function return the order of any polynome. we will need this to create a galois type.
	function get_order ( input : std_logic_vector ) return integer;
	constant field_order : integer := get_order(polynome_vector);

	--with the order, we create a galois type. Galois operation on galois type are automatic.
	type galois_vector is array (field_order-1 downto 0) of std_logic;
	type galois_polynome is array (NATURAL RANGE <>) of galois_vector;

	--function to_galois_vector ( input : galois_value;     field : to_galois_vector ) return galois_vector;
	function to_galois_vector ( input : std_logic_vector ) return galois_vector;
	function to_galois_vector ( input : unsigned         ) return galois_vector;
	function to_galois_vector ( input : integer          ) return galois_vector;

	function to_std_logic_vector ( input : galois_vector ) return std_logic_vector;
	function to_unsigned         ( input : galois_vector ) return unsigned;
	--function to_integer          ( input : galois_vector ) return integer;

	--Operadores
	function "+"   (l:galois_vector; r: galois_vector      ) return galois_vector;
	function "-"   (l:galois_vector; r: galois_vector      ) return galois_vector;

	function "*"   (l:galois_vector; r: galois_vector) return galois_vector;
	--function "/"   (l:gray_vector; r: gray_vector) return std_logic_vector;
	function "mod" (l:gray_vector; r: gray_vector) return std_logic_vector;
	--function "rem" (l:gray_vector; r: gray_vector) return std_logic_vector;
	function "="   (l:galois_vector; r: galois_vector) return boolean;
	function "/="  (l:galois_vector; r: galois_vector) return boolean;
	function ">"   (l:galois_vector; r: galois_vector) return boolean;
	function "<"   (l:galois_vector; r: galois_vector) return boolean;
	function ">="  (l:galois_vector; r: galois_vector) return boolean;
	function "<="  (l:galois_vector; r: galois_vector) return boolean;

	function get_order ( input : galois_vector ) return integer;
	constant polynome_field : galois_vector(polynome_vector'range) := to_galois_vector(polynome_vector);

end std_logic_galois;

package body std_logic_galois is



  function get_order ( input : std_logic_vector ) return integer is
      variable tmp : integer := 0;
  begin
    for j in galois_gen_poly'range loop
      if galois_gen_poly(j) = '1' then
        if j > tmp then
          tmp := j;
        end if;
      end if;
    end loop;
    return tmp;
  end get_order;

	function get_order ( input : galois_vector ) return integer is
		variable tmp : std_logic_vector(input'range) := 0;
  begin
		tmp := to_std_logic_vector(input);
    return get_order(tmp);
  end get_order;

	function to_galois_vector ( input : std_logic_vector) return galois_vector is
	   variable tmp : galois_vector;
	begin
	   for j in tmp'range loop
	       tmp(j) := input(j);
       end loop;
	   return tmp;
	end to_galois_vector;

	function to_galois_vector ( input : unsigned ) return galois_vector is
	   variable tmp : galois_vector;
	begin
		   for j in tmp'range loop
	       tmp(j) := input(j);
       end loop;
	   return tmp;
	end to_galois_vector;

	function to_galois_vector ( input : integer ) return galois_vector is
	   variable tmp : galois_vector;
	   variable tmp2 : unsigned(tmp'range);
	begin
	    tmp2 := to_unsigned(input,field_order);
		for j in tmp'range loop
	       tmp(j) := tmp2(j);
       end loop;
	   return tmp;
	end to_galois_vector;

	function to_std_logic_vector ( input : galois_vector	) return  std_logic_vector is
		variable tmp : std_logic_vector(input'range);
	begin
		for j in input'range loop
			tmp(j) := input(j);
		end loop;
		return tmp;
	end to_std_logic_vector;

	function to_unsigned ( input : galois_vector ) return unsigned is
	   variable tmp : unsigned(input'range);
	begin
		for j in tmp'range loop
	       tmp(j) := input(j);
       end loop;
	   return tmp;
	end to_unsigned;

	--function to_integer( input : gray_vector ) return integer is
	--begin
	--end to_integer;

	function "+" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector;
	begin
	   for j in tmp'range loop
	   	tmp(j) := l(j) xor r(j);
	   end loop;
	   return tmp;
	end "+";

	function "-" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector;
	begin
	   for j in tmp'range loop
	   	tmp(j) := l(j) xor r(j);
	   end loop;
	   return tmp;
	end "-";

	function "*" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector( (l'high+r'high) downto 0) := (others=>'0');
	begin
        --primeiro a multiplicação
        for j in l'range loop
          for k in r'range loop
              tmp(j+k) := tmp(j+k) xor ( l(j) and r(k) );
          end loop;
        end loop;
        --depois a redução.
        tmp := tmp mod polynome_field;
        return tmp(l'range);
	end "*";

	function "/" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector( (l'range) := (others=>'0');
	begin
		tmp := to_galois_vector( to_unsigned(l) / to_unsigned(r) );
		return tmp;
	end "/";

	function "mod" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector( (l'range) := (others=>'0');
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);
		for j in l_order downto r_order loop --length = high+1
			if l(j) = '1' then
				for k in 0 to r_order loop
					--order 8 poly fits on 9 bits, 8 downto 0.
					--we go until tmp bits 8 downto 0 get xored by gen poly.
					tmp(j-k) := tmp(j-k) xor r(r_order-k);
				end loop;
			end if;
		end loop;
		return tmp(l'range);
	end "mod";

	function "mod" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp     : galois_polynome(l'range) := (others=>'0');
		variable tmp2    : galois_vector  (l'range) := (others=>'0');
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);
		for j in l_order downto r_order loop --length = high+1
			if l(j) > to_galois_vector(0) then
				for k in 0 to r_order loop
					tmp(j-k) := tmp(j-k) + ( l(j) * r(r_order-k) );
				end loop;
			end if;
		end loop;
		return tmp(l'range);
	end "mod";

	function "=" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) = to_unsigned(r);
		return tmp;
	end "=";

	function "/=" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) /= to_unsigned(r);
		return tmp;
	end "/=";

	function ">" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) > to_unsigned(r);
		return tmp;
	end ">";

	function ">=" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) >= to_unsigned(r);
		return tmp;
	end ">=";

	function "<" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) < to_unsigned(r);
		return tmp;
	end "<";

	function "<=" (l:galois_vector; r: galois_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) <= to_unsigned(r);
		return tmp;
	end "<=";

end std_logic_galois;
