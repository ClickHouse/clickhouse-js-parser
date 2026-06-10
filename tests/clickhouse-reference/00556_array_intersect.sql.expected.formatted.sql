SELECT arrayIntersect([], []);

SELECT arrayIntersect([1], []);

SELECT arrayIntersect([1], [1]);

SELECT arrayIntersect([1, 2], [1, 3], [2, 3]);

SELECT arrayIntersect([1, 2], [1, 3], [1, 4]);

SELECT arrayIntersect([1, -1], [1]);

SELECT arrayIntersect([1, -1], [NULL, 1]);

SELECT arrayIntersect([1, -1, NULL], [NULL, 1]);

SELECT arrayIntersect(CAST([1, 2] AS Array(Nullable(Int8))), [1, 3]);

SELECT arrayIntersect(CAST([1, -1] AS Array(Nullable(Int8))), [NULL, 1]);

SELECT arrayIntersect([[1, 2], [1, 1]], [[2, 1], [1, 1]]);

SELECT arrayIntersect([[1, 2, NULL], [1, 1]], [[-2, 1], [1, 1]]);

SELECT arrayIntersect([(1, ['a', 'b']), (NULL, ['c'])], [(2, ['c', NULL]), (1, ['a', 'b'])]);

SELECT toTypeName(arrayIntersect([(1, ['a', 'b']), (NULL, ['c'])], [(2, ['c', NULL]), (1, ['a', 'b'])]));