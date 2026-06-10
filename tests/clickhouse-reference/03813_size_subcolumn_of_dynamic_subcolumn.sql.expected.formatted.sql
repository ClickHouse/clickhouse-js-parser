DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    ad Array(Array(Dynamic)),
    jd Array(Array(JSON))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT
    [[CAST('[1, 2, 3]' AS Array(UInt64))::Dynamic]],
    [['{"a" : [1, 2, 3], "b" : [{"c" : [[1, 2, 3]]}]}']];

SELECT
    ad.`Array(UInt64)`.size2,
    jd.a.:`Array(Nullable(Int64))`.size2,
    jd.b.:`Array(JSON)`.c.:`Array(Array(Nullable(Int64)))`.size3,
    jd.b.:`Array(JSON)`.c.:`Array(Array(Nullable(Int64)))`.size4
FROM test;

SELECT
    ad.`Array(UInt64)`.size0,
    jd.a.:`Array(Nullable(Int64))`.size0,
    jd.b.:`Array(JSON)`.c.:`Array(Array(Nullable(Int64)))`.size0,
    jd.b.:`Array(JSON)`.c.:`Array(Array(Nullable(Int64)))`.size1
FROM test; -- {serverError UNKNOWN_IDENTIFIER}

DROP TABLE test;