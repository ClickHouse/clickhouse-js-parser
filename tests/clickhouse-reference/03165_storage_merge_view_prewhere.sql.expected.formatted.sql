-- Tags: distributed
DROP TABLE IF EXISTS ids;

DROP TABLE IF EXISTS data;

DROP TABLE IF EXISTS data2;

CREATE TABLE ids
(
    id UUID,
    whatever String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO ids;

CREATE TABLE data
(
    id UUID,
    event_time DateTime,
    status String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO data;

CREATE TABLE data2
(
    id UUID,
    event_time DateTime,
    status String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO data2;

SELECT
    id,
    whatever
FROM
    ids AS l
INNER JOIN merge(currentDatabase(), 'data*') AS s
    ON l.id = s.id
WHERE status IN (['CREATED', 'CREATING'])
ORDER BY event_time DESC;

SELECT
    id,
    whatever
FROM
    ids AS l
INNER JOIN clusterAllReplicas(test_cluster_two_shards, merge(currentDatabase(), 'data*')) AS s
    ON l.id = s.id
WHERE status IN (['CREATED', 'CREATING'])
ORDER BY event_time DESC;

SELECT
    id,
    whatever
FROM
    ids AS l
INNER JOIN view(    SELECT *
    FROM merge(currentDatabase(), 'data*')) AS s
    ON l.id = s.id
WHERE status IN (['CREATED', 'CREATING'])
ORDER BY event_time DESC;