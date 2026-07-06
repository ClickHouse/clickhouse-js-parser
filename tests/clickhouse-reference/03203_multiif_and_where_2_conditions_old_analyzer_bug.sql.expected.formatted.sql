DROP TABLE IF EXISTS bugcheck1;

CREATE TABLE bugcheck1
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT
    'c1' AS column_a,
    'c2' AS column_b;

SELECT
    *,
    multiIf(column_b IN (
        SELECT 'c2' AS someproduct
    ), 'yes', 'no') AS condition_1,
    multiIf(column_b = 'c2', 'true', 'false') AS condition_2
FROM (
        SELECT
            column_a,
            column_b
        FROM bugcheck1
    )
WHERE condition_1 IN ('yes')
    AND condition_2 IN ('true')
SETTINGS enable_analyzer = '0';

SELECT
    multiIf(column_b IN (
        SELECT 'c2' AS someproduct
    ), 'yes', 'no') AS condition_1,
    multiIf(column_b = 'c2', 'true', 'false') AS condition_2
FROM (
        SELECT
            column_a,
            column_b
        FROM bugcheck1
    )
WHERE condition_1 IN ('yes')
    AND condition_2 IN ('true')
SETTINGS enable_analyzer = '0';

SELECT
    *,
    multiIf(column_b IN (
        SELECT 'c2' AS someproduct
    ), 'yes', 'no') AS condition_1,
    multiIf(column_b = 'c2', 'true', 'false') AS condition_2
FROM (
        SELECT
            column_a,
            column_b
        FROM bugcheck1
    )
WHERE condition_1 IN ('yes')
    AND condition_2 IN ('true')
SETTINGS enable_analyzer = '1';

DROP TABLE bugcheck1;