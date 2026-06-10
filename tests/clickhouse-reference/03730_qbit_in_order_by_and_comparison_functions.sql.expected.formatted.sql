DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    qbit QBit(Float64, 3)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT [1., 2., 3.]
FROM numbers(10);

SELECT *
FROM test
ORDER BY qbit ASC; -- {serverError ILLEGAL_COLUMN}

SELECT qbit < qbit
FROM test; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

DROP TABLE test;