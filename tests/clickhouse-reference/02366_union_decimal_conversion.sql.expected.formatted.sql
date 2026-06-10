SELECT
    sum(a),
    sum(b)
FROM cluster(test_cluster_two_shards, view(    SELECT
        CAST(number AS Decimal(7, 2)) AS a,
        0 AS b
    FROM numbers(2)
    UNION ALL
    SELECT
        0,
        CAST(number AS Decimal(7, 2)) AS b
    FROM numbers(2)));