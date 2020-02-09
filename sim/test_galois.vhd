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
  use expert.std_logic_expert.all;
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
    signal div_tmp_s  : std_logic_vector(15 downto 0);
    signal mod_s      : galois_vector;
    signal inv_s      : galois_vector;
    signal one_s      : galois_vector;
    --for partial multiplication functions
    signal mult_tmp_s : std_logic_vector(14 downto 0) := (others=>'0');
    signal reduce_s   : galois_vector;
    signal div_j      : integer := 0;


    type vec_temp is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);
    constant poly_tmp : vec_temp(4 downto 0) := (x"01", x"0f", x"36", x"78", x"40" );
    constant  msg_tmp : vec_temp(2 downto 0) := (x"12", x"34", x"56" );


    --POLYNOMIAL OPS TEST
    constant in_a_poly  : galois_polynome(2 downto 0) := (
        to_galois_vector(msg_tmp(2)),
        to_galois_vector(msg_tmp(1)),
        to_galois_vector(msg_tmp(0))
    );

    constant in_b_poly : galois_polynome(4 downto 0) := (
        4      => to_galois_vector(1),
        others => to_galois_vector(0)
    );

    constant in_a_inv_poly  : galois_polynome(2 downto 0) := (
        galois_inv(in_a_poly(2)),
        galois_inv(in_a_poly(1)),
        galois_inv(in_a_poly(0))
    );

    constant generator_poly : galois_polynome(4 downto 0) := (
        to_galois_vector(poly_tmp(4)),
        to_galois_vector(poly_tmp(3)),
        to_galois_vector(poly_tmp(2)),
        to_galois_vector(poly_tmp(1)),
        to_galois_vector(poly_tmp(0))
    );

    signal div_poly  : galois_polynome(6 downto 0);
    signal mult_poly : galois_polynome(6 downto 0);
    signal mod_poly  : galois_polynome(6 downto 0);

    --RS(7,3). We have some constants:
    constant cons_n : integer := 7;
    constant cons_k : integer := 3;
    constant cons_2t : integer := 4; --2t=n-k
    constant cons_t : integer  := 2;

    --constants derived from the code to be used.
    constant x_2t_poly : galois_polynome(cons_2t downto 0) := (
        cons_2t => to_galois_vector(1),
        others => to_galois_vector(0)
    );
    constant x_t_poly  : galois_polynome(cons_t downto 0) := (
        cons_t => to_galois_vector(1),
        others => (others=>'0')
    );


    constant msg_poly : galois_polynome(cons_k - 1 downto 0) := (
        to_galois_vector(msg_tmp(2)),
        to_galois_vector(msg_tmp(1)),
        to_galois_vector(msg_tmp(0))
    );



    signal msg_to_tx  : galois_polynome(cons_n-1 downto 0) := (others=>(others=>'0'));
    signal error_poly : galois_polynome(cons_n-1 downto 0) := (
        cons_n-1 => to_galois_vector(1),
        0        => to_galois_vector(1),
        others   => (others=>'0')
    );
    signal msg_err     : galois_polynome(cons_n-1 downto 0) := (others=>(others=>'0'));


    --poly for the syndromes. it is n-k in size.
    --signal syndrome : galois_polynome(cons_n - cons_k - 1 downto 0);
    signal syndrome : galois_polynome(cons_2t-1 downto 0) := (others=>(others=>'0'));

    --berlekamp
    signal var_l    : integer := 0;
    signal var_d    : galois_vector := to_galois_vector(0);
    signal x_1_poly : galois_polynome(cons_2t     downto 0) := (1 => to_galois_vector(1), others=>(others=>'0'));
    signal t_poly   : galois_polynome(cons_2t     downto 0) := (others=>(others=>'0'));
    signal b_poly   : galois_polynome(cons_2t     downto 0) := (0 => to_galois_vector(1), others=>(others=>'0'));
    signal c_poly   : galois_polynome(cons_2t     downto 0) := (1 => to_galois_vector(1), others=>(others=>'0'));

    --the error locator matrix will lead to error locator poly
    signal   lambda_poly     : galois_polynome(cons_2t       downto 0) := (others=>(others=>'0'));
    signal   error_location  : std_logic_vector(cons_n-1     downto 0) := (others=>'0');
    signal   lambda_dx_poly  : galois_polynome(cons_2t       downto 0) := (others=>(others=>'0')); --when we derive, the constant ( x^0 ) goes away.
    signal   omega_poly      : galois_polynome(2*cons_2t - 1 downto 0) := (others=>(others=>'0'));
    signal   evaluator_poly  : galois_polynome(2*cons_2t - 1 downto 0) := (others=>(others=>'0'));
    signal   fix_poly        : galois_polynome(cons_n - 1    downto 0) := (others=>(others=>'0'));
    signal   msg_fixed       : galois_polynome(cons_n - 1    downto 0) := (others=>(others=>'0'));

    --ADVANCED GALOIS POLY
    -- we encourage that these functions should be used after the unpiped algo is simulated.
    signal pipe_input1    : galois_polynome(6 downto 0) := (6 downto 4 => msg_poly, others=>(others=>'0'));
    signal pipe_input2    : galois_polynome(4 downto 0) := generator_poly;
    signal pipe_poly_temp : galois_pipe; --galois pipe is an evil array of array of array. no other way though.
    signal pipe_result_s  : galois_polynome(6 downto 0);


    signal error_pos_tmp   : galois_vector := to_galois_vector(0);
    signal index_j         : integer := 0;

begin

    process
    begin
        --begin.
        msg_to_tx <= (others=>(others=>'0'));
        wait for 10 ns;

        --RS encoder
        msg_to_tx   <= (msg_poly * x_2t_poly) + ( (msg_poly * x_2t_poly) mod generator_poly );
        wait for 10 ns;
        -- yes, it is just that. Challenge: use pipeline_mod or mem_mod for better synthesis.
        ------------------------------------------------------------------------------------------------

        --we intentionally add an error on msg_to_tx by adding a polynome.
        msg_err <= msg_to_tx + error_poly;
        wait for 10 ns;

        ------------------------------------------------------------------------------------------------
        --now we attpempt to fix it. The infamous RS decoder.

        --we calculate the syndromes by evaluating the polynome on field_generator roots.
        --roots are constant and usually are just 2^n mod field_generator. the galois library
        --have it done for you on the field_roots constant. It is on a polynome form, bein 0 the first constant up
        --to field_order.
        --by the way, it sucks as name, because the field generator is experessed like the polynome generator. but they ARE NOT THE SAME.
        for j in syndrome'range loop
            syndrome(j) <= evaluate(msg_err,field_roots(j));
        end loop;
        wait for 10 ns;


        --now we create the error locator polynome. This is costy.
        --first we create a matrix of syndromes to find the coeficients A for the error locator polynome.
        --we need to symplify the matrix equation [A][x]=[B].
        --the error locator polinome is something like A(x) = An*x^n + ... + A1*x + 1
        --we have 3 options here:
        --1: Gaussian reduction -> just error locator.
        --2: Berlekamp-Massey   -> just error locator.
        --3: Euclidean. this is nice and complicated and gives us BOTH error locator and error value. but it is by far the most resource consuming.
        --
        --We go with (2) adjusted for VHDL.
        berlekamp : for j in 1 to cons_2t loop

              -- calculate discrepancy: d = S(j)+SUM(C(l)*S(j-l)) with l = 1..var_l
              -- and again changing because computers are stuck to indexes.
              -- the "sum" part of BM does not apply to j=1 (they call N on original paper)
              -- so, for j = 1, var_d = S0.
              var_d <= syndrome(j-1);
              wait for 10 ns;
              if var_l /= 0 then
                for i in 1 to var_l loop
                    var_d <= var_d + b_poly(i) * syndrome(j-i-1);
                    wait for 10 ns;
                end loop;
              end if;

              b_poly <= b_poly + (c_poly * var_d);
              if to_integer(var_d) /= 0 and j > 2 * var_l then
                  c_poly <= (b_poly(cons_2t-1 downto 0) / var_d) * x_1_poly(1 downto 0);
                  var_l  <= j - var_l;
              else
                  c_poly <= c_poly(cons_2t-1 downto 0) * x_1_poly(1 downto 0); --or we can rotate left with discard
              end if;
              wait for 10 ns;

        end loop;

        -- berlekamp gives us something like A2x^2 + A1x^1 + 1
        -- we have two paths: keep this way. or adjust it. Difference is adjusting will
        -- take more hardware. this means more combinational logic.
        lambda_poly <= b_poly;
        wait for 10 ns;

        -- we have ways to know WHERE is wrong. last step: calculate how much is wrong.
        -- we are goint to use Forney algorithm. BUT... We have to calculate the derivative of the error
        -- locator and the omega.
        -- first, the derivative: we multiply by regular integer (i.e, several sums). this is tricky.
        -- as Galois sums are XOR, the even powers of x will desapear. the ods remain as they are.
        -- after deleting even power, right shift.
        -- (remember: d(x^2)/dx = 2*x, or a right shift)
        -- OR use the multiplication by integer (on galois lib) when shifting.
        for j in lambda_dx_poly'high-1 downto 0 loop
            lambda_dx_poly(j) <= (j+1)*lambda_poly(j+1);
        end loop;
        wait for 10 ns;

        --also for Forney get omega.
        omega_poly  <= ( syndrome * lambda_poly ) mod x_2t_poly;
        wait for 10 ns;
        
        --then we create the 
        evaluator_poly <= omega_poly / lambda_dx_poly;
        wait for 10 ns;

        -- we get all polys we need. Error Locator and Error Evaluator.
        -- now that we have the error locator polynome, we have to find its roots.
        -- There is chien search. But we know if we are to fix error, it must be on valid locations.
        -- So we test the poly at roots that indicate location only. This happens to be alfa**n
        -- for us, then, 2**(-n).
        -- galois lib has all inverted roots as constant, so this should not be hardare costy.
        for j in 0 to cons_n-1 loop
            error_pos_tmp <= evaluate(lambda_poly,field_inv_roots(j));
            wait for 10 ns;
            if error_pos_tmp = to_galois_vector(0) then
                error_location(j) <= '1';
            end if;
            wait for 10 ns;
        end loop;

        wait for 10 ns;

        --finally, we generate an vector to be added to the message so we can fix it.
        for j in error_location'range loop
            if error_location(j) = '1' then
                fix_poly(j) <= field_roots(j) * evaluate( omega_poly,field_inv_roots(j) ) / evaluate( lambda_dx_poly,field_inv_roots(j) );
            else
                -- we do not fix error where there is none. period.
                -- doing so will mess the whole message. evaluator_poly
                -- does not necessarly evaluate to 0 on roots with no error.
                fix_poly(j) <= to_galois_vector(0);
            end if;
        end loop;
        wait for 10 ns;

        --then we add. if everything is ok, hopefully the message is the same.
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

    process
        variable tmp : galois_vector;
    begin
        for j in 1 to 2**field_order-2 loop
            tmp   := to_galois_vector(j);
            div_j <= j;
            inv_s <= galois_inv(tmp);
            one_s <= galois_inv(tmp) * tmp;
            wait for 10 ns;
        end loop;
        wait;
    end process;

    mult_tmp_s <= galois_mult(a_s,b_s);
    reduce_s   <= galois_reduce(div_tmp_s);

    --galois Poly test
    mult_poly <= in_a_poly *   in_b_poly;
    mod_poly  <= mult_poly mod generator_poly;
    div_poly  <= mult_poly /   in_b_poly,
                 mult_poly /   in_a_poly     after 10 ns,
                 mult_poly /   mult_poly     after 20 ns,
                 mult_poly /   in_a_inv_poly after 30 ns;


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
