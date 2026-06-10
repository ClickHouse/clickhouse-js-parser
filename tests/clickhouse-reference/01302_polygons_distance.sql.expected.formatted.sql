SELECT polygonsDistanceCartesian([[[(0, 0), (0, 3), (1, 2.9), (2, 2.6), (2.6, 2), (2.9, 1), (3, 0), (0, 0)]]], [[[(1., 1.), (1., 4.), (4., 4.), (4., 1.), (1., 1.)]]]);

SELECT polygonsDistanceCartesian([[[(0, 0), (0, 0.1), (0.1, 0.1), (0.1, 0)]]], [[[(1., 1.), (1., 4.), (4., 4.), (4., 1.), (1., 1.)]]]);

SELECT polygonsDistanceSpherical([[[(23.72575, 37.971536)]]], [[[(4.3826169, 50.8119483)]]]);

DROP TABLE IF EXISTS polygon_01302;

CREATE TABLE polygon_01302
(
    x Array(Array(Array(Tuple(Float64, Float64)))),
    y Array(Array(Array(Tuple(Float64, Float64))))
)
ENGINE = Memory();

INSERT INTO polygon_01302;

SELECT polygonsDistanceSpherical(x, y)
FROM polygon_01302;

DROP TABLE polygon_01302;