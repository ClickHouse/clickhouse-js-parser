DROP TABLE IF EXISTS t_left;

DROP TABLE IF EXISTS t_right;

CREATE TABLE t_left
(
    id UInt64,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t_right
(
    id UInt64,
    val String
)
ENGINE = MergeTree()
ORDER BY id;

SET enable_analyzer = '1';

SET join_algorithm = 'direct';

SELECT
    l.id,
    l.name,
    r.val
FROM
    t_left AS l
LEFT JOIN t_right AS r
    ON l.id = r.id;

SELECT '--';

INSERT INTO t_left;

SELECT
    l.id,
    l.name,
    r.val
FROM
    t_left AS l
INNER JOIN t_right AS r
    ON l.id = r.id
ORDER BY l.id ASC;

SELECT
    l.id,
    l.name,
    r.val
FROM
    t_left AS l
LEFT JOIN t_right AS r
    ON l.id = r.id
ORDER BY l.id ASC;