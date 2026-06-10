DROP TABLE IF EXISTS x1;

CREATE TABLE x1
(
    i Nullable(int)
)
ENGINE = MergeTree()
PRIMARY KEY i
ORDER BY i DESC
SETTINGS allow_nullable_key = '1', index_granularity = '2', allow_experimental_reverse_key = '1';

INSERT INTO x1 SELECT *
FROM numbers(100);

OPTIMIZE TABLE x1 FINAL;

SELECT *
FROM x1
WHERE i = 3;

SELECT count()
FROM x1
WHERE i >= 3
    AND i <= 10;

DROP TABLE x1;