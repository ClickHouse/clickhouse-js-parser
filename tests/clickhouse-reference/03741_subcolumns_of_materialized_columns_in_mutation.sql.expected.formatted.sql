DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s String,
    json JSON MATERIALIZED s
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT '{"a" : 42}';

ALTER TABLE test UPDATE s = '{}' WHERE json.a = 42 SETTINGS mutations_sync = '1';

SELECT *
FROM test;

DROP TABLE test;