SET enable_analyzer = '1';

SET enable_named_columns_in_function_tuple = '1';

SELECT untuple((* EXCEPT (b),))
FROM (
        SELECT
            1 AS a,
            2 AS b,
            3 AS c
    );

SELECT
    'hello',
    untuple((* EXCEPT (b),)),
    'world'
FROM (
        SELECT
            1 AS a,
            2 AS b,
            3 AS c
    );

SELECT argMax(untuple(x))
FROM (
        SELECT (number, number + 1) AS x
        FROM numbers(10)
    );

SELECT
    argMax(untuple(x)),
    min(x)
FROM (
        SELECT (number, number + 1) AS x
        FROM numbers(10)
    )
HAVING tuple(untuple(min(x))).1 != 42;

DROP TABLE IF EXISTS kv;

CREATE TABLE kv
(
    key int,
    v1 int,
    v2 int,
    v3 int,
    v4 int,
    v5 int
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO kv;

SELECT
    key,
    untuple(argMax((* EXCEPT (key),), v1))
FROM kv
GROUP BY key
ORDER BY key ASC
FORMAT TSVWithNames;