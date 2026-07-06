-- Tags: no-fasttest
INSERT INTO FUNCTION file(currentDatabase() || '_data_02302.parquet') SELECT
    1 AS x,
    NULL::Nullable(UInt8) AS xx
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(currentDatabase() || '_data_02302.parquet', auto, 'x UInt8, xx UInt8 default 10, y default 42, z default x + xx + y')
SETTINGS input_format_parquet_allow_missing_columns = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02302.orc') SELECT
    1 AS x,
    NULL::Nullable(UInt8) AS xx
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(currentDatabase() || '_data_02302.orc', auto, 'x UInt8, xx UInt8 default 10, y default 42, z default x + xx + y')
SETTINGS input_format_orc_allow_missing_columns = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02302.arrow') SELECT
    1 AS x,
    NULL::Nullable(UInt8) AS xx
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(currentDatabase() || '_data_02302.arrow', auto, 'x UInt8, xx UInt8 default 10, y default 42, z default x + xx + y')
SETTINGS input_format_arrow_allow_missing_columns = '1';