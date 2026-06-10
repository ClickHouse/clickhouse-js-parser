SET enable_analyzer = '1';

SET query_plan_join_swap_table = '0';

SET enable_parallel_replicas = '0';

SET enable_join_runtime_filters = '0';

CREATE TABLE users1
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users1 SELECT
    number AS uid,
    'Alice' AS name,
    30 AS age
FROM numbers(100000);

CREATE TABLE users2
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users2 SELECT
    number AS uid,
    'Alice2' AS name,
    30 AS age
FROM numbers(1000);

EXPLAIN actions = '1', keep_logical_steps = '1'
SELECT count()
FROM
    (
        SELECT
            1 AS x,
            *
        FROM users1
    ) AS u1
ANY LEFT JOIN users2 AS u2
    ON u1.uid = u2.uid
WHERE 1 / u2.age > 1;

EXPLAIN actions = '1', keep_logical_steps = '1'
SELECT count()
FROM
    (
        SELECT
            1 AS x,
            *
        FROM users1
    ) AS u1
ANY LEFT JOIN users2 AS u2
    ON u1.uid = u2.uid
WHERE u2.age > 1;