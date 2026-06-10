SELECT
    'ab\0c' < 'ab\0d',
    'ab\0c' > 'ab\0d';

SELECT
    'a' < 'a\0b',
    'a' > 'a\0b';

SELECT
    'a\0\0\0\0' < 'a\0\0\0',
    'a\0\0\0\0' > 'a\0\0\0';

DROP TABLE IF EXISTS strings_00469;

CREATE TABLE strings_00469
(
    x String,
    y String
)
ENGINE = TinyLog();

INSERT INTO strings_00469;

SELECT
    x < y,
    x > y
FROM strings_00469;

SELECT
    x < 'aa',
    x > 'aa'
FROM strings_00469;

SELECT
    x < 'a\0',
    x > 'a\0'
FROM strings_00469;

SELECT *
FROM strings_00469
ORDER BY x ASC;

SELECT *
FROM strings_00469
ORDER BY
    x ASC,
    y ASC;

DROP TABLE strings_00469;