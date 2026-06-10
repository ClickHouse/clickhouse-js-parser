-- Tests maps with "unusual" key types (Float32, Nothing, LowCardinality(String))
SET mutations_sync = '2';

DROP TABLE IF EXISTS tab;

SELECT 'Map(Nothing, ...) is non-comparable --> not usable as primary key';

CREATE TABLE tab
(
    m1 Map(String, AggregateFunction(sum, UInt32))
)
ENGINE = MergeTree()
ORDER BY m1; -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE tab
(
    m3 Map(Nothing, String)
)
ENGINE = MergeTree()
ORDER BY tuple();

-- INSERT INTO tab VALUES (map('', 'd')); -- { serverError NOT_IMPLEMENTED } -- The client can't serialize the data and fails. The query
-- doesn't reach the server and we can't check via 'serverError' :-/
DROP TABLE tab;

CREATE TABLE tab
(
    m1 Map(Float32, String),
    m2 Map(LowCardinality(String), String)
)
ENGINE = MergeTree()
ORDER BY (m1, m2);

INSERT INTO tab;

INSERT INTO tab;

-- Test merge
OPTIMIZE TABLE tab FINAL;

SELECT *
FROM tab
ORDER BY
    m1 ASC,
    m2 ASC;

CREATE TABLE tab
(
    m1 Map(Float32, String),
    m2 Map(LowCardinality(String), String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab;

ALTER TABLE tab UPDATE m1 = map(3., 'aaa') WHERE m1 = map(2., 'aa');