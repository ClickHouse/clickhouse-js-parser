SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt64,
    c0 Tuple(c1 String, c2 String),
    INDEX i0 c0.c1 TYPE text(tokenizer = splitByString) GRANULARITY 100000000
)
ENGINE = SummingMergeTree()
ORDER BY id;

INSERT INTO tab (id, c0);

INSERT INTO tab (id, c0);

OPTIMIZE TABLE tab FINAL;

SELECT id
FROM tab
WHERE hasAllTokens(c0.c1, 'aa aaa')
SETTINGS force_data_skipping_indices = 'i0';

DROP TABLE tab;

CREATE TABLE tab
(
    id UInt64,
    c1 JSON(s1 String),
    INDEX i0 c1.s1 TYPE text(tokenizer = splitByString) GRANULARITY 100000000,
    INDEX i1 coalesce(c1.s2, '')::String TYPE text(tokenizer = splitByString) GRANULARITY 100000000
)
ENGINE = SummingMergeTree()
ORDER BY id;

INSERT INTO tab (id, c1);

INSERT INTO tab (id, c1);

SELECT id
FROM tab
WHERE hasAllTokens(c1.s1, 'AAA')
SETTINGS force_data_skipping_indices = 'i0';

SELECT id
FROM tab
WHERE hasAllTokens(coalesce(c1.s2, '')::String, 'BBB')
SETTINGS force_data_skipping_indices = 'i1';