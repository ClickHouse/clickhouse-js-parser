-- Tags: no-fasttest
SET output_format_write_statistics = '0';

SET output_format_json_pretty_print = '0';

SET extremes = '1';

SET enable_analyzer = '1';

SET output_format_json_quote_64bit_integers = '1';

SELECT
    toInt64(0) AS i0,
    toUInt64(0) AS u0,
    toInt64(9223372036854775807) AS ip,
    toInt64(-9223372036854775808) AS `in`,
    toUInt64(18446744073709551615) AS up,
    [toInt64(0)] AS arr,
    (toUInt64(0), toUInt64(0)) AS tuple
GROUP BY
    i0,
    u0,
    ip,
    `in`,
    up,
    arr,
    tuple
WITH TOTALS
FORMAT JSON;

SELECT
    toInt64(0) AS i0,
    toUInt64(0) AS u0,
    toInt64(9223372036854775807) AS ip,
    toInt64(-9223372036854775808) AS `in`,
    toUInt64(18446744073709551615) AS up,
    [toInt64(0)] AS arr,
    (toUInt64(0), toUInt64(0)) AS tuple
GROUP BY
    i0,
    u0,
    ip,
    `in`,
    up,
    arr,
    tuple
WITH TOTALS
FORMAT JSONCompact;

SELECT
    toInt64(0) AS i0,
    toUInt64(0) AS u0,
    toInt64(9223372036854775807) AS ip,
    toInt64(-9223372036854775808) AS `in`,
    toUInt64(18446744073709551615) AS up,
    [toInt64(0)] AS arr,
    (toUInt64(0), toUInt64(0)) AS tuple
GROUP BY
    i0,
    u0,
    ip,
    `in`,
    up,
    arr,
    tuple
WITH TOTALS
FORMAT JSONEachRow;

SET output_format_json_quote_64bit_integers = '0';