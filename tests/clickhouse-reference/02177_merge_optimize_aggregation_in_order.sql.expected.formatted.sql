DROP TABLE IF EXISTS data_02177;

CREATE TABLE data_02177
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO data_02177;

SET optimize_aggregation_in_order = '1';

-- { echoOn }
-- regression for optimize_aggregation_in_order
-- that cause "Chunk should have AggregatedChunkInfo in GroupingAggregatedTransform" error
SELECT count()
FROM remote('127.{1,2}', currentDatabase(), data_02177)
GROUP BY key;

SELECT count()
FROM remote('127.{1,2}', currentDatabase(), data_02177)
GROUP BY key
SETTINGS distributed_aggregation_memory_efficient = '0';

-- { echoOff }
DROP TABLE data_02177;