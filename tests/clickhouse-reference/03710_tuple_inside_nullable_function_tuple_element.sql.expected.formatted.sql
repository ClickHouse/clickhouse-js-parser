SET allow_experimental_nullable_tuple_type = '1';

WITH (
        SELECT tuple('1', toDateTime64('2024-01-01 00:00:00', 6, 'UTC'), 3)
    ) AS result

SELECT
    (result).1,
    (result).2,
    (result).3;

SELECT tupleElement(CAST(NULL AS Nullable(Tuple(Int32, String))), 1);

SELECT toTypeName(tupleElement(CAST(NULL AS Nullable(Tuple(Int32, String))), 1));

SELECT tupleElement(CAST((1, 'hello') AS Nullable(Tuple(Int32, String))), 2);

SELECT toTypeName(tupleElement(CAST((1, 'hello') AS Nullable(Tuple(Int32, String))), 2));

SELECT tupleElement([CAST((1, 'a') AS Nullable(Tuple(Int32, String))), NULL], 1);

SELECT toTypeName(tupleElement([CAST((1, 'a') AS Nullable(Tuple(Int32, String))), NULL], 1));

SELECT tupleElement([CAST(([1, 2, 3], 'a') AS Nullable(Tuple(Array(Int32), String))), CAST(NULL AS Nullable(Tuple(Array(Int32), String))), NULL], 1);

SELECT toTypeName(tupleElement([CAST(([1, 2, 3], 'a') AS Nullable(Tuple(Array(Int32), String))), CAST(NULL AS Nullable(Tuple(Array(Int32), String))), NULL], 1));

SELECT tupleElement(CAST(NULL AS Nullable(Tuple(Int8, String))), 3); -- { serverError NOT_FOUND_COLUMN_IN_BLOCK }

SELECT tupleElement(CAST([(1, 7), (3, 4), (2, 8)] AS Array(Nullable(Tuple(x Int8, y Int8)))), 'y');

SELECT toTypeName(tupleElement(CAST([(1, 7), (3, 4), (2, 8)] AS Array(Nullable(Tuple(x Int8, y Int8)))), 'y'));

WITH data AS (
    SELECT [CAST((1, 7) AS Nullable(Tuple(x Int8, y Int8))), NULL, CAST((2, 8) AS Nullable(Tuple(x Int8, y Int8)))] AS arr
)

SELECT tupleElement(arr, 'y')
FROM data;

SELECT tupleElement([CAST((1, 'a') AS Nullable(Tuple(Nullable(Int32), String))), NULL], 1);

SELECT toTypeName(tupleElement([CAST((1, 'a') AS Nullable(Tuple(Nullable(Int32), String))), NULL], 1));

SELECT tupleElement(CAST((1, 'hello') AS Nullable(Tuple(Int32, String))), 5, 'default_value');

SELECT toTypeName(tupleElement(CAST((1, 'hello') AS Nullable(Tuple(Int32, String))), 5, 'default_value'));

SELECT tupleElement(CAST(NULL AS Nullable(Tuple(Int32, String))), 1, 999);

SELECT toTypeName(tupleElement(CAST(NULL AS Nullable(Tuple(Int32, String))), 1, 999));

SELECT tupleElement(CAST(((1, 'inner'), 'outer') AS Nullable(Tuple(Tuple(Int32, String), String))), 1);

SELECT toTypeName(tupleElement(CAST(((1, 'inner'), 'outer') AS Nullable(Tuple(Tuple(Int32, String), String))), 1));

SELECT tupleElement(CAST(NULL AS Nullable(Tuple(Tuple(Int32, String), String))), 1);

SELECT toTypeName(tupleElement(CAST(NULL AS Nullable(Tuple(Tuple(Int32, String), String))), 1));

SELECT tupleElement((1, CAST(NULL AS Nullable(String))), 2);

SELECT toTypeName(tupleElement((1, CAST(NULL AS Nullable(String))), 2));

SELECT tupleElement([[CAST((1, 'a') AS Nullable(Tuple(Int32, String))), NULL], [NULL, CAST((2, 'b') AS Nullable(Tuple(Int32, String)))]], 1);

SELECT toTypeName(tupleElement([[CAST((1, 'a') AS Nullable(Tuple(Int32, String))), NULL], [NULL, CAST((2, 'b') AS Nullable(Tuple(Int32, String)))]], 1));

SELECT tupleElement(CAST(tuple() AS Nullable(Tuple)), 1); -- { serverError NOT_FOUND_COLUMN_IN_BLOCK }

SELECT tupleElement([CAST(NULL AS Nullable(Tuple(Int32, String))), NULL, NULL], 1);

SELECT toTypeName(tupleElement([CAST(NULL AS Nullable(Tuple(Int32, String))), NULL, NULL], 1));

SELECT tupleElement(CAST((1, 'hello') AS Nullable(Tuple(x Int32, y String))), 'z', 'default');

SELECT toTypeName(tupleElement(CAST((1, 'hello') AS Nullable(Tuple(x Int32, y String))), 'z', 'default'));

SELECT tupleElement(CAST((1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AS Nullable(Tuple(Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32))), 10);

SELECT toTypeName(tupleElement(CAST((1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AS Nullable(Tuple(Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32))), 10));

SELECT tupleElement(materialize(CAST((42, 'const') AS Nullable(Tuple(Int32, String)))), 1)
FROM numbers(3);

SELECT toTypeName(tupleElement(materialize(CAST((42, 'const') AS Nullable(Tuple(Int32, String)))), 1))
FROM numbers(3);

SELECT
    tupleElement(CAST((1, 'hello', 3.14) AS Nullable(Tuple(Int32, String, Float64))), 1) AS `first`,
    tupleElement(CAST((1, 'hello', 3.14) AS Nullable(Tuple(Int32, String, Float64))), 2) AS second,
    tupleElement(CAST((1, 'hello', 3.14) AS Nullable(Tuple(Int32, String, Float64))), 3) AS third;

SELECT *
FROM (
        SELECT CAST((number, toString(number)) AS Nullable(Tuple(Int32, String))) AS t
        FROM numbers(5)
    )
WHERE tupleElement(t, 1) > 2;

SELECT tupleElement(CAST(NULL AS Nullable(Tuple(Int32, String))), 1) + 10;

SELECT
    sum(tupleElement(t, 1)) AS sum_first,
    count(tupleElement(t, 1)) AS count_first
FROM (
        SELECT CAST((number, toString(number)) AS Nullable(Tuple(Int32, String))) AS t
        FROM numbers(10)
    );

SELECT tupleElement([CAST((1, 'a') AS Nullable(Tuple(Int32, String))), NULL, CAST((2, 'b') AS Nullable(Tuple(Int32, String))), NULL, CAST((3, 'c') AS Nullable(Tuple(Int32, String)))], 2);

DROP TABLE IF EXISTS test_nullable_tuples;

DROP TABLE IF EXISTS test_array_nullable_tuples;

DROP TABLE IF EXISTS test_nullable_named_tuples;

DROP TABLE IF EXISTS test_complex_nullable;

CREATE TABLE test_nullable_tuples
(
    id UInt32,
    data Nullable(Tuple(Int32, String))
)
ENGINE = Memory();

INSERT INTO test_nullable_tuples;

SELECT
    id,
    tupleElement(data, 1) AS value,
    toTypeName(tupleElement(data, 1)) AS type
FROM test_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(data, 2) AS value,
    toTypeName(tupleElement(data, 2)) AS type
FROM test_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(data, 1) AS value
FROM test_nullable_tuples
WHERE tupleElement(data, 1) > 200
ORDER BY id ASC;

SELECT
    count() AS total,
    count(tupleElement(data, 1)) AS non_null_count,
    countIf(tupleElement(data, 1) IS NULL) AS null_count
FROM test_nullable_tuples;

SELECT
    sum(tupleElement(data, 1)) AS sum_values,
    avg(tupleElement(data, 1)) AS avg_values,
    min(tupleElement(data, 1)) AS min_value,
    max(tupleElement(data, 1)) AS max_value,
    count(tupleElement(data, 1)) AS count_non_null
FROM test_nullable_tuples;

CREATE TABLE test_array_nullable_tuples
(
    id UInt32,
    records Array(Nullable(Tuple(Int32, String)))
)
ENGINE = Memory();

INSERT INTO test_array_nullable_tuples;

SELECT
    id,
    tupleElement(records, 1) AS values,
    toTypeName(tupleElement(records, 1)) AS type
FROM test_array_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(records, 2) AS values,
    toTypeName(tupleElement(records, 2)) AS type
FROM test_array_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(record, 1) AS value,
    tupleElement(record, 2) AS name
FROM
    test_array_nullable_tuples
ARRAY JOIN records AS record
WHERE record IS NOT NULL
ORDER BY
    id ASC,
    value ASC;

CREATE TABLE test_nullable_named_tuples
(
    id UInt32,
    person Nullable(Tuple(name String, age UInt8, salary Float64))
)
ENGINE = Memory();

INSERT INTO test_nullable_named_tuples;

SELECT
    id,
    tupleElement(person, 'name') AS name,
    tupleElement(person, 'age') AS age,
    tupleElement(person, 'salary') AS salary,
    toTypeName(tupleElement(person, 'name')) AS name_type
FROM test_nullable_named_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(person, 1) AS name,
    tupleElement(person, 2) AS age,
    tupleElement(person, 3) AS salary
FROM test_nullable_named_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(person, 'name') AS name,
    tupleElement(person, 'salary') AS salary
FROM test_nullable_named_tuples
WHERE tupleElement(person, 'salary') > 55000
ORDER BY id ASC;

SELECT
    avg(tupleElement(person, 'age')) AS avg_age,
    sum(tupleElement(person, 'salary')) AS total_salary,
    count(tupleElement(person, 'name')) AS count_people
FROM test_nullable_named_tuples;

SELECT
    t1.id AS id1,
    t2.id AS id2,
    tupleElement(t1.data, 1) AS value1,
    tupleElement(t2.data, 1) AS value2
FROM
    test_nullable_tuples AS t1
INNER JOIN test_nullable_tuples AS t2
    ON tupleElement(t1.data, 1) = tupleElement(t2.data, 1)
WHERE t1.id < t2.id
ORDER BY
    t1.id ASC,
    t2.id ASC;

SELECT
    tupleElement(data, 2) AS category,
    count() AS cnt,
    avg(tupleElement(data, 1)) AS avg_value
FROM test_nullable_tuples
WHERE data IS NOT NULL
GROUP BY category
ORDER BY category ASC;

SELECT
    id,
    tupleElement(data, 1) AS value
FROM test_nullable_tuples
WHERE id IN (
        SELECT id
        FROM test_nullable_tuples
        WHERE tupleElement(data, 1) > 100
    )
ORDER BY id ASC;

SELECT
    id,
    multiIf(tupleElement(data, 1) IS NULL, 'null', tupleElement(data, 1) > 200, 'high', tupleElement(data, 1) > 100, 'medium', 'low') AS category
FROM test_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(data, 1, 999) AS value
FROM test_nullable_tuples
ORDER BY id ASC;

SELECT
    id,
    tupleElement(data, 5, 'default_string') AS value
FROM test_nullable_tuples
ORDER BY id ASC;

CREATE TABLE test_complex_nullable
(
    id UInt32,
    matrix Array(Array(Nullable(Tuple(x Int32, y Int32))))
)
ENGINE = Memory();

INSERT INTO test_complex_nullable;

SELECT
    id,
    tupleElement(matrix, 'x') AS x_values,
    toTypeName(tupleElement(matrix, 'x')) AS type
FROM test_complex_nullable
ORDER BY id ASC;

SELECT
    id,
    tupleElement(matrix, 'y') AS y_values
FROM test_complex_nullable
ORDER BY id ASC;

SELECT
    id,
    value,
    row_number() OVER (ORDER BY value ASC NULLS LAST, id ASC) AS rank,
    dense_rank() OVER (ORDER BY value ASC NULLS LAST) AS dense_rank
FROM (
        SELECT
            id,
            tupleElement(data, 1) AS value
        FROM test_nullable_tuples
    )
ORDER BY rank ASC;

SELECT DISTINCT tupleElement(data, 2) AS category
FROM test_nullable_tuples
WHERE tupleElement(data, 2) IS NOT NULL
ORDER BY category ASC;

SELECT value
FROM (
        SELECT tupleElement(data, 1) AS value
        FROM test_nullable_tuples
        WHERE id <= 2
        UNION ALL
        SELECT tupleElement(data, 1) AS value
        FROM test_nullable_tuples
        WHERE id >= 4
    )
ORDER BY value ASC NULLS LAST;

SELECT
    id,
    tupleElement(data, 1) AS value
FROM test_nullable_tuples
WHERE tupleElement(data, 1) IN (100, 300, 500)
ORDER BY id ASC;

SELECT
    id,
    tupleElement(data, 1) AS value,
    tupleElement(data, 2) AS name
FROM test_nullable_tuples
ORDER BY
    tupleElement(data, 1) ASC NULLS LAST,
    id ASC;