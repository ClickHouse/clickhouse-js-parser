CREATE TABLE t1
(
    key Int32,
    value DateTime
)
ENGINE = Log();

INSERT INTO t1 SELECT
    number,
    number
FROM numbers(10000);

CREATE TABLE t2
ENGINE = Log() AS
SELECT
    key AS key1,
    value
FROM t1;

EXPLAIN actions = '1'
SELECT count()
FROM (
        SELECT key
        FROM
            t1
        CROSS JOIN t2
        WHERE t1.value >= toDateTime(toString(t2.value))
    )
WHERE key = 162601
SETTINGS enable_analyzer = '1';