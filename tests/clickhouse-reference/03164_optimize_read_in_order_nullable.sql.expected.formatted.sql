-- Reproducer from https://github.com/ClickHouse/ClickHouse/issues/63460
DROP TABLE IF EXISTS `03164_users`;

CREATE TABLE `03164_users`
(
    uid Nullable(Int16),
    name String,
    age Int16
)
ENGINE = MergeTree()
ORDER BY uid
SETTINGS allow_nullable_key = '1';

INSERT INTO `03164_users`;

INSERT INTO `03164_users`;

INSERT INTO `03164_users`;

OPTIMIZE TABLE `03164_users` FINAL;

SELECT '-- Reproducer result:';

SELECT *
FROM `03164_users`
ORDER BY uid ASC NULLS FIRST
LIMIT 10
SETTINGS optimize_read_in_order = '1';

DROP TABLE IF EXISTS `03164_multi_key`;

CREATE TABLE `03164_multi_key`
(
    c1 Nullable(UInt32),
    c2 Nullable(UInt32)
)
ENGINE = MergeTree()
ORDER BY (c1, c2)
SETTINGS allow_nullable_key = '1';

INSERT INTO `03164_multi_key`;

-- Just in case
OPTIMIZE TABLE `03164_multi_key` FINAL;

SELECT
    c1,
    c2
FROM `03164_multi_key`
ORDER BY
    c1 ASC NULLS LAST,
    c2 ASC NULLS LAST
SETTINGS optimize_read_in_order = '1';

SELECT
    c1,
    c2
FROM `03164_multi_key`
ORDER BY
    c1 ASC NULLS LAST,
    c2 ASC NULLS FIRST
SETTINGS optimize_read_in_order = '1';

SELECT
    c1,
    c2
FROM `03164_multi_key`
ORDER BY
    c1 ASC NULLS FIRST,
    c2 ASC NULLS LAST
SETTINGS optimize_read_in_order = '1';

SELECT
    c1,
    c2
FROM `03164_multi_key`
ORDER BY
    c1 DESC NULLS FIRST,
    c2 DESC NULLS LAST
SETTINGS optimize_read_in_order = '1';