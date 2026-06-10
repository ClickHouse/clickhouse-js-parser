DROP TABLE IF EXISTS l;

DROP TABLE IF EXISTS r;

CREATE TABLE l
(
    a String,
    b Tuple(String, String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE r
(
    a String,
    c Tuple(String, String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO l (a, b);

INSERT INTO r (a, c);

SET join_use_nulls = '0';

SELECT *
FROM
    l
LEFT JOIN r
    USING (a)
ORDER BY a ASC;

SELECT a
FROM
    l
RIGHT JOIN r
    USING (a)
ORDER BY a ASC;

SELECT *
FROM
    l
RIGHT JOIN r
    USING (a)
ORDER BY a ASC;

SET join_use_nulls = '1';

SELECT a
FROM
    l
LEFT JOIN r
    USING (a)
ORDER BY a ASC;

DROP TABLE l;

DROP TABLE r;

CREATE TABLE l
(
    a String,
    b String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE r
(
    a String,
    c Array(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO l (a, b);

INSERT INTO r (a, c);