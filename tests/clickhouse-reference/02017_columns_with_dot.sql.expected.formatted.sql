DROP TABLE IF EXISTS t_with_dots;

CREATE TABLE t_with_dots
(
    id UInt32,
    arr Array(UInt32),
    `b.id` UInt32,
    `b.arr` Array(UInt32)
)
ENGINE = Log();

INSERT INTO t_with_dots;

SELECT *
FROM t_with_dots;

DROP TABLE t_with_dots;

CREATE TABLE t_with_dots
(
    id UInt32,
    arr Array(UInt32),
    `b.id` UInt32,
    `b.arr` Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t_with_dots
(
    id UInt32,
    arr Array(UInt32),
    `b.id` UInt32,
    `b.arr` Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0';