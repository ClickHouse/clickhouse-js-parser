-- Tags: long, replica, no-replicated-database, no-shared-merge-tree
-- Tag no-replicated-database: Old syntax is not allowed
-- no-shared-merge-tree: implemented another test
DROP TABLE IF EXISTS replicated_alter1;

DROP TABLE IF EXISTS replicated_alter2;

SET replication_alter_partitions_sync = '2';

SET mutations_sync = '2';

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE replicated_alter1
(
    d Date,
    k UInt64,
    i32 Int32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00062/alter', 'r1', d, k, 8192);

CREATE TABLE replicated_alter2
(
    d Date,
    k UInt64,
    i32 Int32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00062/alter', 'r2', d, k, 8192);

INSERT INTO replicated_alter1;

DESCRIBE TABLE replicated_alter1;

SHOW CREATE TABLE replicated_alter1;

DESCRIBE TABLE replicated_alter2;

SHOW CREATE TABLE replicated_alter2;

SELECT *
FROM replicated_alter1
ORDER BY k ASC;

ALTER TABLE replicated_alter1 ADD COLUMN dt DateTime('UTC');

INSERT INTO replicated_alter1;

ALTER TABLE replicated_alter1 ADD COLUMN n Nested(ui8 UInt8, s String);

INSERT INTO replicated_alter1;

ALTER TABLE replicated_alter1 ADD COLUMN `n.d` Array(Date);

INSERT INTO replicated_alter1;

ALTER TABLE replicated_alter1 ADD COLUMN s String DEFAULT '0';

INSERT INTO replicated_alter1;

ALTER TABLE replicated_alter1 DROP COLUMN `n.d`, MODIFY COLUMN s Int64;

ALTER TABLE replicated_alter1 ADD COLUMN `n.d` Array(Date), MODIFY COLUMN s UInt32;

ALTER TABLE replicated_alter1 DROP COLUMN n.ui8, DROP COLUMN n.d;

ALTER TABLE replicated_alter1 DROP COLUMN n.s;

ALTER TABLE replicated_alter1 ADD COLUMN `n.s` Array(String), ADD COLUMN `n.d` Array(Date);

ALTER TABLE replicated_alter1 DROP COLUMN n;

ALTER TABLE replicated_alter1 MODIFY COLUMN dt Date, MODIFY COLUMN s DateTime('UTC') DEFAULT '1970-01-01 00:00:00';

DROP TABLE replicated_alter1;

DROP TABLE replicated_alter2;