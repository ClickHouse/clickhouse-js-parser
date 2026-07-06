DROP TABLE IF EXISTS source;

DROP TABLE IF EXISTS target1;

DROP TABLE IF EXISTS target2;

DROP TABLE IF EXISTS v_heavy;

CREATE TABLE source
(
    type String
)
ENGINE = MergeTree()
ORDER BY type;

CREATE VIEW v_heavy
AS
WITH nums AS (
    SELECT number
    FROM numbers(100000.)
)

SELECT count(*) AS n
FROM (
        SELECT number
        FROM
            numbers(100000.) AS n1
        CROSS JOIN nums
    );

CREATE TABLE target1
(
    type String
)
ENGINE = MergeTree()
ORDER BY type;

CREATE TABLE target2
(
    type String
)
ENGINE = MergeTree()
ORDER BY type;

SET max_execution_time = '2';

-- we should not execute scalar subquery here
CREATE MATERIALIZED VIEW vm_target2
TO target2
AS
SELECT *
FROM source
WHERE type = 'two'
    AND (
        SELECT sum(sleepEachRow(0.1))
        FROM numbers(30)
    );