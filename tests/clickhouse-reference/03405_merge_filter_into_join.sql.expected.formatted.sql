CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

-- For some reason planner sometimes decides to swap tables.
-- It breaks test because it prints query plan with actions.
SET query_plan_join_swap_table = '0';

SET enable_analyzer = '1'; -- Optimization requires LogicalJoinStep

SET enable_parallel_replicas = '0'; -- Optimization requires LogicalJoinStep

SET parallel_hash_join_threshold = '0';

-- { echoOn }
EXPLAIN actions = '1'
SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        INNER JOIN users AS u2
            ON 1
    )
WHERE age = u2.age
ORDER BY `ALL` ASC
SETTINGS enable_join_runtime_filters = '0';

SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        INNER JOIN users AS u2
            ON 1
    )
WHERE age = u2.age
ORDER BY `ALL` ASC;

EXPLAIN actions = '1'
SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        CROSS JOIN users AS u2
    )
WHERE age = u2.age
ORDER BY `ALL` ASC
SETTINGS enable_join_runtime_filters = '0';

SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        CROSS JOIN users AS u2
    )
WHERE age = u2.age
ORDER BY `ALL` ASC;

EXPLAIN actions = '1'
SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        SEMI LEFT JOIN users AS u2
            ON 1
    )
WHERE age = u2.age
ORDER BY `ALL` ASC
SETTINGS enable_join_runtime_filters = '0';

EXPLAIN actions = '1'
SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        FULL JOIN users AS u2
            ON 1
    )
WHERE age = u2.age
ORDER BY `ALL` ASC
SETTINGS enable_join_runtime_filters = '0';

EXPLAIN actions = '1'
SELECT *
FROM (
        SELECT *
        FROM
            users AS u1
        ANTI LEFT JOIN users AS u2
            ON 1
    )
WHERE age = u2.age
ORDER BY `ALL` ASC
SETTINGS enable_join_runtime_filters = '0';