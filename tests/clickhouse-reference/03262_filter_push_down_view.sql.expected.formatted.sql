-- add_minmax_index_for_numeric_columns=0: Different plan
DROP TABLE IF EXISTS alpha;

DROP TABLE IF EXISTS alpha__day;

SET session_timezone = 'Etc/UTC';

CREATE TABLE alpha
(
    ts DateTime64(6),
    auid Int64
)
ENGINE = MergeTree()
ORDER BY (auid, ts)
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

CREATE VIEW alpha__day (ts_date Date, auid Int64)
AS
SELECT
    ts_date,
    auid
FROM (
        SELECT
            toDate(ts) AS ts_date,
            auid
        FROM alpha
    )
WHERE ts_date <= toDateTime('2024-01-01 00:00:00') - toIntervalDay(1);

INSERT INTO alpha;

INSERT INTO alpha;

INSERT INTO alpha;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT auid
                FROM alpha__day
                WHERE auid = 1
            ))
    )
WHERE `explain` LIKE '%Condition:%'
    OR `explain` LIKE '%Granules:%'
SETTINGS enable_analyzer = '1';