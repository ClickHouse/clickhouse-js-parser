DROP TABLE IF EXISTS merge_tree_in_subqueries;

CREATE TABLE merge_tree_in_subqueries
(
    id UInt64,
    name String,
    num UInt64
)
ENGINE = MergeTree()
ORDER BY (id, name);

INSERT INTO merge_tree_in_subqueries;

INSERT INTO merge_tree_in_subqueries;

INSERT INTO merge_tree_in_subqueries;

INSERT INTO merge_tree_in_subqueries;

INSERT INTO merge_tree_in_subqueries;

SET parallel_replicas_only_with_analyzer = '0'; -- necessary for CI run with disabled analyzer

SET max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost', parallel_replicas_for_non_replicated_merge_tree = '1';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 0
    )
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '0'; -- { serverError SUPPORT_IS_DISABLED }

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 0
    )
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '1';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 0
    )
SETTINGS enable_parallel_replicas = '1';

SELECT '---';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 3
        OFFSET 2
    )
ORDER BY id ASC
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '0'; -- { serverError SUPPORT_IS_DISABLED };

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 3
        OFFSET 2
    )
ORDER BY id ASC
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '1';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT *
        FROM `system`.numbers
        LIMIT 3
        OFFSET 2
    )
ORDER BY id ASC
SETTINGS enable_parallel_replicas = '1';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT 1
    )
ORDER BY id ASC
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '0'; -- { serverError SUPPORT_IS_DISABLED };

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT 1
    )
ORDER BY id ASC
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '1';

SELECT *
FROM merge_tree_in_subqueries
WHERE id IN (
        SELECT 1
    )
ORDER BY id ASC
SETTINGS enable_parallel_replicas = '1';

SELECT
    id,
    name
FROM merge_tree_in_subqueries
WHERE (id, name) IN (3, 'test3')
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '0';

SELECT
    id,
    name
FROM merge_tree_in_subqueries
WHERE (id, name) IN (3, 'test3')
SETTINGS
    enable_parallel_replicas = '2',
    parallel_replicas_allow_in_with_subquery = '1';