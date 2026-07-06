CREATE TABLE test_rows_compact_part__fuzz_11
(
    x UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO test_rows_compact_part__fuzz_11 SELECT 1;

SELECT 1
FROM test_rows_compact_part__fuzz_11
WHERE exists((
        SELECT 1
    ))
SETTINGS enable_analyzer = '1';