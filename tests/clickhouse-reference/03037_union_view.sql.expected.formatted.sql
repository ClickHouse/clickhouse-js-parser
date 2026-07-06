-- https://github.com/ClickHouse/ClickHouse/issues/55803
SET enable_analyzer = '1';

DROP TABLE IF EXISTS broken_table;

DROP TABLE IF EXISTS broken_view;

CREATE TABLE broken_table
(
    start DateTime64(6),
    `end` DateTime64(6)
)
ENGINE = ReplacingMergeTree(start)
ORDER BY start;

CREATE VIEW broken_view
AS
SELECT
    t.start AS start,
    t.`end` AS `end`,
    CAST(dateDiff('second', t.start, t.`end`) AS float) AS total_sec
FROM broken_table AS t FINAL
UNION ALL
SELECT
    NULL AS start,
    NULL AS `end`,
    NULL AS total_sec;

SELECT
    v.start,
    v.total_sec
FROM broken_view AS v FINAL
WHERE v.start IS NOT NULL;