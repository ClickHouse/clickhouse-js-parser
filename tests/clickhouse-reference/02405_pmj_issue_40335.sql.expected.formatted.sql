DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    x UInt64
)
ENGINE = TinyLog();

INSERT INTO t1;

CREATE TABLE t2
(
    x UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO t2;

INSERT INTO t2;

SET max_block_size = '3';

SET max_joined_block_size_rows = '2';

SET join_algorithm = 'partial_merge';

SELECT value
FROM
    t1
LEFT JOIN t2
    ON t1.x = t2.x
ORDER BY value ASC;