
use std.textio.all;
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- Could use 'vunit_lib.vunit_context', however, this is a VHDL 2008 construct
-- whereas this library should ideally support 93, 2002 and 2008. Also, to
-- reduce the likelihood of errors when VUnit is updated, we're using a subset
-- of vunit_context containing only the required packages
library expert;
    use expert.std_string.all;

------------------------
-- Entity declaration --
------------------------
entity std_string_tb is
end entity;

architecture testbench of std_string_tb is

  signal text1 : string(9 downto 1);
  signal text2 : string(9 downto 1);
  signal text3 : string(15 downto 1);
  signal text4 : string(19 downto 1);

  signal x : boolean;
  signal y : boolean;

begin

  text1 <= string_replace("teste %r","sub");
  text2 <= string_replace("%r teste","sub");
  text3 <= string_replace("teste %r teste","sub");
  text4 <= string_replace("teste \%r teste %r","sub");

  x <= string_match("teste","teste eh bom.");
  y <= string_match("teste","testar eh bom.");

end architecture;
