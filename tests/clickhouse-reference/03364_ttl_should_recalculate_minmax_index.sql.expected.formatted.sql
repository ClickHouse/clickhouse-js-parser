-- { echoOn }
DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    dt DateTime,
    i Int32
)
ENGINE = MergeTree()
ORDER BY dt
PARTITION BY indexHint(dt)
TTL dt + toIntervalDay(15)
SETTINGS index_granularity = '8192';

INSERT INTO x;

OPTIMIZE TABLE x FINAL;

SELECT i
FROM x;

SELECT (minmax_dt).1 = (minmax_dt).2
FROM mergeTreeIndex(currentDatabase(), x, with_minmax = 1);

SELECT (
        SELECT min(dt)
        FROM x
    ) = (
        SELECT minDistinct(dt)
        FROM x
    );

DROP TABLE x;