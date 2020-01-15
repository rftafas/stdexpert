-- this library supports ONLY GF(2^m). It does not support any other prime. Yes, of course it
-- can be adapted for it.
--
--
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
--          polynome_vector(8 downto 0) => (8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0')
--      );
--  use work.std_logic_galois_8.all -- it must be work.
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
	use IEEE.math_real.all;

package std_logic_galois is
	generic(
		field_order     : integer := 8;
	  polynome_vector : std_logic_vector(field_order downto 0) := (others=>'0')
	);
  --constant polynome_vector : std_logic_vector(8 downto 0) := (8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0');

	--these function return the order of any polynome. we will need this to create a galois type.
	function get_order ( input : std_logic_vector ) return integer;
	--constant field_order : integer := get_order(polynome_vector);

	--with the order, we create a galois type. Galois operation on galois type are automatic.
	type galois_vector   is array (field_order-1 downto 0) of std_logic;
	type galois_polynome is array (NATURAL RANGE <>) of galois_vector;

	--function to_galois_vector ( input : galois_value;     field : to_galois_vector ) return galois_vector;
	function to_galois_vector ( input : std_logic_vector ) return galois_vector;
	function to_galois_vector ( input : unsigned         ) return galois_vector;
	function to_galois_vector ( input : integer          ) return galois_vector;

	function to_std_logic_vector ( input : galois_vector ) return std_logic_vector;
	function to_unsigned         ( input : galois_vector ) return unsigned;
	--function to_integer          ( input : galois_vector ) return integer;

	function galois_reduce (input : std_logic_vector) return galois_vector;
	function galois_inv    (input : galois_vector   ) return galois_vector;
	function get_order     ( input : galois_vector  ) return integer;

	--Operadores
	function "+"   (l:galois_vector; r: galois_vector      ) return galois_vector;
	function "-"   (l:galois_vector; r: galois_vector      ) return galois_vector;

	function "*"   (l:galois_vector; r: galois_vector) return galois_vector;
	function "/"   (l:galois_vector; r: galois_vector) return galois_vector;
	function "mod" (l:galois_vector; r: galois_vector) return galois_vector;
	function "mod" (l:galois_polynome; r: galois_polynome) return galois_polynome;
	--function "rem" (l:galois_vector; r: galois_vector) return std_logic_vector;
	function "="   (l:galois_vector; r: galois_vector) return boolean;
	function "/="  (l:galois_vector; r: galois_vector) return boolean;
	function ">"   (l:galois_vector; r: galois_vector) return boolean;
	function "<"   (l:galois_vector; r: galois_vector) return boolean;
	function ">="  (l:galois_vector; r: galois_vector) return boolean;
	function "<="  (l:galois_vector; r: galois_vector) return boolean;

	constant b_integer : integer := 2**field_order-2;
	constant b_size    : integer := integer(ceil(log2(real(b_integer))));
	constant b_value   : unsigned(b_size-1 downto 0) := to_unsigned(b_integer, b_size);

end std_logic_galois;

package body std_logic_galois is

  function get_order ( input : std_logic_vector ) return integer is
      variable tmp : integer := 0;
  begin
    for j in input'range loop
      if input(j) = '1' then
        if j > tmp then
          tmp := j;
        end if;
      end if;
    end loop;
    return tmp;
  end get_order;

	function get_order ( input : galois_vector ) return integer is
		variable tmp : std_logic_vector(input'range);
  begin
		tmp := to_std_logic_vector(input);
    return get_order(tmp);
  end get_order;

	function get_order ( input : galois_polynome ) return integer is
      variable tmp : integer := 0;
  begin
    for j in input'range loop
      if input(j) /= to_galois_vector(0) then
        if j > tmp then
          tmp := j;
        end if;
      end if;
    end loop;
    return tmp;
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

	--function to_integer( input : galois_vector ) return integer is
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

	function "+" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp : galois_polynome;
	begin
	   for j in tmp'range loop
	   	tmp(j) := l(j) + r(j);
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

	function "-" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp : galois_polynome;
	begin
		 for j in tmp'range loop
			tmp(j) := l(j) - r(j);
		 end loop;
		 return tmp;
	end "-";

	function "*" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : std_logic_vector( (l'high+r'high) downto 0) := (others=>'0');
	begin
        --primeiro a multiplicação
        for j in l'range loop
          for k in r'range loop
              tmp(j+k) := tmp(j+k) xor ( l(j) and r(k) );
          end loop;
        end loop;
        --depois a redução.
        return galois_reduce(tmp);
	end "*";

	function "*" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp : galois_polynome( (l'length + r'length - 1) downto 0 ) := (others=>(others=>'0'));
	begin
	  --primeiro a multiplicação
	  for j in l'range loop
	    for k in r'range loop
	        tmp(j+k) := tmp(j+k) + ( l(j) * r(k) );
	    end loop;
	  end loop;
	  return tmp;
	end "*";

	function galois_inv (input : galois_vector ) return galois_vector is
		variable tmp : galois_vector := (0=>'1', others=>'0');
		variable b_tmp : unsigned(b_value'range) := b_value;
	begin
		--we use fermat for Galois inversion. note that a^(-1) = a^(2^m - 2)
		--thus, we calculate. Galois is nice because it keeps multiplication at bay.

		-- hard way:
		--for j in 1 to field_order-2 loop
		--	tmp := tmp * input;
		--end loop;
		--return tmp;

		--best synth result
		b_tmp := b_value;
		tmp   := input;

		for j in b_tmp'range loop
			if b_tmp > 1 then
				if b_tmp(0) = '1' then
					b_tmp := b_tmp - 1;
					tmp := tmp * input;
				else
					b_tmp := '0' & b_tmp(b_tmp'high-1 downto 0);
					tmp := tmp * tmp;
				end if;
			end if;
		end loop;
		return tmp;
	end galois_inv;

	function "/" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector := (others=>'0');
	begin
		--dw don't do "l/r", instead we do "l * r ^ (-1)"
		tmp := l * galois_inv(r);
		return tmp;
	end "/";

	--This function takes vectors larger outside the field and put them inside it.
	function galois_reduce ( input:std_logic_vector ) return galois_vector is
		variable tmp         : std_logic_vector(input'range) := (others=>'0');
	begin
		tmp         := input;
        for j in input'high downto field_order loop
            if input(j) = '1' then
                for k in 0 to field_order loop
                    --order 8 poly fits on 9 bits, 8 downto 0.
                    --we go until tmp bits 8 downto 0 get xored by gen poly.
                    tmp(j-k) := tmp(j-k) xor polynome_vector(field_order-k);
                end loop;
            end if;
        end loop;
		return to_galois_vector(tmp(field_order-1 downto 0));
	end galois_reduce;

	function "mod" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector := (others=>'0');
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
		variable tmp     : galois_polynome(l'range) := (others=>(others=>'0'));
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
