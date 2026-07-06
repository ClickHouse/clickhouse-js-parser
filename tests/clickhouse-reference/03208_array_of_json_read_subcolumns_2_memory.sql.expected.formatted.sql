-- Tags: no-asan, no-tsan, no-msan, no-flaky-check
-- too slow for sanitizers and flaky check
SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    json JSON(max_dynamic_paths = 8, `a.b` Array(JSON))
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1000000000', min_bytes_for_wide_part = '10000000000';

INSERT INTO test SELECT
    number,
    '{}'
FROM numbers(10000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b', arrayMap((x -> map('b.c.d_' || toString(x), number::UInt32, 'c.d.e', range((number + x) % 5 + 1))), range(number % 5 + 1))))
FROM numbers(10000, 10000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.r', arrayMap((x -> map('b.c.d_' || toString(x), number::UInt32, 'c.d.e', range((number + x) % 5 + 1))), range(number % 5 + 1))))
FROM numbers(20000, 10000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.a1', number, 'a.a2', number, 'a.a3', number, 'a.a4', number, 'a.a5', number, 'a.a6', number, 'a.a7', number, 'a.a8', number, 'a.r', arrayMap((x -> map('b.c.d_' || toString(x), number::UInt32, 'c.d.e', range((number + x) % 5 + 1))), range(number % 5 + 1))))
FROM numbers(30000, 10000);

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(json)) AS paths_with_types
FROM test
ORDER BY paths_with_types ASC;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(arrayJoin(json.a.b))) AS paths_with_types
FROM test
ORDER BY paths_with_types ASC;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(arrayJoin(json.a.r.:`Array(JSON)`))) AS paths_with_types
FROM test
ORDER BY paths_with_types ASC;

SELECT
    json,
    json.a.b,
    json.a.b.c,
    json.a.b.c.d.e,
    json.a.b.b.c.d_0,
    json.a.b.b.c.d_1,
    json.a.b.b.c.d_2,
    json.a.b.b.c.d_3,
    json.a.b.b.c.d_4,
    json.a.r,
    json.a.r.:`Array(JSON)`,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1,
    json.a.r.:`Array(JSON)`.b.c.d_2,
    json.a.r.:`Array(JSON)`.b.c.d_3,
    json.a.r.:`Array(JSON)`.b.c.d_4,
    json.^a,
    json.a.b.^b.c,
    json.a.r.:`Array(JSON)`.^b.c
FROM test
FORMAT Null;

SELECT
    json,
    json.a.b,
    json.a.b.c,
    json.a.b.c.d.e,
    json.a.b.b.c.d_0,
    json.a.b.b.c.d_1,
    json.a.b.b.c.d_2,
    json.a.b.b.c.d_3,
    json.a.b.b.c.d_4,
    json.a.r,
    json.a.r.:`Array(JSON)`,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1,
    json.a.r.:`Array(JSON)`.b.c.d_2,
    json.a.r.:`Array(JSON)`.b.c.d_3,
    json.a.r.:`Array(JSON)`.b.c.d_4,
    json.^a,
    json.a.b.^b.c,
    json.a.r.:`Array(JSON)`.^b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.b,
    json.a.b.c,
    json.a.b.c.d.e,
    json.a.b.b.c.d_0,
    json.a.b.b.c.d_1,
    json.a.b.b.c.d_2,
    json.a.b.b.c.d_3,
    json.a.b.b.c.d_4,
    json.a.r,
    json.a.r.:`Array(JSON)`,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1,
    json.a.r.:`Array(JSON)`.b.c.d_2,
    json.a.r.:`Array(JSON)`.b.c.d_3,
    json.a.r.:`Array(JSON)`.b.c.d_4,
    json.^a,
    json.a.b.^b.c,
    json.a.r.:`Array(JSON)`.^b.c
FROM test
FORMAT Null;

SELECT
    json.a.b,
    json.a.b.c,
    json.a.b.c.d.e,
    json.a.b.b.c.d_0,
    json.a.b.b.c.d_1,
    json.a.b.b.c.d_2,
    json.a.b.b.c.d_3,
    json.a.b.b.c.d_4,
    json.a.r,
    json.a.r.:`Array(JSON)`,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1,
    json.a.r.:`Array(JSON)`.b.c.d_2,
    json.a.r.:`Array(JSON)`.b.c.d_3,
    json.a.r.:`Array(JSON)`.b.c.d_4,
    json.^a,
    json.a.b.^b.c,
    json.a.r.:`Array(JSON)`.^b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE empty(json.a.r.:`Array(JSON)`.c.d.e)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_0)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_1);

SELECT count()
FROM test
WHERE empty(json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_0.:Int64)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_1.:Int64);

SELECT count()
FROM test
WHERE arrayJoin(json.a.r.:`Array(JSON)`.c.d.e) IS NULL
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_0) IS NULL
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_1) IS NULL;

SELECT count()
FROM test
WHERE arrayJoin(json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`) IS NULL
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_0.:Int64) IS NULL
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_1.:Int64) IS NULL;

SELECT
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1
FROM test
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64,
    json.a.r.:`Array(JSON)`.b.c.d_1.:Int64
FROM test
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64,
    json.a.r.:`Array(JSON)`.b.c.d_1.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1
FROM test
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.c.d.e,
    json.a.r.:`Array(JSON)`.b.c.d_0,
    json.a.r.:`Array(JSON)`.b.c.d_1
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64,
    json.a.r.:`Array(JSON)`.b.c.d_1.:Int64
FROM test
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.c.d.e.:`Array(Nullable(Int64))`,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64,
    json.a.r.:`Array(JSON)`.b.c.d_1.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE empty(json.a.r.:`Array(JSON)`.^b)
    AND empty(json.a.r.:`Array(JSON)`.^b.c)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_0);

SELECT count()
FROM test
WHERE empty(json.a.r.:`Array(JSON)`.^b)
    AND empty(json.a.r.:`Array(JSON)`.^b.c)
    AND empty(json.a.r.:`Array(JSON)`.b.c.d_0.:Int64);

SELECT count()
FROM test
WHERE empty(arrayJoin(json.a.r.:`Array(JSON)`.^b))
    AND empty(arrayJoin(json.a.r.:`Array(JSON)`.^b.c))
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_0) IS NULL;

SELECT count()
FROM test
WHERE empty(arrayJoin(json.a.r.:`Array(JSON)`.^b))
    AND empty(arrayJoin(json.a.r.:`Array(JSON)`.^b.c))
    AND arrayJoin(json.a.r.:`Array(JSON)`.b.c.d_0.:Int64) IS NULL;

SELECT
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0
FROM test
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64
FROM test
FORMAT Null;

SELECT
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0
FROM test
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64
FROM test
FORMAT Null;

SELECT
    json.a.r,
    json.a.r.:`Array(JSON)`.^b,
    json.a.r.:`Array(JSON)`.^b.c,
    json.a.r.:`Array(JSON)`.b.c.d_0.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

DROP TABLE test;