DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    date Date,
    s1 String,
    s2 String
)
ENGINE = MergeTree()
ORDER BY (date, s1)
PARTITION BY toYYYYMMDD(date)
SETTINGS index_granularity = '8192';

INSERT INTO t1 (date, s1, s2);

ALTER TABLE t1 ADD COLUMN s3 String DEFAULT concat(s2, '_', s1);

INSERT INTO t1 (date, s1, s2);

SELECT
    ignore(date),
    s3
FROM t1
WHERE s2 = 'bbb';

DROP TABLE t1;