DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x Nullable(UInt32)
)
ENGINE = Memory();

INSERT INTO test SELECT number % 2 ? NULL : number
FROM numbers(10);

SELECT getSubcolumn(x, 'null')
FROM test;

DROP TABLE test;