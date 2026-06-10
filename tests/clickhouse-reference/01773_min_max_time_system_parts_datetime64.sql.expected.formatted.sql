DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    time DateTime64(3)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toStartOfInterval(time, toIntervalYear(2));

INSERT INTO test;

SELECT
    min_time,
    max_time
FROM `system`.parts
WHERE table = 'test'
    AND database = currentDatabase();

SELECT
    min_time,
    max_time
FROM `system`.parts_columns
WHERE table = 'test'
    AND database = currentDatabase();

DROP TABLE test;