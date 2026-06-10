-- Test from https://github.com/ClickHouse/ClickHouse/issues/37673
DROP TABLE IF EXISTS data_proj_order_by_comp;

CREATE TABLE data_proj_order_by_comp
(
    t UInt64,
    PROJECTION tSort (SELECT * ORDER BY t)
)
ENGINE = MergeTree()
ORDER BY tuple();

SYSTEM STOP MERGES data_proj_order_by_comp;

INSERT INTO data_proj_order_by_comp;

INSERT INTO data_proj_order_by_comp;

-- { echoOn }
SELECT t
FROM data_proj_order_by_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '1';

SELECT t
FROM data_proj_order_by_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '0';

SELECT t
FROM data_proj_order_by_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS max_threads = '1'; -- { echoOff }