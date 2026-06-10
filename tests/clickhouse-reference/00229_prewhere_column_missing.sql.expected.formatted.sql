DROP TABLE IF EXISTS prewhere_column_missing;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE prewhere_column_missing
(
    d Date DEFAULT '2015-01-01',
    x UInt64
)
ENGINE = MergeTree(d, x, 1);

INSERT INTO prewhere_column_missing (x);

SELECT *
FROM prewhere_column_missing;

ALTER TABLE prewhere_column_missing ADD COLUMN arr Array(UInt64);

SELECT
    *,
    arraySum(arr) AS s
FROM prewhere_column_missing;

SELECT
    *,
    arraySum(arr) AS s
FROM prewhere_column_missing
WHERE s = 0;

SELECT
    *,
    arraySum(arr) AS s
FROM prewhere_column_missing
PREWHERE s = 0;

SELECT
    *,
    length(arr) AS l
FROM prewhere_column_missing;

SELECT
    *,
    length(arr) AS l
FROM prewhere_column_missing
WHERE l = 0;

SELECT
    *,
    length(arr) AS l
FROM prewhere_column_missing
PREWHERE l = 0;

ALTER TABLE prewhere_column_missing ADD COLUMN hash_x UInt64 DEFAULT intHash64(x);

SELECT *
FROM prewhere_column_missing
WHERE hash_x = intHash64(x);

SELECT *
FROM prewhere_column_missing
PREWHERE hash_x = intHash64(x);

SELECT *
FROM prewhere_column_missing
WHERE hash_x = intHash64(x)
    AND length(arr) = 0;

SELECT *
FROM prewhere_column_missing
PREWHERE hash_x = intHash64(x)
    AND length(arr) = 0;

SELECT *
FROM prewhere_column_missing
WHERE hash_x = intHash64(x)
    AND length(arr) = 0
    AND arraySum(arr) = 0;

SELECT *
FROM prewhere_column_missing
PREWHERE hash_x = intHash64(x)
    AND length(arr) = 0
    AND arraySum(arr) = 0;

DROP TABLE prewhere_column_missing;