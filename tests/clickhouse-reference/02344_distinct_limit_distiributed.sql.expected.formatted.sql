DROP TABLE IF EXISTS t_distinct_limit;

CREATE TABLE t_distinct_limit
(
    d Date,
    id Int64
)
ENGINE = MergeTree()
ORDER BY d
PARTITION BY toYYYYMM(d)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SET max_threads = '10';

INSERT INTO t_distinct_limit SELECT
    '2021-12-15',
    -1
FROM numbers(1000000.);

INSERT INTO t_distinct_limit SELECT
    '2022-12-15',
    1
FROM numbers(1000000.);

INSERT INTO t_distinct_limit SELECT
    '2022-12-16',
    11
FROM numbers(1);

INSERT INTO t_distinct_limit SELECT
    '2023-12-16',
    12
FROM numbers(1);

INSERT INTO t_distinct_limit SELECT
    '2023-12-16',
    13
FROM numbers(1);

INSERT INTO t_distinct_limit SELECT
    '2023-12-16',
    14
FROM numbers(1);

SET max_block_size = '1024';

SELECT id
FROM (
        SELECT DISTINCT id
        FROM remote('127.0.0.1,127.0.0.2', currentDatabase(), t_distinct_limit)
        LIMIT 10
    )
ORDER BY id ASC;