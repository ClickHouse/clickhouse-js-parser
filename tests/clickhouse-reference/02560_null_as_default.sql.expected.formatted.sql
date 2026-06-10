DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64
)
ENGINE = Memory();

SET insert_null_as_default = '1';

INSERT INTO test SELECT number % 2 ? NULL : 42 AS x
FROM numbers(2);

SELECT *
FROM test
ORDER BY x ASC;

DROP TABLE test;

CREATE TABLE test
(
    x LowCardinality(String) DEFAULT 'Hello'
)
ENGINE = Memory();

INSERT INTO test SELECT (number % 2 ? NULL : 'World')::LowCardinality(Nullable(String))
FROM numbers(2);