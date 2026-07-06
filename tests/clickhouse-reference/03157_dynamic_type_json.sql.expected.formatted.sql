SET allow_experimental_dynamic_type = '1';

SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

DROP TABLE IF EXISTS test_deep_nested_json;

CREATE TABLE test_deep_nested_json
(
    i UInt16,
    d JSON
)
ENGINE = Memory();

INSERT INTO test_deep_nested_json;

INSERT INTO test_deep_nested_json;

SELECT *
FROM test_deep_nested_json
ORDER BY i ASC;

SELECT
    d::Dynamic AS d1,
    dynamicType(d1)
FROM test_deep_nested_json
ORDER BY i ASC;

DROP TABLE test_deep_nested_json;