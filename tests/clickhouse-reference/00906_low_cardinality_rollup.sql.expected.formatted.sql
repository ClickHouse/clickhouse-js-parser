DROP TABLE IF EXISTS lc;

CREATE TABLE lc
(
    a LowCardinality(Nullable(String)),
    b LowCardinality(Nullable(String))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lc;

INSERT INTO lc;

SELECT
    a,
    b,
    count(a)
FROM lc
GROUP BY
    a,
    b
WITH ROLLUP
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    count(a)
FROM lc
GROUP BY a
WITH ROLLUP
ORDER BY a ASC;

SELECT
    a,
    b,
    count(a)
FROM lc
GROUP BY
    a,
    b
WITH CUBE
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    count(a)
FROM lc
GROUP BY a
WITH CUBE
ORDER BY a ASC;