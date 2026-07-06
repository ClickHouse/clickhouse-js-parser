DROP TABLE IF EXISTS t1;

DROP DICTIONARY IF EXISTS dict_flat;

DROP DICTIONARY IF EXISTS dict_hashed;

DROP DICTIONARY IF EXISTS dict_complex_cache;

CREATE TABLE t1
(
    key UInt64,
    a UInt8,
    b String,
    c Float64
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO t1 SELECT
    number,
    number,
    toString(number),
    number
FROM numbers(4);

CREATE DICTIONARY dict_flat
(
    key UInt64 DEFAULT 0,
    a UInt8 DEFAULT 42,
    b String DEFAULT 'x',
    c Float64 DEFAULT 42.
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE 't1'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(FLAT());

CREATE DICTIONARY dict_hashed
(
    key UInt64 DEFAULT 0,
    a UInt8 DEFAULT 42,
    b String DEFAULT 'x',
    c Float64 DEFAULT 42.
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE 't1'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(HASHED());

CREATE DICTIONARY dict_complex_cache
(
    key UInt64 DEFAULT 0,
    a UInt8 DEFAULT 42,
    b String DEFAULT 'x',
    c Float64 DEFAULT 42.
)
PRIMARY KEY key, b
SOURCE(clickhouse(TABLE 't1'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(COMPLEX_KEY_CACHE(SIZE_IN_CELLS 1));

SET join_use_nulls = '0';

SET join_algorithm = 'direct';

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
LEFT JOIN dict_flat AS d
    ON s1.key = d.key
ORDER BY s1.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
LEFT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
ANY LEFT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
SEMI LEFT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
ANTI LEFT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
INNER JOIN dict_flat AS d
    USING (key);

SELECT *
FROM
    (
        SELECT number AS k
        FROM numbers(100)
    ) AS s1
INNER JOIN dict_flat AS d
    ON k = key
ORDER BY k ASC;

SET join_use_nulls = '1';

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
LEFT JOIN dict_hashed AS d
    ON s1.key = d.key
ORDER BY s1.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
LEFT JOIN dict_hashed AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
ANY LEFT JOIN dict_hashed AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
SEMI LEFT JOIN dict_hashed AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
ANTI LEFT JOIN dict_hashed AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
INNER JOIN dict_hashed AS d
    USING (key);

SELECT *
FROM
    (
        SELECT number AS k
        FROM numbers(100)
    ) AS s1
INNER JOIN dict_hashed AS d
    ON k = key
ORDER BY k ASC;

-- unsupported cases for dictionary join, falls back to regular join
SET join_algorithm = 'default';

SELECT *
FROM
    (
        SELECT if(number % 2 = 0, number, number * 1000) AS k
        FROM numbers(100)
    ) AS s1
INNER JOIN dict_flat AS d
    ON k = key
    OR k = 1000 * key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
ANY LEFT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC
SETTINGS any_join_distinct_right_table_keys = '1';

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(5)
    ) AS s1
LEFT JOIN dict_complex_cache AS d
    ON s1.key = d.key
ORDER BY s1.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
RIGHT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
RIGHT JOIN dict_flat AS d
    ON s1.key = d.key
ORDER BY d.key ASC;

SELECT *
FROM
    (
        SELECT number + 2 AS key
        FROM numbers(4)
    ) AS s1
FULL JOIN dict_flat AS d
    USING (key)
ORDER BY
    s1.key ASC,
    d.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
ANY INNER JOIN dict_flat AS d
    USING (key)
ORDER BY s1.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
ANY RIGHT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
SEMI RIGHT JOIN dict_flat AS d
    USING (key)
ORDER BY s1.key ASC;

SELECT *
FROM
    (
        SELECT number AS key
        FROM numbers(2)
    ) AS s1
ANTI RIGHT JOIN dict_flat AS d
    USING (key)
ORDER BY key ASC;

SET join_algorithm = 'auto';

SET join_algorithm = 'partial_merge';

DROP DICTIONARY dict_flat;

DROP DICTIONARY dict_hashed;

DROP DICTIONARY dict_complex_cache;

DROP TABLE t1;