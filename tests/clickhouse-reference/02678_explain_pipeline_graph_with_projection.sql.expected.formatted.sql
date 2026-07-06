DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    ID UInt64,
    name String
)
ENGINE = MergeTree()
ORDER BY ID;

INSERT INTO t1 (ID, name);

-- The returned node order is uncertain
EXPLAIN PIPELINE graph = '1'
SELECT count(ID)
FROM t1
FORMAT Null;

EXPLAIN PIPELINE graph = '1'
SELECT sum(1)
FROM t1
FORMAT Null;

EXPLAIN PIPELINE graph = '1'
SELECT min(ID)
FROM t1
FORMAT Null;

EXPLAIN PIPELINE graph = '1'
SELECT max(ID)
FROM t1
FORMAT Null;

DROP TABLE t1;