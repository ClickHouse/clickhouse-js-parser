SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    t Tuple(a UInt32),
    json JSON(b UInt32),
    a UInt32 DEFAULT t.a,
    b UInt32 DEFAULT json.b,
    c UInt32 DEFAULT json.c
)
ENGINE = Memory();

INSERT INTO test (t, json) SELECT
    tuple(42),
    '{"b" : 42, "c" : 42}';

SELECT *
FROM test;

DROP TABLE test;

CREATE TABLE test
(
    t Tuple(a UInt32),
    json JSON(b UInt32),
    a UInt32 MATERIALIZED t.a,
    b UInt32 MATERIALIZED json.b,
    c UInt32 MATERIALIZED json.c
)
ENGINE = Memory();

SELECT
    *,
    a,
    b,
    c
FROM test;

SELECT *
FROM format(JSONEachRow, 't Tuple(a UInt32), json JSON(b UInt32), a UInt32 default t.a, b UInt32 default json.b, c UInt32 default json.c', '{"t" : {"a" : 42}, "json" : {"b" : 42, "c" : 42}}');