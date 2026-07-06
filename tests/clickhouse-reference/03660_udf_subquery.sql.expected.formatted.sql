-- Tags: no-parallel
SET enable_analyzer = '1';

DROP TABLE IF EXISTS dict;

CREATE TABLE dict
ENGINE = MergeTree()
ORDER BY id AS
SELECT
    1 AS id,
    'one' AS name
UNION ALL
SELECT
    2 AS id,
    'two' AS name;

CREATE OR REPLACE FUNCTION udf_type_of_int AS int_ -> (
    SELECT if(name = 'one', 'The One', 'other')
    FROM dict
    WHERE id = int_
);

-- this part worked successfully
SELECT *
FROM (
        SELECT udf_type_of_int(1)
        UNION ALL
        SELECT udf_type_of_int(2)
    )
ORDER BY `ALL` ASC;

-- ... and this not!
SELECT udf_type_of_int(number)
FROM numbers(5)
ORDER BY number ASC;

SELECT
    number AS id,
    udf_type_of_int(id)
FROM numbers(5)
ORDER BY number ASC;

SELECT
    number AS id,
    udf_type_of_int(id
    OR id = 1)
FROM numbers(5)
ORDER BY number ASC;

DROP FUNCTION udf_type_of_int;

DROP TABLE dict;