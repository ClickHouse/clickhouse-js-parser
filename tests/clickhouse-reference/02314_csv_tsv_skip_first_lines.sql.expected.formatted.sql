INSERT INTO FUNCTION file(currentDatabase() || '_data_02314.csv') SELECT
    number,
    number + 1
FROM numbers(5)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02314.csv') SELECT
    number,
    number + 1,
    number + 2
FROM numbers(5);

DESCRIBE TABLE file(currentDatabase() || '_data_02314.csv') SETTINGS input_format_csv_skip_first_lines = '5';

SELECT *
FROM file(currentDatabase() || '_data_02314.csv')
ORDER BY c1 ASC
SETTINGS input_format_csv_skip_first_lines = '5';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02314.tsv') SELECT
    number,
    number + 1
FROM numbers(5)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02314.tsv') SELECT
    number,
    number + 1,
    number + 2
FROM numbers(5);

DESCRIBE TABLE file(currentDatabase() || '_data_02314.tsv') SETTINGS input_format_tsv_skip_first_lines = '5';

SELECT *
FROM file(currentDatabase() || '_data_02314.tsv')
ORDER BY c1 ASC
SETTINGS input_format_tsv_skip_first_lines = '5';