-- Tags: shard
SET max_threads = '1';

DROP TABLE IF EXISTS enums;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE enums
(
    d Date DEFAULT '2015-12-29',
    k DEFAULT 0,
    e Enum8('world' = 2, 'hello' = 1),
    sign Enum8('minus' = -1, 'plus' = 1),
    letter Enum16('a' = 0, 'b' = 1, 'c' = 2, '*' = -256)
)
ENGINE = MergeTree(d, k, 1);

DESCRIBE TABLE enums;

-- insert default values
INSERT INTO enums (k);

SELECT *
FROM enums;

ALTER TABLE enums MODIFY COLUMN e Enum8('world' = 2, 'hello' = 1, '!' = 3);

INSERT INTO enums (e, sign, letter);

SELECT *
FROM enums
ORDER BY _part ASC;

-- expand `e` and `sign` from Enum8 to Enum16 without changing values, change values of `letter` without changing type
ALTER TABLE enums MODIFY COLUMN e Enum16('world' = 2, 'hello' = 1, '!' = 3), MODIFY COLUMN sign Enum16('minus' = -1, 'plus' = 1), MODIFY COLUMN letter Enum16('a' = 0, 'b' = 1, 'c' = 2, 'no letter' = -256);

ALTER TABLE enums MODIFY COLUMN e Enum8('world' = 2, 'hello' = 1, '!' = 3), MODIFY COLUMN sign Enum8('minus' = -1, 'plus' = 1);

INSERT INTO enums (letter, e);

DROP TABLE enums;

CREATE TABLE enums
(
    e Enum8('a' = 0, 'b' = 1, 'c' = 2, 'd' = 3)
)
ENGINE = TinyLog();

INSERT INTO enums;

-- ORDER BY
SELECT *
FROM enums
ORDER BY e ASC;

SELECT *
FROM enums
ORDER BY e DESC;

-- GROUP BY
SELECT
    count(),
    e
FROM enums
GROUP BY e
ORDER BY e ASC;

SELECT any(e)
FROM enums;

-- IN
SELECT *
FROM enums
WHERE e IN ('a', 'd');

SELECT *
FROM enums
WHERE e IN (
        SELECT e
        FROM enums
    );

-- DISTINCT
SELECT DISTINCT e
FROM enums;

-- Comparison
SELECT *
FROM enums
WHERE e = e;

SELECT *
FROM enums
WHERE e = 'a'
    OR e = 'd';

SELECT *
FROM enums
WHERE e != 'a';

SELECT
    *,
    e < 'b'
FROM enums;

SELECT
    *,
    e > 'b'
FROM enums;

-- Conversion
SELECT
    toInt8(e),
    toInt16(e),
    toUInt64(e),
    toString(e),
    e
FROM enums;

DROP TABLE IF EXISTS enums_copy;

CREATE TABLE enums_copy
ENGINE = TinyLog() AS
SELECT *
FROM enums;

SELECT *
FROM enums_copy;

DROP TABLE enums_copy;

CREATE TABLE enums_copy
ENGINE = TinyLog() AS
SELECT *
FROM remote('127.0.0.2', currentDatabase(), enums);

SELECT *
FROM remote('127.0.0.2', currentDatabase(), enums_copy);