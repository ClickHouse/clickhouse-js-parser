-- Tags: long
SET enable_analyzer = '1';

SET mutations_sync = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a UInt32,
    json JSON(a UInt32),
    t Tuple(a UInt32, b UInt32),
    PROJECTION p1 (SELECT json ORDER BY json.a),
    PROJECTION p2 (SELECT t ORDER BY t.a),
    PROJECTION p3 (SELECT json ORDER BY json.c.:`Array(JSON)`.d.:Int64)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO test SELECT
    number,
    toJSONString(map('a', number, 'b', 'str', 'c', [toJSONString(map('d', number::UInt32))::JSON])),
    tuple(number, number)
FROM numbers(100)
SETTINGS
    use_variant_as_common_type = '1',
    output_format_json_quote_64bit_integers = '0';

EXPLAIN indexes = '1'
SELECT json
FROM test
WHERE json.a = 1
SETTINGS enable_parallel_replicas = '0';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT json
                FROM test
                WHERE json.a = 1
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%';

SELECT json
FROM test
WHERE json.a = 1;

EXPLAIN indexes = '1'
SELECT t
FROM test
WHERE t.a = 1
SETTINGS enable_parallel_replicas = '0';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT t
                FROM test
                WHERE t.a = 1
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%';

SELECT t
FROM test
WHERE t.a = 1;

EXPLAIN indexes = '1'
SELECT json
FROM test
WHERE json.c.:`Array(JSON)`.d.:Int64 = [1]
SETTINGS enable_parallel_replicas = '0';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT json
                FROM test
                WHERE json.c.:`Array(JSON)`.d.:Int64 = [1]
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%';

SELECT json
FROM test
WHERE json.c.:`Array(JSON)`.d.:Int64 = [1];

OPTIMIZE TABLE test FINAL;

DROP TABLE test;

SELECT '------------------------------------------------------------------';

CREATE TABLE test
(
    a UInt32,
    json JSON(a UInt32),
    t Tuple(a UInt32, b UInt32)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

ALTER TABLE test ADD PROJECTION p1 (SELECT json ORDER BY json.a);

ALTER TABLE test MATERIALIZE PROJECTION p1;

ALTER TABLE test ADD PROJECTION p2 (SELECT t ORDER BY t.a);

ALTER TABLE test MATERIALIZE PROJECTION p2;

ALTER TABLE test ADD PROJECTION p3 (SELECT json ORDER BY json.c.:`Array(JSON)`.d.:Int64);

ALTER TABLE test MATERIALIZE PROJECTION p3;

ALTER TABLE test ADD PROJECTION p (SELECT json.b ORDER BY json.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT t.a ORDER BY json.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT a ORDER BY json.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT t.b ORDER BY t.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT json.a ORDER BY t.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT a ORDER BY t.a); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT json.a ORDER BY json.c.:`Array(JSON)`.d.:Int64); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT t.a ORDER BY json.c.:`Array(JSON)`.d.:Int64); -- {serverError NOT_IMPLEMENTED}

ALTER TABLE test ADD PROJECTION p (SELECT a ORDER BY json.c.:`Array(JSON)`.d.:Int64); -- {serverError NOT_IMPLEMENTED}