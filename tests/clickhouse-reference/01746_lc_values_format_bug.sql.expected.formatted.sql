DROP TABLE IF EXISTS lc_test;

CREATE TABLE lc_test
(
    id LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY tuple();

INSERT INTO lc_test;

SELECT id
FROM lc_test;