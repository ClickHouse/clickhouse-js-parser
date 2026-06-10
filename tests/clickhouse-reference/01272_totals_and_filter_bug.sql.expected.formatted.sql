SELECT *
FROM (
        SELECT
            number,
            count()
        FROM numbers(2)
        GROUP BY number
        WITH TOTALS
    )
WHERE number > 0
SETTINGS enable_optimize_predicate_expression = '0';

CREATE TABLE foo
(
    server_date Date,
    dimension_1 String,
    metric_1 UInt32
)
ENGINE = MergeTree()
ORDER BY server_date
PARTITION BY toYYYYMM(server_date);

CREATE TABLE bar
(
    server_date Date,
    dimension_1 String,
    metric_2 UInt32
)
ENGINE = MergeTree()
ORDER BY server_date
PARTITION BY toYYYYMM(server_date);

INSERT INTO foo;

INSERT INTO bar;

SELECT
    dimension_1,
    sum_metric_1,
    sum_metric_2
FROM
    (
        SELECT
            dimension_1,
            sum(metric_1) AS sum_metric_1
        FROM foo
        GROUP BY dimension_1
        WITH TOTALS
    ) AS subquery_1
ALL FULL JOIN (
        SELECT
            dimension_1,
            sum(metric_2) AS sum_metric_2
        FROM bar
        GROUP BY dimension_1
        WITH TOTALS
    ) AS subquery_2
    USING (dimension_1)
WHERE sum_metric_2 < 20
ORDER BY dimension_1 ASC;

DROP TABLE foo;

DROP TABLE bar;