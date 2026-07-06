DROP TABLE IF EXISTS `03409_users` SYNC;

CREATE TABLE `03409_users`
(
    uid Int16,
    name String,
    age Nullable(Int16),
    age2 Nullable(Int16),
    version Nullable(UInt8)
)
ENGINE = ReplicatedCoalescingMergeTree('/clickhouse/tables/{database}/test_00754/summing', 'r1')
ORDER BY (uid, name);

INSERT INTO `03409_users`;

INSERT INTO `03409_users`;

INSERT INTO `03409_users`;

INSERT INTO `03409_users`;

INSERT INTO `03409_users`;

OPTIMIZE TABLE `03409_users` FINAL;

SYSTEM SYNC REPLICA `03409_users`;

SELECT *
FROM `03409_users`
ORDER BY `ALL` ASC;

CREATE TABLE `03409_users`
(
    uid Int16,
    name String,
    age Nullable(Int16),
    age2 Nullable(Int16),
    version Nullable(UInt8)
)
ENGINE = ReplicatedCoalescingMergeTree('/clickhouse/tables/{database}/test_00754/summing', 'r1', version)
ORDER BY (uid, name);

INSERT INTO `03409_users`;

INSERT INTO `03409_users`;