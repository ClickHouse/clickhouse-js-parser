-- Tags: long, replica
SET send_logs_level = 'fatal';

SET allow_suspicious_codecs = '1';

DROP TABLE IF EXISTS compression_codec_replicated1;

DROP TABLE IF EXISTS compression_codec_replicated2;

CREATE TABLE compression_codec_replicated1
(
    id UInt64 CODEC(LZ4()),
    data String CODEC(ZSTD()),
    ddd Date CODEC(NONE()),
    somenum Float64 CODEC(ZSTD(2)),
    somestr FixedString(3) CODEC(LZ4HC(7)),
    othernum Int64 CODEC(Delta())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_replicated', '1')
ORDER BY tuple();

CREATE TABLE compression_codec_replicated2
(
    id UInt64 CODEC(LZ4()),
    data String CODEC(ZSTD()),
    ddd Date CODEC(NONE()),
    somenum Float64 CODEC(ZSTD(2)),
    somestr FixedString(3) CODEC(LZ4HC(7)),
    othernum Int64 CODEC(Delta())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_replicated', '2')
ORDER BY tuple();

INSERT INTO compression_codec_replicated1;

INSERT INTO compression_codec_replicated1;

INSERT INTO compression_codec_replicated1;

SYSTEM SYNC REPLICA compression_codec_replicated2;

SELECT *
FROM compression_codec_replicated1
ORDER BY id ASC;

SELECT *
FROM compression_codec_replicated2
ORDER BY id ASC;

OPTIMIZE TABLE compression_codec_replicated1 FINAL;

INSERT INTO compression_codec_replicated1;

DETACH TABLE compression_codec_replicated1;

ATTACH TABLE compression_codec_replicated1;

SELECT count(*)
FROM compression_codec_replicated1
WHERE id = 2
GROUP BY id;

SELECT count(*)
FROM compression_codec_replicated2
WHERE id = 2
GROUP BY id;

DROP TABLE IF EXISTS compression_codec_multiple_replicated1;

DROP TABLE IF EXISTS compression_codec_multiple_replicated2;

SET network_compression_method = 'lz4hc';

CREATE TABLE compression_codec_multiple_replicated1
(
    id UInt64 CODEC(LZ4(), ZSTD(), NONE(), LZ4HC(), Delta(4)),
    data String CODEC(ZSTD(2), NONE(), Delta(2), LZ4HC(), LZ4(), LZ4(), Delta(8)),
    ddd Date CODEC(NONE(), NONE(), NONE(), Delta(1), LZ4(), ZSTD(), LZ4HC(), LZ4HC()),
    somenum Float64 CODEC(Delta(4), LZ4(), LZ4(), ZSTD(2), LZ4HC(5), ZSTD(3), ZSTD())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_multiple', '1')
ORDER BY tuple();

CREATE TABLE compression_codec_multiple_replicated2
(
    id UInt64 CODEC(LZ4(), ZSTD(), NONE(), LZ4HC(), Delta(4)),
    data String CODEC(ZSTD(2), NONE(), Delta(2), LZ4HC(), LZ4(), LZ4(), Delta(8)),
    ddd Date CODEC(NONE(), NONE(), NONE(), Delta(1), LZ4(), ZSTD(), LZ4HC(), LZ4HC()),
    somenum Float64 CODEC(Delta(4), LZ4(), LZ4(), ZSTD(2), LZ4HC(5), ZSTD(3), ZSTD())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_multiple', '2')
ORDER BY tuple();

INSERT INTO compression_codec_multiple_replicated2;

SYSTEM SYNC REPLICA compression_codec_multiple_replicated1;

SELECT *
FROM compression_codec_multiple_replicated2
ORDER BY id ASC;

SELECT *
FROM compression_codec_multiple_replicated1
ORDER BY id ASC;

INSERT INTO compression_codec_multiple_replicated1 SELECT
    modulo(number, 100),
    toString(number),
    toDate('2018-12-01'),
    5.5 * number
FROM `system`.numbers
LIMIT 10000;

SYSTEM SYNC REPLICA compression_codec_multiple_replicated2;

SELECT count(*)
FROM compression_codec_multiple_replicated1;

SELECT count(*)
FROM compression_codec_multiple_replicated2;

SELECT countDistinct(data)
FROM compression_codec_multiple_replicated1;

SELECT countDistinct(data)
FROM compression_codec_multiple_replicated2;

SELECT floor(sum(somenum), 1)
FROM compression_codec_multiple_replicated1;

SELECT floor(sum(somenum), 1)
FROM compression_codec_multiple_replicated2;

TRUNCATE TABLE compression_codec_multiple_replicated1;

SELECT sum(cityHash64(*))
FROM compression_codec_multiple_replicated2;

SELECT sum(cityHash64(*))
FROM compression_codec_multiple_replicated1;

DROP TABLE IF EXISTS compression_codec_multiple_more_types_replicated;

CREATE TABLE compression_codec_multiple_more_types_replicated
(
    id Decimal128(13) CODEC(ZSTD(), LZ4(), ZSTD(), ZSTD(), Delta(2), Delta(4), Delta(1), LZ4HC()),
    data FixedString(12) CODEC(ZSTD(), ZSTD(), Delta(1), Delta(1), Delta(1), NONE(), NONE(), NONE(), LZ4HC()),
    ddd Nested(age UInt8, Name String) CODEC(LZ4(), LZ4HC(), NONE(), NONE(), NONE(), ZSTD(), Delta(8))
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_multiple_more_types_replicated', '1')
ORDER BY tuple();

SHOW CREATE TABLE compression_codec_multiple_more_types_replicated;

INSERT INTO compression_codec_multiple_more_types_replicated;

INSERT INTO compression_codec_multiple_more_types_replicated;

SELECT *
FROM compression_codec_multiple_more_types_replicated
ORDER BY id ASC;

DROP TABLE IF EXISTS compression_codec_multiple_with_key_replicated;

SET network_compression_method = 'zstd';

SET network_zstd_compression_level = '5';

CREATE TABLE compression_codec_multiple_with_key_replicated
(
    somedate Date CODEC(ZSTD(), ZSTD(), ZSTD(12), LZ4HC(12), Delta(), Delta()),
    id UInt64 CODEC(LZ4(), ZSTD(), Delta(), NONE(), LZ4HC(), Delta()),
    data String CODEC(ZSTD(2), Delta(1), LZ4HC(), NONE(), LZ4(), LZ4())
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00910/compression_codec_multiple_with_key_replicated', '1')
ORDER BY id
PARTITION BY somedate
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO compression_codec_multiple_with_key_replicated;

SELECT data
FROM compression_codec_multiple_with_key_replicated
WHERE id >= 3
    AND id <= 1112;

INSERT INTO compression_codec_multiple_with_key_replicated SELECT
    toDate('2018-10-12'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 1000;

SELECT COUNTDistinct(data)
FROM compression_codec_multiple_with_key_replicated
WHERE id < 222;

DROP TABLE compression_codec_multiple_more_types_replicated;