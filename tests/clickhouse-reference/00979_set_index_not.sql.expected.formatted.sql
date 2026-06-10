DROP TABLE IF EXISTS set_index_not;

CREATE TABLE set_index_not
(
    name String,
    status Enum8('alive' = 0, 'rip' = 1),
    INDEX idx_status status TYPE set(2) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY name
SETTINGS index_granularity = '8192';

INSERT INTO set_index_not;

SELECT *
FROM set_index_not
WHERE status != 'rip';

SELECT *
FROM set_index_not
WHERE NOT status = 'rip';

SELECT *
FROM set_index_not
WHERE NOT status != 'rip';

SELECT *
FROM set_index_not
WHERE NOT NOT status = 'rip';

DROP TABLE set_index_not;