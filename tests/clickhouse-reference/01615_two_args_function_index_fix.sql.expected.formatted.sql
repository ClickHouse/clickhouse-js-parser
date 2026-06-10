DROP TABLE IF EXISTS bad_date_time;

CREATE TABLE bad_date_time
(
    time Datetime('Asia/Istanbul'),
    count UInt16
)
ENGINE = MergeTree()
ORDER BY time;

INSERT INTO bad_date_time;

-- primary key analysis was wrong in previous versions and did not take the timezone argument into account, so empty result was given.
SELECT
    toDate(time, 'UTC') AS dt,
    min(toDateTime(time, 'UTC')),
    max(toDateTime(time, 'UTC')),
    sum(count)
FROM bad_date_time
WHERE toDate(time, 'UTC') = '2020-12-19'
GROUP BY dt;