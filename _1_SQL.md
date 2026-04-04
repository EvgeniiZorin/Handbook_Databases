# SQL

# Operations

## Null Handling

### COALESCE vs IFNULL

The main difference between the two is that `IFNULL` function takes two arguments and returns the first one if it's not `NULL` or the second if the first one is `NULL`.

`COALESCE` function can take two or more parameters and returns the first non-`NULL` parameter, or `NULL` if all parameters are null, for example:

```sql
-- Source - https://stackoverflow.com/a/18528590
-- Posted by Aleks G, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-01-19, License - CC BY-SA 4.0

SELECT IFNULL('some value', 'some other value');
-> returns 'some value'

SELECT IFNULL(NULL,'some other value');
-> returns 'some other value'

SELECT COALESCE(NULL, 'some other value');
-> returns 'some other value' - equivalent of the IFNULL function

SELECT COALESCE(NULL, 'some value', 'some other value');
-> returns 'some value'

SELECT COALESCE(NULL, NULL, NULL, NULL, 'first non-null value');
-> returns 'first non-null value'
```

## Temp functions

Let's consider a simple example:

```sql
WITH temp1 AS (
  SELECT 'hello_20250501-and then the rest' textvalue union all 
  select 'asdfdd20250601asdfk'
),

temp2 AS (
  SELECT
    textvalue,
    CAST(SUBSTRING(textvalue, 7, 4) || '-' || SUBSTRING(textvalue, 11, 2) || '-' || SUBSTRING(textvalue, 13, 2) AS DATE) AS extracted_date
  FROM temp1
)

SELECT
  textvalue, 
  extracted_date,
  EXTRACT(YEAR FROM extracted_date) AS year,
  EXTRACT(MONTH FROM extracted_date) AS month,
  EXTRACT(DAY FROM extracted_date) AS day
FROM temp2
```

You could have written that super-long string operation as a temporary function. Please note that now there are two queries / transactions below:

```sql
CREATE TEMP FUNCTION extract_Custom_Date(x string) AS ((
  SELECT
    CAST(
      SUBSTRING(x, 7, 4) || '-' ||
      SUBSTRING(x, 11, 2) || '-' ||
      SUBSTRING(x, 13, 2)
    AS DATE)
));

WITH temp1 AS (
  SELECT 'hello_20250501-and then the rest' textvalue union all 
  select 'asdfdd20250601asdfk'
),

temp2 AS (
  SELECT
    textvalue,
    extract_Custom_Date(textvalue) AS extracted_date
  FROM temp1
)

SELECT
  textvalue, 
  extracted_date,
  EXTRACT(YEAR FROM extracted_date) AS year,
  EXTRACT(MONTH FROM extracted_date) AS month,
  EXTRACT(DAY FROM extracted_date) AS day
FROM temp2

```


# Conditional logic

## CASE WHEN

Creating a new column / field based on a condition for the other columns. 

> In SQL, conditional logic is executed by the `case` expression, which can be used in SELECT, INSERT, UPDATE, and DELETE statements.
> It is ANSI-SQL compliant, meaning it works everywhere - PostgreSQL, MySQL, BigQuery, etc., etc.

Features:
- In the CASE expression, the clauses are evaluated from top to bottom in order
- CASE expressions may return any type of expression, including subqueries; IOW, the CASE expression goes through conditions and returns a value when the first condition is met (so it's greedy)

**Types of CASE statements**:
1. Searched case expressions
   1. Can specify any condition - range, inequality, multipart conditions;
  ```sql
  CASE 
    WHEN category.name IN ('Children', 'Family', 'Sports', 'Animation') THEN 'All ages'
    WHEN category.name = 'Horror' THEN 'Adult'
    WHEN category.name IN ('Music', 'Games') THEN 'Teens'
    ELSE 'Other'
  END
  ```
1. Simple case expressions
   1. Less flexible than searched case expression
   2. Simpler 
   3. only supports one type of condition
  ```sql
  CASE category.name
    WHEN 'Children' THEN 'All ages'
    WHEN 'Family' THEN 'All ages'
    WHEN 'Sports' THEN 'All ages'
    WHEN 'Animation' THEN 'All ages'
    WHEN 'Horror' THEN 'Adult'
    WHEN 'Music' THEN 'Teens'
    WHEN 'Games' THEN 'Teens'
    ELSE 'Other'
  END
  ```

```sql
-- General view
CASE 
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  WHEN conditionN THEN resultN
  ELSE else_result
END AS alias;
```

Use cases:
- in pivot (see the pivot section)
- checking for existence

  Example 1:
  ```sql
  -- check whether an actor appeared in at least one G-rated film, boolean column for this check
  SELECT
    a.first_name,
    a.last_name,
    CASE
      -- correlated subquery for the WHEN EXIST statement
      WHEN EXISTS (SELECT 1 FROM film_actor fa
                  INNER JOIN film f ON fa.film_id = f.film_id 
                  WHERE fa.actor_id = a.actor_id AND f.rating = 'G')
        THEN 'Y'
      ELSE 'N' 
      END AS g_actor
  FROM actor a

  -- | first_name | last_name | g_actor | 
  -- | - | - | - |
  -- | Jack | Jones | Y |
  -- | Jill | Valentine | N |
  ```

  Example 2:
  ```sql
  -- case expression to count the number of copies in inventory for each film and then returns one of the statements
  SELECT
    f.title,
    CASE (SELECT COUNT(*) FROM inventory i WHERE i.film_id = f.film_id)
      WHEN 0 THEN 'Out of stock'
      WHEN 1 THEN 'Scarse'
      WHEN 2 THEN 'Scarse'
      ELSE 'Common'
    END AS film_availability
  FROM film f 
  ```
- Division by zero errors (alternatives - safe divide)

  ```sql
  SELECT SUM(p.amount) / CASE WHEN COUNT(p.amount) = 0 THEN 1 ELSE COUNT(p.amount) END AS avg_payment
  FROM payments AS p
  ```
- conditional updates
- handling null values (alternatives - COALESCE function)

  ```sql
  CASE WHEN value1 IS NULL THEN 'Unknown' ELSE value1
  ```

### in select

Here is an example where we create a new field that will detail if a student passed or failed, based on their scores:
```sql
SELECT 
  student_id, 
  student_name, 
  exam_score,
  CASE 
    WHEN exam_score >= 60 THEN 'Pass' 
    ELSE 'Fail' 
  END AS result
FROM students;
```

```sql
-- CASE WHEN can be used within a aggregate function
-- For example, take values where rating < 3 as 1 (otherwise, take as 0), and sum them - that counts how many ratings there are with a value of less than 3
SUM(case when rating < 3 then 1 else 0 end)

-- An example: multiply by -1 if another column says "Buy", else take the original value
SELECT stock_name, 
    CASE
        WHEN operation = 'Buy' THEN price * -1 
        ELSE price
        END AS capital_proc
    FROM Stocks
```

Another example of multiple filters:
```sql
SELECT 
	sex,
	count(*) AS count1,
	sum(is_married) AS count_married,
	sum(CASE WHEN e.birth_date > '1980-01-01' THEN 1 ELSE 0 END) AS count_older_1980,
	sum(CASE WHEN e.birth_date < '1970-01-01' THEN 1 ELSE 0 END) AS count_younger_1970
FROM employee e
INNER JOIN newtable nt
ON e.emp_id = nt.emp_id 
GROUP BY sex
```

Can use CASE WHEN for handling null values
```sql
CASE WHEN a.address IS NULL THEN 'unknown' ELSE a.address END address
```

### in update

> conditional updates

```sql
-- A script that runs every week that sets the `customer.active` column to 0 for any customers who haven't rented a film in the last 90 days
UPDATE customer
SET active = 
  CASE
    WHEN (SELECT datediff(now(), max(rental_date))
          FROM rental r
          WHERE r.customer_id = customer.customer_id) >= 90
    THEN 0
    ELSE 1
    END
WHERE active = 1;
```

## IF

`IF()` is not part of ANSI SQL, meaning that it only exists in certain engines like:
- MySQL
- MariaDB
- BigQuery

Note: compared to `CASE WHEN`, it has advantages and disadvantages:
- ✅ very convenient and readable for simple, binary condition
- ❌ Only supports two outputs (no multi-branch logic)
- ❌ Therefore, not very readable for complex logic

BigQuery:
```sql
IF(condition, value_if_true, value_if_false)

SELECT
    product,
    IF(price > 100, 'premium', 'budget') AS price_band
FROM products;
```




# Trigger

Defines a certain action when a certain operation is performed on a database. 

```sql
-- Run this in the MySQL terminal
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee'); -- `VALUES(NEW.attribute_name)` if you want to add attribute of the newly-inserted row  
    END$$
DELIMITER ;
-- Now, every time a row is added to the table `employee`, a row is added into the table `trigger_test` saying `added new employee`
```

# IF conditions

```sql
# From table 'Employee', calculate bonus for each employee_id. 
# Bonus = 100% salary (if ID is odd and employee name doesn't start with 'M'), else bonus = 0. 
## Solution 1
SELECT employee_id, CASE WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%' THEN salary ELSE 0 END AS bonus FROM Employees;
## Solution 2
SELECT employee_id, if(employee_id % 2 = 1 AND name NOT LIKE 'M%', salary, 0) AS bonus FROM Employees;
```


# Joins

JOIN is a command for linking rows from two or more tables based on a column common for all of them, using the subclause `ON`.
- Common joins: `INNER`, `LEFT`
- Less common: `FULL OUTER`
- Joins you should use very rarely: `RIGHT`, `CROSS`
- By default, writing `JOIN` defaults to `INNER JOIN`


| Type | Explanation |
| - | - |
| Inner Join | Returns records with matching values in both tables. |
| Left (outer) join | Returns all records from the left table and the matched records (or NULL for non-matched records) from the right table. |
| Right (outer) join | The opposite of left outer join. |
| Full (outer) joint | Returns all records, with non-matching records having NULL. |

When you join and you reference tables outside the `from` clause, you either use the entire table names or you alias for each table (with or without `AS` keyword).

There are two main categories of joins:
- **INNER JOIN**: will only retain the data from the two tables that is related to each other (that is present in both tables, like an overlap of the Venn diagram);
- **OUTER JOIN**: will additionally retain the data that is not related from one table to the other; iow, combines values from the two tables, even those with NULL values.

General form:
```sql
SELECT * FROM table1 -- or SELECT table1.id, table2.id2
JOIN table2 ON table1.id = table2.id;
```

In your ON statement, you can also join based on ranges:
```sql

WITH 
Prices AS (
	SELECT 1 product_id, '2019-02-17'::date start_date, '2019-02-28'::date end_date, 5 price
	UNION ALL
	SELECT 1 product_id, '2019-03-01'::date start_date, '2019-03-22'::date end_date, 20 price
	UNION ALL
	SELECT 2 product_id, '2019-02-01'::date start_date, '2019-02-20'::date end_date, 15 price
	UNION ALL
	SELECT 2 product_id, '2019-02-21'::date start_date, '2019-03-31'::date end_date, 30 price
),
UnitsSold AS (
	SELECT 1 product_id, '2019-02-25'::date purchase_date, 100 units
	UNION ALL
	SELECT 1 product_id, '2019-03-01'::date purchase_date, 15 units
	UNION ALL
	SELECT 2 product_id, '2019-02-10'::date purchase_date, 200 units
	UNION ALL
	SELECT 2 product_id, '2019-03-22'::date purchase_date, 30 units
)
SELECT *
FROM Prices AS p
INNER JOIN UnitsSold AS us
	ON p.start_date < us.purchase_date 
	AND us.purchase_date < p.end_date
```

You can also combine JOIN and WHERE operations:
```sql
SELECT column_list
FROM table1
JOIN table2 ON table1.column_name = table2.column_name
WHERE condition;
```


---

<img src="Media/joins.png" width=800>

Now let's consider two tables and how they can be joined on the `student_id` column:

Table `student`:
| student_id |     name     | age|
|:----|:----|:----|
|          1 | John Stramer |  50|
|          2 | John Wick    |  35|
|          3 | Jack Bauer   |  45|

Table `course`:
| course_id | student_id|
|:----|:----|
|         1 |          1|
|         1 |          2|
|         2 |          1|
|         3 |         10|

> Notice that the join order doesn't matter, since SQL is a nonprocedural language

## ON...AND vs ON...WHERE

Let's say we have two tables:

```sql
SELECT * FROM A
```

| id | val |
| - | - |
| 1 | A |
| 2 | B |
| 3 | C |

```sql
SELECT * FROM B
```

| id | val |
| - | - |
| 1 | A | 
| 2 | B |
| 3 | B |
| 4 | A |

You can join them with two different ways:

**We do additional filter in the ON statement with AND - filter is happening BEFORE the join, in the individual table**

```sql
SELECT *
FROM A
LEFT JOIN B
ON
  A.id = B.id
  AND B.val = 'A'
```

We get:

| A.id | A.val | B.id | B.val |
| - | - | - | - |
| 1 | A | 1 | A | 
| 2 | B | NULL | NULL |
| 3 | C | NULL | NULL |

**We do additional filter in the WHERE statement - filter is happening AFTER the join, in the resulting joined table**

```sql
SELECT *
FROM A
LEFT JOIN B
ON
  A.id = B.id
WHERE B.val = 'A'
```

We get:

| A.id | A.val | B.id | B.val |
| - | - | - | - |
| 1 | A | 1 | A |

---

You can also use joins for an advanced case like this:

![alt text](image-2.png)

```sql
SELECT 
  p.PROD_CAT,
  COALESCE(SUM(s.PRICE * s.CNT), 0) AS TOTAL_AMT
FROM public.product1 AS p
LEFT JOIN public.sale1 AS s 
ON 
  p.PROD_NM = s.PROD_NM
  AND s.SALE_DT BETWEEN p.EFF_DT AND p.EXP_DT
GROUP BY p.PROD_CAT
```

## ON vs USING

> Subclause `ON`

There are two clauses for joining - ON and USING:

**ON**

the ON clause is the most general: `ON t1.a = t2.a`, `ON t1.a = t2.b AND t1.b = t2.b`

```sql
SELECT 
  post.post_id,
  title,
  review
FROM post
INNER JOIN post_comment 
  ON post.post_id = post_comment.post_id
ORDER BY post.post_id, post_comment_id
```

**USING**

if a column used for join has the same name, USING can be used where you don't specify the table it is coming from;

the USING clause: shorthand form: `USING a`, `USING (a, b)` - where if you are joining on multiple columns you just write them in a tuple where each element is separated by a coma

USING -any columns mentioned in the USING list will appear in the joined list only once with an unqualified name

```sql
SELECT
  post_id,
  title,
  review
FROM post
INNER JOIN post_comment 
  USING(post_id) -- can also write as: USING (post_id)
ORDER BY post_id, post_comment_id
```

## Inner join

> `INNER JOIN` can also be written as `JOIN`

Intersection of two tables, meaning all rows that exist for both. 

<img src="Media/inner_join.png" alt="inner joins" width="300">

Command:
```sql
SELECT * 
FROM student 
INNER JOIN course 
ON student.student_id = course.student_id;
```
Output:
| student_id |     name     | age | course_id | student_id|
|:----|:----|:----|:----|:----|
|          1 | John Stramer |  50 |         1 |          1|
|          2 | John Wick    |  35 |         1 |          2|
|          1 | John Stramer |  50 |         2 |          1|

> `\x` - toggle expanded display. 

Another example of joining two tables:
```txt
table1
| id | val |
| -  | -   |
| 1  | A |
| null | B |
| 1 | C | 
| 2 | D |

table2
| id | val |
| - | - |
| 1 | A |
| null | B |
| 1 | C |

inner join of these tables:
| id | table1.val | table2.val |
| - | - | - |
| 1 | A | A |
| 1 | A | C |
| 1 | C | A |
| 1 | C | C |
```

An unusual (older) way to write an inner join:
```sql
SELECT
  c.first_name,
  c.last_name,
  a.address
FROM customer c, address a
WHERE c.address_id = a.address_id
```

## Left (outer) join

Will keep the unrelated data from the left (the first) table. Left join gets all rows from the left table, but from the right table - only rows that are linked to those of the table on the left. Missing data from the right table will have NULL values. 

<img src="Media/left_outer_join.png" alt="left (outer) join" width="300">

> can be written as LEFT JOIN, LEFT OUTER JOIN
>
> the keyword "LEFT" indicates that the table on the left side of the join is responsible for determining the number of rows in the result set, whereas the table on the right side is used to provide column values whenever a match is found

Command:
```sql
SELECT * 
FROM student 
LEFT JOIN course 
ON student.student_id = course.student_id;
```
Output:
| student_id |     name     | age | course_id | student_id|
|:----       |:----         |:----|:----      |:----      |
|          1 | John Stramer |  50 |         1 |          1|
|          2 | John Wick    |  35 |         1 |          2|
|          1 | John Stramer |  50 |         2 |          1|
|          3 | Jack Bauer   |  45 |      NULL |      NULL |


More examples:
```sql
select * from a LEFT OUTER JOIN b on a.a = b.b;
-- Only show entries that don't have a car
SELECT * FROM person LEFT JOIN car ON car.id = person.car_id WHERE car.* IS NULL;
```

> Note: we can change the join type from LEFT JOIN to RIGHT JOIN and vise versa as long as we also change the order of the tables
>
> For example, these two statements return the same result:
>
> SELECT o.OrderId, o.OrderDate, c.CustomerId, c.FirstName, c.LastName, c.Country
> FROM Customers c
> LEFT JOIN Orders o ON c.CustomerId = o.CustomerId;
>
> and
>
> SELECT o.OrderId, o.OrderDate, c.CustomerId, c.FirstName, c.LastName, c.Country
> FROM Orders o
> RIGHT JOIN Customers c ON o.CustomerId = c.CustomerId

An example of a three-way left outer join:
```sql
WITH film AS (
  SELECT 1 film_id, 'ROCKY' title union all 
  select 2 film_id, 'JAWS' title union all 
  select 3, 'SPEED'
),

inventory AS (
  select 1 film_id, 10 inventory_id union all 
  select 1 film_id, 11 inventory_id union all 
  select 2, 12
),

rental AS (
  select 10 inventory_id, '2025-01-01' rental_date union all 
  select 10, '2025-05-01' union all 
  select 11, '2025-02-01'
)

select
  f.film_id,
  f.title,
  i.inventory_id,
  r.rental_date
FROM film f
LEFT JOIN inventory i 
  ON f.film_id = i.film_id 
LEFT JOIN rental r 
  ON i.inventory_id = r.inventory_id 

-- +---------+-------+--------------+-------------+
-- | film_id | title | inventory_id | rental_date |
-- +---------+-------+--------------+-------------+
-- |       1 | ROCKY |           10 | 2025-01-01  |
-- |       1 | ROCKY |           10 | 2025-05-01  |
-- |       1 | ROCKY |           11 | 2025-02-01  |
-- |       2 | JAWS  |           12 | NULL        |
-- |       3 | SPEED |         NULL | NULL        |
-- +---------+-------+--------------+-------------+
```

## Right (outer) join

All rows from the second / right table + the rows that match the rows from the second table .

> Right joins are much more rare than left joins and are not supported in every database server, so it's preferable to use left joins.

<img src="Media/right_outer_join.png" alt="right (outer) join" width="300">

Command:
```sql
SELECT * FROM student RIGHT JOIN course ON student.stu
dent_id = course.student_id;
```
Output:
| student_id |     name     | age | course_id | student_id|
|:----|:----|:----|:----|:----|
|          1 | John Stramer |  50 |         1 |          1|
|          2 | John Wick    |  35 |         1 |          2|
|          1 | John Stramer |  50 |         2 |          1|
|       NULL |       NULL   | NULL|         3 |         10|


## Full (outer) join

> `FULL OUTER JOIN` can also be written as `FULL JOIN`

Combine all values from the two tables, including those with NULL values. 

<img src="Media/full_outer_join.png" alt="full (outer) join" width="300">

Command:
```sql
SELECT * FROM student FULL JOIN course ON student.student_id = course.student_id;
```
Output:
| student_id |     name     | age | course_id | student_id|
|:----|:----|:----|:----|:----|
|          1 | John Stramer |  50 |         1 |          1|
|          2 | John Wick    |  35 |         1 |          2|
|          1 | John Stramer |  50 |         2 |          1|
|       NULL | NULL         | NULL|         3 |         10|
|          3 | Jack Bauer   |  45 |      NULL | NULL      |


More examples:
```sql
select * from a FULL OUTER JOIN b on a.a = b.b;

SELECT * FROM table1 FULL JOIN table2 ON table1.id = table2.char_id; 
```
Or, if the column has the same name:
```sql
SELECT * FROM table1 JOIN table2 USING (id_name)
```

```sql
-- We have two tables with primary and foreign key "employee_id", and we want to show ids that are not used for inner join (because they are not in both tables)
SELECT absent_in_one AS employee_id 
FROM (
    SELECT
    CASE 
    WHEN e_emp_id IS NULL THEN s_emp_id
    WHEN s_emp_id IS NULL THEN e_emp_id
    ELSE NULL
    END AS absent_in_one
    FROM (
        SELECT e.employee_id AS e_emp_id, e.name AS e_name, s.employee_id AS s_emp_id, s.salary AS s_salary
        FROM Employees e
        FULL JOIN Salaries s
        ON e.employee_id = s.employee_id
    )
)
WHERE absent_in_one IS NOT NULL
```

Or if we want to joint three tables:
```sql
SELECT columns FROM junction_table
FULL JOIN table_1 ON junction_table.foreign_key_column = table_1.primary_key_column
FULL JOIN table_2 ON junction_table.foreign_key_column = table_2.primary_key_column;
```

## Multi-table joins

Example:
```sql
-- example 1
SELECT c.CustomerName, o.OrderDate, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Products p ON o.ProductID = p.ProductID;

-- example 2
SELECT c.CustomerName, o.OrderDate, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Products p ON o.ProductID = p.ProductID;
```

The join order does not matter! All the variations below will return the same result, but thw rows might be in different order:
```sql
SELECT 
  c.first_name,
  c.last_name,
  ct.city

-- variation 1
FROM customer c
INNER JOIN address a
  ON c.address_id = a.address_id
INNER JOIN city ct
  ON a.city_id = ct.city_id

-- variation 2
FROM city ct
INNER JOIN address a
  ON a.city_id = ct.city_id
INNER JOIN customer c
  ON c.address_id = a.address_id

-- variation 3
FROM address a
INNER JOIN city ct
  ON a.city_id = ct.city_id
INNER JOIN customer c
  ON c.address_id = a.address_id
```

## Self join

Joining a table with itself. Can utilise inner, left, right, or full outer joins. 

Why?
- Some tables might include a self-referencing foreign key, which means that it includes a column that points to the primary key within the same table

For example, let's consider the following table. 
| id | name  | salary | managerId |
| -- | ----- | ------ | --------- |
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | null      |
| 4  | Max   | 90000  | null      |

We can join each employee with their manager:
| employee_name | employee_salary | manager_name | manager_salary |
| ------------- | --------------- | ------------ | -------------- |
| Joe           | 70000           | Sam          | 60000          |
| Henry         | 80000           | Max          | 90000          |

This can be done by using the following command:
```sql
SELECT 
  e1.name AS employee_name, 
  e1.salary AS employee_salary, 
  e2.name AS manager_name, 
  e2.salary AS manager_salary
FROM Employee e1
INNER JOIN Employee e2 
-- using self-referencing foreign key managerId
ON e1.managerId = e2.id
```

Another example - return all addresses that are in the same city:
```sql
SELECT 
	a1.address AS address1,
	a2.address AS address2,
	a1.city_id 
FROM address AS a1
INNER JOIN address AS a2
	ON a1.city_id = a2.city_id
-- here you use `<` to prevent duplication. If you use `<>` instead, you will get duplication like addressA, addressB, same city and addressB, addressA, same city
WHERE a1.address < a2.address;
```

## Cross join
 
Cartesian product (a.k.a. cross join) is when you join two tables without specifying how to join them, which generates every permutation of the two tables. 

> This join type is used rarely

You can write `CROSS JOIN` in two ways:
```sql
-- method 1
SELECT *
FROM table1
CROSS JOIN table2

-- method 2
SELECT *
FROM table1, table2
```

For example, in this case you join two tables without specifying a condition:
- `SELECT COUNT(*) FROM customer` - $599$ rows
- `SELECT COUNT(*) FROM payment` - $16044$ rows
- `SELECT COUNT(*) FROM customer CROSS JOIN payment` - $599 * 16044 = 9610356$ rows

A more visual example:
```sql
WITH table1 AS (
	SELECT 'John' AS name, 'Wayne' AS surname
	UNION ALL
	SELECT 'Bruce' AS name, 'Willis' AS surname
	UNION ALL
	SELECT 'Jack' AS name, 'The Ripper' AS surname
),
table2 AS (
	SELECT 'Carpenter' AS profession
	UNION ALL
	SELECT 'Movie Star' AS profession
	UNION ALL
	SELECT 'Data Scientist' AS profession
)
SELECT * FROM table1
CROSS JOIN table2

-- Output:
-- name |surname   |profession    |
-- -----+----------+--------------+
-- John |Wayne     |Carpenter     |
-- John |Wayne     |Movie Star    |
-- John |Wayne     |Data Scientist|
-- Bruce|Willis    |Carpenter     |
-- Bruce|Willis    |Movie Star    |
-- Bruce|Willis    |Data Scientist|
-- Jack |The Ripper|Carpenter     |
-- Jack |The Ripper|Movie Star    |
-- Jack |The Ripper|Data Scientist|
```

```sql
SELECT * FROM customer INNER JOIN payment;
-- can also be written as:
SELECT * FROM customer CROSS JOIN payment;
-- or
SELECT * FROM customer, payment;

-- an example: a CROSS JOIN below behaves just like a normal INNER JOIN. So the two statements below are equivalent:
SELECT * FROM customer c CROSS JOIN payment p WHERE c.customer_id = p.customer_id
SELECT * FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id
```

```sql
-- Identify all cases where an actor named Monroe appeared in a PG film
-- (All of the queries below result in the same output)
-- var 1
SELECT 
  actor_id, 
  film_id
FROM film_actor
WHERE (actor_id, film_id) IN (
  SELECT
    a.actor_id,
    f.film_id
  FROM actor a
  CROSS JOIN film f
  WHERE 
    a.last_name = 'MONROE'
    AND f.rating = 'PG'
);

-- var2
SELECT 
	fa.actor_id,
	fa.film_id
FROM film_actor fa 
INNER JOIN actor a 
ON fa.actor_id = a.actor_id 
INNER JOIN film f
ON fa.film_id = f.film_id 
WHERE 
	a.last_name = 'MONROE'
	AND f.rating = 'PG';

-- var3
SELECT 
  fa.actor_id, 
  fa.film_id
FROM film_actor fa
WHERE 
  fa.actor_id IN (SELECT actor_id FROM actor WHERE last_name = 'MONROE')
  AND fa.film_id IN (SELECT film_id FROM film WHERE rating='PG');
```

> When CROSS JOIN is used with a WHERE clause, it behaves like INNER JOIN, filtering the results based on specific conditions

## Natural join

> This join type sucks and should be avoided

Join where the columns on which to join are determined automatically using the identical names of the columns in the tables to be joined.

```sql
SELECT 
  c.first_name, c.last_name, date(r.rental_date)
FROM customer c
NATURAL JOIN rental r
```

## Regex join

```sql
WITH temp1 AS (
  SELECT 1 id, 'hello we are opening our stores' textvalue union all
  select 20 id, 'this product is vegetarian' union all 
  select 30 id, 'this product is not suitable for vegetarians at all' union all 
  select 4 id, 'this product contains cannabis in itself.' union all
  select 40 id, 'the product has cannabis oil in its ingredients list.'
),
keywords AS (
  SELECT 'vegetarian' keyword union all 
  select 'cannabis oil' 
)

select *
from temp1 AS tp
INNER JOIN keywords AS kw 
  ON REGEXP_CONTAINS(
    LOWER(tp.textvalue),
    LOWER(
      CONCAT('\\b', kw.keyword, '\\b')
    )
  )

-- note that it doesn't match "vegetarians" in sentence id 30 because
-- it is matching keywords surrounded by the word boundary \b

-- [{
--   "id": "20",
--   "textvalue": "this product is vegetarian",
--   "keyword": "vegetarian"
-- }, {
--   "id": "40",
--   "textvalue": "the product has cannabis oil in its ingredients list.",
--   "keyword": "cannabis oil"
-- }]
```

You can also create custom logic for joining, for example:
- Regex join based on inclusion keywords;
- However, if a exclusion keyword is also matched for the same item for the same match_group, then exclude that matched match_group for that item

```sql
WITH temp1 AS (
  SELECT 1  id, 'hello we are opening our stores' textvalue union all
  select 20 id, 'this product is vegetarian' union all 
  select 3  id, 'this product is not suitable for vegetarians at all' union all 
  select 4  id, 'this product contains cannabis in itself.' union all
  select 40 id, 'the product has cannabis oil in its ingredients list.' union all 
  select 5  id, 'this product is not vegetarian as it contains meat'
),
keywords AS (
  SELECT 'DIET' match_group, 'vegetarian' keyword, 'include' match_type union all 
  select 'DIET' match_group, 'cannabis oil',       'include' union all 
  select 'DIET' match_group, 'meat',               'exclude'
)

SELECT
  temp1.id,
  temp1.textvalue,
  k.match_group,
  ARRAY_AGG(DISTINCT k.keyword ORDER BY k.keyword) AS keywords_matches
FROM temp1
INNER JOIN keywords AS k
  ON REGEXP_CONTAINS(
    LOWER(temp1.textvalue),
    LOWER(CONCAT('\\b', k.keyword, '\\b'))
  )
WHERE
  k.match_type = 'include'
  AND NOT EXISTS (
    SELECT 1
    FROM keywords AS k_exc
    WHERE
      k_exc.match_type = 'exclude'
      AND k_exc.match_group = k.match_group
      AND REGEXP_CONTAINS(
        LOWER(temp1.textvalue),
        LOWER(CONCAT('\\b', k_exc.keyword, '\\b'))
      )
  )
GROUP BY 1, 2, 3
-- in this example below, inclusion keyword matched id 5 on vegetarian, 
-- however, it also matched on exclusion keyword "meat" for the same match_group, therefore, 
-- we excluded that row from being in the match_group

-- [{
--   "id": "20",
--   "textvalue": "this product is vegetarian",
--   "match_group": "DIET",
--   "keywords_matches": ["vegetarian"]
-- }, {
--   "id": "40",
--   "textvalue": "the product has cannabis oil in its ingredients list.",
--   "match_group": "DIET",
--   "keywords_matches": ["cannabis oil"]
-- }]
```

# MATCH INTO

General syntax:

```sql
MERGE INTO TargetTable AS T
USING SourceTable AS S
    ON (T.ID = S.ID) -- Condition to match rows

WHEN MATCHED THEN
    UPDATE SET T.Name = S.Name -- Action if rows match

WHEN NOT MATCHED [ BY TARGET ] THEN
    INSERT (ID, Name) VALUES (S.ID, S.Name) -- Action if no match in target

[ WHEN NOT MATCHED BY SOURCE THEN
    DELETE -- Action if no match in source (optional, use with caution)
]; -- Semicolon is required in SQL Server
```

Here is an example. For some reason, you can't do `MERGE` with two CTEs, so I had to create some tables:

```sql
CREATE TABLE `info_table` (
  id INT64,
  name STRING,
  type STRING,
  char_name STRING,
  class STRING
);

INSERT INTO `info_table` (id, name, type, char_name, class)
VALUES 
  (1, 'abc',  'normal', 'jerry', 'mage'),
  (2, 'abcd', 'normal', 'tom',   'warrior'),
  (3, 'dak',  'match',  'kerry', 'druid');

CREATE TABLE `info_table_override` (
  id INT64,
  name STRING,
  class STRING
);

INSERT INTO `info_table_override` (id, name, class)
VALUES 
  (1, 'abc', 'UPDATED MAGE'),
  (2, 'abcd', 'UPDATED WARRIOR');

MERGE `info_table` AS it
USING `info_table_override` AS ito
ON it.id = ito.id
AND it.name = ito.name
WHEN MATCHED THEN
  UPDATE SET
    it.class = ito.class,
    it.type = 'override';

-- as a result, you get an updated table in `info_table` like this
-- id name  type     char_name class
-- -----------------------------------------------
-- 2	 abcd	 override tom       UPDATED WARRIOR
-- 1	 abc   override jerry     UPDATED MAGE
-- 3	 dak   match    kerry     druid
```



# Pivot

## Wide -> long (unpivot)

There are different solutions for this.

### UNPIVOT

- Works in BigQuery

```sql
WITH temp1 AS (
  SELECT 1 ID, 25 age, 50000 compensation, 3 years_experience
  union all
  select 2 ID, 33 age, 61000 compensation, 5 years_experience 
)

SELECT
    ID,
    VariableType,
    VariableValue
FROM
    temp1
UNPIVOT
    (VariableValue FOR VariableType IN (age, compensation, years_experience)) AS UnpivotedData;

-- result
-- | ID | VariableType     | VariableValue |
-- | -- | ---------------- | ------------- |
-- | 1  | age              | 25            |
-- | 1  | compensation     | 50000         |
-- | 1  | years_experience | 3             |
-- | 2  | age              | 33            |
-- | 2  | compensation     | 61000         |
-- | 2  | years_experience | 5             |
```

### UNION ALL

- A more compatible solution

**Example 1**

```txt
From table: 
| name | sport | color | bonus |
| - | - | - | - |
| name1 | basketball | green | 10 |
| name2 | voleyball | red | 5 |

To table:
| name | category | value |
| - | - | - |
| name1 | sport | basketball | 
| name1 | color | green |
| name1 | bonus | 10 |
| name2 | sport | voleyball |
| name2 | color | red |
| name2 | bonus | 5 |
```

```sql
SELECT 
  name, 
  'sport' AS category, 
  sport AS value
FROM wideClient
UNION ALL 
SELECT 
  name, 
  'color' AS category, 
  color AS value
FROM wideClient
UNION ALL
SELECT 
  name, 
  'bonus' AS category, 
  bonus AS value 
FROM wideClient
```


## Long -> wide (pivot)

### Manual

Here you have to specify names of columns used for pivot.

**Example 1**

```txt
Input: 
Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+
Output: 
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+
```

Query:
```sql
SELECT
    id,
    MAX(CASE WHEN month='Jan' THEN revenue ELSE null END) AS Jan_Revenue,
    MAX(CASE WHEN month='Feb' THEN revenue ELSE null END) AS Feb_Revenue,
    MAX(CASE WHEN month='Mar' THEN revenue ELSE null END) AS Mar_Revenue,
    MAX(CASE WHEN month='Apr' THEN revenue ELSE null END) AS Apr_Revenue,
    MAX(CASE WHEN month='May' THEN revenue ELSE null END) AS May_Revenue,
    MAX(CASE WHEN month='Jun' THEN revenue ELSE null END) AS Jun_Revenue,
    MAX(CASE WHEN month='Jul' THEN revenue ELSE null END) AS Jul_Revenue,
    MAX(CASE WHEN month='Aug' THEN revenue ELSE null END) AS Aug_Revenue,
    MAX(CASE WHEN month='Sep' THEN revenue ELSE null END) AS Sep_Revenue,
    MAX(CASE WHEN month='Oct' THEN revenue ELSE null END) AS Oct_Revenue,
    MAX(CASE WHEN month='Nov' THEN revenue ELSE null END) AS Nov_Revenue,
    MAX(CASE WHEN month='Dec' THEN revenue ELSE null END) AS Dec_Revenue
FROM Department
GROUP BY id
ORDER BY id ASC
```

-------------------------------------------------------------------------------------------

Another example:
```sql
-- table `film`
-- title           |rating|
-- ----------------+------+
-- ACADEMY DINOSAUR|PG    |
-- ACE GOLDFINGER  |G     |
-- ADAPTATION HOLES|NC-17 |
-- AFFAIR PREJUDICE|G     |
-- AFRICAN EGG     |G     |
-- AGENT TRUMAN    |PG    |
-- AIRPLANE SIERRA |PG-13 |
-- AIRPORT POLLOCK |R     |
-- ALABAMA DEVIL   |PG-13 |
-- ALADDIN CALENDAR|NC-17 |

-- You can create a table like this:
SELECT
  rating,
  COUNT(*)
FROM film
GROUP BY rating;
-- rating|count(*)|
-- ------+--------+
-- PG    |     194|
-- G     |     178|
-- NC-17 |     210|
-- PG-13 |     223|
-- R     |     195|

-- If you wanted the same result but having a table with a single row and five columns (one for each rating):
SELECT 
	SUM(CASE WHEN film.rating = 'G' THEN 1 ELSE 0 END) AS 'G',
	SUM(CASE WHEN film.rating = 'PG' THEN 1 ELSE 0 END) AS 'PG',
	SUM(CASE WHEN film.rating = 'PG-13' THEN 1 ELSE 0 END) AS 'PG_13',
	SUM(CASE WHEN film.rating = 'R' THEN 1 ELSE 0 END) AS 'R',
	SUM(CASE WHEN film.rating = 'NC-17' THEN 1 ELSE 0 END) AS 'NC_17'
FROM film;
-- G  |PG |PG_13|R  |NC_17|
-- ---+---+-----+---+-----+
-- 178|194|  223|195|  210|
```

In MySQL, you can use the pivot clauses.

**Example 2**

```sql
-- | store | week | xcount |
-- | - | - | - |
-- | 101 | 1 | 138 |
-- | 101 | 2 | 282 |
-- | 102 | 1 | 96 |
-- | 102 | 2 | 18 |

-- BigQuery / MySQL solution
WITH temp1 AS (
  SELECT 101 AS store, 1 AS week, 138 AS xcount
  UNION ALL
  SELECT 101 AS store, 2 AS week, 282 AS xcount
  UNION ALL 
  SELECT 102 AS store, 1 AS week, 96 AS xcount
)
SELECT * 
FROM temp1
PIVOT (MAX(xcount) for week IN (1, 2, 3))

-- | store | _1 | _2 | _3 |
-- | - | - | - | - |
-- | 101 | 138 | 282 | NULL |
-- | 102 | 96 | 18 | NULL |
```

Another Example of pivot (can be used in BigQuery):

```sql
SELECT
  id,
  STRING_AGG(DISTINCT(IF(feature = "Iron", textvalue, NULL))) AS text_values_for_iron,
  STRING_AGG(DISTINCT(IF(feature = "Wood", textvalue, NULL))) AS text_values_for_wood,
  ... -- can repeat for many many classes
FROM table1
GROUP BY 1
```

### Automatic

```sql
WITH temp1 AS (
  SELECT 1 id, 2020 year, 100 price, 'gbp' unit union all 
  SELECT 1 id, 2020 year, 1000 price, 'gbp' unit union all
  select 1 id, 2021 year, 105 price, 'gbp' unit union all 
  select 1 id, 2022 year, 115 price, 'gbp' unit union all 
  SELECT 2 id, 2020 year, 200 price, 'gbp' unit union all 
  select 2 id, 2021 year, 205 price, 'gbp' unit union all 
  select 2 id, 2022 year, 215 price, 'gbp' unit union all 
  SELECT 3 id, 2020 year, 300 price, 'gbp' unit union all 
  select 3 id, 2021 year, 305 price, 'gbp' unit union all 
  select 3 id, 2022 year, 315 price, 'gbp' unit 
)

SELECT * 
FROM temp1
Pivot(MAX(price) AS price
FOR YEAR IN (2020, 2021, 2022, 2023))

-- [{
--   "id": "1",
--   "unit": "gbp",
--   "price_2020": "1000",
--   "price_2021": "105",
--   "price_2022": "115",
--   "price_2023": null
-- }, {
--   "id": "2",
--   "unit": "gbp",
--   "price_2020": "200",
--   "price_2021": "205",
--   "price_2022": "215",
--   "price_2023": null
-- }, {
--   "id": "3",
--   "unit": "gbp",
--   "price_2020": "300",
--   "price_2021": "305",
--   "price_2022": "315",
--   "price_2023": null
-- }]
```

# Export query to CSV

```sql
-- General form
\copy (SELECT ...) TO '/Users/Desktop/file.csv' DELIMITER ',' CSV HEADER;

-- Example
\copy (SELECT * FROM table1 WHERE first_name='Evgenii') TO '/Users/evgen/Desktop/query2.csv' DELIMITER ',' CSV HEADER;
```

# Procedures

In SQL, stored procedure is a set of statement(s) that perform some defined actions. We make stored procedures so that we can reuse statements that are used frequently. Below are the procedures for PostgreSQL.

Not sure if I can get a procedure to return information in a SELECT statement.

Check all procedures for postgreSQL
```sql
\df
```

Create a new procedure for PostgreSQL
```sql
CREATE PROCEDURE proc_1 ()
LANGUAGE SQL
AS $$
SELECT * FROM table1;
$$;
```

Run a procedure
```sql
CALL proc_1();
```

E.g. a procedure for inserting a new entry
```sql
# Create procedure
CREATE PROCEDURE proc_insertrecord 
(var1 VARCHAR(30), var2 VARCHAR(30), var3 INT) 
LANGUAGE SQL
AS $$ 
INSERT INTO table1 (first_name, gender, age) 
VALUES (var1, var2, var3); 
$$;

# Run procedure
CALL proc_insertRecord ('Isabel2', 'weird', 10);
```

Delete a procedure
```sql
DROP PROCEDURE proc_1;
```

# Transaction

A transaction is $N \ge 1$ queries to DB that either compelete successfully all together or are not completed at all (property of *atomicity*).

A SQL transaction is a sequence of $N \ge 1$ database operations / queries to DB that behave as a single unit of work. It ensures that multiple operations are executed in an atomic and consistent manner, which is crucial for maintaining database integrity. SQL transactions adhere to a set of principles known as ACID.

Primary statements used for managing SQL transactions:
- BEGIN TRANSACTION / START TRANSACTION
- COMMIT
- ROLLBACK


Example of a transaction: consider a bank database with two tables: Customers (customer_id, name, account_balance) and Transactions (transaction_id, transaction_amount, customer_id). To transfer a specific amount from one customer to another securely, you would use a SQL transaction as follows:
```sql
BEGIN TRANSACTION;
-- MySQL `START TRANSACTION;`

-- Reduce the balance of the sender
UPDATE Customers
SET account_balance = account_balance - 100
WHERE customer_id = 1;

-- Increase the balance of the receiver
UPDATE Customers
SET account_balance = account_balance + 100
WHERE customer_id = 2;

-- Insert a new entry into the Transactions table
INSERT INTO Transactions (transaction_amount, customer_id)
VALUES (-100, 1),
       (100, 2);

-- Check if the sender's balance is sufficient
IF (SELECT account_balance FROM Customers WHERE customer_id = 1) >= 0
    -- if true, make the changes permanent;
    COMMIT;
ELSE
    -- otherwise, ROLLBACK - undo all the changes done to the data since the beginning of this transaction
    ROLLBACK;

-- the end of the transaction is signalled by the COMMIT command
```

Another example - transfer $50 from account 123 to account 789:
```sql
-- Account:
-- account_id | avail_balance | last_activity_date  |
-- --------------------------------------------------
-- 123        | 500           | 2019-07-10 20:53:27 |
-- 789        | 75            | 2019-06-22 15:18:35 |

-- Transaction:
-- txn_id | txn_date   | account_id | txn_type_cd | amount |
-- ---------------------------------------------------------
-- 1001   | 2019-05-15 | 123        | C           | 500    |
-- 1002   | 2019-06-01 | 789        | C           | 75     |

START TRANSACTION;

UPDATE Account 
SET 
	avail_balance = avail_balance - 50, 
	last_activity_date = CURRENT_TIMESTAMP
WHERE 
	account_id = 123
;

INSERT INTO Transaction(txn_date, account_id, txn_type_cd, amount)
VALUES (CURDATE(), 123, 'D', 50)

UPDATE Account
SET
	avail_balance = avail_balance + 50,
	last_activity_date = CURRENT_TIMESTAMP 
WHERE 
	account_id = 789
;

INSERT INTO Transaction(txn_date, account_id, txn_type_cd, amount)
VALUES (CURDATE(), 789, 'C', 50)

COMMIT;
```

SQL transactions are crucial in various real-world scenarios that require multiple database operations to occur atomically and consistently. **Real-life examples**:
- **E-commerce**: When processing an order that includes billing, shipping, and updating the inventory, it is essential to execute these actions as a single transaction to ensure data consistency and avoid potential double bookings, incorrect inventory updates, or incomplete order processing.
- **Banking and financial systems**: Managing accounts, deposits, withdrawals, and transfers require transactions for ensuring data integrity and consistency while updating account balances and maintaining audit trails of all transactions. For example, it would be a bad idea if you could withdraw 500 usd from your account, but it would fail at a later stage and would never get transfer to another account.
- **Reservation systems**: For booking tickets or accommodations, the availability of the seats or rooms must be checked, confirmed, and updated in the system. Transactions are necessary for this process to prevent overbooking or incorrect reservations.
- **User registration and authentication**: While creating user accounts, it is vital to ensure that the account information is saved securely to the correct tables and without duplicates. Transactions can ensure atomicity and isolation of account data operations.

**Potential issues with SQL transactions**:
- **Isolation problems**:
  - Dirty reads - where a transaction may see uncommitted changes made by some other transaction. 
  - Non-repeatable reads: Before transaction A is over, another transaction B also accesses the same data. Then, due to the modification caused by transaction B, the data read twice from transaction A may be different. The key to non-repeatable reading is to modify: In the same conditions, the data you have read, read it again, and find that the value is different.
  - Phantom reads: When the user reads records, another transaction inserts or deletes rows to the records being read. When the user reads the same rows again, a new “phantom” row will be found. The key point of the phantom reading is to add or delete: Under the same conditions, the number of records read out for the first time and the second time is different.
- **Deadlocks**: when two different transactions are waiting for resources that the other transaction currently holds. E.g. transaction A might have just updated the `account` table and is waiting for a write lock on the `transaction` table, while transaction B has inserted a row into the `transaction` table and is waiting for a write lock on the `account` table.
- **Lost updates**
- **Long-running transactions**



Transactions may also have savepoints, so that if you do a rollback, you return to that savepoint (and not undo the entire transaction):
```sql
START TRANSACTION;

UPDATE product
SET date_retired = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

SAVEPOINT before_close_accounts;

UPDATE account
SET 
  status = 'CLOSED', 
  close_date = CURRENT_TIMESTAMP(),
  last_activity_date = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

ROLLBACK TO SAVEPOINT before_close_accounts;
COMMIT;
```

## Locking

Locks are the mechanism the database server uses to control simultaneous use of data resources. 

Two locking strategies:
- **write lock** + **read lock**: 
  - Database writers request and receive from the server a write lock to modify data, *and database readers must request and receive from the server a read lock to query data*; 
  - One write lock is given out at a time for each table (or portion) and read requests are blocked until the write lock is released
- **Versioning approach** (**write lock**, NO **read lock**) 
  - Database writers request and receive from the server a write lock to modify data, *but readers do not need any type of lock to query data*. 
  - Instead, the server ensures that a reader sees a consistent view of the data from the time their query begins until their query has finished. 

Lock granularities:
- Table locks: keep multiple users from modifying data in the same table simultaneously
- Page locks: keep multiple users from modifying data on the same page of a table (segment of memory generally in the range of 2 KB to 16 KB) simulaneously
- Row locks: keep multiple users from modifying the same row in a table simultaneously

## auto-commit vs manual commit

> note: this is written for DBeaver

When you are working with a database in DBeaver, you can have two modes:
- Auto-commit: any changes to the database, such as UPDATE, DELETE, etc. are by default committed. Once a query has finished, there is no way of undoing it
- Manual commit: you can rollback any changes you have made to the database. If you want to make the changes permanent, you have to manually commit them by pressing the corresponding button

Manual for DBeaver: https://github.com/dbeaver/dbeaver/wiki/Auto-and-Manual-Commit-Modes



## Isolation levels

> Read more: https://blog.iddqd.uk/interview-section-databases/

Transaction isolation levels are how SQL databases solve data reading problems in concurrent transactions. 

The four isolation levels in increasing order of isolation attained for a given transaction, are READ UNCOMMITTED , READ COMMITTED , REPEATABLE READ , and SERIALIZABLE.
- **Read uncommitted**: one transaction can read the data of another uncommitted transaction.  
  - Weakest isolation, but also the fastest;
  - Allows dirty reads, non-repeatable reads, phantoms
  - Is acceptable when 1) you are reading data that you know will never be modified in any way or 2) for non-critical summary reports
- **Read committed**: a transaction cannot read data until another transaction is committed. 
  - Default for PostgreSQL
  - Prevents dirty reads
  - Allows non-repeatable reads, phantom reads
- **Repeatable read**: when starting to read data (transaction is opened), modification operations are no longer allowed. Solved non-repeatable read.
  - Default for MySQL
  - Prevents dirty reads, non-repeatable reads
  - Allows phantoms
- **Serializable**: erializable is the highest transaction isolation level. Under this level, transactions are serialized and executed sequentially, which can avoid dirty read, non-repeatable read, and phantom read. However, this transaction isolation level is inefficient and consumes database performance, so it is rarely used.
  - Strongest isolation, but also the slowest
  - Prevents dirty reads, non-repeatable reads, and phantom reads


# Relationships

Relationships in SQL are a way to establish connections between multiple tables. There are five different types of relationships between tables:
- One-to-one
- One-to-many
- Many-to-many
- Many-to-one
- Self-referencing

Read more: https://www.geeksforgeeks.org/relationships-in-sql-one-to-one-one-to-many-many-to-many/

## One-to-one

- Definition: Each record in Table A is associated with one and only one record in Table B, and vice versa.
- Setup: Include a foreign key in one of the tables that references the primary key of the other table.

```sql
-- For example: Tables users and user_profiles, where each user has a single corresponding profile.
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50));
CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY,
    user_id INT UNIQUE,
    profile_data VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id));
```

## One-to-many

- Definition: Each record in Table A can be associated with multiple records in Table B, but each record in Table B is associated with only one record in Table A.
- Setup: Include a foreign key in the "many" side table (Table B) that references the primary key of the "one" side table (Table A).

```sql
-- For example: Tables departments and employees, where each department can have multiple employees, but each employee belongs to one department.
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50));
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id));
```

```txt
Example: each character from the Mario franchise is associated with multiple filenames that represent sounds, but each sound is only connected to one character.

In this example, the foreign key from table B (`sounds`) references the primary key from table A (`characters`): 

mario_database=> SELECT * FROM characters FULL JOIN sounds ON characters.character_id = sounds.character_id;
mario_database=>                                                    
+--------------+--------+------------------+----------------+----------+--------------+--------------+
| character_id |  name  |     homeland     | favorite_color | sound_id |   filename   | character_id |
+--------------+--------+------------------+----------------+----------+--------------+--------------+
|            1 | Mario  | Mushroom Kingdom | Red            |        1 | its-a-me.wav |            1 |
|            1 | Mario  | Mushroom Kingdom | Red            |        2 | yippee.wav   |            1 |
|            2 | Luigi  | Mushroom Kingdom | Green          |        3 | ha-ha.wav    |            2 |
|            2 | Luigi  | Mushroom Kingdom | Green          |        4 | oh-yeah.wav  |            2 |
|            3 | Peach  | Mushroom Kingdom | Pink           |        5 | yay.wav      |            3 |
|            3 | Peach  | Mushroom Kingdom | Pink           |        6 | woo-hoo.wav  |            3 |
|            3 | Peach  | Mushroom Kingdom | Pink           |        7 | mm-hmm.wav   |            3 |
|            1 | Mario  | Mushroom Kingdom | Red            |        8 | yahoo.wav    |            1 |
```

## Many-to-many

- Definition: Each record in Table A can be associated with multiple records in Table B, and vice versa.
- Setup: Create an intermediate (junction, linking) table that contains foreign keys referencing both related tables.

```sql
-- For example: Tables students and courses, where each student can enroll in multiple courses, and each course can have multiple students.
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50));
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50));
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id));
```

## Many-to-one

> Note: A Many-to-One relation is the same as one-to-many, but from a different viewpoint.

- Definition: Multiple records in table A can be associated with one record in table B.
- Setup: Crate a Foreign key in “Many Table” that references to Primary Key in “One Table”.

```sql
-- Example: Table Courses and Teachers, many courses can be taught by single teacher.
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);
```

## Self-referencing

- Definition: A table has a foreign key that references its primary key.
- Setup: Include a foreign key column in the same table that references its primary key.

```sql
-- For example : A table `employees` with a column `manager_id` referencing the same table’s `employee_id`.
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id));
```

# Create function

In PostgreSQL, first you can create a function. First, let's say you have the following table `public.test`:

```txt
id|num|data        |
--+---+------------+
 1|100|abc'def     |
 2|200|second_entry|
 3|100|abc'def     |
 4|200|second_entry|
 5|100|abc'def     |
 6|200|second_entry|
```

Create this filter function:

```sql
CREATE OR REPLACE FUNCTION SelectId4(N INT) RETURNS TABLE (num INT, data1 VARCHAR) AS $$
BEGIN
	RETURN QUERY (
		SELECT
			t1.num,
			t1.data AS data1
		FROM public.test AS t1
		WHERE id = N
	);
END;
$$ LANGUAGE plpgsql;
```

Then you can call it like this: 

```sql
SELECT * FROM SelectId4(3)
```

To see all the available functions that I created:

```sql
SELECT routine_name, routine_schema, routine_definition
FROM information_schema.routines
WHERE routine_type = 'FUNCTION'
AND routine_schema NOT IN ('pg_catalog', 'information_schema');
```

