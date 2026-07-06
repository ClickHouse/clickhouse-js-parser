SELECT arrayCompact([0]);

SELECT arrayCompact([1]);

SELECT arrayCompact([2]);

SELECT arrayCompact([1, 1]);

SELECT arrayCompact([1, 2]);

SELECT arrayCompact([1, 1, 2]);

SELECT arrayCompact([1, 2, 1]);

SELECT arrayCompact([2, 1, 1]);

SELECT arrayCompact([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]);

SELECT arrayCompact(arrayMap((x -> 0), [NULL]));

SELECT toString(arrayCompact(arrayMap((x -> 0), [NULL])));