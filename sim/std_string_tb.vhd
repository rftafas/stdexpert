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
library vunit_lib;
	context vunit_lib.vunit_context;

entity std_string_tb is
  generic (runner_cfg : string);
end entity;

architecture testbench of std_string_tb is
begin

  main : process
    variable stat         : checker_stat_t;
    variable fail_checker : checker_t;
    variable text_v : string(256 downto 1) := (others=>nul);
    variable text_size : positive := 1;

  begin
    test_runner_setup(runner, runner_cfg);
    set_stop_level(failure);

    while test_suite loop
      if run("Sanity check for system.") then
        report "System Sane. Begin tests.";
        check_true(true, result("Sanity check for system."));

      elsif run("string_length(string,keyword)") then
        check_equal(string_length(text_v),256,result("string_length(string)"));

      elsif run("replace at start") then
        text_size := string_length("sub test: replace first");
        text_v(text_size downto 1) := string_replace("%r replace first","sub test:");
        check_equal(text_v(text_size downto 1),"sub test: replace first", result("string_replace(original_string,replace term)"));

      elsif run("replace in the end") then
        text_size := string_length("sub test: replace last");
        text_v(text_size downto 1) := string_replace("sub test: replace %r","last");
        info(text_v(text_size downto 1));
        check_equal(text_v(text_size downto 1),"sub test: replace last", result("string_replace(original_string,replace term)"));

      elsif run("replace in middle") then
        text_size := string_length("sub test: replace");
        text_v(text_size downto 1) := string_replace("sub %r replace","test:");
        check_equal(text_v(text_size downto 1),"sub test: replace", result("string_replace(original_string,replace term)"));

      elsif run("avoid mistaken replace") then
        text_size := string_length("sub test: keep first \%r on string");
        info(to_string(text_size));
        text_v(text_size downto 1) := string_replace("sub test: keep first \%r %r string","on");
        info(text_v(text_size downto 1));
        check_equal(text_v(text_size downto 1),"sub test: keep first \%r on string", result("string_replace(original_string,replace term)"));

      elsif run("string_match(source,keyword)") then
        check_true(string_match("pass","This test must pass"), result("string_replace(original_string,replace term)"));
        check_false(string_match("pass","This test must fail"), result("string_replace(original_string,replace term)"));
      end if;

    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

end architecture;
