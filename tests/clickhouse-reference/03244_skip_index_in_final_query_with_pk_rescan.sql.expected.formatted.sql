-- Tags: long, no-tsan, no-asan, no-msan, no-s3-storage
SET use_skip_indexes = '1';

SET use_skip_indexes_if_final = '1';

DROP TABLE IF EXISTS t_final_query_tbl;

CREATE TABLE t_final_query_tbl
(
    id UInt64,
    v UInt64,
    INDEX secondaryidx v TYPE minmax() GRANULARITY 1
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

SYSTEM STOP MERGES t_final_query_tbl;

INSERT INTO t_final_query_tbl SELECT
    number,
    if(number = 100444, 98889991, number)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl SELECT
    number,
    if(number = 100444, 88889992, number + 1)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl SELECT
    number,
    if(number = 100444, 78889993, number + 1)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl SELECT
    number,
    if(number = 100444, 68889994, number + 1)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl SELECT
    number,
    if(number = 100444, 58889995, number + 1)
FROM numbers(1000000);

SELECT count(id)
FROM t_final_query_tbl FINAL
WHERE v = 98889991
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id)
FROM t_final_query_tbl FINAL
WHERE v = 88889992
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id)
FROM t_final_query_tbl FINAL
WHERE v = 78889993
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id)
FROM t_final_query_tbl FINAL
WHERE v = 68889994
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id)
FROM t_final_query_tbl FINAL
WHERE v = 58889995
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

DROP TABLE t_final_query_tbl;

DROP TABLE IF EXISTS t_final_query_tbl2;

CREATE TABLE t_final_query_tbl2
(
    id1 String,
    id2 UInt64,
    id3 DateTime,
    v UInt64,
    INDEX secondaryidx v TYPE minmax() GRANULARITY 1
)
ENGINE = ReplacingMergeTree()
ORDER BY (id1, id2, id3);

SYSTEM STOP MERGES t_final_query_tbl2;

INSERT INTO t_final_query_tbl2 SELECT
    substr(lower(hex(MD5(toString(trunc(number / 1000))))), 1, 10),
    trunc(number % 100),
    toDateTime(number),
    if(number = 100444, 98889991, number)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl2 SELECT
    substr(lower(hex(MD5(toString(trunc(number / 1000))))), 1, 10),
    trunc(number % 100),
    toDateTime(number),
    if(number = 100444, 88889992, number)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl2 SELECT
    substr(lower(hex(MD5(toString(trunc(number / 1000))))), 1, 10),
    trunc(number % 100),
    toDateTime(number),
    if(number = 100444, 78889993, number)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl2 SELECT
    substr(lower(hex(MD5(toString(trunc(number / 1000))))), 1, 10),
    trunc(number % 100),
    toDateTime(number),
    if(number = 100444, 68889994, number)
FROM numbers(1000000);

INSERT INTO t_final_query_tbl2 SELECT
    substr(lower(hex(MD5(toString(trunc(number / 1000))))), 1, 10),
    trunc(number % 100),
    toDateTime(number),
    if(number = 100444, 58889995, number)
FROM numbers(1000000);

SELECT count(id1)
FROM t_final_query_tbl2 FINAL
WHERE v = 98889991
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id1)
FROM t_final_query_tbl2 FINAL
WHERE v = 88889992
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id1)
FROM t_final_query_tbl2 FINAL
WHERE v = 78889993
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id1)
FROM t_final_query_tbl2 FINAL
WHERE v = 68889994
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

SELECT count(id1)
FROM t_final_query_tbl2 FINAL
WHERE v = 58889995
SETTINGS use_skip_indexes_if_final_exact_mode = '1';

DROP TABLE t_final_query_tbl2;