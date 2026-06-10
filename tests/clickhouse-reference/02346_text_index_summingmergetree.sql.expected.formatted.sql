SET enable_full_text_index = '1';

-- Tests text index with the 'SummingMergeTree' engine
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    key String,
    value UInt32,
    INDEX idx_key key TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = SummingMergeTree()
ORDER BY id;

SYSTEM STOP MERGES tab;

INSERT INTO tab;

SELECT '-- direct read disabled';

SET use_skip_indexes_on_data_read = '0';

SELECT sum(value)
FROM tab
WHERE hasToken(key, 'foo');

SELECT sum(value)
FROM tab
WHERE hasToken(key, 'bar');

SET use_skip_indexes_on_data_read = '1';

SYSTEM START MERGES tab;

OPTIMIZE TABLE tab FINAL; -- emulate merge

SELECT value
FROM tab
WHERE hasToken(key, 'foo');

SELECT value
FROM tab
WHERE hasToken(key, 'bar');

DROP TABLE tab;