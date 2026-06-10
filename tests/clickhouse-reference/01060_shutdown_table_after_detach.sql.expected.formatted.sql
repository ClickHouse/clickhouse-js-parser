DROP TABLE IF EXISTS test;

CREATE TABLE test
ENGINE = MergeTree()
ORDER BY number
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi' AS
SELECT
    number,
    toString(rand()) AS x
FROM numbers(10000000);

SELECT count()
FROM test;

ALTER TABLE test DETACH PARTITION tuple();

DETACH TABLE test;

ATTACH TABLE test;

ALTER TABLE test ATTACH PARTITION tuple();

DROP TABLE test;