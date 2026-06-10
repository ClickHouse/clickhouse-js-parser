SET send_logs_level = 'fatal';

CREATE TABLE test_table
(
    n Int32,
    s String
)
ENGINE = MergeTree()
ORDER BY n
PARTITION BY n;

CREATE TABLE mview_backend
(
    n Int32,
    n2 Int64
)
ENGINE = MergeTree()
ORDER BY n
PARTITION BY n;

CREATE MATERIALIZED VIEW mview
TO mview_backend
AS
SELECT
    n,
    n * n AS n2
FROM test_table;

DROP TABLE test_table;

DETACH TABLE mview;

/* Check that we don't get an exception with the option. */
ATTACH TABLE mview;

INSERT INTO test_table;

SELECT
    n,
    s
FROM test_table
ORDER BY n ASC;

SELECT
    n,
    n2
FROM mview
ORDER BY n ASC;