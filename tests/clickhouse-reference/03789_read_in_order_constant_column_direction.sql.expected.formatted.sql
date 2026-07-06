-- Test: read-in-order optimization should use InReverseOrder when constant ORDER BY columns are skipped
-- This test specifically tests read-in-order optimization, so we need to ensure it's enabled
SET optimize_read_in_order = '1';

-- Ensure plan stabiliity with parallel replicas
SET parallel_replicas_local_plan = '1';

DROP TABLE IF EXISTS test_03789;

CREATE TABLE test_03789
(
    tenant String,
    event_time DateTime,
    id UInt64
)
ENGINE = MergeTree()
ORDER BY (tenant, event_time, id);

INSERT INTO test_03789 SELECT
    toString(number % 10),
    now() - number,
    number
FROM numbers(1000);

SELECT count() > 0
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM test_03789
                WHERE tenant = '5'
                ORDER BY event_time DESC
                LIMIT 5
            ))
    )
WHERE `explain` LIKE '%InReverseOrder%';

SELECT count() > 0
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM test_03789
                WHERE tenant = '5'
                ORDER BY
                    tenant ASC,
                    event_time DESC
                LIMIT 5
            ))
    )
WHERE `explain` LIKE '%InReverseOrder%';

DROP TABLE test_03789;