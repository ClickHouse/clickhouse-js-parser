SET validate_polygons = '0';

SELECT pointInPolygon((0., 0.), [(0., 0.)]);

SELECT pointInPolygon((1., 1.), [(0., 0.)]);

SELECT pointInPolygon((0., 0.), [(0., 0.), (0., 0.)]);

SELECT pointInPolygon((1., 1.), [(0., 0.), (0., 0.)]);

SELECT pointInPolygon((5., 5.), [(0., 0.), (5., 0.), (10., 0.)]);

SELECT pointInPolygon((2., 2.), [(0., 0.), (5., 5.), (5., 0.)], [(2., 2.)]);

SELECT pointInPolygon((2., 2.), [(0., 0.), (5., 5.), (5., 0.)], [(2., 2.), (5., 2.)]);

SELECT pointInPolygon((2.5, 2.5), [(0., 0.), (5., 0.), (10., 0.)], [(2., 2.), (3., 3.), (3., 2.)]);

SELECT pointInPolygon((1., 1.), [(0., 0.), (5., 0.), (10., 0.)], [(2., 2.), (3., 3.), (3., 2.)]);

DROP TABLE IF EXISTS points_test;

CREATE TABLE points_test
(
    x Float64,
    y Float64,
    note String
)
ENGINE = TinyLog();

INSERT INTO points_test (x, y, note);

SELECT
    x,
    y,
    note,
    pointInPolygon((x, y), [
    [[(0, 0), (10, 0), (10, 10), (0, 10), (0, 0)], [(2, 2), (4, 2), (4, 4), (2, 4), (2, 2)], [(6, 2), (8, 2), (8, 4), (6, 4), (6, 2)], [(4, 6), (6, 6), (6, 8), (4, 8), (4, 6)]],
    [[(20, 0), (30, 0), (30, 10), (20, 10), (20, 0)], [(22, 2), (24, 2), (24, 4), (22, 4), (22, 2)], [(26, 2), (28, 2), (28, 4), (26, 4), (26, 2)], [(24, 6), (26, 6), (26, 8), (24, 8), (24, 6)]],
    [[(-10, -10)]], -- Empty Bound Polgyon
    [[(3, 3), (100, 3), (500, 3)]] -- Empty Bound Polgyon
]) AS inside
FROM points_test
ORDER BY
    note ASC,
    x ASC,
    y ASC;

SELECT pointInPolygon((0., 0.), [[(0, 0)]]);

SELECT pointInPolygon((5., 5.), [[(0, 0)], [(1, 5), (5, 5), (10, 5)]]);