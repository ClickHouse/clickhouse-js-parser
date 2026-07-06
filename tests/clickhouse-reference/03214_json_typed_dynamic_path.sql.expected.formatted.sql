-- Tags: no-fasttest
SET enable_json_type = '1';

SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(a Dynamic)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT '{"a" : 42}';

INSERT INTO test SELECT '{"a" : [1, 2, 3]}';

OPTIMIZE TABLE test;

SELECT *
FROM test
ORDER BY toString(json) ASC;

DROP TABLE test;

CREATE TABLE test
(
    json JSON(a Dynamic)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '10000000', min_bytes_for_wide_part = '10000000';