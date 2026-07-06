DROP TABLE IF EXISTS a1;

DROP TABLE IF EXISTS a2;

SET send_logs_level = 'fatal';

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

INSERT INTO a1;

INSERT INTO a1;

INSERT INTO a2;

INSERT INTO a2;

INSERT INTO a2;

SELECT
    a,
    b
FROM
    a1
LEFT JOIN (
        SELECT
            a,
            b
        FROM a2
    ) AS js2
    USING (a)
ORDER BY b ASC
SETTINGS join_default_strictness = 'ANY';

SELECT
    a,
    b
FROM
    a1
LEFT JOIN (
        SELECT
            a,
            b
        FROM a2
    ) AS js2
    USING (a)
ORDER BY b ASC; -- default SETTINGS join_default_strictness='ALL';