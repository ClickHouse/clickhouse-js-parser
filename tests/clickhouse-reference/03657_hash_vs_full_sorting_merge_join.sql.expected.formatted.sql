DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS tn1;

DROP TABLE IF EXISTS tn2;

CREATE TABLE t1
(
    key UInt32,
    s String
)
ENGINE = TinyLog();

CREATE TABLE tn1
(
    key Nullable(UInt32),
    s String
)
ENGINE = TinyLog();

CREATE TABLE t2
(
    key UInt32,
    s String
)
ENGINE = TinyLog();

CREATE TABLE tn2
(
    key Nullable(UInt32),
    s String
)
ENGINE = TinyLog();

INSERT INTO t1;

INSERT INTO tn1;

INSERT INTO t2;

INSERT INTO tn2;

SET enable_analyzer = '1';

SET join_algorithm = 'hash';

SELECT '---';

SELECT
    key,
    length(t1.s),
    length(t2.s)
FROM
    t1 AS t1
ALL FULL JOIN tn2 AS t2
    USING (key)
ORDER BY
    key ASC,
    length(t1.s) ASC,
    length(t2.s) ASC;

SET join_algorithm = 'full_sorting_merge';

SET join_use_nulls = true;

DROP TABLE t1;

DROP TABLE t2;

DROP TABLE tn1;

DROP TABLE tn2;