DROP TABLE IF EXISTS ttl_test_02129;

CREATE TABLE ttl_test_02129
(
    a Int64,
    b String,
    d Date
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY d
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', materialize_ttl_recalculate_only = '0';

SYSTEM STOP TTL MERGES ttl_test_02129;

INSERT INTO ttl_test_02129 SELECT
    number,
    '',
    '2021-01-01'
FROM numbers(10);

ALTER TABLE ttl_test_02129 ADD COLUMN c Int64 SETTINGS mutations_sync = '2';

INSERT INTO ttl_test_02129 SELECT
    number,
    '',
    '2021-01-01',
    1
FROM numbers(10);

ALTER TABLE ttl_test_02129 MODIFY TTL d + toIntervalMonth(1) WHERE c = 1 SETTINGS mutations_sync = '2';

SELECT *
FROM ttl_test_02129
ORDER BY
    a ASC,
    b ASC,
    d ASC,
    c ASC;

DROP TABLE ttl_test_02129;

CREATE TABLE ttl_test_02129
(
    a Int64,
    b String,
    d Date
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY d
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', materialize_ttl_recalculate_only = '1';

ALTER TABLE ttl_test_02129 ADD COLUMN c Int64 SETTINGS mutations_sync = '2', alter_sync = '2';

ALTER TABLE ttl_test_02129 MODIFY TTL d + toIntervalMonth(1) WHERE c = 1 SETTINGS mutations_sync = '2', alter_sync = '2';

SYSTEM START TTL MERGES ttl_test_02129;

OPTIMIZE TABLE ttl_test_02129 FINAL;