

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
# if you ran the sqlfluff fix command, but it shows you errors but says
# "no fixable linting violations found", you can check if parsing was successful:
sqlfluff parse query1.sql --dialect bigquery
# fix the parsing error if it was present,
# then fix again
```

Useful dialects:
- `ansi` - generic SQL
- `bigquery` - for Google / GCP BigQuery


You can specify configurations in the `.sqlfluff` file: 

```sqlfluff
; You can check all the available rules in the official documentation:
; https://docs.sqlfluff.com/en/stable/reference/rules.html

[sqlfluff]
dialect = bigquery

[sqlfluff:rules:capitalisation.keywords]
capitalisation_policy = upper
; [sqlfluff:rules:capitalisation.identifiers]
; extended_capitalisation_policy = lower
; [sqlfluff:rules:capitalisation.functions]
; extended_capitalisation_policy = lower
; [sqlfluff:rules:capitalisation.literals]
; capitalisation_policy = lower
; [sqlfluff:rules:capitalisation.types]
; extended_capitalisation_policy = lower

[sqlfluff:layout:type:join_clause]
line_position = alone

[sqlfluff:layout:type:join_on_clause]
line_position = alone

[sqlfluff:indentation]
; indented_joins = true
indented_on_contents = true
```
