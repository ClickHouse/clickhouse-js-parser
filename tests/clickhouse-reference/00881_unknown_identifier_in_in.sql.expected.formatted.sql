SELECT toUInt64(1) AS x
FROM (
        SELECT 1
    )
GROUP BY 1
HAVING x IN (
        SELECT countIf(y, z = 1)
        FROM (
                SELECT
                    1 AS y,
                    1 AS z
            )
    );