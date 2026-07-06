DROP TABLE IF EXISTS data_order_by_proj_comp;

CREATE TABLE data_order_by_proj_comp
(
    t UInt64,
    PROJECTION tSort (SELECT * ORDER BY t)
)
ENGINE = MergeTree()
ORDER BY t;

SYSTEM STOP MERGES data_order_by_proj_comp;

INSERT INTO data_order_by_proj_comp;

INSERT INTO data_order_by_proj_comp;

-- { echoOn }
SELECT t
FROM data_order_by_proj_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '1';

SELECT t
FROM data_order_by_proj_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '0';

SELECT t
FROM data_order_by_proj_comp
WHERE t > 0
ORDER BY t ASC
SETTINGS max_threads = '1'; -- { echoOff }