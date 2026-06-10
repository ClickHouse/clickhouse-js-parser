DROP TABLE IF EXISTS alter_ttl;

SET allow_suspicious_ttl_expressions = '1';

CREATE TABLE alter_ttl
(
    i Int
)
ENGINE = MergeTree()
ORDER BY i
TTL toDate('2020-05-05');

ALTER TABLE alter_ttl ADD COLUMN s String;

ALTER TABLE alter_ttl MODIFY COLUMN s String TTL toDate('2020-01-01');

SHOW CREATE TABLE alter_ttl;

DROP TABLE alter_ttl;

CREATE TABLE alter_ttl
(
    d Date,
    s String
)
ENGINE = MergeTree()
ORDER BY d
TTL d + toIntervalMonth(1);

ALTER TABLE alter_ttl MODIFY COLUMN s String TTL d + toIntervalDay(1);