SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS t1__fuzz_8;

DROP TABLE IF EXISTS full_join__fuzz_4;

CREATE TABLE t1__fuzz_8
(
    x LowCardinality(UInt32),
    str Nullable(Int16)
)
ENGINE = Memory();

INSERT INTO t1__fuzz_8;

CREATE TABLE full_join__fuzz_4
(
    x LowCardinality(UInt32),
    s LowCardinality(String)
)
ENGINE = Join(`ALL`, `FULL`, x)
SETTINGS join_use_nulls = '1';

INSERT INTO full_join__fuzz_4;

SET join_use_nulls = '1';

SELECT *
FROM
    t1__fuzz_8
FULL JOIN full_join__fuzz_4
    USING (x)
ORDER BY
    x DESC,
    str ASC,
    s ASC NULLS LAST;