-- Tags: no-parallel, no-fasttest
INSERT INTO FUNCTION file(`02376_data`.arrow) SELECT toLowCardinality(toString(number)) AS x
FROM numbers(10)
SETTINGS
    output_format_arrow_string_as_string = '1',
    output_format_arrow_low_cardinality_as_dictionary = '1',
    engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02376_data`.arrow);

SELECT *
FROM file(`02376_data`.arrow);