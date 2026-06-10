DROP TABLE IF EXISTS local_t;

CREATE TABLE local_t
ENGINE = Log() AS
SELECT 1 AS a;

SELECT *
FROM (
        SELECT a
        FROM remote('127.0.0.{1,2}', currentDatabase(), local_t)
        GROUP BY a
        WITH TOTALS
    )
WHERE a IN (
        SELECT 1
    );

SELECT *
FROM (
        SELECT a
        FROM remote('127.0.0.1', currentDatabase(), local_t)
        GROUP BY a
        WITH TOTALS
    )
WHERE a IN (
        SELECT 1
    );

SELECT
    a,
    count()
FROM remote('127.0.0.{1,2}', currentDatabase(), local_t)
GROUP BY a
WITH TOTALS
HAVING a IN (
        SELECT 1
    );