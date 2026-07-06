DROP TABLE IF EXISTS tp;

CREATE TABLE tp
(
    x Int32,
    y Int32,
    PROJECTION p (SELECT x, y ORDER BY x)
)
ENGINE = MergeTree()
ORDER BY y
SETTINGS min_rows_for_wide_part = '4', min_bytes_for_wide_part = '32';

INSERT INTO tp SELECT
    number,
    number
FROM numbers(3);

INSERT INTO tp SELECT
    number,
    number
FROM numbers(5);

CHECK TABLE tp SETTINGS check_query_single_value_result = '0', max_threads = '1';

DROP TABLE tp;

CREATE TABLE tp
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64,
    PROJECTION p1 (SELECT p, sum(k), sum(v1), sum(v2) GROUP BY p)
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO tp (p, k, v1, v2);

CREATE TABLE tp
(
    x int,
    PROJECTION p (SELECT sum(x))
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS min_rows_for_wide_part = '2', min_bytes_for_wide_part = '0';

INSERT INTO tp;

SELECT part_type
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'tp';

SELECT part_type
FROM `system`.projection_parts
WHERE database = currentDatabase()
    AND table = 'tp';