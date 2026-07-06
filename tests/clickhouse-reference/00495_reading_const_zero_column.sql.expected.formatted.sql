DROP TABLE IF EXISTS one_table;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE one_table
(
    date Date,
    one UInt64
)
ENGINE = MergeTree(date, (date, one), 8192);

INSERT INTO one_table SELECT
    today(),
    toUInt64(1)
FROM `system`.numbers
LIMIT 100000;

SET preferred_block_size_bytes = '8192';

SELECT isNull(one)
FROM one_table
WHERE isNull(one);