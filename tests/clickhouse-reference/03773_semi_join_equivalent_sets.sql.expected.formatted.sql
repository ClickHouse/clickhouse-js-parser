SET enable_analyzer = '1';

SET enable_parallel_replicas = '0';

SET query_plan_join_swap_table = '0';

SET enable_join_runtime_filters = '0';

CREATE TABLE users
(
    uid UInt64,
    name String,
    age Int16
)
ENGINE = MergeTree()
ORDER BY uid;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    users
                ANY LEFT JOIN (
                        SELECT number
                        FROM numbers(10)
                    ) AS t2
                    ON users.uid = t2.number
                WHERE t2.number = 0
            ))
    )
WHERE `explain` ILIKE '%Type:%'
    OR `explain` ILIKE '%Strictness%'
    OR `explain` ILIKE '%filter column%';

EXPLAIN actions = '1'
SELECT *
FROM
    users
SEMI LEFT JOIN (
        SELECT number
        FROM numbers(10)
    ) AS t2
    ON users.uid = t2.number
WHERE t2.number = 1;

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    users
                ANY LEFT JOIN (
                        SELECT number
                        FROM numbers(10)
                    ) AS t2
                    ON users.uid = t2.number
                WHERE t2.number = 1
            ))
    )
WHERE `explain` ILIKE '%Type:%'
    OR `explain` ILIKE '%Strictness%'
    OR `explain` ILIKE '%filter column%';

SELECT '--';

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    users
                SEMI LEFT JOIN (
                        SELECT number
                        FROM numbers(10)
                    ) AS t2
                    ON users.uid = t2.number
                WHERE users.uid = 1
            ))
    )
WHERE `explain` ILIKE '%Type:%'
    OR `explain` ILIKE '%Strictness%'
    OR `explain` ILIKE '%filter column%';

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    users
                ANY RIGHT JOIN (
                        SELECT number
                        FROM numbers(10)
                    ) AS t2
                    ON users.uid = t2.number
                WHERE users.uid = 1
            ))
    )
WHERE `explain` ILIKE '%Type:%'
    OR `explain` ILIKE '%Strictness%'
    OR `explain` ILIKE '%filter column%';

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    users
                SEMI RIGHT JOIN (
                        SELECT number
                        FROM numbers(10)
                    ) AS t2
                    ON users.uid = t2.number
                WHERE t2.number = 1
            ))
    )
WHERE `explain` ILIKE '%Type:%'
    OR `explain` ILIKE '%Strictness%'
    OR `explain` ILIKE '%filter column%';