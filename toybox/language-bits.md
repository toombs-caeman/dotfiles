what is a programming language?
or So you want to design a language.
and bits and pieces I would like to see aligned

# syntax semantics mechanics tooling ecosystem
syntax, the form of the code written in a language, is distinct but not separate from
semantics, the underlying concepts of a language.
This is again distinct from the mechanics, the way concepts are represented and manipulated by the machine.

the medium is the message
syntax affects the way you can use and reason about a language,
so it's unreasonable to separate a language from its syntax

# tooling and ecosystem
## installation / updating / versioning
is there a standard way to:
* version/update the toolchain
* version/download/publish libraries
* have multiple versions of the toolchain installed (virtual env)
* version/install/uninstall compiled code
* cross-compile
is it possible to have multiple versions of the runtime and/or libraries active at the same time?
is the toolchain available on system package managers (apt, pacman, homebrew, etc.)
### mechanics
* [semantic versioning](https://semver.org/)
## build tools / runtime / repl
how easy is it to save a repl session and edit it down into real code?
can we trace which lines (from repl session) have effects and prune to those before outputing?
## editing
do you have a language server
do you have emacs/vim integrations
## testing
do you have a standard testing framework
## documentation generator
can we automatically embed documentation in your language, perhaps its understood by AST?
Is there a convention for writing comments in a way that gets extracted by tools like [doxygen](https://www.doxygen.nl/index.html)
can we easily support [literate programming](https://en.wikipedia.org/wiki/Literate_programming)
## logging
## debugger
how different is the debugger from the repl?
is it easy to debug concurrent programs
## linter / formatter
is there a language wide style or is it up to convention?

# semantics
what is the **intended use** of your language?
Is it primarily for:
* string manipulation
* array manipulation
* math
* glue-code
* high level code
* low level code
* meta-programming

## types
what are the natively supported types? Are functions first-class?
what happens when a computation has no result? do you have (Null nil NaN None)?
what values are considered false? perhaps (null 0, '')?

## scope
* local scope
* how does global scope behave? especially when threaded
* lexical(static) vs dynamic scope, closures
* do you have file-local or other scopes?

## parallelism concurrency
* what is the interface for concurrent threads?
* system threads vs language threads
* Global Interpreter Lock (GIL)

## flow control
* if, else, elif, case
* while, for, do-until, (recursive call)
* linear flow (newline)
* try, catch, finally

## memory management
* malloc/free
* garbage collection
* known variable lifetimes
### heap vs stack
## typing
* dynamic (duck)
* static
* hinting
* mixed, or static typing but default to Any
### mechanics
* [hindley-milner](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system)
## user input
how do you request input while the program is running
## gui/tui
# mechanics
* what platforms do you target
* what's the foreign function/memory [interface](https://en.wikipedia.org/wiki/Foreign_function_interface) like
* how do you interact with external programs and/or env
* what's your minimum memory usage
* hows the performance

can you transparently use hardware when its available, or scale back when it isn't?
* GPU
* cores
* extra memory
# syntax
## literal types
* strings
* numbers
* lists, dicts, sets
    `obj.{a,b,c}` returns dict {'a':obj.a, 'b':obj.b, 'c': obj.c}
    `obj.[a,b,c]` returns list ['a':obj.a, 'b':obj.b, 'c': obj.c]
* lambdas
## parsing
### statements vs expressions
### mechanics
* [overview](https://stereobooster.com/posts/an-overview-of-parsing-algorithms/)

