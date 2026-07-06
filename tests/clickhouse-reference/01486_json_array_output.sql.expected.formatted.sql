-- Tags: no-fasttest
SET output_format_json_array_of_rows = '1';

SELECT
    number AS a,
    number * 2 AS b
FROM numbers(3)
FORMAT JSONEachRow;

SELECT *
FROM numbers(1)
FORMAT JSONEachRow;

SELECT *
FROM numbers(1)
WHERE NULL
FORMAT JSONEachRow;