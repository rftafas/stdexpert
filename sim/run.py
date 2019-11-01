from os.path import join, dirname
import sys
from vunit import VUnit

root = dirname(__file__)

vu = VUnit.from_argv()

lib = vu.add_library("repo")
lib.add_source_files(join(root, "../src/*.vhd"))
lib.add_source_files(join(root, "./*.vhd"))
test_tb = lib.entity("std_logic_expert_tb")
test_tb.scan_tests_from_file(join(root, "std_logic_expert_tb.vhd"))

vu.main()
