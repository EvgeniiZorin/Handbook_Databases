
In BigQuery, it doesn't cost you to create tables. It DOES, however, cost to store and query data. 
- Price per storage: https://cloud.google.com/bigquery/pricing#storage - it's approximately in the ballpark of 20 USD per terabyte per month

# Query optimisation

BigQuery:
- Stores data as a columnar data structure;

Optimising query cost:
- As it is a columnar database, `SELECT *` is the most expensive way to query data; so, **specify the exact columns you need** instead of using the wildcard `*` operator
- In partitioned and clustered tables, use `WHERE` on such columns


Create a partitioned / clustered table:

```sql
CREATE TABLE temp.ez_temp1 (
    id int64,
    year int64
)
PARTITION BY (year)
CLUSTER BY (id)
AS 
SELECT 1 AS id, 2023 AS year
UNION ALL
SELECT 2 AS id, 2023 AS year 
```
