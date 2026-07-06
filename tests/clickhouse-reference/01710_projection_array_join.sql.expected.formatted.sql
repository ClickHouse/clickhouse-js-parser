SET optimize_use_projections = '1';

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    pk int,
    arr Array(int),
    PROJECTION p (SELECT arr ORDER BY pk)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO x;

SELECT a
FROM
    x
ARRAY JOIN arr AS a;

DROP TABLE x;