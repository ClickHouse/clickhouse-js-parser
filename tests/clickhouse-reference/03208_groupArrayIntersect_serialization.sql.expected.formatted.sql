SELECT
    hex(groupArrayIntersectState([1]) AS a),
    toTypeName(a);

SELECT finalizeAggregation(CAST(unhex('010101') AS AggregateFunction(groupArrayIntersect, Array(UInt8))));

DROP TABLE IF EXISTS grouparray;

CREATE TABLE grouparray
(
    v AggregateFunction(groupArrayIntersect, Array(UInt8))
)
ENGINE = Log();

INSERT INTO grouparray SELECT groupArrayIntersectState(CAST('[2, 4, 6, 8, 10]' AS Array(UInt8)));

SELECT
    '1',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

SELECT
    '2',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

INSERT INTO grouparray SELECT groupArrayIntersectState(CAST('[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]' AS Array(UInt8)));

SELECT
    '3',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

INSERT INTO grouparray SELECT groupArrayIntersectState(CAST('[2, 6, 10]' AS Array(UInt8)));

SELECT
    '5',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

INSERT INTO grouparray SELECT groupArrayIntersectState(CAST('[10]' AS Array(UInt8)));

SELECT
    '6',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

INSERT INTO grouparray SELECT groupArrayIntersectState(CAST('[]' AS Array(UInt8)));

SELECT
    '7',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray;

DROP TABLE IF EXISTS grouparray_string;

CREATE TABLE grouparray_string
(
    v AggregateFunction(groupArrayIntersect, Array(Tuple(Array(String))))
)
ENGINE = Log();

INSERT INTO grouparray_string SELECT groupArrayIntersectState([tuple(['2', '4', '6', '8', '10'])]);

SELECT
    'a',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray_string;

INSERT INTO grouparray_string SELECT groupArrayIntersectState([tuple(['2', '4', '6', '8', '10']), tuple(['2', '4', '6', '8', '10'])]);

SELECT
    'b',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray_string;

INSERT INTO grouparray_string SELECT groupArrayIntersectState([tuple(['2', '4', '6', '8', '10']), tuple(['2', '4', '6', '8', '10', '14'])]);

SELECT
    'c',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray_string;

INSERT INTO grouparray_string SELECT groupArrayIntersectState([tuple(['2', '4', '6', '8', '10', '20']), tuple(['2', '4', '6', '8', '10', '14'])]);

SELECT
    'd',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray_string;

INSERT INTO grouparray_string SELECT groupArrayIntersectState(CAST('[]' AS Array(Tuple(Array(String)))));

SELECT
    'e',
    arraySort(groupArrayIntersectMerge(v))
FROM grouparray_string;