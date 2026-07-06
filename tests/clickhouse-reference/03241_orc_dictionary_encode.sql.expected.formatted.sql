-- Tags: no-fasttest
SET input_format_orc_use_fast_decoder = '1';

SET input_format_orc_dictionary_as_low_cardinality = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '_03241_data1_without_dict.orc')) SELECT toLowCardinality(CAST(if(number % 10 = 0, NULL, number % 10) AS Nullable(String))) AS c
FROM numbers(100000)
SETTINGS
    output_format_orc_dictionary_key_size_threshold = '0',
    engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '_03241_data1_with_dict.orc')) SELECT toLowCardinality(CAST(if(number % 10 = 0, NULL, number % 10) AS Nullable(String))) AS c
FROM numbers(100000)
SETTINGS
    output_format_orc_dictionary_key_size_threshold = 0.1,
    engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(concat(currentDatabase(), '_03241_data1_without_dict.orc'));

DESCRIBE TABLE file(concat(currentDatabase(), '_03241_data1_with_dict.orc'));

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data1_without_dict.orc'))
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data1_with_dict.orc'))
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data1_without_dict.orc'), ORC, 'c String')
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data1_with_dict.orc'), ORC, 'c LowCardinality(String)')
GROUP BY c
ORDER BY c ASC;

SET input_format_orc_dictionary_as_low_cardinality = '0';

INSERT INTO FUNCTION file(concat(currentDatabase(), '_03241_data2_without_dict.orc')) SELECT toLowCardinality(CAST(if(number % 10 = 0, NULL, number % 10) AS Nullable(String))) AS c
FROM numbers(100000)
SETTINGS
    output_format_orc_dictionary_key_size_threshold = '0',
    engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '_03241_data2_with_dict.orc')) SELECT toLowCardinality(CAST(if(number % 10 = 0, NULL, number % 10) AS Nullable(String))) AS c
FROM numbers(100000)
SETTINGS
    output_format_orc_dictionary_key_size_threshold = 0.1,
    engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(concat(currentDatabase(), '_03241_data2_without_dict.orc'));

DESCRIBE TABLE file(concat(currentDatabase(), '_03241_data2_with_dict.orc'));

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data2_without_dict.orc'))
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data2_with_dict.orc'))
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data2_without_dict.orc'), ORC, 'c String')
GROUP BY c
ORDER BY c ASC;

SELECT
    c,
    count(1)
FROM file(concat(currentDatabase(), '_03241_data2_with_dict.orc'), ORC, 'c LowCardinality(String)')
GROUP BY c
ORDER BY c ASC;