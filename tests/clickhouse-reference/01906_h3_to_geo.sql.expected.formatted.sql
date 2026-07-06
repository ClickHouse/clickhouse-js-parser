-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes
(
    h3_index UInt64
)
ENGINE = Memory();

-- Random geo coordinates were generated using the H3 tool: https://github.com/ClickHouse-Extras/h3/blob/master/src/apps/testapps/mkRandGeo.c at various resolutions from 0 to 15.
-- Corresponding H3 index values were in turn generated with those geo coordinates using `geoToH3(lat, lon, res)` ClickHouse function for the following test.
INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

WITH h3ToGeo(h3_index) AS p

SELECT
    round((p).1, 3),
    round((p).2, 3)
FROM h3_indexes
ORDER BY h3_index ASC;

DROP TABLE h3_indexes;

DROP TABLE IF EXISTS h3_geo;

-- compare if the results of h3ToGeo and geoToH3 are the same
CREATE TABLE h3_geo
(
    lat Float64,
    lon Float64,
    res UInt8
)
ENGINE = Memory();

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

INSERT INTO h3_geo;

SELECT result
FROM (
        SELECT
            (lon, lat) AS input_geo,
            h3ToGeo(geoToH3(lon, lat, res)) AS output_geo,
            if(abs((input_geo).1 - (output_geo).1) < 0.001
            AND abs((input_geo).2 - (output_geo).2) < 0.001, 'ok', 'fail') AS result
        FROM h3_geo
    );

DROP TABLE h3_geo;