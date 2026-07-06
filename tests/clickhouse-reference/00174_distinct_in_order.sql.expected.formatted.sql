-- Tags: stateful
SELECT '-- check that distinct with and w/o optimization produce the same result';

DROP TABLE IF EXISTS distinct_in_order SYNC;

DROP TABLE IF EXISTS ordinary_distinct SYNC;

CREATE TABLE distinct_in_order
(
    CounterID UInt32,
    EventDate Date
)
ENGINE = MergeTree()
ORDER BY (CounterID, EventDate)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO distinct_in_order SELECT DISTINCT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate ASC
SETTINGS optimize_distinct_in_order = '1';

CREATE TABLE ordinary_distinct
(
    CounterID UInt32,
    EventDate Date
)
ENGINE = MergeTree()
ORDER BY (CounterID, EventDate)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO ordinary_distinct SELECT DISTINCT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate ASC
SETTINGS optimize_distinct_in_order = '0';

SELECT DISTINCT *
FROM distinct_in_order
EXCEPT
SELECT *
FROM ordinary_distinct;

INSERT INTO distinct_in_order SELECT DISTINCT
    CounterID,
    EventDate
FROM test.hits
ORDER BY CounterID ASC
SETTINGS optimize_distinct_in_order = '1';

INSERT INTO ordinary_distinct SELECT DISTINCT
    CounterID,
    EventDate
FROM test.hits
ORDER BY CounterID ASC
SETTINGS optimize_distinct_in_order = '0';