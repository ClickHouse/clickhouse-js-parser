-- Tags: no-parallel, no-random-merge-tree-settings
DROP TABLE IF EXISTS test_rows_compact_part;

CREATE TABLE test_rows_compact_part
(
    f1 int,
    f2 int
)
ENGINE = MergeTree()
ORDER BY f2
PARTITION BY f1
SETTINGS min_bytes_for_wide_part = '10485760';

INSERT INTO test_rows_compact_part SELECT
    0,
    arrayJoin(range(10000));

INSERT INTO test_rows_compact_part SELECT
    1,
    arrayJoin(range(10000));

SELECT 0
FROM test_rows_compact_part
LIMIT 1
FORMAT JSONCompact
SETTINGS exact_rows_before_limit = '0', output_format_write_statistics = '0';

SELECT 0
FROM test_rows_compact_part
LIMIT 1
FORMAT JSONCompact
SETTINGS exact_rows_before_limit = '1', output_format_write_statistics = '0';

DROP TABLE IF EXISTS test_rows_wide_part;

CREATE TABLE test_rows_wide_part
(
    f1 int,
    f2 int
)
ENGINE = MergeTree()
ORDER BY f2
PARTITION BY f1
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO test_rows_wide_part SELECT
    0,
    arrayJoin(range(10000));

INSERT INTO test_rows_wide_part SELECT
    1,
    arrayJoin(range(10000));

SELECT 0
FROM test_rows_wide_part
LIMIT 1
FORMAT JSONCompact
SETTINGS exact_rows_before_limit = '0', output_format_write_statistics = '0';

SELECT 0
FROM test_rows_wide_part
LIMIT 1
FORMAT JSONCompact
SETTINGS exact_rows_before_limit = '1', output_format_write_statistics = '0';