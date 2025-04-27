

There are different ways to lint SQL.

# SQLFluff

https://sqlfluff.com/

pip package.

Documentation: https://docs.sqlfluff.com/en/stable/gettingstarted.html#basic-usage

```bash
# just check and show mistakes to correct
sqlfluff lint query1.sql --dialect ansi
# actually fix the sql 
sqlfluff fix query1.sql --dialect ansi
```

