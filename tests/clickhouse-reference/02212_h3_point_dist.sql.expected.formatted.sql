-- Tags: no-fasttest
DROP TABLE IF EXISTS table1;

CREATE TABLE table1
(
    lat1 Float64,
    lon1 Float64,
    lat2 Float64,
    lon2 Float64
)
ENGINE = Memory();

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

SELECT '-- select h3PointDistM(lat1, lon1,lat2, lon2) AS k from table1 order by k;';

SELECT round(h3PointDistM(lat1, lon1, lat2, lon2), 2) AS k
FROM table1
ORDER BY k ASC;

SELECT round(h3PointDistKm(lat1, lon1, lat2, lon2), 2) AS k
FROM table1
ORDER BY k ASC;

SELECT round(h3PointDistRads(lat1, lon1, lat2, lon2), 5) AS k
FROM table1
ORDER BY k ASC;

DROP TABLE table1;

SELECT round(h3PointDistRads(-10., 0., 10., arrayJoin([0.])), 5) AS h3PointDistRads;

SELECT round(h3PointDistRads(-10., 0., 10., toFloat64(0)), 5) AS h3PointDistRads;