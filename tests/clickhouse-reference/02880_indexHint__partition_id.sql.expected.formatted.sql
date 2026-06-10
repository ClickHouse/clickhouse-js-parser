DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    part Int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY part;

INSERT INTO data;

-- { echoOn }
SELECT *
FROM data
PREWHERE indexHint(_partition_id = '1');

-- TODO: optimize_use_implicit_projections ignores indexHint (with analyzer) because source columns might be aliased.
SELECT count()
FROM data
PREWHERE indexHint(_partition_id = '1')
SETTINGS optimize_use_implicit_projections = '0';

SELECT *
FROM data
WHERE indexHint(_partition_id = '1');

SELECT count()
FROM data
WHERE indexHint(_partition_id = '1')
SETTINGS optimize_use_implicit_projections = '0';