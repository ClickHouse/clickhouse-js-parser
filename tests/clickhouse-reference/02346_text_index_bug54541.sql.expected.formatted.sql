-- Test for AST Fuzzer crash #54541
SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

SELECT *
FROM tab
WHERE str = 'b'
    AND 1.;