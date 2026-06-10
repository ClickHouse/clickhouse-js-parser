-- Tags: no-fasttest, no-parallel
INSERT INTO FUNCTION file('data.jsonl', 'JSONEachRow', 'x UInt32') SELECT *
FROM numbers(10)
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file('data.jsonl')
ORDER BY x ASC;