SET join_algorithm = 'auto';

SET max_bytes_in_join = '100';

DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS nr;

CREATE TABLE t
(
    x UInt32,
    s LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE nr
(
    x Nullable(UInt32),
    s Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t;

INSERT INTO nr;

SET join_use_nulls = '0';

SET enable_analyzer = '1';

-- x is supertupe for `t.x` and `nr.x` from left and right since `x` is inside `USING`.
SELECT
    x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
FULL JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    nr AS l
LEFT JOIN t AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    nr AS l
RIGHT JOIN t AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    nr AS l
FULL JOIN t AS r
    USING (x)
ORDER BY t.x ASC;

SET enable_analyzer = '0';

-- t.x is supertupe for `x` from left and right since `x` is inside `USING`.
SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
LEFT JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
RIGHT JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

SELECT
    t.x,
    l.s,
    r.s,
    toTypeName(l.s),
    toTypeName(r.s)
FROM
    t AS l
FULL JOIN nr AS r
    USING (x)
ORDER BY t.x ASC;

DROP TABLE t;

DROP TABLE nr;