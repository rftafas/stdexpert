# std_logic_expert

## Description
A numeric_std compatible replacement for std_logic_arith and std_logic_unsigned.

ALL STD_LOGIC_VECTORS are considered UNSIGNED. If SIGNED operation is needed, due to very specific and INTENDED behavior, it should be used the SIGNED type on NUMERIC_STD.

## Types and Typecasts

### Types

RANGE_T: record that includes "low" and "high" fields. Used to expand the ranges on VHDL.

USE:
signal|variable myrange : range_t := ( high => <integer>, low => <integer> );
  
### Type CASTs

|Function|Input Types|
|---|---|
|TO_INTEGER(input)|STD_LOGIC_VECTOR|
|TO_STD_LOGIC_VECTOR(input)|INTEGER,SIGNED,UNSIGEND|
|TO_UNSIGNED(input)|STD_LOGIC_VECTOR,SIGNED|
|TO_SIGNED(input)|UNSIGNED|

## Operators

It covers following operators:

|Operator|LEFT|RIGHT|RESULT|Description|
|---|---|---|---|---|
|+ , - , * , / |STD_LOGIC_VECTOR|STD_LOGIC_VECTOR, INTEGER, UNSIGNED|STD_LOGIC_VECTOR|Arithmetic operator|
||INTEGER|STD_LOGIC_VECTOR|STD_LOGIC_VECTOR|
||UNSIGNED|STD_LOGIC_VECTOR|STD_LOGIC_VECTOR|
|> , < , >= , <= , = , /= |STD_LOGIC_VECTOR|INTEGER|BOOLEAN|Comparator operator|
||INTEGER|STD_LOGIC_VECTOR|BOOLEAN|
|rrl , rll |STD_LOGIC_VECTOR|STD_LOGIC_VECTOR|STD_LOGIC_VECTOR|Rotation, getting the bit and placing back to begining.|

## Functions

|Function|Use|DEscription|
|---|---|---|
|size_of|size_of(number<,word>)|Return the minimum number of bits that an integer requires to be represented. If a word size is provided, the minimum number of words to represent that number.|
|index_of|index_of(vector)|Return the relative position of that register inside a larger register. (i.e. for byte, the byte number of that slice)|
|rebase|rebase(vector)|Returns an std_logic_vector starting with 0 and little endian.|
|range_of|range_of(vector)|Returns a range_t containing vector'high and vector'low|
|get_slice|get_slice(vector,<word_size>,<index>)|Returns a smaller vector (size of word_size) a portion of input vector corresponding to a word number (example: byte0 is 7..0, byte1 is 15..8)|
|set_slice|set_slice(vector,<word size>,<index>)|Retruns a vector replacing a portion of input vector corresponding to a word number (example: byte0 is 7..0, byte1 is 15..8)|
|to_range|to_range(vector)|Returns a range_t containing vector'high and vector'low|. Same of range_of (present to comply with other typecasts)
|index_of_1|index_of_1(vector)|Returns the index of highest '1' bit.|
|index_of_0|index_of_0(vector)|Returns the index of highest '0' bit.|
|all_1|all_1(input)|Returns an "all ones" vector sized input-1 downto 0|
|all_0|all_0(input)|Returns an "all zeroes" vector sized input-1 downto 0|
