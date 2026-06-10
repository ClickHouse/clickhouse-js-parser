DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt8,
    y UInt8,
    z String DEFAULT toString(x)
)
ORDER BY x
PARTITION BY x;

INSERT INTO test (x, y);

INSERT INTO test (x, y);

OPTIMIZE TABLE test FINAL;

INSERT INTO test (x, y);

ALTER TABLE test DROP PARTITION 2;

SET mutations_sync = '1';

ALTER TABLE test UPDATE z = x || y WHERE 1;

SELECT *
FROM test
ORDER BY `ALL` ASC;

TRUNCATE TABLE test;

DROP TABLE test SYNC;

SYSTEM FLUSH LOGS part_log;

SELECT
    event_type,
    merge_reason,
    table,
    part_name,
    partition_id,
    `partition`,
    `rows`,
    merged_from
FROM `system`.part_log
WHERE database = currentDatabase()
    AND event_type IN ('MergePartsStart', 'MergeParts', 'MutatePartStart', 'MutatePart')
ORDER BY event_time_microseconds ASC
FORMAT Vertical;