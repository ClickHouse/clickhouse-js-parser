-- Tags: no-parallel
SET allow_suspicious_ttl_expressions = '1';

DROP TABLE IF EXISTS ttl;

CREATE TABLE ttl
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toDayOfMonth(d);

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

SET mutations_sync = '2';

ALTER TABLE ttl MODIFY TTL d + toIntervalDay(1);

SELECT *
FROM ttl
ORDER BY a ASC;

CREATE TABLE ttl
(
    i Int,
    s String
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL i % 2 = 0 ? today() - 10 : toDate('2100-01-01');

SELECT *
FROM ttl
ORDER BY i ASC;

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
ORDER BY i;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL i % 3 = 0 ? today() - 10 : toDate('2100-01-01');

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
ORDER BY i;

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
ORDER BY i;

ALTER TABLE ttl MODIFY COLUMN s String TTL toDate('2000-01-02');