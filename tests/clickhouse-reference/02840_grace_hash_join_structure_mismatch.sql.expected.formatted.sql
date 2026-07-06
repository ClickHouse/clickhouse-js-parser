SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE t1__fuzz_17
(
    a LowCardinality(UInt8),
    b Nullable(UInt256)
)
ENGINE = Memory();

CREATE TABLE t2__fuzz_0
(
    c UInt32,
    d String
)
ENGINE = Memory();

INSERT INTO t1__fuzz_17 SELECT *
FROM generateRandom()
LIMIT 1;

INSERT INTO t2__fuzz_0 SELECT *
FROM generateRandom()
LIMIT 1;

SET join_algorithm = 'grace_hash';

SELECT *
FROM
    t1__fuzz_17
INNER JOIN t2__fuzz_0
    ON c = a
WHERE a
FORMAT Null;