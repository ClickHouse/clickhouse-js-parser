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

SELECT
    a.data,
    b.data
FROM
    test_new_json_type AS a
INNER JOIN test_new_json_type AS b
    ON a.id = b.id
ORDER BY id ASC;

DROP TABLE test_new_json_type;