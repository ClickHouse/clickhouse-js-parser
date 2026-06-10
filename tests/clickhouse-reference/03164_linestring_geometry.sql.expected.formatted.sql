-- { echoOn }
SELECT readWKTLineString('LINESTRING (1 1, 2 2, 3 3, 1 1)');

SELECT toTypeName(readWKTLineString('LINESTRING (1 1, 2 2, 3 3, 1 1)'));

SELECT wkt(readWKTLineString('LINESTRING (1 1, 2 2, 3 3, 1 1)'));

-- Native Array(Tuple(Float64, Float64)) is threated as Ring, not as LineString.
WITH wkt(CAST([(1, 1), (2, 2), (3, 3)] AS Array(Tuple(Float64, Float64)))) AS x

SELECT
    x,
    toTypeName(x),
    readWKTRing(x) AS y,
    toTypeName(y);