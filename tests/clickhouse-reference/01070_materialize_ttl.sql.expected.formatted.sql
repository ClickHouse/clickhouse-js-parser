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

SET materialize_ttl_after_modify = '0';

ALTER TABLE ttl MATERIALIZE TTL; -- { serverError INCORRECT_QUERY }

ALTER TABLE ttl MODIFY TTL d + toIntervalDay(1);

-- TTL should not be applied
SELECT *
FROM ttl
ORDER BY a ASC;

ALTER TABLE ttl MATERIALIZE TTL SETTINGS mutations_sync = '2';

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