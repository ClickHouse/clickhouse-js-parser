DROP TABLE IF EXISTS a;

CREATE TABLE a
(
    i int,
    j int,
    PROJECTION p (SELECT * ORDER BY j)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY i
SETTINGS index_granularity = '1';

INSERT INTO a;

SELECT *
FROM a
WHERE i > 0
    AND j = 4
SETTINGS force_index_by_date = '1';

DROP TABLE a;