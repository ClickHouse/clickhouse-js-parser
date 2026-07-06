-- Tags: long
SET max_threads = '3';

SET min_bytes_to_use_direct_io = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    json JSON(max_dynamic_paths = 4)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '1', index_granularity_bytes = '28437532', merge_max_block_size = '3520', index_granularity = '26762';

SYSTEM STOP MERGES test;

INSERT INTO test SELECT
    number,
    toJSONString(map('a', number))
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('b', arrayMap((x -> map('c', x)), range(number % 5 + 1))))
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('b', arrayMap((x -> map('d', x)), range(number % 5 + 1))))
FROM numbers(50000);

SYSTEM START MERGES test;

OPTIMIZE TABLE test FINAL;

SELECT *
FROM (
        SELECT DISTINCT json.b.:`Array(JSON)`
        FROM test
    )
ORDER BY `all` ASC;

DROP TABLE test;