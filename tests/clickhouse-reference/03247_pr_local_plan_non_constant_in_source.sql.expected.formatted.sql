DROP TABLE IF EXISTS table_3 SYNC;

CREATE TABLE table_3
(
    uid UUID,
    date DateTime('Asia/Kamchatka')
)
ENGINE = ReplicatedMergeTree('/pr_local_plan/{database}/table_3', 'r1')
ORDER BY date;

INSERT INTO table_3;

SELECT
    uid,
    date,
    toDate(date) = toDate('2021-03-24') AS res
FROM table_3
WHERE res = 1
ORDER BY
    uid ASC,
    date ASC
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '3',
    cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost',
    parallel_replicas_local_plan = '1';

DROP TABLE table_3 SYNC;