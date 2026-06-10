DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a Int32,
    b Int32,
    c Int32,
    d Int32
)
ENGINE = MergeTree()
ORDER BY (a, b, c);

INSERT INTO tab SELECT
    0,
    number % 3,
    2 - intDiv(number, 3),
    (number % 3 + 1) * 10
FROM numbers(6);

INSERT INTO tab SELECT
    0,
    number % 3,
    2 - intDiv(number, 3),
    (number % 3 + 1) * 100
FROM numbers(6);

SELECT
    a,
    any(b),
    c,
    d
FROM tab
WHERE b = 1
GROUP BY
    a,
    c,
    d
ORDER BY
    c ASC,
    d ASC
SETTINGS
    optimize_aggregation_in_order = '1',
    query_plan_aggregation_in_order = '1';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1, sorting = 1', (
                SELECT
                    a,
                    any(b),
                    c,
                    d
                FROM tab
                WHERE b = 1
                GROUP BY
                    a,
                    c,
                    d
                SETTINGS
                    optimize_aggregation_in_order = '1',
                    query_plan_aggregation_in_order = '1'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR `explain` LIKE '%Aggregating%'
    OR `explain` LIKE '%Order:%'
SETTINGS enable_analyzer = '0';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1, sorting = 1', (
                SELECT
                    a,
                    any(b),
                    c,
                    d
                FROM tab
                WHERE b = 1
                GROUP BY
                    a,
                    c,
                    d
                SETTINGS
                    optimize_aggregation_in_order = '1',
                    query_plan_aggregation_in_order = '1'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR `explain` LIKE '%Aggregating%'
    OR `explain` LIKE '%Order:%'
SETTINGS enable_analyzer = '1';