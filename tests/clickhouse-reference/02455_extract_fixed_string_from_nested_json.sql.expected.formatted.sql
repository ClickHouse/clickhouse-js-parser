DROP TABLE IF EXISTS test_fixed_string_nested_json;

CREATE TABLE test_fixed_string_nested_json
(
    data String
)
ENGINE = MergeTree()
ORDER BY data;

INSERT INTO test_fixed_string_nested_json (data);

SELECT JSONExtract(data, 'Tuple(a FixedString(24))') AS json
FROM test_fixed_string_nested_json;

DROP TABLE test_fixed_string_nested_json;