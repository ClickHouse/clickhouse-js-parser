DROP TABLE IF EXISTS b;

CREATE TABLE b
(
    x Int64,
    y String
)
ENGINE = MergeTree()
ORDER BY (x, y)
SETTINGS index_granularity = '2';

INSERT INTO b;

SELECT count()
FROM b
WHERE x = 1
    AND y = 'b';

DETACH TABLE b;

ATTACH TABLE b;

DROP TABLE b;