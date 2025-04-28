

There are different ways to lint SQL.

# SQLFluff

- It is a pip package that runs as a CLI tool; 
- Website: https://sqlfluff.com/
- Documentation: https://docs.sqlfluff.com/en/stable/gettingstarted.html#basic-usage

```bash
# just check and show mistakes to correct
sqlfluff lint query1.sql --dialect ansi
# actually fix the sql 
sqlfluff fix query1.sql --dialect ansi
```

Useful dialects:
- `ansi` - generic SQL
- `bigquery` - for Google / GCP BigQuery
