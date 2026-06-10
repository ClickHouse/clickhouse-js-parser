-- Tags: long, no-tsan, no-msan, no-ubsan, no-asan
-- Random settings limits: index_granularity=(100, None); merge_max_block_size=(100, None)
SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', lock_acquire_timeout_for_background_operations = '600';

SYSTEM STOP MERGES test;

INSERT INTO test SELECT
    number,
    number
FROM numbers(200000);

INSERT INTO test SELECT
    number,
    'str_' || toString(number)
FROM numbers(200000, 200000);

INSERT INTO test SELECT
    number,
    range(number % 10 + 1)
FROM numbers(400000, 200000);

SYSTEM START MERGES test;

OPTIMIZE TABLE test FINAL;

SELECT
    count(),
    dynamicType(d)
FROM test
GROUP BY dynamicType(d)
ORDER BY
    count() ASC,
    dynamicType(d) ASC;

DROP TABLE test;