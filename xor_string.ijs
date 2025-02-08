NB. This file is a sketch of a solution to ACCU Homework Challenge 26, as set in C Vu, 36(6):10-13, January 2024
NB. The challenge is a simple one: write a program that takes a file/string as input and a random seed, and 
NB. XOR the bytes of the input with random bytes generated using the seed. The only constraint is that feeding 
NB. the output into the program again with the same seed should recover the original input.

NB. I am not very familiar with J, so this felt like a good excuse to use it.

NB. Bitwise operations are performed using (16 + k) b., where k is a truth table. Here k = 6 = 2b0110.
NB. Example:
NB.    1 0 (22 b.) table 1 0
NB. +-----+---+
NB. |22 b.|1 0|
NB. +-----+---+
NB. |1    |0 1|
NB. |0    |1 0|
NB. +-----+---+

xor =. 22 b.

NB. We need to generate a list of ASCII codes corresponding to the literals (chars) of the input string
gen_list =. 3 : '?($a. i. y) $ 255'
NB. For example:
NB.    gen_list 'O tempora, o mores!'
NB. 158 82 231 16 98 86 24 153 72 236 76 106 175 213 201 118 154 48 186

NB. Interestingly, a tacit form can be generated automatically from the direct definition:
NB.    gen_list_tct =. 13 : '?($a. i. y) $ 255'
NB.    gen_list_tct
NB. [: ? 255 $~ [: $ a. i. ]

NB. XORs the generated list with a list of ASCII codes
xor_list =. gen_list xor a. i. ]

NB. Setting the random seed requires use of foreigns.
rs =. 9!:1
NB. Note that rs n is the same as (9!:1) n NOT 9!:1 n
NB.    9!:1 100
NB. |rank error, executing conj !:
NB. |   9    !:1 100
NB. This is because arrays bind the most tightly in J, so '1 100' is an array which is passed
NB. as the RH argument to the foreign conjunction !:.

NB. Example:
NB.    rs 100
NB.    10 ? 10
NB. 4 8 5 7 6 9 3 0 1 2
NB.    10 ? 10
NB. 4 7 2 9 0 5 8 3 6 1
NB.    rs 100   NB. Resetting the seed restores the original deal values
NB.    10 ? 10
NB. 4 8 5 7 6 9 3 0 1 2

NB. Direct dyadic definition that combines seeding and xor'ing into one function:
xor_list_rs =: 4 : 'xor_list y [ rs x'

NB. Usage:
NB.   10 xor_list_rs 'Hello, ACCU!'
NB. 81 12 175 119 231 108 212 38 140 156 247 77
NB.    100 xor_list_rs 'Hello, ACCU!'
NB. 61 183 20 204 9 209 84 113 25 43 44 143
NB.    10 xor_list_rs 'Hello, ACCU!'
NB. 81 12 175 119 231 108 212 38 140 156 247 77

NB. Writing the verb out explicitly to see if it can be simplified:
xor_list_comb =: 4 : '(([: ? 255 $~ [: $ a. i. ]) (22 b.) a. i. ]) y [ (9!:1) x'

NB. You have to be careful when using foreigns with side-effects, as they may be incorrectly optimised out.
NB. In this case, using the tacit generator gives the wrong result:
NB. [: (([: ? 255 $~ [: $ a. i. ]) 22 b. a. i. ]) ]

NB. The combined function above displays a repitition of a. i. ] . How can we extract this so that we
NB. can make the program self-inverting?

NB. This is the section without the foreign conjunction:
t =. ([: ? 255 $~ [: $ a. i. ]) 22 b. a. i. ]

NB. Tree representation
NB.   5!:4 < 't'
NB.         +- [:
NB.         +- ?
NB.         |    +- 255
NB.  +------+    +- ~ --- $
NB.  |      |    |
NB.  |      +----+     +- [:
NB.  |           |     +- $
NB.  |           +-----+    +- a.
NB.--+                 +----+- i.
NB.  |                      +- ]
NB.  +- b. --- 22
NB.  |
NB.  |      +- a.
NB.  +------+- i.
NB.         +- ]

NB. This allows us to 'factorise' the end of the branches:
s =. ([: ? 255 $~ [: $ ]) 22 b. ]

NB. Usage
NB.    rs 10
NB.    s a. i. string
NB. is the same as
NB.    rs 10
NB.    t string
NB. is the same as
NB.    10 xor_list_comb string

NB. Example
NB.    string =. 'Hello, ACCU!'
NB.    rs 10
NB.    out =. s a. i. string
NB.    out
NB. 81 12 175 119 231 108 212 38 140 156 247 77
NB.    rs 10
NB.    out2 =. s out
NB.    out2
NB. 72 101 108 108 111 44 32 65 67 67 85 33
NB.    out2 { a.
NB. Hello, ACCU! NB. We have recovered the input!
