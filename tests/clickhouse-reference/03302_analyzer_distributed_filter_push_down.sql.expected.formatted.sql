-- Tags: no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Different plan
SET enable_analyzer = '1';

SET serialize_query_plan = '0';

SET enable_parallel_replicas = '0';

SET prefer_localhost_replica = '1';

SET optimize_aggregation_in_order = '0', optimize_read_in_order = '0';

CREATE TABLE tab0
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO tab0 SELECT
    number,
    number
FROM numbers(8192 * 123);

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, actions = 1, distributed = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
                    )
                WHERE x = 42
            ))
    );

--- lambdas are not supported
SELECT *
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
    )
WHERE arraySum(arrayMap((y -> y + 1), [x])) = 42;

SELECT *
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
    )
WHERE arraySum(arrayMap((y -> x + y + 2), [x])) = 42;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, actions = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
                    )
                WHERE x = 42
            ))
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, actions = 1, distributed = 1', (
                SELECT *
                FROM (
                        SELECT
                            x,
                            sum(y)
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
                        GROUP BY x
                    )
                WHERE x = 42
            ))
    );

--- IN is supported
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
                    )
                WHERE x IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

--- GLOBAL IN is replaced to temporary table
SELECT sum(y)
FROM (
        SELECT *
        FROM remote('127.0.0.2', currentDatabase(), tab0)
    )
WHERE x GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.2', currentDatabase(), tab0)
                    )
                WHERE x GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

SELECT sum(y)
FROM (
        SELECT *
        FROM remote('127.0.0.1', currentDatabase(), tab0)
    )
WHERE x GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.1', currentDatabase(), tab0)
                    )
                WHERE x GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

SELECT sum(y)
FROM (
        SELECT *
        FROM remote('127.0.0.{2,3}', currentDatabase(), tab0)
    )
WHERE x GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{2,3}', currentDatabase(), tab0)
                    )
                WHERE x GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

SELECT sum(y)
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
    )
WHERE x GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab0)
                    )
                WHERE x GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

SELECT sum(y)
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2,3}', currentDatabase(), tab0)
    )
WHERE x GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(y)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2,3}', currentDatabase(), tab0)
                    )
                WHERE x GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

SELECT sum(x)
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2,3}', currentDatabase(), tab0)
    )
WHERE y GLOBAL IN (
        SELECT number + 42
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT sum(x)
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2,3}', currentDatabase(), tab0)
                    )
                WHERE y GLOBAL IN (
                        SELECT number + 42
                        FROM numbers(1)
                    )
            ))
    );

CREATE TABLE tab1
(
    tenant String,
    recordTimestamp Int64,
    responseBody String,
    colAlias String ALIAS responseBody || 'something else',
    INDEX ngrams colAlias TYPE ngrambf_v1(3, 2097152, 3, 0) GRANULARITY 10
)
ENGINE = MergeTree()
ORDER BY recordTimestamp
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO tab1 SELECT *
FROM generateRandom('tenant String, recordTimestamp Int64, responseBody String')
LIMIT 10;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, distributed = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab1)
                    )
                WHERE (tenant, recordTimestamp) IN (
                        SELECT
                            tenant,
                            recordTimestamp
                        FROM remote('127.0.0.{1,2}', currentDatabase(), tab1)
                        WHERE colAlias LIKE '%abcd%'
                    )
            ))
    );

CREATE TABLE tab2
ENGINE = ReplacingMergeTree()
ORDER BY n
SETTINGS add_minmax_index_for_numeric_columns = '0' AS
SELECT intDiv(number, 2) AS n
FROM numbers(8192 * 123);

CREATE VIEW test_view
AS
SELECT *
FROM remote('127.0.0.{1,2}', currentDatabase(), tab2);

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1, actions = 1, distributed = 1', (
                SELECT *
                FROM test_view
                WHERE n = 100
            ))
    );