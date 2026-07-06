SELECT tupleToNameValuePairs(tuple(1, 2, 3));

DROP TABLE IF EXISTS test02008;

CREATE TABLE test02008
(
    col Tuple(a Tuple(key1 int, key2 int), b Tuple(key1 int, key2 int))
)
ENGINE = Memory();

INSERT INTO test02008;

INSERT INTO test02008;

SELECT tupleToNameValuePairs(col)
FROM test02008
ORDER BY col ASC;

CREATE TABLE test02008
(
    col Tuple(CPU double, Memory double, Disk double)
)
ENGINE = Memory();

INSERT INTO test02008;

SELECT untuple(arrayJoin(tupleToNameValuePairs(col)))
FROM test02008;

SELECT tupleToNameValuePairs(tuple(1, 1.3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tupleToNameValuePairs(tuple(1, [1, 2])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tupleToNameValuePairs(tuple(1, 'a')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tupleToNameValuePairs(33); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }