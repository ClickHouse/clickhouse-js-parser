DROP TABLE IF EXISTS smta;

CREATE TABLE smta
(
    k Int64,
    a AggregateFunction(max, Int64),
    city SimpleAggregateFunction(max, LowCardinality(String))
)
ENGINE = SummingMergeTree()
ORDER BY k;

INSERT INTO smta (k, city);

SELECT
    k,
    city
FROM smta;

INSERT INTO smta (k, city);

OPTIMIZE TABLE smta;