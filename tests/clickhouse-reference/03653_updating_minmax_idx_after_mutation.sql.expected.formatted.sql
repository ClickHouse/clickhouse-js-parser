DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    time DateTime
)
ENGINE = MergeTree()
ORDER BY ()
PARTITION BY toYYYYMM(time);

INSERT INTO test;

SELECT max_time
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test'
    AND active;

SET mutations_sync = '1';

ALTER TABLE test DELETE WHERE time >= '2000-01-01 02:00:00';

DROP TABLE test;