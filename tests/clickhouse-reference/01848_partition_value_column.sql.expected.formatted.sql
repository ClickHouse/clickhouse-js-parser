DROP TABLE IF EXISTS tbl;

DROP TABLE IF EXISTS tbl2;

CREATE TABLE tbl
(
    dt DateTime,
    i int,
    j String,
    v Float64
)
ENGINE = MergeTree()
ORDER BY i
PARTITION BY (toDate(dt), i % 2, length(j))
SETTINGS index_granularity = '1';

INSERT INTO tbl;

SET optimize_use_implicit_projections = '1';

SELECT count()
FROM tbl
WHERE _partition_value = ('2021-04-01', 1, 2)
SETTINGS max_rows_to_read = '1';

SELECT count()
FROM tbl
WHERE (_partition_value).1 = '2021-04-01'
SETTINGS max_rows_to_read = '4';

SELECT count()
FROM tbl
WHERE (_partition_value).2 = 0
SETTINGS max_rows_to_read = '4';

SELECT count()
FROM tbl
WHERE (_partition_value).3 = 4
SETTINGS max_rows_to_read = '1';

CREATE TABLE tbl2
(
    i int
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO tbl2;

SELECT _partition_value
FROM tbl2; -- { serverError UNKNOWN_IDENTIFIER }

SELECT _partition_value
FROM tbl2
GROUP BY 1; -- { serverError UNKNOWN_IDENTIFIER }

DROP TABLE tbl;

DROP TABLE tbl2;