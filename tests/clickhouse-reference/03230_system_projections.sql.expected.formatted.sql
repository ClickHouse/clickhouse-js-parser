DROP TABLE IF EXISTS projections;

DROP TABLE IF EXISTS projections_2;

CREATE TABLE projections
(
    key String,
    d1 Int,
    PROJECTION improved_sorting_key (SELECT * ORDER BY d1, key)
)
ENGINE = MergeTree()
ORDER BY key;

CREATE TABLE projections_2
(
    name String,
    frequency UInt64,
    PROJECTION agg (SELECT name, max(frequency) AS max_frequency GROUP BY name),
    PROJECTION agg_no_key (SELECT max(frequency) AS max_frequency)
)
ENGINE = MergeTree()
ORDER BY name;

SELECT *
FROM `system`.projections
WHERE database = currentDatabase();

SELECT count(*)
FROM `system`.projections
WHERE table = 'projections'
    AND database = currentDatabase();

SELECT count(*)
FROM `system`.projections
WHERE table = 'projections_2'
    AND database = currentDatabase();

SELECT name
FROM `system`.projections
WHERE type = 'Normal'
    AND database = currentDatabase();

DROP TABLE projections;

DROP TABLE projections_2;