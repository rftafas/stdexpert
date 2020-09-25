----------------------------------------------------------------------------------
--Copyright 2020 Ricardo F Tafas Jr

--Licensed under the Apache License, Version 2.0 (the "License"); you may not
--use this file except in compliance with the License. You may obtain a copy of
--the License at

--   http://www.apache.org/licenses/LICENSE-2.0

--Unless required by applicable law or agreed to in writing, software distributed
--under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
--OR CONDITIONS OF ANY KIND, either express or implied. See the License for
--the specific language governing permissions and limitations under the License.
----------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library expert;
    use expert.std_string.all;

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
