DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS any_left_join;

DROP TABLE IF EXISTS any_inner_join;

DROP TABLE IF EXISTS any_right_join;

DROP TABLE IF EXISTS any_full_join;

DROP TABLE IF EXISTS semi_left_join;

DROP TABLE IF EXISTS semi_right_join;

DROP TABLE IF EXISTS anti_left_join;

DROP TABLE IF EXISTS anti_right_join;

CREATE TABLE t1
(
    x UInt32,
    str String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE any_left_join
(
    x UInt32,
    s String
)
ENGINE = Join(`ANY`, `LEFT`, x);

CREATE TABLE any_inner_join
(
    x UInt32,
    s String
)
ENGINE = Join(`ANY`, `INNER`, x);

CREATE TABLE any_right_join
(
    x UInt32,
    s String
)
ENGINE = Join(`ANY`, `RIGHT`, x);

CREATE TABLE semi_left_join
(
    x UInt32,
    s String
)
ENGINE = Join(SEMI, `LEFT`, x);

CREATE TABLE semi_right_join
(
    x UInt32,
    s String
)
ENGINE = Join(SEMI, `RIGHT`, x);

CREATE TABLE anti_left_join
(
    x UInt32,
    s String
)
ENGINE = Join(ANTI, `LEFT`, x);

CREATE TABLE anti_right_join
(
    x UInt32,
    s String
)
ENGINE = Join(ANTI, `RIGHT`, x);

INSERT INTO t1 (x, str);

INSERT INTO any_left_join (x, s);

INSERT INTO any_inner_join (x, s);

INSERT INTO any_right_join (x, s);

INSERT INTO semi_left_join (x, s);

INSERT INTO semi_right_join (x, s);

INSERT INTO anti_left_join (x, s);

INSERT INTO anti_right_join (x, s);

SET join_use_nulls = '0';

SET any_join_distinct_right_table_keys = '0';

SET parallel_replicas_local_plan = '1';

SELECT *
FROM
    t1
ANY LEFT JOIN any_left_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
ANY INNER JOIN any_inner_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
ANY RIGHT JOIN any_right_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
SEMI LEFT JOIN semi_left_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
SEMI RIGHT JOIN semi_right_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
ANTI LEFT JOIN anti_left_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

SELECT *
FROM
    t1
ANTI RIGHT JOIN anti_right_join AS j
    USING (x)
ORDER BY
    x ASC,
    str ASC,
    s ASC;

DROP TABLE t1;

DROP TABLE any_left_join;

DROP TABLE any_inner_join;

DROP TABLE any_right_join;

DROP TABLE semi_left_join;

DROP TABLE semi_right_join;

DROP TABLE anti_left_join;

DROP TABLE anti_right_join;