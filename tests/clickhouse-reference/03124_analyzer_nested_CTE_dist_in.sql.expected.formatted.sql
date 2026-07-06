-- https://github.com/ClickHouse/ClickHouse/issues/23865
SET enable_analyzer = '1';

CREATE TABLE table_local
ENGINE = Memory() AS
SELECT *
FROM numbers(10);

CREATE TABLE table_dist AS table_local
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), table_local);

WITH x AS (
    SELECT number
    FROM numbers(10)
    WHERE number % 3 = 0
),

y AS (
    SELECT
        number,
        count()
    FROM table_dist
    WHERE number IN (
            SELECT *
            FROM x
        )
    GROUP BY number
)

SELECT *
FROM y
ORDER BY `ALL` ASC;