DROP TABLE IF EXISTS short;

DROP TABLE IF EXISTS long;

DROP TABLE IF EXISTS merged;

CREATE TABLE short
(
    e Int64,
    t DateTime
)
ENGINE = MergeTree()
ORDER BY t
PARTITION BY e;

CREATE TABLE long
(
    e Int64,
    t DateTime
)
ENGINE = MergeTree()
ORDER BY t
PARTITION BY (e, toStartOfMonth(t));

INSERT INTO short SELECT
    number % 11,
    toDateTime('2021-01-01 00:00:00') + number
FROM numbers(1000);

INSERT INTO long SELECT
    number % 11,
    toDateTime('2021-01-01 00:00:00') + number
FROM numbers(1000);

CREATE TABLE merged AS short
ENGINE = Merge(currentDatabase(), 'short|long');

SELECT sum(e)
FROM (
        SELECT *
        FROM merged
        ORDER BY t ASC
        LIMIT 10
    )
SETTINGS optimize_read_in_order = '0';

SELECT sum(e)
FROM (
        SELECT *
        FROM merged
        ORDER BY t ASC
        LIMIT 10
    )
SETTINGS max_threads = '1';

SELECT sum(e)
FROM (
        SELECT *
        FROM merged
        ORDER BY t ASC
        LIMIT 10
    )
SETTINGS max_threads = '3';

SELECT sum(e)
FROM (
        SELECT *
        FROM merged
        ORDER BY t ASC
        LIMIT 10
    )
SETTINGS max_threads = '10';

SELECT sum(e)
FROM (
        SELECT *
        FROM merged
        ORDER BY t ASC
        LIMIT 10
    )
SETTINGS max_threads = '50';