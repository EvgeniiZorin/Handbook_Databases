# SQL-handbook

## Most basic information

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
| `\d second_table` | check columns and details of a table in a database |

## Database

`CREATE DATABASE database_name;`

## Table

**Create a table**
- `CREATE TABLE table_name();`
- `CREATE TABLE table_name(column_name DATATYPE CONSTRAINTS);` create table with columns
- `CREATE TABLE sounds(sound_id SERIAL PRIMARY KEY);`

**Alter a table**
- `ALTER TABLE table_name ADD COLUMN column_name DATATYPE;`
- `ALTER TABLE characters ADD COLUMN character_id SERIAL;`
- `ALTER TABLE characters ADD COLUMN name VARCHAR(30) NOT NULL;` max length = 30
- `ALTER TABLE sounds ADD COLUMN character_id INT NOT NULL REFERENCES characters(character_id);`
- `ALTER TABLE second_table DROP COLUMN age;` delete a column
- `ALTER TABLE second_table RENAME COLUMN name TO username;` rename a column


