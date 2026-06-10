-- Tags: no-random-merge-tree-settings
SET optimize_read_in_order = '1';

SET read_in_order_two_level_merge_threshold = '100';

DROP TABLE IF EXISTS x1;

DROP TABLE IF EXISTS x2;

CREATE TABLE x1
(
    i Nullable(int)
)
ENGINE = MergeTree()
ORDER BY i DESC
SETTINGS allow_nullable_key = '1', index_granularity = '2', allow_experimental_reverse_key = '1';

INSERT INTO x1 SELECT *
FROM numbers(100);

OPTIMIZE TABLE x1 FINAL;

SELECT *
FROM x1
WHERE i = 3;

SELECT count()
FROM x1
WHERE i >= 3
    AND i <= 10;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM x1
                ORDER BY i DESC NULLS FIRST
                LIMIT 5
            ))
    )
WHERE `explain` ILIKE '%sort%'
SETTINGS
    max_threads = '1',
    enable_analyzer = '1';

EXPLAIN PIPELINE
SELECT *
FROM x1
ORDER BY i DESC NULLS FIRST
LIMIT 5
SETTINGS max_threads = '1';

SELECT *
FROM x1
ORDER BY i DESC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM x1
                ORDER BY i ASC
                LIMIT 5
            ))
    )
WHERE `explain` ILIKE '%sort%'
SETTINGS
    max_threads = '1',
    enable_analyzer = '1';

EXPLAIN PIPELINE
SELECT *
FROM x1
ORDER BY i ASC
LIMIT 5
SETTINGS max_threads = '1';

SELECT *
FROM x1
ORDER BY i ASC
LIMIT 5;

CREATE TABLE x2
(
    i Nullable(int),
    j Nullable(int)
)
ENGINE = MergeTree()
ORDER BY (i, j DESC)
SETTINGS allow_nullable_key = '1', index_granularity = '2', allow_experimental_reverse_key = '1';

INSERT INTO x2 SELECT
    number % 10,
    number + 1000
FROM numbers(100);

OPTIMIZE TABLE x2 FINAL;

SELECT *
FROM x2
WHERE j = 1003;

SELECT count()
FROM x2
WHERE (i >= 3
    AND i <= 10)
    AND (j >= 1003
    AND j <= 1008);

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM x2
                ORDER BY
                    i ASC,
                    j DESC NULLS FIRST
                LIMIT 5
            ))
    )
WHERE `explain` ILIKE '%sort%'
SETTINGS
    max_threads = '1',
    enable_analyzer = '1';

EXPLAIN PIPELINE
SELECT *
FROM x2
ORDER BY
    i ASC,
    j DESC NULLS FIRST
LIMIT 5
SETTINGS max_threads = '1';

SELECT *
FROM x2
ORDER BY
    i ASC,
    j DESC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM x2
                ORDER BY
                    i ASC,
                    j ASC
                LIMIT 5
            ))
    )
WHERE `explain` ILIKE '%sort%'
SETTINGS
    max_threads = '1',
    enable_analyzer = '1';

EXPLAIN PIPELINE
SELECT *
FROM x2
ORDER BY
    i ASC,
    j ASC
LIMIT 5
SETTINGS max_threads = '1';

SELECT *
FROM x2
ORDER BY
    i ASC,
    j ASC
LIMIT 5;

DROP TABLE x1;

DROP TABLE x2;