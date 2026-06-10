DROP TABLE IF EXISTS test_03143;

CREATE TABLE test_03143
(
    timestamp DateTime,
    x UInt32 TTL timestamp + toIntervalMonth(1),
    y String TTL timestamp + toIntervalDay(1),
    z String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_03143;

SELECT
    name,
    column,
    type,
    column_ttl_min,
    column_ttl_max
FROM `system`.parts_columns
WHERE table = 'test_03143'
    AND database = currentDatabase()
ORDER BY
    name ASC,
    column ASC;