SET output_format_write_statistics = '0';

SELECT
    1,
    'a',
    [1, 2, 3],
    (1, 'a'),
    NULL,
    nan
FORMAT JSONStrings;