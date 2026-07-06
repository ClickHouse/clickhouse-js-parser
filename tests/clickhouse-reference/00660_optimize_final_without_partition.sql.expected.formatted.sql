SET optimize_on_insert = '0';

DROP TABLE IF EXISTS partitioned_by_tuple;

CREATE TABLE partitioned_by_tuple
(
    d Date,
    x UInt8,
    w String,
    y UInt8
)
ENGINE = SummingMergeTree(y)
ORDER BY (d, x, w)
PARTITION BY (d, x);

INSERT INTO partitioned_by_tuple;

INSERT INTO partitioned_by_tuple;

INSERT INTO partitioned_by_tuple;

OPTIMIZE TABLE partitioned_by_tuple;

SELECT *
FROM partitioned_by_tuple
ORDER BY
    d ASC,
    x ASC,
    w ASC,
    y ASC;

OPTIMIZE TABLE partitioned_by_tuple FINAL;

DROP TABLE partitioned_by_tuple;