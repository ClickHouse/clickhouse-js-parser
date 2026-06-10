DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    i8 Int8,
    i16 Int16,
    i32 Int32,
    i64 Int64
)
ENGINE = Memory();

INSERT INTO t;

SELECT
    * APPLY(bitmapMin),
    * APPLY(bitmapMax)
FROM (
        SELECT * APPLY(groupBitmapState)
        FROM t
    );

DROP TABLE t;