SELECT *
FROM
    cluster(test_cluster_two_shards, `system`.one) AS A
GLOBAL INNER JOIN (
        SELECT *
        FROM cluster(test_cluster_two_shards, `system`.one)
    ) AS B
    ON A.dummy = B.dummy;

SET use_index_for_in_with_subqueries = '0';