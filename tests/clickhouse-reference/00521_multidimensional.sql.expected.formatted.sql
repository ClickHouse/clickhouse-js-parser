DROP TABLE IF EXISTS multidimensional;

CREATE TABLE multidimensional
(
    x UInt64,
    arr Array(Array(String))
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO multidimensional;

SELECT *
FROM multidimensional;

ALTER TABLE multidimensional ADD COLUMN t Tuple(String, Array(Nullable(String)), Tuple(UInt32, Date));

INSERT INTO multidimensional (t);

SELECT *
FROM multidimensional
ORDER BY t ASC;

OPTIMIZE TABLE multidimensional;

DROP TABLE multidimensional;

CREATE TABLE multidimensional
(
    x UInt64,
    arr Array(Array(String)),
    t Tuple(String, Array(Nullable(String)), Tuple(UInt32, Date))
)
ENGINE = Memory();

INSERT INTO multidimensional;

CREATE TABLE multidimensional
(
    x UInt64,
    arr Array(Array(String)),
    t Tuple(String, Array(Nullable(String)), Tuple(UInt32, Date))
)
ENGINE = TinyLog();

CREATE TABLE multidimensional
(
    x UInt64,
    arr Array(Array(String)),
    t Tuple(String, Array(Nullable(String)), Tuple(UInt32, Date))
)
ENGINE = StripeLog();

CREATE TABLE multidimensional
(
    x UInt64,
    arr Array(Array(String)),
    t Tuple(String, Array(Nullable(String)), Tuple(UInt32, Date))
)
ENGINE = Log();