-- Tags: no-fasttest
INSERT INTO FUNCTION file(currentDatabase() || '_02293_data.arrow') SELECT toLowCardinality(toString(number))
FROM numbers(300)
SETTINGS
    output_format_arrow_low_cardinality_as_dictionary = '1',
    engine_file_truncate_on_insert = '1';

SELECT *
FROM file(currentDatabase() || '_02293_data.arrow')
SETTINGS max_threads = '1';