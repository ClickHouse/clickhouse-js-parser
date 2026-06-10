CREATE TABLE p3
(
    x Int64,
    y Int64
)
ENGINE = MergeTree()
ORDER BY (x, y);

INSERT INTO p3;

EXPLAIN indexes = '1', projections = '1'
SELECT *
FROM p3
WHERE pointInPolygon((x, y), [(0, 0), (0, 150), (150, 150), (150, 0)])
FORMAT Null;