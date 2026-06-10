INSERT INTO FUNCTION file(currentDatabase() || '_data_02318.tsv') SELECT *
FROM numbers(10);

DESCRIBE TABLE file(currentDatabase() || '_data_02318.tsv', 'Template') SETTINGS format_template_row = 'nonexist', format_template_resultset = 'nonexist'; -- {serverError FILE_DOESNT_EXIST}