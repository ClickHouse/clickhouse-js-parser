SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS lc_00800_2;

CREATE TABLE lc_00800_2
(
    val LowCardinality(UInt64)
)
ENGINE = MergeTree()
ORDER BY val;

INSERT INTO lc_00800_2 SELECT number % 123
FROM `system`.numbers
LIMIT 100000;

SELECT DISTINCT val
FROM lc_00800_2
ORDER BY val ASC;