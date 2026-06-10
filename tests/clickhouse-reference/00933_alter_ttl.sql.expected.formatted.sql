SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS ttl;

CREATE TABLE ttl
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toDayOfMonth(d)
SETTINGS remove_empty_parts = '0';

ALTER TABLE ttl MODIFY TTL d + toIntervalDay(1);

SHOW CREATE TABLE ttl;

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

INSERT INTO ttl;

OPTIMIZE TABLE ttl PARTITION 10 FINAL;

SELECT *
FROM ttl
ORDER BY
    d ASC,
    a ASC;

ALTER TABLE ttl MODIFY TTL a; -- { serverError BAD_TTL_EXPRESSION }

CREATE TABLE ttl
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDayOfMonth(d)
SETTINGS remove_empty_parts = '0';

ALTER TABLE ttl MODIFY COLUMN a Int TTL d + toIntervalDay(1);

DESCRIBE TABLE ttl;

ALTER TABLE ttl MODIFY COLUMN d Int TTL d + toIntervalDay(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

ALTER TABLE ttl MODIFY COLUMN d DateTime TTL d + toIntervalDay(1); -- { serverError ALTER_OF_COLUMN_IS_FORBIDDEN }