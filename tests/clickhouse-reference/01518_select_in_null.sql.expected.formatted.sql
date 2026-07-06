DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    cA String,
    c1 String
)
ENGINE = MergeTree()
ORDER BY (cA, c1);

INSERT INTO t1 SELECT
    'AAAAAAAAAAA',
    'BBBBBB';

SELECT count()
FROM t1
WHERE c1 IN (
        SELECT 'BBBBBB'
        UNION ALL
        SELECT NULL
    );

SELECT count()
FROM t1
WHERE CAST(c1 AS Nullable(String)) IN (
        SELECT 'BBBBBB'
        UNION ALL
        SELECT NULL
    );

DROP TABLE t1;