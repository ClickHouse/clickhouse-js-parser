-- { echo ON }
DROP TABLE IF EXISTS test;

-- disable merge
CREATE TABLE test
(
    i int,
    j int,
    PROJECTION p (SELECT *, _part_offset ORDER BY j)
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '1', max_bytes_to_merge_at_max_space_in_pool = '1';

-- make 5 parts
INSERT INTO test SELECT
    number,
    10 - number
FROM numbers(5);

-- verify _part_starting_offset and _part_offset in parent part and projection
SELECT
    _part,
    _part_starting_offset,
    _part_offset
FROM test
ORDER BY `all` ASC;

SELECT
    _part,
    _part_starting_offset,
    _part_offset
FROM test
WHERE j = 8
ORDER BY `all` ASC;

-- make sure key analysis works correctly
SELECT
    *,
    _part_starting_offset + _part_offset
FROM test
WHERE _part_starting_offset + _part_offset = 8
SETTINGS
    parallel_replicas_local_plan = '0',
    max_rows_to_read = '1';

SELECT
    *,
    _part_offset + _part_starting_offset
FROM test
WHERE _part_offset + _part_starting_offset = 8
SETTINGS
    parallel_replicas_local_plan = '0',
    max_rows_to_read = '1';

-- from fuzzer
SELECT *
FROM test
PREWHERE 8 = _part_offset + _part_starting_offset
WHERE 8 = _part_offset + _part_starting_offset
SETTINGS
    parallel_replicas_local_plan = '0',
    max_rows_to_read = '1';

SELECT *
FROM test
PREWHERE 8 = _part_starting_offset * _part_offset
    AND 3
WHERE 8 = _part_starting_offset + _part_offset;

DROP TABLE test;