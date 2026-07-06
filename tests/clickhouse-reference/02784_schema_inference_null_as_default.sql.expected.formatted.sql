DESCRIBE TABLE format(JSONEachRow, '{"x" : null}, {"x" : 42}') SETTINGS schema_inference_make_columns_nullable = '1';

SELECT *
FROM format(JSONEachRow, '{"x" : null}, {"x" : 42}')
SETTINGS schema_inference_make_columns_nullable = '1';

DESCRIBE TABLE format(JSONEachRow, '{"x" : null}, {"x" : 42}') SETTINGS schema_inference_make_columns_nullable = 'auto', input_format_null_as_default = '0';

SELECT *
FROM format(JSONEachRow, '{"x" : null}, {"x" : 42}')
SETTINGS
    schema_inference_make_columns_nullable = 'auto',
    input_format_null_as_default = '0';

DESCRIBE TABLE format(JSONEachRow, '{"x" : null}, {"x" : 42}') SETTINGS schema_inference_make_columns_nullable = '0', input_format_null_as_default = '1';

SELECT *
FROM format(JSONEachRow, '{"x" : null}, {"x" : 42}')
SETTINGS
    schema_inference_make_columns_nullable = '0',
    input_format_null_as_default = '1';