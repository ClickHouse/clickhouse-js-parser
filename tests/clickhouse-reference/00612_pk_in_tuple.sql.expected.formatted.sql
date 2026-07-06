DROP TABLE IF EXISTS tab_00612;

CREATE TABLE tab_00612
(
    key UInt64,
    arr Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO tab_00612;

INSERT INTO tab_00612;

SELECT *
FROM tab_00612
ORDER BY key ASC;

SELECT
    key,
    arrayJoin(arr) AS val
FROM tab_00612
WHERE (key, val) IN (1, 1);

SELECT
    key,
    arrayJoin(arr) AS val
FROM tab_00612
WHERE (key, val) IN ((1, 1), (2, 2))
ORDER BY key ASC;

SELECT key
FROM
    tab_00612
LEFT ARRAY JOIN arr AS val
WHERE (key, val) IN (1, 1);

SELECT key
FROM
    tab_00612
LEFT ARRAY JOIN arr AS val
WHERE (key, val) IN ((1, 1), (2, 2))
ORDER BY key ASC;

CREATE TABLE tab_00612
(
    key UInt64,
    n Nested(x UInt64)
)
ENGINE = MergeTree()
ORDER BY key;

SELECT
    key,
    arrayJoin(n.x) AS val
FROM tab_00612
WHERE (key, val) IN (1, 1);

SELECT
    key,
    arrayJoin(n.x) AS val
FROM tab_00612
WHERE (key, val) IN ((1, 1), (2, 2))
ORDER BY key ASC;

SELECT key
FROM
    tab_00612
LEFT ARRAY JOIN n.x AS val
WHERE (key, val) IN (1, 1);

SELECT key
FROM
    tab_00612
LEFT ARRAY JOIN n.x AS val
WHERE (key, val) IN ((1, 1), (2, 2))
ORDER BY key ASC;

SELECT max(key)
FROM
    tab_00612
LEFT ARRAY JOIN `n.x` AS val
WHERE (key, val) IN ((1, 1),);

SELECT max(key)
FROM
    tab_00612
LEFT ARRAY JOIN n AS val
WHERE (key, val.x) IN (1, 1);

SELECT max(key)
FROM
    tab_00612
LEFT ARRAY JOIN `n.x` AS val
WHERE (key, val) IN ((1, 1), (2, 2));

SELECT max(key)
FROM
    tab_00612
LEFT ARRAY JOIN n AS val
WHERE (key, val.x) IN ((1, 1), (2, 2));

SELECT max(key)
FROM
    tab_00612
ANY LEFT JOIN (
        SELECT
            key,
            arrayJoin(n.x) AS val
        FROM tab_00612
    ) AS js2
    USING (key)
WHERE (key, val) IN (1, 1);

SELECT max(key)
FROM
    tab_00612
ANY LEFT JOIN (
        SELECT
            key,
            arrayJoin(n.x) AS val
        FROM tab_00612
    ) AS js2
    USING (key)
WHERE (key, val) IN ((1, 1), (2, 2));

CREATE TABLE tab_00612
(
    key1 Int32,
    id1 Int64,
    c1 Int64
)
ENGINE = MergeTree()
ORDER BY key1
PARTITION BY id1;

INSERT INTO tab_00612;

SELECT count(*)
FROM tab_00612
PREWHERE id1 IN (1);

SELECT count()
FROM tab_00612
WHERE (key1, id1) IN (-1, 1)
    AND (key1, 1) IN (-1, 1)
SETTINGS force_primary_key = '1';

DROP TABLE tab_00612;