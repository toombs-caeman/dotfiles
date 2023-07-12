# name options
* [ayeaye](https://subnautica.fandom.com/wiki/Eyeye)
* [minima](https://github.com/TheRealMichaelWang/minima)
# minimal viable interpreter
* parsing source to ast
* inline ffi for implementing 'builtins'
* 'main()' to evaluate ast
* name resolution
    * scoping, garbage collection, var lifetimes
* backing store/serialization? for communicating between foreign functions?
* binary data format? 'native' types

* name define grammar version by hash of parsing expressings
    * 'use <grammar>' directive for loading grammar by hash

* inline snapshot testing
* can name everything, don't have to name anything
    * DeBrujin naming 


# optimization modes
0. run as a repl with no attempt at using restrictive primitives
1. compile, but do not use restrictive primitives
2. compile, derive restrictive primitives
3. compile, fail on ambiguous primitives

# type heirarchy
low-level types
* num - generic number
    * int
        * {i,u}{16,32,64}
        * {i,u}size
    * float
        * f{16,32,64}
* string - pythonic immutable strings
    * arr[char]
* iterable - generic iterable
    * array - immutable, uniform type
    * vector - 
* collection
    * set
    * dict
        * namespace
    * tuple - immutable, 
* ref - rustic pointer
    * raw pointer
* producer
    * function
        * FFI
    * coroutine
        * remote call
join python sql and apl in an unholy union
allow dense array syntax but encourage pythonic style
allow persistence and strong consistency guarantees by embedding a sqlite database

# tooling
* packages must be published as source under git, use semver git tags to publish version so there's no separate
  packaging mechanism. The package name is the host url (sans http://)
* toolchain/compiler/interpreter/linter/etc should be a single binary file
* static binaries.
* how to resolve incompatible libraries? do we allow multiple versions of the same libraries.
  how can we have 'virtual env' to capture the dependencies of just the current project in a separate tree.
* stdlib should be a flat namespace, statically linked in compiler and copied when used to any output.
* cross-compilation possible.
* a 'binary' is a frozen and trimmed program state (trim to reachable code from entry point and exec)
  or have multiple entrypoints bundled like busybox
* shebang convention to automatically run source file as an interpreter (as bash does).

# orthogonal syntax
unify parts of programming languages that are typically similar but different syntax.

for..in, foreach, and map are closely related keywords across many different languages.
All use cases of these are served by the singular loop, aka '@'.
Loop also handles the need for while, do..while, reduce and filter.

Similarly, '?' handles the need for if, else, and case keywords

only use one quote style for strings

prefer expressions (and blocks) over statements

rather than special syntax for generics and macros let the full language be available at compile time

# borrowing features
'borrow' successful features and workflows from other languages.
golang
* channels - typed thread-safe fifo as only communication between threads
* fmt - standard toolchain includes linter/formatter
* get (library name indicates fetch url)
* static binaries for easy containerization.
rust
* borrow (reference) and scoping semantics to get around gc
apl
* function semantics
sql
* the same code can lead to different 'plans' at runtime based on meta-data about the execution context or data size
zig
* [comptime](https://kristoff.it/blog/what-is-zig-comptime/)
bash et al.
* allow source files to run in 'interpreter mode', or have a repl
python
* allow deep destructured assignment
* whitespace significant
* slice syntax
elixir
* assignment is actually pattern matching

# novel ideas?
* embed sqlite in the language
* afford efficient 'array of structs'<->'struct of arrays' memory packing.
* if pair expects an expression but gets a newline, whitespace become significant like python.
  the resulting block has type block.
blocks are implicitly a function of zero arguments, but also evaluate when cast to another type.
unless the receiving function calls for a block.
* language primitives exposing heap/stack differences, or other low level concepts should not be 'default'. The default numeric type should be bignum, but let `u32` be specified. default sequence type should be a vector (variable size/type), but allow array (const size, uniform type) be specified.
* separate language into high and low level primitives, high level primitives are expressible multiple ways using low level primitives, chosen by static analysis and optimization level (for example [] would mean 'any sequence' unless given an explicit annotation, depending on usage it could compile to array or a vector).
* high level types are collections of traits, any low level structure which implements those traits may be used at compile time

# semantics
values and expressions
* a value is a scalar (number string or a collection of values)
* an expression is not a value, but may produce a value (zero or one)
* names may be assigned to expressions or values
* there are three types of expressions which are not values: blocks, functions, operators
    * blocks take zero arguments
    * functions and blocks
* use python's taxonomy of [collections](https://docs.python.org/3/library/collections.abc.html#collections-abstract-base-classes)

# meta-syntax v0.0
define foreign function interface (ffi).
use unicode literal functions for meta-programming.
perhaps meta-language mechanics uses unicode characters,
while the more common language elements can use ascii symbols
methods for modifying the parsing grammar
use precedence climbing

before cementing syntax with any backward compatible processes, generate permutations of 'valid syntax'
and make sure they have clear semantics. All parsable expressions should have clear semantic meaning
(whether or not it is a useful construct, or valid code in this instance.

# core syntax v0.1
literal types
* numbers and infinity
* string ''
* regex ` `
* fstring ""
* pair :
* signature/ast pattern <>
* set {}
* list []
* block ()
* iterator *
* pair iterator `**`
* range iterator ..

names (variables)
* name `[a-zA-Z][a-zA-Z_]*`
* assign =

literal functions
* math operators +(add) -(sub) `*`(mul) /(div) //(idiv) !/(mod) ^(exp) /^(log)
* unary math    +(abs) -(inv) !^(???)
* bool operators !(not) /+(or) `/*`(and) /-(xor) !+(nor) `!*`(nand) !-(xnor)
* comparators /=(eq) /<(lt) />(gt) !=(ne) !<(nl) !>(ng)
* object operator .(access) !.(safe access) `_`(typeof) `/_`(isinstance) `!_`(issubclass)
* loop @
* branch ?
* try % /% !%
* thread |
* comptime $

* join <> << >> ><
* reference &
    * pass by name instead of by value

compound literal types
* function <>:()
* object {:}

other functions
* load - import file

other builtin types
* iter - an iterator
* mat - a numeric matrix type
* type

traits, aka generics, aka interfaces
* ffi - foreign function interface
* itr - iterator
* cmp - comparable, well ordered?
* fun - callable. blk, uop or bop

# tables v0.2
expose sqlite as a language feature for persistence and querying
operations like loop, join and filter should have the same syntax
for sqlite based or in-memory types
zip / join
other builtin types
* tab - a sqlite table
* ⨝`u2a1d` new `ji` (join)
* ⟕`u27d5` new `j]` (left join)
* ⟖`u27d6` new `j[` (right join)
* ⟗`u27d7` new `jo` (outer join)

can this handle sqlite and pandas use case?

# I/O and concurrency v0.3
I/O should have chan semantics.
allow coprocesses which communicate exclusively through channels
sys module for calling external programs
what about audio/visual i/o as primitives in addition to files.

literal functions
* proc |

other types
* chan - a typed thread-safe queue that produces a value or blocks

# aliases v0.4
bidirectional updates between variables. reversible functions
literal function
* alias <->

# fstrings, regex, requests v0.5
implement fstrings as a syntax
[fstring](https://news.ycombinator.com/item?id=31457188)
add regex and http request libraries

# ecosystem v0.6
datetime
what's the mvp for an xorg/wayland-like graphics env

## ops
* casting - cast should be a complete function between all builtin types
* comparisons =≥≠≤><
* bitwise &(b-and) ¦(BB)(bit or)
* math * (mul) /(div) %(mod) -(inv/sub) +(add) ±(abs) 
* logical !(not) ∨(OR)(or) ∧(AN)(and) ×(\/)(xor) ¬(-,)(not)

## flow control
* line - simple expressions are evaluated in linear order
* func - λ and Λ cause a jump in memory
* chan - a chan read may block while waiting for a value
* proc - a thread may run in parallel
* case - a branch chooses one of several sections to run
* loop - a loop repeats a section
* try  - a handle exceptions and errors
* load - import a library, aka jump to a file
* ‖(||) a language thread (concurrent/parallel execution)
    * ¥(Ye) ⑂(2h) join/wait
    * read/write channel
* ⟂(u27C2) ⊥(T-) branch execution ≡(=3) Ϡ(P3) ?
    * default pair
* @(loop)∘(Ob) ↻(new Q>)
    * « (<<)continue
    * » (>>)break
* try catch... finally
* import
* loop
    * the only difference is that a map can happen in any order becaue it doesn't (shouldn't) have side effects
      while a for loop can make arbitrary changes to external values.
    * filter is the same, as long as we have the sentinel nil which cannot be in the output (repeat after me, nil is not a value).
    * where map is a function x -> y, reduce is a function x,y -> z
      we have separate function types for 1-adic and 2-adic functions
      so this is fine.
## iter
* ∘`Ob`/r map (with λ) or reduce (with Λ)
* ↕`UD`/R sort/rearrange
* ↔`<>`/f filter
* ‥`..`.. count/range/slice
* ∷`::`:: groupby
* ∝`0(`/@ cycle repeat sequence
* ∇`NB`/z zip
* ∆`DE`/Z zip longest
* ∃`TE`/E any
* ∀`FA`/A all
higher order functions
* map/reduce/filter
* groupby
* partial



## set
* ∋`-)` /k has key
* ⊇`_)` /s is subset
* ⊃`C)` /S is strict subset

can we do auto AOS↔SOA conversion
# tooling
## keyboard
take notes from the [bqn keyboard](https://mlochbaum.github.io/BQN/tutorial/expression.html#arithmetic)
# ref
* [python builtins](https://docs.python.org/3/library/functions.html)
* [python itertools](https://docs.python.org/3/library/itertools.html)
* [bqn](https://mlochbaum.github.io/BQN/tutorial/expression.html)
* [elixir](https://learnxinyminutes.com/docs/elixir/)
