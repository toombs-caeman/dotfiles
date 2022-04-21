human read and writable data formats for key-value and tabular data

# goals?
straightforward to read and write by hand
straightforward to parse

# define formats
empty lines and comments (starting with '#') are ignored

* NOS(nosql) is a key-value format
  * subset of TOML?
* TAB(table) is a tabular data format
    * TAB is a fixed-width format.
    * the first row is a header. Header names must follow the bash variable naming convention.
    * The spacing of the header determines column width.
    * only the last column is not-fixed width


the parsers here are intended to parse TAB and NOS format files into the current shell ENV
or format the current ENV for TAB or NOS formats.
This is for ease of programmatic access, but the formats are intended to be human read- and write-able.

# reference:
* [TOML](https://github.com/toml-lang/toml)
* [Indental](https://wiki.xxiivv.com/site/indental.html)
* [Tablatal](https://wiki.xxiivv.com/site/tablatal.html)
* [sed](https://www.grymoire.com/Unix/Sed.html)

