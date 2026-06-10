-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes
(
    h3_index UInt64
)
ENGINE = Memory();

-- Random geo coordinates were generated using the H3 tool: https://github.com/ClickHouse-Extras/h3/blob/master/src/apps/testapps/mkRandGeo.c at various resolutions from 0 to 15.
-- Corresponding H3 index values were in turn generated with those geo coordinates using `geoToH3(lon, lat, res)` ClickHouse function for the following test.
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

SELECT substring(h3CellAreaRads2(h3_index)::String, 1, 10)
FROM h3_indexes
ORDER BY h3_index ASC;

DROP TABLE h3_indexes;