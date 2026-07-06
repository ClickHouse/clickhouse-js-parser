SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x LowCardinality(Int32)
)
ENGINE = Memory();

INSERT INTO test SELECT 1;

INSERT INTO test SELECT 2;

SELECT x + 10000000000.
FROM test
ORDER BY
    10000000000. ASC,
    x ASC;

SELECT x + (10000000000. + 100000000000000000000.)
FROM test
ORDER BY
    10000000000. + 100000000000000000000. ASC,
    x ASC;

SELECT x + (pow(2, 2) + pow(3, 2))
FROM test
ORDER BY
    pow(2, 2) + pow(3, 2) ASC,
    x ASC;

DROP TABLE test;