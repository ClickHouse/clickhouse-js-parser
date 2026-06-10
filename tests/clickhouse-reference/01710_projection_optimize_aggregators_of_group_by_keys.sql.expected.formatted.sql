DROP TABLE IF EXISTS proj;

CREATE TABLE proj
(
    date Date,
    PROJECTION maxdate (SELECT max(date) GROUP BY date)
)
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT toDate('2012-10-24') - number % 100
FROM numbers(100.);

SELECT max(date)
FROM proj
PREWHERE date != '2012-10-24';

DROP TABLE proj;