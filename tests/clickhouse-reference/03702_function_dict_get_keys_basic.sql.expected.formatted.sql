DROP DICTIONARY IF EXISTS dict_neg;

DROP TABLE IF EXISTS dict_src_neg;

CREATE TABLE dict_src_neg
(
    id UInt64,
    u64 UInt64,
    i32n Nullable(Int32)
)
ENGINE = Memory();

INSERT INTO dict_src_neg;

CREATE DICTIONARY dict_neg
(
    id UInt64,
    u64 UInt64,
    i32n Nullable(Int32)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src_neg'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys(toString(number), 'u64', toUInt64(7))
FROM numbers(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT dictGetKeys('dict_neg', toString(number), toUInt64(7))
FROM numbers(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT dictGetKeys('dict_neg', 'no_such_attr', toUInt64(7)); -- { serverError ILLEGAL_COLUMN }

SELECT dictGetKeys('dict_neg', 'u64'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT dictGetKeys('dict_neg', 'u64', toUInt64(7), 1); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT dictGetKeys('dict_neg', 'i32n', tuple(number))
FROM numbers(3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT dictGetKeys('non_a_dict_name', 'i32n', tuple(number))
FROM numbers(3); -- { serverError BAD_ARGUMENTS }

SELECT dictGetKeys('dict_neg', 'not_a_attr_col', tuple(number))
FROM numbers(3); -- { serverError ILLEGAL_COLUMN }

DROP DICTIONARY IF EXISTS dict_simple_kv;

DROP TABLE IF EXISTS dict_src_simple_kv;

CREATE TABLE dict_src_simple_kv
(
    id UInt64,
    attr Int32
)
ENGINE = Memory();

INSERT INTO dict_src_simple_kv;

CREATE DICTIONARY dict_simple_kv
(
    id UInt64,
    attr Int32
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src_simple_kv'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys('dict_simple_kv', 'attr', toUInt32(10));

SELECT toTypeName(dictGetKeys('dict_simple_kv', 'attr', toUInt32(10)));

DROP DICTIONARY IF EXISTS dict_complex2_kv;

DROP TABLE IF EXISTS dict_src_complex2_kv;

CREATE TABLE dict_src_complex2_kv
(
    k1 UInt64,
    k2 String,
    attr Int32
)
ENGINE = Memory();

INSERT INTO dict_src_complex2_kv;

CREATE DICTIONARY dict_complex2_kv
(
    k1 UInt64,
    k2 String,
    attr Int32
)
PRIMARY KEY k1, k2
SOURCE(clickhouse(TABLE 'dict_src_complex2_kv'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT dictGetKeys('dict_complex2_kv', 'attr', 10);

SELECT toTypeName(dictGetKeys('dict_complex2_kv', 'attr', 10));

DROP DICTIONARY IF EXISTS dict_complex1_kv;

DROP TABLE IF EXISTS dict_src_complex1_kv;

CREATE TABLE dict_src_complex1_kv
(
    k1 UInt64,
    attr Int32
)
ENGINE = Memory();

INSERT INTO dict_src_complex1_kv;

CREATE DICTIONARY dict_complex1_kv
(
    k1 UInt64,
    attr Int32
)
PRIMARY KEY k1
SOURCE(clickhouse(TABLE 'dict_src_complex1_kv'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT dictGetKeys('dict_complex1_kv', 'attr', 1);

SELECT toTypeName(dictGetKeys('dict_complex1_kv', 'attr', 1));

DROP DICTIONARY IF EXISTS dict_complex_wide_kv;

DROP TABLE IF EXISTS dict_src_complex_wide_kv;

CREATE TABLE dict_src_complex_wide_kv
(
    a1 UInt64,
    a2 Int64,
    a3 String,
    a4 Date,
    a5 UUID,
    a6 IPv4,
    a7 IPv6,
    a8 DateTime64(3),
    attr Int32
)
ENGINE = Memory();

INSERT INTO dict_src_complex_wide_kv;

CREATE DICTIONARY dict_complex_wide_kv
(
    a1 UInt64,
    a2 Int64,
    a3 String,
    a4 Date,
    a5 UUID,
    a6 IPv4,
    a7 IPv6,
    a8 DateTime64(3),
    attr Int32
)
PRIMARY KEY a1, a2, a3, a4, a5, a6, a7, a8
SOURCE(clickhouse(TABLE 'dict_src_complex_wide_kv'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT dictGetKeys('dict_complex_wide_kv', 'attr', 10);

SELECT toTypeName(dictGetKeys('dict_complex_wide_kv', 'attr', 10));

DROP DICTIONARY IF EXISTS dict_types;

DROP TABLE IF EXISTS dict_src_types;

CREATE TABLE dict_src_types
(
    id UInt64,
    i8 Int8,
    u8 UInt8,
    i64 Int64,
    u64 UInt64,
    f32 Float32,
    f64 Float64,
    dec32 Decimal32(3),
    dec64 Decimal64(3),
    d Date,
    dt DateTime,
    dt64 DateTime64(3),
    uuid UUID,
    ip4 IPv4,
    ip6 IPv6,
    s String,
    arr_u64 Array(UInt64),
    arr_nested Array(Array(UInt8)),
    n_i32 Nullable(Int32),
    n_str Nullable(String)
)
ENGINE = Memory();

INSERT INTO dict_src_types;

CREATE DICTIONARY dict_types
(
    id UInt64,
    i8 Int8,
    u8 UInt8,
    i64 Int64,
    u64 UInt64,
    f32 Float32,
    f64 Float64,
    dec32 Decimal32(3),
    dec64 Decimal64(3),
    d Date,
    dt DateTime,
    dt64 DateTime64(3),
    uuid UUID,
    ip4 IPv4,
    ip6 IPv6,
    s String,
    arr_u64 Array(UInt64),
    arr_nested Array(Array(UInt8)),
    n_i32 Nullable(Int32),
    n_str Nullable(String)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src_types'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys('dict_types', 'i8', '-128');

SELECT dictGetKeys('dict_types', 'i8', '0');

SELECT dictGetKeys('dict_types', 'i8', '127');

SELECT dictGetKeys('dict_types', 'u64', '0');

SELECT dictGetKeys('dict_types', 'u64', '18446744073709551615');

SELECT dictGetKeys('dict_types', 'f32', '1.5');

SELECT dictGetKeys('dict_types', 'f32', 'inf');

SELECT dictGetKeys('dict_types', 'f32', inf);

SELECT dictGetKeys('dict_types', 'f32', '-inf');

SELECT dictGetKeys('dict_types', 'f64', '42.25');

SELECT dictGetKeys('dict_types', 'f64', 'nan');

SELECT dictGetKeys('dict_types', 'f64', nan);

SELECT dictGetKeys('dict_types', 'arr_u64', []);

SELECT dictGetKeys('dict_types', 'arr_u64', [1, 2]);

SELECT dictGetKeys('dict_types', 'arr_nested', [[1, 2], [3]]);

SELECT dictGetKeys('dict_types', 'arr_u64', '[]');

SELECT dictGetKeys('dict_types', 'arr_u64', '[1,2]');

SELECT dictGetKeys('dict_types', 'arr_nested', '[[1,2],[3]]');

SELECT dictGetKeys('dict_types', 'n_i32', NULL);

SELECT dictGetKeys('dict_types', 'n_i32', 0);

SELECT dictGetKeys('dict_types', 'n_str', NULL);

SELECT dictGetKeys('dict_types', 'n_str', 'x');

SELECT dictGetKeys('dict_types', 'd', '2000-01-02');

SELECT dictGetKeys('dict_types', 'dt', '2000-01-02 03:04:05');

SELECT dictGetKeys('dict_types', 'dt64', toDateTime64('1970-01-01 00:00:00', 3));

SELECT dictGetKeys('dict_types', 'uuid', '01234567-89ab-cdef-0123-456789abcdef');

SELECT dictGetKeys('dict_types', 'ip4', '1.2.3.4');

SELECT dictGetKeys('dict_types', 'ip6', '2001:db8::1');

SELECT dictGetKeys('dict_types', 's', '');

SELECT dictGetKeys('dict_types', 'dec32', '1.234');

SELECT dictGetKeys('dict_types', 'dec64', '42.500');

DROP DICTIONARY IF EXISTS dict_valexpr;

DROP TABLE IF EXISTS dict_src_valexpr;

CREATE TABLE dict_src_valexpr
(
    id UInt64,
    s String,
    i32n Nullable(Int32),
    u64 UInt64
)
ENGINE = Memory();

INSERT INTO dict_src_valexpr;

CREATE DICTIONARY dict_valexpr
(
    id UInt64,
    s String,
    i32n Nullable(Int32),
    u64 UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src_valexpr'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys('dict_valexpr', 's', 'alpha');

SELECT dictGetKeys('dict_valexpr', 's', v)
FROM (
        SELECT arrayJoin(['alpha', 'beta', 'zzz']) AS v
    );

SELECT dictGetKeys('dict_valexpr', 's', CAST('alpha' AS LowCardinality(String)));

SELECT dictGetKeys('dict_valexpr', 's', CAST(v AS LowCardinality(String)))
FROM (
        SELECT arrayJoin(['alpha', 'beta', 'zzz']) AS v
    );

SELECT dictGetKeys('dict_valexpr', 'i32n', CAST(NULL AS Nullable(Int32)));

SELECT dictGetKeys('dict_valexpr', 'i32n', CAST(10 AS Nullable(Int32)));

SELECT dictGetKeys('dict_valexpr', 'i32n', CAST('10' AS Nullable(String)));

SELECT dictGetKeys('dict_valexpr', 'u64', CAST(NULL AS Nullable(Int32))); -- { serverError CANNOT_INSERT_NULL_IN_ORDINARY_COLUMN }

SELECT dictGetKeys('dict_valexpr', 'u64', CAST(-42 AS Nullable(Int32))); -- { serverError CANNOT_CONVERT_TYPE }

SELECT dictGetKeys('dict_valexpr', 'u64', CAST('42' AS Nullable(String)));

SELECT dictGetKeys('dict_valexpr', 'i32n', x)
FROM (
        SELECT arrayJoin([CAST(NULL AS Nullable(Int32)), CAST(10 AS Nullable(Int32)), CAST(NULL AS Nullable(Int32)), CAST(-5 AS Nullable(Int32))]) AS x
    );

SELECT dictGetKeys('dict_valexpr', 'u64', '42');

DROP DICTIONARY IF EXISTS dict_match;

DROP TABLE IF EXISTS dict_src_match;

CREATE TABLE dict_src_match
(
    id UInt64,
    grp String
)
ENGINE = Memory();

INSERT INTO dict_src_match;

CREATE DICTIONARY dict_match
(
    id UInt64,
    grp String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src_match'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys('dict_match', 'grp', 'Z');

SELECT dictGetKeys('dict_match', 'grp', v)
FROM (
        SELECT arrayJoin(['Z', 'Y']) AS v
    );

SELECT dictGetKeys('dict_match', 'grp', v)
FROM (
        SELECT arrayJoin(['B', 'C']) AS v
    );

SELECT dictGetKeys('dict_match', 'grp', 'A');

SELECT dictGetKeys('dict_match', 'grp', v)
FROM (
        SELECT arrayJoin(['A', 'B', 'A']) AS v
    );