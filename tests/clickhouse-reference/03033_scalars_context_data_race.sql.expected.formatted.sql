DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test_tmp;

DROP TABLE IF EXISTS dst;

DROP TABLE IF EXISTS view;

CREATE TABLE test
(
    address FixedString(20),
    deployer FixedString(20),
    block_number UInt256,
    block_hash FixedString(32),
    block_timestamp DateTime('UTC'),
    insertion_time DateTime('UTC')
)
ENGINE = MergeTree()
ORDER BY address
SETTINGS index_granularity = '8192';

CREATE TABLE test_tmp AS test;

CREATE TABLE dst
(
    block_timestamp AggregateFunction(max, Nullable(DateTime('UTC'))),
    block_hash AggregateFunction(argMax, Nullable(FixedString(32)), DateTime('UTC')),
    block_number AggregateFunction(argMax, Nullable(UInt256), DateTime('UTC')),
    deployer AggregateFunction(argMax, Nullable(FixedString(20)), DateTime('UTC')),
    address FixedString(20),
    name AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    symbol AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    decimals AggregateFunction(argMax, Nullable(UInt8), DateTime('UTC')),
    is_proxy AggregateFunction(argMax, Nullable(Bool), DateTime('UTC')),
    blacklist_flags AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    whitelist_flags AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    detected_standards AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    amended_type AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    comment AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    _sources AggregateFunction(groupUniqArray, String),
    _updated_at AggregateFunction(max, DateTime('UTC')),
    _active AggregateFunction(argMax, Bool, DateTime('UTC'))
)
ENGINE = MergeTree()
ORDER BY address
SETTINGS index_granularity = '8192';

CREATE MATERIALIZED VIEW view
TO dst
(
    block_timestamp AggregateFunction(max, Nullable(DateTime('UTC'))),
    block_hash AggregateFunction(argMax, Nullable(FixedString(32)), DateTime('UTC')),
    block_number AggregateFunction(argMax, Nullable(UInt256), DateTime('UTC')),
    deployer AggregateFunction(argMax, Nullable(FixedString(20)), DateTime('UTC')),
    address FixedString(20),
    name AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    symbol AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    decimals AggregateFunction(argMax, Nullable(UInt8), DateTime('UTC')),
    is_proxy AggregateFunction(argMax, Nullable(Bool), DateTime('UTC')),
    blacklist_flags AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    whitelist_flags AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    detected_standards AggregateFunction(argMax, Array(Nullable(String)), DateTime('UTC')),
    amended_type AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    comment AggregateFunction(argMax, Nullable(String), DateTime('UTC')),
    _sources AggregateFunction(groupUniqArray, String),
    _updated_at AggregateFunction(max, DateTime('UTC')),
    _active AggregateFunction(argMax, Bool, DateTime('UTC'))
)
AS
WITH (
        SELECT toDateTime('1970-01-01 00:00:00')
    ) AS default_timestamp

SELECT
    maxState(CAST(block_timestamp AS Nullable(DateTime('UTC')))) AS block_timestamp,
    argMaxState(CAST(block_hash AS Nullable(FixedString(32))), insertion_time) AS block_hash,
    argMaxState(CAST(block_number AS Nullable(UInt256)), insertion_time) AS block_number,
    argMaxState(CAST(deployer AS Nullable(FixedString(20))), insertion_time) AS deployer,
    address,
    argMaxState(CAST(NULL AS Nullable(String)), CAST(default_timestamp AS DateTime('UTC'))) AS name,
    argMaxState(CAST(NULL AS Nullable(String)), CAST(default_timestamp AS DateTime('UTC'))) AS symbol,
    argMaxState(CAST(NULL AS Nullable(UInt8)), CAST(default_timestamp AS DateTime('UTC'))) AS decimals,
    argMaxState(CAST(true AS Nullable(Boolean)), insertion_time) AS is_proxy,
    argMaxState(CAST('[]' AS Array(Nullable(String))), CAST(default_timestamp AS DateTime('UTC'))) AS blacklist_flags,
    argMaxState(CAST('[]' AS Array(Nullable(String))), CAST(default_timestamp AS DateTime('UTC'))) AS whitelist_flags,
    argMaxState(CAST('[]' AS Array(Nullable(String))), CAST(default_timestamp AS DateTime('UTC'))) AS detected_standards,
    argMaxState(CAST(NULL AS Nullable(String)), CAST(default_timestamp AS DateTime('UTC'))) AS amended_type,
    argMaxState(CAST(NULL AS Nullable(String)), CAST(default_timestamp AS DateTime('UTC'))) AS comment,
    groupUniqArrayState('tokens_proxy_deployments') AS _sources,
    maxState(insertion_time) AS _updated_at,
    argMaxState(true, CAST(default_timestamp AS DateTime('UTC'))) AS _active
FROM test
WHERE insertion_time > toDateTime('2024-03-14 11:38:09')
GROUP BY address;

SET max_insert_threads = '4';

INSERT INTO test_tmp SELECT *
FROM generateRandom()
LIMIT 24;

INSERT INTO test_tmp SELECT *
FROM generateRandom()
LIMIT 25;

INSERT INTO test_tmp SELECT *
FROM generateRandom()
LIMIT 26;

INSERT INTO test_tmp SELECT *
FROM generateRandom()
LIMIT 30;

INSERT INTO test (address, deployer, block_number, block_hash, block_timestamp, insertion_time) SELECT *
FROM test_tmp;

SELECT count()
FROM test;

DROP TABLE test;

DROP TABLE test_tmp;

DROP TABLE dst;

DROP TABLE view;