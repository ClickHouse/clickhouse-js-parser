DROP TABLE IF EXISTS test_in_tuple_1;

DROP TABLE IF EXISTS test_in_tuple_2;

DROP TABLE IF EXISTS test_in_tuple;

CREATE TABLE test_in_tuple_1
(
    key Int32,
    key_2 Int32,
    x Array(Int32),
    y Array(Int32)
)
ENGINE = MergeTree()
ORDER BY (key, key_2);

CREATE TABLE test_in_tuple_2
(
    key Int32,
    key_2 Int32,
    x Array(Int32),
    y Array(Int32)
)
ENGINE = MergeTree()
ORDER BY (key, key_2);

CREATE TABLE test_in_tuple AS test_in_tuple_1
ENGINE = Merge(currentDatabase(), '^test_in_tuple_[0-9]+$');

INSERT INTO test_in_tuple_1;

INSERT INTO test_in_tuple_2;

SELECT
    key,
    arr_x,
    arr_y,
    _table
FROM
    test_in_tuple
LEFT ARRAY JOIN x AS arr_x, y AS arr_y
ORDER BY
    _table ASC,
    arr_x ASC,
    arr_y ASC;

SELECT
    key,
    arr_x,
    arr_y,
    _table
FROM
    test_in_tuple
LEFT ARRAY JOIN x AS arr_x, y AS arr_y
WHERE (key_2, arr_x, arr_y) IN (1, 1, 1)
ORDER BY
    _table ASC,
    arr_x ASC,
    arr_y ASC;

SELECT
    key,
    arr_x,
    arr_y,
    _table
FROM
    test_in_tuple
LEFT ARRAY JOIN arrayFilter(((t, x_0, x_1) -> (key_2, x_0, x_1) IN (1, 1, 1)), x, x, y) AS arr_x, arrayFilter(((t, x_0, x_1) -> (key_2, x_0, x_1) IN (1, 1, 1)), y, x, y) AS arr_y
WHERE (key_2, arr_x, arr_y) IN (1, 1, 1)
ORDER BY
    _table ASC,
    arr_x ASC,
    arr_y ASC;