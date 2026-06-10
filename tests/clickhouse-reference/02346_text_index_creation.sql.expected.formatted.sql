SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text() GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

DROP TABLE tab;

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'ngrams') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'sparseGrams') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByString') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'array') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT '-- tokenizer must be splitByNonAlpha, ngrams, sparseGrams, splitByString or array.';

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'invalid') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByNonAlpha()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByString) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByString()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = `array`) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = array()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams(4)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams(0)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams(-1)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams(18446744073709552000.)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(3)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(3, 4)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(3, 4, 4)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(2)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(101)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(50, 49)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(50, 51, 49)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = sparseGrams(50, 51, 52)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByString(['\n', '\\'])) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByString('\n')) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = splitByString([1, 2])) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_block_size = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_block_size = 0) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_block_size = 1024.) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = 0) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = 1024.) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = '1024') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = -1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = 1024.) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = '1024') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = -1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = 0) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_codec = 1024) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_codec = 1.) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_codec = 'none') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_codec = 'bitpacking') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', posting_list_codec = 'invalid_codec') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- TODO: this should throw an exception but it doesn't

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(ngrams) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams('4')) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', tokenizer = ngrams(3)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = ngrams(3), tokenizer = ngrams(4)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_frontcoding_compression = 1, dictionary_block_frontcoding_compression = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha', non_existing_argument = 1024) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    str1 String,
    str2 String,
    INDEX idx (str1, str2) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError INCORRECT_NUMBER_OF_COLUMNS }

CREATE TABLE tab
(
    s String,
    INDEX idx_1 s TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_2 s TYPE text(tokenizer = ngrams(3)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    str String,
    INDEX idx_1 str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

ALTER TABLE tab ADD INDEX idx_2 str TYPE text(tokenizer = ngrams(3)) GRANULARITY 100000000; -- { serverError BAD_ARGUMENTS }

-- It must still be possible to create a column on the same column with a different expression
ALTER TABLE tab ADD INDEX idx_3 lower(str) TYPE text(tokenizer = ngrams(3)) GRANULARITY 100000000;

CREATE TABLE tab
(
    key UInt64,
    u64 UInt64,
    INDEX idx u64 TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    f32 Float32,
    INDEX idx f32 TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    arr Array(UInt64),
    INDEX idx arr TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    arr Array(Float32),
    INDEX idx arr TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    map Map(UInt64, String),
    INDEX idx mapKeys(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    map Map(Float32, String),
    INDEX idx mapKeys(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    map Map(String, UInt64),
    INDEX idx mapValues(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    map Map(String, Float32),
    INDEX idx mapValues(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    n_str Nullable(String),
    INDEX idx n_str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE tab
(
    key UInt64,
    lc LowCardinality(UInt64),
    INDEX idx lc TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    lc LowCardinality(Float32),
    INDEX idx lc TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tab
(
    key UInt64,
    str String,
    str_fixed FixedString(3),
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_fixed str_fixed TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO tab;

SELECT count()
FROM tab
WHERE str = 'foo'
SETTINGS force_data_skipping_indices = 'idx';

SELECT count()
FROM tab
WHERE str_fixed = toFixedString('foo', 3)
SETTINGS force_data_skipping_indices = 'idx_fixed';

CREATE TABLE tab
(
    key UInt64,
    lc LowCardinality(String),
    lc_fixed LowCardinality(FixedString(3)),
    INDEX idx lc TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_fixed lc_fixed TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key;

SELECT count()
FROM tab
WHERE lc = 'foo'
SETTINGS force_data_skipping_indices = 'idx';

SELECT count()
FROM tab
WHERE lc_fixed = toFixedString('foo', 3)
SETTINGS force_data_skipping_indices = 'idx_fixed';

CREATE TABLE tab
(
    key UInt64,
    arr Array(String),
    arr_fixed Array(FixedString(3)),
    INDEX idx arr TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_fixed arr_fixed TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO tab;

SELECT count()
FROM tab
WHERE has(arr, 'foo')
SETTINGS force_data_skipping_indices = 'idx';

SELECT count()
FROM tab
WHERE has(arr_fixed, toFixedString('foo', 3))
SETTINGS force_data_skipping_indices = 'idx_fixed';

CREATE TABLE tab
(
    key UInt64,
    map Map(String, String),
    map_fixed Map(FixedString(3), FixedString(3)),
    INDEX idx_keys mapKeys(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_keys_fixed mapKeys(map_fixed) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_values mapValues(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX idx_values_fixed mapValues(map_fixed) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO tab;

SELECT count()
FROM tab
WHERE mapContainsKey(map, 'foo')
SETTINGS force_data_skipping_indices = 'idx_keys';

SELECT count()
FROM tab
WHERE mapContainsKey(map_fixed, toFixedString('foo', 3))
SETTINGS force_data_skipping_indices = 'idx_keys_fixed';

SELECT count()
FROM tab
WHERE has(mapValues(map), 'foo')
SETTINGS force_data_skipping_indices = 'idx_values';

SELECT count()
FROM tab
WHERE has(mapValues(map_fixed), toFixedString('foo', 3))
SETTINGS force_data_skipping_indices = 'idx_values_fixed';