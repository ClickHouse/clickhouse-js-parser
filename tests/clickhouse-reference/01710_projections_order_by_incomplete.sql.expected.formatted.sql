DROP TABLE IF EXISTS data_proj_order_by_incomp;

CREATE TABLE data_proj_order_by_incomp
(
    t UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

SYSTEM STOP MERGES data_proj_order_by_incomp;

INSERT INTO data_proj_order_by_incomp;

ALTER TABLE data_proj_order_by_incomp ADD PROJECTION tSort (SELECT * ORDER BY t);

INSERT INTO data_proj_order_by_incomp;

-- { echoOn }
SELECT t
FROM data_proj_order_by_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '1';

SELECT t
FROM data_proj_order_by_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '0';

SELECT t
FROM data_proj_order_by_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS max_threads = '1'; -- { echoOff }