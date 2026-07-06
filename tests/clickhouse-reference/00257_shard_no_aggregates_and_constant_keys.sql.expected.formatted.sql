-- Tags: shard
SET enable_analyzer = '1';

SET enable_positional_arguments = '0';

SELECT 40 AS z
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 3
    )
GROUP BY z;

SELECT 41 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY z;

SELECT
    count(),
    42 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY z;

SELECT 43 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY
    42,
    43,
    44;

SELECT 11 AS z
FROM (
        SELECT 2
        UNION ALL
        SELECT 3
    )
GROUP BY
    42,
    43,
    44;

SELECT 40 AS z
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 3
    )
GROUP BY z
WITH TOTALS;

-- NOTE: non-analyzer preserves the original header (i.e. 41) for TOTALS in
-- case of remote queries with GROUP BY some_requested_const and there were no
-- aggregate functions, the query above. But everything else works in the same
-- way, i.e.:
--
--     select 41 as z, count() from remote('127.0.0.{2,3}', system.one) group by z WITH TOTALS;
--     select 41 as z from remote('127.0.0.{2,3}', system.one) group by 1 WITH TOTALS;
--
SELECT 41 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY z
WITH TOTALS;

SELECT
    count(),
    42 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY z
WITH TOTALS;

SELECT 43 AS z
FROM remote('127.0.0.{2,3}', `system`.one)
GROUP BY
    42,
    43,
    44
WITH TOTALS;

SELECT 11 AS z
FROM (
        SELECT 1
        UNION ALL
        SELECT 2
    )
GROUP BY
    42,
    43,
    44
WITH TOTALS;

SELECT 11 AS z
FROM (
        SELECT 2
        UNION ALL
        SELECT 3
    )
GROUP BY
    42,
    43,
    44
WITH TOTALS;

SELECT count()
WITH TOTALS;

SELECT count()
FROM remote('127.0.0.{2,3}', `system`.one)
WITH TOTALS;