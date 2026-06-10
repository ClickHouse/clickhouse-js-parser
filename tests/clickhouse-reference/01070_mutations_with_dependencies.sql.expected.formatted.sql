-- Tags: no-parallel, no-object-storage
-- With s3 policy TTL TO DISK 'default' doesn't work (because we have no default, only 's3')
DROP TABLE IF EXISTS ttl;

SET mutations_sync = '2';

-- check that ttl info was updated after mutation.
CREATE TABLE ttl
(
    i Int,
    a Int,
    s String
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO ttl;

ALTER TABLE ttl MODIFY TTL a % 2 = 0 ? today() - 10 : toDate('2100-01-01');

ALTER TABLE ttl MATERIALIZE TTL;

SELECT *
FROM ttl
ORDER BY i ASC;

ALTER TABLE ttl UPDATE a = 0 WHERE i % 2 = 0;

DROP TABLE ttl;

-- check that skip index is updated after column was modified by ttl.
CREATE TABLE ttl
(
    i Int,
    a Int,
    s String DEFAULT 'b' TTL a % 2 = 0 ? today() - 10 : toDate('2100-01-01'),
    INDEX ind_s s TYPE set(1) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO ttl;

SELECT count()
FROM ttl
WHERE s = 'a';

SELECT count()
FROM ttl
WHERE s = 'b';

-- check only that it doesn't throw exceptions.
SET allow_suspicious_ttl_expressions = '1';

CREATE TABLE ttl
(
    i Int,
    s String
)
ENGINE = MergeTree()
ORDER BY i
TTL toDate('2000-01-01') TO DISK 'default';

CREATE TABLE ttl
(
    a Int,
    b Int,
    c Int DEFAULT 42 TTL d,
    d Date,
    INDEX ind b * c TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO ttl;

ALTER TABLE ttl UPDATE d = '2000-01-01' WHERE 1;

SELECT *
FROM ttl;