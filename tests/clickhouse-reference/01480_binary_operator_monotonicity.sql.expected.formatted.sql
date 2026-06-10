DROP TABLE IF EXISTS binary_op_mono1;

DROP TABLE IF EXISTS binary_op_mono2;

DROP TABLE IF EXISTS binary_op_mono3;

DROP TABLE IF EXISTS binary_op_mono4;

DROP TABLE IF EXISTS binary_op_mono5;

DROP TABLE IF EXISTS binary_op_mono6;

DROP TABLE IF EXISTS binary_op_mono7;

DROP TABLE IF EXISTS binary_op_mono8;

CREATE TABLE binary_op_mono1
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY toDate(i / 1000);

CREATE TABLE binary_op_mono2
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY 1000 / i
SETTINGS allow_floating_point_partition_key = true;

;

CREATE TABLE binary_op_mono3
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i + 1000;

CREATE TABLE binary_op_mono4
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY 1000 + i;

CREATE TABLE binary_op_mono5
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i - 1000;

CREATE TABLE binary_op_mono6
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY 1000 - i;

CREATE TABLE binary_op_mono7
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i / 1000.
SETTINGS allow_floating_point_partition_key = true;

CREATE TABLE binary_op_mono8
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY 1000. / i
SETTINGS allow_floating_point_partition_key = true;

INSERT INTO binary_op_mono1;

INSERT INTO binary_op_mono2;

INSERT INTO binary_op_mono3;

INSERT INTO binary_op_mono4;

INSERT INTO binary_op_mono5;

INSERT INTO binary_op_mono6;

INSERT INTO binary_op_mono7;

INSERT INTO binary_op_mono8;

SET max_rows_to_read = '1';

SELECT count()
FROM binary_op_mono1
WHERE toDate(i / 1000) = '2020-09-02';

SELECT count()
FROM binary_op_mono2
WHERE 1000 / i = 100;

SELECT count()
FROM binary_op_mono3
WHERE i + 1000 = 500;

SELECT count()
FROM binary_op_mono4
WHERE 1000 + i = 500;

SELECT count()
FROM binary_op_mono5
WHERE i - 1000 = 1234;

SELECT count()
FROM binary_op_mono6
WHERE 1000 - i = 1234;

SELECT count()
FROM binary_op_mono7
WHERE i / 1000. = 22.3;

SELECT count()
FROM binary_op_mono8
WHERE 1000. / i = 33.4;

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY i / 10
SETTINGS index_granularity = '1';

INSERT INTO x;

SET max_rows_to_read = '3';

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT *
FROM x
WHERE i > 30; -- converted to i / 10 >= 3, thus needs to read 3 granules.

DROP TABLE x;