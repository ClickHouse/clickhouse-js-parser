DROP TABLE IF EXISTS t1__fuzz_13;

DROP TABLE IF EXISTS t2__fuzz_47;

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE t1__fuzz_13
(
    id Nullable(Int16)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS allow_nullable_key = '1';

CREATE TABLE t2__fuzz_47
(
    id LowCardinality(Int16)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t1__fuzz_13;

INSERT INTO t2__fuzz_47;

SELECT *
FROM
    t1__fuzz_13
FULL JOIN t2__fuzz_47
    ON 1 = 2
ORDER BY `ALL` ASC;