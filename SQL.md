# SQL

- [SQL](#sql)
- [Basic](#basic)
- [Database Normalization](#database-normalization)
- [Subsets of SQL commands](#subsets-of-sql-commands)
  - [DDL](#ddl)
  - [DML](#dml)
    - [SELECT](#select)
  - [DCL](#dcl)
  - [TCL](#tcl)
- [Datatypes](#datatypes)
- [Constraints](#constraints)
- [Keys](#keys)
  - [Unique key](#unique-key)
  - [Primary key](#primary-key)
  - [Composite primary key](#composite-primary-key)
  - [Foreign key](#foreign-key)
- [Sub-query](#sub-query)
- [Operators](#operators)
  - [Logical operators](#logical-operators)
  - [Comparison operators](#comparison-operators)
  - [Arithmetic operations](#arithmetic-operations)
- [IF conditions](#if-conditions)
- [REGEX](#regex)
- [Dates](#dates)
- [Union](#union)
- [Joins](#joins)
  - [Inner joins](#inner-joins)
  - [Left (outer) join](#left-outer-join)
  - [Right (outer) join](#right-outer-join)
  - [Full (outer) join](#full-outer-join)
- [Export query to CSV](#export-query-to-csv)
- [Procedures](#procedures)
- [Views](#views)
- [Transaction](#transaction)
- [Isolation levels](#isolation-levels)
- [Denormalisation](#denormalisation)
- [Relationships](#relationships)
  - [One-to-one](#one-to-one)
  - [One-to-many](#one-to-many)
  - [Many-to-many](#many-to-many)
  - [Many-to-one](#many-to-one)
  - [Self-referencing](#self-referencing)
- [PostgreSQL](#postgresql)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

# Basic

**Table** - organised set of data in the form of rows and columns.

Basic commands: 
| Command | Function |
| --- | --- |
| `\! cd` | list current dir|
| `\! dir` | list files in the current dir |
| `\i file.sql` | import file |
| `\?` | print methods |
| `\l` or MySQL `SHOW DATABASES;` | list databases |
| `\c database_name` or MySQL `use database_name;` | connect to a database |
| `\d` or MySQL `SHOW TABLES;` | check which tables are present |
| `\dt` | show tables ONLY, without `id_seq` |
| PostgreSQL `\d second_table`, `\d+ second_table`; MySQL `DESCRIBE tablename` | check columns and details of a table in a database |



# Database Normalization

**Database normalization** is the process of **structuring a relational database** in accordance with a series of so-called **normal forms** in order to reduce data redundancy and improve data integrity. It was first proposed by British computer scientist Edgar F. Codd as part of his relational model.

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

---

# Subsets of SQL commands

SQL is a hybrid language that contains 4 languages at once - DDL, DML, DCL, DQL

Read more: https://www.scaler.com/topics/ddl-dml-dcl/

## DDL

Data Definition Language, shortly termed DDL, is a subset of SQL commands that define the structure or schema of the database; commands used to modify or alter the structure of the database. 

Commands:
| Command | Explanation |
| - | - |
| **CREATE** | Create a new database |
| **ALTER** | ALTER command alters the database structure by adding, deleting, and modifying columns of the already existing tables, like renaming and changing the data type and size of the columns. |
| **DROP** | The DROP command deletes the defined table with all the table data, associated indexes, constraints, triggers, and permission specifications. |
| **TRUNCATE** | **Deletes all the data / rows** and records from an existing table, including the allocated spaces for the records. Unlike the DROP command, it does not delete the table from the database. It works similarly to the DELETE statement without a WHERE clause; also TRUNCATE is faster than DELETE. |
| **RENAME** | ... |

Database commands:
```sql
CREATE DATABASE database1;

-- Rename a database: 
ALTER DATABASE first_database RENAME TO second_database;

-- Delete a database:
DROP DATABASE second_database;
```

Table commands:
```sql
-- General form
CREATE TABLE table1(
column1 DATATYPE CONSTRAINTS, 
column2 DATATYPE CONSTRAINTS);
-- Create a new table
CREATE TABLE IF NOT EXISTS tablename;
-- Create an empty table
CREATE TABLE table1();
-- Some examples
CREATE TABLE table1(id SERIAL PRIMARY KEY, first_name VARCHAR(50) NOT NULL, gender VARCHAR(7) NOT NULL, date_birth DATE NOT NULL);
CREATE TABLE table1(id BIGSERIAL NOT NULL PRIMARY KEY);

-- Rename a table
ALTER TABLE table1 
RENAME TO table2;

-- Delete records from a table, but leave the table
-- TRUNCATE - like DELETE, but doesn't have a possible IF clause
TRUNCATE table1;
TRUNCATE table1, table2;

-- Delete the table and all the rows inside it
DROP TABLE table1;
DROP TABLE IF EXISTS table1;

-- General form
ALTER TABLE table1 
ADD COLUMN column1 DATATYPE CONSTRAINTS DEFAULT 'default', 
ADD COLUMN column2 DATATYPE CONSTRAINTS REFERENCES table2(column1);
-- Add a column example
ALTER TABLE table1 
ADD COLUMN name VARCHAR(30) NOT NULL UNIQUE;

-- Rename a column
ALTER TABLE table1 
RENAME COLUMN column1 TO column2;

-- Change datatype of a column
ALTER TABLE characters ALTER COLUMN date_of_birth SET DATA TYPE VARCHAR(10); # Change datatype of a column
-- Restart the auto-incrementing values
ALTER SEQUENCE person_id_seq RESTART WITH 10; # or 1
-- Add foreign key
ALTER TABLE <table_name> ADD FOREIGN KEY(<column_name>) REFERENCES <referenced_table_name>(<referenced_column_name>);

-- Delete a column
ALTER TABLE table1 
DROP COLUMN column1;

-- Drop a constraint for a column
ALTER TABLE table1 DROP CONSTRAINT constraint_name; # Drop a named constraint
ALTER TABLE table1 ALTER COLUMN column1 DROP NOT NULL; # Drop not null constraint

-- Add a column by concatenating two other columns (NOTE: this is not the most optimal solution, but it's the one that works for me):
ALTER TABLE table1 ADD COLUMN full_name VARCHAR(30); 
UPDATE table1 SET full_name = first_name || ' ' || last_name;
```



## DML

Data Manipulation Language, shortly termed DML, is an element in SQL language that deals with managing and manipulating data in the database. DML commands are SQL commands that perform operations like storing data in database tables, modifying and deleting existing rows, retrieving data, or updating data.

Commands:
| Command | Explanation |
| - | - |
| **SELECT** | Fetches data or records from one or more tables in the SQL database. The retrieved data gets displayed in a result table known as the result set.
| **INSERT** | Inserts one or more new records into the table in the SQL database. |
| **UPDATE** | Updates or changes the existing data or records in a table in the SQL database. |
| **DELETE** | Deletes the existing records (that can be specified with a WHERE clause and logical operators to delete selected rows from the database). Is redo-able. |
| **MERGE** | Deals with insertion, updation, and deletion in the same SQL statement. |
| **CALL** | Calls or invokes a stored procedure. |
| **EXPLAIN PLAN** | Describes the access path to the data. It returns the execution plans for the statements like INSERT, UPDATE, and DELETE in the readable format for users to check the SQL Queries. |
| **LOCK TABLE** | Ensures the consistency, atomicity, and durability of database transactions like reading and writing operations. |

Table:
```sql
# Delete records from a table, but leave the table
# DELETE - has a possible IF clause
DELETE FROM table1;
DELETE FROM table1 WHERE column1 = value; 
```

```sql
-- Insert a row in the default order of columns
INSERT INTO table1 VALUES ('Value1', 52, DATE '1995-05-04');
-- Insert a row with data for specified columns only
INSERT INTO table1 (column1, column2, column3) VALUES ('Value1', 52, DATE '1995-05-04');
-- Insert two rows
INSERT INTO table1 (column1, column2, column3) VALUES (...), (...);

-- Alter all rows
UPDATE table1
SET column1 = 10

-- Update an entry based on IF-condition
UPDATE table1 
SET column1=5, column2=10 
WHERE row='Rowname' AND row2='Rowname2';

-- Delete all rows
DELETE FROM table1; 
-- Delete a row in which column has the specified value
DELETE FROM table1 WHERE column1='Value'; 

## Update rows

# Update values in a column - swap 'f' and 'm' values
UPDATE Salary SET sex = CASE WHEN sex = 'm' THEN 'f' ELSE 'm' END;

```

### SELECT

General form:
```sql
SELECT column1, column2 -- or `*` -- or `table1.column1, table1.column2` to specify which table, especially useful in joins
FROM table1 
WHERE column2='Value'
AND (column3='Value2' OR column3='value3');
```

Some more examples:
```sql
ORDER BY column_name LIMIT 10 OFFSET 3;
-- COALESCE - print a value for NULL values
SELECT COALESCE(column1, 'Entry not found') FROM table1;   
-- Select all rows for all columns from a table
SELECT * FROM table1;


# Print the max value of column2
SELECT MAX(column1)

SELECT ROUND(AVG(column1))

SELECT column1 AS "Column title"

# Select example
SELECT column1 FROM table1 WHERE column2 = 'value' and column3 > 100;
```

**SQL functions**:

```sql
-- COUNT
-- Count the total number of rows
SELECT COUNT(*)
-- Count non-null values in a column
SELECT COUNT(column_name)
-- Count all female employees
SELECT COUNT(emp_id) FROM employee WHERE sex = 'F';
-- Count how many entries for each unique group in column 'sex' there are
SELECT COUNT(sex), sex FROM employee GROUP BY sex;

-- AVG
SELECT AVG(column1) 

-- SUM
-- Sum all values in a column
SELECT SUM(column1)
-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id FROM works_with GROUP BY emp_id;

```

**DISTINCT**:
```sql
-- Only print unique values from the column
SELECT DISTINCT(column1)
```

**AS**:
```sql
SELECT column1 AS new_column_name
```

**WHERE**:
```sql
WHERE column1 != 2 OR column2 IS null;
WHERE column1 IN ('Value1', 'Value2', 'Value3')
-- Values between two dates
WHERE date BETWEEN DATE '1999-01-01' AND '2015-01-01'
-- Values alphabetically between two strings
WHERE column1 BETWEEN 'Alpha' AND 'Beta'
-- Odd number
MOD(columnName, 2) <> 0
-- Even number
MOD(columnName, 2) = 0


-- REGEXP
-- Value starts with 'a'
WHERE email LIKE 'a%'
-- Value ends with '.com'
WHERE email LIKE '%.com';

WHERE course NOT LIKE '_lgorithms';
-- case-insensitive
ILIKE, NOT ILIKE
-- Entries start with a vowel
SELECT DISTINCT(CITY) FROM STATION WHERE CITY ~ '^[AEIOUaeiou].*';
SELECT DISTINCT(CITY) FROM STATION WHERE CITY REGEXP '^[aeiou]';
```

**HAVING**

WHERE is used for filtering rows BEFORE any grouping or aggregation.

HAVING is used for filtering rows AFTER any grouping or aggregation.

If you have both a WHERE clause and a HAVING clause in your query, WHERE will execute first.

In order to use HAVING, you also need:
- A GROUP BY clause
- An aggregation in your SELECT section (SUM, MIN, MAX, etc.)


**ORDER BY**:
-  `ORDER BY column1 ASC`
-  `ORDER BY column1 DESC`
-  `ORDER BY column1, column2`

`SELECT * FROM characters ORDER BY character_id;`

**GROUP BY**:
- `GROUP BY column1`
- `GROUP BY column1 HAVING COUNT(*) > 5` only group those values whose count is > 5
- `select major_id, count(*) from students group by major_id;` count unique values in column 'major_id'
- `select major_id, min(gpa) from students group by major_id;` view min value in each group within column major_id



**OFFSET**: skip n rows

**LIMIT**: show n first rows

Examples: 
- `SELECT * FROM table1;` view table1
- `SELECT * FROM characters ORDER BY character_id DESC;` view the whole table ordered by 'character_id'; DESC or ASC
- `SELECT * FROM person WHERE gender='Female' AND (country_of_birth='Poland' OR country_of_birth='China') ORDER BY first_name;`
- `SELECT column1, COUNT(*) FROM table GROUP BY column1;` print count of each value in column1
- `SELECT make, SUM(price) FROM car GROUP BY make;`
- `WHERE column1 < 'M'` selects rows with column1 values before 'M' alphabetically

## DCL

Data Control Language, shortly termed DCL, is comprised of those commands in SQL that deal with controls, rights, and permission in the database system. DCL commands are SQL commands that perform operations like giving and withdrawing database access from the user.

| Command | Explanation | 
| - | - |
| **GRANT** | Gives access privileges or permissions like ALL, SELECT, and EXECUTE to the database objects like views, tables, etc, in SQL. |
| **REVOKE** | Withdraws access privileges or permissions given with the GRANT command. |

## TCL

Transaction Control Language:
- COMMIT
- ROLLBACK
- SAVEPOINT

# Datatypes

| Datatype | Description |
| --- | --- |
| `DATE` | YYYY-MM-DD |
| `TIMESTAMP` | YYYY-MM-DD HH:MM:SS |
| `INT` | Whole number. |
| `SERIAL` | Auto-increments a number. The SERIAL type will make your column an INT with a NOT NULL constraint, and automatically increment the integer when a new row is added.  |
| `BIGSERIAL` | Auto-increments a number |
| `CHAR(30)` | String (specified length). The string has to be EXACTLY the specified length, in this case, 30 characters - no more, no less. *Note: use single quotes, not doublequotes* |
| `VARCHAR(30)` | String (max length). The string can have a length up to the specified limit, such as 10, 20, 25 characters, but no more than 30 characters. *Note: use single quotes, not doublequotes* |
| `NUMERIC(4, 1)` | Float with number of decimals (1). For MySQL, I think, it's `DECIMAL(10, 4)`|
| `NULL` | Null. `column IS NULL`|
| `BOOLEAN` | `TRUE`, `FALSE` |

# Constraints

Constraints are used to limit the data types for specific columns.

| Constraint | Meaning |
| --- | --- |
| **NOT NULL** | Values in this column have to be present, i.e. cannot be `NULL` |
| **CHECK** | Check for a specified condition. E.g. `constraint login_min_length check (char_length(login) >= 3)` - check the minimum length of a login field. |
| **DEFAULT** | Sets a default value for each row in a column |
| **PRIMARY KEY** | Makes a specified column a `PRIMARY KEY` type. |
| **FOREIGN KEY** | Makes a specified column an external key. E.g. `constraint user_uuid_foreign_key foreign key (user_uuid) references users (uuid) on update cascade on delete cascade` - обязывает содержать значение в user_uuid только для существующей записи в таблице users и автоматически обновится если оно будет изменено в таблице users, а так же заставит запись удалиться при удалении записи о пользователе |
| **REFERENCES table(column)** | Make a foreign key referencing another table |
| **BIGSERIAL** | Integer that auto-increments |
| **BOOLEAN** | True / False, 'Yes' / 'No' |
| **UNIQUE** | Values in this column must be unique for each data point |

Examples:
```sql
-- Add a NOT NULL constraint to the foreign key column, so that there will be no Null rows
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;
```

UNIQUE - makes sure that only unique values can be added in a column
```sql
ALTER TABLE table1 ADD CONSTRAINT constraint_name_here UNIQUE (column1) # Custom constraint name
# or
ALTER TABLE table1 ADD UNIQUE (column1) # Constraint name defined by psql
```

DEFAULT - specify a default value for a column
```sql
CREATE TABLE table1 (column1 INT DEFAULT 'undecided')
```

CHECK - a column can only accept specific values
```sql
ALTER TABLE table1 ADD CONSTRAINT constraint_name CHECK (column1='Male' OR column1='Female');
```

CONFLICT (CONSTRAINT) MANAGEMENT
```sql
ON CONFLICT (column1) DO NOTHING;
INSERT INTO ... VALUES ... ON CONFLICT (column1) DO UPDATE SET column1 = EXCLUDED.column1; # If an entry exists, it will update with the value you give it
```

FOREIGN KEYS - can connect tables based on foreign keys
```sql
CREATE TABLE table1(column1 DATATYPE REFERENCES table2(column_of_table2);

ALTER TABLE table_name ADD COLUMN column_name DATATYPE REFERENCES referenced_table_name(referenced_column_name); # to set a foreign key that references a column from another table
ALTER TABLE table_name ADD FOREIGN KEY(column_name) REFERENCES referenced_table(referenced_column); # set an existing column as a foreign key
ALTER TABLE character_actions ADD FOREIGN KEY(character_id) REFERENCES characters(character_id);
```

# Keys

## Unique key

A unique key prevents duplicate values in a column and can store NULL values.

## Primary key

Primary key is an entry into the `Primary key` column that **inequivocally (uniquely)** identify each one row in a table, i.e. an ID for each data point / row.

Features:
- `Null` values are not accepted. 
- Are indexed automatically.
- If you manually tried inserting a row with a primary key that already exists in the table, it would lead to an error, as no duplicate primary keys are allowed;
- By definition, primary key has two constraints - NOT NULL and UNIQUE;


```sql
-- NOTE: NOT A GOOD PRACTICE, but an example. Create a column with primary key that you manually have to enter:
CREATE TABLE sounds (sound_id INT PRIMARY KEY);

-- You can create a table with a column with PRIMARY KEY constraint. As it is SERIAL, you don't need to specify it when inserting new rows - it will be created automatically as per the internal rules:
-- PostgreSQL
CREATE TABLE sounds (
  sound_id SERIAL PRIMARY KEY
);
-- MySQL
CREATE TABLE student (
    student_id INT AUTO_INCREMENT PRIMARY KEY
);
-- Or add a new column and set it up as a primary key
ALTER TABLE moon ADD COLUMN moon_id SERIAL PRIMARY KEY;

-- Adding a new column and setting it up as a primary key can also be done in two steps:
ALTER TABLE table_name ADD COLUMN column1 SERIAL;
ALTER TABLE table1 ADD PRIMARY KEY (column1);
```




If you want to alter the primary key, you can do it like this. Check first the details of a table with the command `\d characters`:
```txt
mario_database=> \d characters
                                             Table "public.characters"
+----------------+-----------------------+-----------+----------+--------------------------------------------------+
|     Column     |         Type          | Collation | Nullable |                     Default                      |
+----------------+-----------------------+-----------+----------+--------------------------------------------------+
| character_id   | integer               |           | not null | nextval('characters_character_id_seq'::regclass) |
| name           | character varying(30) |           | not null |                                                  |
| homeland       | character varying(60) |           |          |                                                  |
| favorite_color | character varying(30) |           |          |                                                  |
+----------------+-----------------------+-----------+----------+--------------------------------------------------+
Indexes:
    "characters_pkey" PRIMARY KEY, btree (name)
```

Then drop contraint:
```sql
ALTER TABLE characters DROP CONSTRAINT characters_pkey;
```

---

Other commands:

ALTER TABLE table_name ADD PRIMARY KEY(column1, column2); # create composite primary key (primary key from two columns)

ALTER TABLE table1 DROP CONSTRAINT person_pkey # Drop primary key constraint


## Composite primary key 

```sql
-- Uses more than one column as a unique pair. 
ALTER TABLE <table_name> ADD PRIMARY KEY(<column_name>, <column_name>);
```

## Foreign key

A foreign key makes a connection between two tables via their joint column. 

A foreign key in one table usually references a primary key in another. 

A Foreign keys enforce data integrity, making sure the data confirms to some rules when it is added to the DB.

```sql
-- Create foreign key upon creation of the table
CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY,
    user_id INT UNIQUE,
    profile_data VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    -- You can also add a feature to auto set the value of the foreign key column to nULL
    -- FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);


-- Create a new column with  the constraint of foreign key
ALTER TABLE more_info 
ADD COLUMN character_id INT 
REFERENCES characters(character_id);

-- You can set an existing column as a foreign key like this:
ALTER TABLE table_name 
ADD FOREIGN KEY(column_name) 
REFERENCES referenced_table(referenced_column)
ON DELETE SET NULL -- optional option
;
```


# Sub-query

Use IDs from one table to use in querying another table
```sql
SELECT column1 as 'Column 1' FROM table1 WHERE table1.id NOT IN (SELECT customer_id FROM table2);
```


# Operators

## Logical operators

| Operator | Meaning |
| - | - |
| `AND` | Shows data if all the conditions separated by `AND` are TRUE. |
| `OR` | Shows data if any of the conditions separated by `OR` is TRUE. |
| `NOT` | Shows data if the condition after `NOT` is not true. |

Some examples:
```sql
SELECT column1, column2 FROM table1 WHERE condition1 AND condition2 AND condition3;

WHERE NOT condition;
```

## Comparison operators

Can be used for comparing numbers or strings. 

| Operator | Meaning |
| --- | -- |
| `=`, `<`, `<=`, `>`, `>=` | |
| `=` | equals |
| `<>` | not equal |

> Note: NULL value indicates an unavailable or unassigned value. The value NULL does not equal zero (0), nor does it equal a space (‘ ‘). Because the NULL value cannot be equal or unequal to any value, you cannot perform any comparison on this value by using operators such as ‘=’ or ‘<>’.
>
> Therefore, use `Column IS NULL` or NOT NULL

## Arithmetic operations

```sql
SELECT 10 + 2;
ROUND(column1, decimalplaces); 
```
| Operator | Meaning |
| --- | --- |
| `-`, `+`, `*`, `/` | |
| `^` | power |
| `%` | modulo |
| `MIN(column1)` | minimum value of a column |
| `SUM(column1)` | sum of all values in a column |
| `AVG(column1)` | average of a column's values |
| `CEIL(5.9)`, `FLOOR(5.1)` | round up a value |
| `ROUND(<number_to_round>, <decimals_places>)` | round a value to the nearest whole number |
| `COUNT(*)` | count number of rows |
| `mod(column1,2)` | Check the remainder of the division. In this case, remainder is zero if the number is even. |



Examples: 
- `SELECT column1 * 10`
- `SELECT MAX(column1)`

# IF conditions

```sql
# From table 'Employee', calculate bonus for each employee_id. 
# Bonus = 100% salary (if ID is odd and employee name doesn't start with 'M'), else bonus = 0. 
## Solution 1
SELECT employee_id, CASE WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%' THEN salary ELSE 0 END AS bonus FROM Employees;
## Solution 2
SELECT employee_id, if(employee_id % 2 = 1 AND name NOT LIKE 'M%', salary, 0) AS bonus FROM Employees;
```

# REGEX

| Sign | Meaning |
| --- | --- |
| `%` | any character, any number of times |
| `_` | exactly 1 character |

These are used with the SQL keyword `LIKE`

```sql
SELECT * FROM courses WHERE course LIKE '_lgorithms';
-- Find any clients who are an LLC
SELECT * FROM client WHERE client_name LIKE '%LLC';
-- Find employees born in october
SELECT * FROM employee WHERE birth_date LIKE '____-10-%';

-- names starting with 'W'
LIKE 'W%'
-- the second letter is 'e'
LIKE '_e%'
-- values with a space in them
LIKE '% %'
```


# Dates

```sql
-- Gives YYYY-MM-DD HH:MM:SS.MSMS
SELECT NOW();
-- Get years of a person from his birthday
SELECT AGE(NOW(), date_of_birth);
-- returns 2022-03-16
SELECT CURDATE(); select CURRENT_DATE 
-- returns current date formatted as UNIX
select UNIX_TIMESTAMP()
```

INTERVAL: `YEARS`, `MONTHS`, `DAYS`

```sql
NOW() - INTERVAL '1 YEAR'; # Time a year ago
```

Typecasting: `::DATE`, `::TIME`
```sql
SELECT NOW()::DATE # YYYY-MM-DD
SELECT NOW()::TIME # HH:MM:SS.MSMS
(NOW()::DATE + INTERVAL '10 MONTHS')::DATE
```

Extracting fields: `DAY`, `DOW`, `MONTH`, `YEAR`, `CENTURY`
```sql
SELECT EXTRACT (YEAR FROM NOW());

```

Select a part of a date:
- 'year', 'month', 'day', 'hour', 'minute', 'second'
```sql
SELECT date_part('year', (SELECT date_column_name))
```

# Union

UNION combines the results from several SELECT statements.

Rule:
- You have to have the same number of columns in the two statements that are joined by the `UNION` statement
- The columns being concatenated have to have the same data type

```sql
-- Return a list of employee names and then branch names located below the first list
SELECT first_name -- can also specify the name of the common column, e.g. `AS name_of_the_union_column`
FROM employee 
UNION 
SELECT branch_name 
FROM branch;

-- Find a list of all clients and branch suppliers ids
SELECT client_name, branch_id -- to increase clarity, can specify the table: `client.branch_id`
FROM client 
UNION
SELECT supplier_name, branch_id -- same: `branch_supplier.branch_id`
FROM branch_supplier;
```

# Joins

JOIN is a command for linking rows from two or more tables based on a column common for all of them. 

There are two main categories of joins:
- **INNER JOIN**: will only retain the data from the two tables that is related to each other (that is present in both tables, like an overlap of the Venn diagram);
- **OUTER JOIN**: will additionally retain the data that is not related from one table to the other; iow, combines values from the two tables, even those with NULL values.

General form:
```sql
SELECT * FROM table1 -- or SELECT table1.id, table2.id2
JOIN table2 ON relation;
```

<img src="Media/joins.png" width=800>


## Inner joins

Intersection of two tables, meaning all rows that exist for both. 

<img src="Media/inner_join.png" alt="inner joins" width="300">

Example table:
| emp_id | first_name | branch_name |
| - | - | - |
| 100 | David | Corporate |
| 102 | Michael | Scranton |
| 106 | Josh | Stamford | 

More examples:

`\x` - toggle expanded display. 

```sql
SELECT * FROM students INNER JOIN majors ON students.major_id = majors.major_id;


```

## Left (outer) join

Example table:
| emp_id | first_name | branch_name |
| - | - | - |
| 100 | David | Corporate |
| 102 | Michael | Scranton |
| 106 | Josh | Stamford | 
| 110 | Angela | NULL |
| 111 | Jack | NULL |

Will keep the unrelated data from the left (the first) table. Left join gets all rows from the left table, but from the right table - only rows that are linked to those of the table on the left. Missing data from the right table will have NULL values. 

<img src="Media/left_outer_join.png" alt="left (outer) join" width="300">

General form:
```sql
-- The same notation, just write `LEFT JOIN` instead of `JOIN`
SELECT columns FROM table1
LEFT JOIN table2 
ON relation;
```

More examples:
```sql
select * from a LEFT OUTER JOIN b on a.a = b.b;
-- Only show entries that don't have a car
SELECT * FROM person LEFT JOIN car ON car.id = person.car_id WHERE car.* IS NULL;
```
## Right (outer) join

All rows from the second / right table + the rows that match the rows from the second table .

<img src="Media/right_outer_join.png" alt="right (outer) join" width="300">

Example table:
| emp_id | first_name | branch_name |
| - | - | - |
| 100 | David | Corporate |
| 102 | Michael | Scranton |
| 106 | Josh | Stamford | 
| NULL | NULL | Buffalo |

General form:
```sql
SELECT columns FROM table1
RIGHT JOIN table2
ON relation;

-- example
select * from a RIGHT OUTER JOIN b on a.a = b.b;
```

## Full (outer) join

Combine all values from the two tables, including those with NULL values. 

<img src="Media/full_outer_join.png" alt="full (outer) join" width="300">

General form:
```sql
SELECT columns FROM table1
FULL JOIN table2
ON relation;
```

More examples:
```sql
select * from a FULL OUTER JOIN b on a.a = b.b;

SELECT * FROM table1 FULL JOIN table2 ON table1.id = table2.char_id; 
```
Or, if the column has the same name:
```sql
SELECT * FROM table1 JOIN table2 USING (id_name)
```

Or if we want to joint three tables:
```sql
SELECT columns FROM junction_table
FULL JOIN table_1 ON junction_table.foreign_key_column = table_1.primary_key_column
FULL JOIN table_2 ON junction_table.foreign_key_column = table_2.primary_key_column;
```

# Export query to CSV

```sql
\copy (SELECT ...) TO '/Users/Desktop/file.csv' DELIMITER ',' CSV HEADER;
# Example
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

# Views

A View is a kind of a table that is based on results of a previous SQL query. For example, you can save a table view upon running the inner join command, and then perform actions on that view table to not type in the join command over and over again. 

Uses and advantages:
- Views can join and simplify multiple tables into a single virtual table;
- Views can act as aggregated tables
- Views can hide the complexity of data
- Views can provide extra security to a DBMS

After you create a view, it shows in the list of tables using the command `\d`. Nevertheless, this view is not a table; it simply is a result of a saved query. 

```sql
# Create a view of a table
CREATE VIEW table1_view_males AS 
SELECT * FROM table1 WHERE gender = 'Male';

# Show a table view
SELECT * FROM table1_view_males;

# Update a view
CREATE OR REPLACE VIEW view1 AS ...;

# Delete a view
DROP VIEW view1;
```

A more practical example
```sql
# Let's say you have a join query
SELECT table1.first_name, table1.gender, table1.age, table2.item 
FROM table1 
INNER JOIN table2 ON table1.first_name = table2.first_name;

# If you want to make an operation on it, instead of writing it out every time, you can save it as a view and then perform that action on the view of the table
CREATE VIEW table1_table2_innerjoin AS 
SELECT table1.first_name, table1.gender, table1.age, table2.item 
FROM table1 
INNER JOIN table2 ON table1.first_name = table2.first_name;

# So now, you can perform operations on that view object you created, 
# for example, you can count rows
SELECT COUNT(*) FROM table1_table2_innerjoin;
```

# Transaction

A transaction is $N \ge 1$ queries to DB that either compelete successfully all together or are not completed at all.

A SQL transaction is a sequence of database operations that behave as a single unit of work. It ensures that multiple operations are executed in an atomic and consistent manner, which is crucial for maintaining database integrity. SQL transactions adhere to a set of principles known as ACID.

Primary statements used for managing SQL transactions:
- BEGIN TRANSACTION / START TRANSACTION
- COMMIT
- ROLLBACK


Example of a transaction: consider a bank database with two tables: Customers (customer_id, name, account_balance) and Transactions (transaction_id, transaction_amount, customer_id). To transfer a specific amount from one customer to another securely, you would use a SQL transaction as follows:
```sql
BEGIN TRANSACTION;

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
    COMMIT;
ELSE
    ROLLBACK;
```

SQL transactions are crucial in various real-world scenarios that require multiple database operations to occur atomically and consistently. Below are some common examples:
- E-commerce: When processing an order that includes billing, shipping, and updating the inventory, it is essential to execute these actions as a single transaction to ensure data consistency and avoid potential double bookings, incorrect inventory updates, or incomplete order processing.
- Banking and financial systems: Managing accounts, deposits, withdrawals, and transfers require transactions for ensuring data integrity and consistency while updating account balances and maintaining audit trails of all transactions.
- Reservation systems: For booking tickets or accommodations, the availability of the seats or rooms must be checked, confirmed, and updated in the system. Transactions are necessary for this process to prevent overbooking or incorrect reservations.
- User registration and authentication: While creating user accounts, it is vital to ensure that the account information is saved securely to the correct tables and without duplicates. Transactions can ensure atomicity and isolation of account data operations.

Potential issues with SQL transactions:
- Isolation problems:
  - Dirty reads - where a transaction may see uncommitted changes made by some other transaction. 
  - Non-repeatable reads: Before transaction A is over, another transaction B also accesses the same data. Then, due to the modification caused by transaction B, the data read twice from transaction A may be different. The key to non-repeatable reading is to modify: In the same conditions, the data you have read, read it again, and find that the value is different.
  - Phantom reads: When the user reads records, another transaction inserts or deletes rows to the records being read. When the user reads the same rows again, a new “phantom” row will be found. The key point of the phantom reading is to add or delete: Under the same conditions, the number of records read out for the first time and the second time is different.
- Deadlocks
- Lost updates
- Long-running transactions

# Isolation levels

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





# Denormalisation

Denormalization is a database optimization technique in which we add redundant data to one or more tables. This can help us avoid costly joins in a relational database. Note that denormalization does not mean ‘reversing normalization’ or ‘not to normalize’. It is an optimization technique that is applied after normalization.

Basically, The process of taking a normalized schema and making it non-normalized is called denormalization, and designers use it to tune the performance of systems to support time-critical operations.

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

# PostgreSQL

Login: `psql --username=<username-here> --dbname=<dbname-here>`

