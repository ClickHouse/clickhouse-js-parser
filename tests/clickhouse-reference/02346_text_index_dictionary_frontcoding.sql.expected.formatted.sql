SET enable_full_text_index = '1';

-- Tests text index parameter `dictionary_block_frontcoding_compression`.
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    text_fc String,
    text_raw String,
    INDEX idx_raw text_raw TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = 6, dictionary_block_frontcoding_compression = 0) GRANULARITY 100000000,
    INDEX idx_fc text_fc TYPE text(tokenizer = 'splitByNonAlpha', dictionary_block_size = 6, dictionary_block_frontcoding_compression = 1) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

SELECT count()
FROM tab
WHERE hasToken(text_raw, 'foo');

SELECT count()
FROM tab
WHERE hasToken(text_fc, 'foo');

SELECT count()
FROM tab
WHERE hasToken(text_raw, 'bar');

SELECT count()
FROM tab
WHERE hasToken(text_fc, 'bar');

SELECT count()
FROM tab
WHERE hasToken(text_raw, 'abc');

SELECT count()
FROM tab
WHERE hasToken(text_fc, 'abc');

DROP TABLE tab;