-- Tags: zookeeper
DROP TABLE IF EXISTS table_for_alter;

SET replication_alter_partitions_sync = '2';

CREATE TABLE table_for_alter
(
    d Date,
    a String,
    b UInt8,
    x String,
    y Int8,
    version UInt64,
    sign Int8 DEFAULT 1
)
ENGINE = ReplicatedVersionedCollapsingMergeTree('/clickhouse/tables/{database}/01526_alter_add/t1', '1', sign, version)
ORDER BY d
PARTITION BY y
SETTINGS index_granularity = '8192';

INSERT INTO table_for_alter;

DETACH TABLE table_for_alter;

ATTACH TABLE table_for_alter;

SELECT *
FROM table_for_alter;

ALTER TABLE table_for_alter ADD COLUMN `order` UInt32, MODIFY ORDER BY (d, `order`);

SHOW CREATE TABLE table_for_alter;

ALTER TABLE table_for_alter ADD COLUMN datum UInt32, MODIFY ORDER BY (d, `order`, datum);

INSERT INTO table_for_alter;

SELECT *
FROM table_for_alter
ORDER BY d ASC;