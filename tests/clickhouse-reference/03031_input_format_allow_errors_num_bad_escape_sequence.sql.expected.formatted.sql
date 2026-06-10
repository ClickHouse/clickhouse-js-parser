SELECT *
FROM format(JSONEachRow, '{"item" : "some string"}, {"item":"\\\\ \\ud83d"}')
SETTINGS input_format_allow_errors_num = '1';