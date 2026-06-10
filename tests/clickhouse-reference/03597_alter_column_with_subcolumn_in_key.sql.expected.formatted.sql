DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt32,
    t Tuple(a UInt32)
)
ENGINE = MergeTree()
ORDER BY t.a;

INSERT INTO test SELECT
    1,
    tuple(1);

ALTER TABLE test UPDATE t = tuple(2) WHERE 1; -- {serverError CANNOT_UPDATE_COLUMN}

ALTER TABLE test MODIFY COLUMN t Tuple(a String); -- {serverError ALTER_OF_COLUMN_IS_FORBIDDEN}

DROP TABLE test;

CREATE TABLE test
(
    id UInt32,
    json JSON
)
ENGINE = MergeTree()
ORDER BY json.a::Int64;

INSERT INTO test SELECT
    1,
    '{"a" : 42}';

ALTER TABLE test UPDATE json = '{}' WHERE 1; -- {serverError CANNOT_UPDATE_COLUMN}

ALTER TABLE test MODIFY COLUMN json JSON(a String); -- {serverError ALTER_OF_COLUMN_IS_FORBIDDEN}