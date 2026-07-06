SET enable_analyzer = '1';

SELECT
    (t).1 AS cnt,
    (t).2 AS name,
    (t).3 AS percent
FROM (
        SELECT arrayJoin(result) AS t
        FROM (
                SELECT
                    [(79, 'name1'), (62, 'name2'), (44, 'name3')] AS data,
                    arraySum(arrayMap((t -> (t).1), data)) AS total,
                    arrayMap((t -> tuple((t).1, (t).2, multiIf(total = 0, 0, (t).1 > 0
                    AND (t).1 < 10, -1., toFloat32((t).1) / toFloat32(total) * 100))), data) AS result
            )
    );

SELECT arrayMap((x -> arrayMap((x -> (x).1), [(1, 1), (2, 2)])), [(3, 3), (4, 4)]);

SELECT arrayMap((x -> ((x).1, arrayMap((x -> (x).1), [(1, 1), (2, 2)]))), [(3, 3), (4, 4)]);