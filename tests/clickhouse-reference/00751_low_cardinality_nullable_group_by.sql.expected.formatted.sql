SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS low_null_float;

CREATE TABLE low_null_float
(
    a LowCardinality(Nullable(Float64))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO low_null_float (a) SELECT if(number % 3 = 0, NULL, number)
FROM `system`.numbers
LIMIT 1000000;

SELECT
    a,
    count()
FROM low_null_float
GROUP BY a
ORDER BY
    count() DESC,
    a ASC
LIMIT 10;