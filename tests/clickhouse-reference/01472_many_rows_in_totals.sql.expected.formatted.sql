SET output_format_pretty_color = '1';

-- Disable external aggregation because it may produce several blocks instead of one.
SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

SET output_format_write_statistics = '0';

SELECT
    g,
    s
FROM
    (
        SELECT
            g,
            sum(number) AS s
        FROM numbers(4)
        GROUP BY bitAnd(number, 1) AS g
        WITH TOTALS
        ORDER BY g ASC
    )
ARRAY JOIN [1, 2] AS a
FORMAT Pretty;

SELECT '--';

SELECT
    g,
    s
FROM
    (
        SELECT
            g,
            sum(number) AS s
        FROM numbers(4)
        GROUP BY bitAnd(number, 1) AS g
        WITH TOTALS
        ORDER BY g ASC
    )
ARRAY JOIN [1, 2] AS a
FORMAT TSV;

SELECT
    g,
    s
FROM
    (
        SELECT
            g,
            sum(number) AS s
        FROM numbers(4)
        GROUP BY bitAnd(number, 1) AS g
        WITH TOTALS
        ORDER BY g ASC
    )
ARRAY JOIN [1, 2] AS a
FORMAT JSON;