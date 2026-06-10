SELECT
    k,
    count()
FROM (
        SELECT number % 5 AS k
        FROM `system`.numbers
        LIMIT 100
    )
GROUP BY k
WITH TOTALS
ORDER BY k ASC
FORMAT Vertical;

SET extremes = '1';

SET output_format_pretty_max_rows = '5';

SET output_format_pretty_max_rows = '4';