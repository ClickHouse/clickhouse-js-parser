-- Tags: distributed
SET distributed_foreground_insert = '1';

DROP TABLE IF EXISTS visits;

DROP TABLE IF EXISTS visits_dist;

CREATE TABLE visits
(
    StartDate Date,
    Name String
)
ENGINE = MergeTree()
ORDER BY StartDate;

CREATE TABLE visits_dist AS visits
ENGINE = Distributed(test_cluster_two_shards_localhost, currentDatabase(), 'visits', rand());

INSERT INTO visits_dist (StartDate, Name);

INSERT INTO visits_dist (StartDate, Name);

ALTER TABLE visits RENAME COLUMN Name TO Name2;

ALTER TABLE visits_dist RENAME COLUMN Name TO Name2;

SELECT *
FROM visits_dist
ORDER BY
    StartDate ASC,
    Name2 ASC;

DROP TABLE visits;

DROP TABLE visits_dist;