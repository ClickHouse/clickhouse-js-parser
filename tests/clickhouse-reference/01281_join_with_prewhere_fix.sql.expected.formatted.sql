DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x UInt8,
    id UInt8
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t;

SET enable_optimize_predicate_expression = '0';

SELECT 1
FROM
    t AS l
INNER JOIN t AS r
    ON l.id = r.id
PREWHERE l.x;

SELECT 2
FROM
    t AS l
INNER JOIN t AS r
    ON l.id = r.id
WHERE r.x;

SELECT 3
FROM
    t AS l
INNER JOIN t AS r
    ON l.id = r.id
PREWHERE l.x
WHERE r.x;

SELECT 4
FROM
    t AS l
INNER JOIN t AS r
    USING (id)
PREWHERE l.x
WHERE r.x;

SELECT 5
FROM
    t AS l
INNER JOIN t AS r
    ON l.id = r.id
WHERE l.x
    AND r.x;

SELECT 6
FROM
    t AS l
INNER JOIN t AS r
    USING (id)
WHERE l.x
    AND r.x;

SET optimize_move_to_prewhere = '0';

SELECT 7
FROM
    t AS l
INNER JOIN t AS r
    ON l.id = r.id
WHERE l.x
    AND r.x;

SELECT 8
FROM
    t AS l
INNER JOIN t AS r
    USING (id)
WHERE l.x
    AND r.x;

DROP TABLE t;