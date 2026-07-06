-- Tags: replica, long
-- Regression test for possible CHECKSUM_DOESNT_MATCH due to per-column TTL bug.
-- That had been fixed in https://github.com/ClickHouse/ClickHouse/pull/35820
DROP TABLE IF EXISTS ttl_02265;

DROP TABLE IF EXISTS ttl_02265_r2;

-- The bug is appears only for Wide part.
CREATE TABLE ttl_02265
(
    date Date,
    key Int,
    value String TTL date + toIntervalMonth(1)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/ttl_02265', 'r1')
ORDER BY key
PARTITION BY date
SETTINGS min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

CREATE TABLE ttl_02265_r2
(
    date Date,
    key Int,
    value String TTL date + toIntervalMonth(1)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/ttl_02265', 'r2')
ORDER BY key
PARTITION BY date
SETTINGS min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

-- after, 20100101_0_0_0 will have ttl.txt and value.bin
INSERT INTO ttl_02265;

-- after, 20100101_0_0_1 will not have neither ttl.txt nor value.bin
OPTIMIZE TABLE ttl_02265 FINAL;

SYSTEM SYNC REPLICA ttl_02265 STRICT;

SYSTEM SYNC REPLICA ttl_02265_r2 STRICT;

-- after detach/attach it will not have TTL in-memory, and will not have ttl.txt
DETACH TABLE ttl_02265;

ATTACH TABLE ttl_02265;

SYSTEM FLUSH LOGS part_log;

SELECT *
FROM `system`.part_log
WHERE database = currentDatabase()
    AND table LIKE 'ttl_02265%'
    AND error != 0
    AND errorCodeToName(error) != 'NO_REPLICA_HAS_PART';