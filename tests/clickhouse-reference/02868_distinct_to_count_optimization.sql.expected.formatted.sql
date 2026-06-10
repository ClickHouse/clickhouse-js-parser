DROP TABLE IF EXISTS test_rewrite_uniq_to_count;

CREATE TABLE test_rewrite_uniq_to_count
(
    a UInt8,
    b UInt8,
    c UInt8
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_rewrite_uniq_to_count;

INSERT INTO test_rewrite_uniq_to_count;

INSERT INTO test_rewrite_uniq_to_count;

SET optimize_uniq_to_count = true;

SELECT uniq(a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    )
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    )
SETTINGS enable_analyzer = '0';

SELECT uniq(a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    )
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    )
SETTINGS enable_analyzer = '1';

SELECT uniq(t.a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(t.a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(t.a)
FROM (
        SELECT DISTINCT a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

SELECT uniq(a)
FROM (
        SELECT DISTINCT test_rewrite_uniq_to_count.a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(a)
FROM (
        SELECT DISTINCT test_rewrite_uniq_to_count.a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(a)
FROM (
        SELECT DISTINCT test_rewrite_uniq_to_count.a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(a)
FROM (
        SELECT DISTINCT test_rewrite_uniq_to_count.a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

SELECT uniq(alias_of_a)
FROM (
        SELECT DISTINCT a AS alias_of_a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(alias_of_a)
FROM (
        SELECT DISTINCT a AS alias_of_a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(alias_of_a)
FROM (
        SELECT DISTINCT a AS alias_of_a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(alias_of_a)
FROM (
        SELECT DISTINCT a AS alias_of_a
        FROM test_rewrite_uniq_to_count
    ) AS t
SETTINGS enable_analyzer = '1';

SELECT uniq(a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    )
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    )
SETTINGS enable_analyzer = '0';

SELECT uniq(a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    )
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    )
SETTINGS enable_analyzer = '1';

SELECT uniq(t.a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(t.a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(t.a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(t.a)
FROM (
        SELECT
            a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '1';

SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY a
    ) AS t
SETTINGS enable_analyzer = '1';

SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY alias_of_a
    ) AS t
SETTINGS enable_analyzer = '0';

EXPLAIN SYNTAX
SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY alias_of_a
    ) AS t
SETTINGS enable_analyzer = '0';

SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY alias_of_a
    ) AS t
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE
SELECT uniq(t.alias_of_a)
FROM (
        SELECT
            a AS alias_of_a,
            sum(b)
        FROM test_rewrite_uniq_to_count
        GROUP BY alias_of_a
    ) AS t
SETTINGS enable_analyzer = '1';