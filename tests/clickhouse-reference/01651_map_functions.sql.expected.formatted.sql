SET use_variant_as_common_type = '0';

-- Map(String, String)
DROP TABLE IF EXISTS table_map;

CREATE TABLE table_map
(
    a Map(String, String),
    b String,
    c Array(String),
    d Array(String)
)
ENGINE = Memory();

INSERT INTO table_map;

SELECT mapContains(a, 'name')
FROM table_map;

SELECT mapContains(a, 'gender')
FROM table_map;

SELECT mapContains(a, 'abc')
FROM table_map;

SELECT mapContains(a, b)
FROM table_map;

SELECT mapContains(a, 10)
FROM table_map; -- { serverError NO_COMMON_TYPE }

SELECT mapKeys(a)
FROM table_map;

SELECT mapFromArrays(c, d)
FROM table_map;

DROP TABLE table_map;

-- Map(UInt8, UInt8)
CREATE TABLE table_map
(
    a Map(UInt8, Int),
    b UInt8,
    c UInt32,
    d Array(String),
    e Array(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO table_map SELECT
    map(number, number),
    number,
    number,
    [number, number, number],
    [number * 2, number * 3, number * 4]
FROM numbers(1000, 3);

SELECT
    mapContains(a, b),
    mapContains(a, c),
    mapContains(a, 233)
FROM table_map;

SELECT mapContains(a, 'aaa')
FROM table_map; -- { serverError NO_COMMON_TYPE }

SELECT mapContains(b, 'aaa')
FROM table_map; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapValues(a)
FROM table_map;

SELECT mapFromArrays(d, e)
FROM table_map;

-- Map(String, UInt8)
SELECT
    map('aa', 4, 'bb', 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map('aa', 4, 'bb', 5) AS m,
    mapContains(m, 'aa'),
    mapContains(m, 'k');

-- Map(Float32, UInt8)
SELECT
    map(CAST('0.1' AS Float32), 4, CAST('0.2' AS Float32), 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map(CAST('0.1' AS Float32), 4, CAST('0.2' AS Float32), 5) AS m,
    mapContains(m, CAST('0.1' AS Float32)),
    mapContains(m, CAST('0.3' AS Float32));

-- Map(LowCardinality(UInt8), UInt8)
SET allow_suspicious_low_cardinality_types = '1';

SELECT
    map(CAST('1' AS LowCardinality(UInt8)), 4, CAST('2' AS LowCardinality(UInt8)), 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map(CAST('1' AS LowCardinality(UInt8)), 4, CAST('2' AS LowCardinality(UInt8)), 5) AS m,
    mapContains(m, 1),
    mapContains(m, 3),
    mapContains(m, CAST('1' AS LowCardinality(UInt8))),
    mapContains(m, CAST('3' AS LowCardinality(UInt8)));

-- Map(Array(UInt8), UInt8)
SELECT
    map(array(1, 2), 4, array(3, 4), 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map(array(1, 2), 4, array(3, 4), 5) AS m,
    mapContains(m, array(1, 2)),
    mapContains(m, array(1, 3));

-- Map(Map(UInt8, UInt8), UInt8)
SELECT
    map(map(1, 2), 4, map(3, 4), 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map(map(1, 2), 4, map(3, 4), 5) AS m,
    mapContains(m, map(1, 2)),
    mapContains(m, map(1, 3));

-- Map(Tuple(UInt8, UInt8), UInt8)
SELECT
    map(tuple(1, 2), 4, tuple(3, 4), 5) AS m,
    mapKeys(m),
    mapValues(m);

SELECT
    map(tuple(1, 2), 4, tuple(3, 4), 5) AS m,
    mapContains(m, tuple(1, 2)),
    mapContains(m, tuple(1, 3));

SELECT
    map(0, 0) AS m,
    mapContains(m, number % 2)
FROM numbers(2);

SELECT mapFromArrays(['aa', 'bb'], [4, 5]);

SELECT mapFromArrays(['aa', 'bb'], materialize([4, 5]))
FROM numbers(2);

SELECT mapFromArrays([1., 2.], [4, 5]);

SELECT mapFromArrays([1., 2.], materialize([4, 5]))
FROM numbers(2);

SELECT mapFromArrays(materialize(['aa', 'bb']), [4, 5])
FROM numbers(2);

SELECT mapFromArrays(materialize(['aa', 'bb']), materialize([4, 5]))
FROM numbers(2);

SELECT mapFromArrays('aa', [4, 5]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapFromArrays(['aa', 'bb'], 5); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapFromArrays(['aa', 'bb'], [4, 5], [6, 7]); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT mapFromArrays(['aa', 'bb'], [4, 5, 6]); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT mapFromArrays([[1, 2], [3, 4]], [4, 5, 6]); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT mapFromArrays(['a', 2], [4, 5]); -- { serverError NO_COMMON_TYPE}

SELECT mapFromArrays([1, 2], [4, 'a']); -- { serverError NO_COMMON_TYPE}

SELECT mapFromArrays(['aa', 'bb'], map('a', 4)); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT mapFromArrays([1, NULL]::Array(Nullable(UInt8)), [3, 4]); -- { serverError BAD_ARGUMENTS }

SELECT mapFromArrays(['aa', 'bb'], map('a', 4, 'b', 5));

SELECT mapFromArrays(['aa', 'bb'], materialize(map('a', 4, 'b', 5)))
FROM numbers(2);

SELECT mapFromArrays([toLowCardinality(1), toLowCardinality(2)], [4, 5]);

SELECT mapFromArrays([toLowCardinality(1), toLowCardinality(2)], materialize([4, 5]))
FROM numbers(2);

SELECT mapFromArrays([1, 2], [3, 4]);

SELECT mapFromArrays(CAST('[1,2]' AS Array(Nullable(UInt8))), [3, 4]);

SELECT
    mapFromArrays([1, 2], [3, 4]) AS x,
    mapFromArrays(x, ['a', 'b']);

SELECT mapFromArrays(map(1, 'a', 2, 'b'), array('c', 'd'));

SELECT mapFromArrays(materialize(map(1, 'a', 2, 'b')), array('c', 'd'));

SELECT mapFromArrays(map(1, 'a', 2, 'b'), materialize(array('c', 'd')));

SELECT mapFromArrays(materialize(map(1, 'a', 2, 'b')), materialize(array('c', 'd')));