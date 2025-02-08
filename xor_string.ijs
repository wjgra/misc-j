xor =. 22 b.

gen_list =. 3 : '?($a. i. y) $ 255'
NB. Using tacit generator
NB. gen_list2 =. 13: 'gen_list'
gen_list2 =. [: ? 255 $~ [: $ a. i. ]

xor_list =. gen_list xor a. i. ]

fr =. 9!:1

xor_list_fr =: 4 : 'xor_list y [ fr x'

NB. Usage:
NB.   10 xor_list_fr 'Hello, ACCU!'
NB. 81 12 175 119 231 108 212 38 140 156 247 77
NB.    100 xor_list_fr 'Hello, ACCU!'
NB. 61 183 20 204 9 209 84 113 25 43 44 143
NB.    10 xor_list_fr 'Hello, ACCU!'
NB. 81 12 175 119 231 108 212 38 140 156 247 77

xor_list_comb =: 4 : '(([: ? 255 $~ [: $ a. i. ]) (22 b.) a. i. ]) y [ (9!:1) x'

NB. Using the tacit generator gives the wrong result
NB. [: (([: ? 255 $~ [: $ a. i. ]) 22 b. a. i. ]) ]
NB. The issue is that it optimises out the foreign!

NB. To do: extract a. i. so that we can make the function self-inverting

NB. This is the section without the foreign
t =. ((([: ? 255 $~ [: $ a. i. ]) (22 b.) a. i. ]))

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

NB. 'Factorise' the end of the branches:
s =. ((([: ? 255 $~ [: $ ]) (22 b.) ]))

NB. Usage
NB.    fr 10
NB.    s a. i. string
NB. is the same as
NB.    fr 10
NB.    t string
NB. is the same as
NB.    xor_list_comb string

NB. Rather than working out how to make something tacit, just use dummy verbs:
NB.    13 : 'f y ] g x' NB. This is wrong...
NB. [: f ] ] [: g [

s_fr =. [: s ] ] [: fr [