DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    key UInt8
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO t1;

CREATE TABLE t2
(
    key UInt32
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO t2;

SELECT a
FROM (
        SELECT
            key + 1 AS a,
            key
        FROM t1
        GROUP BY key
    )
WHERE key
FORMAT Null;

SET join_algorithm = 'full_sorting_merge';

SET max_rows_in_set_to_optimize_join = '0';

SELECT key
FROM
    (
        SELECT key
        FROM t1
        GROUP BY key
    ) AS t1
INNER JOIN (
        SELECT key
        FROM t2
    ) AS t2
    ON t1.key = t2.key
WHERE key
FORMAT Null;