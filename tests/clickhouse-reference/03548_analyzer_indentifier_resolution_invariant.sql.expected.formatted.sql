SET allow_experimental_analyzer = '1';

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

CREATE VIEW v0
AS
SELECT
    1 AS a0,
    1 IN (a0)
FROM
    t0 AS tx
INNER JOIN t0 AS ty
    ON 1
CROSS JOIN t0 AS tz; -- { serverError UNKNOWN_IDENTIFIER }