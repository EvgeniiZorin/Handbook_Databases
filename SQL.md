# SQL

- [SQL](#sql)
- [General](#general)
  - [Comments](#comments)
  - [Query formatting](#query-formatting)
  - [Database Normalization](#database-normalization)
- [Subsets of SQL commands](#subsets-of-sql-commands)
  - [DDL](#ddl)
  - [DML](#dml)
  - [DCL](#dcl)
  - [TCL](#tcl)
- [Examples](#examples)
  - [Creating and populating a table (PostgreSQL)](#creating-and-populating-a-table-postgresql)
- [Datatypes](#datatypes)
  - [Character](#character)
  - [Numeric](#numeric)
    - [Round](#round)
  - [Temporal](#temporal)
  - [NULL](#null)
  - [Type casting](#type-casting)
  - [Array \> column etc.](#array--column-etc)
- [Operators](#operators)
  - [Logical](#logical)
  - [Comparison](#comparison)
  - [Arithmetic](#arithmetic)
    - [Divide by zero](#divide-by-zero)
  - [Set](#set)
    - [UNION](#union)
    - [EXCEPT](#except)
    - [INTERSECT](#intersect)
    - [Generate temporary data](#generate-temporary-data)
- [Query clauses](#query-clauses)
  - [Aliases](#aliases)
  - [SELECT](#select)
    - [Built-in functions](#built-in-functions)
    - [Random sampling](#random-sampling)
    - [Record expansion](#record-expansion)
    - [COALESCE](#coalesce)
    - [CONCAT](#concat)
    - [DISTINCT](#distinct)
    - [EXCEPT](#except-1)
    - [FARM\_FINGERPRINT](#farm_fingerprint)
    - [LIKE \& REGEXP](#like--regexp)
    - [QUOTE](#quote)
    - [SPLIT\_PART](#split_part)
    - [Row array-like, SPLIT](#row-array-like-split)
    - [Window functions](#window-functions)
      - [RANK](#rank)
      - [QUALIFY](#qualify)
      - [LAG, LEAD](#lag-lead)
      - [Cumulative SUM](#cumulative-sum)
      - [FIRST\_VALUE](#first_value)
      - [Sliding window](#sliding-window)
    - [Aggregate functions](#aggregate-functions)
      - [COUNT](#count)
      - [SUM](#sum)
      - [MIN/MAX](#minmax)
      - [AVG](#avg)
      - [GROUP BY](#group-by)
        - [WHERE vs HAVING](#where-vs-having)
      - [STRING\_AGG](#string_agg)
    - [Statistics](#statistics)
      - [Quantile](#quantile)
  - [FROM](#from)
  - [WHERE](#where)
    - [LIKE, REGEX](#like-regex)
  - [ORDER BY](#order-by)
  - [OFFSET](#offset)
  - [LIMIT](#limit)
- [Types of tables](#types-of-tables)
  - [Subquery](#subquery)
    - [Types of correlation](#types-of-correlation)
    - [Types of location](#types-of-location)
  - [CTE](#cte)
  - [Temporary tables](#temporary-tables)
  - [Views](#views)
- [Conditional logic](#conditional-logic)
  - [CASE WHEN](#case-when)
    - [in select](#in-select)
    - [in update](#in-update)
- [Constraints](#constraints)
  - [Primary key](#primary-key)
  - [Composite primary key](#composite-primary-key)
  - [Foreign key](#foreign-key)
  - [UNIQUE](#unique)
  - [CHECK](#check)
  - [DEFAULT](#default)
  - [others](#others)
- [Trigger](#trigger)
- [IF conditions](#if-conditions)
- [Joins](#joins)
  - [ON...AND vs ON...WHERE](#onand-vs-onwhere)
  - [ON vs USING](#on-vs-using)
  - [Inner join](#inner-join)
  - [Left (outer) join](#left-outer-join)
  - [Right (outer) join](#right-outer-join)
  - [Full (outer) join](#full-outer-join)
  - [Multi-table joins](#multi-table-joins)
  - [Self join](#self-join)
  - [Cross join](#cross-join)
  - [Natural join](#natural-join)
- [Pivot](#pivot)
  - [Wide -\> long](#wide---long)
  - [Long -\> wide](#long---wide)
- [Export query to CSV](#export-query-to-csv)
- [Procedures](#procedures)
- [Transaction](#transaction)
  - [Locking](#locking)
  - [auto-commit vs manual commit](#auto-commit-vs-manual-commit)
  - [Isolation levels](#isolation-levels)
- [Metadata](#metadata)
- [Index](#index)
- [Denormalisation](#denormalisation)
- [Relationships](#relationships)
  - [One-to-one](#one-to-one)
  - [One-to-many](#one-to-many)
  - [Many-to-many](#many-to-many)
  - [Many-to-one](#many-to-one)
  - [Self-referencing](#self-referencing)
- [PostgreSQL](#postgresql)
- [Tasks](#tasks)
  - [JOINS](#joins-1)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

# General

**Table** - organised set of data in the form of rows and columns.

A few types of schema in a relational database:
- Star schema: 
- Snowflake schema

Basic commands: 
| Command | PostgreSQL psql ; general | MySQL |
| - | - | - |
| List current dir | `\! cd` | |
| List files in the current dir | `\! dir` | |
| Import file | `\i file.sql` | |
| Print methods | `\?` | |
| List databases | `\l` | `SHOW DATABASES;` |
| Connect to a database | `\c database_name` | `use database_name;` |
| Show tables | `\d` | `SHOW TABLES;` |
| Show tables ONLY, without `id_seq` | `\dt` | |
| Describe table / Check columns and details of a table in a database | `\d second_table`, `\d+ second_table` ; `SELECT column_name, data_type, character_maximum_length, column_default, is_nullable FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'sample1';` | `DESCRIBE tablename`, `DESC table1` |
| Show the supported character sets in your server | | `SHOW CHARACTER SET;` |
| Connect to a database `database1` and format every output in XML | | | `sudo mysql -u root -p --xml database1` |
| Check constraints of different tables and databases | | | `SELECT * FROM information_schema.TABLE_CONSTRAINTS;` |

Specific to BigQuery:
```sql
-- Get names of columns in a table
SELECT column_name
FROM <project_name>.<dataset_name>.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = '<table_name>' 
```

**Row / record**: a set of columns that together completely describe an entity or some action on an entity. 

## Comments

```sql
SELECT /* comment here */
FROM /* another comment here */
-- this is another way to write comments

/*
you can write multi-line comments
like this
*/
SELECT *
FROM table1
WHERE employee='Laura'

```

## Query formatting

```sql
SELECT a
     , d
     , c
FROM table
WHERE d = 'SOMETHING'
```

## Database Normalization

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

**Database commands**:
```sql
CREATE DATABASE database1;

-- Rename a database: 
ALTER DATABASE first_database RENAME TO second_database;

-- Delete a database:
DROP DATABASE second_database;
```

**Table commands**:

These are SQL schema statements for creating tables with specified schemas.
```sql
-- General form
CREATE TABLE table1(
  column1 DATATYPE CONSTRAINTS, 
  column2 DATATYPE CONSTRAINTS
);
-- Create a new table
CREATE TABLE IF NOT EXISTS tablename;
-- Create an empty table
CREATE TABLE table1();

-- Rename a table
ALTER TABLE table1 
RENAME TO table2;

-- Delete records from a table, but leave the table
-- TRUNCATE - like DELETE, but doesn't have a possible IF clause
TRUNCATE table1;
TRUNCATE table1, table2;

-- Delete the table and all the rows inside it
DROP TABLE table1;
DROP TABLE table1, table2;
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
-- Delete records from a table, but leave the table
-- DELETE - has a possible IF clause
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

-- Update rows

-- Update values in a column - swap 'f' and 'm' values
UPDATE Salary SET sex = CASE WHEN sex = 'm' THEN 'f' ELSE 'm' END;

```

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

# Examples

## Creating and populating a table (PostgreSQL)

```sql
-- An extensive example (PostgreSQL) with a PRIMARY KEY
DROP TABLE IF EXISTS public.employee CASCADE; 
DROP TABLE IF EXISTS public.employee_info;
CREATE TABLE public.employee(
  id SERIAL PRIMARY KEY,                               -- Primary key column that automatically increments with each inserted row
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),   -- When the row was added
  date_birth DATE NOT NULL,                            -- Comment here
  street VARCHAR(20),                                  -- Comment here
  phone_number NUMERIC UNIQUE NOT NULL,                -- Comment here
  city VARCHAR(20),                                    -- Comment here
  country VARCHAR(20)                                  -- Comment here
);
-- Then add another table with a FOREIGN KEY
CREATE TABLE public.employee_info(
  employee_id INTEGER NOT NULL,                        -- References employee.id
  first_name VARCHAR(50) NOT NULL,                     -- First name
  last_name VARCHAR(50) NOT NULL,                      -- Last name
  sex VARCHAR(10) NOT NULL                             
    CHECK (sex IN ('male', 'female', 'other')),
  --eye_color ENUM('BR', 'BL', 'GR'),                    -- Eye color
  salary INTEGER NOT NULL DEFAULT 10000,               -- If no salary is provided, default = 10,000
  PRIMARY KEY (employee_id, first_name, last_name),    -- Composite primary key
  FOREIGN KEY (employee_id)                            -- Delete definitions if attribute is deleted
    REFERENCES employee (id)
    ON DELETE CASCADE
);
-- Insert some values
INSERT INTO public.employee 
	(date_birth, street, phone_number, city, country)
VALUES
	('1970-05-04', 'Grove street', 7291235938, 'Toluca', 'Mexico'),
	('1971-06-01', 'Oak avenue', 3835913978, 'Puebla', 'Mexico')
;
```

MySQL:
- Mostly all the same
- Different how you auto-increment a column

```sql
CREATE TABLE table1 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  -- ...
)
```

# Datatypes

## Character

| Datatype | Description | Example |
| - | - | - |
| `CHAR(30)` | Fixed-length, blank-padded strings. <br> The string has to be EXACTLY the specified length, in this case, 30 characters - no more, no less. These are right-padded with spaces (to fill up the remaining characters not used by definition of a variable) and always consume the same number of bytes.| State abbreviations - all strings stored in the column are of the same length. |
| `VARCHAR(30)` | Variable-length string. The string can have a length up to the specified limit, such as 10, 20, 25 characters, but no more than e.g. 30 characters. | Varchar is appropriate for free-form data entry, e.g. notes column to hold data about customer interactions with your company's customer service department.  |
| PostgreSQL `text` ; MySQL `tinytext`, `text`, `mediumtext`, `longtext` | To store longer strings such as emails, XML documents. | Note: in MySQL, `tinytext` and `text` aren't normally used. Instead, you can see more often the use of mediumtext and longtext that can be used for storing documents. |

> Note 1: 
> for character data types, use single quotes, not doublequotes. 
> If you need to use a single apostrophe as part of the string, use it two times to escape, e.g. to write a string `O'Brien` you can escape like this: `'O''Brien'`
>
> HOWEVER, in BigQuery, you can use single quotes `'` or double quotes `"`, to represent character data types and datetime. 

> Note 2:
> CHAR and VARCHAR are for storing relatively short text strings. For longer, use text data types

Define character set:
```sql
-- for a variable
VARCHAR(20) CHARACTER SET latin1
-- for the entire database
CREATE DATABASE database1 CHARACTER SET latin1;
```

**SUBSTRING**
- MySQL, PostgreSQL
- For slicing
- Indexes in SQL start with 1
```sql
-- Select substring from index 5 to index 10
SELECT SUBSTRING('yes hello world', 5, 5); -- returns 'hello'
-- 'hello' + '****' + 'world' -> 'hello****world'
SELECT CONCAT( SUBSTRING('yes hello world', 5, 5), '****', SUBSTRING('yes hello world', 11, 5) )
```

**CHAR**

> Works for MySQL and PostgreSQL

Returns the ASCII code / number for a character

```sql
SELECT ASCII('ñ') -- for instance, in character set UTF-8 it's a character 195
```

**LENGTH**

> Works for MySQL and PostgreSQL
>
> Works only with string / character data types

For a specified column, returns the string length of each row

```sql
SELECT LENGTH(name)
FROM person;
-- returns:
-- length| -- int data type
-- ------+
--      9|
--      2|
--      5|
--      5|
```



**TRIM**

Removes spaces or specified characters from both ends of a string.

```sql
SELECT TRIM(name) FROM employees;
```

**UPPER**

```sql
SELECT UPPER(name)
-- Capitalise the first letter only
SELECT CONCAT(
  UPPER(SUBSTRING(name,1,1)),
  LOWER(SUBSTRING(name, 2, LENGTH(name) - 1))
) AS name
```

## Numeric

| Datatype | Description | Example |
| - | - | - |
| `SERIAL` | Auto-increments a number upon inserting a new row. The SERIAL type will make your column an INT with a NOT NULL constraint, and automatically increment the integer when a new row is added. `BIGSERIAL` is the same but has a higher range of possible values.  |
| `BOOLEAN` | `TRUE`, `FALSE` | A column indicating whether a customer order has been shipped |
| `INT` | Whole number. MySQL also has `tinyint`, `smallint`, `mediumint`, `int`, `bigint` | |
| `FLOAT` | Can be `FLOAT(p,s)`, where p is the total number of digits and s is number of allowable digits to the right of the decimal point. For MySQL, can be `FLOAT`, `FLOAT(p,s)`, and for even larger numbers `DOUBLE(p,s)`. | E.g. `FLOAT(4,2)` - handles 17.87, 8.19, but rounds 17.8675 to 17.87 and errors at attempt of storing 178.375 |

> Note 1: 
> The numeric data types can be defined as `unsigned`, meaning that they are greater than or equal to zero.

```sql
-- | `POW(2, 3)` | Power; in this example, 2^3. Works in PostgreSQL, MySQL. |
-- | `MOD(<number_to_round/column>, <number-by-which-to-divide>)` | Modulo: check the remainder of the division. In this case, remainder is zero if the number is even. E.g. `MOD(3, 2)`, `MOD(column1, 2)`. Works in MySQL and PostgreSQL. |
-- | `exp(x)` | Calculate the e^x |
-- | `ln(x)` | Calculate the natural log of x |
-- | `sqrt(x)` | Calculate the square root of x |

-- In a column 'comparison' with binary values (0 and 1), calculate percentage that all ones make from the total amount
SELECT ROUND( (SUM(comparison)::numeric / COUNT(comparison)::numeric) * 100 , 2 ) AS immediate_percentage

-- SIGN
-- Show the sign of the signed number
-- `1` if positive, `-1` if negative, and `0` if the number is a zero.
SELECT
  balance,
  SIGN(balance) AS sign
FROM account
-- | balance | sign |
-- | - | - |
-- | 102.21 | 1 |
-- | 0 | 0 |
-- | -122 | -1 |

-- ABS
-- Shows the absolute value of a signed number
SELECT ABS(balance) FROM account
```

### Round

Controlling number precision:
| Operator | Description |
| - | - |
| `ROUND(<number/column-to-round>)` | Round a value to the nearest whole number. |
| `ROUND(<number_to_round/column>, <decimals_places>)`. | Round a value / column to the nearest number with the specified precision after decimal point. Example: `ROUND(15.51235312, 2)` rounds to 15.51. |
| `FLOOR(5.1)` | Round DOWN a value. E.g. `FLOOR(7.1)`, `FLOOR(7.9)` produces 7. |
| `CEIL(5.9)` | Round UP a value. E.g. `CEIL(7.1)`, `CEIL(7.9)` produces 8. |

## Temporal

| Datatype | Description | Example |
| - | - | - |
| `TIMESTAMP` | Used by MySQL, PostgreSQL. Date format: `YYYY-MM-DD HH:MM:SS.MSS`. The TIMESTAMP data type has a range of '1970-01-01 00:00:01' UTC to '2038-01-09 03:14:07' UTC. It has varying properties, depending on the MySQL version and the SQL mode the server is running in. | A column that tracks when a user last modified a particular row in a table. |
| `DATETIME` | MySQL. Date format is like TIMESTAMP.  The DATETIME type is used when you need values that contain both date and time information. MySQL retrieves and displays DATETIME values in 'YYYY-MM-DD HH:MM:SS' format. The supported range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59'. | |
| `DATE` | `YYYY-MM-DD` | Column to hold the expected future shipping date of a customer order. An employee's birth date. |
| `YEAR` | `YYYY` | |
| `TIME` | `HHH:MM:SS` | |

> Date is inserted as string in the format `YYYY-MM-DD`, e.g. `2020-03-23`. MySQL or other servers will automatically convert the string into a date, given that the format of the string matches that of the column in the temporal datatype

To automatically populate a table with the date that a record was inserted:
```sql
-- PostgreSQL, MySQL
CREATE TABLE table1 (
	name TEXT, 
--	date TIMESTAMP
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Different ways of writing time:
| Date | Example |
| - | - |
| `YYYY` | 2014 |
| `MM` | 01 to 12 |
| `DD` | 01 to 31 |
| `HH` | Hour: 00 to 23 |
| `HHH` | Hours (elapsed): -838 to 838 |
| `MI` | Minute: 00 to 59 |
| `SS` | Seconds: 00 to 59 |

**Time zones**

```sql
-- Give current UTC time
-- MySQL
SELECT utc_timestamp();

-- Check time zone settings - global time zone and session time zone
-- SYSTEM = server is using the time zone setting from the server on which the database resides
-- MySQL
SELECT @@global.time_zone, @@session.time_zone
-- Set time zone
SET time_zone = 'Europe/Zurich';
-- PostgreSQL
SHOW timezone;
SELECT current_setting('TIMEZONE');
```

**General**

```sql
-- Get a quarter number for a timestamp
SELECT quarter(datetime)

-- Update a date for a row
UPDATE rental
SET return_date = '2019-09-17' -- or '2019-09-17 15:30:00'
WHERE rental_id = 99999;

-- Gives YYYY-MM-DD HH:MM:SS.MSMS
SELECT NOW();
-- Get years of a person from his birthday
SELECT AGE(NOW(), date_of_birth);
-- Get current date; returns 2022-03-16
-- MySQL, CURDATE(); PostgreSQL, doesn't exist
SELECT CURDATE()
-- PostgreSQL, CURRENT_DATE;
-- MySQL, CURRENT_DATE or CURRENT_DATE()
select CURRENT_DATE() -- returns '2024-11-21'
-- Get current time; format `11:34:22`
SELECT CURTIME()
SELECT CURRENT_TIME()
-- Get current timestamp
SELECT CURRENT_TIMESTAMP
-- returns current date formatted as UNIX time
select UNIX_TIMESTAMP()
```

**INTERVAL**
- Is used to add time period to dates
- Used by PostgreSQL, MySQL
- Interval types (note: in PostgreSQL, can write as singular or plural - DAY or DAYS; in MySQL, only as singular - DAY): `second`, `minute`, `hour`, `day`, `month`, `year`, `minute_second`, `hour_second`, `year_month`

```sql
-- Current date + 5 days
-- PostgreSQL 
SELECT CURRENT_DATE + INTERVAL '5 DAY'
-- MySQL
SELECT CURRENT_DATE() + INTERVAL 5 DAY;
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);
-- Time a year ago: 
NOW() - INTERVAL '1 YEAR';
-- Select birthdays between 1977-05-04 and 30 days before that
SELECT * FROM personal_data 
WHERE birthday < '1977-05-04'::date 
AND birthday > '1977-05-04'::date - INTERVAL '30 DAYS';

-- Add 3 hours, 27 minutes, and 11 seconds to the current timestamp
-- MySQL
SELECT DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL '3:27:11' HOUR_SECOND)
-- PostgreSQL
SELECT CURRENT_TIMESTAMP + INTERVAL '3:27:11' HOUR_SECOND;
-- MySQL: add 9 years and 11 months to a birth_date
UPDATE employee
SET birth_date = DATE_ADD(birth_date, INTERVAL '9-11' YEAR_MONTH)
WHERE emp_id = 123;
```

**Other**
```sql
-- Typecasting
-- YYYY-MM-DD
SELECT NOW()::DATE
-- HH:MM:SS.MSMS
SELECT NOW()::TIME
-- An example
(NOW()::DATE + INTERVAL '10 MONTHS')::DATE

-- STR_TO_DATE()
-- Change string format to specified datetime format
-- MySQL
-- Returns DATETIME, DATE, or TIME value depending on the contents of the format string
SELECT STR_TO_DATE('September 17, 2019', '%M %d, %Y'); -- generates DATE format: `YYYY-MM-DD`
```

**DAYNAME()**
- MySQL
- Extracts an entity from a date
- *Instead of this, it is better to use EXTRACT*
```sql
SELECT DAYNAME('2019-09-18') -- > Wednesday
```

**EXTRACT**
- Extracts fields: DAY, DOW, MONTH, YEAR, CENTURY
- EXTRACT can be used in SELECT and WHERE
- PostgreSQL, MySQL
```sql
-- EXTRACT: Extracting fields: DAY, DOW, MONTH, YEAR, CENTURY
-- EXTRACT can be used in SELECT and WHERE
-- PostgreSQL
EXTRACT (YEAR FROM NOW())
-- MySQL
EXTRACT(YEAR FROM CURRENT_DATE())
-- MySQL
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW())
-- Select month of February
SELECT * FROM notable_dates WHERE EXTRACT (MONTH FROM date1) = 02
-- Compare two years
WHERE EXTRACT(YEAR FROM date1) < EXTRACT(YEAR FROM CURRENT_DATE())
WHERE EXTRACT(YEAR FROM e.birth_date) IN (1967, 1961)
-- MySQL
YEAR(date1) = 2004 -- or '2004'
QUARTER(date1)
MONTHNAME(date1)
```

```sql
-- Select a part of a date
-- year, month, day, hour, minute, second
SELECT date_part('year', (SELECT date_column_name))

-- Select year and month
SELECT TO_CHAR(order_date, 'YYYY-MM')

-- DATEDIFF
-- MySQL
-- returns the number of full days between two dates
-- ignores the time of day in its arguments
SELECT DATEDIFF('2019-09-03', '2019-06-21') -- > 74
SELECT DATEDIFF('2019-09-03 23:59:59', '2019-06-21 00:00:01') -- > 74
SELECT DATEDIFF('2019-06-21', '2019-09-03') -- > -74

-- MySQL
-- if you have date containing minutes, hours, etc. apart from the date itself, you can filter only based on year,month,day like this:
WHERE return_date = date('2005-07-05') 
```

MySQL string formats to date type, e.g. `str_to_date('DEC-21-1980', '%b-%d-%Y')`:
| Formatter | Definition | Example |
| - | - | - |
| `%Y` | The four-digit year | |
| `%y` | The two-digit year | |
| `%M` | The full month name | (January..December) |
| `%m` | The numeric month | (0..12) |
| `%b` | The short month name | Jan, Feb, ... |
| `%W` | The full weekday name | (Sunday..Saturday) |
| `%w` | The numeric day of the week | (0=Sunday..6=Saturday) |
| `%a` | The short weekday name | Sun, Mon, ... |
| `%d` | The numeric day of the month | (01..31) |
| `%j` | The day of year | (001..366) |
| `%H` | The hour of the day, in 24-hour format | (00..23) |
| `%h` | The hour of the day, in 12-hour format | (01..12) |
| `%i` | The minutes within the hour | (00..59) |
| `%s` | The number of seconds | (00.59) |
| `%f` | The number of microseconds | (000000..999999) |
| `%p` | AM or PM | |

Examples:
```sql
-- return records where date equals to specified date
select * from personal_data where birthday = '1977-05-04'
select * from personal_data where birthday = '1977-05-04'::date;

-- Thus, we can order birthdays based only on month and date
-- For example, table like this:
--  id | name         |    date    |
-- ----+--------------+------------+
--  21 | Person 1     | 1971-11-21 |
--  23 | Person 2     | 1989-12-29 |

SELECT * 
FROM notable_dates 
ORDER BY 
  EXTRACT(MONTH FROM date) DESC, 
  EXTRACT(DAY FROM date) DESC;
```

Show total monthly payments for film rentals for 2005 for each quarter and month;
```sql
SELECT 
	QUARTER(payment_date) AS quarter,
	MONTHNAME(payment_date) AS month_nm,
	SUM(amount) AS monthly_sales,
	MAX(SUM(amount)) OVER () AS max_overall_sales,
	MAX(SUM(amount)) OVER (PARTITION BY QUARTER(payment_date)) AS max_qrtr_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY 
	quarter(payment_date),
	monthname(payment_date)
;

-- quarter|month_nm|monthly_sales|max_overall_sales|max_qrtr_sales|
-- -------+--------+-------------+-----------------+--------------+
--       2|May     |      4823.44|         28368.91|       9629.89|
--       2|June    |      9629.89|         28368.91|       9629.89|
--       3|July    |     28368.91|         28368.91|      28368.91|
--       3|August  |     24070.14|         28368.91|      28368.91|
```

## NULL

Different meanings / contexts of NULL:
- Not applicable: employee ID column for a transaction that took place at an ATM machine
- Value not yet known: federal ID is not known at the time a customer row is created
- Value undefined: when an account is created for a product that has not yet been added to the database

Rules:
- An expression can *be* null, but it can never *equal* null: 
  - ❌ `WHERE return_date = NULL` does not return any rows
  - ✅ `WHERE return_date IS NULL` or `IS NOT NULL`
- Two nulls are never equal to each other

## Type casting

You can cast datatypes in the ways below:
```sql
-- data types: date, numeric, int, float
-- does NOT work in BigQuery or MySQL,
-- but works in PostgreSQL
SELECT 
  whatever::date, 
  whatever2::numeric
-- or
round( SUM(rating::dec / position::dec)::dec / COUNT(rating)::dec, 2) AS quality

-- another way
SELECT 
  CAST(sss2.id AS STRING),
  CAST(age AS varchar),
  CAST('123' AS SIGNED INTEGER)
```

Complex data types:
```sql
-- List - usually used within a WHERE _ IN <list> clause
('Value1', 'Value2', 'Value3')
```

## Array > column etc.

Convert sql array into rows of a column
```sql
SELECT *
FROM UNNEST(ARRAY[1, 2, 3,
                  4, 5, 6
]) AS id1
-- id1   |
-- ------+
--      1|
--      2|
--      3|
--      4|
--      5|
--      6|
```

Separate string into list items
```sql
-- Separate string into list items
SELECT string_to_array('1 2 3 4', ' ') -- gives you output of one cell like this: {1,2,3,4}
-- Separate and put as values of a column
SELECT unnest(string_to_array('1 2 3 4', ' '))
-- example usage: you have a string containing items you want to look for
select *
from employee
where emp_id in (
	select unnest(string_to_array('100 101 102', ' '))::numeric
)
-- make a database selection as a name
```

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

## Set 


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
```


# Query clauses

Query clauses:
- select
- from
- where
- group by
- having
- order by

Each clause has keywords / statements, e.g. clause SELECT has statements such as DISTINCT etc.

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

### CONCAT

Features:
- Can handle any expression that returns a string
- In MySQL, will convert numbers, dates to string format

Concatenate two columns:
```sql
SELECT first_name || '-' || last_name AS column_name
FROM employee;
-- or
SELECT CONCAT( first_name, '-', last_name )
FROM employee;

-- Update a table's column by concatenating a string at the end
UPDATE table1
SET col1 = CONCAT(col1, ' additional string')
```

### DISTINCT

```sql
-- Only print unique values from the column
-- the two queries below produce the same result
SELECT DISTINCT (column1)
SELECT DISTINCT column1

-- Show unique combinations of two columns - returns column where each row is a list of unique combs
SELECT DISTINCT (column1, column2)
-- show unique combinations of two columns BUT return a normal table
SELECT DISTINCT column1, column2

-- example
SELECT DISTINCT(country, lang)
FROM (
	SELECT 'usa' AS country, 'english' AS lang
	UNION ALL
	SELECT 'usa' AS country, 'spanish' AS lang
	UNION ALL
	SELECT 'can' AS country, 'french' AS lang
	UNION ALL
	SELECT 'usa' AS country, 'spanish' AS lang
) AS subquery1;
-- `SELECT DISTINCT(country, lang)` returns this:
-- row          |
-- -------------+
-- (can,french) |
-- (usa,english)|
-- (usa,spanish)|

-- `SELECT DISTINCT country, lang` returns this:
-- country|lang   |
-- -------+-------+
-- usa    |spanish|
-- can    |french |
-- usa    |english|
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

### LIKE & REGEXP

> `LIKE` Works for MySQL, PostgreSQL

The regex statement `LIKE` in the `SELECT` clause will return a boolean mask for whether a column matches that regexp.

```sql
SELECT 
  first_name,
  first_name LIKE 'A%' AS starts_with_a
  -- MySQL:      alternatively you can use: `first_name REGEXP '^A.*' AS starts_with_a`
  -- PostgreSQL: alternatively you can use: `first_name ~ '^A.*' AS starts_with_a`
FROM employee;
-- returns for MySQL
-- first_name|starts_with_a| -- bigint
-- ----------+-------------+
-- David     |0            |
-- Angela    |1            |
-- Kelly     |0            |
-- Stanley   |0            |
-- Andy      |1            |

-- returns for PostgreSQL
-- first_name|starts_with_a| -- bool
-- ----------+-------------+
-- David     |false        |
-- Angela    |true         |
-- Kelly     |false        |
-- Stanley   |false        |
-- Andy      |true         |
```


### QUOTE

> This function is MySQL only.

Place quotes around results of the query AND adds escape characters (to single quotes / apostrophes). Can be used with any data type.

```sql
SELECT QUOTE(person_id) FROM person
-- output:
-- QUOTE(person_id)|
-- ---------------+
-- '58'           |
-- '92'           |
-- '182'          |
-- '118'          |
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
  temp2,
  UNNEST(feature_split) AS feature_split_2

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

> a.k.a. data windows, window functions, analytic function

In SQL, a window function allows advanced analytics by letting you calculate across rows while keeping all data intact; it is a function which uses values from one or multiple rows to return a value for each row. 
- ℹ️ This contrasts with an aggregate function, which returns a single value for multiple rows.

Window functions have an OVER clause; any function without an OVER clause is not a window function, but rather an aggregate or single-row (scalar) function.

Anatomy of a window function:
- Some aggregate function first;
- `OVER()` clause: defines the set of rows for the function. Every window function requires this;
- `PARTITION BY`: split data into groups, applying the function within each group. Similar to GROUP BY but without collapsing rows;
- `ORDER BY`: orders rows within each partition, critical for functions like ROW_NUMBER() and RANK();

```sql
<function_name>() OVER (
  PARTITION BY <column> 
  ORDER BY <column>
)
```


**Example 1:**

Show total monthly payments for film rentals for 2005 for each quarter and month;
```sql
SELECT 
	QUARTER(payment_date) AS quarter,
	MONTHNAME(payment_date) AS month_nm,
	SUM(amount) AS monthly_sales,
	MAX(SUM(amount)) OVER () AS max_overall_sales,
	MAX(SUM(amount)) OVER (PARTITION BY QUARTER(payment_date)) AS max_qrtr_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY 
	quarter(payment_date),
	monthname(payment_date)
;

-- quarter|month_nm|monthly_sales|max_overall_sales|max_qrtr_sales|
-- -------+--------+-------------+-----------------+--------------+
--       2|May     |      4823.44|         28368.91|       9629.89|
--       2|June    |      9629.89|         28368.91|       9629.89|
--       3|July    |     28368.91|         28368.91|      28368.91|
--       3|August  |     24070.14|         28368.91|      28368.91|
```

**Example 2:**

```sql
SELECT 
	year,
	month, 
	MAX(MAX(sale)) OVER () AS max_overall_sale,
	MAX(SUM(sale)) OVER (PARTITION BY month) AS total_monthly_sales,
	MAX(MAX(sale)) OVER (PARTITION BY year, month) AS max_monthly_sales
	
FROM (
	SELECT '2014' AS year, 'June' AS month, 100 AS sale
	UNION ALL
	SELECT '2014' AS year, 'June' AS month, 150 AS sale
	UNION ALL
	SELECT '2014' AS year, 'July' AS month, 170 AS sale
	UNION ALL
	SELECT '2015' AS year, 'June' AS month, 300 AS sale
	UNION ALL
	SELECT '2015' AS year, 'June' AS month, 50 AS sale
) a1
GROUP BY 
	year,
	month

-- Result: 
-- year|month|max_overall_sale|total_monthly_sales|max_monthly_sales|
-- ----+-----+----------------+-------------------+-----------------+
-- 2014|July |             300|                170|              170|
-- 2014|June |             300|                350|              150|
-- 2015|June |             300|                350|              300|
```


#### RANK

Ranking functions:
- `ROW_NUMBER`: returns a unique number for each row
- `RANK`: returns the same ranking in case of a tie, with gaps in the ranking
- `DENSE_RANK`: returns the same ranking in case of a tie, with NO gaps in the ranking

> For many situations, the `RANK` function might be the best option

**A clear comparative example**

```sql
SELECT 
	customer_id,
	num_rentals,
	ROW_NUMBER() OVER (ORDER BY num_rentals DESC) AS row_number_rnk,
	RANK() OVER (ORDER BY num_rentals DESC) AS rank_rnk,
	DENSE_RANK() OVER (ORDER BY num_rentals DESC) AS dense_rank_rnk
FROM (	
	SELECT 1 customer_id, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 43 num_rentals
) a1;
-- customer_id|num_rentals|row_number_rnk|rank_rnk|dense_rank_rnk|
-- -----------+-----------+--------------+--------+--------------+
--           1|         46|             1|       1|             1|
--           2|         45|             2|       2|             2|
--           3|         45|             3|       2|             2|
--           4|         44|             4|       4|             3|
--           5|         44|             5|       4|             3|
--           6|         44|             6|       4|             3|
--           7|         43|             7|       7|             4|
```


Another example: **For each group, save only the longest string**

```sql
WITH a1 AS (
	SELECT 'Text 1' AS texts, 1 AS groups
	UNION ALL
	SELECT 'Longer texts' AS texts, 1 AS groups
	UNION ALL
	SELECT 'fasdd asdfasd' AS texts, 2 AS groups
	UNION ALL
	SELECT 'aas algitorkdm' AS texts, 2 AS groups
	UNION ALL 
	SELECT NULL AS texts, 3 AS groups
	UNION ALL
	SELECT 'aaa' AS texts, 3 AS groups
),
a2 AS (
	SELECT 
		groups,
		CASE WHEN texts IS NULL THEN '-' ELSE texts END AS texts
	FROM a1
),
a3 AS (
	SELECT
		texts, 
		groups,
		ROW_NUMBER() OVER (PARTITION BY groups ORDER BY LENGTH(texts) DESC)
	FROM a2
)
SELECT *
FROM a3
WHERE row_number = 1
```


Get top 3 for ROW_NUMBER() function:
```sql
SELECT *
FROM (
	SELECT 
		customer_id,
		num_rentals,
		ROW_NUMBER() OVER (ORDER BY num_rentals DESC) AS row_number_rnk
	FROM (	
		SELECT 1 customer_id, 46 num_rentals
		UNION ALL
		SELECT 2 customer_id, 45 num_rentals
		UNION ALL
		SELECT 3 customer_id, 45 num_rentals
		UNION ALL
		SELECT 4 customer_id, 44 num_rentals
		UNION ALL
		SELECT 5 customer_id, 44 num_rentals
		UNION ALL
		SELECT 6 customer_id, 44 num_rentals
		UNION ALL
		SELECT 7 customer_id, 43 num_rentals
	) a1
) a2
WHERE 
	row_number_rnk <= 3
;
-- customer_id|num_rentals|row_number_rnk|
-- -----------+-----------+--------------+
--           1|         46|             1|
--           2|         45|             2|
--           3|         45|             3|
```

Multiple ranking - get ranking for each year
```sql
WITH temp1 AS (
	SELECT 1 customer_id, 2014 yr, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 2014 yr, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 2015 yr, 43 num_rentals
)
SELECT 
	customer_id,
	yr,
	num_rentals,
	ROW_NUMBER() OVER (PARTITION BY yr ORDER BY num_rentals DESC) AS num_rentals_rank
FROM temp1

-- customer_id|yr  |num_rentals|dense_rank_rnk|
-- -----------+----+-----------+--------------+
--           1|2014|         46|             1|
--           2|2014|         45|             2|
--           3|2014|         45|             2|
--           4|2014|         44|             3|
--           5|2015|         44|             1|
--           6|2015|         44|             1|
--           7|2015|         43|             2|
```

#### QUALIFY

QUALIFY is a clause used to filter the results of a window function. 

> You need a QUALIFY statement because WHERE, GROUP BY, and HAVING filtering statements are all evaluated before the window functions. This can be overcome either by QUALIFY within the same query or writing filters on a window function-containing query contained within a CTE.

Examples:
> seemingly, QUALIFY doesn't work in PostgreSQL

```sql
-- Notice in this example that QUALIFY is applied AFTER 
-- apllying the WHERE clause
WITH temp1 AS (
	SELECT 1 customer_id, 2014 yr, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 2014 yr, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 2015 yr, 43 num_rentals
)
SELECT *
FROM temp1
WHERE customer_id IN (1, 2, 5, 6)
QUALIFY ROW_NUMBER() OVER(
	PARTITION BY yr 
	ORDER BY num_rentals ASC
) = 1
-- | customer_id | yr   | num_rentals |
-- | ----------- | ---- | ----------- |
-- | 2           | 2014 | 45          |
-- | 5           | 2015 | 44          |

-- if you comment out the WHERE clause, then apply QUALIFY in a separate CTE, and then apply WHERE, 
-- the results will be different - will return empty table
```

#### LAG, LEAD

```sql
WITH temp1 AS (
	SELECT 'Lisa' name, '2021-01-01' date, 5500 salary
	UNION ALL
	SELECT 'Lisa' name, '2022-01-01' date, 7000 salary
	UNION ALL
	SELECT 'Lisa' name, '2023-01-01' date, 7500 salary
	UNION ALL
	SELECT 'Lisa' name, '2024-01-01' date, 8000 salary
)
SELECT
	name, 
	date,
	salary,
	LAG(salary) OVER (ORDER BY date) AS prev_salary,
	LEAD(salary) OVER (ORDER BY date) AS next_salary
FROM temp1;

-- output
-- name|date      |salary|prev_salary|next_salary|
-- ----+----------+------+-----------+-----------+
-- Lisa|2021-01-01|  5500|           |       7000|
-- Lisa|2022-01-01|  7000|       5500|       7500|
-- Lisa|2023-01-01|  7500|       7000|       8000|
-- Lisa|2024-01-01|  8000|       7500|           |
```

#### Cumulative SUM

```sql
WITH daily_sales AS (
	SELECT '2023-05-01'::date date, 100 sales
	UNION ALL
	SELECT '2023-05-02'::date date, 200 sales
	UNION ALL
	SELECT '2023-05-03'::date date, 150 sales
)
SELECT 
	date, 
	sales,
	SUM(sales) OVER (ORDER BY Date) as CumulativeSales
FROM daily_sales;

-- date      |sales|cumulativesales|
-- ----------+-----+---------------+
-- 2023-05-01|  100|            100|
-- 2023-05-02|  200|            300|
-- 2023-05-03|  150|            450|
```

#### FIRST_VALUE

FIRST_VALUE() returns the first value in an ordered partition, while LAST_VALUE() returns the last value. 

𝗙𝗼𝗿 𝗲𝘅𝗮𝗺𝗽𝗹𝗲: In analyzing stock prices, FIRST_VALUE() can be used to compare daily stock prices to the price at month's start, so we can measure price changes relative to the month's opening price.

Example:

**FIRST_VALUE() behaves exactly as expected:**
```sql
WITH temp1 AS (
	SELECT 1 customer_id, 2014 yr, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 2014 yr, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 2015 yr, 43 num_rentals
)
SELECT 
	customer_id,
	yr,
	num_rentals,
	FIRST_VALUE(num_rentals) OVER (PARTITION BY yr ORDER BY num_rentals)
FROM temp1;
-- customer_id|yr  |num_rentals|first_value|
-- -----------+----+-----------+-----------+
--           4|2014|         44|         44|
--           2|2014|         45|         44|
--           3|2014|         45|         44|
--           1|2014|         46|         44|
--           7|2015|         43|         43|
--           5|2015|         44|         43|
--           6|2015|         44|         43|

```

**LAST_VALUE(), however, has an interesting case:**

```sql
/*
If you run it like below, it will find the last row between the start and the current row for each partition
*/
WITH temp1 AS (
	SELECT 1 customer_id, 2014 yr, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 2014 yr, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 2015 yr, 43 num_rentals
)
SELECT 
	customer_id,
	yr,
	num_rentals,
	LAST_VALUE(num_rentals) OVER (PARTITION BY yr ORDER BY num_rentals)
FROM temp1
-- customer_id|yr  |num_rentals|last_value|
-- -----------+----+-----------+----------+
--           4|2014|         44|        44|
--           2|2014|         45|        45|
--           3|2014|         45|        45|
--           1|2014|         46|        46|
--           7|2015|         43|        43|
--           5|2015|         44|        44|
--           6|2015|         44|        44|

/*
This is because by default, if you don't specify the range for the LAST_VALUE function, it runs the following: 
LAST_VALUE(num_rentals) OVER (PARTITION BY yr ORDER BY num_rentals RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
which exactly finds the last value in the range between the starting value and the current row's value.

Nevertheless, if you (as expected) want to find the last row in the range of starting value to the end value of a partition, 
you need to specify it in the range:
*/
WITH temp1 AS (
	SELECT 1 customer_id, 2014 yr, 46 num_rentals
	UNION ALL
	SELECT 2 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 3 customer_id, 2014 yr, 45 num_rentals
	UNION ALL
	SELECT 4 customer_id, 2014 yr, 44 num_rentals
	UNION ALL
	SELECT 5 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 6 customer_id, 2015 yr, 44 num_rentals
	UNION ALL
	SELECT 7 customer_id, 2015 yr, 43 num_rentals
)
SELECT 
	customer_id,
	yr,
	num_rentals,
	LAST_VALUE(num_rentals) OVER (PARTITION BY yr ORDER BY num_rentals RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM temp1
-- customer_id|yr  |num_rentals|last_value|
-- -----------+----+-----------+----------+
--           4|2014|         44|        46|
--           2|2014|         45|        46|
--           3|2014|         45|        46|
--           1|2014|         46|        46|
--           7|2015|         43|        44|
--           5|2015|         44|        44|
--           6|2015|         44|        44|
```

#### Sliding window

E.g. this leet code question: https://leetcode.com/problems/restaurant-growth/submissions/1649171860/?envType=study-plan-v2&envId=top-sql-50

Query below answer the question: 
- What is the cumulative sum of current day with the previous day for purchases? 
- What is the average purchase between each day and it's previous day? 

```sql
WITH temp1 AS (
  SELECT '2024-01-01' date, 10 purchase
  UNION ALL
  SELECT '2024-01-02' date, 50 purchase
  UNION ALL
  SELECT '2024-01-02' date, 50 purchase
  UNION ALL
  SELECT '2024-01-03' date, 60 purchase
  UNION ALL
  SELECT '2024-01-04' date, 70 purchase
  UNION ALL
  SELECT '2024-01-04' date, 10 purchase
), 
temp2 AS (
  SELECT 
    CAST(date AS date) AS date,
    purchase
  FROM temp1
)

SELECT 
  date,
  purchase,
  SUM(purchase) OVER (
    ORDER BY date 
    RANGE BETWEEN INTERVAL 1 DAY PRECEDING 
    AND CURRENT ROW 
  ) AS cumsum_prev_day,
  ROUND(
    AVG(purchase) OVER (
      ORDER BY date 
      RANGE BETWEEN INTERVAL 1 DAY PRECEDING 
      AND CURRENT ROW)
  , 2) AS cumavg_prev_day
FROM temp2
```

### Aggregate functions

Aggregate statements / functions can be used in two ways:
- Implicit groups: there is no GROUP BY clause, so all rows are considered
- Explicit groups: used with GROUP BY clause. You specify over which group of rows the aggregated functions should be applied.

> Note: aggregate functions such as AVG, MIN, and MAX cannot be used in a WHERE clause directly - they have to be wrapped in a subquery.

```sql
-- General form
-- On their own
SELECT 
  aggregate_function(column1) AS alias
FROM table1

-- With GROUP BY
SELECT 
  column1, 
  aggregate_function(column2)
FROM table1
GROUP BY column1;
```

#### COUNT

> Note: COUNT(*) counts all values including NULL; 
> 
> COUNT(column1), SUM(column1), MAX(column1), AVG(column1) count all values EXCEPT FOR NULL;


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
-- Count unique categories in a column
SELECT COUNT(DISTINCT sex) FROM employee;
SELECT COUNT(DISTINCT(sex)) FROM employee;
-- Equivalent of COUNTIF in excel
SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END)
```

#### SUM

```sql
-- SUM
-- Sum all values in a column
SELECT SUM(column1)
-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id FROM works_with GROUP BY emp_id;
```

#### MIN/MAX

```sql
-- MIN, MAX
-- Print the max value of column2
SELECT MAX(column1)
-- Select the earliest date for each 'player_id' category
SELECT 
  player_id, 
  MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id
-- Select the second highest salary in a table
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);
```

#### AVG

```sql
-- AVG
SELECT AVG(column1) 
```

#### GROUP BY 

> Note: you can either use WHERE or HAVING in GROUP BY for filtering. Please see the respective section for the differences.

Can be:
- Single-column grouping: `GROUP BY column1`
- Multicolumn grouping: `GROUP BY column1, column2`

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

-- You can also group based on values generated by expressions
SELECT
  EXTRACT(YEAR FROM rental_date) AS year,
  COUNT(*) AS how_many
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date)

-- WITH ROLLUP
-- also show total counts (shown as NULL) for each subgroup
-- is used in multicolumn grouping
SELECT 
	fa.actor_id,
	f.rating,
	COUNT(*)
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id 
GROUP BY fa.actor_id, f.rating WITH ROLLUP 
ORDER BY 1, 2;
-- below we can see that for actor_id=1, total count is 19, and it also shows subcounts for each rating for this actor_id
-- actor_id|rating|COUNT(*)|
-- --------+------+--------+
--         |      |    5462|
--        1|      |      19|
--        1|G     |       4|
--        1|NC-17 |       5|
--        1|PG    |       6|
--        1|PG-13 |       1|
--        1|R     |       3|
--        2|      |      25|
--        2|G     |       7|
--        2|NC-17 |       8|
--        2|PG    |       6|
--        2|PG-13 |       2|
--        2|R     |       2|

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

Example of GROUP_CONCAT (MySQL):
```sql
-- concatenate all rows in the column "last_name" with separator ', '
group_concat(last_name ORDER BY first_name SEPARATOR ', ')
```

### Statistics

#### Quantile

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
  -- BigQuery: calculate 10th and 90th percentile
	APPROX_QUANTILES(age, 100)[OFFSET(10)] AS percentile_10,
	APPROX_QUANTILES(age, 100)[OFFSET(90)] AS percentile_90
	-- PostgreSQL: calculate 10th, 50th, and 90th percentile, taking the value that exists in the dataset; 
	-- so if there's an even number of data points, it takes the lower middle value
	percentile_disc(0.1) WITHIN GROUP(ORDER BY age) AS percentile_10_disc,
	percentile_disc(0.5) WITHIN GROUP(ORDER BY age) AS percentile_50_disc,
	percentile_disc(0.9) WITHIN GROUP(ORDER BY age) AS percentile_90_disc,
  	-- PostgreSQL: find true quantiles
	-- if there's an even number of data points, takes the average of the middle two values
	percentile_cont(0.1) WITHIN GROUP(ORDER BY age) AS percentile_10_cont,
	percentile_cont(0.5) WITHIN GROUP(ORDER BY age) AS percentile_50_cont,
	percentile_cont(0.9) WITHIN GROUP(ORDER BY age) AS percentile_90_cont
FROM table1
GROUP BY 
	profession
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

### LIKE, REGEX

There are two ways of writing regular expressions in SQL:
- `LIKE`: simplified REGEXP; is not as powerful, but typically faster than regular expressions.
- `~` or `REGEXP`: True REGEXP

First, very basic regex functions `LEFT`:


**LEFT**

> Works for PostgreSQL, MySQL

```sql
-- Match last names that begin with 'Q'
WHERE LEFT(last_name, 1) = 'Q' 
-- Match last names that begin with 'Qu'
WHERE LEFT(last_name, 2) = 'Qu'
```


**LIKE**

> Works for MySQL, PostgreSQL

General form:
```sql
SELECT * 
FROM courses 
WHERE course LIKE '_lgorithms';
```

| Wildcard character | Meaning |
| --- | --- |
| `%` | any character, any number of times (including 0) |
| `_` | exactly 1 character |

These are used with the SQL keyword `LIKE`

```sql
-- Find any clients who are an LLC
client_name LIKE '%LLC';
-- Case insensitive
LOWER(client_name) LIKE 'david'
-- Find employees born in october
birth_date LIKE '____-10-%';

-- names starting with 'W'
LIKE 'W%'
-- the second letter is 'e'
LIKE '_e%'
-- values with a space in them
LIKE '% %'
-- Value ends with '.com'
LIKE '%.com';
-- last_name like MATTHEWS, WALTERS, WATTS
LIKE '_A_T%S'
-- negative LIKE
NOT LIKE '_lgorithms';
-- case-insensitive
ILIKE, NOT ILIKE

```


**REGEXP**

> MySQL: `REGEXP` ; PostgreSQL: `~`

```sql
SELECT * FROM table1 WHERE name ~ '^Grandfather.+|.+parents.+'
-- Entries start with a vowel
SELECT DISTINCT(CITY) FROM STATION WHERE CITY ~ '^[AEIOUaeiou].*';
SELECT DISTINCT(CITY) FROM STATION WHERE CITY REGEXP '^[aeiou]';
```


**CONTAINS_SUBSTR**

> Works only for BigQuery

```sql
SELECT *
FROM `database.countries`
WHERE CONTAINS_SUBSTR(country_name, 'rus')
-- will find rows which in column `country_name` have 'Cyprus', 'Belarus', 'Russia'
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

# Types of tables

Different types of tables:
- Permanent tables: created by the `CREATE TABLE` statement
- Derived (subquery-generated) tables: rows returned by a subquery and held in memory
- Temporary (volatile) tables: volatile data held in memory
- Virtual table (view): created using the `CREATE VIEW` statement



## Subquery

> a.k.a. subquery, nested query, inner query

- Subqueries are embedded within another SQL query (called the *containing statement*) and are used when the result of one query depends on that of the other; 
- Are powerful tools for performing complex data manipulations that require one or more intermediary steps
- **Scalar subqueries** are queries that only return a single value. More specifically, this means if you execute a scalar subquery, it would return one column value of one specific row. 
- **Non-scalar subqueries**, however, can return single or multiple rows and may contain multiple columns.


### Types of correlation

(depending on their relation to the containing query):
- Noncorrelated subqueries
- Correlated subqueries

**Noncorrelated subqueries**: 

<u>May be executed alone</u> and do not reference anything from the containing statement 

```sql
-- Find all cities that are not in India
SELECT 
  city_id, 
  city
FROM city
WHERE 
  country_id <> (
    SELECT
      country_id
    FROM country
    WHERE country = 'India'
  );
```

**Correlated subqueries**:

These subqueries reference one or more columns from the containing query statement

```sql

SELECT 
  с.first_name, 
  c.last_name 
FROM customer c
WHERE 20 = (
  SELECT count(*) 
  FROM rental r
  WHERE r.customer_id = c.customer_id
);


-- an operator that is used a lot for correlated subqueries is EXIST
-- find all clients who rented at least one movie before 25 may 2005
SELECT 
  с.first_name, 
  c.last_name
FROM customer c
WHERE EXISTS (
  SELECT 1 
  FROM rental r
  WHERE 
    r.customer_id = c.customer_id
  AND date(r.rental date) < '2005-05-25'
);

-- Correlated subquery that is used for changing the column last_update in the table 'customer'
UPDATE customer с
SET с.last_update = (
  SELECT max(г.rental_date) 
  FROM rental r
  WHERE r.customer_id = c.customer_id
);
```


> Note: a subquery can return multicolumn and multirow table:
```sql
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
```

### Types of location

**Types (depending on where / in which clause the subquery is located)**:
- SELECT subqueries
- FROM subqueries
- WHERE subqueries
- HAVING subqueries

**SELECT subqueries**

```sql
-- General Form
SELECT column1, column2, columnN,
(SELECT agg_function(column) FROM table WHERE condition)
FROM table
```

**FROM subqueries**

Subqueries in the FROM clause create a temporary table that can be used for the main query. This allows
the programmer to simplify the process by breaking the problem into smaller, more manageable parts.

This subquery's data is held in memory for the duration of the entire query and then discarded.

```sql
-- General form
-- This is the containing query
SELECT employee, total_sales
FROM (
  -- This is the subquery
  SELECT 
    first_name || ' ' || last_name AS employee, 
    SUM(sales) AS total_sales
  FROM sales
  GROUP BY employee
) AS sales_summary -- alias of the subquery
WHERE total_sales > 100000;
```

In this example, the subquery creates a temporary table aliased as `sales_summary`, which does the following:
- Concatenates each employee’s first and last name (separated by a space). This concatenation is aliased as employee.
- Calculates the total sales for each employee.
- Groups the total_sales by employee.

**WHERE subqueries**

Subqueries in the WHERE clause are used to filter rows based on conditions detailed in a subquery.

This method is useful when you don’t already have access to the condition on which you want to filter your query.

Scalar example: 
```sql
-- Suppose that we have a table called employees with employee_id, first_name, last_name, salary, and department_id columns. If we want to find all employees who earn more than the average salary, we can use a subquery:
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find all clients who are handled by the branch that Michael Scott manages
SELECT client.client_name
FROM client
WHERE branch_id = (
    SELECT employee.branch_id
    FROM employee
    WHERE employee.first_name = 'Michael' AND employee.last_name = 'Scott'
);
```

Non-scalar example:
```sql
-- Suppose that we are using the same dataset as before with the first_name, last_name, and salary fields. We want to return the first name, last name, and salary of employees whose first name begins with the letter 'J':
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE first_name LIKE 'J%');

-- Find names of all employees who have sold over 30,000 to a single client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);
```

**HAVING subqueries**

The HAVING clause is used to filter the results of a GROUP BY query based on conditions involving
aggregate functions. The subquery is executed for each group and filters the groups based on the
specified condition.

```sql
SELECT CustomerID, AVG(TotalAmount) AS AverageTotalAmount
FROM Orders
GROUP BY CustomerID
HAVING AVG(TotalAmount) > (SELECT AVG(TotalAmount)
FROM Orders);
```

## CTE

CTE, common table expressions
- CTEs are, in a sense, are like *named subqueries*
- They make a query more readable and allow each CTE communicate / query other CTEs, as opposed to (nested) subqueries. 


CTEs are also temporary tables typically that are formulated at the beginning of a
query and only exist during the execution of the query. This means that CTEs cannot be used in other
queries beyond the one in which you are using the CTE.
While CTEs and subqueries are both used in similar circumstances (such as when you need to produce
an intermediary result), there are a couple of factors that tip off CTEs:
• They are typically created at the beginning of a query using the WITH operator
• They are followed by a query that queries the CTE
Alternatively, subqueries are a query within a query, nested within one of a query’s clauses.

```sql
WITH 
alias AS (
  -- <Put query here>
), 
alias2 AS (
  -- <put query here>
)
-- ... <Query that queries the alias>
SELECT *
FROM alias
INNER JOIN alias2 
ON alias.id = alias2.id

-- A more concrete example
WITH customer_totals AS (
  SELECT CustomerID, SUM(TotalAmount) AS total_sales
  FROM Orders
  GROUP BY CustomerID
)
SELECT c.CustomerID, c.total_sales, o.avg_order_amount
FROM customer_totals c
JOIN (
  SELECT CustomerID, AVG(TotalAmount) AS avg_order_amount
  FROM Orders GROUP BY CustomerID )
ON c.CustomerID = o.CustomerID;

-- an example
WITH actors_s AS (
  SELECT 
    actor_id, 
    first_name, 
    last_name
  FROM actor
  WHERE last name LIKE 'S%'
),
actors_s_pg AS (
  SELECT 
    s.actor_id, 
    s.first_name, 
    s.last_name,
    f.film_id, 
    f.title
  -- this CTE references another CTE actors_s
  FROM actors_s s
  INNER JOIN film_actor fa
  ON s.actor_id = fa.actor__id
  INNER JOIN film f
  ON f.film_id = fa.film_id
  WHERE f.rating = 'PG'
),
actors_s_pg_revenue AS (
  SELECT spg.first_name, spg.last_name, p.amount
  FROM actors_s_pg spg
  INNER JOIN inventory i
  ON i.film_id = spg.film_id
  INNER JOIN rental r
  ON i.inventory_id = r.inventory_id
  INNER JOIN payment p
  ON r.rental_id = p.rental_id
) -- end of the WITH statement
SELECT 
  spg_rev.first_name, 
  spg_rev.last_name,
  sum(spg_rev.amount) tot_revenue
FROM actors_s_pg_revenue spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 desc;
```

```sql
-- Example
WITH a1 AS (
	SELECT
		bs.branch_id,
		bs.branch_name,
		COUNT(bs.mgr_id)
	FROM employees_db.public.branch bs
	INNER JOIN employees_db.public.branch_supplier bs2 
	ON bs.branch_id = bs2.branch_id 
	
	GROUP BY 
		bs.branch_id, 
		bs.branch_name
)
SELECT * FROM a1
```

## Temporary tables

The tables appear like permanent tables, but any data inserted into this table will disappear at some point, e.g. at the end of a transaction or when the database connection session is closed.

```sql
-- MySQL
CREATE TEMPORARY TABLE temp1
(
  person_id SMALLINT(5),
  first_name VARCHAR(45),
  last_name VARCHAR(45)
);
INSERT INTO temp1
SELECT actor_id, first_name, last_name
FROM table1
WHERE last_name LIKE '%J';
```

## Views

A view is a mechanism for querying data; a query that is stored in the data dictionary.
- A view is created by assigning a name to a SELECT statement and then storing the query for future use;
- It looks and acts like a table, but there is no data associated with a view; when you issue a query against a view, your query is merged with the view definition to create a final query to be executed
- Example: you can save a table view upon running the inner join command, and then perform actions on that view table to not type in the join command over and over again. 

Uses and advantages:
- Data Security: 
  - You can keep the table private (users don't have SELECT permission to the table) but create one or more views that obscure the private / sensitive information;
- Data Aggregation:
  - Views can join and simplify multiple tables into a single virtual table;
  - Views can act as aggregated tables
- Hiding Complexity:
  - Views can hide the complexity of data
  - E.g. you can have a view with tons of subqueries, joins, etc. but they are hidden from the end user



After you create a view, it shows in the list of tables using the command `\d`. Nevertheless, this view is not a table; it simply is a result of a saved query. 

```sql
-- Create a view of a table
CREATE VIEW table1_view_males AS 
SELECT * FROM table1 WHERE gender = 'Male';

-- Show a table view
SELECT * FROM table1_view_males;

-- Update a view
CREATE OR REPLACE VIEW view1 AS ...;

-- Delete a view
DROP VIEW view1;
```

A more practical example
```sql
-- Let's say you have a join query
SELECT table1.first_name, table1.gender, table1.age, table2.item 
FROM table1 
INNER JOIN table2 ON table1.first_name = table2.first_name;

-- If you want to make an operation on it, instead of writing it out every time, you can save it as a view and then perform that action on the view of the table
CREATE VIEW table1_table2_innerjoin AS 
SELECT table1.first_name, table1.gender, table1.age, table2.item 
FROM table1 
INNER JOIN table2 ON table1.first_name = table2.first_name;

-- So now, you can perform operations on that view object you created, 
# for example, you can count rows
SELECT COUNT(*) FROM table1_table2_innerjoin;
```

Another example - you want to define a view that partially hides the email:
```sql
-- define a view
CREATE VIEW customer_vw (
  customer_id,
  first_name,
  last_name,
  email
) AS
SELECT 
  customer_id,
  first_name,
  last_name,
  -- partially obstruct the emails - only show first two letters, then '*****', ended by the last four letters
  concat(substr(email,1,2), '*****', substr(email, -4)) AS email
FROM customer
-- only show active customers
WHERE active = 1
;

-- query a view just like you would a table
SELECT 
  first_name,
  last_name, 
  email
FROM customer_vw;
```

Maybe slighly counterintuitive, but you can modify a table that is used in the view as long as some conditions are met:
- No aggregate functions are used
- The view does not employ GROUP BY or HAVING clauses;
- No subqueries exist in the SELECT or FROM clause, and any subqueries in the WHERE clause do no refer to tables in the from clause
- The view does not utilize UNION, UNION ALL, or DISTINCT
- The FROM clause includes at least one table or updatable view
- The FROM clause uses only innner joins if there is more than one table or view

For example, in the view below:
- You can modify last_name
- you CANNOT modify email since it is derived from an expression
- you CANNOT insert new rows as you have a derived column `email`
```sql
CREATE VIEW customer_vw (
  customer_id,
  first_name,
  last_name,
  email
) AS
SELECT 
  customer_id,
  first_name,
  last_name,
  concat(substr(email,1,2), '*****', substr(email, -4)) AS email
FROM customer
;
```

# Conditional logic

## CASE WHEN

Creating a new column / field based on a condition for the other columns. 

> In SQL, conditional logic is executed by the `case` expression, which can be used in SELECT, INSERT, UPDATE, and DELETE statements.

Features:
- In the CASE expression, the clauses are evaluated from top to bottom in order
- CASE expressions may return any type of expression, including subqueries

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
    WHEN 90 <= (SELECT datediff(now(), max(rental_date))
                FROM rental r
                WHERE r.customer_id = customer.customer_id) 
    THEN 0
    ELSE 1
    END
WHERE active = 1;
```


# Constraints

Constraints are a restriction placed on one or more columns of a table.

**Check all constraints for database `database1`, table `favorite_food`**
```sql
-- MySQL
SELECT * FROM information_schema.TABLE_CONSTRAINTS 
WHERE 
	CONSTRAINT_SCHEMA = 'database1'
	AND TABLE_NAME = 'favorite_food';
```

Constraints can be created at the time of creation of the associated table:
```sql
-- example for MySQL table
CREATE TABLE customer (
  customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  store_id TINYINT UNSIGNED NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  -- primary key constraint
  PRIMARY KEY (customer_id),
  -- indexes
  KEY idx_fk_store_id (store_id),
  KEY idx_fk_address_id (address_id),
  KEY idx_last_name (last_name),
  -- foreign key
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
    REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

## Primary key

Primary key:
- Serves as a **unique identifier** for each record in a table;
- IOW, it is an entry into the `Primary key` column that **inequivocally (uniquely)** identify each one row in a table, i.e. an ID for each data point / row.
- Features:
  - `Null` values are not accepted. 
  - Are indexed automatically.
  - If you manually tried inserting a row with a primary key that already exists in the table, it would lead to an error, as no duplicate primary keys are allowed;
  - By definition, primary key has two constraints - NOT NULL and UNIQUE;

An example of a column `person_id` that is a primary key:
```txt
<!-- MySQL -->
Field      |Type                |Null|Key|Default|Extra         |
-----------+--------------------+----+---+-------+--------------+
person_id  |smallint unsigned   |NO  |PRI|       |auto_increment|

<!-- PostgreSQL -->
   Column    |         Type          | Collation | Nullable |                  Default
-------------+-----------------------+-----------+----------+-------------------------------------------
 person_id   | integer               |           | not null | nextval('person_person_id_seq'::regclass)
```

**Create a column with primary key that you manually have to enter**:
```sql
-- NOTE: NOT A GOOD PRACTICE, but an example
-- PostgreSQL
CREATE TABLE sounds (sound_id INT PRIMARY KEY);
```

**Create a table with PRIMARY KEY constraint**
```sql
-- You can create a table with a column with PRIMARY KEY constraint. 
-- As it is also a  SERIAL, you don't need to specify it when inserting new rows - it will be created automatically as per the internal rules:

-- PostgreSQL
CREATE TABLE sounds (
  sound_id SERIAL PRIMARY KEY
);
-- alternatively, can use:
-- BIGSERIAL NOT NULL PRIMARY KEY; 

-- MySQL
-- can be SMALLINT or INT
CREATE TABLE person (
  person_id SMALLINT UNSIGNED AUTO_INCREMENT,
  PRIMARY KEY (person_id)
);
-- or if you want to name the constraint
CREATE TABLE person (
  person_id SMALLINT UNSIGNED AUTO_INCREMENT,
  CONSTRAINT pk_person PRIMARY KEY (person_id)
);
```

**Set a column as a primary key**
```sql
-- PostgreSQL
-- Add a column and set it as primary key
ALTER TABLE moon ADD COLUMN moon_id SERIAL PRIMARY KEY;
-- or in two steps
ALTER TABLE table_name ADD COLUMN column1 SERIAL;
ALTER TABLE table1 ADD PRIMARY KEY (column1);
```



If you want to alter the primary key, you can do it like this. Check first the details of a table:
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

## Composite primary key 

**Upon creation of the table**
```sql
-- MySQL
CREATE TABLE table1(
  person_id SMALLINT UNSIGNED,
  food VARCHAR(20),
  CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food)
);
```

**Set few columns**
```sql
-- PostgreSQL
-- Uses more than one column as a unique pair. 
ALTER TABLE table_name ADD PRIMARY KEY(column1, column2); 
```

## Foreign key

A foreign key:
- Field in a table that references the primary key of another table
- Makes a connection between two tables via their joint column. 
- Enforce data integrity, making sure the data confirms to some rules when it is added to the DB. More specifically, it *restricts one or more columns to contain only values found in another table's primary key columns.*; thus it prevents *orphaned rows* - rows that no longer point to valid primary key (e.g. changing a customer's ID in the `customer` table without changing the same customer ID in the `rental` table);
- It is NOT necessary to have a foreign key constraint in place in order to join two tables
- A table might include a *self-referencing foreign key*, which means that it includes a column that points to the primary key within the same table; for example, a table about movies, where each movie has a `film_id`, can contain column `prequel_film_id` which points to the film's parent `film_id`

`ON` clauses in the foreign key constraint:
- ON DELETE SET NULL: if in the table 1 a row is deleted, then in the table 2 that references that first table via foreign key the corresponding value is set to NULL;
- ON DELETE CASCADE: if the row in the original table containing an id is deleted, then in a table referencing that table via a foreign key the entire row is deleted. 
- ON DELETE RESTRICT: 
  - will cause the server to raise an error if a row is attempted to be deleted in the parent table that is referenced in the child table;
  - protects against orphaned records when rows are deleted from the parent table;
- ON UPDATE CASCADE: 
  - will cause the server to propagate a change to the primary key value of a parent (referenced) table with a primary key to the child table;
  - also protects against orphaned records when a primary key value is updated in the parent table;
- ON UPDATE RESTRICT
- ON UPDATE SET NULL

**Create foreign key upon creation of the table**
```sql
-- PostgreSQL
CREATE TABLE user_profiles (
  profile_id INT PRIMARY KEY,
  user_id INT UNIQUE,
  profile_data VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES users(user_id) -- ON DELETE SET NULL --or-- ON DELETE CASCADE
);

-- MySQL
-- Foreign key person_id in table favorite_food that references another table's person.person_id
CREATE TABLE favorite_food (
  person_id SMALLINT UNSIGNED,
  CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) REFERENCES person (person_id) 
);

```

```sql

-- Create a new column with  the constraint of foreign key
ALTER TABLE more_info 
ADD COLUMN character_id INT 
REFERENCES characters(character_id);

-- You can set an existing column as a foreign key like this:
-- PostgreSQL
ALTER TABLE table_name 
ADD FOREIGN KEY(column_name) 
REFERENCES referenced_table(referenced_column)
ON DELETE SET NULL -- optional option
;
-- MySQL
ALTER TABLE customer
ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id) -- add a foreign key on column address_id
  REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE; -- that will reference a parent table address, column address_id, and if from address.address_id a row is attempted to be removed, an error is raised

ALTER TABLE rental 
ADD CONSTRAINT fk_1 FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON DELETE RESTRICT;

-- remove a constraint
ALTER TABLE customer
DROP CONSTRAINT -- ...o9i
```

## UNIQUE

Restricts the specified column to contain unique values within it. Values in this column must be unique for each data point. Makes sure that only unique values can be added in a column

> You should not build unique indexes / constraints on your primary key column(s), since the server already checks uniqueness for primary key values.

```sql
ALTER TABLE table1 ADD CONSTRAINT constraint_name_here UNIQUE (column1) -- Custom constraint name
-- or
ALTER TABLE table1 ADD UNIQUE (column1) -- Constraint name defined by psql

-- Create unique index on the `customer.email` column
-- MySQL
ALTER TABLE customer
ADD UNIQUE idx_email (email);

-- SQL server, Oracle database
CREATE UNIQUE INDEX idx_email
ON customer (email);
```

## CHECK

> Check works for PostgreSQL; 
> 
> Enum - for MySQL (I think)

Restricts the allowable values for a column. Thus, a column can only accept specific values

```sql
ALTER TABLE table1 
ADD CONSTRAINT constraint_name CHECK (column1='Male' OR column1='Female');

-- Other examples
-- check the minimum length of a login field
CONSTRAINT login_min_length CHECK (char_length(login) >= 3) 
-- check constraints that only three values are possible for this column
eye_color CHAR(2) CHECK (eye_color IN ('BR', 'BL', 'GR'))
```

MySQL:
```sql
eye_color ENUM('BR', 'BL', 'GR'),                    -- Eye color
```

## DEFAULT

Sets a default value for each row in a column. If no value is provided for this column, set a default value. 

```sql
DEFAULT NOW()
DEFAULT 'string here'
```

## others

| Constraint | Meaning |
| --- | --- |
| **NOT NULL** | Values in this column have to be present, i.e. cannot be `NULL` |
| **DEFAULT** | Sets a default value for each row in a column |
| **PRIMARY KEY** | Makes a specified column a `PRIMARY KEY` type. |
| **FOREIGN KEY** | Makes a specified column an external key. E.g. `constraint user_uuid_foreign_key foreign key (user_uuid) references users (uuid) on update cascade on delete cascade` - обязывает содержать значение в user_uuid только для существующей записи в таблице users и автоматически обновится если оно будет изменено в таблице users, а так же заставит запись удалиться при удалении записи о пользователе |
| **REFERENCES table(column)** | Make a foreign key referencing another table |

Examples:
```sql
-- Add a NOT NULL constraint to the foreign key column, so that there will be no Null rows
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;
```


DEFAULT - specify a default value for a column
```sql
CREATE TABLE table1 (column1 INT DEFAULT 'undecided')
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

```sql
-- AUTO_INCREMENT
-- Makes a column automatically populate with incrementing values (starting with 1) upon inserting new rows
```sql
-- MySQL
CREATE TABLE person (
  person_id SMALLINT UNSIGNED,
  PRIMARY KEY (person_id)
);
SET foreign_key_checks=0;
ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;
SET foreign_key_checks=1;
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

| Type | Explanation |
| - | - |
| Inner Join | Returns records with matching values in both tables. |
| Left (outer) join | Returns all records from the left table and the matched records (or NULL for non-matched records) from the right table. |
| Right (outer) join | The opposite of left outer join. |
| Full (outer) joint | Returns all records, with non-matching records having NULL. |

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

## Right (outer) join

All rows from the second / right table + the rows that match the rows from the second table .

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

# Pivot

## Wide -> long

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


## Long -> wide

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

A SQL transaction is a sequence of database operations that behave as a single unit of work. It ensures that multiple operations are executed in an atomic and consistent manner, which is crucial for maintaining database integrity. SQL transactions adhere to a set of principles known as ACID.

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
- **Banking and financial systems**: Managing accounts, deposits, withdrawals, and transfers require transactions for ensuring data integrity and consistency while updating account balances and maintaining audit trails of all transactions.
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
- Database writers request and receive from the server a write lock to modify data, *and database readers must request and receive from the server a read lock to query data*; One write lock is given out at a time for each table (or portion) and read requests are blocked until the write 
- **Versioning approach:** database writers request and receive from the server a write lock to modify data, *but readers do not need any type of lock to query data*. Instead, the server ensures that a reader sees a consistent view of the data from the time their query begins until their query has finished. 

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

# Metadata

Metadata - data about data.

Data dictionary / system catalog - data about tables:
- table name
- table storage information (tablespace, initial size, etc.)
- storage engine
- column names
- column data types
- default column values
- not null column constraints
- primary key columns
- primary key name
- name of primary key index
- foreign key name and columns

in MySQL, `information_schema` is used to publish metadata. All objects within the `information_schema` database are views that, unlike `describe`, can be queried. 

Views within the `information_schema` database:
| View name | Provides information about ... |
| - | - |
| `schemata` | Databases |
| `tables` | Tables and views |
| `columns` | Columns of tables and views |
| `statistics` | Indexes |
| `user_privileges` | Who has privileges on which schema objects |
| `schema_privileges`, `table_privileges`, `column_privileges` | Who has privileges on which databases, tables, or columns of which tables |
| `character_sets` | What character sets are available |
| `collations` | What collations are available for which character sets |
| `collation_character_set_applicability` | Which character sets are available for which collation |
| `table_constraints` | The unique, foreign key, and primary key constraints |
| `key_column_usage` | The constraints associated with each key column |
| `routines` | Stored routines (procedures and functions) |
| `views` | Views |
| `triggers` | Table triggers |
| `plugins` | Server plug-ins |
| `engines` | Available storage engines |
| `partitions` | Table partitions |
| `events` | Scheduled events |
| `processlist` | Running processes |
| `referential_constraints` | Foreign keys |
| `parameters` | Stored procedure and function parameters |
| `profiling` | User profiling information |

Examples:

```sql
-- show info about tables and views
SELECT table_name, table_type
FROM information_schema.tables
WHERE
	-- 'sakila' schema / database
	table_schema = 'sakila'
	-- exclude the views, showing only tables
	AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- show info only about views
SELECT table_name, is_updatable
FROM information_schema.views
WHERE table_schema = 'sakila'
ORDER BY table_name;

-- column information for both tables and views
SELECT 
	column_name,
	data_type,
	character_maximum_length AS char_max_len,
	numeric_precision AS num_prcsn,
	numeric_scale AS num_scale
FROM information_schema.columns
WHERE 
	table_schema = 'sakila'
	AND table_name = 'film'
-- 'ordinal_position' - to retrieve the columns in the order in which they were added to the table
ORDER BY ordinal_position;

-- get info about indexes for database 'sakila', table 'rental'
SELECT 
	index_name,
	non_unique,
	seq_in_index, 
	column_name
FROM information_schema.statistics
WHERE 	
	table_schema = 'sakila'
	AND table_name = 'rental'
ORDER BY index_name, seq_in_index;

-- show constraints
SELECT 
	constraint_name,
	table_name,
	constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'sakila'
ORDER BY constraint_type, constraint_name;
```

# Index

Index is a mechanism for quickly finding a specific item within a resource.

The role of indexes is to facilitate the retrieval of a subset of a table's rows and columns without the need to inspect every row in the table.

Show indexes: `SHOW INDEX FROM customer;`

```sql
-- Add an index called `idx_email` on the `customer.email` column
-- MySQL
ALTER TABLE customer
ADD INDEX idx_email (email);
-- Others
CREATE INDEX idx_email
ON customer (email);

-- Drop an index
-- MySQL
ALTER TABLE customer
DROP INDEX idx_email;
-- Others
DROP INDEX idx_email;
-- or
DROP INDEX idx_email ON customer;
```

Index can be multicolumn if you query data based on multiple columns.

E.g. if you search for customers by first and last names, you can build a multicolumn index:
```sql
ALTER TABLE customer
ADD INDEX idx_full_name (last_name, first_name);
```

<u>Types of indexes</u>:
- **B-tree indexes**: balanced-tree indexes;
  - Branch nodes are used for navigating the tree, while leaf nodes hold the actual values and location information;
  - Example of a B-tree index built on the customer.last_name column
  ![alt text](image-1.png)
  - As more and more rows are added to the table, the server will attempt to keep the tree balanced so that there aren't far more branch/leaf nodes on one side of the root node than the other; by keeping the tree balanced, the server is able to traverse quickly to the leaf nodes to find the desired values without having to navigate through many levels of branch nodes;
  - Great at handling columns that contain many different values, e.g. a customer's first or last names
- **Bitmap indexes**: 
  - Generate a bitmap for each value stored in the column
  - Bitmap indexes are a nice, compact indexing solution for columns with a small number of unique values
  - `CREATE BITMAP INDEX idx_active ON customer (active);`
  - Commonly used in warehousing environments, where large amounts of data are generally indexed on columns containing relatively few unique values;
- **Text indexes** / full-text indexes
  - If your database stores documents and the user wants to search for words or phrases in the document

Index disadvantages:
- Index is a table, so having lots of indexes can slow the database down
- Indexes require disk space

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

# Tasks

## JOINS

![alt text](Media/image-3.png)

![alt text](Media/image-4.png)

![alt text](Media/image-5.png)

![alt text](Media/image-6.png)

