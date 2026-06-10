DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    t UInt8,
    flag UInt8,
    id UInt8
)
ENGINE = MergeTree()
ORDER BY (t, id)
PARTITION BY t
SETTINGS index_granularity = '8192';

INSERT INTO test;

SET query_plan_filter_push_down = true;

SELECT
    id,
    flag
FROM
    test AS t1
INNER JOIN (
        SELECT DISTINCT id
        FROM test
    ) AS t2
    ON t1.id = t2.id
WHERE flag = 0
    AND t = 1
    AND id NOT IN (
        SELECT 1
        WHERE 0
    )
ORDER BY id ASC;