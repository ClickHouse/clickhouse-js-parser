DROP TABLE IF EXISTS v;

CREATE VIEW v (date UInt32, value UInt8)
AS
WITH data AS (
    SELECT '' AS id
    LIMIT 0
),

r AS (
    SELECT
        '' AS id,
        CAST('1' AS UInt8) AS value
)

SELECT
    now() AS date,
    value
    AND data.id IN (
        SELECT '' AS d
        FROM `system`.one
    ) AS value
FROM
    data
LEFT JOIN r
    ON data.id = r.id;

SELECT 1;

SELECT
    date,
    value
FROM v;

SELECT 2;

SELECT
    date,
    value
FROM v
ORDER BY date ASC;

SELECT 3;

DROP TABLE v;