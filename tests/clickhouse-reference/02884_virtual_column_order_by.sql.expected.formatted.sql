-- Tags: no-fasttest
INSERT INTO FUNCTION file('02884_1.csv') SELECT 1 AS x
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file('02884_2.csv') SELECT 2 AS x
SETTINGS engine_file_truncate_on_insert = '1';

SELECT
    _file,
    *
FROM file('02884_{1,2}.csv')
ORDER BY _file ASC
SETTINGS max_threads = '1';