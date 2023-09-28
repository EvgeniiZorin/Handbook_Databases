
# noSQL

# AQL

All the material can be found here: https://docs.arangodb.com/3.11/aql/

## Basic syntax

Two types of operations:
- Returning a result with RETURN keyword
- Modifying the data with INSERT, UPDATE, REPLACE, REMOVE, or UPSERT keywords

Whitespace (blanks, carriage returns, line feeds, and tab stops) can be used in the query text to increase its readability. Tokens have to be separated by any number of whitespace. Whitespace within strings or names must be enclosed in quotes in order to be preserved.

Comments:

```aql
/* this is a comment */ RETURN 1
/* these */ RETURN /* are */ 1 /* multiple */ + /* comments */ 1
/* this is
   a multi line
   comment */
// a single line comment
```

Example of a basic query:
```aql
FOR u IN users // `users-collection-1`
  FILTER u.type == "newbie" && u.active == true
  RETURN u.name
// in the above example, `type`, `active`, and `name` are attributes of documents from the collection `users`
```

## Data types

| Data type | Example |	Description |
| - | - | - |
| null | `null` |	An empty value, also: the absence of a value |
| boolean | `true`, `false` |	Boolean truth value with possible values false and true |
| number | 1, +1, -1, 1.05 |	Signed (real) number |
| string | `'string'`, `"string"`, `"this is a \"quoted\" word"`, `'this is a "quoted" word'` |	UTF-8 encoded text value |
| array / list | `[ -99, "yikes!", [ false, ["no"], [] ], 1 ]` |	Sequence of values, referred to by their positions. Nesting is allowed. Slicing is done as in Python. |
| object / document / dictionary | `{ "name" : "Vanessa", "age" : 15 }` | Sequence of values, referred to by their names |




