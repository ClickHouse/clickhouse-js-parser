SET enable_full_text_index = '1';

SET use_skip_indexes_on_data_read = '1';

-- Tests for text indexes build on expressions
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt64,
    s1 String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

ALTER TABLE tab ADD INDEX idx_text lower(s1) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000;

INSERT INTO tab;

OPTIMIZE TABLE tab FINAL;

SELECT id
FROM tab
WHERE hasAllTokens(lower(s1), 'a')
ORDER BY id ASC;

SELECT id
FROM tab
WHERE hasAllTokens(lower(s1), 'b')
ORDER BY id ASC;

CREATE TABLE tab
(
    id UInt64,
    s1 String,
    s2 String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

ALTER TABLE tab ADD INDEX idx_text concat(s1, ' ', s2) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000;

INSERT INTO tab;

SELECT id
FROM tab
WHERE hasAllTokens(concat(s1, ' ', s2), 'A');

SELECT id
FROM tab
WHERE hasAllTokens(concat(s1, ' ', s2), 'D');