-- Tags: long, replica
DROP TABLE IF EXISTS minmax_idx1;

DROP TABLE IF EXISTS minmax_idx2;

CREATE TABLE minmax_idx1
(
    u64 UInt64,
    i32 Int32,
    f64 Float64,
    d Decimal(10, 2),
    s String,
    e Enum8('a' = 1, 'b' = 2, 'c' = 3),
    dt Date,
    INDEX idx_all (i32, i32 + f64, d, s, e, dt) TYPE minmax() GRANULARITY 1,
    INDEX idx_2 (u64 + toYear(dt), substring(s, 2, 4)) TYPE minmax() GRANULARITY 3
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00837/minmax', 'r1')
ORDER BY u64
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

CREATE TABLE minmax_idx2
(
    u64 UInt64,
    i32 Int32,
    f64 Float64,
    d Decimal(10, 2),
    s String,
    e Enum8('a' = 1, 'b' = 2, 'c' = 3),
    dt Date,
    INDEX idx_all (i32, i32 + f64, d, s, e, dt) TYPE minmax() GRANULARITY 1,
    INDEX idx_2 (u64 + toYear(dt), substring(s, 2, 4)) TYPE minmax() GRANULARITY 3
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00837/minmax', 'r2')
ORDER BY u64
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

/* many small inserts => table will make merges */
INSERT INTO minmax_idx1;

INSERT INTO minmax_idx1;

INSERT INTO minmax_idx2;

INSERT INTO minmax_idx2;

INSERT INTO minmax_idx2;

INSERT INTO minmax_idx1;

SYSTEM SYNC REPLICA minmax_idx1;

SYSTEM SYNC REPLICA minmax_idx2;

INSERT INTO minmax_idx1;

INSERT INTO minmax_idx1;

INSERT INTO minmax_idx1;

INSERT INTO minmax_idx1;

INSERT INTO minmax_idx2;

INSERT INTO minmax_idx2;

OPTIMIZE TABLE minmax_idx1;

OPTIMIZE TABLE minmax_idx2;

/* simple select */
SELECT *
FROM minmax_idx1
WHERE i32 = 5
    AND i32 + f64 < 12
    AND 3 < d
    AND d < 7
    AND (s = 'bac'
    OR s = 'cba')
ORDER BY dt ASC;

SELECT *
FROM minmax_idx2
WHERE i32 = 5
    AND i32 + f64 < 12
    AND 3 < d
    AND d < 7
    AND (s = 'bac'
    OR s = 'cba')
ORDER BY dt ASC;

/* select with hole made by primary key */
SELECT *
FROM minmax_idx1
WHERE (u64 < 2
    OR u64 > 10)
    AND e != 'b'
ORDER BY dt ASC;

SELECT *
FROM minmax_idx2
WHERE (u64 < 2
    OR u64 > 10)
    AND e != 'b'
ORDER BY dt ASC;

DROP TABLE minmax_idx1;

DROP TABLE minmax_idx2;