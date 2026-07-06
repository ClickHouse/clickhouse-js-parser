SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS test_empty;

CREATE TABLE test_empty
(
    a Array(Int64)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_empty;

SELECT arraySort(groupArrayIntersect(*))
FROM test_empty;

INSERT INTO test_empty;

DROP TABLE test_empty;

DROP TABLE IF EXISTS test_null;

CREATE TABLE test_null
(
    a Array(Nullable(Int64))
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS allow_nullable_key = '1';

INSERT INTO test_null;

SELECT arraySort(groupArrayIntersect(*))
FROM test_null;

INSERT INTO test_null;

INSERT INTO test_null;

DROP TABLE test_null;

DROP TABLE IF EXISTS test_nested_arrays;

CREATE TABLE test_nested_arrays
(
    a Array(Array(Int64))
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_nested_arrays;

INSERT INTO test_nested_arrays;

SELECT arraySort(groupArrayIntersect(*))
FROM test_nested_arrays;

INSERT INTO test_nested_arrays;

DROP TABLE test_nested_arrays;

DROP TABLE IF EXISTS test_numbers;

CREATE TABLE test_numbers
(
    a Array(Int64)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_numbers;

INSERT INTO test_numbers;

INSERT INTO test_numbers;

SELECT arraySort(groupArrayIntersect(*))
FROM test_numbers;

INSERT INTO test_numbers;

DROP TABLE test_numbers;

DROP TABLE IF EXISTS test_big_numbers_sep;

CREATE TABLE test_big_numbers_sep
(
    a Array(Int64)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_big_numbers_sep SELECT array(number)
FROM numbers_mt(100000);

SELECT arraySort(groupArrayIntersect(*))
FROM test_big_numbers_sep;

DROP TABLE test_big_numbers_sep;

DROP TABLE IF EXISTS test_big_numbers;

CREATE TABLE test_big_numbers
(
    a Array(Int64)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_big_numbers SELECT range(100000);

SELECT length(groupArrayIntersect(*))
FROM test_big_numbers;

INSERT INTO test_big_numbers SELECT range(99999);

INSERT INTO test_big_numbers;

SELECT arraySort(groupArrayIntersect(*))
FROM test_big_numbers;

DROP TABLE test_big_numbers;

DROP TABLE IF EXISTS test_string;

CREATE TABLE test_string
(
    a Array(String)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_string;

INSERT INTO test_string;

INSERT INTO test_string;

SELECT arraySort(groupArrayIntersect(*))
FROM test_string;

DROP TABLE test_string;

DROP TABLE IF EXISTS test_big_string;

CREATE TABLE test_big_string
(
    a Array(String)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_big_string SELECT groupArray(toString(number))
FROM numbers_mt(50000);

SELECT length(groupArrayIntersect(*))
FROM test_big_string;

INSERT INTO test_big_string SELECT groupArray(toString(number))
FROM numbers_mt(49999);

INSERT INTO test_big_string;

SELECT arraySort(groupArrayIntersect(*))
FROM test_big_string;

INSERT INTO test_big_string;

DROP TABLE test_big_string;

DROP TABLE IF EXISTS test_datetime;

CREATE TABLE test_datetime
(
    a Array(DateTime)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_datetime;

INSERT INTO test_datetime;

SELECT arraySort(groupArrayIntersect(*))
FROM test_datetime;

DROP TABLE test_datetime;

DROP TABLE IF EXISTS test_date32;

CREATE TABLE test_date32
(
    a Array(Date32)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_date32;

SELECT arraySort(groupArrayIntersect(*))
FROM test_date32;

DROP TABLE test_date32;

DROP TABLE IF EXISTS test_date;

CREATE TABLE test_date
(
    a Array(Date)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test_date;

SELECT arraySort(groupArrayIntersect(*))
FROM test_date;

DROP TABLE test_date;