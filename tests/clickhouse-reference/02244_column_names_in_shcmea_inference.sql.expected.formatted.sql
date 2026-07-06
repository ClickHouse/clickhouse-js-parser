INSERT INTO FUNCTION file(currentDatabase() || '_test_02244', 'TSV', 'x String, y UInt32') SELECT
    'Hello, world!',
    42
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '_test_02244', 'TSV') SETTINGS column_names_for_schema_inference = 'x,y';

INSERT INTO FUNCTION file(currentDatabase() || '_test_02244', 'CSV', 'x String, y UInt32') SELECT
    'Hello, world!',
    42
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '_test_02244', 'CSV') SETTINGS column_names_for_schema_inference = 'x,y';

INSERT INTO FUNCTION file(currentDatabase() || '_test_02244', 'JSONCompactEachRow', 'x String, y UInt32') SELECT
    'Hello, world!',
    42
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '_test_02244', 'JSONCompactEachRow') SETTINGS column_names_for_schema_inference = 'x,y';

INSERT INTO FUNCTION file(currentDatabase() || '_test_02244', 'Values', 'x String, y UInt32') SELECT
    'Hello, world!',
    42
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '_test_02244', 'Values') SETTINGS column_names_for_schema_inference = 'x,y';