-- https://github.com/ClickHouse/ClickHouse/issues/39634
SET enable_analyzer = '1';

CREATE TABLE test1
(
    pk String,
    `x.y` Decimal(18, 4)
)
ENGINE = MergeTree()
ORDER BY pk;

CREATE TABLE test2
(
    pk String,
    `x.y` Decimal(18, 4)
)
ENGINE = MergeTree()
ORDER BY pk;

INSERT INTO test1 SELECT
    'pk1',
    1;

INSERT INTO test2 SELECT
    'pk1',
    2;

SELECT
    t1.pk,
    t2.x.y
FROM
    test1 AS t1
LEFT JOIN test2 AS t2
    ON t1.pk = t2.pk;

SELECT
    t1.pk,
    t2.`x.y`
FROM
    test1 AS t1
LEFT JOIN test2 AS t2
    ON t1.pk = t2.pk;