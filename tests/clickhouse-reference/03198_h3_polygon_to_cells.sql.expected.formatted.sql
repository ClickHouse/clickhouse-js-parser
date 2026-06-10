-- Tags: no-fasttest
-- example from h3 docs
SELECT arraySort(arrayMap((x -> h3ToString(x)), h3PolygonToCells([(-122.40898669999721, 37.81331899998324), (-122.35447369999936, 37.71980619999785), (-122.4798767000009, 37.815157199999845)], 7))) = ['872830820ffffff', '872830828ffffff', '87283082affffff', '87283082bffffff', '87283082effffff', '872830870ffffff', '872830876ffffff'];

-- test both rings, polygons and multipolygons
DROP TABLE IF EXISTS rings;

DROP TABLE IF EXISTS polygons;

DROP TABLE IF EXISTS multipolygons;

CREATE TABLE rings
(
    ring Ring
)
ENGINE = Memory();

CREATE TABLE polygons
(
    polygon Polygon
)
ENGINE = Memory();

CREATE TABLE multipolygons
(
    multipolygon MultiPolygon
)
ENGINE = Memory();

INSERT INTO rings;

-- expected: '8b63a9a9914cfff','8b63a9a99168fff','8b63a9a9916afff'
INSERT INTO polygons;

-- expected: '8b63a9a9914cfff','8b63a9a99168fff'
INSERT INTO multipolygons;

-- expected: '8b63a9a9914cfff','8b63a9a99168fff', '8b63a9a99bb3fff'
SELECT arraySort(arrayMap((x -> h3ToString(x)), h3PolygonToCells(ring, 11))) = ['8b63a9a9914cfff', '8b63a9a99168fff', '8b63a9a9916afff']
FROM rings;

SELECT arraySort(arrayMap((x -> h3ToString(x)), h3PolygonToCells(polygon, 11))) = ['8b63a9a9914cfff', '8b63a9a99168fff']
FROM polygons;

SELECT arraySort(arrayMap((x -> h3ToString(x)), h3PolygonToCells(multipolygon, 11))) = ['8b63a9a9914cfff', '8b63a9a99168fff', '8b63a9a99bb3fff']
FROM multipolygons;

DROP TABLE rings;

DROP TABLE polygons;

DROP TABLE multipolygons;