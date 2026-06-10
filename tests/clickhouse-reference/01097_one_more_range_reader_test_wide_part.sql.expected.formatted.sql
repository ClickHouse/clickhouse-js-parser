DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    id UInt32,
    a Int
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO t;

ALTER TABLE t ADD COLUMN s String DEFAULT 'foo';

SELECT s
FROM t
PREWHERE a = 1;

DROP TABLE t;

INSERT INTO t;