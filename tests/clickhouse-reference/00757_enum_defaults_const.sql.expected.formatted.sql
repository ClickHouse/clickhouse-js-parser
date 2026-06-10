SET enable_analyzer = '0';

SELECT
    os_name,
    count()
FROM (
        SELECT CAST('iphone' AS Enum8('iphone' = 1, 'android' = 2)) AS os_name
    )
GROUP BY os_name
WITH TOTALS;

SELECT
    toNullable(os_name) AS os_name,
    count()
FROM (
        SELECT CAST('iphone' AS Enum8('iphone' = 1, 'android' = 2)) AS os_name
    )
GROUP BY os_name
WITH TOTALS;