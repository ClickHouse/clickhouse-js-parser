-- Tags: no-fasttest
CREATE TABLE hardlink_cycle
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS disk = 's3_disk', min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', min_level_for_wide_part = '0', sleep_before_loading_outdated_parts_ms = '10000';

INSERT INTO hardlink_cycle SELECT
    rand(),
    rand()
FROM numbers(1)
SETTINGS
    max_block_size = '1',
    min_insert_block_size_bytes = '1';

SET mutations_sync = '2', alter_sync = '2';

ALTER TABLE hardlink_cycle RENAME COLUMN b TO c;

ALTER TABLE hardlink_cycle RENAME COLUMN c TO d;

ALTER TABLE hardlink_cycle RENAME COLUMN d TO e;

DETACH TABLE hardlink_cycle;

ATTACH TABLE hardlink_cycle;

DROP TABLE hardlink_cycle SYNC;