SELECT hasSubstr([], []);

SELECT hasSubstr([], [1]);

SELECT hasSubstr([], [NULL]);

SELECT hasSubstr([NULL], [NULL]);

SELECT hasSubstr([NULL], [NULL, 1]);

SELECT hasSubstr([1], []);

SELECT hasSubstr([1], [NULL]);

SELECT hasSubstr([1, NULL], [NULL]);

SELECT hasSubstr([1, NULL, 3, 4, NULL, 5, 7], [3, 4, NULL]);

SELECT hasSubstr([1, NULL], [3, 4, NULL]);

SELECT hasSubstr([1], emptyArrayUInt8());

SELECT hasSubstr([1, 2, 3, 4], [1, 3]);

SELECT hasSubstr([1, 2, 3, 4], [1, 3, 5]);

SELECT hasSubstr([-128, 1., 512], [1.]);

SELECT hasSubstr([-128, 1., 512], [0.3]);

SELECT hasSubstr(['a'], ['a']);

SELECT hasSubstr(['a', 'b'], ['a', 'c']);

SELECT hasSubstr(['a', 'c', 'b'], ['a', 'c']);

SELECT hasSubstr([1], ['a']); -- { serverError NO_COMMON_TYPE }

SELECT hasSubstr([[1, 2], [3, 4]], ['a', 'c']); -- { serverError NO_COMMON_TYPE }

SELECT hasSubstr([[1, 2], [3, 4], [5, 8]], [[3, 4]]);

SELECT hasSubstr([[1, 2], [3, 4], [5, 8]], [[3, 4], [5, 8]]);

SELECT hasSubstr([[1, 2], [3, 4], [5, 8]], [[1, 2], [5, 8]]);