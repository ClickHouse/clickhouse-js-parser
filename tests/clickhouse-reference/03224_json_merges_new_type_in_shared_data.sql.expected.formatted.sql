SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 1)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT '{"b" : 42}'
FROM numbers(5);

INSERT INTO test SELECT '{"a" : 42, "b" : [1, 2, 3]}'
FROM numbers(5);

OPTIMIZE TABLE test FINAL;

SELECT DISTINCT
    dynamicType(json.b) AS type,
    isDynamicElementInSharedData(json.b)
FROM test
ORDER BY type ASC;

DROP TABLE test;