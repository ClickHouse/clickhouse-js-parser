SET enable_analyzer = '1';

SET query_plan_join_swap_table = false;

SET enable_join_runtime_filters = '0';

SET enable_parallel_replicas = '0';

SET correlated_subqueries_default_join_kind = 'left';

SET correlated_subqueries_use_in_memory_buffer = '0';

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

EXPLAIN actions = '1'
SELECT count()
FROM users1 AS u1
WHERE exists((
        SELECT *
        FROM users2 AS u2
        WHERE u1.uid != u2.uid
    ));

EXPLAIN actions = '1'
SELECT count()
FROM users1 AS u1
WHERE NOT exists((
        SELECT *
        FROM users2 AS u2
        WHERE u1.uid != u2.uid
    ));