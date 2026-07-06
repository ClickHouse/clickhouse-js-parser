-- Tags: no-fasttest, long
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
FROM numbers(5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number))
FROM numbers(5, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number)))
FROM numbers(10, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('b.b.d', number::UInt32, 'b.b.e', 'str_' || toString(number)))
FROM numbers(15, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number)))
FROM numbers(20, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number), 'b.b._' || toString(number), number::UInt32))
FROM numbers(25, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', range(number % 1)::Array(UInt32), 'a.b.e', 'str_' || toString(number), 'd.a', number::UInt32, 'd.c', toDate(number)))
FROM numbers(30, 5);

INSERT INTO test SELECT
    number,
    toJSONString(map('a.b.c', number, 'a.b.d', toDateTime(number), 'a.b.e', 'str_' || toString(number), 'd.a', range(number % 5 + 1)::Array(UInt32), 'd.b', number::UInt32))
FROM numbers(35, 5);

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
    json.b.b._25,
    json.b.b._25.:Int64,
    json.b.b._25.:UUID,
    json.b.b._26,
    json.b.b._26.:Int64,
    json.b.b._26.:UUID,
    json.b.b._27,
    json.b.b._27.:Int64,
    json.b.b._27.:UUID,
    json.b.b._28,
    json.b.b._28.:Int64,
    json.b.b._28.:UUID,
    json.b.b._29,
    json.b.b._29.:Int64,
    json.b.b._29.:UUID,
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
FORMAT JSONColumns;

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
    json.b.b._25,
    json.b.b._25.:Int64,
    json.b.b._25.:UUID,
    json.b.b._26,
    json.b.b._26.:Int64,
    json.b.b._26.:UUID,
    json.b.b._27,
    json.b.b._27.:Int64,
    json.b.b._27.:UUID,
    json.b.b._28,
    json.b.b._28.:Int64,
    json.b.b._28.:UUID,
    json.b.b._29,
    json.b.b._29.:Int64,
    json.b.b._29.:UUID,
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
FORMAT JSONColumns;

SELECT json.non.existing.path
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.non.existing.path,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.non.existing.path
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.non.existing.path,
    json.non.existing.path.:Int64
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT json.a.b.c
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT json.b.b.e
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

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
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.d.a
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e,
    json.d.a
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

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
FORMAT JSONColumns;

SELECT
    json.b.b.e,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.b.b.e.:String,
    json.b.b.e.:Date,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

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
FORMAT JSONColumns;

SELECT
    json,
    json.b.b.e,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

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
FORMAT JSONColumns;

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
FORMAT JSONColumns;

SELECT
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.d.a,
    json.d.b
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.d.b.:Int64,
    json.d.b.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

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
FORMAT JSONColumns;

SELECT
    json.d.a,
    json.b.b._26
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._26.:Int64,
    json.b.b._26.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._26.:Int64,
    json.b.b,
    json.b.b._26.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.d.a,
    json.b.b._26
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._26.:Int64,
    json.b.b._26.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.d.a,
    json.d.a.:`Array(Nullable(Int64))`,
    json.d.a.:Date,
    json.b.b._26.:Int64,
    json.b.b,
    json.b.b._26.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.^a,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.^a,
    json.a.b.c
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.^a,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.^a,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json.^a,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.^a,
    json.a.b.d
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.^a,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

SELECT
    json,
    json.^a,
    json.a.b.d,
    json.a.b.d.:Int64,
    json.a.b.d.:Date
FROM test
ORDER BY id ASC
FORMAT JSONColumns;

DROP TABLE test;