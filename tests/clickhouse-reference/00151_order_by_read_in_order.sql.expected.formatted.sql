-- Tags: stateful
SET optimize_read_in_order = '1';

SELECT CounterID
FROM test.hits
ORDER BY CounterID DESC
LIMIT 50;

SELECT CounterID
FROM test.hits
ORDER BY CounterID ASC
LIMIT 50;

SELECT CounterID
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate ASC
LIMIT 50;

SELECT EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate ASC
LIMIT 50;

SELECT EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate DESC
LIMIT 50;

SELECT CounterID
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate DESC
LIMIT 50;

SELECT CounterID
FROM test.hits
ORDER BY
    CounterID DESC,
    EventDate DESC
LIMIT 50;

SELECT EventDate
FROM test.hits
ORDER BY
    CounterID DESC,
    EventDate DESC
LIMIT 50;

SELECT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate ASC
LIMIT 50;

SELECT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID ASC,
    EventDate DESC
LIMIT 50;

SELECT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID DESC,
    EventDate ASC
LIMIT 50;

SELECT
    CounterID,
    EventDate
FROM test.hits
ORDER BY
    CounterID DESC,
    EventDate DESC
LIMIT 50;