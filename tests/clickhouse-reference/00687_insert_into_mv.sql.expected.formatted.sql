DROP TABLE IF EXISTS test_00687;

DROP TABLE IF EXISTS mv_bad;

DROP TABLE IF EXISTS mv_good;

DROP TABLE IF EXISTS mv_group;

CREATE TABLE test_00687
(
    x String
)
ENGINE = Null();

CREATE MATERIALIZED VIEW mv_bad
(
    x String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
AS
SELECT DISTINCT x
FROM test_00687;

CREATE MATERIALIZED VIEW mv_good
(
    x String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
AS
SELECT x
FROM test_00687;

CREATE MATERIALIZED VIEW mv_group
(
    x String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
AS
SELECT x
FROM test_00687
GROUP BY x;

INSERT INTO test_00687;

SELECT *
FROM mv_bad;

SELECT '---';

SELECT *
FROM mv_good;

SELECT *
FROM mv_group;

DROP TABLE mv_bad;

DROP TABLE mv_good;

DROP TABLE mv_group;

DROP TABLE test_00687;