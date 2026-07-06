SET schema_inference_use_cache_for_file = '0';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert;

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_max_batch_size = '1';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_max_batch_size = '2';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_include_column_names = '0';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_use_replace = '1';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_table_name = 'test';

SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
FORMAT SQLInsert
SETTINGS output_format_sql_insert_table_name = 'test', output_format_sql_insert_quote_names = '0';

INSERT INTO FUNCTION file(currentDatabase() || '_02322_data.sql', 'SQLInsert') SELECT
    number AS x,
    number % 3 AS y,
    'Hello' AS z
FROM numbers(5)
SETTINGS
    output_format_sql_insert_max_batch_size = '2',
    output_format_sql_insert_quote_names = '0',
    engine_file_truncate_on_insert = '1';

SELECT *
FROM file(currentDatabase() || '_02322_data.sql', 'MySQLDump');

INSERT INTO FUNCTION file(currentDatabase() || '_02322_data.sql', 'SQLInsert') SELECT
    number,
    number % 3,
    'Hello'
FROM numbers(5)
SETTINGS
    output_format_sql_insert_max_batch_size = '2',
    engine_file_truncate_on_insert = '1';