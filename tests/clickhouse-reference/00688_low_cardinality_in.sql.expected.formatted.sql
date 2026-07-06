SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS lc_00688;

CREATE TABLE lc_00688
(
    str LowCardinality(String),
    val LowCardinality(UInt8)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lc_00688;

SELECT
    str,
    str IN ('a', 'd')
FROM lc_00688;

SELECT
    val,
    val IN (1, 3)
FROM lc_00688;

SELECT
    str,
    str IN (
        SELECT arrayJoin(['a', 'd'])
    )
FROM lc_00688;

SELECT
    val,
    val IN (
        SELECT arrayJoin([1, 3])
    )
FROM lc_00688;

SELECT
    str,
    str IN (
        SELECT str
        FROM lc_00688
    )
FROM lc_00688;

SELECT
    val,
    val IN (
        SELECT val
        FROM lc_00688
    )
FROM lc_00688;

DROP TABLE IF EXISTS ary_lc_null;

CREATE TABLE ary_lc_null
(
    i int,
    v Array(LowCardinality(Nullable(String)))
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO ary_lc_null;

SELECT v
FROM ary_lc_null
WHERE v IN (
        SELECT v
        FROM ary_lc_null
    );