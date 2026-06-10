DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO tab SELECT
    number,
    number
FROM numbers(10);

INSERT INTO tab SELECT
    number,
    number
FROM numbers(20);

SET mutations_sync = '2';

ALTER TABLE tab DELETE WHERE x > 1000
AND y IN (
    SELECT sum(number + 1)
    FROM numbers_mt(10000000.)
    GROUP BY number % 2
    WITH TOTALS
);