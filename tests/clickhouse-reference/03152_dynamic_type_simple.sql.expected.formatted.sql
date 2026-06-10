SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test_max_types;

CREATE TABLE test_max_types
(
    d Dynamic(max_types = 5)
)
ENGINE = Memory();

INSERT INTO test_max_types;

SELECT
    d,
    dynamicType(d)
FROM test_max_types;

DROP TABLE IF EXISTS test_nested_dynamic;

CREATE TABLE test_nested_dynamic
(
    d1 Dynamic,
    d2 Dynamic(max_types = 2)
)
ENGINE = Memory();

INSERT INTO test_nested_dynamic;

SELECT
    d1,
    dynamicType(d1),
    d2,
    dynamicType(d2)
FROM test_nested_dynamic;

DROP TABLE IF EXISTS test_rapid_schema;

CREATE TABLE test_rapid_schema
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test_rapid_schema;

SELECT
    d,
    dynamicType(d),
    d.Int64,
    d.String,
    d.Date,
    d.Float64,
    d.DateTime,
    d.`Array(Int64)`,
    d.`Array(String)`
FROM test_rapid_schema
FORMAT PrettyCompactMonoBlock;

SELECT finalizeAggregation(CAST(dynamic_state AS AggregateFunction(sum, UInt64)))
FROM (
        SELECT CAST(state AS Dynamic) AS dynamic_state
        FROM (
                SELECT sumState(number) AS state
                FROM numbers(10000)
            )
    );

DROP TABLE test_max_types;

DROP TABLE test_nested_dynamic;

DROP TABLE test_rapid_schema;