SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'array') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab (str);

DROP TABLE tab;

CREATE TABLE tab
(
    str String,
    INDEX idx str TYPE text(tokenizer = 'ngrams') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();