DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test2;

CREATE TABLE test
(
    id UInt64,
    json JSON
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test SELECT
    number,
    '{}'
FROM numbers(100000);

ALTER TABLE test UPDATE json = '{"a" : 42}' WHERE id > 50000 SETTINGS mutations_sync = '1';

CREATE TABLE test2
(
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test2 SELECT if(id < 75000, json, '{"a" : 42}'::JSON)
FROM test;

SELECT *
FROM test2
FORMAT Null;