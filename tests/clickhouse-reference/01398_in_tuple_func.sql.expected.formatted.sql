SELECT 1 IN (tuple(1, 2, 3, 4, 5))
SETTINGS max_temporary_columns = '2';

SELECT (1, 2) IN (tuple(tuple(1, 2), tuple(3, 4), tuple(5, 6), tuple(7, 8), tuple(9, 10)))
SETTINGS max_temporary_columns = '4';

SELECT 1 IN (array(1, 2, 3, 4, 5))
SETTINGS max_temporary_columns = '3';

SELECT (1, 2) IN (array(tuple(1, 2), tuple(3, 4), tuple(5, 6), tuple(7, 8), tuple(9, 10)))
SETTINGS max_temporary_columns = '4';

SELECT (1, 2) IN (tuple(1, 2));

SELECT (1, 2) IN (array((1, 3), (1, 2)));

SELECT [1] IN (array([1], [2, 3]));

SELECT ([1], [2]) IN (tuple([NULL], [NULL]));

SELECT ([1], [2]) IN (tuple(([NULL], [NULL]), ([1], [2])));

SELECT 4 IN (plus(2, 2));

SELECT (1, 'a') IN (tuple((1, 'a'), (2, 'b'), (3, 'c')));

SELECT (1, 'a') IN (tuple((2, 'b'), (3, 'c'), (4, 'd')));

SELECT (1, (2, 'foo')) IN (tuple((1, (3, 'b')), (1, (2, 'foo'))));