SET enable_json_type = '1';

SELECT
    '{}'::JSON AS j1,
    '{}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON AS j1,
    '{}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON AS j1,
    '{"a" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON AS j1,
    '{"a" : 2}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON AS j1,
    '{"a" : 0}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON AS j1,
    '{"b" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 1, "b" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 1, "b" : 2}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 1, "b" : 0}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 0, "b" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"a" : 2, "b" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON AS j1,
    '{"b" : 1, "c" : 1}'::JSON AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{}'::JSON(a UInt32) AS j1,
    '{}'::JSON(a UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON(a UInt32) AS j1,
    '{}'::JSON(a UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON(a UInt32) AS j1,
    '{"a" : 1}'::JSON(a UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON(a UInt32) AS j1,
    '{"a" : 0}'::JSON(a UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON(a UInt32) AS j1,
    '{"a" : 2}'::JSON(a UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 1}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 1, "b" : 0}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 1, "b" : 2}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 0, "b" : 1}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32) AS j1,
    '{"a" : 2, "b" : 1}'::JSON(a UInt32, b UInt32) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{}'::JSON(max_dynamic_paths = 2) AS j1,
    '{}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 0, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 2, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 0, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 2, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 0, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 2, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 0}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 0}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 2}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"b" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"b" : 0}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"b" : 2}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 0}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 2}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 0}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 2}'::JSON(max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 0, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 2, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 0, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 2, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 0, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 2, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 0, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 2, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 0, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 2, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 0}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

SELECT
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 1, "f" : 1}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j1,
    '{"a" : 1, "b" : 1, "c" : 1, "d" : 1, "e" : 2}'::JSON(a UInt32, b UInt32, max_dynamic_paths = 2) AS j2,
    j1 < j2,
    j1 = j2,
    j1 > j2;

CREATE TABLE test
(
    json1 JSON(max_dynamic_paths = 2, a UInt32),
    json2 JSON(max_dynamic_paths = 2, a UInt32)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONEachRow;

SELECT
    json1,
    json2,
    json1 = json2,
    json1 != json2,
    json1 < json2,
    json1 > json2
FROM test;

DROP TABLE test;