DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt32,
    y String
)
ENGINE = Memory();

INSERT INTO test SELECT *
FROM generateRandom()
LIMIT 10;

SELECT count()
FROM test;

DROP TABLE test;