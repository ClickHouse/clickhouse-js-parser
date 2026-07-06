DROP TABLE IF EXISTS crash_02919;

CREATE TABLE crash_02919
(
    b Int64,
    c Nullable(Int64) MATERIALIZED b,
    d Nullable(Bool) MATERIALIZED b
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO crash_02919;

SELECT
    b,
    c,
    d
FROM crash_02919;

ALTER TABLE crash_02919 UPDATE b = 1 WHERE 1 = 1 SETTINGS mutations_sync = '1';

ALTER TABLE crash_02919 UPDATE b = 0.1 WHERE 1 = 1 SETTINGS mutations_sync = '1';

DROP TABLE crash_02919;