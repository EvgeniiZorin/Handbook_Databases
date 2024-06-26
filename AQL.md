# AQL

AQL is for ArangoDB. ArangoDB can be run in localhost with Docker:
```powershell
docker run -e ARANGO_NO_AUTH=1 -p 8529:8529 -d --name test-arangodb arangodb
```

All the material can be found here: https://docs.arangodb.com/3.11/aql/

# Basic syntax

Two types of operations / queries:
- Returning a result with RETURN keyword
- Modifying the data with INSERT, UPDATE, REPLACE, REMOVE, or UPSERT keywords

Examples of RETURN operation:
```sql
//return each document unchanged, as a list of dictionaries
FOR doc IN users
RETURN doc

//filter
FOR friend IN friends
FILTER friend.name == 'Will'
RETURN friend

//return document by its id `_id`
RETURN document("<name-of-collection>/<id-number>")

//create a projection of returning value
//which is a list of dictionaries, but each dictionary inside of one value (for this example, 'user') will also have
// a dictionary with the query result
FOR doc IN users
RETURN { user: doc,
newAttribute: true }
```

Examples of INSERT operation:
```sql
insert {"name": "Will"} into friends //insert key:value pair into "friends" collection
```

Whitespace (blanks, carriage returns, line feeds, and tab stops) can be used in the query text to increase its readability. Tokens have to be separated by any number of whitespace. Whitespace within strings or names must be enclosed in quotes in order to be preserved.

Comments:

```aql
/* this is a comment */ RETURN 1
/* these */ RETURN /* are */ 1 /* multiple */ + /* comments */ 1
/* this is
   a multi line
   comment */
// a single line comment
some command here // and a comment afterwards
```

Example of a basic query:
```aql
FOR u IN users // `users-collection-1`
  FILTER u.type == "newbie" && u.active == true
  RETURN u.name
// in the above example, `type`, `active`, and `name` are attributes of documents from the collection `users`
```

# Data types

| Data type | Example |	Description |
| - | - | - |
| null | `null` |	An empty value, also: the absence of a value |
| boolean | `true`, `false` |	Boolean truth value with possible values false and true |
| number | 1, +1, -1, 1.05 |	Signed (real) number |
| string | `'string'`, `"string"`, `"this is a \"quoted\" word"`, `'this is a "quoted" word'` |	UTF-8 encoded text value |
| array / list | `[ -99, "yikes!", [ false, ["no"], [] ], 1 ]` <br> `['a', 'b', 'c']` |	Sequence of values, referred to by their positions. Nesting is allowed. Slicing is done as in Python. |
| object / document / dictionary | `{ "name" : "Vanessa", "age" : 15 }` | Sequence of values, referred to by their names |

# Operators

https://docs.arangodb.com/3.12/aql/operators/

**Comparison operators**
| Operator | Description |
| - | - |
| `==` | Equality |
| `!=` | Inequality |
| `<`, `<=`, `>`, `>=` | Comparison |
| `IN`, `NOT IN` | Tests if a value is contained / not contained in an array |
| `LIKE`, `NOT LIKE` | Tests if a string value matches a pattern |
| `=~`, `!~` | Tests if a string value matches \ does not match a regular expression |

Examples:
```sql
//strings
"abc" LIKE "a%" //true
"abc" LIKE "_bc" //true
"a_b_foo" LIKE "a\\_b\\_foo" //true
```

**Logical operators**
| Operator | Description |
| - | - |
| `&&`, `AND` | Logical *and* operator |
| `||`, `OR` | Logical *or* operator |
| `!`, `NOT` | Logical *not* operator |

**Range operator**
| Operator | Description |
| - | - |
| `..` | This operator produced an array of the integer values in the defined range, with both bounding values included. E.g. `2010..2013` produced an array `[2010, 2011, 2012, 2013]` |

# Filter

## Get unique attributes for a class 'Class1'

```sql
let attr = (for d in nodes
filter d._class == 'Class1'
return distinct attributes(d))

return unique(flatten(attr))
```

## Check all neighbouring classes from one of the directions of the link

inbound or outbound

```sql
for i in nodes
filter i._class == 'class1'
for j in 1..1 inbound i rels
return distinct j._class
```

## "Let" statement

```sql
let statement1 = (
    for s in 1..1 inbound nodes rels
    FILTER s._class == "class-here" 
    RETURN distinct {att1: s.att1, att2: s.att2}
)

filter length (statement1) != 0

return distinct{
ATT1: concat_separator('; ', statement1[*].att1),
ATT2: concat_separator('; ', statement1[*].att2),
}
```

---

## General examples

```sql
filter class.attribute 

== 'term here' // exact match
!= 'term1' // not equal to
in ['2021', '2022']

//-------------------------------------------------------------------------



filter not contains(cv.source "douyin")
filter length(className) > 0 // remove nan values (???)
```

COLLECT - counts rows
```sql
for node in nodes
filter node.class=='classHere'

collect 
CLASS = node.class, 
CLASS2 = node.class2
with count into n

return distinct {
class1: CLASS,
class2: CLASS2,
COUNT: n
}
```

## REGEXP

```sql
=~ 'term here' // str.contains
=~ 'term1|term2' // str.contains with an OR logical operator
a =~ 'disease[sd]'
a =~ 'cancer(s|ous)'
```

# Graph traversals

```sql
FOR vertex[, edge[, path]]
IN [min[..max]] // the minimal and maximal depth for the traversal
OUTBOUND|INBOUND|ANY
startVertex
GRAPH graphName
[PRUNE [pruneVariable = ]pruneCondition]
[OPTIONS options]
```

Examples:

```sql
// insert an edge into edge collection "hi_fives" connecting two nodes from the document collection "friends" with "_id" values being "friends/332" and "friends/2771": 
insert {_from: "friends/332", _to: "friends/2771", handCoverage: 0.1} into "hi_fives"
```

```sql
// return nodes that are at most 1 edge away from the node "friends/237", edges being defined in collection "hi_fives"
for friend in 1..1 outbound 
"friends/237" hi_fives
return friend

// return nodes that are at most 2 edges away from the node "friends/237", edges being defined in collection "hi_fives"
for friend in 1..2 outbound 
"friends/237" hi_fives
return friend

```




