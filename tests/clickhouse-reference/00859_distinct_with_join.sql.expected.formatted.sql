DROP TABLE IF EXISTS fooL;

DROP TABLE IF EXISTS fooR;

CREATE TABLE fooL
(
    a Int32,
    v String
)
ENGINE = Memory();

CREATE TABLE fooR
(
    a Int32,
    v String
)
ENGINE = Memory();

INSERT INTO fooL SELECT
    number,
    'L' || toString(number)
FROM numbers(2);

INSERT INTO fooL SELECT
    number,
    'LL' || toString(number)
FROM numbers(2);

INSERT INTO fooR SELECT
    number,
    'R' || toString(number)
FROM numbers(2);

SELECT DISTINCT a
FROM
    fooL
SEMI LEFT JOIN fooR
    USING (a)
ORDER BY a ASC;

DROP TABLE fooL;

DROP TABLE fooR;