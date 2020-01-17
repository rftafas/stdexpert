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

    signal input1    : std_logic_vector(7 downto 0);
    signal input2    : std_logic_vector(7 downto 0);

    signal ck : std_logic := '0';
    
    signal a_s      : galois_vector;
    signal b_s      : galois_vector;
    signal mult_s   : galois_vector;
    signal div_s    : galois_vector;
    signal mod_s    : galois_vector;
    signal inv_s    : galois_vector;
    signal reduce_s : galois_vector;


    type vec_temp is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);
    constant poly_tmp : vec_temp(4 downto 0) := (x"01", x"0f", x"36", x"78", x"40" );
    constant  msg_tmp : vec_temp(6 downto 0) := (x"12", x"34", x"56", others=>x"00" );
    constant msg_tmp2 : vec_temp(6 downto 0) := (x"12", x"34", x"56", x"37", x"e6", x"78", x"d9");

    constant generator_poly : galois_polynome(4 downto 0) := (
        to_galois_vector(poly_tmp(4)),
        to_galois_vector(poly_tmp(3)),
        to_galois_vector(poly_tmp(2)),
        to_galois_vector(poly_tmp(1)),
        to_galois_vector(poly_tmp(0))
    );

    constant msg_poly : galois_polynome(6 downto 0) := (
        to_galois_vector(msg_tmp(6)),
        to_galois_vector(msg_tmp(5)),
        to_galois_vector(msg_tmp(4)),
        to_galois_vector(msg_tmp(3)),
        to_galois_vector(msg_tmp(2)),
        to_galois_vector(msg_tmp(1)),
        to_galois_vector(msg_tmp(0))
    );
    
    signal poly_mod_tmp : galois_polynome(6 downto 0);

    signal mod_result : galois_polynome(6 downto 0) := (others=>(others=>'0'));
    signal msg_to_tx  : galois_polynome(6 downto 0) := (others=>(others=>'0'));
    
    signal mult_tmp   : std_logic_vector(14 downto 0) := (others=>'0');
    signal reduce_tmp : std_logic_vector(14 downto 0) := (others=>'0');
    signal galois_inv_tmp : galois_vector := (others=>'0');
    signal term1 : galois_vector := (others=>'0');
    signal term2 : galois_vector := (others=>'0');
    
    signal b_tmp : unsigned(b_value'range) := b_value;
    
    
    constant roots_cte : galois_polynome(3 downto 0) := (
        to_galois_vector(2)**3,
        to_galois_vector(2)**2,
        to_galois_vector(2)**1,
        to_galois_vector(2)**0
    );
    
    --this is the example message
    constant constant_message: galois_polynome(6 downto 0) := (
        to_galois_vector(msg_tmp2(6)),
        to_galois_vector(msg_tmp2(5)),
        to_galois_vector(msg_tmp2(4)),
        to_galois_vector(msg_tmp2(3)),
        to_galois_vector(msg_tmp2(2)),
        to_galois_vector(msg_tmp2(1)),
        to_galois_vector(msg_tmp2(0))
    );
    
    --this is an example for syndrome calculation.
    constant syndromes : galois_polynome(3 downto 0) := (
        evaluate(constant_message * roots_cte(3)),
        evaluate(constant_message * roots_cte(2)),
        evaluate(constant_message * roots_cte(1)),
        evaluate(constant_message * roots_cte(0))
    );
    
    --test pipeline mod
    signal pipe_input1    : galois_polynome(6 downto 0) := msg_poly;
    signal pipe_input2    : galois_polynome(4 downto 0) := generator_poly;
    
    signal pipe_poly_temp : galois_pipe;
    signal pipe_result_s    : galois_polynome(6 downto 0);
    
begin

    process
    begin
        input1   <= x"36";
        input2   <= x"12";
        mult_tmp <= (others=>'0');
        wait for 1 ns;
        
        for j in input1'range loop
          for k in input2'range loop
              mult_tmp(j+k) <= mult_tmp(j+k) xor ( input1(j) and input2(k) );
              wait for 1 ns;
          end loop;
        end loop;

        wait for 1 ns;
        reduce_tmp <= mult_tmp;
        
        wait for 1 ns;
        for j in reduce_tmp'high downto field_order loop
            if reduce_tmp(j) = '1' then
                for k in 0 to field_order loop
                    --order 8 poly fits on 9 bits, 8 downto 0.
                    --we go until tmp bits 8 downto 0 get xored by gen poly.
                    reduce_tmp(j-k) <= reduce_tmp(j-k) xor polynome_vector(field_order-k);
                                                            
                    wait for 1 ns;
                end loop;
            end if;
        end loop;
        wait for 1 ns;
        
        galois_inv_tmp <= a_s;
        b_tmp <= b_value;
        wait for 1 ns;
        
		for j in b_tmp'range loop
			if b_tmp > 1 then
				if b_tmp(0) = '1' then
					b_tmp <= b_tmp - 1;
					galois_inv_tmp <= galois_inv_tmp * a_s;
				else
					b_tmp <= '0' & b_tmp(b_tmp'high-1 downto 0);
					galois_inv_tmp <= galois_inv_tmp * galois_inv_tmp;
				end if;
			end if;
			wait for 1 ns;
		end loop;
		wait for 1 ns;
		
		poly_mod_tmp <= msg_poly;
		wait for 1 ns;
		
		for j in 6 downto 4 loop --length = high+1
			if poly_mod_tmp(j) > to_galois_vector(0) then
				for k in 1 to 4 loop
					poly_mod_tmp(j-k) <= poly_mod_tmp(j-k) - (poly_mod_tmp(j) * generator_poly(4-k));
					wait for 1 ns;
				end loop;
				poly_mod_tmp(j) <= (others=>'0');
			end if;
			wait for 1 ns;
		end loop;

        wait;
    end process;

    ck <= not ck after 10 ns;

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

    a_s      <= to_galois_vector(input1);
    b_s      <= to_galois_vector(input2);
    mult_s   <= a_s * b_s;
    div_s    <= a_s / b_s;
    mod_s    <= a_s mod b_s;
    inv_s    <= galois_inv(b_s);
    reduce_s <= galois_reduce(mult_tmp);

    mod_result <= msg_poly mod generator_poly;
    msg_to_tx  <= msg_poly(6 downto 4) & mod_result(3 downto 0); 

end Behavioral;
