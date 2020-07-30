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
--          field_generator(8 downto 0) => (8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0')
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
	-------------------------------------------------------------------------------------------------------
	--READ THIS IF YOU GOT SYNTAX ERRORS:
	--
	--Manufacturers still do not support generics on packages for simulation.
	--
	--If you need to use VIVADO_SIM, for example, comment the "Generic" field below and
	--uncomment the two constants afterwards. The annoying part of it is having to copy this repo
	--on every project and to edit it. My recommendation is to simulate and go back to generic format
	--when it is working as intended.
	-------------------------------------------------------------------------------------------------------
	generic (
	 	field_order     : integer := 8;
		field_generator : std_logic_vector(field_order downto 0) := (others=>'0')
	);
  --constant field_generator : std_logic_vector(8 downto 0) := (8=>'1', 4=>'1', 3=>'1', 2=>'1', 0=>'1', others=>'0');
	--constant field_order     : integer := 8;

	--these function return the order of any polynome. we will need this to create a galois type.
	function get_order ( input : std_logic_vector ) return integer;
	--this functions returns the roots for the field baed on the field generator.


	--with the order, we create a galois type. Galois operation on galois type are automatic.
	type galois_vector   is array (field_order-1 downto 0) of std_logic;
	type galois_polynome is array (NATURAL RANGE <>) of galois_vector;
	--type galois_pipe     is array (NATURAL RANGE <>) of galois_polynome;
	type galois_pipe     is array (6 downto 0) of galois_polynome(6 downto 0);

	--function that generates the field roots.
	function field_roots_func          return galois_polynome;
	function field_inverted_roots_func return galois_polynome;
	--constant to be used with field roots.
	constant field_roots     : galois_polynome(2**field_order-2 downto 0) := field_roots_func;
	constant field_inv_roots : galois_polynome(2**field_order-2 downto 0) := field_inverted_roots_func;

	--function to_galois_vector ( input : galois_value;     field : to_galois_vector ) return galois_vector;
	function to_galois_vector ( input : std_logic_vector ) return galois_vector;
	function to_galois_vector ( input : unsigned         ) return galois_vector;
	function to_galois_vector ( input : integer          ) return galois_vector;

	function to_std_logic_vector ( input : galois_vector ) return std_logic_vector;
	function to_unsigned         ( input : galois_vector ) return unsigned;
	function to_integer          ( input : galois_vector ) return integer;

	--Operadores
	function "+"   (l:galois_vector;   r: galois_vector   ) return galois_vector;
	function "+"   (l:galois_polynome; r: galois_polynome ) return galois_polynome;
	function "-"   (l:galois_vector;   r: galois_vector   ) return galois_vector;
	function "-"   (l:galois_polynome; r: galois_polynome ) return galois_polynome;

	function "*"   (l:galois_vector;   r: galois_vector   ) return galois_vector;
	function "*"   (l:integer;         r: galois_vector   ) return galois_vector;
	function "*"   (l:galois_polynome; r: galois_polynome ) return galois_polynome;
	function "*"   (l:galois_polynome; r: galois_vector   ) return galois_polynome;
	function "/"   (l:galois_vector;   r: galois_vector   ) return galois_vector;
	function "/"   (l:galois_polynome; r: galois_polynome ) return galois_polynome;
	function "/"   (l:galois_polynome; r: galois_vector   ) return galois_polynome;
	function "mod" (l:galois_vector;   r: galois_vector   ) return galois_vector;
	function "mod" (l:galois_polynome; r: galois_polynome ) return galois_polynome;

	function "**"  (l:galois_vector; r: integer      ) return galois_vector;
	function "**"  (l:galois_vector; r: unsigned     ) return galois_vector;
	function "**"  (l:galois_vector; r: signed       ) return galois_vector;

	--function "rem" (l:galois_vector; r: galois_vector) return std_logic_vector;
	function "="   (l:galois_vector; r: galois_vector) return boolean;
	function "/="  (l:galois_vector; r: galois_vector) return boolean;
	function ">"   (l:galois_vector; r: galois_vector) return boolean;
	function "<"   (l:galois_vector; r: galois_vector) return boolean;
	function ">="  (l:galois_vector; r: galois_vector) return boolean;
	function "<="  (l:galois_vector; r: galois_vector) return boolean;

	function "="   (l:galois_vector; r: std_logic_vector) return boolean;
	function "/="  (l:galois_vector; r: std_logic_vector) return boolean;
	function ">"   (l:galois_vector; r: std_logic_vector) return boolean;
	function "<"   (l:galois_vector; r: std_logic_vector) return boolean;
	function ">="  (l:galois_vector; r: std_logic_vector) return boolean;
	function "<="  (l:galois_vector; r: std_logic_vector) return boolean;

	function "sll"  (l:galois_polynome; r: integer) return galois_polynome;

	--some galois operators
	function galois_reduce ( input : std_logic_vector ) return galois_vector;
	function galois_inv    ( input : galois_vector    ) return galois_vector;
	function get_order     ( input : galois_vector    ) return integer;
	function get_order     ( input : galois_polynome  ) return integer;
	function galois_mult   ( l     : galois_vector;   r: galois_vector ) return std_logic_vector;

	--generic functions for polynome operations
	function evaluate      ( input : galois_polynome; x_input : galois_vector) return galois_vector;
	function root_locator  ( input : galois_polynome ) return galois_polynome;

	--procedure pipeline_mult (l: in galois_polynome; r: in galois_polynome; result : out galois_polynome; signal tmp : inout std_logic_vector );
	procedure pipeline_mod ( signal l: in galois_polynome; signal r: in galois_polynome; result : out galois_polynome; signal reg : inout galois_pipe );

	--some important internal constants.
	constant b_integer   : integer := 2**field_order-2;

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
	       tmp(j) := input(input'low+j);
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

	function to_integer( input : galois_vector ) return integer is
	begin
		return to_integer(to_unsigned(input));
	end to_integer;

	function "+" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector;
	begin
	   for j in tmp'range loop
	   	tmp(j) := l(j) xor r(j);
	   end loop;
	   return tmp;
	end "+";

	function "+" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		--variable tmp : galois_polynome( maximum(l'high,r'high) - 1 downto 0); --when vivado sim support this, remove this comment.
		variable tmp : galois_polynome( l'high + r'high downto 0);
		variable size : integer;
	begin
		if l'high > r'high then
			size := l'high;
		else
			size := r'high;
		end if;

	  for j in size downto 0 loop
			if j >= l'length then
	   		tmp(j) := r(j);
			elsif j >= r'length then
				tmp(j) := l(j);
			else
				tmp(j) := l(j) + r(j);
			end if;
	  end loop;
	  return tmp(size downto 0);
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
		--variable tmp : galois_polynome( maximum(l'high,r'high) - 1 downto 0); --when vivado sim support this, remove this comment.
		variable tmp : galois_polynome( l'high + r'high downto 0);
		variable size : integer;
	begin
		if l'high > r'high then
			size := l'high;
		else
			size := r'high;
		end if;

	  for j in size downto 0 loop
			if j >= l'length then
	   		tmp(j) := r(j);
			elsif j >= r'length then
				tmp(j) := l(j);
			else
				tmp(j) := l(j) - r(j);
			end if;
	  end loop;
	  return tmp(size downto 0);
	end "-";

	function "*" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : std_logic_vector( (l'high+r'high) downto 0);
		variable tmp2 : galois_vector;
	begin
        --if it is to be put on a pipeline, just copy this.
        tmp  := galois_mult(l,r);
				tmp2 := galois_reduce(tmp);
        return tmp2;

	end "*";

	function "*" (l:integer; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector;
	begin
		tmp := r;
  	if l mod 2 = 0 then
			tmp := to_galois_vector(0);
		end if;
		return tmp;
	end "*";

	function "*" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp : galois_polynome( l'high + r'high downto 0 ) := (others=>(others=>'0'));
	begin
	  --primeiro a multiplicação
	  for j in l'range loop
	    for k in r'range loop
	        tmp(j+k) := tmp(j+k) + ( l(j) * r(k) );
	    end loop;
	  end loop;
	  return tmp;
	end "*";

	--Galois scalar multiplication
	function "*" (l:galois_polynome; r: galois_vector        ) return galois_polynome is
		variable tmp : galois_polynome(l'range ) := (others=>(others=>'0'));
	begin
	  --primeiro a multiplicação
	  for j in l'range loop
        tmp(j) := l(j) * r;
	  end loop;
	  return tmp;
	end "*";

	function "/" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector := (others=>'0');
	begin
		--dw don't do "l/r", instead we do "l * r ^ (-1)"
		tmp := l * galois_inv(r);
		return tmp;
	end "/";


	function "/" (l:galois_polynome; r: galois_vector        ) return galois_polynome is
		variable tmp : galois_polynome(l'range);
	begin
		for j in l'range loop
			tmp(j) := l(j) / r;
		end loop;
		return tmp;
	end "/";

	function "/" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp     : galois_polynome(l'range) := (others=>(others=>'0'));
		variable tmp1    : galois_vector            := (others=>'0');
		variable result  : galois_polynome(l'range) := (others=>(others=>'0'));
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);
		for j in l'high downto 0 loop
			if j < r_order then
				--we do nothing.
			elsif tmp(j) > to_galois_vector(0) then
				result(j-r_order) := tmp(j) * galois_inv(r(r_order));
				for k in 1 to r_order loop
					tmp(j-k) := tmp(j-k) - ( result(j-r_order) * r(r_order-k) );
				end loop;
				tmp(j) := to_galois_vector(0);
			end if;
		end loop;
		return result;

	end "/";


	function "**"  (l:galois_vector; r: integer        ) return galois_vector is
		variable tmp     : galois_vector           := to_galois_vector(1);
		variable exp_tmp : integer := 0;
	begin

		exp_tmp := r;

		if r < 0 then
			exp_tmp := exp_tmp * (-1);
		end if;

		for j in 1 to exp_tmp loop
			tmp := tmp * l;
		end loop;

		if r < 0 then
			tmp := galois_inv(tmp);
		end if;

		return tmp;
	end "**";

	function "**"  (l:galois_vector; r: unsigned        ) return galois_vector is
		variable tmp     : galois_vector           := to_galois_vector(1);
	begin
		--this is dangerous and will generate huge unfeasible hardware
		--(as for 2020, like dividers in 2010. Maybe this comment will be laughable in 2030)
		for j in 0 to to_integer(r) loop
			tmp := tmp * l;
		end loop;

		report "Variable exponential operation detected. Be sure that this is intended." severity note;
		return tmp;
	end "**";

	function "**"  (l:galois_vector; r: signed        ) return galois_vector is
		variable tmp     : galois_vector   := to_galois_vector(1);
		variable exp_tmp : signed(r'range) := (others=>'0');
		variable check   : boolean;
	begin

		check := r < to_signed(0,r'length);

		if check then
			exp_tmp := exp_tmp * (-1);
		end if;

		tmp     := tmp ** unsigned(exp_tmp);

		if check then
			tmp := galois_inv(tmp);
		end if;

		return tmp;
	end "**";

	function "mod" (l:galois_vector; r: galois_vector        ) return galois_vector is
		variable tmp : galois_vector := (others=>'0');
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);
		--for j in l_order downto r_order loop --we fix the boundaries. tool likes it.
		for j in tmp'range loop
			if j <= l_order and j >= r_order then
				if l(j) = '1' then
					for k in 0 to r_order loop
						--order 8 poly fits on 9 bits, 8 downto 0.
						--we go until tmp bits 8 downto 0 get xored by gen poly.
						tmp(j-k) := tmp(j-k) xor r(r_order-k);
					end loop;
				end if;
			end if;
		end loop;
		return tmp(l'range);
	end "mod";

	function "mod" (l:galois_polynome; r: galois_polynome        ) return galois_polynome is
		variable tmp     : galois_polynome(l'range) := (others=>(others=>'0'));
		variable tmp1    : galois_vector            := (others=>'0');
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);
		for j in l_order downto r_order loop --length = high+1
			if tmp(j) > to_galois_vector(0) then
				for k in 1 to r_order loop
					tmp(j-k) := tmp(j-k) - ( tmp(j) * galois_inv(r(r'high)) * r(r_order-k) );
				end loop;
				tmp(j) := to_galois_vector(0);
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

	function "=" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) = unsigned(r);
		return tmp;
	end "=";

	function "/=" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) /= unsigned(r);
		return tmp;
	end "/=";

	function ">" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) > unsigned(r);
		return tmp;
	end ">";

	function ">=" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) >= unsigned(r);
		return tmp;
	end ">=";

	function "<" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) < unsigned(r);
		return tmp;
	end "<";

	function "<=" (l:galois_vector; r: std_logic_vector        ) return boolean is
		variable tmp : boolean;
	begin
		tmp := to_unsigned(l) <= unsigned(r);
		return tmp;
	end "<=";


  function "sll"  (l:galois_polynome; r: integer) return galois_polynome is
		variable tmp : galois_polynome;
	begin
		if (r > 0) and (l'length > 1) then
			tmp(l'high downto r) := tmp(l'high-r downto 0);
			tmp(r-1 downto 0)    := (others=>(others=>'0'));
		else
			tmp := l;
		end if;
		return tmp;
	end "sll";


	function galois_inv (input : galois_vector ) return galois_vector is
		variable tmp   : galois_vector           := to_galois_vector(0);
	begin
		--we use fermat for Galois inversion. note that a^(-1) = a^(2^m - 2)
		--thus, we calculate. Galois is nice because it keeps multiplication at bay.

		-- hard way:
		for j in 1 to 2**field_order-2 loop
			if to_galois_vector(j) * input = to_galois_vector(1) then
				tmp := to_galois_vector(j);
			end if;
		end loop;
		return tmp;
	end galois_inv;

	--This function takes vectors larger outside the field and put them inside it.
	function galois_reduce ( input:std_logic_vector ) return galois_vector is
		variable tmp         : std_logic_vector(input'range) := (others=>'0');
	begin
		tmp := input;
    for j in tmp'high downto field_order loop
        if tmp(j) = '1' then
            for k in 0 to field_order loop
                --order 8 poly fits on 9 bits, 8 downto 0.
                --we go until tmp bits 8 downto 0 get xored by gen poly.
                tmp(j-k) := tmp(j-k) xor field_generator(field_order-k);
            end loop;
        end if;
    end loop;
		return to_galois_vector(tmp(field_order-1 downto 0));
	end galois_reduce;

	function galois_mult (l:galois_vector; r: galois_vector        ) return std_logic_vector is
		variable tmp : std_logic_vector( (l'high+r'high) downto 0) := (others=>'0');
	begin
        --primeiro a multiplicação
        for j in l'range loop
          for k in r'range loop
              tmp(j+k) := tmp(j+k) xor ( l(j) and r(k) );
          end loop;
        end loop;
        --depois a redução.
        return tmp;
	end galois_mult;

	function evaluate ( input:galois_polynome; x_input : galois_vector) return galois_vector is
		variable tmp : galois_vector;
	begin
		--TO DO: should change to horner's method.
		tmp := to_galois_vector(0);
		for j in input'range loop
			tmp := (input(J) * (x_input ** j) ) + tmp;
		end loop;
		return tmp;
	end evaluate;

	function part_div ( l: galois_polynome; r: galois_polynome) return galois_polynome is
		variable tmp     : galois_polynome(l'range) := (others=>(others=>'0'));
		variable tmp1    : galois_vector            := (others=>'0');
		variable r_order : integer;
		variable l_order : integer;
	begin
		--depois a redução.
		tmp := l;
		r_order := get_order(r);
		l_order := get_order(l);

		if l_order >= r_order then
			for k in r'range loop
				if k = 0 then
					tmp(l_order) := to_galois_vector(0);
				elsif k <= r_order then
					tmp(l_order-k) := l(l_order-k) - ( l(l_order) * galois_inv(r(r'high)) * r(r_order-k) );
				end if;
			end loop;


		end if;
		return tmp;
	end part_div;

	procedure pipeline_mult ( signal l: in galois_vector; signal r: in galois_vector; result : out galois_vector; signal reg : inout std_logic_vector ) is
	begin
		reg    <= galois_mult(l,r);
		result := galois_reduce(reg);
	end pipeline_mult;

	--usage:
	-- to make reminder = poly1 mod poly2 do:
	-- note the signal below. in the future, when Xilinx supports array of array we may ue it;
	-- for now, we suffer. declare as below.
	-- signal poly1_pipe : galois_polynome(poly1'length ** 2 -1 downto 0);
	--
	--process(clk)
	--begin
	--	if rising_edge(clk)
	--		pipeline_mod(poly1,poly2,reminder,poly1_pipe)
	-- end if;
	--end process;
  --
	-- and that is all folks. it has the same number of steps as POLY1 has elements
	-- if poly1 is (7 downto 0), pipeline will have 8 steps.
	--
	procedure pipeline_mod ( signal l: in galois_polynome; signal r: in galois_polynome; result : out galois_polynome; signal reg : inout galois_pipe ) is
		variable r_order : integer;
	begin

		for j in reg'range loop
			if j = 0 then
				reg(0) <= l;
			else
				reg(j) <= part_div(reg(j-1),r);
			end if;
		end loop;
		result := reg(reg'high);
	end pipeline_mod;

	function field_roots_func return galois_polynome is
		variable tmp : galois_polynome(2**field_order-2 downto 0);
	begin
		tmp(0) := to_galois_vector(1);
		for j in 1 to 2**field_order-2 loop
			tmp(j) := tmp(j-1) * to_galois_vector(2);
		end loop;
		return tmp;
	end field_roots_func;

	function field_inverted_roots_func return galois_polynome is
		variable tmp : galois_polynome(2**field_order-2 downto 0);
	begin
		tmp := field_roots_func;
		for j in 0 to 2**field_order-2 loop
			tmp(j) := galois_inv(tmp(j));
		end loop;
		return tmp;
	end field_inverted_roots_func;

	function root_locator(input:galois_polynome) return galois_polynome is
		variable tmp : galois_polynome(input'range) := (others=>(others=>'0'));
		variable k   : integer                      := 0;
	begin
		for j in 1 to 2**field_order-1 loop
			if (k <= tmp'high) and (evaluate(input,to_galois_vector(j)) = to_galois_vector(0)) then
				tmp( k ) := to_galois_vector( j );
				k := k + 1;
			end if;
		end loop;
		return tmp;
	end root_locator;

end std_logic_galois;
