SELECT arrayRotateLeft([1, 2, 3, 4, 5], 2);

SELECT arrayRotateLeft([1, 2, 3, 4, 5], -2);

SELECT arrayRotateLeft([1, 2, 3, 4, 5], 8);

SELECT arrayRotateLeft(['H', 'e', 'l', 'l', 'o'], 2);

SELECT arrayRotateLeft([[[1, 2], [3, 4]], [[5, 6], [7, 8]]], 1);

SELECT arrayRotateRight([1, 2, 3, 4, 5], 2);

SELECT arrayRotateRight([1, 2, 3, 4, 5], -2);

SELECT arrayRotateRight([1, 2, 3, 4, 5], 8);

SELECT arrayRotateRight(['H', 'e', 'l', 'l', 'o'], 2);

SELECT arrayRotateRight([[[1, 2], [3, 4]], [[5, 6], [7, 8]]], 1);

SELECT arrayShiftLeft([1, 2, 3, 4, 5], 3);

SELECT arrayShiftLeft([1, 2, 3, 4, 5], -3);

SELECT arrayShiftLeft([1, 2, 3, 4, 5], 8);

SELECT arrayShiftLeft(['a', 'b', 'c', 'd', 'e'], 3);

SELECT arrayShiftLeft([[1, 2], [3, 4], [5, 6]], 2);

SELECT arrayShiftLeft([[[1, 2], [3, 4]], [[5, 6], [7, 8]]], 1);

SELECT arrayShiftLeft([1, 2, 3, 4, 5], 3, 7);

SELECT arrayShiftLeft(['a', 'b', 'c', 'd', 'e'], 3, 'foo');

SELECT arrayShiftLeft([[1, 2], [3, 4], [5, 6]], 2, [7, 8]);

SELECT arrayShiftLeft(CAST('[1, 2, 3, 4, 5, 6]' AS Array(UInt16)), 1, 1000);

SELECT arrayShiftRight([1, 2, 3, 4, 5], 3);

SELECT arrayShiftRight([1, 2, 3, 4, 5], -3);

SELECT arrayShiftRight([1, 2, 3, 4, 5], 8);

SELECT arrayShiftRight(['a', 'b', 'c', 'd', 'e'], 3);

SELECT arrayShiftRight([[1, 2], [3, 4], [5, 6]], 2);

SELECT arrayShiftRight([[[1, 2], [3, 4]], [[5, 6], [7, 8]]], 1);

SELECT arrayShiftRight([1, 2, 3, 4, 5], 3, 7);

SELECT arrayShiftRight(['a', 'b', 'c', 'd', 'e'], 3, 'foo');

SELECT arrayShiftRight([[1, 2], [3, 4], [5, 6]], 2, [7, 8]);

SELECT arrayShiftRight(CAST('[1, 2, 3, 4, 5, 6]' AS Array(UInt16)), 1, 1000);

DROP TABLE IF EXISTS t02845;

CREATE TABLE t02845
(
    a Array(UInt8),
    s Int16,
    d UInt8
)
ENGINE = MergeTree()
ORDER BY d;

INSERT INTO t02845;

SELECT '-- arrayRotateLeft';

SELECT arrayRotateLeft(a, 2)
FROM t02845;

SELECT arrayRotateRight(a, 2)
FROM t02845;

SELECT arrayShiftLeft(a, 3)
FROM t02845;

SELECT arrayShiftRight(a, 3)
FROM t02845;

SELECT arrayShiftLeft(a, 3, 7)
FROM t02845;

SELECT arrayShiftRight(a, 3, 7)
FROM t02845;

SELECT arrayRotateLeft(a, s)
FROM t02845;

SELECT arrayRotateRight(a, s)
FROM t02845;

SELECT arrayShiftLeft(a, s, d)
FROM t02845;

SELECT arrayShiftRight(a, s, d)
FROM t02845;

SELECT arrayShiftLeft([30000], 3, 5);

SELECT arrayShiftLeft([[1]], 3, []);

SELECT arrayShiftLeft(['foo'], 3, 3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayShiftLeft([1], 3, 'foo'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }