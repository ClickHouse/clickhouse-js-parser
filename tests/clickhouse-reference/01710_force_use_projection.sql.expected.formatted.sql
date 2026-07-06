DROP TABLE IF EXISTS tp;

CREATE TABLE tp
(
    d1 Int32,
    d2 Int32,
    eventcnt Int64,
    PROJECTION p (SELECT sum(eventcnt) GROUP BY d1)
)
ENGINE = MergeTree()
ORDER BY (d1, d2);

SET optimize_use_projections = '1', force_optimize_projection = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT
    sum(eventcnt) AS eventcnt,
    d1
FROM tp
GROUP BY d1;

SELECT
    avg(eventcnt) AS eventcnt,
    d1
FROM tp
GROUP BY d1;

INSERT INTO tp;

DROP TABLE tp;