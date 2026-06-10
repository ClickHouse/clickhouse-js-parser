-- { echo }
-- create table
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Nullable(Int32),
    b Nullable(Int32)
)
ENGINE = Memory();

INSERT INTO test (a, b);

-- first value
SELECT first_value(b)
FROM test;

SELECT first_value(b) IGNORE NULLS
FROM test;

SELECT first_value(b) RESPECT NULLS
FROM test;

-- last value
SELECT last_value(b)
FROM test;

SELECT last_value(b) IGNORE NULLS
FROM test;

SELECT last_value(b) RESPECT NULLS
FROM test;

SET enable_analyzer = '1';