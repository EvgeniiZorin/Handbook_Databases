SELECT
    column1,
    column2,
    keep
FROM db1.table1
WHERE
    column1 IN ('a', 'b', 'c')
    AND keep = 1
