-- Tags: no-parallel
DROP TABLE IF EXISTS table_for_ttl;

CREATE TABLE table_for_ttl
(
    d DateTime,
    key UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY key;

INSERT INTO table_for_ttl SELECT
    now() - toIntervalYear(2),
    1,
    toString(number)
FROM numbers(1000);

INSERT INTO table_for_ttl SELECT
    now() - toIntervalDay(2),
    3,
    toString(number)
FROM numbers(2000, 1000);

INSERT INTO table_for_ttl SELECT
    now(),
    4,
    toString(number)
FROM numbers(3000, 1000);

SELECT count()
FROM table_for_ttl;

ALTER TABLE table_for_ttl MODIFY TTL d + toIntervalYear(1) SETTINGS materialize_ttl_after_modify = '0';

OPTIMIZE TABLE table_for_ttl FINAL;

ALTER TABLE table_for_ttl MODIFY COLUMN value String TTL d + toIntervalDay(1) SETTINGS materialize_ttl_after_modify = '0';

SELECT countDistinct(value)
FROM table_for_ttl;