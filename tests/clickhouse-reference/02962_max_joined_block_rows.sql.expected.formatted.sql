DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    a UInt64,
    b UInt64
)
ENGINE = Memory();

INSERT INTO t1 SELECT
    number % 2,
    number
FROM numbers(10);

CREATE TABLE t2
(
    a UInt64
)
ENGINE = Memory();

INSERT INTO t2 SELECT number % 2
FROM numbers(10);

SET min_joined_block_size_rows = '0', min_joined_block_size_bytes = '0';

-- block size is always multiple of 5 because we have 5 rows for each key in right table
-- we do not split rows corresponding to the same key
SET join_algorithm = 'hash';

SELECT
    max(bs) <= 5,
    b
FROM (
        SELECT
            blockSize() AS bs,
            *
        FROM
            t1
        INNER JOIN t2
            ON t1.a = t2.a
    )
GROUP BY b
ORDER BY b ASC
SETTINGS max_joined_block_size_rows = '5';

SELECT '--';

SELECT
    max(bs) <= 10,
    b
FROM (
        SELECT
            blockSize() AS bs,
            *
        FROM
            t1
        INNER JOIN t2
            ON t1.a = t2.a
    )
GROUP BY b
ORDER BY b ASC
SETTINGS max_joined_block_size_rows = '10';

SET join_algorithm = 'parallel_hash';