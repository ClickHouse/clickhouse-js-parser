SET enable_analyzer = '1';

SELECT
    false ? c : '' AS c,
    count()
FROM (
        SELECT '' AS c
    )
GROUP BY c;

SELECT
    if(0, c, '') AS _c,
    count()
FROM (
        SELECT '' AS c
    )
GROUP BY _c;

SELECT
    if(1 = 0, c, '') AS _c,
    count()
FROM (
        SELECT '' AS c
    )
GROUP BY _c;

SELECT
    materialize(false) ? c : 'x' AS c,
    count()
FROM (
        SELECT 'o' AS c
    )
GROUP BY c;

SELECT
    if(1 = 1, c, '') AS _c,
    count()
FROM (
        SELECT '' AS c
    )
GROUP BY _c;

DROP TABLE IF EXISTS f;

CREATE TABLE f
(
    c String
)
ENGINE = Null();

DROP TABLE IF EXISTS v;

CREATE MATERIALIZED VIEW v
ENGINE = Null()
AS
SELECT
    false ? c : '' AS c,
    countState() AS t
FROM f
GROUP BY c;

DROP TABLE v;

DROP TABLE f;