SELECT column1, column2, keep, CASE WHEN surname IS NULL THEN 'Unknown' ELSE surname END AS surname
FROM db1.table1
WHERE column1 IN ('a', 'b', 'c')
AND keep = 1
;