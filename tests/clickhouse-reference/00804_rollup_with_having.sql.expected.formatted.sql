DROP TABLE IF EXISTS rollup_having;

CREATE TABLE rollup_having
(
    a Nullable(String),
    b Nullable(String)
)
ENGINE = Memory();

INSERT INTO rollup_having;

INSERT INTO rollup_having;

INSERT INTO rollup_having;

SELECT
    a,
    b,
    count(*) AS count
FROM rollup_having
GROUP BY
    a,
    b
WITH ROLLUP
HAVING a IS NOT NULL
ORDER BY
    a ASC,
    b ASC,
    count ASC;

SELECT
    a,
    b,
    count(*) AS count
FROM rollup_having
GROUP BY
    a,
    b
WITH ROLLUP
HAVING a IS NOT NULL
    AND b IS NOT NULL
ORDER BY
    a ASC,
    b ASC,
    count ASC;

DROP TABLE rollup_having;