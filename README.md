
Binary to BCD Converter
=======================

This verilog module takes a binary number as an input and outputs its corresponding BCD representation.
Currently only following configurations are supported

Input bit width | Output number of digits
----------------|------------------------
16|5
32|10

Intent for this fork
--------------------
Port gigysurk's implementation to VHDL.
Integrate jaxc's VHDL implemetation of johnloomis' scratch buffer implementation.
Implement an in-place circular buffer version.

Create test benches and reports on performance and logic size of each implementation.

Timing Diagram
--------------

TODO

Algorithm Description
---------------------

TODO
