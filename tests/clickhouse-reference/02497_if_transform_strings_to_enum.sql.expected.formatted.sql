SET enable_analyzer = '1';

SET optimize_if_transform_strings_to_enum = '1';

SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10;

SELECT number > 5 ? 'censor.net' : 'google'
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT number > 5 ? 'censor.net' : 'google'
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT number > 5 ? 'censor.net' : 'google'
FROM `system`.numbers
LIMIT 10;

SELECT CONCAT(transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other'), '1')
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT CONCAT(transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other'), '1')
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT CONCAT(transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other'), '1')
FROM `system`.numbers
LIMIT 10;

SELECT CONCAT(number > 5 ? 'censor.net' : 'google', '1')
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT CONCAT(number > 5 ? 'censor.net' : 'google', '1')
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT CONCAT(number > 5 ? 'censor.net' : 'google', '1')
FROM `system`.numbers
LIMIT 10;

SELECT t1.value
FROM (
        SELECT number > 5 ? 'censor.net' : 'google' AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

EXPLAIN SYNTAX
SELECT t1.value
FROM (
        SELECT number > 5 ? 'censor.net' : 'google' AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

EXPLAIN QUERY TREE run_passes = '1'
SELECT t1.value
FROM (
        SELECT number > 5 ? 'censor.net' : 'google' AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

SELECT t1.value
FROM (
        SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

EXPLAIN SYNTAX
SELECT t1.value
FROM (
        SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

EXPLAIN QUERY TREE run_passes = '1'
SELECT t1.value
FROM (
        SELECT transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value
        FROM `system`.numbers
        LIMIT 10
    ) AS t1;

SELECT
    number > 5 ? 'censor.net' : 'google' AS value,
    value
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT
    number > 5 ? 'censor.net' : 'google' AS value,
    value
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT
    number > 5 ? 'censor.net' : 'google' AS value,
    value
FROM `system`.numbers
LIMIT 10;

SELECT
    transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value,
    value
FROM `system`.numbers
LIMIT 10;

EXPLAIN SYNTAX
SELECT
    transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value,
    value
FROM `system`.numbers
LIMIT 10;

EXPLAIN QUERY TREE run_passes = '1'
SELECT
    transform(number, [2, 4, 6], ['google', 'censor.net', 'yahoo'], 'other') AS value,
    value
FROM `system`.numbers
LIMIT 10;

SELECT transform(number, [NULL], ['google', 'censor.net', 'yahoo'], 'other')
FROM (
        SELECT NULL AS number
        FROM `system`.numbers
        LIMIT 10
    );

EXPLAIN SYNTAX
SELECT transform(number, [NULL], ['google', 'censor.net', 'yahoo'], 'other')
FROM (
        SELECT NULL AS number
        FROM `system`.numbers
        LIMIT 10
    );

EXPLAIN QUERY TREE run_passes = '1'
SELECT transform(number, [NULL], ['google', 'censor.net', 'yahoo'], 'other')
FROM (
        SELECT NULL AS number
        FROM `system`.numbers
        LIMIT 10
    );

SELECT transform(number, NULL, ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT transform(number, NULL, ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

EXPLAIN QUERY TREE run_passes = '1'
SELECT transform(number, NULL, ['google', 'censor.net', 'yahoo'], 'other')
FROM `system`.numbers
LIMIT 10; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SET optimize_if_transform_strings_to_enum = '0';