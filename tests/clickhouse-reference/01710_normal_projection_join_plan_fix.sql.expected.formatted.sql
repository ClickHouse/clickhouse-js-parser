DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    id UInt32,
    s String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t2
(
    id1 UInt32,
    id2 UInt32
)
ENGINE = MergeTree()
ORDER BY id1
SETTINGS index_granularity = '1';

INSERT INTO t2 SELECT
    number,
    number
FROM numbers(100);

ALTER TABLE t2 ADD PROJECTION proj (SELECT id2 ORDER BY id2);

SELECT s
FROM
    t1 AS lhs
LEFT JOIN (
        SELECT *
        FROM t2
        WHERE id2 = 2
    ) AS rhs
    ON lhs.id = rhs.id2;

DROP TABLE t1;

DROP TABLE t2;