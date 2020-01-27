----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 13.01.2020 15:54:30
-- Design Name:
-- Module Name: test_galois - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library expert;
--  package std_logic_galois_8 is new expert.std_logic_galois
--      generic map (
--          field_order     => 8,
--          polynome_vector => "100011011"--( 8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0' ) --"100011011"
--      );
--  use work.std_logic_galois_8.all;
  use expert.std_logic_galois.all;
library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;
library stdblocks;
  use stdblocks.sync_lib.all;
  use stdblocks.ram_lib.all;
  use stdblocks.fifo_lib.all;

entity test_galois is
end test_galois;

architecture Behavioral of test_galois is
    
    --testing something on library.
    constant test_field_roots : galois_polynome(field_roots'range) := field_roots;

    signal input1    : std_logic_vector(7 downto 0);
    signal input2    : std_logic_vector(7 downto 0);

    signal ck : std_logic := '0';
    
    signal a_s        : galois_vector;
    signal b_s        : galois_vector;
    signal mult_s     : galois_vector;
    signal div_s      : galois_vector;
    signal mod_s      : galois_vector;
    signal inv_s      : galois_vector;
    --for partial multiplication functions
    signal mult_tmp_s : std_logic_vector(14 downto 0) := (others=>'0');
    signal reduce_s   : galois_vector;


    type vec_temp is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);
    constant poly_tmp : vec_temp(4 downto 0) := (x"01", x"0f", x"36", x"78", x"40" );
    constant  msg_tmp : vec_temp(2 downto 0) := (x"12", x"34", x"56" );
    

    --POLYNOMIAL OPS TEST
    constant a_poly  : galois_polynome(2 downto 0) := (
        to_galois_vector(msg_tmp(2)),
        to_galois_vector(msg_tmp(1)),
        to_galois_vector(msg_tmp(0))
    );
    constant b_poly : galois_polynome(4 downto 0) := (
        4      => to_galois_vector(1),
        others => to_galois_vector(0)
    );

    constant generator_poly : galois_polynome(4 downto 0) := (
        to_galois_vector(poly_tmp(4)),
        to_galois_vector(poly_tmp(3)),
        to_galois_vector(poly_tmp(2)),
        to_galois_vector(poly_tmp(1)),
        to_galois_vector(poly_tmp(0))
    );
    
    --constant generator_poly_roots : galois_polynome(generator_poly'range) := root_locator(generator_poly);
    signal generator_poly_roots : galois_polynome(generator_poly'range);
    
    signal mult_poly : galois_polynome(6 downto 0);
    signal div_poly  : galois_polynome(6 downto 0);
    signal mod_poly  : galois_polynome(6 downto 0);

    --RS(7,3). We have some constants:
    constant cons_n : integer := 7;
    constant cons_k : integer := 3;
    constant cons_t : integer := 4; --t=n-k



    constant msg_poly : galois_polynome(cons_k - 1 downto 0) := (
        to_galois_vector(msg_tmp(2)),
        to_galois_vector(msg_tmp(1)),
        to_galois_vector(msg_tmp(0))
    );
    
    constant x_n_poly : galois_polynome(cons_t downto 0) := (
        cons_t => to_galois_vector(1),
        others => to_galois_vector(0)
    );
    
    signal msg_to_tx  : galois_polynome(cons_n-1 downto 0) := (others=>(others=>'0'));
    signal error_poly : galois_polynome(cons_n-1 downto 0) := (
        cons_n-1 => to_galois_vector(1),
        others   => (others=>'0')
    );
    signal msg_err     : galois_polynome(cons_n-1 downto 0) := (others=>(others=>'0'));


    --poly for the syndromes. it is n-k in size.
    signal syndrome : galois_polynome(cons_n - cons_k - 1 downto 0);  
    
    --the error locator matrix will lead to error locator poly
    signal error_locator   : galois_polynome(cons_n - 1 downto 0);
    signal error_pos       : galois_polynome(cons_n - 1 downto 0);
    
    signal derivative_poly : galois_polynome(cons_n - 2 downto 0); --when we derive, the constant ( x^0 ) goes away.
    signal evaluator_poly  : galois_polynome(cons_n + cons_k - 1 downto 0);
    signal error_evaluator : galois_polynome(cons_n - 1 downto 0);
    signal fix_poly        : galois_polynome(cons_n - 1 downto 0);
    signal msg_fixed       : galois_polynome(cons_n - 1 downto 0);
    
    --ADVANCED GALOIS POLY
    -- we encourage that these functions should be used after the unpiped algo is simulated.
    signal pipe_input1    : galois_polynome(6 downto 0) := (6 downto 4 => msg_poly, others=>(others=>'0'));
    signal pipe_input2    : galois_polynome(4 downto 0) := generator_poly;
    signal pipe_poly_temp : galois_pipe; --galois pipe is an evil array of array of array. no other way though.
    signal pipe_result_s  : galois_polynome(6 downto 0);
    
    signal probe : galois_vector;
    signal root_index : integer := 0;
    signal index : integer := 0;
    
begin

    process
        --for berlekamp
        variable var_l    : integer := 0;
        variable var_m    : integer := 1;
        variable var_d    : galois_vector;
        variable var_b    : galois_vector := to_galois_vector(0);
        variable tmp_poly : galois_polynome(cons_n + cons_k - 1 downto 0)  := (others=>(others=>'0'));
        variable x_m_poly : galois_polynome(cons_k       downto 0) := (others=>(others=>'0'));
        variable t_poly   : galois_polynome(cons_n-1     downto 0) := (others=>(others=>'0'));
        variable b_poly   : galois_polynome(cons_n-1     downto 0) := (others=>(others=>'0'));
        variable c_poly   : galois_polynome(cons_n-1     downto 0) := (others=>(others=>'0'));
        --error locator tmp
        variable error_pos_tmp : galois_vector;
    begin
        --begin.
        msg_to_tx <= (others=>(others=>'0'));
        wait for 10 ns;
        
        --RS encoder
        msg_to_tx   <= (msg_poly * x_n_poly) + ( (msg_poly * x_n_poly) mod generator_poly );
        wait for 10 ns;
        -- yes, it is just that. Challenge: use pipeline_mod or mem_mod for better synthesis.
        ------------------------------------------------------------------------------------------------
        
        --we intentionally add an error on msg_to_tx by adding a polynome.
        msg_err <= msg_to_tx;-- + error_poly;
        wait for 10 ns;
        
        ------------------------------------------------------------------------------------------------
        --now we attpempt to fix it. The infamous RS decoder.
        
        --we calculate the syndromes by evaluating the polynome on field_generator roots.
        --roots are constant and usually are just 2^n mod field_generator. the galois library
        --have it done for you on the field_roots constant. It is on a polynome form, bein 0 the first constant up
        --to field_order.
        for j in 1 to 2**field_order-1 loop
            probe <= evaluate(generator_poly,to_galois_vector(j));
            index <= j;
            wait for 10 ns;
            if (root_index <= generator_poly_roots'high) and (evaluate(generator_poly,to_galois_vector(j)) = to_galois_vector(0)) then
				generator_poly_roots( root_index ) <= to_galois_vector( j );
				root_index <= root_index + 1;
            end if;
			wait for 10 ns;
        end loop;
        
        wait for 10 ns;
        
        --by the way, it sucks as name, because the field generator is experessed like the polynome generator. but they ARE NOT THE SAME.
        for j in syndrome'range loop
            syndrome(j) <= evaluate(msg_err,generator_poly_roots(j));
        end loop;
        wait for 10 ns;
        
        --now we create the error locator polynome. This is costy.
        --first we create a matrix of syndromes to find the coeficients A for the error locator polynome.
        --we need to symplify the matrix equation [A][x]=[B].
        --the error locator polinome is something like A(x) = An*x^n + ... + A1*x + 1
        --we have 3 options here:
        --1: Gaussian reduction -> just error locator.
        --2: Berlekamp-Massey -> just error locator.
        --3: Euclidean. this is nice and complicated and gives us BOTH error locator and error value. but it is by far the most resource consuming.
        --
        --We go with (2) adjusted for VHDL.
        berlekamp : for j in 0 to cons_k loop
              --calculate discrepancy: d = S(j)+SUM(C(l)*S(j-l)) with l = 1..var_l
              var_d := syndrome(j);
              for l in 1 to var_l loop
                var_d := var_d + c_poly(l) * syndrome(j-l);
              end loop;
               
              x_m_poly := (var_m => to_galois_vector(1), others=>to_galois_vector(0) );
              tmp_poly := x_m_poly * b_poly;
              tmp_poly := tmp_poly * (var_d * galois_inv(var_b) );
              
              if to_integer(var_d) = 0 then              
                  var_m  := var_m + 1;
              elsif 2 * var_l <= j then
                  t_poly := c_poly;   
                  c_poly := c_poly + tmp_poly(c_poly'range); --was -
                  var_l  := j + 1 - var_l;
                  b_poly := t_poly;
                  var_b  := var_d;
                  var_m  := 1;
              else
                  c_poly := c_poly + tmp_poly(c_poly'range); --was -
                  var_m  := var_m + 1;
              end if;
              
        end loop;

        error_locator <= c_poly;
        wait for 10 ns;
        
        --If one has moved to euclidean, he is just fine for fixing the error. Otherwise...        
        --now that we have the error locator polynome, we have to find its roots.
        --We could be crazy and test the whole elements from its galois field BUT we know that 
        --the log2 of the roots of the error locator polynome point to a location. In this case, the index element
        --of the received message. so, for RS(7,3) and a GF(2^M) we have to test just 2^(index+1) with index from 0 to 6.
        --this, my friends, is the Chien Search.
        for j in 0 to cons_n-1 loop
            error_pos_tmp := evaluate(error_locator,to_galois_vector(2**j));
            if error_pos_tmp = to_galois_vector(0) then
                error_pos(j) <= to_galois_vector(2**j);
            else
                error_pos(j) <= to_galois_vector(0);
            end if;
        end loop;
        wait for 10 ns;
        
        --we know WHERE is wrong. last step: calculate how much is wrong.
        --we use the Forney algorithm. BUT... We have to calculate the derivative of the error locator and the omega.
        --first, the redivative:
        for j in cons_n-2 downto 0 loop
            derivative_poly(j) <= to_galois_vector( (j+1)*to_integer(error_locator(j+1)) ); 
        end loop;
        wait for 10 ns;
        
        evaluator_poly  <= syndrome * error_locator;
        wait for 10 ns;
        
        error_evaluator <= evaluator_poly(error_evaluator'range) / derivative_poly;
        wait for 10 ns;
        --finally, we generate an vector to be added to the message so we can fix it.
        for j in error_pos'range loop
            fix_poly(j) <= evaluate( error_evaluator,error_pos(j) );
        end loop;
        wait for 10 ns;
        
        --then we add. if ecverything is ok, hopefully the message is the same.
        msg_fixed <= msg_err + fix_poly(msg_err'range);
        wait for 10 ns;
        
        wait;
    end process;

    --Basic Galois Test
    ck <= not ck after 10 ns;



    --teste de galois.
    input1   <= x"36";--x"CC after 10 ns;
    input2   <= x"12";--x"11 after 10 ns;


    --Galois Vector test
    a_s      <= to_galois_vector(input1);
    b_s      <= to_galois_vector(input2);
    mult_s   <= a_s * b_s;
    div_s    <= a_s / b_s;
    mod_s    <= a_s mod b_s;
    inv_s    <= galois_inv(b_s);

    mult_tmp_s <= galois_mult(a_s,b_s);
    reduce_s   <= galois_reduce(mult_tmp_s);
    
    --galois Poly test
    mult_poly <= a_poly    *   b_poly;
    mod_poly  <= mult_poly mod generator_poly;
    div_poly  <= mult_poly /   b_poly;
    
    --test pipelined polynome division
    process(ck)
        variable pipe_result    : galois_polynome(6 downto 0);
    begin
        if rising_edge(ck) then
        for j in 6 downto 0 loop
            pipeline_mod(pipe_input1, pipe_input2, pipe_result, pipe_poly_temp);
        end loop;
        pipe_result_s <= pipe_result;
        end if;
    end process;

end Behavioral;
