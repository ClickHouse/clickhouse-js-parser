DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    t Tuple(a UInt32),
    a UInt32 MATERIALIZED t.a
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT tuple(1);

SELECT
    t,
    a
FROM test;

ALTER TABLE test UPDATE t = tuple(2) WHERE 1 SETTINGS mutations_sync = '1';

ALTER TABLE test UPDATE t = tuple(3) WHERE 1 SETTINGS mutations_sync = '1';

DROP TABLE test;

CREATE TABLE test
(
    t Tuple(a UInt32),
    a UInt32 MATERIALIZED t.a + 42
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE test
(
    t Tuple(a UInt32),
    a UInt32 MATERIALIZED t.a
)
ENGINE = MergeTree()
ORDER BY a;

CREATE TABLE test
(
    json JSON,
    a UInt32 MATERIALIZED json.a::UInt32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT '{"a" : 1}';

SELECT
    json,
    a
FROM test;

ALTER TABLE test UPDATE json = '{"a" : 2}' WHERE 1 SETTINGS mutations_sync = '1';

ALTER TABLE test UPDATE json = '{"a" : 3}' WHERE 1 SETTINGS mutations_sync = '1';

CREATE TABLE test
(
    json JSON,
    a UInt32 MATERIALIZED json.a::UInt32 + 42
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE test
(
    json JSON,
    a UInt32 MATERIALIZED json.a::UInt32
)
ENGINE = MergeTree()
ORDER BY a;