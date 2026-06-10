-- Tags: no-fasttest
DROP TABLE IF EXISTS table1;

CREATE TABLE table1
(
    lat Float64,
    lon Float64,
    resolution UInt8
)
ENGINE = Memory();

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

SELECT geoToH3(55.77922738, 37.63098076, 15);

SELECT geoToH3(55.77922738, 37.63098076, 24); -- { serverError ARGUMENT_OUT_OF_BOUND }

SELECT geoToH3(lat, lon, resolution)
FROM table1
ORDER BY
    lat ASC,
    lon ASC,
    resolution ASC;

SELECT geoToH3(lat, lon, resolution) AS k
FROM table1
ORDER BY
    lat ASC,
    lon ASC,
    k ASC;

SELECT
    lat,
    lon,
    geoToH3(lat, lon, resolution) AS k
FROM table1
ORDER BY
    lat ASC,
    lon ASC,
    k ASC;

SELECT
    geoToH3(lat, lon, resolution) AS k,
    count(*)
FROM table1
GROUP BY k
ORDER BY k ASC;

DROP TABLE table1;