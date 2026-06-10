SET output_format_pretty_color = '1';

SET output_format_pretty_row_numbers = '0';

SET output_format_pretty_display_footer_column_names = '0';

SET output_format_pretty_squash_consecutive_ms = '0';

SELECT *
FROM numbers(10)
FORMAT Pretty;

SELECT *
FROM numbers(10)
FORMAT PrettyCompact;

SELECT *
FROM numbers(10)
FORMAT PrettyCompactMonoBlock;

SELECT *
FROM numbers(10)
FORMAT PrettyNoEscapes;

SELECT *
FROM numbers(10)
FORMAT PrettyCompactNoEscapes;

SELECT *
FROM numbers(10)
FORMAT PrettySpaceNoEscapes;

SELECT *
FROM numbers(10)
FORMAT PrettySpace;

SET output_format_pretty_row_numbers = '1';

SET max_block_size = '1';

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT Pretty;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettyCompact;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettyCompactMonoBlock;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettyNoEscapes;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettyCompactNoEscapes;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettySpace;

SELECT *
FROM (
        SELECT 1 AS a
        UNION ALL
        SELECT 2 AS a
    )
ORDER BY a ASC
FORMAT PrettySpaceNoEscapes;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT Pretty;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettyCompact;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettyCompactMonoBlock;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettyNoEscapes;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettyCompactNoEscapes;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettySpace;

SELECT *
FROM numbers(10)
ORDER BY number ASC
FORMAT PrettySpaceNoEscapes;