SELECT arrayResize([1, 2, 3], 10);

SELECT arrayResize([1, 2, 3], -10);

SELECT arrayResize([1, NULL, 3], 10);

SELECT arrayResize([1, NULL, 3], -10);

SELECT arrayResize([1, 2, 3, 4, 5, 6], 3);

SELECT arrayResize([1, 2, 3, 4, 5, 6], -3);

SELECT arrayResize([1, 2, 3], 5, 42);

SELECT arrayResize([1, 2, 3], -5, 42);

SELECT arrayResize(['a', 'b', 'c'], 5);

SELECT arrayResize([[1, 2], [3, 4]], 4);

SELECT arrayResize([[1, 2], [3, 4]], -4);

SELECT arrayResize([[1, 2], [3, 4]], 4, [5, 6]);

SELECT arrayResize([[1, 2], [3, 4]], -4, [5, 6]);

-- different types of array elements and default value to fill
SELECT arrayResize([1, 2, 3], 5, 423.56);

-- Second argument cannot be Nullable
SELECT arrayResize([1, 2, 3], toNullable(3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayResize(materialize([1]), toNullable(3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }