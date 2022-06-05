# SQL-handbook

## Most basic information

**Types of databases**:
- SQL (relational databases): MySQL, PostreSQL, SQLite, Microsoft SQL Server, MariaDB, Oracle; 
  - *In a relational database, there are relationships between tables.* 
- NoSQL (not only SQL; can also structure in non-structured data): MongoDB, Redis, Firebase, DynamoDB, Cassandra; 

Datatypes: 
- `DATE`
- `INT`
- `SERIAL`
- `VARCHAR(30)` - short string of characters of specified length
- `NUMERIC(4, 1)`

Basic commands: 
| Command | Function |
| --- | --- |
| `\l` | list databases |
| `\c database_name` | connect to a database |
| `\d` | check which tables are present |
| `\dt` | show tables ONLY, without `id_seq` |
| `\d second_table` | check columns and details of a table in a database |

## Database

- `CREATE DATABASE database_name;`
- `DROP DATABASE second_database;` delete a database
- `ALTER DATABASE first_database RENAME TO mario_database;` rename a database


## Create a table**
```sql
CREATE TABLE tableName(columnName DATATYPE CONSTRAINTS);
```
Constraints: 
- `NOT NULL`
- `PRIMARY KEY`
- `BIGSERIAL` - integer that auto-increments; 

Examples: 
- `CREATE TABLE table_name();`
- `CREATE TABLE table1(id INT, firstName VARCHAR(50), lastName VARCHAR(50));
- `CREATE TABLE sounds(sound_id SERIAL PRIMARY KEY);`
- `CREATE TABLE table1 (id BIGSERIAL NOT NULL PRIMARY KEY, first_name VARCHAR(50) NOT NULL, gender VARCHAR(7) NOT NULL, date_of_birth DATE NOT NULL, email VARCHAR(150) );`

## Alter a table
- `DROP TABLE second_table;` remove a table
- `ALTER TABLE table_name ADD COLUMN column_name DATATYPE;`
- `ALTER TABLE characters ADD COLUMN character_id SERIAL;`
- `ALTER TABLE characters ADD COLUMN name VARCHAR(30) NOT NULL;` max length = 30
- `ALTER TABLE sounds ADD COLUMN character_id INT NOT NULL REFERENCES characters(character_id);`
- `ALTER TABLE second_table DROP COLUMN age;` delete a column
- `ALTER TABLE second_table RENAME COLUMN name TO username;` rename a column
- `DELETE FROM second_table WHERE username='Luigi';` from a table, delete row where username='Luigi'
- `ALTER TABLE second_table DROP COLUMN username;`
- `ALTER TABLE characters ADD PRIMARY KEY(name);` set column to primary key (unique identifier)
- `ALTER TABLE characters DROP CONSTRAINT characters_pkey;` drop constraint to primary key
- `ALTER TABLE table_name ADD COLUMN column_name DATATYPE REFERENCES referenced_table_name(referenced_column_name);` to set a foreign key that references a column from another table
- `ALTER TABLE table_name ADD UNIQUE(column_name);` add UNIQUE constraint to the foreign key
- `ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;` Add NOT NULL constraint to foreign key column, so that there will be no rows for nobody
- `ALTER TABLE more_info RENAME COLUMN height TO height_in_cm;` rename column in a table
- `ALTER TABLE table_name ADD FOREIGN KEY(column_name) REFERENCES referenced_table(referenced_column);` set an existing column as a foreign key
- `ALTER TABLE character_actions ADD FOREIGN KEY(character_id) REFERENCES characters(character_id);`
- `ALTER TABLE table_name ADD PRIMARY KEY(column1, column2);` create composite primary key (primary key from two columns)


**Add rows**
```sql
INSERT INTO tablename (column1, column2, column2) VALUES ('Value1', 52, DATE '1995-05-04');
```

- `INSERT INTO second_table(id, username) VALUES(1, 'Samus');` insert a row into our table
- `INSERT INTO characters(name, homeland, favorite_color) VALUES('Mario', 'Mushroom Kingdom', 'Red');`
- `INSERT INTO characters(name, homeland, favorite_color) VALUES('Toadstool', 'Mushroom Kingdom', 'Red'), ('Bowser', 'Mushroom Kingdom', 'Green');` insert two rows at once
- `INSERT INTO more_info(birthday, height, weight, character_id) VALUES('1981-07-09', 155, 64.5, 1);` DATE: 'YYYY-MM-DD'
- `INSERT INTO more_info(birthday, height, weight, character_id) VALUES('1989-07-31', NULL, NULL, 6);`

**Update rows**
- `UPDATE tablename SET column=3 WHERE row="RowName"`

## Filter
- `SELECT column FROM table_name;`
- `SELECT * FROM table_name;` view table_name
- `SELECT * FROM characters ORDER BY character_id;` view the whole table ordered by 'character_id'
- `SELECT character_id, name FROM characters WHERE name='Toad';` only view the rows of 'Toad'
- `SELECT name, population, area FROM World WHERE area >= 3000000 OR population >= 25000000;`
- `SELECT name FROM Customer WHERE referee_id != 2 OR referee_id IS null;`

