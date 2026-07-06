-- Tags: no-parallel, no-fasttest
INSERT INTO FUNCTION file(`02416_data`.json) SELECT
    number::UInt32 AS n,
    'Hello' AS s,
    range(number) AS a
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02416_data`.json);

SELECT *
FROM file(`02416_data`.json);

INSERT INTO FUNCTION file(`02416_data`.jsonCompact) SELECT
    number::UInt32 AS n,
    'Hello' AS s,
    range(number) AS a
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02416_data`.jsonCompact);

SELECT *
FROM file(`02416_data`.jsonCompact);

INSERT INTO FUNCTION file(`02416_data`.jsonColumnsWithMetadata) SELECT
    number::UInt32 AS n,
    'Hello' AS s,
    range(number) AS a
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02416_data`.jsonColumnsWithMetadata);

SELECT *
FROM file(`02416_data`.jsonColumnsWithMetadata);