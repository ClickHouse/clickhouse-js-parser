SET allow_deprecated_error_prone_window_functions = '1';

SET output_format_pretty_row_numbers = '0';

SELECT
    neighbor(n, -2) AS int,
    neighbor(s, -2) AS str,
    neighbor(lcs, -2) AS lowCstr
FROM (
        SELECT
            number % 5 AS n,
            toString(n) AS s,
            CAST(s AS LowCardinality(String)) AS lcs
        FROM numbers(10)
    );

DROP TABLE IF EXISTS neighbor_test;

CREATE TABLE neighbor_test
(
    rowNr UInt8,
    val_string String,
    val_low LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY rowNr
PARTITION BY tuple();

INSERT INTO neighbor_test;

SELECT
    rowNr,
    val_string,
    neighbor(val_string, -1) AS str_m1,
    neighbor(val_string, 1) AS str_p1,
    val_low,
    neighbor(val_low, -1) AS low_m1,
    neighbor(val_low, 1) AS low_p1
FROM (
        SELECT *
        FROM neighbor_test
        ORDER BY
            val_string ASC,
            rowNr ASC
    )
ORDER BY
    rowNr ASC,
    val_string ASC,
    str_m1 ASC,
    str_p1 ASC,
    val_low ASC,
    low_m1 ASC,
    low_p1 ASC
SETTINGS output_format_pretty_color = '1'
FORMAT PrettyCompact;