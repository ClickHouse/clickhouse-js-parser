SET allow_experimental_variant_type = '1';

SET allow_suspicious_variant_types = '1';

SET session_timezone = 'UTC';

SELECT
    v,
    variantElement(v, 'String')
FROM format(JSONEachRow, 'v Variant(String, UInt64)', '{"v" : null}, {"v" : "string"}, {"v" : 42}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'FixedString(4)')
FROM format(JSONEachRow, 'v Variant(String, FixedString(4))', '{"v" : null}, {"v" : "string"}, {"v" : "abcd"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Bool')
FROM format(JSONEachRow, 'v Variant(String, Bool)', '{"v" : null}, {"v" : "string"}, {"v" : true}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Int8')
FROM format(JSONEachRow, 'v Variant(String, Int8, UInt64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UInt8')
FROM format(JSONEachRow, 'v Variant(String, UInt8, Int64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Int16')
FROM format(JSONEachRow, 'v Variant(String, Int16, Int64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UInt16')
FROM format(JSONEachRow, 'v Variant(String, UInt16, Int64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Int32')
FROM format(JSONEachRow, 'v Variant(String, Int32, Int64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UInt32')
FROM format(JSONEachRow, 'v Variant(String, UInt32, Int64)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Int64')
FROM format(JSONEachRow, 'v Variant(String, Int64, Int128)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000000000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UInt64')
FROM format(JSONEachRow, 'v Variant(String, UInt64, Int128)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}, {"v" : 10000000000000000000000}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Int128')
FROM format(JSONEachRow, 'v Variant(String, Int128, Int256)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UInt128')
FROM format(JSONEachRow, 'v Variant(String, UInt128, Int256)', '{"v" : null}, {"v" : "string"}, {"v" : -1}, {"v" : 0}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Float32')
FROM format(JSONEachRow, 'v Variant(String, Float32)', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Float64')
FROM format(JSONEachRow, 'v Variant(String, Float64)', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Decimal32(6)')
FROM format(JSONEachRow, 'v Variant(String, Decimal32(6))', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}, {"v" : 4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Decimal64(6)')
FROM format(JSONEachRow, 'v Variant(String, Decimal64(6))', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}, {"v" : 4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Decimal128(6)')
FROM format(JSONEachRow, 'v Variant(String, Decimal128(6))', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}, {"v" : 4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Decimal256(6)')
FROM format(JSONEachRow, 'v Variant(String, Decimal256(6))', '{"v" : null}, {"v" : "string"}, {"v" : 42.42}, {"v" : 4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Date')
FROM format(JSONEachRow, 'v Variant(String, Date, DateTime64)', '{"v" : null}, {"v" : "string"}, {"v" : "2020-01-01"}, {"v" : "2020-01-01 00:00:00.999"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Date32')
FROM format(JSONEachRow, 'v Variant(String, Date32, DateTime64)', '{"v" : null}, {"v" : "string"}, {"v" : "1900-01-01"}, {"v" : "2020-01-01 00:00:00.999"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'DateTime')
FROM format(JSONEachRow, 'v Variant(String, DateTime, DateTime64)', '{"v" : null}, {"v" : "string"}, {"v" : "2020-01-01 00:00:00"}, {"v" : "2020-01-01 00:00:00.999"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'DateTime64')
FROM format(JSONEachRow, 'v Variant(String, DateTime64)', '{"v" : null}, {"v" : "string"}, {"v" : "2020-01-01 00:00:00.999"}, {"v" : "2020-01-01 00:00:00.999999999 ABC"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'UUID')
FROM format(JSONEachRow, 'v Variant(String, UUID)', '{"v" : null}, {"v" : "string"}, {"v" : "c8619cca-0caa-445e-ae76-1d4f6e0b3927"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'IPv4')
FROM format(JSONEachRow, 'v Variant(String, IPv4)', '{"v" : null}, {"v" : "string"}, {"v" : "127.0.0.1"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'IPv6')
FROM format(JSONEachRow, 'v Variant(String, IPv6)', '{"v" : null}, {"v" : "string"}, {"v" : "2001:0db8:85a3:0000:0000:8a2e:0370:7334"}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Enum(''a'' = 1)')
FROM format(JSONEachRow, 'v Variant(String, UInt32, Enum(''a'' = 1))', '{"v" : null}, {"v" : "string"}, {"v" : "a"}, {"v" : 1}, {"v" : 2}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Map(String, UInt64)')
FROM format(JSONEachRow, 'v Variant(String, Map(String, UInt64))', '{"v" : null}, {"v" : "string"}, {"v" : {"a" : 42, "b" : 43, "c" : null}}, {"v" : {"c" : 44, "d" : [1,2,3]}}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Tuple(a UInt64, b UInt64)')
FROM format(JSONEachRow, 'v Variant(String, Tuple(a UInt64, b UInt64))', '{"v" : null}, {"v" : "string"}, {"v" : {"a" : 42, "b" : null}}, {"v" : {"a" : 44, "d" : 32}}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Tuple(a UInt64, b UInt64)')
FROM format(JSONEachRow, 'v Variant(String, Tuple(a UInt64, b UInt64))', '{"v" : null}, {"v" : "string"}, {"v" : {"a" : 42, "b" : null}}, {"v" : {"a" : 44, "d" : 32}}')
SETTINGS input_format_json_defaults_for_missing_elements_in_named_tuple = '0';

SELECT
    v,
    variantElement(v, 'Array(UInt64)')
FROM format(JSONEachRow, 'v Variant(String, Array(UInt64))', '{"v" : null}, {"v" : "string"}, {"v" : [1, 2, 3]}, {"v" : [null, null, null]} {"v" : [1, 2, "hello"]}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'LowCardinality(String)')
FROM format(JSONEachRow, 'v Variant(LowCardinality(String), UInt64)', '{"v" : null}, {"v" : "string"}, {"v" : 42}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Array(LowCardinality(Nullable(String)))')
FROM format(JSONEachRow, 'v Variant(Array(LowCardinality(Nullable(String))), UInt64)', '{"v" : null}, {"v" : ["string", null]}, {"v" : 42}')
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'Array(Nullable(String))')
FROM format(JSONEachRow, 'v Variant(String, Array(Nullable(String)))', '{"v" : null}, {"v" : "string"}, {"v" : ["hello", null, "world"]}')
FORMAT JSONEachRow;

SELECT repeat('-', 80)
FORMAT JSONEachRow;

SELECT
    v,
    variantElement(v, 'String')
FROM format(CSV, 'v Variant(String, UInt64)', '\\N\n"string"\nstring\n42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'FixedString(4)')
FROM format(CSV, 'v Variant(String, FixedString(4))', '\\N\n"string"\nstring\n"abcd"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Bool')
FROM format(CSV, 'v Variant(String, Bool)', '\\N\ntruee\ntrue')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Int8')
FROM format(CSV, 'v Variant(String, Int8, UInt64)', '\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UInt8')
FROM format(CSV, 'v Variant(String, UInt8, Int64)', '\\N\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Int16')
FROM format(CSV, 'v Variant(String, Int16, Int64)', '\\N\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UInt16')
FROM format(CSV, 'v Variant(String, UInt16, Int64)', '\\N\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Int32')
FROM format(CSV, 'v Variant(String, Int32, Int64)', '\\N\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UInt32')
FROM format(CSV, 'v Variant(String, UInt32, Int64)', '\\N\n"string"\n-1\n0\n10000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Int64')
FROM format(CSV, 'v Variant(String, Int64, Int128)', '\\N\n"string"\n-1\n0\n10000000000000000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UInt64')
FROM format(CSV, 'v Variant(String, UInt64, Int128)', '\\N\n"string"\n-1\n0\n10000000000000000000000\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Int128')
FROM format(CSV, 'v Variant(String, Int128, Int256)', '\\N\n"string"\n-1\n0\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UInt128')
FROM format(CSV, 'v Variant(String, UInt128, Int256)', '\\N\n"string"\n-1\n0\n42d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Float32')
FROM format(CSV, 'v Variant(String, Float32)', '\\N\n"string"\n42.42\n42.d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Float64')
FROM format(CSV, 'v Variant(String, Float64)', '\\N\n"string"\n42.42\n42.d42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Decimal32(6)')
FROM format(CSV, 'v Variant(String, Decimal32(6))', '\\N\n"string"\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Decimal64(6)')
FROM format(CSV, 'v Variant(String, Decimal64(6))', '\\N\n"string"\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Decimal128(6)')
FROM format(CSV, 'v Variant(String, Decimal128(6))', '\\N\n"string"\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Decimal256(6)')
FROM format(CSV, 'v Variant(String, Decimal256(6))', '\\N\n"string"\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Date')
FROM format(CSV, 'v Variant(String, Date, DateTime64)', '\\N\n"string"\n"2020-01-d1"\n"2020-01-01"\n"2020-01-01 00:00:00.999"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Date32')
FROM format(CSV, 'v Variant(String, Date32, DateTime64)', '\\N\n"string"\n"2020-01-d1"\n"1900-01-01"\n"2020-01-01 00:00:00.999"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'DateTime')
FROM format(CSV, 'v Variant(String, DateTime, DateTime64)', '\\N\n"string"\n"2020-01-d1"\n"2020-01-01 00:00:00"\n"2020-01-01 00:00:00.999"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'DateTime64')
FROM format(CSV, 'v Variant(String, DateTime64)', '\\N\n"string"\n"2020-01-d1"\n"2020-01-01 00:00:00.999"\n"2020-01-01 00:00:00.999999999 ABC"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'UUID')
FROM format(CSV, 'v Variant(String, UUID)', '\\N\n"string"\n"c8619cca-0caa-445e-ae76-1d4f6e0b3927"\nc8619cca-0caa-445e-ae76-1d4f6e0b3927AAA')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'IPv4')
FROM format(CSV, 'v Variant(String, IPv4)', '\\N\n"string"\n"127.0.0.1"\n"127.0.0.1AAA"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'IPv6')
FROM format(CSV, 'v Variant(String, IPv6)', '\\N\n"string"\n"2001:0db8:85a3:0000:0000:8a2e:0370:7334"\n2001:0db8:85a3:0000:0000:8a2e:0370:7334AAA')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Enum(''a'' = 1)')
FROM format(CSV, 'v Variant(String, UInt32, Enum(''a'' = 1))', '\\N\n"string"\n"a"\n1\n2\naa')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Map(String, UInt64)')
FROM format(CSV, 'v Variant(String, Map(String, UInt64))', '\\N\n"string"\n"{''a'' : 42, ''b'' : 43, ''c'' : null}"\n"{''c'' : 44, ''d'' : [1,2,3]}"\n"{''c'' : 44"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Array(UInt64)')
FROM format(CSV, 'v Variant(String, Array(UInt64))', '\\N\n"string"\n"[1, 2, 3]"\n"[null, null, null]"\n"[1, 2, ''hello'']"\n"[1, 2"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'LowCardinality(String)')
FROM format(CSV, 'v Variant(LowCardinality(String), UInt64)', '\\N\n"string"\n42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Array(LowCardinality(Nullable(String)))')
FROM format(CSV, 'v Variant(Array(LowCardinality(Nullable(String))), UInt64, String)', '\\N\n"[''string'', null]"\n"[''string'', nul]"\n42')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'Array(Nullable(String))')
FROM format(CSV, 'v Variant(String, Array(Nullable(String)))', '\\N\n"string"\n"[''hello'', null, ''world'']"\n"[''hello'', nul]"')
FORMAT CSV;

SELECT
    v,
    variantElement(v, 'String')
FROM format(TSV, 'v Variant(String, UInt64)', '\\N\nstring\n42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'FixedString(4)')
FROM format(TSV, 'v Variant(String, FixedString(4))', '\\N\nstring\nabcd')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Bool')
FROM format(TSV, 'v Variant(String, Bool)', '\\N\ntruee\ntrue')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Int8')
FROM format(TSV, 'v Variant(String, Int8, UInt64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UInt8')
FROM format(TSV, 'v Variant(String, UInt8, Int64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Int16')
FROM format(TSV, 'v Variant(String, Int16, Int64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UInt16')
FROM format(TSV, 'v Variant(String, UInt16, Int64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Int32')
FROM format(TSV, 'v Variant(String, Int32, Int64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UInt32')
FROM format(TSV, 'v Variant(String, UInt32, Int64)', '\\N\nstring\n-1\n0\n10000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Int64')
FROM format(TSV, 'v Variant(String, Int64, Int128)', '\\N\nstring\n-1\n0\n10000000000000000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UInt64')
FROM format(TSV, 'v Variant(String, UInt64, Int128)', '\\N\nstring\n-1\n0\n10000000000000000000000\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Int128')
FROM format(TSV, 'v Variant(String, Int128, Int256)', '\\N\nstring\n-1\n0\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UInt128')
FROM format(TSV, 'v Variant(String, UInt128, Int256)', '\\N\nstring\n-1\n0\n42d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Float32')
FROM format(TSV, 'v Variant(String, Float32)', '\\N\nstring\n42.42\n42.d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Float64')
FROM format(TSV, 'v Variant(String, Float64)', '\\N\nstring\n42.42\n42.d42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Decimal32(6)')
FROM format(TSV, 'v Variant(String, Decimal32(6))', '\\N\nstring\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Decimal64(6)')
FROM format(TSV, 'v Variant(String, Decimal64(6))', '\\N\nstring\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Decimal128(6)')
FROM format(TSV, 'v Variant(String, Decimal128(6))', '\\N\nstring\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Decimal256(6)')
FROM format(TSV, 'v Variant(String, Decimal256(6))', '\\N\nstring\n42.42\n42d42\n4242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242.424242424242424242')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Date')
FROM format(TSV, 'v Variant(String, Date, DateTime64)', '\\N\nstring\n2020-01-d1\n2020-01-01\n2020-01-01 00:00:00.999')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Date32')
FROM format(TSV, 'v Variant(String, Date32, DateTime64)', '\\N\nstring\n2020-01-d1\n1900-01-01\n2020-01-01 00:00:00.999')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'DateTime')
FROM format(TSV, 'v Variant(String, DateTime, DateTime64)', '\\N\nstring\n2020-01-d1\n2020-01-01 00:00:00\n2020-01-01 00:00:00.999')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'DateTime64')
FROM format(TSV, 'v Variant(String, DateTime64)', '\\N\nstring\n2020-01-d1\n2020-01-01 00:00:00.999\n2020-01-01 00:00:00.999999999 ABC')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'UUID')
FROM format(TSV, 'v Variant(String, UUID)', '\\N\nstring\nc8619cca-0caa-445e-ae76-1d4f6e0b3927\nc8619cca-0caa-445e-ae76-1d4f6e0b3927AAA')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'IPv4')
FROM format(TSV, 'v Variant(String, IPv4)', '\\N\nstring\n127.0.0.1\n127.0.0.1AAA')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'IPv6')
FROM format(TSV, 'v Variant(String, IPv6)', '\\N\nstring\n2001:0db8:85a3:0000:0000:8a2e:0370:7334\n2001:0db8:85a3:0000:0000:8a2e:0370:7334AAA')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Enum(''a'' = 1)')
FROM format(TSV, 'v Variant(String, UInt32, Enum(''a'' = 1))', '\\N\nstring\na\n1\n2\naa')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Map(String, UInt64)')
FROM format(TSV, 'v Variant(String, Map(String, UInt64))', '\\N\nstring\n{''a'' : 42, ''b'' : 43, ''c'' : null}\n{''c'' : 44, ''d'' : [1,2,3]}\n{''c'' : 44')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Array(UInt64)')
FROM format(TSV, 'v Variant(String, Array(UInt64))', '\\N\nstring\n[1, 2, 3]\n[null, null, null]\n[1, 2, ''hello'']\n[1, 2')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'LowCardinality(String)')
FROM format(TSV, 'v Variant(LowCardinality(String), UInt64)', '\\N\nstring\n42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Array(LowCardinality(Nullable(String)))')
FROM format(TSV, 'v Variant(Array(LowCardinality(Nullable(String))), UInt64, String)', '\\N\n[''string'', null]\n[''string'', nul]\n42')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'Array(Nullable(String))')
FROM format(TSV, 'v Variant(String, Array(Nullable(String)))', '\\N\nstring\n[''hello'', null, ''world'']\n[''hello'', nul]')
FORMAT TSV;

SELECT
    v,
    variantElement(v, 'String')
FROM format(Values, 'v Variant(String, UInt64)', '(NULL), (''string''), (42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'FixedString(4)')
FROM format(Values, 'v Variant(String, FixedString(4))', '(NULL), (''string''), (''abcd'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Bool')
FROM format(Values, 'v Variant(String, Bool)', '(NULL), (true)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Int8')
FROM format(Values, 'v Variant(String, Int8, UInt64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UInt8')
FROM format(Values, 'v Variant(String, UInt8, Int64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Int16')
FROM format(Values, 'v Variant(String, Int16, Int64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UInt16')
FROM format(Values, 'v Variant(String, UInt16, Int64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Int32')
FROM format(Values, 'v Variant(String, Int32, Int64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UInt32')
FROM format(Values, 'v Variant(String, UInt32, Int64)', '(NULL), (''string''), (-1), (0), (10000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Int64')
FROM format(Values, 'v Variant(String, Int64, Int128)', '(NULL), (''string''), (-1), (0), (10000000000000000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UInt64')
FROM format(Values, 'v Variant(String, UInt64, Int128)', '(NULL), (''string''), (-1), (0), (10000000000000000000000)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Int128')
FROM format(Values, 'v Variant(String, Int128, Int256)', '(NULL), (''string''), (-1), (0)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UInt128')
FROM format(Values, 'v Variant(String, UInt128, Int256)', '(NULL), (''string''), (-1), (0)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Float32')
FROM format(Values, 'v Variant(String, Float32)', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Float64')
FROM format(Values, 'v Variant(String, Float64)', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Decimal32(6)')
FROM format(Values, 'v Variant(String, Decimal32(6))', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Decimal64(6)')
FROM format(Values, 'v Variant(String, Decimal64(6))', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Decimal128(6)')
FROM format(Values, 'v Variant(String, Decimal128(6))', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Decimal256(6)')
FROM format(Values, 'v Variant(String, Decimal256(6))', '(NULL), (''string''), (42.42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Date')
FROM format(Values, 'v Variant(String, Date, DateTime64)', '(NULL), (''string''), (''2020-01-d1''), (''2020-01-01''), (''2020-01-01 00:00:00.999'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Date32')
FROM format(Values, 'v Variant(String, Date32, DateTime64)', '(NULL), (''string''), (''2020-01-d1''), (''1900-01-01''), (''2020-01-01 00:00:00.999'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'DateTime')
FROM format(Values, 'v Variant(String, DateTime, DateTime64)', '(NULL), (''string''), (''2020-01-d1''), (''2020-01-01 00:00:00''), (''2020-01-01 00:00:00.999'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'DateTime64')
FROM format(Values, 'v Variant(String, DateTime64)', '(NULL), (''string''), (''2020-01-d1''), (''2020-01-01 00:00:00.999''), (''2020-01-01 00:00:00.999999999 ABC'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'UUID')
FROM format(Values, 'v Variant(String, UUID)', '(NULL), (''string''), (''c8619cca-0caa-445e-ae76-1d4f6e0b3927''), (''c8619cca-0caa-445e-ae76-1d4f6e0b3927AAA'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'IPv4')
FROM format(Values, 'v Variant(String, IPv4)', '(NULL), (''string''), (''127.0.0.1''), (''127.0.0.1AAA'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'IPv6')
FROM format(Values, 'v Variant(String, IPv6)', '(NULL), (''string''), (''2001:0db8:85a3:0000:0000:8a2e:0370:7334''), (''2001:0db8:85a3:0000:0000:8a2e:0370:7334AAA'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Enum(''a'' = 1)')
FROM format(Values, 'v Variant(String, UInt32, Enum(''a'' = 1))', '(NULL), (''string''), (''a''), (1), (2), (''aa'')')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Map(String, UInt64)')
FROM format(Values, 'v Variant(String, Map(String, UInt64))', '(NULL), (''string''), ({''a'' : 42, ''b'' : 43, ''c'' : null})')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Array(UInt64)')
FROM format(Values, 'v Variant(String, Array(UInt64))', '(NULL), (''string''), ([1, 2, 3]), ([null, null, null])')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'LowCardinality(String)')
FROM format(Values, 'v Variant(LowCardinality(String), UInt64)', '(NULL), (''string''), (42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Array(LowCardinality(Nullable(String)))')
FROM format(Values, 'v Variant(Array(LowCardinality(Nullable(String))), UInt64, String)', '(NULL), ([''string'', null]), (42)')
FORMAT Values;

SELECT
    v,
    variantElement(v, 'Array(Nullable(String))')
FROM format(Values, 'v Variant(String, Array(Nullable(String)))', '(NULL), (''string''), ([''hello'', null, ''world''])')
FORMAT Values;