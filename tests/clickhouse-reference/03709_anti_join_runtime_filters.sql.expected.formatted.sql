SET enable_analyzer = '1';

SET enable_join_runtime_filters = '1';

CREATE TABLE nation
(
    n_nationkey Int32,
    n_name String
)
ENGINE = MergeTree()
ORDER BY n_nationkey;

CREATE TABLE customer
(
    c_custkey Int32,
    c_nationkey Int32
)
ENGINE = MergeTree()
ORDER BY c_custkey;

INSERT INTO nation;

INSERT INTO customer SELECT
    number,
    5 - number % 2
FROM numbers(500);

SET enable_parallel_replicas = '0';

SET query_plan_join_swap_table = '0';

-- LEFT ANTI JOIN
SELECT REGEXP_REPLACE(trimLeft(`explain`), '_runtime_filter_\\d+', '_runtime_filter_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count()
                FROM
                    customer
                ANTI LEFT JOIN nation
                    ON c_nationkey = n_nationkey
            ))
    )
WHERE `explain` ILIKE '%Filter column%'
    OR `explain` LIKE '%BuildRuntimeFilter%'
    OR `explain` LIKE '% Type:%'
    OR `explain` LIKE '% Strictness:%';

SELECT count()
FROM
    customer
ANTI LEFT JOIN nation
    ON c_nationkey = n_nationkey
SETTINGS enable_join_runtime_filters = '0';

SELECT count()
FROM
    customer
ANTI LEFT JOIN nation
    ON c_nationkey = n_nationkey
SETTINGS enable_join_runtime_filters = '1';

-- RIGHT ANTI JOIN
SELECT REGEXP_REPLACE(trimLeft(`explain`), '_runtime_filter_\\d+', '_runtime_filter_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count()
                FROM
                    customer
                ANTI RIGHT JOIN nation
                    ON c_nationkey = n_nationkey
            ))
    )
WHERE `explain` ILIKE '%Filter column%'
    OR `explain` LIKE '%BuildRuntimeFilter%'
    OR `explain` LIKE '% Type:%'
    OR `explain` LIKE '% Strictness:%';