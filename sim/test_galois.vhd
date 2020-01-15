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
  package std_logic_galois_8 is new expert.std_logic_galois
      generic map (
          field_order     => 8,
          polynome_vector => "100011011"--( 8=>'1', 4=>'1', 3=>'1', 1=>'1', 0=>'1', others=>'0' ) --"100011011"
      );
  use work.std_logic_galois_8.all;
  --use expert.std_logic_galois.all;
library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;
library stdblocks;
  use stdblocks.sync_lib.all;
  use stdblocks.ram_lib.all;
  use stdblocks.fifo_lib.all;

entity test_galois is
  Port (
   ck  : in  std_logic;
   a   : in  std_logic_vector(7 downto 0);
   b   : in  std_logic_vector(7 downto 0);
   result : out std_logic_vector(7 downto 0)
   );
end test_galois;

architecture Behavioral of test_galois is

    signal a_s  : galois_vector;
    signal b_s  : galois_vector;
    signal test : galois_vector;

    type vec_temp is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);
    constant poly_tmp : vec_temp(4 downto 0) := (x"01", x"0f", x"46", x"78", x"40" );
    constant  msg_tmp : vec_temp(6 downto 0) := (x"12", x"34", x"56", others=>x"00" );

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

    signal mod_result : galois_polynome(6 downto 0) := (others=>(others=>'0'));


begin

    mod_result <= msg_poly mod generator_poly;

    process(all)
    begin
        if rising_edge(ck) then
            a_s <= to_galois_vector(a);
            b_s <= to_galois_vector(b);
            --test <= a_s * b_s;
            --test <= a_s + b_s;
            test <= a_s / b_s;
        end if;
    end process;

    result <= to_std_logic_vector(test);

end Behavioral;
