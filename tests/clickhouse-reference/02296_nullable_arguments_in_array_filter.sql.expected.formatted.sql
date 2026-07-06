SELECT arrayFilter((x -> 2 * x > 0), []);

SELECT arrayFilter((x -> 2 * x > 0), [NULL]);

SELECT arrayFilter((x -> x % 2 ? NULL : 1), [1, 2, 3, 4]);

SELECT arrayFilter((x -> x % 2), [1, NULL, 3, NULL]);