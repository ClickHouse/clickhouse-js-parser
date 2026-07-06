DROP TABLE IF EXISTS arrays_test;

CREATE TABLE arrays_test
(
    s String,
    arr1 Array(UInt8),
    map1 Map(UInt8, String),
    map2 Map(UInt8, String)
)
ENGINE = Memory();

INSERT INTO arrays_test;

SELECT
    s,
    arr1,
    map1
FROM
    arrays_test
ARRAY JOIN arr1, map1
SETTINGS enable_unaligned_array_join = '1';

SELECT
    s,
    arr1,
    map1
FROM
    arrays_test
LEFT ARRAY JOIN arr1, map1
SETTINGS enable_unaligned_array_join = '1';

SELECT
    s,
    map1
FROM
    arrays_test
ARRAY JOIN map1;

SELECT
    s,
    map1
FROM
    arrays_test
LEFT ARRAY JOIN map1;

SELECT
    s,
    map1,
    map2
FROM
    arrays_test
ARRAY JOIN map1, map2
SETTINGS enable_unaligned_array_join = '1';

SELECT
    s,
    map1,
    map2
FROM
    arrays_test
LEFT ARRAY JOIN map1, map2
SETTINGS enable_unaligned_array_join = '1';