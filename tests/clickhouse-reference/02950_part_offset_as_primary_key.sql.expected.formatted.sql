SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS a;

CREATE TABLE a
(
    i int
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '2';

INSERT INTO a SELECT -number
FROM numbers(5);

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

-- nothing to read
SELECT i
FROM a
WHERE _part_offset >= 5
ORDER BY i ASC
SETTINGS max_bytes_to_read = '1';

-- one granule
SELECT i
FROM a
WHERE _part_offset = 0
ORDER BY i ASC
SETTINGS max_rows_to_read = '2';

SELECT i
FROM a
WHERE _part_offset = 1
ORDER BY i ASC
SETTINGS max_rows_to_read = '2';

SELECT i
FROM a
WHERE _part_offset = 2
ORDER BY i ASC
SETTINGS max_rows_to_read = '2';

SELECT i
FROM a
WHERE _part_offset = 3
ORDER BY i ASC
SETTINGS max_rows_to_read = '2';

SELECT i
FROM a
WHERE _part_offset = 4
ORDER BY i ASC
SETTINGS max_rows_to_read = '1';

-- other predicates
SELECT i
FROM a
WHERE _part_offset IN (1, 4)
ORDER BY i ASC
SETTINGS max_rows_to_read = '3';

SELECT i
FROM a
WHERE _part_offset NOT IN (1, 4)
ORDER BY i ASC
SETTINGS max_rows_to_read = '4';

-- the force_primary_key check still works
SELECT i
FROM a
WHERE _part_offset = 4
ORDER BY i ASC
SETTINGS force_primary_key = '1'; -- { serverError INDEX_NOT_USED }

-- combining with other primary keys doesn't work (makes no sense)
SELECT i
FROM a
WHERE i = -3
    OR _part_offset = 4
ORDER BY i ASC
SETTINGS force_primary_key = '1'; -- { serverError INDEX_NOT_USED }

DROP TABLE a;

DROP TABLE IF EXISTS b;

CREATE TABLE b
(
    i int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2';

-- all_1_1_0
INSERT INTO b SELECT number * 10
FROM numbers(5);

-- all_2_2_0
INSERT INTO b SELECT number * 100
FROM numbers(5);

-- multiple parts with _part predicate
SELECT i
FROM b
WHERE _part = 'all_1_1_0'
    AND _part_offset IN (1, 4)
    OR _part = 'all_2_2_0'
    AND _part_offset IN (0, 4)
ORDER BY i ASC
SETTINGS max_rows_to_read = '6';

DROP TABLE b;