SET join_algorithm = 'partial_merge';

DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS nr;

CREATE TABLE t
(
    x UInt32,
    lc LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE nr
(
    x Nullable(UInt32),
    lc Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t;

INSERT INTO nr;

SET join_use_nulls = '0';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (x)
ORDER BY x ASC;

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (x)
ORDER BY x ASC;

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
FULL JOIN nr AS r
    USING (x)
ORDER BY x ASC;

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '1';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC
SETTINGS enable_analyzer = '0';

SET join_use_nulls = '1';

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

SELECT
    x,
    lc,
    r.lc,
    toTypeName(r.lc)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

SELECT
    x,
    lc,
    materialize(r.lc) AS y,
    toTypeName(y)
FROM
    t AS l
FULL JOIN nr AS r
    USING (lc)
ORDER BY x ASC;

DROP TABLE nr;

DROP TABLE t;