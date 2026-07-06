DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x AggregateFunction(uniq, UInt64),
    y Int64
)
ENGINE = Memory();

SET max_insert_threads = '1';

INSERT INTO test SELECT
    uniqState(number) AS x,
    number AS y
FROM numbers(10)
GROUP BY number
ORDER BY y ASC;

SELECT uniqStateMap(map(1, x)) OVER (PARTITION BY y)
FROM test;

SELECT uniqStateForEach([x]) OVER (PARTITION BY y)
FROM test;

SELECT uniqStateResample(30, 75, 30)([x], 30) OVER (PARTITION BY y)
FROM test;

SELECT uniqStateForEachMapForEach([map(1, [x])]) OVER (PARTITION BY y)
FROM test;

SELECT uniqStateDistinctMap(map(1, x)) OVER (PARTITION BY y)
FROM test;

DROP TABLE test;