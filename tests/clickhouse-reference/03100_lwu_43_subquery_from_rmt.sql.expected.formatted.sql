DROP TABLE IF EXISTS lightweight_test SYNC;

DROP TABLE IF EXISTS keys SYNC;

CREATE TABLE lightweight_test
(
    ts DateTime,
    value String,
    key String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/lightweight_test', '1')
ORDER BY key
PARTITION BY toYYYYMMDD(ts)
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

CREATE TABLE keys
(
    key String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/keys', '1')
ORDER BY key;

INSERT INTO lightweight_test;

INSERT INTO keys;

SELECT
    key,
    value
FROM lightweight_test
ORDER BY key ASC;

UPDATE lightweight_test SET value = 'UPDATED-1' WHERE key IN (
    SELECT key
    FROM keys
);