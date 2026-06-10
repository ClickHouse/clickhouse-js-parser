-- Tags: long, replica, no-replicated-database, no-shared-merge-tree
-- Tag no-replicated-database: Old syntax is not allowed
-- no-shared-merge-tree -- old syntax not supported, for new syntax additional test
SET optimize_on_insert = '0';

SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS old_style;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE old_style
(
    d Date,
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00754/old_style', 'r1', d, x, 8192);

ALTER TABLE old_style ADD COLUMN y UInt32, MODIFY ORDER BY (x, y); -- { serverError BAD_ARGUMENTS }

DROP TABLE old_style;

DROP TABLE IF EXISTS summing_r1;

DROP TABLE IF EXISTS summing_r2;

CREATE TABLE summing_r1
(
    x UInt32,
    y UInt32,
    val UInt32
)
ENGINE = ReplicatedSummingMergeTree('/clickhouse/tables/{database}/test_00754/summing', 'r1')
ORDER BY (x, y);

CREATE TABLE summing_r2
(
    x UInt32,
    y UInt32,
    val UInt32
)
ENGINE = ReplicatedSummingMergeTree('/clickhouse/tables/{database}/test_00754/summing', 'r2')
ORDER BY (x, y);

/* Can't add an expression with existing column to ORDER BY. */
ALTER TABLE summing_r1 MODIFY ORDER BY (x, y, -val); -- { serverError BAD_ARGUMENTS }

/* Can't add an expression with existing column to ORDER BY. */
ALTER TABLE summing_r1 ADD COLUMN z UInt32 DEFAULT x + 1, MODIFY ORDER BY (x, y, -z); -- { serverError BAD_ARGUMENTS }

/* Can't add nonexistent column to ORDER BY. */
ALTER TABLE summing_r1 MODIFY ORDER BY (x, y, nonexistent); -- { serverError UNKNOWN_IDENTIFIER }

/* Can't modyfy ORDER BY so that it is no longer a prefix of the PRIMARY KEY. */
ALTER TABLE summing_r1 MODIFY ORDER BY x; -- { serverError BAD_ARGUMENTS }

ALTER TABLE summing_r1 ADD COLUMN z UInt32 AFTER y, MODIFY ORDER BY (x, y, -z);

INSERT INTO summing_r1 (x, y, z, val);

SYSTEM SYNC REPLICA summing_r2;

SELECT *
FROM summing_r2;

INSERT INTO summing_r1 (x, y, z, val);

SELECT *
FROM summing_r2 FINAL
ORDER BY
    x ASC,
    y ASC,
    z ASC;

SHOW CREATE TABLE summing_r2;

DETACH TABLE summing_r2;

ALTER TABLE summing_r1 ADD COLUMN t UInt32 AFTER z, MODIFY ORDER BY (x, y, t * t) SETTINGS replication_alter_partitions_sync = '2'; -- { serverError UNFINISHED }

ATTACH TABLE summing_r2;

DROP TABLE summing_r1;

DROP TABLE summing_r2;