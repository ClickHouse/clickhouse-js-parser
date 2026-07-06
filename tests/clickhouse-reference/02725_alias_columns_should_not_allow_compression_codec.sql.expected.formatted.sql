DROP TABLE IF EXISTS alias_column_should_not_allow_compression;

CREATE TABLE IF NOT EXISTS alias_column_should_not_allow_compression
(
    user_id UUID,
    user_id_hashed ALIAS cityHash64(user_id)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE IF NOT EXISTS alias_column_should_not_allow_compression_fail
(
    user_id UUID,
    user_id_hashed ALIAS cityHash64(user_id) CODEC(LZ4HC(1))
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

ALTER TABLE alias_column_should_not_allow_compression MODIFY COLUMN user_id CODEC(LZ4HC(1));

ALTER TABLE alias_column_should_not_allow_compression MODIFY COLUMN user_id_hashed CODEC(LZ4HC(1)); -- { serverError BAD_ARGUMENTS }

ALTER TABLE alias_column_should_not_allow_compression ADD COLUMN user_id_hashed_1 UInt64 ALIAS cityHash64(user_id) CODEC(LZ4HC(1)); -- { serverError BAD_ARGUMENTS }