SELECT toUInt64(1)
UNION ALL
SELECT countIf(n > 0)
FROM (
        SELECT 2 AS n
    );

SELECT q
FROM (
        SELECT [1, 2, 3] AS q
        UNION ALL
        SELECT groupArray(arrayJoin([4, 5, 6])) AS q
        ORDER BY q ASC
    )
ORDER BY q ASC;