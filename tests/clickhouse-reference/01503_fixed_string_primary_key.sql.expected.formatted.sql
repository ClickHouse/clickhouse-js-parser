DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    key FixedString(10)
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY tuple();

INSERT INTO test SELECT toString(intDiv(number, 8))
FROM numbers(100);

SELECT count()
FROM test
WHERE key = '1';