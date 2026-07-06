DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    foo Array(LowCardinality(String)),
    INDEX idx foo TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
PRIMARY KEY tuple();

INSERT INTO tab;

SELECT '---';

SELECT
    table,
    name,
    type
FROM `system`.data_skipping_indices
WHERE database = currentDatabase()
    AND table = 'tab';

EXPLAIN indexes = '1', description = '0'
SELECT *
FROM tab
WHERE has(foo, 'b');

DROP TABLE tab;