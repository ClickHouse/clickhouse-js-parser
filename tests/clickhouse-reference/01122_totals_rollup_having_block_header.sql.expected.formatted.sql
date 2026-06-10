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
    count(*)
FROM rollup_having
GROUP BY
    a,
    b
WITH ROLLUP
WITH TOTALS
HAVING a IS NOT NULL; -- { serverError NOT_IMPLEMENTED }

SELECT
    a,
    b,
    count(*)
FROM rollup_having
GROUP BY
    a,
    b
WITH ROLLUP
WITH TOTALS
HAVING a IS NOT NULL
    AND b IS NOT NULL; -- { serverError NOT_IMPLEMENTED }

DROP TABLE rollup_having;