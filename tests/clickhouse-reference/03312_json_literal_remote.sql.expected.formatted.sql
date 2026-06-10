-- Tags: no-fasttest
SET enable_json_type = '1';

SET enable_analyzer = '1';

SET output_format_native_write_json_as_string = '0';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

SELECT
    '{"a" : false}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : null}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, 2, 3]}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : {"b" : 42}}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [{"b" : 42}]}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, "str", [1]]}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : false}'::JSON(a Bool) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : null}'::JSON(a Nullable(UInt32)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a Int64) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a UInt64) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a Int128) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a UInt128) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a Int256) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(a UInt256) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(a Float64) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(a Decimal32(2)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(a Decimal64(2)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(a Decimal128(2)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(a Decimal256(2)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : "41b43b2a-46c9-4ff8-a354-621299fd5d52"}'::JSON(a UUID) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : "121.0.0.1"}'::JSON(a IPv4) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : "2001:0db8:85a3:0000:0000:8a2e:0370:7334"}'::JSON(a IPv6) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, 2, 3]}'::JSON(a Array(Int64)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, "str", [1]]}'::JSON(a Tuple(Int64, String, Array(Int64))) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : {"b" : 1, "c" : "str", "d" : [1]}}'::JSON(a Tuple(b Int64, c String, d Array(Int64))) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : {"b" : 1, "c" : 2, "d" : 3}}'::JSON(a Map(String, Int64)) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [{"b" : 42}]}'::JSON(a Array(JSON(b Int64))) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : false}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : null}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, 2, 3]}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : {"b" : 42}}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [{"b" : 42}]}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, "str", [1]]}'::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : false}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : null}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : 42.42}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, 2, 3]}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : {"b" : 42}}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [{"b" : 42}]}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');

SELECT
    '{"a" : [1, "str", [1]]}'::JSON(max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.2', 'system.one');