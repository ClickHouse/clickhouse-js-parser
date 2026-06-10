DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a;

INSERT INTO t SELECT
    number % 10,
    number
FROM numbers(10000);

CREATE OR REPLACE ROW POLICY rp ON t USING 0 TO ALL;

SELECT
    count(),
    min(a),
    max(a)
FROM t;

DROP ROW POLICY rp ON t;

DROP TABLE t;