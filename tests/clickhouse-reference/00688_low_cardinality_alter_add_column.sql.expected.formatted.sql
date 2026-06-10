DROP TABLE IF EXISTS cardinality;

CREATE TABLE cardinality
(
    x String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO cardinality (x) SELECT concat('v', toString(number))
FROM numbers(10);

ALTER TABLE cardinality ADD COLUMN y LowCardinality(String);

SELECT *
FROM cardinality;