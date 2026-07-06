-- { echoOn }
SELECT readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1))');

SELECT toTypeName(readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1))'));

SELECT wkt(readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1))'));

SELECT readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1), (1 0, 2 0, 3 0))');

SELECT toTypeName(readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1), (1 0, 2 0, 3 0))'));

SELECT wkt(readWKTMultiLineString('MULTILINESTRING ((1 1, 2 2, 3 3, 1 1), (1 0, 2 0, 3 0))'));

-- Native Array(Array(Tuple(Float64, Float64))) is treated as Polygon, not as MultiLineString.
WITH wkt(CAST([[(1, 1), (2, 2), (3, 3), (1, 1)]] AS Array(Array(Tuple(Float64, Float64))))) AS x

SELECT
    x,
    toTypeName(x),
    readWKTPolygon(x) AS y,
    toTypeName(y);

-- Non constant tests
DROP TABLE IF EXISTS t;

CREATE TABLE IF NOT EXISTS t
(
    shape Array(Array(Tuple(Float64, Float64))),
    wkt_string String,
    ord Float64
)
ENGINE = Memory();

INSERT INTO t (ord, shape, wkt_string);

INSERT INTO t (ord, shape, wkt_string);

INSERT INTO t (ord, shape, wkt_string);

-- Native Array(Array(Tuple(Float64, Float64))) is treated as Polygon, not as MultiLineString.
-- but reading MultiLineString should still return an Array(Array(Tuple(Float64, Float64)))
SELECT
    wkt(shape),
    readWKTMultiLineString(wkt_string),
    readWKTMultiLineString(wkt_string) = shape
FROM t
ORDER BY ord ASC;