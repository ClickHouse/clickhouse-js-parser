-- Cache is only for MergeTree
DROP TABLE IF EXISTS t_mem;

CREATE TABLE t_mem
(
    key Int
)
ENGINE = Memory();

INSERT INTO t_mem;

SELECT columns_descriptions_cache_size
FROM `system`.tables
WHERE database = currentDatabase()
    AND table = 't_mem';

-- MergeTree
DROP TABLE IF EXISTS t_mt;

-- { echoOn }
CREATE TABLE t_mt
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ();

SELECT columns_descriptions_cache_size
FROM `system`.tables
WHERE database = currentDatabase()
    AND table = 't_mt';

INSERT INTO t_mt;

INSERT INTO t_mt;

ALTER TABLE t_mt ADD COLUMN value String SETTINGS mutations_sync = '2';

INSERT INTO t_mt;

INSERT INTO t_mt;

-- now let's try to remove ColumnsDescription with old structure
ALTER TABLE t_mt DETACH PART 'all_1_1_0';

ALTER TABLE t_mt DETACH PART 'all_2_2_0';

-- reattach
DETACH TABLE t_mt;

ATTACH TABLE t_mt;

-- system.metrics
SELECT value > 0
FROM `system`.metrics
WHERE metric = 'ColumnsDescriptionsCacheSize';