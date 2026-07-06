SET allow_suspicious_low_cardinality_types = '1';

SELECT CAST(NULL AS LowCardinality(Nullable(Int8)));

DROP TABLE IF EXISTS lc_null_int8_defnull;

CREATE TABLE lc_null_int8_defnull
(
    val LowCardinality(Nullable(Int8)) DEFAULT NULL
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lc_null_int8_defnull;

SELECT *
FROM lc_null_int8_defnull AS values;

ALTER TABLE lc_null_int8_defnull ADD COLUMN val2 LowCardinality(Nullable(Int8)) DEFAULT NULL;

INSERT INTO lc_null_int8_defnull;

SELECT *
FROM lc_null_int8_defnull
ORDER BY val ASC;