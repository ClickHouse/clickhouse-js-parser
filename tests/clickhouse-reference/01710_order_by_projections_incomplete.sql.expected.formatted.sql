DROP TABLE IF EXISTS data_order_by_proj_incomp;

CREATE TABLE data_order_by_proj_incomp
(
    t UInt64
)
ENGINE = MergeTree()
ORDER BY t;

SYSTEM STOP MERGES data_order_by_proj_incomp;

INSERT INTO data_order_by_proj_incomp;

ALTER TABLE data_order_by_proj_incomp ADD PROJECTION tSort (SELECT * ORDER BY t);

INSERT INTO data_order_by_proj_incomp;

-- { echoOn }
SELECT t
FROM data_order_by_proj_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '1';

SELECT t
FROM data_order_by_proj_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS optimize_read_in_order = '0';

SELECT t
FROM data_order_by_proj_incomp
WHERE t > 0
ORDER BY t ASC
SETTINGS max_threads = '1'; -- { echoOff }