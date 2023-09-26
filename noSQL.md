
# noSQL

# AQL

## Basic

All the material can be found here: https://docs.arangodb.com/3.11/aql/

Two types of operations:
- Returning a result with RETURN keyword
- Modifying the data with INSERT, UPDATE, REPLACE, REMOVE, or UPSERT keywords

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

| Data type |	Description |
| - | - |
| null |	An empty value, also: the absence of a value |
| boolean |	Boolean truth value with possible values false and true |
| number |	Signed (real) number |
| string |	UTF-8 encoded text value |
| array / list |	Sequence of values, referred to by their positions |
| object / document |	Sequence of values, referred to by their names |




