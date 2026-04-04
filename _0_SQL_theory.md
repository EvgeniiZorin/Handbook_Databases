# Database normalisation

**Database normalization**:
- The process of **structuring a relational database** in accordance with a series of so-called **normal forms** in order to reduce data redundancy and improve data integrity; usually it is done by splitting a table into smaller tables and coding relationships between them via keys. 
- It was first proposed by British computer scientist Edgar F. Codd as part of his relational model.
- Normalisation is the process of refining a database design to ensure that each independent piece of information is in only one place except for foreign key
- Doesn't really apply in noSQL databases;

Denormalized dataset - all the data is combined in one dataset, without adhering to the database rules. To enter to a database, data has to have data integrity and adhere to some rules of good database design. Normalization of a database table - structuring it in such a way that it doesn't and cannot express *redundant information*. 

The main purpose of database normalization is to avoid complexities, eliminate duplicates, and organize data in a consistent way.

There are some normal forms (NF) which start with the most important (dangerous) at 1NF and continue to the less dangerous ones with increasing number. These are basically like safety assessment levels, starting from broader one to the more detailed ones. 

**1NF** - eliminates repeating groups:
- Row order should NOT be used to convey information in a table;
- Atomicity: a single cell can only contain a single value of the same data type (within the column);
- Every table has to have primary key (one or several);
- Every row should be unique and not be repeated;
- A repeating group of data items should NOT be stored on a single row; instead, should be stored in a separate table referencing the main table via key;

**2NF** - eliminates redundancy:
- The table has to be in 1NF;
- All non-key attribute in a table must depend on the entire primary key (one or several) within that table; if it only depends on one of the primary keys, then it doesn't belong in this table;
- Relationship between tables has to be formed with foreign keys;

**3NF** - eliminates transitive partial dependency:
- The table has to be in 2NF;
- every non-attribute in a table should depend on the key, the whole key, and nothing but the key; that is to say, there should not be dependencies between attributes that are not part of primary key;

An excellent example is given here: https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/#:~:text=The%20First%20Normal%20Form%20%E2%80%93%201NF,-For%20a%20table&text=there%20must%20be%20a%20primary,each%20row%20in%20the%20table

## Denormalisation

Denormalization is a database optimization technique in which we add redundant data to one or more tables. This can help us avoid costly joins in a relational database. Note that denormalization does not mean ‘reversing normalization’ or ‘not to normalize’. It is an optimization technique that is applied after normalization.

Basically, the process of taking a normalized schema and making it non-normalized is called denormalization, and designers use it to tune the performance of systems to support time-critical operations.

In a traditional normalized database, we store data in separate logical tables and attempt to minimize redundant data. We may strive to have only one copy of each piece of data in a database. For example, in a normalized database, we might have a Courses table and a Teachers table. Each entry in Courses would store the teacherID for a Course but not the teacherName. When we need to retrieve a list of all Courses with the Teacher’s name, we would do a join between these two tables. In some ways, this is great; if a teacher changes his or her name, we only have to update the name in one place. The drawback is that if tables are large, we may spend an unnecessarily long time doing joins on tables. Denormalization, then, strikes a different compromise. Under denormalization, we decide that we’re okay with some redundancy and some extra effort to update the database in order to get the efficiency advantages of fewer joins. 

Pros of Denormalization:
- Improved query performance: retrieving data is faster since we do fewer joins;
- Reduced complexity: By combining related data into fewer tables, denormalization can simplify the database schema and make it easier to manage. 
- Simplification of queries: Queries to retrieve can be simpler(and therefore less likely to have bugs), since we need to look at fewer tables.
- Easier Maintenance and Updates: Denormalization can make it easier to update and maintain the database by reducing the number of tables.
- Improved Read Performance: Denormalization can improve read performance by making it easier to access data.
- Better Scalability: Denormalization can improve the scalability of a database system by reducing the number of tables and improving the overall performance.


Cons of Denormalization:
- Reduced data integrity: By adding redundant data, denormalization can reduce data integrity and increase the risk of inconsistencies.
- Increased Complexity: While denormalization can simplify the database schema in some cases, it can also increase complexity by introducing redundant data.
- Increased Storage Requirements: By adding redundant data, denormalization can increase storage requirements and increase the cost of maintaining the database.
- Increased Update and Maintenance Complexity: Denormalization can increase the complexity of updating and maintaining the database by introducing redundant data.
- Limited Flexibility: Denormalization can reduce the flexibility of a database system by introducing redundant data and making it harder to modify the schema.



# ANSI SQL standards

**ANSI SQL** - official SQL standard maintained by ANSI/ISO; "The official set of rules and guidelines for structuring SQL queries".

It defines a uniform, vendor-neutral syntax intended to work across all relational databases, to ensure cross-platform interoperability and avoid vendor lock-in. 

**Non-ANSI SQL** refers to proprietary SQL features or syntax extensions created by database vendors, as well as legacy SQL. 

Examples of non-ANSI SQL:
- `SHOW` statements
- `DO` - execute an expression without returning a result
- Functions from BigQuery: `ARRAY_LENGTH(arr)`, `ARRAY_AGG(value)`, `ARRAY_CONCAT(arr1, arr2)`
- BigQuery ML functions: `ML.PREDICT`, `ML.TRAIN`, `ML.EVALUATE`, `ML.FEATURE_INFO`













# Operators

Operators can be used in SELECT and WHERE statements. 

## Logical 

| Operator | Meaning |
| - | - |
| `AND` | Shows data if all the conditions separated by `AND` are TRUE. |
| `OR` | Shows data if any of the conditions separated by `OR` is TRUE. |
| `NOT` | Shows data if the condition after `NOT` is not true. |
| `BETWEEN ... AND ...` | Return values that are (inclusively) between the two values. `WHERE salary BETWEEN 500 AND 1000`. So `salary BETWEEN 500 AND 1000` is equivalent to `salary >= 500 AND salary <= 1000` |
| `IN` | TRUE if the operand is equal to one of a list of expressions |
| `NOT IN` | Opposite of `IN`. *Note: it is an alias for `<> ALL`* |
| `LIKE` | TRUE if the operand matches a pattern |
| `ALL` | *Difficult to understand* - make comparisons between a single value and every value in a set. *Note: `<> ALL` is equivalent to `NOT IN`* |
| `ANY` | Like ALL but it returns TRUE as soon as a single comparison is favorable. *Note: `= ANY` is equivalent to `IN`* |
| `EXISTS` | TRUE if the subquery returns one or more records. |

Some examples:
```sql
SELECT 
  column1, 
  column2 
FROM table1 
WHERE 
  condition1 AND condition2 AND NOT condition3
;

-- ALL
-- EXAMPLE 1: Find all customers who have never gotten a free film rental
SELECT
  first_name,
  last_name
FROM customer
WHERE customer_id <> ALL ( -- it works just like `WHERE customer_id NOT IN (`, but the latter is much easier to understand
  SELECT customer_id
  FROM payment
  WHERE amount = 0
);

-- EXAMPLE 2:
-- 2. The containing query returns all customers whose total number of films rentals exceeds any of the North American customers
SELECT customer_id, count(*)
FROM rental r 
GROUP BY customer_id 
HAVING COUNT(*) > ALL (
	-- 1. Subquery returns (in one multi-rowed column) the total number of film rentals for all customers in North America 
	SELECT COUNT(*)
	FROM rental r
	INNER JOIN customer c
	ON r.customer_id = c.customer_id 
	INNER JOIN address a
	ON c.address_id = a.address_id 
	INNER JOIN city ct 
	ON a.city_id = ct.city_id 
	INNER JOIN country co 
	ON ct.country_id = co.country_id 
	WHERE co.country IN ('United States', 'Mexico', 'Canada')
	GROUP BY r.customer_id
);

-- ANY
-- EXAMPLE 1: Find all customers whose total film rental payments exceed the total payments for all customers in Bolivia, Paraguay, or Chile
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY (
  SELECT SUM(p.amount)
  FROM payment p
  INNER JOIN customer c
  ON p.customer_id = c.customer_id
  INNER JOIN address a
  ON c.address_id = a.address_id
  INNER JOIN city ct 
  ON a.city_id = ct.city_id
  INNER JOIN country co
  ON ct.country_id = co.country_id
  WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
  GROUP BY co.country
)


-- EXISTS
-- Check for subqueries that return no rows:
-- Find all actors who have never appeared in an R-rated film
SELECT
  a.first_name,
  a.last_name
FROM actor a
WHERE NOT EXISTS (
  SELECT 1
  FROM film_actor fa
  INNER JOIN film f 
    ON f.film_id = fa.film_id
  WHERE 
    fa.actor_id = a.actor_id 
    AND f.rating = 'R'
)

```

## Comparison

Can be used for comparing numbers or strings. 

| Operator | Meaning |
| --- | -- |
| `<`, `<=`, `>`, `>=` | |
| `=` | equals |
| `<>` | not equal. `WHERE name <> 'STEVEN'` |
| `LIKE`, `~`, `REGEXP` | used for regex |
| `IN` | if a value is contained within a list. |
| `BETWEEN` | value is contained between two other values. |

> Note: NULL value indicates an unavailable or unassigned value. The value NULL does not equal zero (0), nor does it equal a space (‘ ‘). Because the NULL value cannot be equal or unequal to any value, you cannot perform any comparison on this value by using operators such as ‘=’ or ‘<>’.
>
> Therefore, use `Column IS NULL` or NOT NULL

## Arithmetic

| Operator | Meaning |
| --- | --- |
| `-`, `+`, `*`, `/` | |
| `^` | power. Works in PostgreSQL. |
| `%` | modulo |

Examples:
```sql
SELECT 10 + 2;
SELECT (100 * 20) / 10;
SELECT column1 * 10;
```

### Divide by zero

To prevent an error when dividing by zero, you case use CASE WHEN statement
```sql
SELECT
  c.first_name,
  c.last_name,
  SUM(p.amount) AS tot_payment_amt,
  COUNT(p.amount) AS num_payments,
  SUM(p.amount) / CASE WHEN COUNT(p.amount) = 0 THEN 1 ELSE COUNT(p.amount) END AS avg_payment
FROM customer AS s
LEFT OUTER JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY 
  c.first_name,
  c.last_name
```

`SAFE_DIVIDE`
- BigQuery

Additionally, when you know that your division operation might involve dividing by zero, you can use BigQuery's function `SAFE_DIVIDE` as it doesn't return an error upon encountering error, but a null value:
```sql
WITH temp1 AS (
  SELECT 1 a, 2 b
  union all
  select 1 a, 1 b  
  union all 
  select 1 a, 0 b  
  union all 
  select 0 a, 1 b  
  union all 
  select 0 a, 0 b
)
SELECT SAFE_DIVIDE (a, b)
from temp1
-- returns
-- | fila | f0_  |
-- | ---- | ---- |
-- | 1    | 0.5  |
-- | 2    | 1.0  |
-- | 3    | null |
-- | 4    | 0.0  |
-- | 5    | null |
```

Features of `SAFE_DIVIDE`:
- It never fails the query because of division by zero or division by null error:
  - If denominator = 0, returns NULL instead of an error
  - If denominator is NULL, returns NULL

## Set 

You perform a set operation by placing a set operator between two select statements:

```sql
SELECT 1 num, 'abc' str
UNION 
select 9 num, 'xyz' str;
```

When performing set operations on two data sets, the following guidelines must apply:
- Both datasets must have the same number of columns;
- The data types of each column across the two data sets must be the same, or compatible.

| Operator | Explanation |
| - | - |
| `UNION` | Combine all the rows from two or more sets. Sort the combined set and remove duplicates. |
| `UNION ALL` | Like UNION, but does not sort the combined set and does not remove duplicates. Thus, the number of rows in the final data set always equals to the sum of the number of rows in the sets being combined. |
| `INTERSECT` | Performs intersection. If the two queries in a compound query return non-overlapping data sets, the intersection will be an empty set. Removes duplicate rows in the overlapping region. |
| `INTERSECT ALL` | Same as INTERSECT but doesn't remove the duplicates in the overlapping region. |
| `EXCEPT` | Performs the EXCEPT set operation - returns the first result set minus any overlap with the second result set. Removes all occurrences of duplicate data from set A. |
| `EXCEPT ALL` | Same as EXCEPT but removes only one occurrence of duplicate data from set A for every occurrence in set B. | 

Examples:
```sql
-- Set A: {10, 10, 10, 11, 12}
-- Set B: {10, 10}

-- A except B: {11, 12}
-- A except all B: {10, 11, 12}
```

### UNION

You perform a set operation by placing a set operator between two `select` statements

Example:
```sql
SELECT ...
FROM table1
WHERE ...
UNION -- UNION ALL, INTERSECT, INTERSECT ALL, EXCEPT
SELECT ...
FROM table2
WHERE ...
```

UNION combines the results from several SELECT statements.

Rule:
- The two statements / tables / data sets that are joined by the `UNION` statement MUST have the same number of columns
- The columns being concatenated MUST have the same data type

```sql
-- Return a list of employee names and then branch names located below the first list
SELECT first_name -- can also specify the name of the common column, e.g. `AS name_of_the_union_column`
FROM employee 
UNION -- can also be UNION ALL
SELECT branch_name 
FROM branch

-- You can also include ORDER BY, but it has to come after the last query AND you have to sort it by the names of the first query
SELECT 
  a.first_name AS fname,
  a.last_name AS lname
FROM actor a
UNION ALL
SELECT 
  c.first_name,
  c.last_name
FROM customer c
ORDER BY lname, fname
;

-- Find a list of all clients and branch suppliers ids
SELECT client_name, branch_id -- to increase clarity, can specify the table: `client.branch_id`
FROM client 
UNION
SELECT supplier_name, branch_id -- same: `branch_supplier.branch_id`
FROM branch_supplier;

-- Get distinct values from two columns - emp_id and is_married
SELECT DISTINCT (a1.emp_marr_vals)
FROM (
	SELECT emp_id AS emp_marr_vals
	FROM newtable
	UNION 
	SELECT is_married
	FROM newtable
) AS a1
```

UNION can also be used to generate synthetic data. See `Types of tables/Subquery/Generate temporary data`

### EXCEPT

```sql
WITH set_a AS (
  SELECT 10 actor_id union all select 11 union all 
  select 12 union all select 10 union all select 10
),

set_b AS (
  select 10 actor_id union all select 10 
)

select * from set_a
except 
select * from set_b

/*
actor_id
11
12
*/
```

```sql
WITH set_a AS (
  SELECT 10 actor_id union all select 11 union all 
  select 12 union all select 10 union all select 10
),

set_b AS (
  select 10 actor_id union all select 10 
)

select * from set_a
except all
select * from set_b

/*
The result now includes a 10, because for 3 occurrences of 10 in set_a, there are only 2 occurrences of 10 in set_b:

actor_id
10
11
12
*/
```

### INTERSECT

PostgreSQL example:

```sql
WITH temp1 AS (
  SELECT 0 index, 'A' letter
  UNION ALL
  SELECT 1 index, 'B' letter
  UNION ALL
  SELECT 2 index, 'C' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'D' letter
),
temp2 AS (
  SELECT 2 index, 'C' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'something else here' letter
  UNION ALL
  SELECT 4 index, 'E' letter
)
SELECT *
FROM temp1
INTERSECT
SELECT *
FROM temp2

-- result
-- if you just run INTERSECT, it basically removes duplicates:
-- index|letter|
-- -----+------+
--     3|D     |
--     2|C     |

-- you can also run INTERSECT ALL, which doesn't remove duplicate intersecting rows:
-- index|letter|
-- -----+------+
--     3|D     |
--     3|D     |
--     2|C     |
```

BigQuery example

```sql
/* This is an example from BigQuery, where only INTERSECT DISTINCT exists. */

WITH temp1 AS (
  SELECT 0 index, 'A' letter
  UNION ALL
  SELECT 1 index, 'B' letter
  UNION ALL
  SELECT 2 index, 'C' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'D' letter
),
temp2 AS (
  SELECT 2 index, 'C' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'D' letter
  UNION ALL
  SELECT 3 index, 'something else here' letter
  UNION ALL
  SELECT 4 index, 'E' letter
)
SELECT *
FROM temp1
INTERSECT ALL
SELECT *
FROM temp2


-- Result:
-- [{
--   "index": "2",
--   "letter": "C"
-- }, {
--   "index": "3",
--   "letter": "D"
-- }]
```

### Generate temporary data

Subqueries (or preferably CTEs) can be used to **generate new data**:

**Generating a (relatively) small dataset**
```sql
-- query
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 99999.99 high_limit;
-- generates the following temporary data
-- name         |low_limit|high_limit|
-- -------------+---------+----------+
-- Small Fry    |        0|     74.99|
-- Average Joes |       75|    149.99|
-- Heavy Hitters|      150|  99999.99|

-- you can subsequently make operations with this synthetic generated data
WITH temp1 AS (
	SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
	UNION ALL
	SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
	UNION ALL
	SELECT 'Heavy Hitters' name, 150 low_limit, 99999.99 high_limit
)
SELECT COUNT(*)
FROM temp1
```

**Generate a larger dataset**
```sql
-- Generate a column with increasing numbers from 0 to 399 (in total 400 rows)
-- MySQL
SELECT 
	ones.num + tens.num + hundreds.num AS a
FROM
(
	SELECT 0 num UNION ALL
	SELECT 1 num UNION ALL
	SELECT 2 num UNION ALL
	SELECT 3 num UNION ALL
	SELECT 4 num UNION ALL
	SELECT 5 num UNION ALL
	SELECT 6 num UNION ALL
	SELECT 7 num UNION ALL
	SELECT 8 num UNION ALL
	SELECT 9 num 
) AS ones
CROSS JOIN
(
	SELECT 0 num UNION ALL
	SELECT 10 num UNION ALL
	SELECT 20 num UNION ALL
	SELECT 30 num UNION ALL
	SELECT 40 num UNION ALL
	SELECT 50 num UNION ALL
	SELECT 60 num UNION ALL
	SELECT 70 num UNION ALL
	SELECT 80 num UNION ALL
	SELECT 90 num 
) AS tens
CROSS JOIN
(
	SELECT 0 num UNION ALL
	SELECT 100 num UNION ALL
	SELECT 200 num UNION ALL
	SELECT 300 num 
) AS hundreds
ORDER BY a
;

-- +-----+
-- | a   |
-- +-----+
-- |   0 |
-- |   1 |
-- |   2 |
-- |   3 |
-- |   4 |
-- |   5 |
-- |   6 |
-- |   7 |
-- |   8 |
-- |   9 |
-- |  10 |
-- |  11 |
-- |  12 |
-- |  13 |
-- ...
-- | 395 |
-- | 396 |
-- | 397 |
-- | 398 |
-- | 399 |
-- +-----+


-- Generate a row for every day in the year 2020
-- MySQL
-- This approach automatically includes the extra leap day (February 29)
SELECT 
	DATE_ADD(
		'2020-01-01', 
		INTERVAL (ones.num + tens.num + hundreds.num) DAY
	) AS dt
FROM
(
	SELECT 0 num UNION ALL
	SELECT 1 num UNION ALL
	SELECT 2 num UNION ALL
	SELECT 3 num UNION ALL
	SELECT 4 num UNION ALL
	SELECT 5 num UNION ALL
	SELECT 6 num UNION ALL
	SELECT 7 num UNION ALL
	SELECT 8 num UNION ALL
	SELECT 9 num 
) AS ones
CROSS JOIN
(
	SELECT 0 num UNION ALL
	SELECT 10 num UNION ALL
	SELECT 20 num UNION ALL
	SELECT 30 num UNION ALL
	SELECT 40 num UNION ALL
	SELECT 50 num UNION ALL
	SELECT 60 num UNION ALL
	SELECT 70 num UNION ALL
	SELECT 80 num UNION ALL
	SELECT 90 num 
) AS tens
CROSS JOIN
(
	SELECT 0 num UNION ALL
	SELECT 100 num UNION ALL
	SELECT 200 num UNION ALL
	SELECT 300 num 
) AS hundreds
WHERE DATE_ADD('2020-01-01', INTERVAL(ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY dt
;

-- Alternatively, can write it like this:
WITH ones AS (
	SELECT 0 num UNION ALL SELECT 1 num UNION ALL SELECT 2 num UNION ALL SELECT 3 num UNION ALL SELECT 4 num UNION ALL SELECT 5 num UNION ALL 
  SELECT 6 num UNION ALL SELECT 7 num UNION ALL SELECT 8 num UNION ALL SELECT 9 num 
),

tens AS (
	SELECT 0 num UNION ALL SELECT 10 num UNION ALL
	SELECT 20 num UNION ALL	SELECT 30 num UNION ALL	SELECT 40 num UNION ALL	SELECT 50 num UNION ALL	
  SELECT 60 num UNION ALL	SELECT 70 num UNION ALL	SELECT 80 num UNION ALL
	SELECT 90 num 
),

hundreds AS (
	SELECT 0 num UNION ALL
	SELECT 100 num UNION ALL
	SELECT 200 num UNION ALL
	SELECT 300 num 
)

SELECT 
	DATE_ADD(
		'2020-01-01', 
		INTERVAL (ones.num + tens.num + hundreds.num) DAY
	  ) AS dt
FROM ones
CROSS JOIN tens
CROSS JOIN hundreds
WHERE 
  DATE_ADD(
    '2020-01-01', 
    INTERVAL(ones.num + tens.num + hundreds.num) DAY
    ) < '2021-01-01'
ORDER BY dt
;

-- +------------+
-- | dt         |
-- +------------+
-- | 2020-01-01 |
-- | 2020-01-02 |
-- | 2020-01-03 |
-- | 2020-01-04 |
-- | 2020-01-05 |
-- | 2020-01-06 |
-- | 2020-01-07 |
-- | 2020-01-08 |
-- | 2020-01-09 |
-- | 2020-01-10 |
-- | 2020-01-11 |
-- | 2020-01-12 |
-- | 2020-01-13 |
-- | 2020-01-14 |
-- | 2020-01-15 |
-- | 2020-01-16 |
-- | 2020-01-17 |
-- | 2020-01-18 |
-- | 2020-01-19 |
-- | 2020-01-20 |
-- | 2020-01-21 |
-- | 2020-01-22 |
-- | 2020-01-23 |
-- | 2020-01-24 |
-- | 2020-01-25 |
-- | 2020-01-26 |
-- | 2020-01-27 |
-- | 2020-01-28 |
-- | 2020-01-29 |
-- | 2020-01-30 |
-- | 2020-01-31 |
-- | 2020-02-01 |
-- | 2020-02-02 |
-- | 2020-02-03 |
-- ...
-- | 2020-12-22 |
-- | 2020-12-23 |
-- | 2020-12-24 |
-- | 2020-12-25 |
-- | 2020-12-26 |
-- | 2020-12-27 |
-- | 2020-12-28 |
-- | 2020-12-29 |
-- | 2020-12-30 |
-- | 2020-12-31 |
-- +------------+
```


