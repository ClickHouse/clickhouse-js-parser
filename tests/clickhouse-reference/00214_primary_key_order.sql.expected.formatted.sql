DROP TABLE IF EXISTS primary_key;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE primary_key
(
    d Date DEFAULT today(),
    x Int8
)
ENGINE = MergeTree(d, -x, 1);

INSERT INTO primary_key (x);

SELECT x
FROM primary_key
ORDER BY x ASC;

SELECT
    'a',
    -x
FROM primary_key
WHERE -x < -3;

SELECT
    'b',
    -x
FROM primary_key
WHERE -x < -2;

SELECT
    'c',
    -x
FROM primary_key
WHERE -x < -1;

SELECT
    'd',
    -x
FROM primary_key
WHERE -x < toInt8(0);

DROP TABLE primary_key;