DROP TABLE IF EXISTS data_02176;

CREATE TABLE data_02176
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

SET optimize_aggregation_in_order = '1';

-- { echoOn }
-- regression for optimize_aggregation_in_order with empty result set
-- that cause at first
--   "Chunk should have AggregatedChunkInfo in GroupingAggregatedTransform"
-- at first and after
--   "Chunk should have AggregatedChunkInfo in GroupingAggregatedTransform"
SELECT count()
FROM remote('127.{1,2}', currentDatabase(), data_02176)
WHERE key = 0
GROUP BY key;

SELECT count()
FROM remote('127.{1,2}', currentDatabase(), data_02176)
WHERE key = 0
GROUP BY key
SETTINGS distributed_aggregation_memory_efficient = '0';

-- { echoOff }
DROP TABLE data_02176;