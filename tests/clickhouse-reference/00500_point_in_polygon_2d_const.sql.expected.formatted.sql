SELECT pointInPolygon((0, 0), [[(0, 0), (10, 0), (10, 10), (0, 10)]]);

DROP TABLE IF EXISTS s;

CREATE TABLE s
(
    id String,
    lng Int64,
    lat Int64
)
ENGINE = Memory();

DROP TABLE IF EXISTS p;

CREATE TABLE p
(
    polygon_id Int64,
    polygon_name String,
    shape Array(Array(Tuple(Float64, Float64))),
    state String
)
ENGINE = Memory();

INSERT INTO s;

INSERT INTO p;

SELECT id
FROM s
WHERE pointInPolygon((lng, lat), (
        SELECT shape
        FROM p
        WHERE polygon_id = 8
    ));

DROP TABLE s;

DROP TABLE p;