# what features do databases typically offer?
* persistent storage
* transactions
* speed (indexing)
* data structuring (filter and reorder output)

# sql as interface to the database
sql proposes a way to ask for the data you want, rather than how to get the data you want (declarative, not procedural), in order to allow the planner to optimize execution in accordance with normally the db state (whether indexes exist, table size, etc).
* a data structuring language

# why sql sucks
[x](https://www.edgedb.com/blog/we-can-do-better-than-sql)
# what could replace sql

# not defining tables directly, object-relational mapping
can we generate an optimal table configuration automatically, from an object level description?

define the object types to be stored in terms of primitive, sum, product, and tags (names).

the database should restructure tables as the number of objects grows, and log the types of queries being performed, generating indexes and such.

# structured returns
sql is limited to returning a flat list of values, which is often then structured using an ORM specific to the host language.

expand the return schema to a nested struct at least (list of lists).
also return type structure (for sum types).

# better flow
expressions should be composable
start with data composition on the left, filter it, then end with output structure
`table1 table2 ijoin fieldA:fieldB ...` compose data by inner joining tables using two fields
`... !? fieldC = 0 ...` where not fieldC == 0
`... output fieldA [fieldC] ...` select [fieldA, [fieldC]]
