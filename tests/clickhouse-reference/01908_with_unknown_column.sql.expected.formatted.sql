SELECT a
FROM (
        WITH a + 1 AS aa,

        sumIf(aa, b > 0) AS aaif

        SELECT
            a,
            aaif
        FROM (
                SELECT
                    1 AS a,
                    2 AS b
            )
        GROUP BY a
    ) AS V;

SELECT a
FROM (
        WITH a + 1 AS aa,

          -- , sumIf(c, b > 0) as aaif
          sum(if(b > 0, c, 0)) AS aaif2

        SELECT
            a,
            aaif2
        FROM (
                SELECT
                    1 AS a,
                    2 AS b,
                    3 AS c
            )
        GROUP BY a
    ) AS V;

SELECT a
FROM (
        WITH a + 1 AS aa

        SELECT
            -- , sumIf(c, b > 0) as aaif
            -- , sum(if(b>0,c,0))  as aaif2
            a,
            sumIf(c, b > 0) AS aaif3
        FROM (
                SELECT
                    1 AS a,
                    2 AS b,
                    3 AS c
            )
        GROUP BY a
    ) AS V;