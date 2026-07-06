DROP TABLE IF EXISTS x;

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

CREATE TABLE x
(
    i int
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '3';

INSERT INTO x SELECT *
FROM numbers(10);

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT count()
                FROM x
                WHERE i >= 3
                    AND i <= 6
                    OR i = 7
            ))
    )
WHERE `explain` LIKE '%ReadFromPreparedSource%'
    OR `explain` LIKE '%ReadFromMergeTree%';

SELECT count()
FROM x
WHERE i >= 3
    AND i <= 6
    OR i = 7;

DROP TABLE x;