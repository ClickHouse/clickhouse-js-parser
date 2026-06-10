SELECT arrayFirstOrNull((x -> 1), emptyArrayUInt8());

SELECT arrayFirstOrNull((x -> 0), emptyArrayUInt8());

SELECT arrayFirstOrNull((x -> 1), [1, 2, 3]);

SELECT arrayFirstOrNull((x -> 0), [1, 2, 3]);

SELECT arrayFirstOrNull((x -> x >= 2), emptyArrayUInt8());

SELECT arrayFirstOrNull((x -> x >= 2), [1, 2, 3]);

SELECT arrayFirstOrNull((x -> x >= 2), materialize([1, 2, 3]));

SELECT arrayFirstOrNull(((x, f) -> f), [1, 2, 3, NULL], [0, 1, 0, 0]);

SELECT arrayFirstOrNull(((x, f) -> f), [1, 2, 3, NULL], [0, 0, 0, 1]);

SELECT arrayLastOrNull((x -> 1), emptyArrayUInt8());

SELECT arrayLastOrNull((x -> 0), emptyArrayUInt8());

SELECT arrayLastOrNull((x -> 1), [1, 2, 3]);

SELECT arrayLastOrNull((x -> 0), [1, 2, 3]);

SELECT arrayLastOrNull((x -> x >= 2), emptyArrayUInt8());

SELECT arrayLastOrNull((x -> x >= 2), [1, 2, 3]);

SELECT arrayLastOrNull((x -> x >= 2), materialize([1, 2, 3]));

SELECT arrayLastOrNull(((x, f) -> f), [1, 2, 3, NULL], [0, 1, 0, 0]);

SELECT arrayLastOrNull(((x, f) -> f), [1, 2, 3, NULL], [0, 1, 0, 1]);