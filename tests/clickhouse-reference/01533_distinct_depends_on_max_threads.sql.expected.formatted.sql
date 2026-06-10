DROP TABLE IF EXISTS bug_13492;

CREATE TABLE bug_13492
(
    d DateTime
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toYYYYMMDD(d);

INSERT INTO bug_13492 SELECT addDays(now(), number)
FROM numbers(100);

SET max_threads = '5';

SELECT DISTINCT 1
FROM
    bug_13492,
    numbers(1) AS n;

SET max_threads = '2';

DROP TABLE bug_13492;