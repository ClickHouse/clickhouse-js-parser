-- { echoOn }
SELECT xxHash32(NULL);

SELECT xxHash64(NULL);

SELECT xxHash64([]);

SELECT xxHash64([NULL]);

SELECT xxHash64([NULL, NULL]);

SELECT xxHash64([NULL::Nullable(Int64)]);

SELECT xxHash64([NULL::Nullable(String)]);

SELECT xxHash64(tuple());

SELECT xxHash64(tuple(NULL));

SELECT xxHash64(tuple(NULL, NULL));

SELECT xxHash64(tuple(NULL::Nullable(Int64)));

SELECT xxHash64(tuple(NULL::Nullable(String)));

SELECT xxHash32(materialize(NULL));

SELECT xxHash64(materialize(NULL));

SELECT xxHash64(materialize([]));

SELECT xxHash64(materialize([NULL]));

SELECT xxHash64(materialize([NULL, NULL]));

SELECT xxHash64(materialize([NULL::Nullable(Int64)]));

SELECT xxHash64(materialize([NULL::Nullable(String)]));

SELECT xxHash64(materialize(tuple()));

SELECT xxHash64(materialize(tuple(NULL)));

SELECT xxHash64(materialize(tuple(NULL, NULL)));

SELECT xxHash64(materialize(tuple(NULL::Nullable(Int64))));

SELECT xxHash64(materialize(tuple(NULL::Nullable(String))));

CREATE TABLE test_hash_on_null
(
    a Array(Nullable(Int64))
)
ENGINE = Memory();

INSERT INTO test_hash_on_null;

SELECT xxHash32(a)
FROM test_hash_on_null;

SELECT cityHash64([1]);

SELECT cityHash64([toNullable(1)]);

SELECT cityHash64('hi');

SELECT cityHash64(tuple('hi'));

SELECT cityHash64(tuple(toNullable('hi')));

SELECT cityHash64(tuple(toLowCardinality(toNullable('hi'))));

SELECT cityHash64(materialize(tuple(toLowCardinality(toNullable('hi')))));

CREATE TABLE test_mix_null
(
    a Nullable(Int64)
)
ENGINE = Memory();

INSERT INTO test_mix_null;

SELECT
    a,
    xxHash32(a),
    xxHash32(tuple(a))
FROM test_mix_null;

CREATE TABLE t
(
    a Array(Tuple(x Nullable(Int64), y Map(Int64, Nullable(String)), z LowCardinality(Nullable(FixedString(16)))))
)
ENGINE = Memory();

INSERT INTO t;

SELECT reinterpret(sipHash128(tuple(*)), 'UInt128')
FROM t;

SELECT cityHash64(tuple(*))
FROM t;

SELECT cityHash64(*)
FROM t;

SELECT cityHash64(a.x)
FROM t;

SELECT cityHash64(a.y)
FROM t;

SELECT cityHash64(a.z)
FROM t;

--- Keyed.
SELECT sipHash64Keyed(materialize((CAST('1' AS UInt64), CAST('2' AS UInt64))), NULL)
FROM numbers(2);

SELECT sipHash64Keyed((CAST('1' AS UInt64), CAST('2' AS UInt64)), tuple(NULL))
FROM numbers(2);

SELECT sipHash64Keyed(materialize((CAST('1' AS UInt64), CAST('2' AS UInt64))), tuple(NULL))
FROM numbers(2);

SELECT sipHash64Keyed((CAST('1' AS UInt64), number), tuple(NULL))
FROM numbers(3);

-- Make sure all types are allowed.
SELECT sum(ignore(cityHash64(tuple(*))))
FROM (
        SELECT *
        FROM generateRandom()
        LIMIT 100
    );