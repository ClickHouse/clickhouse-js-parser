-- Tags: no-ordinary-database
CREATE TABLE data_02491
(
    key Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS old_parts_lifetime = '600';

INSERT INTO data_02491;

OPTIMIZE TABLE data_02491 FINAL;

TRUNCATE TABLE data_02491;

SYSTEM FLUSH LOGS part_log;

WITH (
        SELECT uuid
        FROM `system`.tables
        WHERE database = currentDatabase()
            AND table = 'data_02491'
    ) AS table_uuid_

SELECT
    table_uuid != toUUIDOrDefault(NULL),
    event_type,
    merge_reason,
    part_name
FROM `system`.part_log
WHERE database = currentDatabase()
    AND table = 'data_02491'
    AND table_uuid = table_uuid_
ORDER BY event_time_microseconds ASC;

DROP TABLE data_02491;