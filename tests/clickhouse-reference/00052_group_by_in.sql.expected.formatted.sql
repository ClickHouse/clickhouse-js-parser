-- Tags: stateful, no-parallel-replicas
-- https://github.com/ClickHouse/ClickHouse/issues/74716
SELECT
    StartDate,
    TraficSourceID IN (0) ? 'type_in' : 'other' AS traf_type,
    sum(Sign)
FROM test.visits
WHERE CounterID = 842440
GROUP BY
    StartDate,
    traf_type
ORDER BY
    StartDate ASC,
    traf_type ASC;