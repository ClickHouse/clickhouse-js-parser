-- Tags: no-fasttest
SET session_timezone = 'UTC';

SET engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(current_database() || '_03259.orc', 'ORC') SELECT
    number,
    if(number % 2 = 0, NULL, toDate32(number)) AS date_field
FROM numbers(10);

DESCRIBE TABLE file(current_database() || '_03259.orc', 'ORC');

SELECT date_field
FROM file(current_database() || '_03259.orc', 'ORC')
ORDER BY number ASC;