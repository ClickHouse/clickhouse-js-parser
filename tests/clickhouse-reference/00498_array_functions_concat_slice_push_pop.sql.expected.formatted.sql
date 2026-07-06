SELECT arrayConcat(emptyArrayUInt8());

SELECT arrayConcat(emptyArrayUInt8(), emptyArrayUInt8());

SELECT arrayConcat(emptyArrayUInt8(), emptyArrayUInt8(), emptyArrayUInt8());

SELECT arrayConcat([NULL], emptyArrayUInt8());

SELECT arrayConcat([NULL], emptyArrayUInt8(), [1]);

SELECT arrayConcat([1, 2], [-1, -2], [0.3, 0.7], [NULL]);

SELECT arrayConcat(NULL, emptyArrayUInt8());

SELECT arrayConcat([1], [-1], NULL);

SELECT arrayConcat([1, 2], [3, 4]);

SELECT arrayConcat([1], [2, 3, 4]);

SELECT arrayConcat(['abc'], ['def', 'gh', 'qwe']);

SELECT arrayConcat([1, NULL, 2], [3, NULL, 4]);

SELECT arrayConcat([1, NULL, 2], [3, 4]);

SELECT arraySlice(NULL, 1, 2);

SELECT arraySlice([1, 2, 3, 4, 5, 6], NULL, NULL);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 2, NULL);

SELECT arraySlice([1, 2, 3, 4, 5, 6], NULL, 4);

SELECT arraySlice([1, 2, 3, 4, 5, 6], NULL, -2);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -3, NULL);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 2, 3);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 2, -2);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -4, 2);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -4, -2);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 2, 0);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -10, 15);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -15, 10);

SELECT arraySlice([1, 2, 3, 4, 5, 6], -15, 9);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 10, 0);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 10, -1);

SELECT arraySlice([1, 2, 3, 4, 5, 6], 10, 1);

SELECT arraySlice([1, 2, NULL, 4, 5, 6], 2, 4);

SELECT arraySlice(['a', 'b', 'c', 'd', 'e'], 2, 3);

SELECT arraySlice([NULL, 'b', NULL, 'd', 'e'], 2, 3);

SELECT
    arraySlice([], materialize(NULL), NULL),
    1
FROM numbers(2);

SELECT arrayPushBack(NULL, 1);

SELECT arrayPushBack([1], 1);

SELECT arrayPushBack([NULL], 1);

SELECT arrayPushBack([0.5, 0.7], 1);

SELECT arrayPushBack([1], -1);

SELECT arrayPushBack(['a', 'b'], 'cd');

SELECT arrayPushBack(emptyArrayUInt8(), 1);

SELECT arrayPushBack(emptyArrayUInt8(), -1);

SELECT arrayPushFront(NULL, 1);

SELECT arrayPushFront([1], 1);

SELECT arrayPushFront([NULL], 1);

SELECT arrayPushFront([0.5, 0.7], 1);

SELECT arrayPushFront([1], -1);

SELECT arrayPushFront(['a', 'b'], 'cd');

SELECT arrayPushFront(emptyArrayUInt8(), 1);

SELECT arrayPushFront(emptyArrayUInt8(), -1);

SELECT arrayPopBack(NULL);

SELECT arrayPopBack(emptyArrayUInt8());

SELECT arrayPopBack([1]);

SELECT arrayPopBack([1, 2, 3]);

SELECT arrayPopBack([0.1, 0.2, 0.3]);

SELECT arrayPopBack(['a', 'b', 'c']);

SELECT arrayPopFront(NULL);

SELECT arrayPopFront(emptyArrayUInt8());

SELECT arrayPopFront([1]);

SELECT arrayPopFront([1, 2, 3]);

SELECT arrayPopFront([0.1, 0.2, 0.3]);

SELECT arrayPopFront(['a', 'b', 'c']);

DROP TABLE IF EXISTS array_functions;

CREATE TABLE array_functions
(
    arr1 Array(Int8),
    arr2 Array(Int8),
    o Int8,
    no Nullable(Int8),
    l Int8,
    nl Nullable(Int8)
)
ENGINE = TinyLog();

INSERT INTO array_functions;

SELECT *
FROM array_functions;

SELECT
    arrayConcat(arr1, arr2),
    arr1,
    arr2
FROM array_functions;

SELECT
    arrayConcat(arr1, arr2, arr1),
    arr1,
    arr2
FROM array_functions;

SELECT
    arr1,
    o,
    l,
    arraySlice(arr1, o, l)
FROM array_functions;

SELECT
    arr1,
    no,
    nl,
    arraySlice(arr1, no, nl)
FROM array_functions;

SELECT
    arr1,
    2,
    l,
    arraySlice(arr1, 2, l)
FROM array_functions;

SELECT
    arr1,
    o,
    2,
    arraySlice(arr1, o, 2)
FROM array_functions;

SELECT
    arr1,
    2,
    nl,
    arraySlice(arr1, 2, nl)
FROM array_functions;

SELECT
    arr1,
    no,
    2,
    arraySlice(arr1, no, 2)
FROM array_functions;

SELECT
    arr1,
    2,
    l,
    arraySlice(arr1, -4, l)
FROM array_functions;

SELECT
    arr1,
    o,
    2,
    arraySlice(arr1, o, -2)
FROM array_functions;

SELECT
    arr1,
    2,
    nl,
    arraySlice(arr1, -4, nl)
FROM array_functions;

SELECT
    arr1,
    no,
    2,
    arraySlice(arr1, no, -2)
FROM array_functions;

SELECT
    arr1,
    2,
    4,
    arraySlice(arr1, 2, 4)
FROM array_functions;

SELECT
    arr1,
    2,
    4,
    arraySlice(arr1, 2, -4)
FROM array_functions;

SELECT
    arr1,
    2,
    4,
    arraySlice(arr1, -4, 2)
FROM array_functions;

SELECT
    arr1,
    2,
    4,
    arraySlice(arr1, -4, -1)
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, 1)
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, 0.1)
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, l)
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, nl)
FROM array_functions;

SELECT arrayPushFront([1, 2, 3], l)
FROM array_functions;

SELECT 'arrayPushFront([1, 2, 3], nl)'
FROM array_functions;

SELECT arrayPushFront([1, 2, 3], nl)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, 1)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, 0.1)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, l)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, nl)
FROM array_functions;

SELECT arrayPushBack([1, 2, 3], l)
FROM array_functions;

SELECT arrayPushBack([1, 2, 3], nl)
FROM array_functions;

SELECT
    arr1,
    arrayPopFront(arr1)
FROM array_functions;

SELECT
    arr1,
    arrayPopBack(arr1)
FROM array_functions;

CREATE TABLE array_functions
(
    arr1 Array(Nullable(Int8)),
    arr2 Array(Nullable(Float32)),
    o Int8,
    no Nullable(Int8),
    l Int8,
    nl Nullable(Int8)
)
ENGINE = TinyLog();

INSERT INTO array_functions;

CREATE TABLE array_functions
(
    arr1 Array(Nullable(Int8)),
    arr2 Array(UInt8),
    o Int8,
    no Nullable(Int8),
    l Int8,
    nl Nullable(Int8)
)
ENGINE = TinyLog();

INSERT INTO array_functions;

CREATE TABLE array_functions
(
    arr1 Array(Nullable(String)),
    arr2 Array(String),
    val String,
    val2 Nullable(String),
    o Int8,
    no Nullable(Int8),
    l Int8,
    nl Nullable(Int8)
)
ENGINE = TinyLog();

INSERT INTO array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, '1')
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, val)
FROM array_functions;

SELECT
    arr1,
    arrayPushFront(arr1, val2)
FROM array_functions;

SELECT arrayPushFront(['a', 'b', 'c'], val)
FROM array_functions;

SELECT arrayPushFront(['a', 'b', 'c'], val2)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, '1')
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, val)
FROM array_functions;

SELECT
    arr1,
    arrayPushBack(arr1, val2)
FROM array_functions;

SELECT arrayPushBack(['a', 'b', 'c'], val)
FROM array_functions;

SELECT arrayPushBack(['a', 'b', 'c'], val2)
FROM array_functions;