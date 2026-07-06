DROP TABLE IF EXISTS not_partitioned;

CREATE TABLE not_partitioned
(
    x UInt8
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO not_partitioned;

INSERT INTO not_partitioned;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'not_partitioned'
    AND active
ORDER BY name ASC;

OPTIMIZE TABLE not_partitioned PARTITION tuple() FINAL;

SELECT sum(x)
FROM not_partitioned;

ALTER TABLE not_partitioned DETACH PARTITION ID 'all';

SELECT `system`.detached_parts.* EXCEPT (bytes_on_disk, path, disk, modification_time)
FROM `system`.detached_parts
WHERE database = currentDatabase()
    AND table = 'not_partitioned';

DROP TABLE not_partitioned;

DROP TABLE IF EXISTS partitioned_by_week;

CREATE TABLE partitioned_by_week
(
    d Date,
    x UInt8
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY toMonday(d);

-- 2000-01-03 belongs to a different week than 2000-01-01 and 2000-01-02
INSERT INTO partitioned_by_week;

INSERT INTO partitioned_by_week;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_week'
    AND active
ORDER BY name ASC;

OPTIMIZE TABLE partitioned_by_week PARTITION '2000-01-03' FINAL;

SELECT sum(x)
FROM partitioned_by_week;

ALTER TABLE partitioned_by_week DROP PARTITION '1999-12-27';

DROP TABLE partitioned_by_week;

DROP TABLE IF EXISTS partitioned_by_tuple;

CREATE TABLE partitioned_by_tuple
(
    d Date,
    x UInt8,
    y UInt8
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY (d, x);

INSERT INTO partitioned_by_tuple;

INSERT INTO partitioned_by_tuple;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_tuple'
    AND active
ORDER BY name ASC;

OPTIMIZE TABLE partitioned_by_tuple PARTITION ('2000-01-01', 1) FINAL;

OPTIMIZE TABLE partitioned_by_tuple PARTITION ('2000-01-02', 1) FINAL;

SELECT sum(y)
FROM partitioned_by_tuple;

ALTER TABLE partitioned_by_tuple DETACH PARTITION ID '20000101-1';

DROP TABLE partitioned_by_tuple;

DROP TABLE IF EXISTS partitioned_by_string;

CREATE TABLE partitioned_by_string
(
    s String,
    x UInt8
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY s;

INSERT INTO partitioned_by_string;

INSERT INTO partitioned_by_string;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_string'
    AND active
ORDER BY name ASC;

OPTIMIZE TABLE partitioned_by_string PARTITION 'aaa' FINAL;

SELECT sum(x)
FROM partitioned_by_string;

ALTER TABLE partitioned_by_string DROP PARTITION 'bbb';

DROP TABLE partitioned_by_string;

DROP TABLE IF EXISTS without_fixed_size_columns;

CREATE TABLE without_fixed_size_columns
(
    s String
)
ENGINE = MergeTree()
ORDER BY s
PARTITION BY length(s);

INSERT INTO without_fixed_size_columns;

SELECT
    `partition`,
    name,
    `rows`
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'without_fixed_size_columns'
    AND active
ORDER BY name ASC;

SELECT *
FROM without_fixed_size_columns
ORDER BY s ASC;

ALTER TABLE without_fixed_size_columns DROP PARTITION 1;

DROP TABLE without_fixed_size_columns;