-- Tags: long, no-object-storage
DROP TABLE IF EXISTS tp_1;

DROP TABLE IF EXISTS tp_2;

CREATE TABLE tp_1
(
    x Int32,
    y Int32,
    PROJECTION p (SELECT x, y ORDER BY x)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/01710_projection_fetch_' || currentDatabase(), '1_{replica}')
ORDER BY y
SETTINGS min_rows_for_wide_part = '4', min_bytes_for_wide_part = '32';

CREATE TABLE tp_2
(
    x Int32,
    y Int32,
    PROJECTION p (SELECT x, y ORDER BY x)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/01710_projection_fetch_' || currentDatabase(), '2_{replica}')
ORDER BY y
SETTINGS min_rows_for_wide_part = '4', min_bytes_for_wide_part = '32';

INSERT INTO tp_1 SELECT
    number,
    number
FROM numbers(3);

SYSTEM SYNC REPLICA tp_2;

SELECT *
FROM tp_2
ORDER BY x ASC;

INSERT INTO tp_1 SELECT
    number,
    number
FROM numbers(5);

-- test projection creation, materialization, clear and drop
ALTER TABLE tp_1 ADD PROJECTION pp (SELECT x, count() GROUP BY x);

SELECT count()
FROM `system`.projection_parts
WHERE database = currentDatabase()
    AND table = 'tp_2'
    AND name = 'pp'
    AND active;

SHOW CREATE TABLE tp_2;

-- all other three operations are mutations
SET mutations_sync = '2';

ALTER TABLE tp_1 MATERIALIZE PROJECTION pp;

ALTER TABLE tp_1 CLEAR PROJECTION pp;

SELECT *
FROM `system`.projection_parts
WHERE database = currentDatabase()
    AND table = 'tp_2'
    AND name = 'pp'
    AND active;

ALTER TABLE tp_1 DROP PROJECTION pp;