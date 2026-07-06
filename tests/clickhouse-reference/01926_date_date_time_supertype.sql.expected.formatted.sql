SELECT toTypeName([toDate('2000-01-01'), toDateTime('2000-01-01', 'Asia/Istanbul')]);

SELECT toTypeName([toDate('2000-01-01'), toDateTime('2000-01-01', 'Asia/Istanbul'), toDateTime64('2000-01-01', 5, 'Asia/Istanbul')]);

SELECT toTypeName([toDate('2000-01-01'), toDateTime('2000-01-01', 'Asia/Istanbul'), toDateTime64('2000-01-01', 5, 'Asia/Istanbul'), toDateTime64('2000-01-01', 6, 'Asia/Istanbul')]);

DROP TABLE IF EXISTS predicate_table;

CREATE TABLE predicate_table
(
    value UInt8
)
ENGINE = TinyLog();

INSERT INTO predicate_table;

WITH toDate('2000-01-01') AS a,

toDateTime('2000-01-01', 'Asia/Istanbul') AS b

SELECT
    if(value, b, a) AS result,
    toTypeName(result)
FROM predicate_table;

WITH toDateTime('2000-01-01', 'Asia/Istanbul') AS a,

toDateTime64('2000-01-01', 5, 'Asia/Istanbul') AS b

SELECT
    if(value, b, a) AS result,
    toTypeName(result)
FROM predicate_table;

SELECT
    CAST(toDate('2000-01-01') AS DateTime('UTC')) AS x,
    toTypeName(x);

SELECT
    CAST(toDate('2000-01-01') AS DateTime64(5, 'UTC')) AS x,
    toTypeName(x);