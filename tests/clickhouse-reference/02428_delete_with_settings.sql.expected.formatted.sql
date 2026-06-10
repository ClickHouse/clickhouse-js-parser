DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id Int32,
    key String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO test SELECT
    number,
    toString(number)
FROM numbers(1000000);

DELETE FROM test WHERE id % 2 = 0 SETTINGS mutations_sync = '0';

SELECT count()
FROM test;