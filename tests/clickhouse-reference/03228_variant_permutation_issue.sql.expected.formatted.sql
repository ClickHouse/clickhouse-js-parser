SET enable_json_type = '1';

DROP TABLE IF EXISTS test_new_json_type;

CREATE TABLE test_new_json_type
(
    id UInt32,
    data JSON,
    version UInt64
)
ENGINE = ReplacingMergeTree(version)
ORDER BY id;

INSERT INTO test_new_json_type FORMAT JSONEachRow;

SELECT *
FROM test_new_json_type FINAL
WHERE data.foo2 IS NOT NULL
ORDER BY id ASC;

INSERT INTO test_new_json_type SELECT
    id,
    '{"foo2":"baz"}' AS _data,
    version + 1 AS _version
FROM test_new_json_type
WHERE id = 2;

DROP TABLE test_new_json_type;

CREATE TABLE test_new_json_type
(
    id Nullable(UInt32),
    data JSON,
    version UInt64
)
ENGINE = ReplacingMergeTree(version)
ORDER BY id
SETTINGS allow_nullable_key = '1';

SELECT *
FROM test_new_json_type FINAL
PREWHERE data.foo2 IS NOT NULL
WHERE data.foo2 IS NOT NULL
ORDER BY id ASC NULLS FIRST;