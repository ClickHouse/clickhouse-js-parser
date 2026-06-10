DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t3;

DROP TABLE IF EXISTS view1;

CREATE TABLE t1
(
    id UInt32,
    value1 String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t2
(
    id UInt32,
    value2 String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t3
(
    id UInt32,
    value3 String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t1 (id, value1);

INSERT INTO t2 (id, value2);

INSERT INTO t3 (id, value3);

SET enable_optimize_predicate_expression = '1';

SELECT
    t1.id,
    t2.id AS id,
    t3.id AS value
FROM
    (
        SELECT
            number AS id,
            42 AS value
        FROM numbers(4)
    ) AS t1
LEFT JOIN (
        SELECT
            number AS id,
            42 AS value
        FROM numbers(3)
    ) AS t2
    ON t1.id = t2.id
LEFT JOIN (
        SELECT
            number AS id,
            42 AS value
        FROM numbers(2)
    ) AS t3
    ON t1.id = t3.id
WHERE id > 0
    AND value < 42
ORDER BY id ASC;

CREATE VIEW IF NOT EXISTS view1
AS
SELECT
    t1.id AS id,
    t1.value1 AS value1,
    t2.value2 AS value2,
    t3.value3 AS value3
FROM
    t1
LEFT JOIN t2
    ON t1.id = t2.id
LEFT JOIN t3
    ON t1.id = t3.id
WHERE t1.id > 0;

SELECT *
FROM view1
WHERE id = 1
ORDER BY id ASC;