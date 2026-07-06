DROP TABLE IF EXISTS test_uint64;

CREATE TABLE test_uint64
(
    data UInt64 DEFAULT 0
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_uint64;

DROP TABLE IF EXISTS test_float64;

CREATE TABLE test_float64
(
    data Float64 DEFAULT 0.
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_float64;

DROP TABLE IF EXISTS test_date;

CREATE TABLE test_date
(
    data Date
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_date;

DROP TABLE IF EXISTS test_datetime;

CREATE TABLE test_datetime
(
    data DateTime
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_datetime;