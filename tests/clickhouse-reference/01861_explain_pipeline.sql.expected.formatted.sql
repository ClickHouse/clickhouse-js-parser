DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Int,
    b Int
)
ENGINE = ReplacingMergeTree()
ORDER BY a
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SET optimize_on_insert = '0';

INSERT INTO test SELECT
    number,
    number
FROM numbers(5);

INSERT INTO test SELECT
    number,
    number
FROM numbers(5, 2);

SET max_threads = '1';

EXPLAIN PIPELINE
SELECT *
FROM test FINAL
SETTINGS enable_vertical_final = '0';

SELECT *
FROM test FINAL;

SET max_threads = '2';

DROP TABLE test;