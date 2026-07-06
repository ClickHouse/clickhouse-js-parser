DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    day Date,
    id UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY day;

INSERT INTO test SELECT
    toDate('2023-01-05') AS day,
    number
FROM numbers(10);

WITH toUInt64(id) AS id_with

SELECT
    day,
    count(id_with)
FROM test
WHERE day >= '2023-01-01'
GROUP BY day
LIMIT 1000;

DROP TABLE test;