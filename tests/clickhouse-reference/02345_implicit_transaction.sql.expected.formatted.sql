-- Tags: no-ordinary-database, no-fasttest, no-encrypted-storage
DROP TABLE IF EXISTS landing_to_target;

DROP TABLE IF EXISTS target;

DROP TABLE IF EXISTS landing;

CREATE TABLE landing
(
    n Int64
)
ENGINE = MergeTree()
ORDER BY n;

CREATE TABLE target
(
    n Int64
)
ENGINE = MergeTree()
ORDER BY n;

CREATE MATERIALIZED VIEW landing_to_target
TO target
AS
SELECT n + throwIf(n = 3333) AS n
FROM landing;

-- There is no gurantee what is inserted in case if exception
-- That initial check is meaninglessness
-- We only sure that if the internal mv's exception is ignored then all the data is inserted to the table landing
INSERT INTO landing SELECT *
FROM numbers(10000)
SETTINGS materialized_views_ignore_errors = '1';

SELECT
    'no_transaction_landing',
    count() = 10000
FROM landing;

SELECT
    'no_transaction_target',
    count() < 10000
FROM target;

TRUNCATE TABLE landing;

TRUNCATE TABLE target;

BEGIN TRANSACTION;

INSERT INTO landing SELECT *
FROM numbers(10000); -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

ROLLBACK;

SELECT
    'after_transaction_landing',
    count()
FROM landing;

SELECT
    'after_transaction_target',
    count()
FROM target;

SELECT
    'after_implicit_txn_in_query_settings_landing',
    count()
FROM landing;

SELECT
    'after_implicit_txn_in_query_settings_target',
    count()
FROM target;

SELECT
    'after_implicit_txn_in_session_landing',
    count()
FROM landing;

SELECT
    'after_implicit_txn_in_session_target',
    count()
FROM target;

SELECT throwIf(number = 0)
FROM numbers(100); -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

INSERT INTO target SELECT *
FROM numbers(10000);

SELECT
    'in_transaction',
    count()
FROM target;

SELECT
    'out_transaction',
    count()
FROM target;

SYSTEM FLUSH LOGS query_log;

SELECT
    'implicit_True',
    count() AS `all`,
    transaction_id = (0, 0, '00000000-0000-0000-0000-000000000000') AS is_empty
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= yesterday()
    AND query LIKE '-- Verify that the transaction_id column is populated correctly%'
GROUP BY transaction_id
FORMAT JSONEachRow;

SELECT
    'implicit_False',
    count() AS `all`,
    transaction_id = (0, 0, '00000000-0000-0000-0000-000000000000') AS is_empty
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= yesterday()
    AND query LIKE '-- Verify that the transaction_id column is NOT populated without transaction%'
GROUP BY transaction_id
FORMAT JSONEachRow;

SET throw_on_unsupported_query_inside_transaction = '1';

SELECT *
FROM `system`.one;

SELECT *
FROM cluster('test_cluster_interserver_secret', `system`, one); -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM cluster('test_cluster_two_shards', `system`, one); -- { serverError NOT_IMPLEMENTED }

SET throw_on_unsupported_query_inside_transaction = '0';

-- there's not session in the interserver mode
SELECT *
FROM cluster('test_cluster_interserver_secret', `system`, one)
FORMAT Null; -- { serverError INVALID_TRANSACTION }