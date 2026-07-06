-- Tags: no-random-settings
CREATE TABLE IF NOT EXISTS t_group_by_lowcardinality
(
    p_date Date,
    val LowCardinality(Nullable(String))
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY p_date;

INSERT INTO t_group_by_lowcardinality SELECT
    today() AS p_date,
    toString(number / 5) AS val
FROM numbers(10000);

INSERT INTO t_group_by_lowcardinality SELECT
    today() AS p_date,
    NULL AS val
FROM numbers(100);

SELECT
    val,
    avg(toUInt32(val))
FROM t_group_by_lowcardinality
GROUP BY val
LIMIT 10
SETTINGS
    max_threads = '1',
    max_rows_to_group_by = '100',
    group_by_overflow_mode = 'any'
FORMAT JSONEachRow;

DROP TABLE IF EXISTS t_group_by_lowcardinality;