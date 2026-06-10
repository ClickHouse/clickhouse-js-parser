SET enable_analyzer = '1';

SELECT
    v.x,
    r.a,
    sum(c)
FROM
    (
        SELECT
            1 AS x,
            2 AS c
    ) AS v
ANY LEFT JOIN (
        SELECT
            1 AS x,
            2 AS a
    ) AS r
    ON v.x = r.x
GROUP BY v.x; -- { serverError NOT_AN_AGGREGATE}