DROP TABLE IF EXISTS open_events_tmp;

DROP TABLE IF EXISTS tracking_events_tmp;

CREATE TABLE open_events_tmp
(
    APIKey UInt32,
    EventDate Date
)
ENGINE = MergeTree()
ORDER BY (APIKey, EventDate)
PARTITION BY toMonday(EventDate);

CREATE TABLE tracking_events_tmp
(
    APIKey UInt32,
    EventDate Date
)
ENGINE = MergeTree()
ORDER BY (APIKey, EventDate)
PARTITION BY toYYYYMM(EventDate);

INSERT INTO open_events_tmp SELECT
    2,
    '2020-07-10'
FROM numbers(32);

INSERT INTO open_events_tmp SELECT
    2,
    '2020-07-11'
FROM numbers(31);

INSERT INTO open_events_tmp SELECT
    2,
    '2020-07-12'
FROM numbers(30);

INSERT INTO tracking_events_tmp SELECT
    2,
    '2020-07-09'
FROM numbers(1555);

INSERT INTO tracking_events_tmp SELECT
    2,
    '2020-07-10'
FROM numbers(1881);

INSERT INTO tracking_events_tmp SELECT
    2,
    '2020-07-11'
FROM numbers(1623);

SELECT EventDate
FROM
    (
        SELECT EventDate
        FROM tracking_events_tmp AS t1
        WHERE EventDate >= toDate('2020-07-09')
            AND EventDate <= toDate('2020-07-11')
            AND APIKey = 2
        GROUP BY EventDate
    )
FULL JOIN (
        SELECT EventDate
        FROM remote('127.0.0.{1,3}', currentDatabase(), open_events_tmp) AS t2
        WHERE EventDate <= toDate('2020-07-12')
            AND APIKey = 2
        GROUP BY EventDate
        WITH TOTALS
    )
    USING (EventDate)
ORDER BY EventDate ASC
SETTINGS
    totals_mode = 'after_having_auto',
    group_by_overflow_mode = 'any',
    max_rows_to_group_by = '10000000',
    joined_subquery_requires_alias = '0';

DROP TABLE open_events_tmp;

DROP TABLE tracking_events_tmp;