
# Query optimisation

BigQuery:
- Stores data as a columnar data structure;

Optimising query cost:
- As it is a columnar database, `SELECT *` is the most expensive way to query data; so, **specify the exact columns you need** instead of using the wildcard `*` operator
- In partitioned and clustered tables, use `WHERE` on such columns


