DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

INSERT INTO t0;

SELECT 1
FROM
    t0
ASOF INNER JOIN t0 AS tx
    ON exists((
        SELECT 1
    ))
INNER JOIN t0 AS ty
    ON t0.c0 = ty.c0; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT 1
FROM
    t0
ASOF INNER JOIN t0 AS tx
    ON exists((
        SELECT 1
    ))
INNER JOIN t0 AS ty
    ON t0.c0 = ty.c0
SETTINGS allow_general_join_planning = '0'; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT 1
FROM
    t0
ASOF INNER JOIN t0 AS tx
    ON exists((
        SELECT 1
    ))
INNER JOIN t0 AS ty
    ON t0.c0 = ty.c0
SETTINGS query_plan_use_new_logical_join_step = '0'; -- { serverError INVALID_JOIN_ON_EXPRESSION }