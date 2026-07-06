DROP TABLE IF EXISTS test;

-- this queries does not have to pass, but they works historically
-- let's support this while can, see #31687
CREATE TABLE test
(
    x String
)
ENGINE = StripeLog();

INSERT INTO test;

SELECT if(0, y, 42)
FROM test;

SELECT if(1, 42, y)
FROM test;

SELECT if(toUInt8(0), y, 42)
FROM test;

SELECT if(toUInt8(1), 42, y)
FROM test;

SELECT if(toUInt8(toUInt8(0)), y, 42)
FROM test;

SELECT if(CAST(CAST(0 AS UInt8) AS UInt8), y, 42)
FROM test;

EXPLAIN SYNTAX
SELECT
    x,
    if((
        SELECT hasColumnInTable(currentDatabase(), 'test', 'y')
    ), y, x || '_')
FROM test;

DROP TABLE IF EXISTS t;