SET allow_deprecated_syntax_for_merge_tree = '1';

SET max_threads = '1';

SET max_insert_threads = '1';

DROP TABLE IF EXISTS test_ins_arr;

CREATE TABLE test_ins_arr
(
    date Date,
    val Array(UInt64)
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_arr SELECT
    toDate('2017-10-02'),
    [number, 42]
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_arr
LIMIT 10;

DROP TABLE test_ins_arr;

DROP TABLE IF EXISTS test_ins_null;

CREATE TABLE test_ins_null
(
    date Date,
    val Nullable(UInt64)
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_null SELECT
    toDate('2017-10-02'),
    if(number % 2, number, NULL)
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_null
LIMIT 10;

DROP TABLE test_ins_null;

DROP TABLE IF EXISTS test_ins_arr_null;

CREATE TABLE test_ins_arr_null
(
    date Date,
    val Array(Nullable(UInt64))
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_arr_null SELECT
    toDate('2017-10-02'),
    [if(number % 2, number, NULL), number, NULL]
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_arr_null
LIMIT 10;

DROP TABLE test_ins_arr_null;

DROP TABLE IF EXISTS test_ins_arr_arr;

CREATE TABLE test_ins_arr_arr
(
    date Date,
    val Array(Array(UInt64))
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_arr_arr SELECT
    toDate('2017-10-02'),
    [[number], [number + 1, number + 2]]
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_arr_arr
LIMIT 10;

DROP TABLE test_ins_arr_arr;

DROP TABLE IF EXISTS test_ins_arr_arr_null;

CREATE TABLE test_ins_arr_arr_null
(
    date Date,
    val Array(Array(Nullable(UInt64)))
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_arr_arr_null SELECT
    toDate('2017-10-02'),
    [[1, NULL, number], [3, NULL, number]]
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_arr_arr_null
LIMIT 10;

DROP TABLE test_ins_arr_arr_null;

DROP TABLE IF EXISTS test_ins_arr_arr_arr;

CREATE TABLE test_ins_arr_arr_arr
(
    date Date,
    val Array(Array(Array(UInt64)))
)
ENGINE = MergeTree(date, date, 8192);

INSERT INTO test_ins_arr_arr_arr SELECT
    toDate('2017-10-02'),
    [[[number]], [[number + 1], [number + 2, number + 3]]]
FROM `system`.numbers
LIMIT 10000;

SELECT *
FROM test_ins_arr_arr_arr
LIMIT 10;

DROP TABLE test_ins_arr_arr_arr;