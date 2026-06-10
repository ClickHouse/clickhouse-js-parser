-- Does additional subquery cache lookups that the test doesn't expect
SET automatic_parallel_replicas_mode = '0';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

SET force_primary_key = '1';

SELECT *
FROM tab
WHERE id > 0
    OR exists((
        SELECT number
        FROM numbers(10)
        WHERE number > 10
    ))
    OR exists((
        SELECT number
        FROM numbers(10)
        WHERE number > 10
    ))
SETTINGS execute_exists_as_scalar_subquery = '0'; -- { serverError INDEX_NOT_USED }

SELECT *
FROM tab
WHERE id > 2
    OR exists((
        SELECT number
        FROM numbers(10)
        WHERE number > 10
    ))
    OR exists((
        SELECT number
        FROM numbers(10)
        WHERE number > 10
    ))
SETTINGS execute_exists_as_scalar_subquery = '1';

SET force_primary_key = '0';

SYSTEM FLUSH LOGS query_log;

SELECT 'ScalarSubqueriesGlobalCacheHit ' || ProfileEvents['ScalarSubqueriesGlobalCacheHit']
FROM `system`.query_log
WHERE type != 'QueryStart'
    AND current_database = currentDatabase()
    AND query LIKE 'select%'
    AND `Settings`['execute_exists_as_scalar_subquery'] = '1';

SELECT exists((
        SELECT 1
        FROM numbers(2)
        WHERE number != 0
    ))
SETTINGS execute_exists_as_scalar_subquery = '1';