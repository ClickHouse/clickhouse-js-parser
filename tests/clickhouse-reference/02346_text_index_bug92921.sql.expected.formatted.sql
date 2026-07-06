SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    s Array(String),
    INDEX idx s TYPE text(tokenizer = sparseGrams) GRANULARITY 100000000,
    PROJECTION p (SELECT s ORDER BY s)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab (s);

INSERT INTO tab (s);

OPTIMIZE TABLE tab FINAL;

DROP TABLE tab;