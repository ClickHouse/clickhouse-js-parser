DROP TABLE IF EXISTS array_union;

CREATE TABLE array_union
(
    date Date,
    arr Array(UInt8)
)
ENGINE = MergeTree()
ORDER BY date
PARTITION BY date;

INSERT INTO array_union;

INSERT INTO array_union;

INSERT INTO array_union;

INSERT INTO array_union;

SELECT arraySort(arrayUnion(arr, [1, 2]))
FROM array_union
ORDER BY arr ASC;

SELECT '-------';

SELECT arraySort(arrayUnion(arr, []))
FROM array_union
ORDER BY arr ASC;

SELECT arraySort(arrayUnion([], arr))
FROM array_union
ORDER BY arr ASC;

SELECT arraySort(arrayUnion([1, 2], arr))
FROM array_union
ORDER BY arr ASC;

SELECT arraySort(arrayUnion([1, 2], [1, 2, 3, 4]))
FROM array_union
ORDER BY arr ASC;

SELECT arraySort(arrayUnion([], []))
FROM array_union
ORDER BY arr ASC;

SELECT arraySort(arrayUnion([-100], [156]));

SELECT arraySort(arrayUnion([1], [-257, -100]));

SELECT arraySort(arrayUnion(['hi'], ['hello', 'hi'], []));

SELECT arraySort(arrayUnion([1, 2, NULL], [1, 3, NULL], [2, 3, NULL]));

SELECT arraySort(arrayUnion([NULL, NULL, NULL, 1], [1, NULL, NULL], [1, 2, 3, NULL]));

SELECT arraySort(arrayUnion([1, 1, 1, 2, 3], [2, 2, 4], [5, 10, 20]));

SELECT arraySort(arrayUnion([1, 2], [1, 3], []));

-- example from docs
SELECT
    arrayUnion([-2, 1], [10, 1], [-2], []) AS num_example,
    arrayUnion(['hi'], [], ['hello', 'hi']) AS str_example,
    arrayUnion([1, 3, NULL], [2, 3, NULL]) AS null_example;

--mix of types
SELECT arrayUnion([1], [-2], [1.1, 'hi'], [NULL, 'hello', []]); -- {serverError NO_COMMON_TYPE}

SELECT arrayUnion([1]);

SELECT arrayUnion(); -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

--bigger arrays
SELECT arraySort(arrayUnion(range(1, 256), range(2, 257)));

SELECT length(arrayUnion(range(1, 100000), range(9999, 200000)));

--bigger number of arguments
SELECT arraySort(arrayUnion([1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 14], [1, 15], [1, 16], [1, 17], [1, 18], [1, 19]));

-- Table with batch inserts
DROP TABLE IF EXISTS test_array_union;

CREATE TABLE test_array_union
(
    id Int8,
    properties Array(String)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '8192';

INSERT INTO test_array_union;

SELECT
    ta.id AS id,
    ta.properties AS properties,
    arrayUnion(ta.properties) AS propertiesUnion
FROM test_array_union AS ta;