SET enable_named_columns_in_function_tuple = '1';

SET output_format_write_statistics = '0';

SET enable_analyzer = '1';

SELECT
    tuple(1 AS b, 2 AS c) AS a,
    map('e', 3, 'f', 4) AS d,
    [5, 6] AS g,
    tuple(map('i', [tuple(7 AS j, 8 AS k)]) AS l, 42 AS m) AS h
FORMAT JSON;

SELECT
    tuple(1 AS b, 2 AS c) AS a,
    map('e', 3, 'f', 4) AS d,
    [5, 6] AS g,
    tuple(map('i', [tuple(7 AS j, 8 AS k)]) AS l, 42 AS m) AS h
FORMAT JSON
SETTINGS output_format_json_pretty_print = '0';