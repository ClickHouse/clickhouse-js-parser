-- Tags: long, zookeeper
SET prefer_warmed_unmerged_parts_seconds = '0';

DROP TABLE IF EXISTS byte_identical_r1;

DROP TABLE IF EXISTS byte_identical_r2;

CREATE TABLE byte_identical_r1
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00721/byte_identical', 'r1')
ORDER BY x;

CREATE TABLE byte_identical_r2
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00721/byte_identical', 'r2')
ORDER BY x;

INSERT INTO byte_identical_r1 (x);

SYSTEM SYNC REPLICA byte_identical_r2;

-- Add a column with a default expression that will yield different values on different replicas.
-- Call optimize to materialize it. Replicas should compare checksums and restore consistency.
ALTER TABLE byte_identical_r1 ADD COLUMN y UInt64 DEFAULT rand();

SYSTEM SYNC REPLICA byte_identical_r1;

SET replication_alter_partitions_sync = '2';

OPTIMIZE TABLE byte_identical_r1 PARTITION tuple() FINAL;

SELECT
    x,
    t1.y - t2.y
FROM
    byte_identical_r1 AS t1
SEMI LEFT JOIN byte_identical_r2 AS t2
    USING (x)
ORDER BY x ASC;

DROP TABLE byte_identical_r1;

DROP TABLE byte_identical_r2;