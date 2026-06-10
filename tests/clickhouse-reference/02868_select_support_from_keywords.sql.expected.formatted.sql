CREATE TABLE test_table
(
    date Date,
    __sign Int8,
    `from` Float64,
    to Float64
)
ENGINE = CollapsingMergeTree(__sign)
ORDER BY date
PARTITION BY toYYYYMM(date)
SETTINGS index_granularity = '8192';

CREATE VIEW test_view
AS
WITH cte AS (
    SELECT
        date,
        __sign,
        `from`,
        to
    FROM test_table FINAL
)

SELECT
    date,
    __sign,
    `from`,
    to
FROM cte;

SHOW CREATE TABLE test_view;

DROP TABLE test_view;

DROP TABLE test_table;