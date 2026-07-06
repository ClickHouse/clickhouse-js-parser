-- Tags: no-fasttest, long, no-debug, no-tsan, no-asan, no-msan, no-ubsan
SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET session_timezone = 'UTC';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    json JSON(max_dynamic_paths = 2, `a.b.c` UInt32)
)
ENGINE = Memory();

TRUNCATE TABLE test;

INSERT INTO test SELECT
    number,
    '{}'
FROM numbers(100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number))
FROM numbers(100000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number)))
FROM numbers(200000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('b.b.d', number::UInt32, 'b.b.e', 'str_' || toString(number)))
FROM numbers(300000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number)))
FROM numbers(400000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number), 'b.b._' || toString(number % 5), number::UInt32))
FROM numbers(500000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', range(number % 1)::Array(UInt32), 'a.b.e', 'str_' || toString(number), 'd.a', number::UInt32, 'd.c', toDate(number)))
FROM numbers(600000, 100000);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', toDateTime(number), 'a.b.e', 'str_' || toString(number), 'd.a', range(number % 5 + 1)::Array(UInt32), 'd.b', number::UInt32))
FROM numbers(700000, 100000);

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(json)) AS paths_with_types
FROM test
ORDER BY paths_with_types ASC;

SELECT
    json.non.existing.path,
    json.a.b.c,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:UUID,
    json.a.b.e,
    json.a.b.e.:String,
    json.a.b.e.:UUID,
    json.b.b._0,
    json.b.b._0.:Int64,
    json.b.b._0.:UUID,
    json.b.b._1,
    json.b.b._1.:Int64,
    json.b.b._1.:UUID,
    json.b.b._2,
    json.b.b._2.:Int64,
    json.b.b._2.:UUID,
    json.b.b._3,
    json.b.b._3.:Int64,
    json.b.b._3.:UUID,
    json.b.b._4,
    json.b.b._4.:Int64,
    json.b.b._4.:UUID,
    json.b.b.d,
    json.b.b.d.:Int64,
    json.b.b.d.:UUID,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:UUID,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:UUID,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:UUID,
    json.d.c,
    json.d.c.:Date,
    json.d.c.:UUID,
    json.^n,
    json.^a,
    json.^a.b,
    json.^b,
    json.^d
FROM test
FORMAT Null;

SELECT
    json.non.existing.path,
    json.a.b.c,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:UUID,
    json.a.b.e,
    json.a.b.e.:String,
    json.a.b.e.:UUID,
    json.b.b._0,
    json.b.b._0.:Int64,
    json.b.b._0.:UUID,
    json.b.b._1,
    json.b.b._1.:Int64,
    json.b.b._1.:UUID,
    json.b.b._2,
    json.b.b._2.:Int64,
    json.b.b._2.:UUID,
    json.b.b._3,
    json.b.b._3.:Int64,
    json.b.b._3.:UUID,
    json.b.b._4,
    json.b.b._4.:Int64,
    json.b.b._4.:UUID,
    json.b.b.d,
    json.b.b.d.:Int64,
    json.b.b.d.:UUID,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:UUID,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:UUID,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:UUID,
    json.d.c,
    json.d.c.:Date,
    json.d.c.:UUID,
    json.^n,
    json.^a,
    json.^a.b,
    json.^b,
    json.^d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.non.existing.path,
    json.a.b.c,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:UUID,
    json.a.b.e,
    json.a.b.e.:String,
    json.a.b.e.:UUID,
    json.b.b._0,
    json.b.b._0.:Int64,
    json.b.b._0.:UUID,
    json.b.b._1,
    json.b.b._1.:Int64,
    json.b.b._1.:UUID,
    json.b.b._2,
    json.b.b._2.:Int64,
    json.b.b._2.:UUID,
    json.b.b._3,
    json.b.b._3.:Int64,
    json.b.b._3.:UUID,
    json.b.b._4,
    json.b.b._4.:Int64,
    json.b.b._4.:UUID,
    json.b.b.d,
    json.b.b.d.:Int64,
    json.b.b.d.:UUID,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:UUID,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:UUID,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:UUID,
    json.d.c,
    json.d.c.:Date,
    json.d.c.:UUID,
    json.^n,
    json.^a,
    json.^a.b,
    json.^b,
    json.^d
FROM test
FORMAT Null;

SELECT
    json,
    json.non.existing.path,
    json.a.b.c,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:UUID,
    json.a.b.e,
    json.a.b.e.:String,
    json.a.b.e.:UUID,
    json.b.b._0,
    json.b.b._0.:Int64,
    json.b.b._0.:UUID,
    json.b.b._1,
    json.b.b._1.:Int64,
    json.b.b._1.:UUID,
    json.b.b._2,
    json.b.b._2.:Int64,
    json.b.b._2.:UUID,
    json.b.b._3,
    json.b.b._3.:Int64,
    json.b.b._3.:UUID,
    json.b.b._4,
    json.b.b._4.:Int64,
    json.b.b._4.:UUID,
    json.b.b.d,
    json.b.b.d.:Int64,
    json.b.b.d.:UUID,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:UUID,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:UUID,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:UUID,
    json.d.c,
    json.d.c.:Date,
    json.d.c.:UUID,
    json.^n,
    json.^a,
    json.^a.b,
    json.^b,
    json.^d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.non.existing.path IS NULL;

SELECT count()
FROM test
WHERE json.non.existing.path.:String IS NULL;

SELECT json.non.existing.path
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.non.existing.path,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.non.existing.path
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.non.existing.path,
    json.non.existing.path.:Int64
FROM test
FORMAT Null;

SELECT
    json,
    json.non.existing.path,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.a.b.c = 0;

SELECT json.a.b.c
FROM test
FORMAT Null;

SELECT json.a.b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.a.b.c
FROM test
FORMAT Null;

SELECT
    json,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.b.b.e IS NULL;

SELECT count()
FROM test
WHERE json.b.b.e.:String IS NULL;

SELECT json.b.b.e
FROM test
FORMAT Null;

SELECT json.b.b.e
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
FORMAT Null;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
FORMAT Null;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.b.b.e IS NULL
    AND json.a.b.d IS NULL;

SELECT count()
FROM test
WHERE json.b.b.e.:String IS NULL
    AND json.a.b.d.:Int64 IS NULL;

SELECT
    json.b.b.e,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.b.b.e IS NULL
    AND json.d.a IS NULL;

SELECT count()
FROM test
WHERE json.b.b.e.:String IS NULL
    AND empty(json.d.a.:`Array(Nullable(Int64))`);

SELECT
    json.b.b.e,
    json.d.a
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.d.a
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.b.b.e IS NULL
    AND json.d.a IS NULL
    AND json.d.b IS NULL;

SELECT count()
FROM test
WHERE json.b.b.e.:String IS NULL
    AND empty(json.d.a.:`Array(Nullable(Int64))`)
    AND json.d.b.:Int64 IS NULL;

SELECT
    json.b.b.e,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.d.a IS NULL
    AND json.d.b IS NULL;

SELECT count()
FROM test
WHERE empty(json.d.a.:`Array(Nullable(Int64))`)
    AND json.d.b.:Int64 IS NULL;

SELECT
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE json.d.a IS NULL
    AND json.b.b._1 IS NULL;

SELECT count()
FROM test
WHERE empty(json.d.a.:`Array(Nullable(Int64))`)
    AND json.b.b._1.:Int64 IS NULL;

SELECT
    json.d.a,
    json.b.b._1
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._1.:Int64,
    json.b.b._1.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._1.:Int64,
    json.b.b,
    json.b.b._1.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.b.b._1
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._1.:Int64,
    json.b.b._1.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._1.:Int64,
    json.b.b,
    json.b.b._1.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._1.:Int64,
    json.b.b,
    json.b.b._1.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE empty(json.^a)
    AND json.a.b.c = 0;

SELECT
    json.^a,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.c
FROM test
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT count()
FROM test
WHERE empty(json.^a)
    AND json.a.b.d IS NULL;

SELECT
    json.^a,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.^a,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json.^a,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT Null;

DROP TABLE test;