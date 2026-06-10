DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    json JSON(max_dynamic_paths = 1)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '100G', write_marks_for_substreams_in_compact_parts = '0';

INSERT INTO test SELECT
    number,
    '{"a" : 42, "b" : {"c" : 42}}'
FROM numbers(100000);

SELECT json.^b
FROM test
ORDER BY id ASC
FORMAT Null;

DROP TABLE test;