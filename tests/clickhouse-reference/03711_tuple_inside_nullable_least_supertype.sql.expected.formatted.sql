SET allow_experimental_nullable_tuple_type = '1';

SET use_variant_as_common_type = '0';

SELECT toTypeName([CAST((8, 9) AS Tuple(Int32, Int32)), CAST((2, 5) AS Nullable(Tuple(Int32, Int32)))]);

SELECT toTypeName([(8, 9), CAST((2, 5) AS Nullable(Tuple(Int32, Int32)))]);

SELECT toTypeName([NULL, '3', CAST('3' AS Nullable(String))]);

SELECT toTypeName([NULL, (8, 9), CAST((2, 5) AS Nullable(Tuple(Int32, Int32)))]);

SELECT toTypeName([NULL, (8, 9), CAST((2, 5) AS Tuple(Int32, Int32))]);

CREATE TABLE test_nullable_tuples
(
    id UInt32,
    data Nullable(Tuple(val1 Int32, val2 String, val3 Float64))
)
ENGINE = Memory();

INSERT INTO test_nullable_tuples SELECT
    number AS id,
    if(number % 5 = 0, NULL, (toInt32(number), toString(number), toFloat64(number) / 10)) AS data
FROM numbers(7);

SELECT *
FROM test_nullable_tuples
ORDER BY id ASC;

SELECT toTypeName([CAST((1, 2) AS Tuple(Int8, Int8)), CAST((3, 4) AS Nullable(Tuple(Int32, Int32)))]);

SELECT toTypeName([CAST((1, 2) AS Tuple(UInt32, UInt32)), CAST((3, 4) AS Nullable(Tuple(Int64, Int64)))]);

SELECT toTypeName([CAST(('a', 'b') AS Tuple(String, String)), CAST(('c', 'd') AS Nullable(Tuple(FixedString(1), FixedString(1))))]);

SELECT toTypeName(CAST([(1, 7), CAST(NULL AS Nullable(Tuple(Int8, Int8))), (2, 8)] AS Array(Nullable(Tuple(Int8, Int8)))));

SELECT toTypeName([NULL, NULL, (1, 2), NULL, CAST((3, 4) AS Nullable(Tuple(Int32, Int32)))]);

SELECT toTypeName([CAST((1, 'a') AS Tuple(x Int32, y String)), CAST((2, 'b') AS Nullable(Tuple(x Int32, y String)))]);

SELECT toTypeName([CAST((1, 'a') AS Tuple(x Int32, y String)), CAST((2, 'b') AS Nullable(Tuple(n Int32, m String)))]);

SELECT toTypeName([(3, 'c'), CAST((1, 'a') AS Tuple(x Int32, y String)), CAST((2, 'b') AS Nullable(Tuple(x Int32, y String)))]);

SELECT toTypeName([NULL, CAST((1, 'a') AS Tuple(x Int32, y String))]);

SELECT toTypeName([NULL, CAST(((1, 2), 'a') AS Tuple(Tuple(Int32, Int32), String))]);

SELECT toTypeName([NULL, CAST(((1, 2), 'a') AS Nullable(Tuple(Tuple(Int32, Int32), String)))]);

SELECT toTypeName([NULL, CAST(((1, 2), 'a') AS Tuple(Nullable(Tuple(Int32, Int32)), String))]);

SELECT toTypeName([NULL, CAST((((1, 2), 3), 4) AS Tuple(Tuple(Tuple(Int32, Int32), Int32), Int32)), CAST((((5, 6), 7), 8) AS Nullable(Tuple(Tuple(Tuple(Int32, Int32), Int32), Int32)))]);

SELECT toTypeName([CAST((1, 2) AS Tuple(Int32, Int32)), CAST((3, 4, 5) AS Nullable(Tuple(Int32, Int32, Int32)))]); -- { serverError NO_COMMON_TYPE }

SELECT toTypeName([NULL, CAST((1, 2) AS Tuple(Int32, Int32)), CAST((3, 4, 5) AS Nullable(Tuple(Int32, Int32, Int32)))]); -- { serverError NO_COMMON_TYPE }

SELECT toTypeName([CAST([(1, 2), (3, 4)] AS Array(Tuple(Int32, Int32))), CAST([(5, 6), (7, 8)] AS Array(Nullable(Tuple(Int32, Int32))))]);

SELECT toTypeName([CAST([(1, 2), (3, 4)] AS Array(Nullable(Tuple(Int32, Int32)))), CAST([(5, 6), (7, 8)] AS Array(Tuple(Int32, Int32)))]);

SELECT toTypeName([CAST(tuple(), 'Tuple()'), CAST(tuple(), 'Nullable(Tuple())')]);

SELECT toTypeName([CAST(tuple(1) AS Tuple(Int32)), CAST(tuple(2) AS Nullable(Tuple(Int32)))]);

SELECT toTypeName([CAST((1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 'Tuple(Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32)'), CAST((11, 12, 13, 14, 15, 16, 17, 18, 19, 20), 'Nullable(Tuple(Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32,Int32))')]);

SELECT toTypeName([CAST(NULL AS Nullable(Tuple(Int32, String))), CAST(NULL AS Nullable(Tuple(Int32, String))), CAST(NULL AS Nullable(Tuple(Int32, String)))]);

SELECT toTypeName([CAST((1, NULL) AS Tuple(Int32, Nullable(String))), CAST((2, 'b') AS Nullable(Tuple(Int32, Nullable(String))))]);