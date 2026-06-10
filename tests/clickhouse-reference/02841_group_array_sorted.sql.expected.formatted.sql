SELECT groupArraySorted(5)(number)
FROM numbers(100);

SELECT groupArraySorted(10)(number)
FROM numbers(5);

SELECT groupArraySorted(100)(number)
FROM numbers(1000);

SELECT groupArraySorted(30)(str)
FROM (
        SELECT toString(number) AS str
        FROM numbers(30)
    );

SELECT groupArraySorted(10)(toInt64(number / 2))
FROM numbers(100);

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test;

SELECT groupArraySorted(3)(a)
FROM test;

DROP TABLE test;

CREATE TABLE IF NOT EXISTS test
(
    id Int32,
    data Tuple(Int32, Int32)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test (id, data);

SELECT groupArraySorted(4)(data)
FROM test;

CREATE TABLE IF NOT EXISTS test
(
    id Int32,
    data Decimal32(2)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test (id, data);

CREATE TABLE IF NOT EXISTS test
(
    id Int32,
    data FixedString(3)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test (id, data);

SELECT groupArraySorted(5)(data)
FROM test;

CREATE TABLE test
(
    id Decimal(76, 53),
    str String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test SELECT
    number,
    'test'
FROM numbers(1000000);

SELECT count(id)
FROM test;

SELECT count(concat(toString(id), 'a'))
FROM test;

CREATE TABLE test
(
    id UInt64,
    agg AggregateFunction(groupArraySorted(2), UInt64)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test SELECT
    1,
    groupArraySortedState(2)(number)
FROM numbers(10);

SELECT groupArraySortedMerge(2)(agg)
FROM test;