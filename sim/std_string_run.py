from os.path import join, dirname
import sys

try:
    from vunit import VUnit
except:
    print("Please, intall vunit_hdl with 'pip install vunit_hdl'")
    print("Also, make sure to have either GHDL or Modelsim installed.")
    exit()

root = dirname(__file__)

vu = VUnit.from_argv()

lib = vu.add_library("expert")
lib.add_source_files(join(root, "../src/std_string.vhd"))
lib.add_source_files(join(root, "./std_string_tb.vhd"))
test_tb = lib.entity("std_string_tb")
test_tb.scan_tests_from_file(join(root, "std_string_tb.vhd"))

vu.main()
