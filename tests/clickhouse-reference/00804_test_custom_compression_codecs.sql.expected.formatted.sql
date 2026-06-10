SET send_logs_level = 'fatal';

SET allow_suspicious_codecs = '1';

DROP TABLE IF EXISTS compression_codec;

CREATE TABLE compression_codec
(
    id UInt64 CODEC(LZ4()),
    data String CODEC(ZSTD()),
    ddd Date CODEC(NONE()),
    somenum Float64 CODEC(ZSTD(2)),
    somestr FixedString(3) CODEC(LZ4HC(7)),
    othernum Int64 CODEC(Delta())
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO compression_codec;

INSERT INTO compression_codec;

INSERT INTO compression_codec;

SELECT *
FROM compression_codec
ORDER BY id ASC;

OPTIMIZE TABLE compression_codec FINAL;

INSERT INTO compression_codec;

DETACH TABLE compression_codec;

ATTACH TABLE compression_codec;

SELECT count(*)
FROM compression_codec
WHERE id = 2
GROUP BY id;

DROP TABLE IF EXISTS bad_codec;

DROP TABLE IF EXISTS params_when_no_params;

DROP TABLE IF EXISTS too_many_params;

DROP TABLE IF EXISTS codec_multiple_direct_specification_1;

DROP TABLE IF EXISTS codec_multiple_direct_specification_2;

DROP TABLE IF EXISTS delta_bad_params1;

DROP TABLE IF EXISTS delta_bad_params2;

CREATE TABLE bad_codec
(
    id UInt64 CODEC(adssadads())
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError UNKNOWN_CODEC }

CREATE TABLE too_many_params
(
    id UInt64 CODEC(ZSTD(2, 3, 4, 5))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError ILLEGAL_SYNTAX_FOR_CODEC_TYPE }

CREATE TABLE params_when_no_params
(
    id UInt64 CODEC(LZ4(1))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError DATA_TYPE_CANNOT_HAVE_ARGUMENTS }

CREATE TABLE codec_multiple_direct_specification_1
(
    id UInt64 CODEC(MULTIPLE(LZ4, ZSTD))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError UNKNOWN_CODEC }

CREATE TABLE codec_multiple_direct_specification_2
(
    id UInt64 CODEC(multiple(LZ4, ZSTD))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError UNKNOWN_CODEC }

CREATE TABLE delta_bad_params1
(
    id UInt64 CODEC(Delta(3))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError ILLEGAL_CODEC_PARAMETER }

CREATE TABLE delta_bad_params2
(
    id UInt64 CODEC(Delta(16))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError ILLEGAL_CODEC_PARAMETER }

DROP TABLE IF EXISTS compression_codec_multiple;

SET network_compression_method = 'lz4hc';

CREATE TABLE compression_codec_multiple
(
    id UInt64 CODEC(LZ4(), ZSTD(), NONE(), LZ4HC(), Delta(4)),
    data String CODEC(ZSTD(2), NONE(), Delta(2), LZ4HC(), LZ4(), LZ4(), Delta(8)),
    ddd Date CODEC(NONE(), NONE(), NONE(), Delta(1), LZ4(), ZSTD(), LZ4HC(), LZ4HC()),
    somenum Float64 CODEC(Delta(4), LZ4(), LZ4(), ZSTD(2), LZ4HC(5), ZSTD(3), ZSTD())
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO compression_codec_multiple;

SELECT *
FROM compression_codec_multiple
ORDER BY id ASC;

INSERT INTO compression_codec_multiple SELECT
    modulo(number, 100),
    toString(number),
    toDate('2018-12-01'),
    5.5 * number
FROM `system`.numbers
LIMIT 10000;

SELECT count(*)
FROM compression_codec_multiple;

SELECT countDistinct(data)
FROM compression_codec_multiple;

SELECT floor(sum(somenum), 1)
FROM compression_codec_multiple;

TRUNCATE TABLE compression_codec_multiple;

SELECT sum(cityHash64(*))
FROM compression_codec_multiple;

DROP TABLE IF EXISTS compression_codec_multiple_more_types;

CREATE TABLE compression_codec_multiple_more_types
(
    id Decimal128(13) CODEC(ZSTD(), LZ4(), ZSTD(), ZSTD(), Delta(2), Delta(4), Delta(1), LZ4HC()),
    data FixedString(12) CODEC(ZSTD(), ZSTD(), Delta(), Delta(), Delta(), NONE(), NONE(), NONE(), LZ4HC()),
    ddd Nested(age UInt8, Name String) CODEC(LZ4(), LZ4HC(), NONE(), NONE(), NONE(), ZSTD(), Delta(8))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE compression_codec_multiple_more_types
(
    id Decimal128(13) CODEC(ZSTD(), LZ4(), ZSTD(), ZSTD(), Delta(2), Delta(4), Delta(1), LZ4HC()),
    data FixedString(12) CODEC(ZSTD(), ZSTD(), NONE(), NONE(), NONE(), LZ4HC()),
    ddd Nested(age UInt8, Name String) CODEC(LZ4(), LZ4HC(), NONE(), NONE(), NONE(), ZSTD(), Delta(8))
)
ENGINE = MergeTree()
ORDER BY tuple();

SHOW CREATE TABLE compression_codec_multiple_more_types;

INSERT INTO compression_codec_multiple_more_types;

INSERT INTO compression_codec_multiple_more_types;

SELECT *
FROM compression_codec_multiple_more_types
ORDER BY id ASC;

DROP TABLE IF EXISTS compression_codec_multiple_with_key;

SET network_compression_method = 'zstd';

SET network_zstd_compression_level = '5';

CREATE TABLE compression_codec_multiple_with_key
(
    somedate Date CODEC(ZSTD(), ZSTD(), ZSTD(12), LZ4HC(12), Delta(), Delta()),
    id UInt64 CODEC(LZ4(), ZSTD(), Delta(), NONE(), LZ4HC(), Delta()),
    data String CODEC(ZSTD(2), Delta(1), LZ4HC(), NONE(), LZ4(), LZ4())
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY somedate
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO compression_codec_multiple_with_key;

SELECT data
FROM compression_codec_multiple_with_key
WHERE id >= 3
    AND id <= 1112;

INSERT INTO compression_codec_multiple_with_key SELECT
    toDate('2018-10-12'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 1000;

SELECT COUNTDistinct(data)
FROM compression_codec_multiple_with_key
WHERE id < 222;

SET network_zstd_compression_level = '7';

INSERT INTO compression_codec_multiple_with_key;

SELECT data
FROM compression_codec_multiple_with_key
WHERE id = 2222;

DROP TABLE IF EXISTS test_default_delta;

CREATE TABLE test_default_delta
(
    id UInt64 CODEC(Delta()),
    data String CODEC(Delta(1)),
    somedate Date CODEC(Delta()),
    somenum Float64 CODEC(Delta()),
    somestr FixedString(3) CODEC(Delta(1)),
    othernum Int64 CODEC(Delta()),
    yetothernum Float32 CODEC(Delta()),
    ddd Nested(age UInt8, Name String, OName String, BName String) CODEC(Delta(1))
)
ENGINE = MergeTree()
ORDER BY tuple();

SHOW CREATE TABLE test_default_delta;

DROP TABLE compression_codec_multiple;

DROP TABLE compression_codec_multiple_more_types;