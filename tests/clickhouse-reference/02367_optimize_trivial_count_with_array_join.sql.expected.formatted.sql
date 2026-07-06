DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS t1;

CREATE TABLE t
(
    id UInt32
)
ENGINE = MergeTree()
ORDER BY id AS
SELECT 1;

CREATE TABLE t1
(
    a Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT [1, 2];

SELECT count()
FROM
    t
ARRAY JOIN (
        SELECT a
        FROM t1
    ) AS _a
SETTINGS optimize_trivial_count_query = '1';

DROP TABLE t;

DROP TABLE t1;