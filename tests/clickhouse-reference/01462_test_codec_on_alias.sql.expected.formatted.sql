DROP TABLE IF EXISTS compression_codec_on_alias;

CREATE TABLE compression_codec_on_alias
(
    c0 ALIAS c1 CODEC(ZSTD()),
    c1 UInt64
)
ENGINE = MergeTree()
ORDER BY c1
PARTITION BY c0; -- { serverError BAD_ARGUMENTS }

CREATE TABLE compression_codec_on_alias
(
    c0 UInt64 CODEC(ZSTD()),
    c1 UInt64
)
ENGINE = MergeTree()
ORDER BY c1
PARTITION BY c0; -- success

ALTER TABLE compression_codec_on_alias ADD COLUMN c3 ALIAS c2 CODEC(ZSTD()) AFTER c2; -- { serverError BAD_ARGUMENTS }

ALTER TABLE compression_codec_on_alias ADD COLUMN c2 UInt64 CODEC(ZSTD()) AFTER c1; -- success