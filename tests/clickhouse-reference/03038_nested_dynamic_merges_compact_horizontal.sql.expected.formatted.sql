-- Tags: long, no-tsan, no-msan, no-ubsan, no-asan
-- Random settings limits: index_granularity=(100, None); merge_max_block_size=(100, None)
SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET allow_experimental_dynamic_type = '1';

SET enable_named_columns_in_function_tuple = '0';

DROP TABLE IF EXISTS test;

;

CREATE TABLE test
(
    id UInt64,
    d Dynamic(max_types = 2)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1000000000', min_bytes_for_wide_part = '10000000000', lock_acquire_timeout_for_background_operations = '600';

SYSTEM STOP MERGES test;

INSERT INTO test SELECT
    number,
    number
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    tuple(if(number % 3 = 0, number, 'str_' || toString(number)))::Tuple(a Dynamic(max_types = 2))
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    tuple(if(number % 3 = 0, toDate(number), range(number % 10)))::Tuple(a Dynamic(max_types = 2))
FROM numbers(50000);

INSERT INTO test SELECT
    number,
    multiIf(number % 5 = 0, tuple(if(number % 3 = 0, toDateTime(number), toIPv4(number)))::Tuple(a Dynamic(max_types = 2)), number % 5 = 1
    OR number % 5 = 2, number, 'str_' || number)
FROM numbers(100000);

SELECT
    count(),
    dynamicType(d) || ':' || dynamicType(d.`Tuple(a Dynamic(max_types=2))`.a) AS type,
    isDynamicElementInSharedData(d.`Tuple(a Dynamic(max_types=2))`.a) AS flag
FROM test
GROUP BY
    type,
    flag
ORDER BY
    count() ASC,
    type ASC;

SYSTEM START MERGES test;

OPTIMIZE TABLE test FINAL;

SELECT '---------------------';

INSERT INTO test SELECT
    number,
    tuple(if(number % 3 = 0, toDateTime(number), NULL))::Tuple(a Dynamic(max_types = 2))
FROM numbers(50000);

INSERT INTO test SELECT
    number,
    tuple(if(number % 2 = 0, tuple(number), NULL))::Tuple(a Dynamic(max_types = 2))
FROM numbers(200000);

INSERT INTO test SELECT
    number,
    tuple(toDateTime(number))::Tuple(a Dynamic(max_types = 2))
FROM numbers(40000);

DROP TABLE test;