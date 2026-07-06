SET force_primary_key = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    t DateTime
)
ENGINE = MergeTree()
ORDER BY toStartOfDay(t);

INSERT INTO tab;

SELECT t
FROM tab
WHERE t > '2020-01-01 01:01:01';

WITH t AS s

SELECT t
FROM tab
WHERE s > '2020-01-01 01:01:01';

CREATE TABLE tab
(
    t DateTime
)
ENGINE = MergeTree()
ORDER BY toStartOfDay(t + 1);

SELECT t
FROM tab
WHERE t + 1 > '2020-01-01 01:01:01';

WITH t + 1 AS s

SELECT t
FROM tab
WHERE s > '2020-01-01 01:01:01';

SET force_primary_key = '0';

SET force_index_by_date = '1';

CREATE TABLE tab
(
    x Int32,
    y Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY x + y;

INSERT INTO tab;

SELECT
    x,
    y
FROM tab
WHERE x + y = 2;

WITH x + y AS s

SELECT
    x,
    y
FROM tab
WHERE s = 2;

CREATE TABLE tab
(
    x Int32,
    y Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY (x + y + 1) * 2;

SELECT
    x,
    y
FROM tab
WHERE x + y + 1 = 3;

-- with x + y as s select x, y from tab where s + 1 = 3;
SET force_index_by_date = '0';