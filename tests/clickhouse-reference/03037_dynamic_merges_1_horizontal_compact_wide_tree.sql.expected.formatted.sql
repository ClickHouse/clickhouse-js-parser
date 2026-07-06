-- Tags: long, no-tsan, no-msan, no-ubsan, no-asan
-- Random settings limits: index_granularity=(100, None); merge_max_block_size=(100, None)
SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    d Dynamic(max_types = 2)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', vertical_merge_algorithm_min_columns_to_activate = '10', index_granularity_bytes = '10485760', index_granularity = '8192', merge_max_block_size = '8192', merge_max_block_size_bytes = '10485760', lock_acquire_timeout_for_background_operations = '600';

SYSTEM STOP MERGES test;

INSERT INTO test SELECT
    number,
    number
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    'str_' || toString(number)
FROM numbers(80000);

INSERT INTO test SELECT
    number,
    range(number % 10 + 1)
FROM numbers(70000);

INSERT INTO test SELECT
    number,
    toDate(number)
FROM numbers(60000);

INSERT INTO test SELECT
    number,
    toDateTime(number)
FROM numbers(50000);

INSERT INTO test SELECT
    number,
    NULL
FROM numbers(100000);

SELECT
    count(),
    dynamicType(d),
    isDynamicElementInSharedData(d)
FROM test
GROUP BY
    dynamicType(d),
    isDynamicElementInSharedData(d)
ORDER BY
    count() ASC,
    dynamicType(d) ASC;

SYSTEM START MERGES test;

OPTIMIZE TABLE test FINAL;

;

SELECT '---------------------';

INSERT INTO test SELECT
    number,
    map(number, number)
FROM numbers(200000);

INSERT INTO test SELECT
    number,
    tuple(number, number)
FROM numbers(10000);

INSERT INTO test SELECT
    number,
    'str_' || number
FROM numbers(30000);

DROP TABLE test;