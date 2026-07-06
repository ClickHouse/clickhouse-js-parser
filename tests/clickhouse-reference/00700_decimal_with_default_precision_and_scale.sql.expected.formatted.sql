DROP TABLE IF EXISTS decimal;

CREATE TABLE IF NOT EXISTS decimal
(
    d1 DECIMAL(9, 8),
    d2 DECIMAL(18),
    d3 DECIMAL
)
ENGINE = MergeTree()
ORDER BY (d2, d3)
PARTITION BY toInt32(d1);

INSERT INTO decimal (d1, d2, d3);

SELECT type
FROM `system`.`columns`
WHERE table = 'decimal'
    AND database = currentDatabase()
ORDER BY type ASC;

SELECT
    toTypeName(d2),
    toTypeName(d3)
FROM decimal
LIMIT 1;

DROP TABLE decimal;