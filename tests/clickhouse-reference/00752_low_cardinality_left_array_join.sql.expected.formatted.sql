SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS lc_left_aj;

CREATE TABLE lc_left_aj
(
    str Array(LowCardinality(String)),
    null_str Array(LowCardinality(Nullable(String))),
    val Array(LowCardinality(Float64)),
    null_val Array(LowCardinality(Nullable(Float64)))
)
ENGINE = Memory();

INSERT INTO lc_left_aj;

SELECT
    *,
    arr
FROM
    lc_left_aj
LEFT ARRAY JOIN str AS arr;

SELECT
    *,
    arr
FROM
    lc_left_aj
LEFT ARRAY JOIN null_str AS arr;

SELECT
    *,
    arr
FROM
    lc_left_aj
LEFT ARRAY JOIN val AS arr;

SELECT
    *,
    arr
FROM
    lc_left_aj
LEFT ARRAY JOIN null_val AS arr;