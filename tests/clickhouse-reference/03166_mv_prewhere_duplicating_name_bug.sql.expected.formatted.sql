CREATE TABLE src
(
    x Int64
)
ENGINE = Log();

CREATE TABLE dst
(
    s String,
    lc LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY s;

CREATE MATERIALIZED VIEW mv
TO dst
(
    s String,
    lc String
)
AS
SELECT
    'a' AS s,
    toLowCardinality('b') AS lc
FROM src;

INSERT INTO src;

SELECT
    s,
    lc
FROM mv
WHERE NOT ignore(lc)
SETTINGS enable_analyzer = '0';

SELECT
    s,
    lc
FROM mv
WHERE NOT ignore(lc)
SETTINGS enable_analyzer = '1';