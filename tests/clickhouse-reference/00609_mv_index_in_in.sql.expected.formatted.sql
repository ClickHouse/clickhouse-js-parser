-- Tags: no-ordinary-database, no-parallel
DROP TABLE IF EXISTS test_00609;

DROP TABLE IF EXISTS test_mv_00609;

CREATE TABLE test_00609
(
    a Int8
)
ENGINE = Memory();

INSERT INTO test_00609;

SET database_replicated_allow_explicit_uuid = '3';

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE MATERIALIZED VIEW test_mv_00609 UUID '00000609-1000-4000-8000-000000000001'
ENGINE = MergeTree(date, a, 8192)
POPULATE
AS
SELECT
    a,
    toDate('2000-01-01') AS date
FROM test_00609;

SELECT *
FROM test_mv_00609; -- OK

SELECT *
FROM test_mv_00609
WHERE a IN (
        SELECT a
        FROM test_mv_00609
    ); -- EMPTY (bug)

SELECT *
FROM `.inner_id.00000609-1000-4000-8000-000000000001`
WHERE a IN (
        SELECT a
        FROM test_mv_00609
    ); -- OK

DROP TABLE test_00609;

DROP TABLE test_mv_00609;