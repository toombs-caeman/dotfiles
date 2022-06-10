embedding micro-languages within full  programming languages.
clusters of functionality that get libraries and/or special syntax

first, consider a language like lisp, with minimal syntax. All functionality in the language must be added by defining
functions, but other languages offer access to functions through special syntax.

# common embeddings
* basic math
* boolean logic
* json
* regex
* cron spec
* sql
* documentation / comments

# unusual embeddings
might have utility
* apl-like function lifting and array manipulation (filter/map/reduce)
* unpacking/argument manipulation

# weird combo
unify sql and apl ways of thinking


# special strings syntax
* %     - 'the value of var is %s' % var; %'%s'(var)
* format- f'the value of var is {var}' or 'the value of var is {}'.format(var)
* regex - r'^(.\*)$'.match(var) or regex('^(.\*)$').match(var)
    * how to represent sed-like expressions? - s's/\(.\*\)/(\1)/'
* apl
    * a'+/'(...) or sum(...)
    * a'i'(...) or range(...)
    * sum(range(...)) - a'+/⍳'(...)
    - use ascii letters instead of strange unicode and greek letters
    - core - compact array manipulation
* sqlite- q'select {col_name} from asf where ...'
    - core - describing what you want (from tabular data), and not how to get it. which lets the query planner work.

`obj.{a,b,c}` returns dict {'a':obj.a, 'b':obj.b, 'c': obj.c}
`obj.[a,b,c]` returns list ['a':obj.a, 'b':obj.b, 'c': obj.c]

    
## format specifiers
* include capabilities of all the usual c::printf() stuff (%s specifiers)
* also include 'escape' capability which behaves differently depending on string type
    * normal strings get quoted (double for double quoted strings, single for single)
    * sql
## unity
unifying similar language level concepts to produce a simplified (but no less powerful) experience.

* repl/debugger
* logging/printing
* sql/apl
* regex/sed/match
* looping control flow
* branching control flow
* object/dictionary
