# Query clauses

SQL query clauses:
- select
- from
- where
- group by
- having
- order by

Each clause has keywords / statements, e.g. clause SELECT has statements such as DISTINCT etc.

## Order of execution

1. FROM / JOIN
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY 
8. LIMIT
9. OFFSET

## Aliases

```sql
-- General syntax
SELECT 
  column1 AS "column title", 
  column2 AS aliasHere, ..., columnN
-- or `*` to select the rows from all the columns in a table
-- or `table1.column1, table1.column2` to specify which table, especially useful in joins
FROM table1
WHERE 
  column2 = 'Value' -- allows us to specify a condition by using an operator
  AND (column3 = 'Value2' OR column3 > 100);

-- we can also give aliases to the tables
SELECT o.OrderId, o.OrderDate, c.CustomerId, c.FirstName, c.LastName, c.Country
FROM Orders o
RIGHT JOIN Customers c 
ON o.CustomerId = c.CustomerId

-- When aliasing, we can either use the keyword AS or omit it
-- (albeit it is preferable to use the AS keyword)
SELECT column1 AS alias1 
-- or
SELECT column1 alias1
```

> Note: alias name cannot start with a digit / number

## SELECT

```sql
-- select all columns
SELECT * 
FROM table1
-- select all but one column
SELECT * EXCEPT (id)
FROM table1
```

There are different ways of aliasing columns:

```sql
SELECT
  column1, 
  COUNT(*)
FROM table1
GROUP BY column1
ORDER BY COUNT(*) DESC

-- or
SELECT
  column1, 
  COUNT(*)
FROM table1
GROUP BY 1
ORDER BY 2 DESC
```

### Built-in functions

For the sample built-in functions below you don't even need a WHERE clause:

```sql
SELECT 
  version(),
  user(),
  database()
;
```

### Random sampling

https://render.com/blog/postgresql-random-samples-big-tables

**random()**


First type of sort is this. 

Intuitive but very inefficient.

```sql
SELECT * FROM my_events -- first, examines every row in the table
ORDER BY random() -- performs a lot of comparisons to sort
LIMIT 10000;
```

Next type - Bernoulli sampling. Much faster (as you just go through the data once) but the output is non-deterministic in the count of rows you get.

```sql
-- Random returns a value in the range [0, 1)
-- Therefore we compare against (0.001% / 100) to get ~10k rows
SELECT * FROM sample_values WHERE random() < 0.00001;
```


**TABLESAMPLE SYSTEM**

Sample N % of all data points. 

> More info: https://cloud.google.com/bigquery/docs/table-sampling

```sql
-- IMPORTANT! sampling is always done before the filtering. Here, you will first sample the table and then to that sample apply the WHERE clause, so the actual amount of sampled data will vary 
SELECT *
FROM table1 TABLESAMPLE SYSTEM (1)
WHERE last_name = 'Wayne'

-- or
SELECT *
FROM table1 AS t1
TABLESAMPLE SYSTEM (0.1) -- sample 0.1% of rows
WHERE last_name = 'Wayne'

-- To first filter and then do sampling you can do this, you can create a temporary table but I don't know how to do it: https://dba.stackexchange.com/questions/258271/perform-tablesample-with-where-clause-in-postgresql#:~:text=However%20you%20can%20work%20around%20this%20if%20you%20really%20want%20to%20use%20the%20tablesample%20attribute%20by%20creating%20a%20temporary%20table%20(or%20similar)%20based%20on%20your%20conditional%20query.

```

### Record expansion

In PostgreSQL, if you have a column where each row is a record/tuple of fixed length (e.g., `(a, b, c)`), and you want to split this column into separate columns, you can use record expansion (also called row deconstruction) via:
- `SELECT (column_name).*` syntax
- Or explicitly cast to a named composite type or use `unnest`, `json`, etc., depending on the context

For instance, the query below returns a column which consists of records with tuples of fixed length:
```sql
WITH temp1 AS (
	SELECT 1 a, 2 b, 3 c 
	UNION ALL
	SELECT 4 a, 5 b, 6 c
), 
temp2 AS (
	SELECT DISTINCT(a, b, c)
	FROM temp1
)
SELECT *
FROM temp2 
-- row    |
-- -------+
-- (1,2,3)|
-- (4,5,6)|
```

You can split it into several columns 
```sql
WITH temp1 AS (
	SELECT 1 a, 2 b, 3 c 
	UNION ALL
	SELECT 4 a, 5 b, 6 c
), 
temp2 AS (
	SELECT DISTINCT(a, b, c)
	FROM temp1
)
SELECT 
	(row).f1 AS row1,
	(row).f2 AS row2,
	(row).f3 AS row3
FROM temp2 
-- row1|row2|row3|
-- ----+----+----+
--    1|   2|   3|
--    4|   5|   6|
```

### COALESCE

> Basically null-value handling.
>
> NOTE: the order of arguments in COALESCE is very important - it returns the FIRST non-null value, therefore, you can thus set priority - the first argument has a higher priority than the second argument, where the latter is used only if the former is absent.

Return the first non-null value in a list of columns. If all the values in the list of columns are NULL, then the function returns NULL

```sql
SELECT 
	name 
	, alias 
	, COALESCE(name, alias)
FROM student s 
-- returns:
-- name        |alias       |coalesce    |
-- ------------+------------+------------+
-- John Wick   |Baba Yaga   |John Wick   |
-- Jack Bauer  |Dude from 24|Jack Bauer  |
-- Poseidon    |Tlalok      |Poseidon    |
-- John Stramer|            |John Stramer|
--             |Ghostface   |Ghostface   |


-- in this case get a value for NULL values
WITH table1 AS (
	SELECT 'John' AS name
	UNION ALL
	SELECT NULL AS name
	UNION ALL
	SELECT 'Jack' AS name
)
SELECT 
	COALESCE(name, 'unknown')
FROM table1
-- coalesce|
-- --------+
-- John    |
-- unknown |
-- Jack    |
```

Can also coalesce based on three columns:
```sql
WITH table1 AS (
	SELECT 'John' AS name1, 'John' AS name2, NULL AS name3
	UNION ALL
	SELECT NULL AS name1, NULL AS name2, 'Jane' AS name3
	UNION ALL
	SELECT 'Jack' AS name1, 'Jill' AS name2, 'Joan' AS name3
	UNION ALL
	SELECT NULL AS name1, NULL AS name2, NULL AS name3
)
SELECT 
	COALESCE(name1, name2, name3),
	*
FROM table1

-- coalesce|name1|name2|name3|
-- --------+-----+-----+-----+
-- John    |John |John |     |
-- Jane    |     |     |Jane |
-- Jack    |Jack |Jill |Joan |
--         |     |     |     |
```

You can also include COALESCE into a WHERE condition:
```sql
with temp1 as (
  select 'ab' id 
  union all
  select 'cd' id 
  union all 
  select NULL id
)
select 
  coalesce(id, 'none') AS id
from temp1
where coalesce(id, 'none') <> 'ab'
```

### EXCEPT

This function doesn't work in PostgreSQL. Works in BigQuery.

```sql
-- Select every column except for the column `alias`
SELECT
	* EXCEPT (alias)
FROM student s

```

### FARM_FINGERPRINT

> Only works in BigQuery

Computer the fingerprint of a STRING or BYTES value, using the FarmHash Fingerprint64 algorithm. The output of this function for a particular input will never change. **It is a fingerprint function, whose requirement it is to simply produce a deterministic unique hash value for every unique input (avoid collisions)**. 

Example:
```sql
SELECT 
  id,
  FARM_FINGERPRINT(name)
FROM `dataset.table1`
```

This is useful for making reproducible samples. For example, in the query below, since each unique value processed with farm_fingerprint maps to a unique fingerprint (reproducibly), then this can serve as a proxy for a random, but reproducible sample. 
```sql
WITH temp1 AS (
	SELECT 1 id, 103 value
	UNION ALL
	SELECT 2 id, 102 value
	UNION ALL
	SELECT 3 id, 1339 value
	UNION ALL
	SELECT 4 id, 371 value
	UNION ALL
	SELECT 5 id, 193 value
	UNION ALL 
	SELECT 6 id, 1923 value
	UNION ALL
	SELECT 7 id, 1022 value
	UNION ALL
	SELECT 8 id, 162 vlaue
	UNION ALL 
	SELECT 9 id, 19234785 value
	UNION ALL
	SELECT 10 id, 5673 value
)
SELECT 
	*,
	FARM_FINGERPRINT(CAST(value AS string)) AS farm_fingerprint_value,
	ROW_NUMBER() OVER (
		ORDER BY FARM_FINGERPRINT(
			CAST(value AS string)
		)) AS random_count
FROM temp1
-- | id | value | farm_fingerprint_value | random_count |
-- | - | - | - | - |
-- | 4 | 371 | -5933768062887988196 | 1 |
-- | 7 | 1022 | -3328868577810523882 | 2 |
-- | 9 | 19234785 | -3020018155477927287 | 3 |
-- ...
-- | 10 | 5 | 193 | 8834274070702014843 | 10 |
```

Therefore, we can choose to randomly select a sample of 3 rows, but this will be reproducible in the future.
```sql
WITH temp1 AS (
	SELECT 1 id, 103 value
	UNION ALL
	SELECT 2 id, 102 value
	UNION ALL
	SELECT 3 id, 1339 value
	UNION ALL
	SELECT 4 id, 371 value
	UNION ALL
	SELECT 5 id, 193 value
	UNION ALL 
	SELECT 6 id, 1923 value
	UNION ALL
	SELECT 7 id, 1022 value
	UNION ALL
	SELECT 8 id, 162 vlaue
	UNION ALL 
	SELECT 9 id, 19234785 value
	UNION ALL
	SELECT 10 id, 5673 value
),
hashed AS (
	SELECT 
		*,
		FARM_FINGERPRINT(CAST(value AS string)) AS farm_fingerprint_value, -- NOTE : this is an optional variable, used here just for visualising
		ROW_NUMBER() OVER (
			ORDER BY FARM_FINGERPRINT(
				CAST(value AS string)
			)) AS random_count
	FROM temp1
)
SELECT 
	id,
	value
FROM hashed
WHERE random_count <= 3
-- | id | value |
-- | - | - |
-- | 4 | 371 |
-- | 7 | 1022 |
-- | 9 | 19234785 |
```

Using a slighly modified example to do stratified sampling stratified by groupp:
```sql
WITH temp1 AS (
	SELECT 1 id, 103 value, 'a' groupp
	UNION ALL
	SELECT 2 id, 102 value, 'a' groupp
	UNION ALL
	SELECT 3 id, 1339 value, 'a' groupp
	UNION ALL
	SELECT 4 id, 371 value, 'a' groupp
	UNION ALL
	SELECT 5 id, 193 value, 'b' groupp
	UNION ALL 
	SELECT 6 id, 1923 value, 'b' groupp
	UNION ALL
	SELECT 7 id, 1022 value, 'b' groupp
	UNION ALL
	SELECT 8 id, 162 vlaue, 'c' groupp
	UNION ALL 
	SELECT 9 id, 19234785 value, 'c' groupp
	UNION ALL
	SELECT 10 id, 5673 value, 'c' groupp
),
/*
CODE VARIANT 1
this is the way to write it in PostgreSQL; also works in BigQuery but is more verbose
*/
hashed AS (
	SELECT 
		*,
		ROW_NUMBER() OVER (
			PARTITION BY groupp
      ORDER BY FARM_FINGERPRINT(
				CAST(value AS string)
			)) AS random_count
	FROM temp1
)
SELECT 
	id,
  groupp,
	value
FROM hashed
WHERE random_count <= 2
/*
CODE VARIANT 2
In BigQuery, you can make it shorter:
*/
SELECT *
FROM temp1 
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY groupp 
  ORDER BY FARM_FINGERPRINT(CAST(value AS string))
) <= 3

-- | id | groupp | value |
-- | 4 | a | 371 |
-- |3 | a | 1339 |
-- | 7 | b | 1022 |
-- | 6 | b | 1923 |
-- | 9 | c | 19234785 |
-- | 10 | c | 5673 |
```

Another example:
```sql
with temp1 AS (
  select 1 idd, 'one' descr
  union all 
  select 1 idd, 'one again' descr
  union all
  select 2 idd, 'two' descr
  union all 
  select 2 idd, 'two again' descr 
  union all 
  select 3 idd, 'three' descr
  union all 
  select 4 idd, 'four' descr 
  union all 
  select 5 idd, 'five' descr
)

select 
  idd,
  string_agg(descr)
from temp1
GROUP BY idd 
ORDER BY farm_fingerprint(cast(idd as string))
limit 3
-- Fila	idd	f0_
-- 1	1	one,one again
-- 2	3	three
-- 3	4	four	
```

---

Final note:

apart from farm_fingerprint (which is great because it's reproducible) you can also use random number: 

```sql
SELECT *
FROM temp1 
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY groupp 
  ORDER BY RAND()
) <= 3
```






### SPLIT_PART

From a column with text values, where each cell has values with a delimiter, extract n-th value into a new column.

> Works in PostgreSQL

Simple example:
```sql
SELECT SPLIT_PART('a,b,c', ',', 2)
-- split_part|
-- ----------+
-- b         |
```

Another example, slightly more complex:
```sql
WITH temp1 AS (
	SELECT 'a1,b1,c1' AS str1
	UNION ALL
	SELECT 'a2,b2,c2' AS str1
)
SELECT 
	SPLIT_PART(str1, ',', 1) AS a,
	SPLIT_PART(str1, ',', 2) AS b,
	SPLIT_PART(str1, ',', 3) AS c
FROM temp1
-- a |b |c |
-- --+--+--+
-- a1|b1|c1|
-- a2|b2|c2|
```

### SUBSTRING

> In some dialects SUBSTR

Slice a string.

Basic syntax: `SUBSTRING(string, start_position, length)`

```sql
WITH temp1 AS (
	SELECT 'Betty' name 
	UNION ALL 
	SELECT 'Anastasia' name
)
SELECT substring (name, 1, 3)
FROM temp1
-- substring|
-- ---------+
-- Bet      |
-- Ana      |
```

Using a negative start_position (in some dialects like MySQL): a negative start_position counts from the end of the string.
```sql
SELECT SUBSTRING('Hello, World!', -6); -- Result: 'World!'
```

### LEFT

Extract `n` characters from a string, starting from left:

```sql
SELECT LEFT('whatever', 3) AS ExtractString; -- output is `wha`

```


### Row array-like, SPLIT

Splits a string row into multiple rows based on a specified delimiter. 

> Works in BigQuery
>
> Doesn't work in PostgreSQL

By default, splits the rows into nested rows, where each row will be a list of split values:

```sql
WITH temp1 AS (
  SELECT 0 id, SPLIT('product a', ' ; ') feature
  UNION ALL
  SELECT 1 id, SPLIT('product a ; product b ; product c', ' ; ') feature
  UNION ALL 
  SELECT 2 id, SPLIT('product a ; product b', ' ; ') feature
)
SELECT *
FROM temp1

-- [{
--   "id": "0",
--   "feature_split": ["product a"]
-- }, {
--   "id": "1",
--   "feature_split": ["product a", "product b", "product c"]
-- }, {
--   "id": "2",
--   "feature_split": ["product a", "product b"]
-- }]

-- As a table in database IDE, it kind of looks like this:
-- | id | feature   |
-- | -- | --------- |
-- | 0  | product a |
-- | 1  | product a |
-- |    | product b |
-- |    | product c |
-- | 2  | product a |
-- |    | product b |
```

To reset the index, use the UNNEST function:
```sql
WITH temp1 AS (
  SELECT 0 id, SPLIT('product a', ' ; ') feature
  UNION ALL
  SELECT 1 id, SPLIT('product a ; product b ; product c', ' ; ') feature
  UNION ALL 
  SELECT 2 id, SPLIT('product a ; product b', ' ; ') feature
)
SELECT 
  id,
  feature_split_2
FROM 
  temp1,
  UNNEST(feature) AS feature_split_2

-- [{
--   "id": "0",
--   "feature_split_2": "product a"
-- }, {
--   "id": "1",
--   "feature_split_2": "product a"
-- }, {
--   "id": "1",
--   "feature_split_2": "product b"
-- }, {
--   "id": "1",
--   "feature_split_2": "product c"
-- }, {
--   "id": "2",
--   "feature_split_2": "product a"
-- }, {
--   "id": "2",
--   "feature_split_2": "product b"
-- }]
```

Now check this out! An alternative to `SPLIT_PART` in BigQuery is the combination of `SPLIT` and `SAFE_OFFSET`:
```sql

with temp1 AS (
  select 'a/b/c' col1
  union all
  select 'a2/b2' col1 
  union all 
  select 'a3' col1
)

select 
  col1, 
  split(col1, '/')[safe_offset(0)]
from temp1
```


At least in BigQuery, you can filter based on these array-like values:
```sql
WITH temp1 AS (
  SELECT 0 id, split('product a', ' ; ') feature
  UNION ALL
  SELECT 1 id, split('product a ; product b ; product c', ' ; ') feature
  UNION ALL 
  SELECT 2 id, split('product a ; product b', ' ; ') feature
)

SELECT *
FROM temp1
WHERE array_to_string(feature, ',') = 'product a,product b'
-- [{
--   "id": "2",
--   "feature": ["product a", "product b"]
-- }]
```


### Window functions



### Aggregate functions


#### GROUP BY 


```sql
-- GROUP BY
--- we can use order of the tables in the filter statement - you basically substitute the names of columns in the filter statement with their ordinal number (index in the order of mention)
SELECT 
  column1, 
  column2, 
  COUNT(column3)
FROM table1
GROUP BY 1 2 
ORDER BY 2 DESC

-- Find out the total salary paid out by each department
SELECT 
  department_id, 
  SUM(salary) as total_salary
FROM employees
GROUP BY department_id;
-- Group by can be used with joins:
SELECT u.name as NAME, SUM(t.amount) as BALANCE
FROM Users u
INNER JOIN Transactions t
ON u.account = t.account
GROUP BY u.name
HAVING SUM(t.amount) > 10000


-- Note: order of GROUP BY doesn't matter - the final numbers will remain the sum, just the order will change
-- https://www.kaggle.com/discussions/getting-started/100307
-- https://stackoverflow.com/questions/3064677/does-the-order-of-columns-matter-in-a-group-by-clause
-- consider this table:
-- | country | person | sale |
-- | - | - | - |
-- | UK | John | 100 |
-- | UK | John | 200 |
-- | UK | Lisa | 500 |
-- | Mex | John | 100 |
-- | Mex | Marvin | 150 |
-- | Mex | Marvin | 150 |
-- | Mex | Jake | 50 |
-- Now consider two queries: 
SELECT 1, 2, SUM(sale)
FROM table1
GROUP BY 1, 2
-- or
SELECT 2, 1, SUM(sale)
FROM table1
GROUP BY 2, 1
-- they will produce the same calculations, just in different order
```

```sql
-- Count number of repetitions of unique categories in column `column1`
SELECT branch_id, COUNT(*) FROM branch_supplier GROUP BY branch_id 
-- Count number of repetitions of unique categories in column `column1` where count is greater than 3
SELECT branch_id, COUNT(*) FROM branch_supplier GROUP BY branch_id HAVING COUNT(*) > 3;

-- Count how many unique categories each super_id has
SELECT super_id, COUNT(DISTINCT(emp_id)) FROM employee GROUP BY super_id;
```

- `GROUP BY column1`
- `GROUP BY column1 HAVING COUNT(*) > 5` only group those values whose count is > 5
- `select major_id, count(*) from students group by major_id;` count unique values in column 'major_id'
- `select major_id, min(gpa) from students group by major_id;` view min value in each group within column major_id

##### ALL

The `GROUP BY ALL` clause is a SQL shorthand notation that automatically groups the results by all non-aggregated columns present in the SELECT statement. This feature is a non-standard extension supported by some modern data platforms like Snowflake, Databricks, **BigQuery**, and ClickHouse, but not universally available in traditional relational databases like MySQL or Oracle. 

Example:
```sql
with temp1 AS (
  select 1 id, 'meat' category, 15 price union all 
  select 2 id, 'meat' category, 6 price union all 
  select 3 id, 'veggies' category, 10 price union all 
  select 4 id, 'veggies' category, 2 price union all 
  select 5 id, 'other' category, 10 price  
)

select
  category,
  sum(price)
FROM temp1 
group by all

-- output:
-- [{
--   "category": "meat",
--   "f0_": "21"
-- }, {
--   "category": "veggies",
--   "f0_": "12"
-- }, {
--   "category": "other",
--   "f0_": "10"
-- }]
```

##### WHERE vs HAVING

**WHERE vs HAVING clause**:
- WHERE is used for filtering rows BEFORE any grouping or aggregation. 
  - You cannot filter in your WHERE statements based on aggregate functions, as they haven't been generated yet. Therefore, WHERE does not work with aggregated results;
- HAVING is used for filtering rows AFTER any grouping or aggregation.
  - The HAVING clause was added to SQL to filter the results of the GROUP BY clause. 
  - The HAVING clause is used in combination with the GROUP BY clause in a SELECT statement to filter rows based on specified conditions after the data is grouped and aggregated. It operates on the result of the grouping operation and filters the aggregated data.


**Here is a thorough example:**
```sql
SELECT * 
FROM client;
-- client_id|branch_id|
-- ---------+---------+
--       400|        2|
--       401|        2|
--       402|        3|
--       403|        3|
--       404|        2|
--       405|        3|
--       406|        2|

/*
For example, in the query below, you can query BEFORE grouping, 
but you cannot query aggregate functions. For instance, this is a simple query condition
*/
WITH client AS (
	SELECT 400 client_id, 2 branch_id UNION ALL SELECT 401 client_id, 2 branch_id UNION ALL SELECT 402 client_id, 3 branch_id UNION ALL SELECT 403 client_id, 3 branch_id UNION ALL SELECT 404 client_id, 2 branch_id UNION ALL SELECT 405 client_id, 3 branch_id UNION ALL SELECT 406 client_id, 2 branch_id
)
SELECT 
	branch_id,
	COUNT(*) AS clients_per_branch
FROM client
WHERE client_id <> 405 -- however, you CANNOT write `WHERE COUNT(*) = 4`
GROUP BY branch_id;
-- branch_id|clients_per_branch|
-- ---------+------------------+
--         3|                 2|
--         2|                 4|

/*
If you wanted, however, to filter by the results of the count aggregate function, 
you would have to include an extra CTE, as you cannot filter using WHERE keyword 
the result of an aggregate function:
*/
WITH client AS (
	SELECT 400 client_id, 2 branch_id UNION ALL SELECT 401 client_id, 2 branch_id UNION ALL SELECT 402 client_id, 3 branch_id UNION ALL SELECT 403 client_id, 3 branch_id UNION ALL SELECT 404 client_id, 2 branch_id UNION ALL SELECT 405 client_id, 3 branch_id UNION ALL SELECT 406 client_id, 2 branch_id
), 
temp1 AS (
	SELECT 
	branch_id,
	COUNT(*) AS clients_per_branch
	FROM client
	WHERE client_id <> 405
	GROUP BY branch_id
)
SELECT 
	*
FROM temp1
WHERE clients_per_branch = 4
-- branch_id|clients_per_branch|
-- ---------+------------------+
--         2|                 4|

/*
Nevertheless, you can use HAVING statement to filter the result
of an aggregate function like COUNT:
*/
WITH client AS (
	SELECT 400 client_id, 2 branch_id UNION ALL SELECT 401 client_id, 2 branch_id UNION ALL SELECT 402 client_id, 3 branch_id UNION ALL SELECT 403 client_id, 3 branch_id UNION ALL SELECT 404 client_id, 2 branch_id UNION ALL SELECT 405 client_id, 3 branch_id UNION ALL SELECT 406 client_id, 2 branch_id
)
SELECT 
	branch_id,
	COUNT(*) AS clients_per_branch
FROM client 
GROUP BY branch_id
HAVING COUNT(*) = 4;
-- branch_id|clients_per_branch|
-- ---------+------------------+
--         2|                 4|
```

If you have both a WHERE clause and a HAVING clause in your query, WHERE will execute first.

In order to use HAVING, you also need:
- A GROUP BY clause
- An aggregation in your SELECT section (SUM, MIN, MAX, etc.)

Some more examples of using the `HAVING` statement:
```sql
-- Example 1
SELECT 
  p.name,
  p.surname,
  COUNT(*)
FROM person p
INNER JOIN transactions t
ON p.id = t.person_id
GROUP BY 
  name, 
  surname
HAVING COUNT(*) >= 40


-- Example 2
SELECT column1, aggregate_function(column2)
FROM table
GROUP BY column1
HAVING aggregated_condition;
-- Find out which departments have a total salary payout greater than 50,000
SELECT 
  department_id,
  COUNT(*) AS number_of_employees, -- also can be `COUNT(employee_id) AS number_of_employees` 
  SUM(salary) as total_salary
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 50000;
```


#### STRING_AGG

> Note: string_agg = postgresql; group_concat = mysql;

```sql
-- STRING_AGG to concatenate strings
-- Below, the ORDER BY within the agg function is optional - it's just to sort the concatenated names lexicographically within each concatenation group
SELECT id, STRING_AGG(name, ', ' ORDER BY name) AS names
FROM some_table
GROUP BY id
```

> If you don't specify the separator, it will default to `,`: `STRING_AGG(column1)`

Concatenate all rows in column "countryname" into one cell, delimited by `, `
```sql
SELECT 
  STRING_AGG(countryname, ', ')
FROM table1
```

```sql
-- for each group in "supply_type", concatenate rows in the column "supplier_name" 
SELECT 
	supply_type,
	STRING_AGG(supplier_name, ' | ') AS suppliers_agg
FROM table1 
GROUP BY supply_type

-- supply_type     |suppliers_agg                            |
-- ----------------+-----------------------------------------+
-- Writing Utensils|Uni-ball | Uni-ball                      |
-- Paper           |Hammer Mill | Patriot Paper | Hammer Mill|
-- Custom Forms    |J.T. Forms & Labels | Stamford Lables    |

-- Same but with a non-textual column
STRING_AGG(CAST(supplier_id AS STRING), ' | ')
```

You can also concatenate rows from a non-textual column:
```sql
-- Method 1
-- works in PostgreSQL
WITH a1 AS (
	SELECT CAST(emp_id AS VARCHAR)
	FROM test.employee
)
SELECT STRING_AGG(emp_id, ' ') FROM a1
-- Method 2
SELECT STRING_AGG(CAST(emp_id AS VARCHAR), ' | ') -- VARCHAR for PostgreSQL and STRING for BigQuery
FROM test.employee
```

another example (you can comment out the `DISTINCT` statement below to see that you get repeats)
```sql
with temp1 AS (
  select 1 id, 'one' key, 'a' value
  union all 
  select 1 id, 'one' key, 'a' value
  union all 
  select 1 id, 'one' key, 'b' value
  union all 
  select 1 id, 'two' key, 'a' value
  union all
  select 2 id, 'one' key, 'a' value
  union all 
  select 2 id, 'two' key, 'b' value
  union all 
  select 2 id, 'two' key, 'b' value 
  union all 
  select 2 id, 'three' key, 'b' value
  union all 
  select 2 id, 'three' key, 'b' value
)
select 
  id,
  STRING_AGG(
    DISTINCT
      CONCAT(key, ' : ', value),
      ' || '
  ) AS descr_key_value
FROM temp1
group by id
-- [{
--   "id": "1",
--   "descr_key_value": "one : a || one : b || two : a"
-- }, {
--   "id": "2",
--   "descr_key_value": "one : a || two : b || three : b"
-- }]
```

You can also sort values within the `STRING_AGG` expression:

```sql
STRING_AGG(DISTINCT column1, ', ' ORDER BY column1)
```


Example of GROUP_CONCAT (MySQL):
```sql
-- concatenate all rows in the column "last_name" with separator ', '
group_concat(last_name ORDER BY first_name SEPARATOR ', ')
```

#### Quantile

`APPROX_QUANTILES`: 
- BigQuery = Aggregate functions

```sql
APPROX_QUANTILES([DISTINCT] expression, number [{IGNORE|RESPECT} NULLS])
```
- `expression`: the column or expression containing numeric data for which to calculate quantiles;
- `number`: an integer representing the number of quantiles to divide the data into, e.g. `4` for quartiles, `100` for percentiles;
- `IGNORE NULLS` or `RESPECT NULLS`: optional clauses to control null handling. By default, it's ignore nulls;

`PERCENTILE_DISC`: 
- Calculate percentiles, taking the value that exists in the dataset; so if there is an even number of data points, it takes the lower middle value
- BigQuery = window function 
- PostgreSQL = aggregate function

`PERCENTILE_CONT`:
- Find true quantiles: if there's an even number of data points, takes the average of the middle two values
- BigQuery = window function
- PostgreSQL = aggregate function


**BigQuery**

```sql
WITH table1 AS (
	SELECT 'Carpenter' AS profession, 70 AS age UNION ALL
	SELECT 'Carpenter', 50 UNION ALL
  SELECT 'Carpenter', 65 UNION ALL
  SELECT 'Carpenter', 45 UNION ALL
  SELECT 'Programmer', 30 UNION ALL
  SELECT 'Programmer', 35 UNION ALL
  SELECT 'Programmer', 20 UNION ALL
  SELECT 'Programmer', 25 
)
SELECT 
	profession,
	MIN(age) AS min_age,
	AVG(age) AS mean_age,
  -- BigQuery: calculate 10th and 90th percentile
	APPROX_QUANTILES(age, 100)[OFFSET(10)] AS percentile_10,
	APPROX_QUANTILES(age, 100)[OFFSET(90)] AS percentile_90,
FROM table1
GROUP BY 
	profession
```

In BigQuery, there is also a window function `PERCENTILE_CONT`:

```sql
WITH table1 AS (
	SELECT 'Carpenter' AS profession, 70 AS age UNION ALL
	SELECT 'Carpenter', 50 UNION ALL
  SELECT 'Carpenter', 65 UNION ALL
  SELECT 'Carpenter', 45 UNION ALL
  SELECT 'Programmer', 30 UNION ALL
  SELECT 'Programmer', 35 UNION ALL
  SELECT 'Programmer', 20 UNION ALL
  SELECT 'Programmer', 25 
)
SELECT
  profession, 
  age, 
  PERCENTILE_CONT(age, 0.95) OVER() AS p95_overall,
  PERCENTILE_CONT(age, 0.95) OVER(PARTITION BY profession) AS p95_per_profession
FROM table1
```


**PostgreSQL**

```sql
WITH table1 AS (
	SELECT 'Carpenter' AS profession, 70 AS age
	UNION ALL
	SELECT 'Carpenter' AS profession, 50 AS age
	UNION ALL
	SELECT 'Carpenter' AS profession, 65 AS age
	UNION ALL
	SELECT 'Carpenter' AS profession, 45 AS age
	UNION ALL
	SELECT 'Programmer' AS profession, 30 AS age
	UNION ALL
	SELECT 'Programmer' AS profession, 35 AS age
	UNION ALL
	SELECT 'Programmer' AS profession, 20 AS age
	UNION ALL
	SELECT 'Programmer' AS profession, 25 AS age
)
SELECT 
	profession,
	MIN(age) AS min_age,
	AVG(age) AS mean_age,
	percentile_disc(0.1) WITHIN GROUP(ORDER BY age) AS percentile_10_disc,
	percentile_disc(0.5) WITHIN GROUP(ORDER BY age) AS percentile_50_disc,
	percentile_disc(0.9) WITHIN GROUP(ORDER BY age) AS percentile_90_disc,
	percentile_cont(0.1) WITHIN GROUP(ORDER BY age) AS percentile_10_cont,
	percentile_cont(0.5) WITHIN GROUP(ORDER BY age) AS percentile_50_cont,
	percentile_cont(0.9) WITHIN GROUP(ORDER BY age) AS percentile_90_cont
FROM table1
GROUP BY 
	profession
```

#### Outliers handling

##### Quantiles

**BigQuery**

```sql
-- Outlier handling based on 5th and 95th quantile
WITH t_temp AS (
	SELECT 'Carpenter' AS profession, 70 AS age UNION ALL
	SELECT 'Carpenter', 50 UNION ALL
  SELECT 'Carpenter', 65 UNION ALL
  SELECT 'Carpenter', 45 UNION ALL
  SELECT 'Programmer', 30 UNION ALL
  SELECT 'Programmer', 35 UNION ALL
  SELECT 'Programmer', 20 UNION ALL
  SELECT 'Programmer', 25 
),

t_percentile AS (
  SELECT 
    *,
    PERCENTILE_CONT(age, 0.95) OVER(PARTITION BY profession) AS percentile_95,
    PERCENTILE_CONT(age, 0.05) OVER(PARTITION BY profession) AS percentile_5
  FROM t_temp
)

SELECT
  * EXCEPT (percentile_95, percentile_5)
FROM t_percentile
WHERE
  age > percentile_5
  AND age < percentile_95
/* It just removes ages 70 and 45 from `Carpenter`
and 20 and 35 from `Programmer`
*/
```

However, the problem with using quantiles for removing outliers is that it will remove any values from top and bottom, even if they are actually very close: 
```sql
WITH t_temp AS (
	SELECT 'Carpenter' AS profession, 1 AS age UNION ALL
	SELECT 'Carpenter', 2 UNION ALL
  SELECT 'Carpenter', 3 UNION ALL
  SELECT 'Carpenter', 4 UNION ALL
  SELECT 'Programmer', 10 UNION ALL
  SELECT 'Programmer', 11 UNION ALL
  SELECT 'Programmer', 12 UNION ALL
  SELECT 'Programmer', 13 
),

t_percentile AS (
  SELECT 
    *,
    PERCENTILE_CONT(age, 0.95) OVER(PARTITION BY profession) AS percentile_95,
    PERCENTILE_CONT(age, 0.05) OVER(PARTITION BY profession) AS percentile_5
  FROM t_temp
)

SELECT
  * EXCEPT (percentile_95, percentile_5)
FROM t_percentile
WHERE
  age > percentile_5
  AND age < percentile_95
-- this will remove rows with ages 1 and 4 from `Carpenter`
-- and rows with ages 10 and 13 from `Programmer`
```

##### Z-score

```sql
WITH data1 AS (
	SELECT 1 category, 'protein' nutrient, 3 value
	UNION ALL 
	SELECT 1, 'protein', 5
	UNION ALL 
	SELECT 1, 'protein', 19
	UNION ALL 
	SELECT 1, 'protein', 9
	UNION ALL 
	SELECT 1, 'protein', 100
	UNION ALL 
	SELECT 1, 'fat', 7
	UNION ALL
	SELECT 1, 'fat', 8
	UNION ALL
	SELECT 1, 'fat', 9
	UNION ALL
	SELECT 1, 'fat', 39
	UNION ALL
	SELECT 1, 'fat', 2
	UNION ALL
	SELECT 2, 'protein', 15
	UNION ALL
	SELECT 2, 'protein', 10
	UNION ALL
	SELECT 2, 'protein', 1000
	UNION ALL
	SELECT 2, 'fat', 14
	UNION ALL
	SELECT 2, 'fat', 19
), 

intermediate_calc AS (
	SELECT
		category,
		nutrient,
		value,
		AVG(value) OVER (PARTITION BY category, nutrient) AS mu,
		COUNT(value) OVER (PARTITION BY category, nutrient) AS n,
		(value - AVG(value) OVER (PARTITION BY category, nutrient))
			* (value - AVG(value) OVER (PARTITION BY category, nutrient))
			AS x_minus_mu_squared
	FROM data1
),

calculate_sigma AS (
	SELECT
		category,
		nutrient,
		value,
		mu,
		n, 
		SQRT(SUM(x_minus_mu_squared) OVER (PARTITION BY category, nutrient) / n) AS sigma
	FROM intermediate_calc
)

SELECT
	category,
	nutrient,
	(value - mu) / sigma AS zscore
FROM calculate_sigma
ORDER BY category ASC, nutrient ASC
```


## FROM

> The **FROM** clause defines the tables used by a query, along with the means of linking the tables together

To see which types of tables you can use in your FROM clause, see the `Types of tables` section.

## WHERE

The WHERE clause is used in a SELECT statement to filter rows based on the specified *filter conditions / statements* before the data is grouped or aggregated. It operates on individual rows and filters them based on the given conditions.

- WHERE clause can have multiple filter conditions separated by the operators `AND` or `OR`

`WHERE salary IS NOT NULL`

```sql
-- OR condition
WHERE 
  column1 != 2 
  OR column2 IS NULL
--
WHERE 
  (surname = 'Jones' AND age > 17)
  OR (surname = 'Wilkinson' AND age > 50)

-- IS
age IS NOT NULL

-- IN
-- values are in a list
column1 IN ('Value1', 'Value2', 'Value3') -- or NOT IN


-- BETWEEN (PostgreSQL, MySQL)
-- Inclusive between <lower limit> and <upper limit>; >= lower_limit AND <= upper_limit
age BETWEEN 25 AND 30
-- Values between two dates
date BETWEEN '1999-01-01' AND '2015-01-01' -- between 1991-01-01 00:00:00 (midnight) and 2015-01-01 00:00:00 (midnight)
-- Values alphabetically between two strings
column1 BETWEEN 'Alpha' AND 'Beta'
-- Include names like 'FARNELL', 'FENNEL', 'FRANKLIN', 'FRAZIER'
column1 BETWEEN 'FA' and 'FRB' -- if you put 'FR' instead of 'FRB', it won't include 'FRANKLIN' and 'FRAZIER'

-- Odd number
MOD(columnName, 2) <> 0
-- Even number
MOD(columnName, 2) = 0
```

### EXISTS

The `EXISTS` operator is used to test for the existence of any record in a subquery; returns TRUE if the subquery returns one or more records. 

Examples:

The following SQL statement returns TRUE and lists the suppliers with a product price less than 20:

```sql
WITH Products AS (
  SELECT 1 ProductID, 'Chais' ProductName, 1 SupplierID, 1 CategoryID, '10 boxes x 20 bags' Unit, 18 Price union all 
  select 2, 'Chang', 1, 1, '24 - 12 oz bottles', 19 union all 
  select 3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10 union all
  select 4, "Chef Anton's Cajun Seasoning", 2, 2, "48 - 6 oz jars", 22 union all 
  select 5, "Chef Anton's Gumbo Mix", 2, 2, "36 boxes", 21.35
),

Suppliers AS (
  select 1 SupplierId, 'Exotic Liquid' SupplierName, 'Charlotte Cooper' ContactName union all 
  select 2, 'New Orleans Cajun Delights', 'Shelley Burke'
)

-- Select suppliers with a product price less than 20
SELECT SupplierName
FROM Suppliers 
WHERE EXISTS (
  SELECT ProductName
  FROM Products 
  WHERE
    Products.SupplierID = Suppliers.supplierID
    AND Price < 20
);
-- [{
--   "SupplierName": "Exotic Liquid"
-- }]
```



## ORDER BY

> If you have multiple columns in your ORDER BY clause, the order in which columns appear there matter, as one row might appear before the other if you order by multiple columns in different order.

```sql
-- General form
SELECT column1, column2, ..., columnN
FROM table_name
ORDER BY 
  column1 [ASC|DESC], 
  column2 [ASC|DESC], 
  ... 
  columnN [ASC|DESC];

-- Examples
SELECT *
FROM employees
ORDER BY salary DESC, age DESC;

-- ORDER BY always comes after GROUP BY
SELECT 
  country, 
  COUNT(*) AS n_companies
FROM companies
GROUP BY country
ORDER BY n_companies DESC
LIMIT 10
```

You can also sort the columns using the **numeric placeholders**:
- It's useful when you are sorting on expressions
```sql
SELECT 
  name,
  surname,
  age,
  birthday
FROM person
ORDER BY 3 DESC; -- order the table using the third element in the SELECT clause
```

Please note that sort is case-sensitive, i.e. SORT BY will sort `amazon, Avon, Bangladesh` to `Avon, Bangladesh, amazon`, so all lowercase will be ordered after all uppercase. To prevent this, do this:
```sql
SELECT 
  col1, 
  col2
FROM temp1
ORDER BY LOWER(col1)
```


## OFFSET 

Skip $n$ rows.

> Note: for some reason, you can use OFFSET only after a LIMIT, but without LIMIT you can't use it

```sql
WITH temp1 AS (
  SELECT 0 index, 'A' letter
  UNION ALL
  SELECT 1 index, 'B' letter
  UNION ALL
  SELECT 2 index, 'C' letter
)
SELECT *
FROM temp1
LIMIT 10
OFFSET 2
```

## LIMIT

show n first rows.
