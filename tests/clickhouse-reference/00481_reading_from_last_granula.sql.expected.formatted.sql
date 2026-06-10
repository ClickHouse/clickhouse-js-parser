DROP TABLE IF EXISTS tab_00481;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE tab_00481
(
    date Date,
    value UInt64,
    s String,
    m FixedString(16)
)
ENGINE = MergeTree(date, (date, value), 8);

INSERT INTO tab_00481 SELECT
    today() AS date,
    number AS value,
    '' AS s,
    toFixedString('', 16) AS m
FROM `system`.numbers
LIMIT 42;

SET preferred_max_column_in_block_size_bytes = '32';

SELECT
    blockSize(),
    *
FROM tab_00481
FORMAT Null;

SELECT 0;

DROP TABLE tab_00481;