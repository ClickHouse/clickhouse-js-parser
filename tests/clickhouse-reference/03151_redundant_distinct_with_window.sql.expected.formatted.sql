DROP TABLE IF EXISTS tab;

DROP TABLE IF EXISTS tab_v;

CREATE TABLE tab
(
    id Int32,
    val Nullable(Float64),
    dt Nullable(DateTime64(6)),
    type Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

CREATE VIEW tab_v
AS
SELECT
    t1.type AS type,
    sum(t1.val) AS sval,
    toStartOfDay(t1.dt) AS sday,
    anyLast(sval) OVER w AS lval
FROM tab AS t1
GROUP BY
    type,
    sday
WINDOW w AS (PARTITION BY type);

SELECT DISTINCT type
FROM tab_v
ORDER BY type ASC;

SELECT '--------';

SELECT DISTINCT
    type,
    sday
FROM tab_v
ORDER BY
    type ASC,
    sday ASC;