-- https://github.com/ClickHouse/ClickHouse/issues/27068
SET enable_analyzer = '1';

CREATE TABLE test
(
    id String,
    create_time DateTime
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

SELECT
    id,
    '1997-02-01' AS create_time
FROM test
WHERE test.create_time = '1970-02-01 00:00:00'
ORDER BY id ASC;