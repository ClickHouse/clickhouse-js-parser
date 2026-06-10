SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS group_by_null_key;

CREATE TABLE group_by_null_key
(
    c1 Nullable(Int32),
    c2 LowCardinality(Nullable(Int32))
)
ENGINE = Memory();

INSERT INTO group_by_null_key;

SELECT
    c1,
    count(*)
FROM group_by_null_key
GROUP BY c1
WITH TOTALS;

SELECT
    c2,
    count(*)
FROM group_by_null_key
GROUP BY c2
WITH TOTALS;

SELECT
    c1,
    count(*)
FROM group_by_null_key
GROUP BY c1
WITH ROLLUP;

SELECT
    c2,
    count(*)
FROM group_by_null_key
GROUP BY c2
WITH ROLLUP;

DROP TABLE group_by_null_key;