SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0';

INSERT INTO test FORMAT JSONAsObject;

SELECT *
FROM test;

SELECT
    json.`a/b/c`,
    json.`a-b-c`,
    json.`a-b/c-d/e`
FROM test;

SELECT
    json.`a/b/c`.:Int64,
    json.`a-b-c`.:Int64,
    json.`a-b/c-d/e`.:Int64
FROM test;

DROP TABLE test;