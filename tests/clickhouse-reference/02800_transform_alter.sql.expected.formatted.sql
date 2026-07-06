DROP TABLE IF EXISTS test_xy;

DROP TABLE IF EXISTS updates;

CREATE TABLE test_xy
(
    x Int32,
    y String
)
ENGINE = MergeTree()
ORDER BY x;

CREATE TABLE updates
(
    x Int32,
    y String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO test_xy (x, y);

INSERT INTO updates (x, y);

SELECT
    x,
    y,
    transform(x, (
        SELECT groupArray(x)
        FROM (
                SELECT
                    x,
                    y
                FROM updates
                ORDER BY x ASC
            ) AS t1
    ), (
        SELECT groupArray(y)
        FROM (
                SELECT
                    x,
                    y
                FROM updates
                ORDER BY x ASC
            ) AS t2
    ), y)
FROM test_xy
WHERE 1
ORDER BY
    x ASC,
    y ASC;

SET mutations_sync = '1';

ALTER TABLE test_xy UPDATE y = transform(x, (
    SELECT groupArray(x)
    FROM (
            SELECT
                x,
                y
            FROM updates
            ORDER BY x ASC
        ) AS t1
), (
    SELECT groupArray(y)
    FROM (
            SELECT
                x,
                y
            FROM updates
            ORDER BY x ASC
        ) AS t2
), y) WHERE 1;

SELECT *
FROM test_xy
ORDER BY
    x ASC,
    y ASC;

DROP TABLE test_xy;

DROP TABLE updates;