-- https://github.com/ClickHouse/ClickHouse/issues/4596
SET enable_analyzer = '1';

CREATE TABLE a1
(
    ANIMAL Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO a1;

SELECT count()
FROM
    a1 AS a
INNER JOIN a1 AS b
    ON a.ANIMAL = b.ANIMAL
INNER JOIN a1 AS c
    ON c.ANIMAL = b.ANIMAL
WHERE a.ANIMAL = 'CROCO';

SELECT count()
FROM
    a1 AS a
INNER JOIN a1 AS b
    ON a.ANIMAL = b.ANIMAL
INNER JOIN a1 AS c
    ON c.ANIMAL = b.ANIMAL
PREWHERE a.ANIMAL = 'CROCO';