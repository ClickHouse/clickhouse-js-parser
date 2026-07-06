-- It's Ok to CLEAR column when there are columns with default expression depending on it.
-- But it's not Ok to DROP such column.
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt8,
    y UInt8 DEFAULT x + 1
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test (x);

SELECT *
FROM test
ORDER BY
    x ASC,
    y ASC;

ALTER TABLE test CLEAR COLUMN x;

ALTER TABLE test DROP COLUMN x; -- { serverError ILLEGAL_COLUMN }

DROP TABLE test;

CREATE TABLE test
(
    x UInt8,
    y UInt8 MATERIALIZED x + 1
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT
    x,
    y
FROM test
ORDER BY
    x ASC,
    y ASC;

CREATE TABLE test
(
    x UInt8,
    y UInt8 ALIAS x + 1,
    z String DEFAULT 'Hello'
)
ENGINE = MergeTree()
ORDER BY tuple();

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE Test
(
    impression_id String,
    impression_id_compressed FixedString(16) DEFAULT UUIDStringToNum(substring(impression_id, 1, 36)),
    impression_id_hashed UInt16 DEFAULT reinterpretAsUInt16(impression_id_compressed),
    event_date Date
)
ENGINE = MergeTree(event_date, impression_id_hashed, (event_date, impression_id_hashed), 8192);

ALTER TABLE Test CLEAR COLUMN impression_id IN PARTITION '202001';