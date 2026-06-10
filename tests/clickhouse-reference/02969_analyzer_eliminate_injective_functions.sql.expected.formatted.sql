SET enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT
    toString(toString(number + 1)) AS val,
    count()
FROM numbers(2)
GROUP BY val
ORDER BY val ASC;

SELECT
    toString(toString(number + 1)) AS val,
    count()
FROM numbers(2)
GROUP BY ALL
ORDER BY val ASC;

EXPLAIN QUERY TREE
SELECT
    toString(toString(number + 1)) AS val,
    count()
FROM numbers(2)
GROUP BY ALL
ORDER BY val ASC;

EXPLAIN QUERY TREE
SELECT
    toString(toString(number + 1)) AS val,
    count()
FROM numbers(2)
GROUP BY val
WITH TOTALS
ORDER BY val ASC;

SELECT
    toString(toString(number + 1)) AS val,
    count()
FROM numbers(2)
GROUP BY val
WITH TOTALS
ORDER BY val ASC;