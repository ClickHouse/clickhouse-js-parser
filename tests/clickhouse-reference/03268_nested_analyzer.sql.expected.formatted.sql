SET enable_analyzer = '1';

SET output_format_pretty_named_tuples_as_json = '0';

-- {echoOn }
SELECT nested(['a', 'b'], [1, 2], [3, 4]);

SELECT nested(['a', 'b'], [1, 2], materialize([3, 4]));

SELECT nested(['a', 'b'], materialize([1, 2]), materialize([3, 4]));

SELECT nested([['a', 'b']], [[1, 2], [3]], [[4, 5], [6]]);

SELECT nested([['a'], ['b']], [[1, 2], [3]], [[4, 5], [6]]); -- {serverError BAD_ARGUMENTS}

SELECT
    x,
    y,
    z,
    nested(['a', 'b', 'c'], x, y, z),
    nested([['a', 'b', 'c']], x, y, z)
FROM
    `system`.one
ARRAY JOIN [[[1, 2], [3]], [[4], [5, 6]]] AS x, [[[7, 8], [9]], [[10], [11, 12]]] AS y, [[[13, 14], [15]], [[16], [17, 18]]] AS z
FORMAT Pretty;

SELECT nested([[['a', 'b', 'c']]], [[[1, 2], [3]], [[4], [5, 6]]] AS x, [[[7, 8], [9]], [[10], [11, 12]]] AS y, [[[13, 14], [15]], [[16], [17, 18]]] AS z)
FORMAT Pretty;

SELECT nested(['a', 'b'], [[1, 2], [3, 4]], [[5], [6]]);

SELECT nested([['a', 'b']], [[1, 2], [3, 4]], [[5], [6]]); -- {serverError SIZES_OF_ARRAYS_DONT_MATCH}

-- {echoOff}
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt8,
    `struct.x` DEFAULT [0],
    `struct.y` ALIAS [1]
)
ENGINE = Memory();

INSERT INTO test (x);

SELECT *
FROM
    test
ARRAY JOIN struct;

SELECT
    x,
    struct.x,
    struct.y
FROM
    test
ARRAY JOIN struct;

DROP TABLE test;