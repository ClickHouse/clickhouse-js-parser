DROP TABLE IF EXISTS tt1;

DROP TABLE IF EXISTS tt2;

DROP TABLE IF EXISTS tt3;

DROP TABLE IF EXISTS tt4;

DROP TABLE IF EXISTS tt_m;

CREATE TABLE tt1
(
    a UInt32,
    b UInt32 ALIAS a
)
ENGINE = Memory();

CREATE TABLE tt2
(
    a UInt32,
    b UInt32 ALIAS a * 2
)
ENGINE = Memory();

CREATE TABLE tt3
(
    a UInt32,
    b UInt32 ALIAS c,
    c UInt32
)
ENGINE = Memory();

CREATE TABLE tt4
(
    a UInt32,
    b UInt32 ALIAS 12
)
ENGINE = Memory();

CREATE TABLE tt_m
(
    a UInt32,
    b UInt32
)
ENGINE = Merge(currentDatabase(), 'tt1|tt2|tt3|tt4');

INSERT INTO tt1;

INSERT INTO tt2;

INSERT INTO tt3 (a, c);

INSERT INTO tt4;

-- { echo  }
SELECT *
FROM tt_m
ORDER BY a ASC;

SELECT *
FROM tt_m
WHERE b != 0
ORDER BY
    b ASC,
    a ASC;

SELECT *
FROM tt_m
WHERE b != 1
ORDER BY
    b ASC,
    a ASC;

SELECT *
FROM tt_m
WHERE b != a * 2
ORDER BY
    b ASC,
    a ASC;

SELECT *
FROM tt_m
WHERE b / 2 != a
ORDER BY
    b ASC,
    a ASC;

SELECT b
FROM tt_m
WHERE b >= 0
ORDER BY
    b ASC,
    a ASC;

SELECT b
FROM tt_m
WHERE b = 12;

SELECT b
FROM tt_m
ORDER BY
    b ASC,
    a ASC;

SELECT
    b,
    count()
FROM tt_m
GROUP BY b
ORDER BY b ASC;

SELECT b
FROM tt_m
ORDER BY b ASC
LIMIT 1 BY b;

SELECT a
FROM tt_m
WHERE b = 12;

SELECT max(a)
FROM tt_m
GROUP BY b
ORDER BY b ASC;

SELECT a
FROM tt_m
ORDER BY
    b ASC,
    a ASC;