DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UUID,
    value UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY id;

INSERT INTO tab;

-- Here we check that partition id for UUID partition key did not change.
-- Different result means Backward Incompatible Change. Old partitions will not be accepted by new server.
SELECT partition_id
FROM `system`.parts
WHERE table = 'tab'
    AND database = currentDatabase();