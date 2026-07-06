-- Tags: global
SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS xp;

DROP TABLE IF EXISTS xp_d;

CREATE TABLE xp
(
    i UInt64,
    j UInt64
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '1';

CREATE TABLE xp_d AS xp
ENGINE = Distributed(test_shard_localhost, currentDatabase(), xp);

INSERT INTO xp SELECT
    number,
    number + 2
FROM numbers(10);

SET max_rows_to_read = '4'; -- 2 from numbers, 2 from tables

SELECT *
FROM xp
WHERE i IN (
        SELECT *
        FROM numbers(2)
    );

SELECT *
FROM xp
WHERE i GLOBAL IN (
        SELECT *
        FROM numbers(2)
    );

SELECT *
FROM xp_d
WHERE i IN (
        SELECT *
        FROM numbers(2)
    );

SET max_rows_to_read = '6'; -- 2 from numbers, 2 from GLOBAL temp table (pushed from numbers), 2 from local xp

SELECT *
FROM xp_d
WHERE i GLOBAL IN (
        SELECT *
        FROM numbers(2)
    );