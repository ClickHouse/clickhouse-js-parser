-- Tags: long, zookeeper
SET send_logs_level = 'fatal';

SET replication_alter_partitions_sync = '2';

DROP TABLE IF EXISTS alter_compression_codec1;

DROP TABLE IF EXISTS alter_compression_codec2;

CREATE TABLE alter_compression_codec1
(
    somedate Date CODEC(LZ4()),
    id UInt64 CODEC(NONE())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/' || currentDatabase() || 'alter_compression_codecs/{shard}', '1_{replica}')
ORDER BY id
PARTITION BY somedate;

CREATE TABLE alter_compression_codec2
(
    somedate Date CODEC(LZ4()),
    id UInt64 CODEC(NONE())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/' || currentDatabase() || 'alter_compression_codecs/{shard}', '2_{replica}')
ORDER BY id
PARTITION BY somedate;

INSERT INTO alter_compression_codec1;

INSERT INTO alter_compression_codec1;

SYSTEM SYNC REPLICA alter_compression_codec2;

SELECT *
FROM alter_compression_codec1
ORDER BY id ASC;

SELECT *
FROM alter_compression_codec2
ORDER BY id ASC;

ALTER TABLE alter_compression_codec1 ADD COLUMN alter_column String DEFAULT 'default_value' CODEC(ZSTD());

SYSTEM SYNC REPLICA alter_compression_codec1;

SELECT compression_codec
FROM `system`.`columns`
WHERE table = 'alter_compression_codec1'
    AND name = 'alter_column'
    AND database = currentDatabase();

SELECT compression_codec
FROM `system`.`columns`
WHERE table = 'alter_compression_codec2'
    AND name = 'alter_column'
    AND database = currentDatabase();

INSERT INTO alter_compression_codec1;

INSERT INTO alter_compression_codec1;

ALTER TABLE alter_compression_codec1 MODIFY COLUMN alter_column CODEC(NONE());

INSERT INTO alter_compression_codec2;

INSERT INTO alter_compression_codec2;

SET allow_suspicious_codecs = '1';

ALTER TABLE alter_compression_codec1 MODIFY COLUMN alter_column CODEC(ZSTD(), LZ4HC(), LZ4(), LZ4(), NONE());

INSERT INTO alter_compression_codec1;

INSERT INTO alter_compression_codec2;

ALTER TABLE alter_compression_codec1 MODIFY COLUMN alter_column FixedString(100);