DROP TABLE IF EXISTS t_str;

CREATE TABLE t_str
(
    creation_time String
)
ENGINE = MergeTree()
ORDER BY creation_time
PARTITION BY creation_time;

INSERT INTO t_str;

SELECT 1 AS x
FROM t_str
WHERE CAST('1970-01-01' AS date) <= CAST((
        SELECT max('1970-01-01')
        FROM numbers(1)
    ) AS date);

SELECT *
FROM (
        SELECT 1 AS x
        FROM t_str
        WHERE CAST('1970-01-01' AS date) <= CAST((
                SELECT max('1970-01-01')
                FROM numbers(1)
            ) AS date)
    );

SELECT *
FROM (
        SELECT *
        FROM t_str
        WHERE (
                SELECT any('1970-01-01')
            )::Date > today()
    );

DROP TABLE t_str;