DROP TABLE IF EXISTS view_no_nulls;

DROP TABLE IF EXISTS view_no_nulls_set;

DROP TABLE IF EXISTS view_nulls_set;

DROP TABLE IF EXISTS view_nulls;

SET join_use_nulls = '0';

CREATE OR REPLACE VIEW view_no_nulls
AS
SELECT *
FROM
    (
        SELECT
            number + 1 AS a,
            number + 11 AS b
        FROM numbers(2)
    ) AS t1
FULL JOIN (
        SELECT
            number + 2 AS a,
            number + 22 AS c
        FROM numbers(2)
    ) AS t2
    USING (a)
ORDER BY a ASC;

CREATE OR REPLACE VIEW view_nulls_set
AS
SELECT *
FROM
    (
        SELECT
            number + 1 AS a,
            number + 11 AS b
        FROM numbers(2)
    ) AS t1
FULL JOIN (
        SELECT
            number + 2 AS a,
            number + 22 AS c
        FROM numbers(2)
    ) AS t2
    USING (a)
ORDER BY a ASC
SETTINGS join_use_nulls = '1';

SET join_use_nulls = '1';

CREATE OR REPLACE VIEW view_nulls
AS
SELECT *
FROM
    (
        SELECT
            number + 1 AS a,
            number + 11 AS b
        FROM numbers(2)
    ) AS t1
FULL JOIN (
        SELECT
            number + 2 AS a,
            number + 22 AS c
        FROM numbers(2)
    ) AS t2
    USING (a)
ORDER BY a ASC;

CREATE OR REPLACE VIEW view_no_nulls_set
AS
SELECT *
FROM
    (
        SELECT
            number + 1 AS a,
            number + 11 AS b
        FROM numbers(2)
    ) AS t1
FULL JOIN (
        SELECT
            number + 2 AS a,
            number + 22 AS c
        FROM numbers(2)
    ) AS t2
    USING (a)
ORDER BY a ASC
SETTINGS join_use_nulls = '0';

SELECT *
FROM view_no_nulls; -- { serverError INCORRECT_QUERY }

SELECT *
FROM view_no_nulls_set;

SELECT *
FROM view_nulls_set;

SELECT *
FROM view_nulls;

DETACH TABLE view_no_nulls;

DETACH TABLE view_no_nulls_set;

DETACH TABLE view_nulls_set;

DETACH TABLE view_nulls;

ATTACH TABLE view_no_nulls;

ATTACH TABLE view_no_nulls_set;

ATTACH TABLE view_nulls_set;

ATTACH TABLE view_nulls;