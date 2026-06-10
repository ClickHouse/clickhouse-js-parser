DROP TABLE IF EXISTS a8x;

SET empty_result_for_aggregation_by_empty_set = '1';

CREATE TABLE a8x
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0' AS
SELECT number
FROM `system`.numbers
LIMIT 100;

SELECT count()
FROM a8x;

SET mutations_sync = '1';

ALTER TABLE a8x UPDATE number = 0 WHERE number = -3;