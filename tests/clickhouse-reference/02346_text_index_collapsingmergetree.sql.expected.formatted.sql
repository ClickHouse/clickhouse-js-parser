SET enable_full_text_index = '1';

-- Tests text index with the 'CollapsingMergeTree' engine
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    key String,
    value Nullable(String),
    sign Int8,
    INDEX idx_key key TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY id;

INSERT INTO tab;

INSERT INTO tab;

SELECT '-- direct read disabled';

SET use_skip_indexes_on_data_read = '0';

SELECT value
FROM tab
WHERE hasToken(key, 'foo')
ORDER BY value ASC;

SET use_skip_indexes_on_data_read = '1';

SELECT value
FROM tab
WHERE hasToken(key, 'bar')
ORDER BY value ASC;

SELECT value
FROM tab FINAL
WHERE hasToken(key, 'foo')
ORDER BY value ASC;

SELECT value
FROM tab FINAL
WHERE hasToken(key, 'bar')
ORDER BY value ASC;

DROP TABLE tab;