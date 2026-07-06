SELECT tupleHammingDistance(tuple(1), tuple(1));

SELECT tupleHammingDistance(tuple(1), tuple(2));

SELECT tupleHammingDistance(tuple(1), tuple(NULL));

SELECT tupleHammingDistance(tuple(NULL), tuple(NULL));

SELECT tupleHammingDistance((1, 2), (3, 4));

SELECT tupleHammingDistance((1, 2), (1, 4));

SELECT tupleHammingDistance(materialize((1, 2)), (1, 4));

SELECT tupleHammingDistance(materialize((1, 2)), materialize((1, 4)));

SELECT tupleHammingDistance((1, 2), (1, 2));

SELECT tupleHammingDistance((1, 2), (1, 257));

SELECT tupleHammingDistance((1, 2, 3), (1, 257, 65537));

SELECT tupleHammingDistance((1, 2), (1, NULL));

SELECT tupleHammingDistance((1, NULL), (1, NULL));

SELECT tupleHammingDistance((NULL, NULL), (NULL, NULL));

SELECT tupleHammingDistance(('abc', 2), ('abc', 257));

SELECT tupleHammingDistance(('abc', (1, 2)), ('abc', (1, 2)));

SELECT tupleHammingDistance(('abc', (1, 2)), ('def', (1, 2)));

SELECT tupleHammingDistance(('abc', (1, 2)), ('def', (1, 3)));

SELECT tupleHammingDistance(tuple(1), tuple(1, 1)); --{serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT tupleHammingDistance(tuple(1), tuple('a')); --{serverError NO_COMMON_TYPE}

SELECT tupleHammingDistance((1, 3), (3, 'a')); --{serverError NO_COMMON_TYPE}