-- Tags: no-parallel
SET mutations_sync = '2';

-- system.parts has server default, timezone cannot be randomized
SET session_timezone = '';

SET allow_suspicious_ttl_expressions = '1';

DROP TABLE IF EXISTS ttl;

CREATE TABLE ttl
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toDayOfMonth(d)
SETTINGS max_number_of_merges_with_ttl_in_pool = '0', materialize_ttl_recalculate_only = true;

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL d + toIntervalDay(1);

SELECT *
FROM ttl
ORDER BY a ASC;

SELECT
    delete_ttl_info_min,
    delete_ttl_info_max
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'ttl'
    AND active > 0
ORDER BY name ASC;

OPTIMIZE TABLE ttl FINAL;

CREATE TABLE ttl
(
    i Int,
    s String
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS max_number_of_merges_with_ttl_in_pool = '0', materialize_ttl_recalculate_only = true;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL i % 2 = 0 ? toDate('2000-01-01') : toDate('2100-01-01');

SELECT *
FROM ttl
ORDER BY i ASC;

SELECT
    delete_ttl_info_min,
    delete_ttl_info_max
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'ttl'
    AND active > 0;

ALTER TABLE ttl MODIFY TTL toDate('2000-01-01');

ALTER TABLE ttl MODIFY COLUMN s String TTL i % 2 = 0 ? today() - 10 : toDate('2100-01-01');

ALTER TABLE ttl MODIFY COLUMN s String TTL toDate('2000-01-01');

CREATE TABLE ttl
(
    d Date,
    i Int,
    s String
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS max_number_of_merges_with_ttl_in_pool = '0', materialize_ttl_recalculate_only = true;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL i % 3 = 0 ? toDate('2000-01-01') : toDate('2100-01-01');

SELECT
    i,
    s
FROM ttl
ORDER BY i ASC;

ALTER TABLE ttl MODIFY COLUMN s String TTL d + toIntervalMonth(1);

CREATE TABLE ttl
(
    i Int,
    s String,
    t String
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS max_number_of_merges_with_ttl_in_pool = '0', materialize_ttl_recalculate_only = true;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY COLUMN s String TTL i % 3 = 0 ? today() - 10 : toDate('2100-01-01'), MODIFY COLUMN t String TTL i % 3 = 1 ? today() - 10 : toDate('2100-01-01');

SELECT
    i,
    s,
    t
FROM ttl
ORDER BY i ASC;

-- MATERIALIZE TTL ran only once
SELECT count()
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 'ttl'
    AND is_done;

-- Nothing changed, don't run mutation
CREATE TABLE ttl
(
    i Int,
    s String TTL toDate('2000-01-02')
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS max_number_of_merges_with_ttl_in_pool = '0', materialize_ttl_recalculate_only = true;

ALTER TABLE ttl MODIFY COLUMN s String TTL toDate('2000-01-02');