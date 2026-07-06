DROP TABLE IF EXISTS index;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE index
(
    key Int32,
    name String,
    merge_date Date
)
ENGINE = MergeTree(merge_date, key, 8192);

INSERT INTO index;

INSERT INTO index;

SELECT *
FROM index
WHERE key = 1;

SELECT *
FROM index
WHERE key = -1;

OPTIMIZE TABLE index;

SELECT *
FROM index
WHERE key < -0.5;

DROP TABLE index;