DROP TABLE IF EXISTS a1;

DROP TABLE IF EXISTS a2;

CREATE TABLE a1
(
    a UInt8,
    b UInt8
)
ENGINE = Memory();

CREATE TABLE a2
(
    a UInt8,
    b UInt8
)
ENGINE = Memory();

INSERT INTO a1;

INSERT INTO a2;

SELECT *
FROM
    a1 AS a
LEFT JOIN a2 AS b
    ON a.a = b.a
ORDER BY b ASC
SETTINGS join_default_strictness = 'ANY';

SELECT
    a1.*,
    a2.*
FROM
    a1
ANY LEFT JOIN a2
    USING (a)
ORDER BY b ASC;