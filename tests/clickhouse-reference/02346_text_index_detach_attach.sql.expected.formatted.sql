-- Test that detaching and attaching parts with a text index works
SET enable_full_text_index = '1';

CREATE TABLE tab
(
    key UInt64,
    str String,
    INDEX inv_idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO tab;

ALTER TABLE tab DETACH PART 'all_1_1_0';

ALTER TABLE tab ATTACH PART 'all_1_1_0';