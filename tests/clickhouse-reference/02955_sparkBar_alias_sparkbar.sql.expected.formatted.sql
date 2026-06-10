SET enable_analyzer = '1';

DROP TABLE IF EXISTS spark_bar_test;

CREATE TABLE spark_bar_test
(
    value Int64,
    event_date Date
)
ENGINE = MergeTree()
ORDER BY event_date;

INSERT INTO spark_bar_test;

SELECT sparkbar(9)(event_date, cnt)
FROM (
        SELECT
            sum(value) AS cnt,
            event_date
        FROM spark_bar_test
        GROUP BY event_date
    );