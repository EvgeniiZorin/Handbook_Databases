# Handbook_Databases

*Ver 3.0.0*

> This is a practical handbook outlining the most important concepts and commands in SQL and noSQL databases. When writing this material, I intended it to be a hands-on manual on how to achieve a specific objective in querying databases, rather than to be an exhaustive piece of writing about every aspect of the language.
>
> Evgenii Zorin

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

I have Markdown documents with commands for [SQL](SQL.md) and [noSQL](noSQL.md).

# Classifications

SQL - structured query language. 

**SQL / relational databases**:
- Relational database management systems (RDBMSs) (there are relationships between tables): use SQL to store and retrieve data and store data in rows and columns.
- In RDBMSs, information from various tables is connected with keys (primary, foreign keys) 
- Examples: MySQL, PostgreSQL, SQLite, Microsoft SQL Server, MariaDB, Oracle
- Allows users to query, insert, delete, and update records in relational databases
- Uses:
  - Suitable for structured data with predefined schema
- Advantages:
  - More advantageous if if your application requires complex data queries and transactional support.
  - Perfect for complex queries - supports complex queries
- Disadvantages:
  - SQL can be too restrictive with data schema: You have to use predefined schemas to determine your data structure before you can work with it. All of your data must follow the same structure, and this process requires significant upfront preparation. If you ever need to change your data structure, it would be difficult and disruptive to your whole system. 

**NoSQL**:
- NoSQL (not only SQL; can also structure in non-structured data)
- It is a type of database that uses non-relational data structures, such as documents, graph databases, and key-value stores to store and retrieve data. NoSQL systems are designed to be more flexible than traditional relational databases and can scale up or down easily to accommodate changes in usage or load.
- Examples:
  - MongoDB: document-oriented database that uses JSON-like documents with optional schemas
  - ArangoDB: free, open-source multi-model (can be used as document DB, key-value store, or graph DB) database. Uses AQL (ArangoDB Query Language)
  - Redis, Firebase, DynamoDB, Cassandra
- Uses:
  - Suitable for unstructured and semi-structured data
- Advantages:
  - Offers more flexibility and scalability. Allows fast prototyping, without worrying about the underlying data storage implementation. |
- Disadvantages:
  - Does not support complex queries;
  - Does not support JOIN operations;

