DROP TABLE IF EXISTS tp;

CREATE TABLE tp
(
    type Int32,
    eventcnt UInt64,
    PROJECTION p (SELECT sum(eventcnt), type GROUP BY type)
)
ENGINE = ReplacingMergeTree()
ORDER BY type
SETTINGS deduplicate_merge_projection_mode = 'ignore';

INSERT INTO tp SELECT
    number % 3,
    1
FROM numbers(3);

INSERT INTO tp SELECT
    number % 3,
    2
FROM numbers(3);

OPTIMIZE TABLE tp DEDUPLICATE; -- { serverError SUPPORT_IS_DISABLED }

OPTIMIZE TABLE tp FINAL;

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SET optimize_use_projections = false, force_optimize_projection = false;

SELECT
    sum(eventcnt) AS eventcnt,
    type
FROM tp
GROUP BY type
ORDER BY
    eventcnt ASC,
    type ASC;

SET optimize_use_projections = true, force_optimize_projection = true;

DROP TABLE tp;