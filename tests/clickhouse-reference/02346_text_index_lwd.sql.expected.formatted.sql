SET enable_full_text_index = '1';

-- Some tests for lightweight deleted on a column with text index
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    s FixedString(37),
    INDEX idx s TYPE text(tokenizer = array()) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab (s);

DELETE FROM tab WHERE true;

INSERT INTO tab (s);

INSERT INTO tab (s);

INSERT INTO tab (s);

INSERT INTO tab (s) SELECT CAST(number AS String)
FROM numbers(5);

INSERT INTO tab (s) SELECT s
FROM generateRandom('s FixedString(37)', 12734763443271340066, 25, 2)
LIMIT 3;

OPTIMIZE TABLE tab FINAL;

SELECT count()
FROM tab
WHERE hasAllTokens(s, 'was');

DROP TABLE tab;