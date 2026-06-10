DROP TABLE IF EXISTS bug;

CREATE TABLE IF NOT EXISTS bug
(
    k UInt64,
    s UInt64
)
ENGINE = Memory();

INSERT INTO bug;

SET optimize_min_equality_disjunction_chain_length = '2';

SELECT *
FROM bug;

SELECT *
FROM bug
WHERE (k = 1
    OR k = 2
    OR k = 3)
    AND (s = 21
    OR s = 22
    OR s = 23);

SELECT *
FROM bug
WHERE (k = 1
    OR k = 2
    OR k = 3)
    AND (s = 21
    OR s = 22
    OR s = 23)
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT *
FROM bug
WHERE (k = 1
    OR k = 2
    OR k = 3)
    AND (s = 21
    OR s = 22
    OR s = 23)
SETTINGS enable_analyzer = '1';

;

SELECT *
FROM (
        SELECT *
        FROM bug
        WHERE k = 1
            OR k = 2
            OR k = 3
    )
WHERE s = 21
    OR s = 22
    OR s = 23;

SELECT *
FROM (
        SELECT *
        FROM bug
        WHERE k = 1
            OR k = 2
            OR k = 3
    )
WHERE s = 21
    OR s = 22
    OR s = 23
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT *
FROM (
        SELECT *
        FROM bug
        WHERE k = 1
            OR k = 2
            OR k = 3
    )
WHERE s = 21
    OR s = 22
    OR s = 23
SETTINGS enable_analyzer = '1';

SELECT
    k,
    k = 1
    OR k = 2
    OR k = 3,
    s,
    s = 21,
    s = 21
    OR s = 22,
    s = 21
    OR s = 22
    OR s = 23
FROM bug;

SELECT
    k,
    k = 1
    OR k = 2
    OR k = 3,
    s,
    s = 21,
    s = 21
    OR s = 22,
    s = 21
    OR s = 22
    OR s = 23
FROM bug
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT
    k,
    k = 1
    OR k = 2
    OR k = 3,
    s,
    s = 21,
    s = 21
    OR s = 22,
    s = 21
    OR s = 22
    OR s = 23
FROM bug
SETTINGS enable_analyzer = '1';

SELECT
    s,
    s = 21
    OR s = 22
    OR s = 23
FROM bug;

SELECT
    s,
    s = 21
    OR s = 22
    OR s = 23
FROM bug
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT
    s,
    s = 21
    OR s = 22
    OR s = 23
FROM bug
SETTINGS enable_analyzer = '1';

SET optimize_min_equality_disjunction_chain_length = '3';

SELECT
    s,
    s = 21
    OR 22 = s
    OR 23 = s
FROM bug;

SELECT
    s,
    s = 21
    OR 22 = s
    OR 23 = s
FROM bug
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT
    s,
    s = 21
    OR 22 = s
    OR 23 = s
FROM bug
SETTINGS enable_analyzer = '1';

DROP TABLE bug;