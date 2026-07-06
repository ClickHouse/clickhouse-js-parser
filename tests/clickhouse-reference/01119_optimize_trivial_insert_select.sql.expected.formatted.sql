DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    n int,
    a Int64,
    s String
)
ENGINE = MergeTree()
ORDER BY a;

SET enable_positional_arguments = '0';

SET optimize_trivial_insert_select = '1';

SET max_rows_to_read = '0';

-- due to aggregate functions, optimize_trivial_insert_select will not be applied
INSERT INTO t SELECT
    1,
    sum(number) AS c,
    getSetting('max_threads')
FROM numbers_mt(100000000)
SETTINGS
    max_insert_threads = '4',
    max_threads = '2';

-- due to GROUP BY, optimize_trivial_insert_select will not be applied
INSERT INTO t SELECT
    2,
    sum(number) AS c,
    getSetting('max_threads')
FROM numbers_mt(100000000)
GROUP BY 1
SETTINGS
    max_insert_threads = '4',
    max_threads = '2';

INSERT INTO t SELECT
    3,
    sum(number) AS c,
    getSetting('max_threads')
FROM numbers_mt(10000000)
GROUP BY 3
SETTINGS
    max_insert_threads = '4',
    max_threads = '2';

INSERT INTO t SELECT
    4,
    sum(number) AS c,
    getSetting('max_threads') AS mt
FROM numbers_mt(10000000)
GROUP BY mt
SETTINGS
    max_insert_threads = '4',
    max_threads = '2';

SELECT
    n,
    a,
    s
FROM t
ORDER BY n ASC;

DROP TABLE t;