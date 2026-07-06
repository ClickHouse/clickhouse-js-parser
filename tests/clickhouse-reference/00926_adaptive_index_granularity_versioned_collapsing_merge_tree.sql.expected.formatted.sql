-- Tags: no-random-merge-tree-settings
----- Group of very similar simple tests ------
DROP TABLE IF EXISTS zero_rows_per_granule;

CREATE TABLE zero_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64,
    Sign Int8,
    Version UInt8
)
ENGINE = VersionedCollapsingMergeTree(Sign, Version)
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '20', min_index_granularity_bytes = '10', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO zero_rows_per_granule (p, k, v1, v2, Sign, Version);

SELECT COUNT(*)
FROM zero_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'zero_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO zero_rows_per_granule (p, k, v1, v2, Sign, Version);

OPTIMIZE TABLE zero_rows_per_granule FINAL;

SELECT COUNT(*)
FROM zero_rows_per_granule FINAL;

SELECT sum(marks)
FROM `system`.parts
WHERE table = 'zero_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

SELECT '-----';

DROP TABLE IF EXISTS four_rows_per_granule;

CREATE TABLE four_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64,
    Sign Int8,
    Version UInt8
)
ENGINE = VersionedCollapsingMergeTree(Sign, Version)
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '120', min_index_granularity_bytes = '100', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO four_rows_per_granule (p, k, v1, v2, Sign, Version);

SELECT COUNT(*)
FROM four_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'four_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO four_rows_per_granule (p, k, v1, v2, Sign, Version);

OPTIMIZE TABLE four_rows_per_granule FINAL;

-- We expect zero marks here, so we might get zero rows if all the parts were
-- deleted already. This can happen in parallel runs where there may be a long delay
-- between queries. So we must write the query in such a way that it always returns
-- zero rows if OK.
SELECT DISTINCT marks AS d
FROM `system`.parts
WHERE table = 'four_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1
HAVING d > 0;

INSERT INTO four_rows_per_granule (p, k, v1, v2, Sign, Version);

INSERT INTO four_rows_per_granule (p, k, v1, v2, Sign, Version);

DROP TABLE IF EXISTS six_rows_per_granule;

CREATE TABLE six_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64,
    Sign Int8,
    Version UInt8
)
ENGINE = VersionedCollapsingMergeTree(Sign, Version)
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '170', min_index_granularity_bytes = '100', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

OPTIMIZE TABLE six_rows_per_granule FINAL;

SELECT COUNT(*)
FROM six_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'six_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

INSERT INTO six_rows_per_granule (p, k, v1, v2, Sign, Version);

-- We expect zero marks here, so we might get zero rows if all the parts were
-- deleted already. This can happen in parallel runs where there may be a long delay
-- between queries. So we must write the query in such a way that it always returns
-- zero rows if OK.
SELECT DISTINCT marks AS d
FROM `system`.parts
WHERE table = 'six_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1
HAVING d > 0;