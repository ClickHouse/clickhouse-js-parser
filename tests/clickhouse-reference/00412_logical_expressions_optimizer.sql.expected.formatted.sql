DROP TABLE IF EXISTS merge_tree;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE merge_tree
(
    x UInt64,
    date Date
)
ENGINE = MergeTree(date, x, 1);

INSERT INTO merge_tree;

SELECT
    x AS y,
    y
FROM merge_tree;