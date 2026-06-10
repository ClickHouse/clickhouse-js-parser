DROP TABLE IF EXISTS array_intersect;

CREATE TABLE array_intersect
(
    date Date,
    arr Array(UInt8)
)
ENGINE = MergeTree()
ORDER BY date
PARTITION BY date;

INSERT INTO array_intersect;

INSERT INTO array_intersect;

INSERT INTO array_intersect;

INSERT INTO array_intersect;

SELECT arraySort(arrayIntersect(arr, [1, 2]))
FROM array_intersect
ORDER BY arr ASC;

SELECT arraySort(arrayIntersect(arr, []))
FROM array_intersect
ORDER BY arr ASC;

SELECT arraySort(arrayIntersect([], arr))
FROM array_intersect
ORDER BY arr ASC;

SELECT arraySort(arrayIntersect([1, 2], arr))
FROM array_intersect
ORDER BY arr ASC;

SELECT arraySort(arrayIntersect([1, 2], [1, 2, 3, 4]))
FROM array_intersect
ORDER BY arr ASC;

SELECT arraySort(arrayIntersect([], []))
FROM array_intersect
ORDER BY arr ASC;

OPTIMIZE TABLE array_intersect;

SELECT arraySort(arrayIntersect([-100], [156]));

SELECT arraySort(arrayIntersect([1], [257]));