SELECT toTypeName(now());

SELECT toTypeName(now() - 1);

SELECT toTypeName(now('UTC') - 1);

SELECT toTypeName(now64(3));

SELECT toTypeName(now64(3) - 1);

SELECT toTypeName(toTimeZone(now64(3), 'UTC') - 1);

DROP TABLE IF EXISTS tt_null;

DROP TABLE IF EXISTS tt;

DROP TABLE IF EXISTS tt_mv;

CREATE TABLE tt_null
(
    p String
)
ENGINE = Null();

CREATE TABLE tt
(
    p String,
    tmin AggregateFunction(min, DateTime)
)
ENGINE = AggregatingMergeTree()
ORDER BY p;

CREATE MATERIALIZED VIEW tt_mv
TO tt
AS
SELECT
    p,
    minState(now() - toIntervalMinute(30)) AS tmin
FROM tt_null
GROUP BY p;

INSERT INTO tt_null;

DROP TABLE tt_null;

DROP TABLE tt;

DROP TABLE tt_mv;