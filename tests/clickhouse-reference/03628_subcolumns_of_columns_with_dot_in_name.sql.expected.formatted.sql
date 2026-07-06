DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    `my.json` JSON
)
ENGINE = Memory();

INSERT INTO test SELECT '{"a" : 42}';

SELECT my.json.a
FROM test
SETTINGS enable_analyzer = '1';

SELECT `my.json`.a
FROM test
SETTINGS enable_analyzer = '1';

SELECT my.json.a
FROM test
SETTINGS enable_analyzer = '0';

SELECT `my.json`.a
FROM test
SETTINGS enable_analyzer = '0';

DROP TABLE test;

SELECT `t.t`.a
FROM format(JSONEachRow, '`t.t` Tuple(a UInt32)', '{"t.t" : {"a" : 42}}');

CREATE TABLE test
(
    `my.json` JSON(a UInt32),
    a1 UInt32 MATERIALIZED my.json.a,
    a2 UInt32 DEFAULT my.json.a,
    b1 UInt32 MATERIALIZED my.json.b,
    b2 UInt32 DEFAULT my.json.b,
    INDEX idx1 my.json.a TYPE minmax() GRANULARITY 1,
    INDEX idx2 my.json.b::Int64 TYPE minmax() GRANULARITY 1,
    PROJECTION prj1 (SELECT my.json, my.json.a, my.json.b ORDER BY my.json.a, my.json.b::Int32)
)
ENGINE = MergeTree()
ORDER BY (my.json.a, my.json.b::Int32, my.json.a + 42, my.json.b::Int32 + 42);

INSERT INTO test (my.json) SELECT '{"a" : 42, "b" : 42}';

SELECT *
FROM test;

SELECT *
FROM test
ORDER BY my.json.a ASC;

SELECT *
FROM test
ORDER BY my.json.b::Int32 ASC;

INSERT INTO test (my.json) SELECT '{"a" : 43, "b" : 43}';

OPTIMIZE TABLE test FINAL;

ALTER TABLE test MODIFY COLUMN `my.json` JSON(a UInt32, b UInt32); -- {serverError ALTER_OF_COLUMN_IS_FORBIDDEN}

ALTER TABLE test UPDATE `my.json` = '{}' WHERE 1; -- {serverError CANNOT_UPDATE_COLUMN}

CREATE TABLE test
(
    `my.tuple` Tuple(a UInt32),
    a1 UInt32 MATERIALIZED my.tuple.a,
    a2 UInt32 DEFAULT my.tuple.a,
    INDEX idx1 my.tuple.a TYPE minmax() GRANULARITY 1,
    PROJECTION prj1 (SELECT my.tuple, my.tuple.a ORDER BY my.tuple.a)
)
ENGINE = MergeTree()
ORDER BY (my.tuple.a, my.tuple.a + 42);

INSERT INTO test (my.tuple) SELECT tuple(42);

SELECT *
FROM test
ORDER BY my.tuple.a ASC;

INSERT INTO test (my.tuple) SELECT tuple(43);

ALTER TABLE test MODIFY COLUMN `my.tuple` Tuple(a UInt32, b UInt32); -- {serverError ALTER_OF_COLUMN_IS_FORBIDDEN}

ALTER TABLE test UPDATE `my.tuple` = tuple(0, 0) WHERE 1; -- {serverError CANNOT_UPDATE_COLUMN}