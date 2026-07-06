SET output_format_pretty_color = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    a String,
    b Date
)
ENGINE = MergeTree()
ORDER BY a;

CREATE TABLE table2
(
    c String,
    a String,
    d Date
)
ENGINE = MergeTree()
ORDER BY c;

INSERT INTO table1;

INSERT INTO table2;

SET join_algorithm = 'partial_merge';

SELECT *
FROM
    table1 AS t1
ALL LEFT JOIN (
        SELECT
            *,
            '0.10',
            c,
            d AS b
        FROM table2
    ) AS t2
    USING (a, b)
ORDER BY
    d ASC,
    t1.a ASC
FORMAT PrettyCompact
SETTINGS max_rows_in_join = '1';

SELECT
    pow('0.0000000257', NULL),
    pow(pow(NULL, NULL), NULL) - NULL,
    val + NULL = rval * 0,
    *
FROM
    (
        SELECT
            val + 256 = NULL * NULL,
            toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    ) AS s1
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS rval
        FROM `system`.one
    ) AS s2
    ON val + 0 = rval * 255
SETTINGS max_rows_in_join = '1';