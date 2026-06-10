DROP TABLE IF EXISTS `03561_t0`, `03561_t1`, `03561_v0`, `03561_v1`;

SET allow_materialized_view_with_bad_select = '1';

CREATE TABLE `03561_t0`
(
    c0 Int
)
ENGINE = Memory();

CREATE TABLE `03561_t1`
(
    c0 Int
)
ENGINE = Memory();

CREATE MATERIALIZED VIEW `03561_v0`
TO `03561_t0`
(
    c0 Int
)
AS
SELECT 1 AS c0
FROM `03561_t0`;

CREATE MATERIALIZED VIEW `03561_v1`
TO `03561_t1`
(
    c0 Int
)
AS
SELECT grouping(c0) AS c0
FROM `03561_t0`;

INSERT INTO `03561_t0` (c0); -- { serverError TOO_DEEP_RECURSION }