DROP TABLE IF EXISTS dest_table_mv;

DROP TABLE IF EXISTS left_table;

DROP TABLE IF EXISTS right_table;

DROP TABLE IF EXISTS dest_table;

DROP TABLE IF EXISTS src_table;

DROP VIEW IF EXISTS dst_mv;

DROP VIEW IF EXISTS dst_mv_1;

DROP VIEW IF EXISTS dst_mv_2;

CREATE TABLE src_table AS `system`.numbers
ENGINE = Memory();

CREATE MATERIALIZED VIEW dst_mv_1
ENGINE = Memory()
AS
SELECT
    *,
    (
        SELECT count()
        FROM src_table
    ) AS cnt
FROM src_table;

INSERT INTO src_table SELECT 1
FROM numbers(3);

INSERT INTO src_table SELECT 2
FROM numbers(2);

INSERT INTO src_table SELECT 3
FROM numbers(1);

SELECT *
FROM dst_mv_1
ORDER BY number ASC;

CREATE TABLE dest_table
(
    Date Date,
    Id UInt64,
    Units Float32
)
ENGINE = Memory();

CREATE TABLE left_table AS dest_table;

CREATE TABLE right_table AS dest_table;

INSERT INTO right_table SELECT
    toDate('2020-01-01') + number,
    number,
    number / 2
FROM numbers(10);

CREATE MATERIALIZED VIEW dest_table_mv
TO dest_table
AS
SELECT
    Date,
    Id,
    Units
FROM
    (
        SELECT *
        FROM left_table
    ) AS t1
INNER JOIN (
        WITH (
                SELECT DISTINCT Date
                FROM left_table
                LIMIT 1
            ) AS dt

        SELECT *
        FROM right_table
        WHERE Date = dt
    ) AS t2
    USING (Date, Id);

INSERT INTO left_table SELECT
    toDate('2020-01-01'),
    0,
    number * 2
FROM numbers(3);

SELECT *
FROM dest_table
ORDER BY
    Date ASC,
    Id ASC,
    Units ASC;

INSERT INTO left_table SELECT
    toDate('2020-01-01'),
    5,
    number * 2
FROM numbers(3);

TRUNCATE TABLE left_table;

INSERT INTO left_table SELECT
    toDate('2020-01-01') + 5,
    5,
    number * 2
FROM numbers(3);

DROP TABLE dest_table_mv;

DROP TABLE left_table;

DROP TABLE right_table;

DROP TABLE dest_table;

DROP TABLE src_table;