-- Tags: zookeeper, no-replicated-database
-- Tag no-replicated-database: Fails due to additional replicas or shards
DROP TABLE IF EXISTS enum_alter_issue;

CREATE TABLE enum_alter_issue
(
    a Enum16('one' = 1, 'two' = 2),
    b Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02012/enum_alter_issue', 'r2')
ORDER BY b;

INSERT INTO enum_alter_issue;

ALTER TABLE enum_alter_issue DETACH PARTITION ID 'all';

ALTER TABLE enum_alter_issue MODIFY COLUMN a Enum8('one' = 1, 'two' = 2, 'three' = 3);

ALTER TABLE enum_alter_issue ATTACH PARTITION ID 'all';

SELECT *
FROM enum_alter_issue;

DROP TABLE enum_alter_issue;