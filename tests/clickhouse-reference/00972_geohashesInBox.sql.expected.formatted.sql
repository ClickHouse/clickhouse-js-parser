SELECT arraySort(geohashesInBox(-1., -1., 1., 1., 3));

SELECT arraySort(geohashesInBox(-0.1, -0.1, 0.1, 0.1, 5));

SELECT arraySort(geohashesInBox(-0.01, -0.01, 0.01, 0.01, 5));

SELECT arraySort(geohashesInBox(-180., 89., -179., 90., 3));

SELECT arraySort(geohashesInBox(-1., 89., 0., 90., 3));

SELECT arraySort(geohashesInBox(0., 89., 1., 90., 3));

SELECT arraySort(geohashesInBox(179., 89., 180., 90., 3));

SELECT arraySort(geohashesInBox(-180., -90., -179., -89., 3));

SELECT arraySort(geohashesInBox(-1., -90., 0., -89., 3));

SELECT arraySort(geohashesInBox(0., -90., 1., -89., 3));

SELECT arraySort(geohashesInBox(179., -90., 180., -89., 3));

SELECT arraySort(geohashesInBox(179., -1., 180., 0., 3));

SELECT arraySort(geohashesInBox(179., 0., 180., 1., 3));

SELECT arraySort(geohashesInBox(-180., -1., -179., 0., 3));

SELECT arraySort(geohashesInBox(-180., 0., -179., 1., 3));

SELECT arraySort(geohashesInBox(98.36, 7.88, 98.37, 7.89, 6));

SELECT arraySort(geohashesInBox(53.8, 27.6, 53.9, 27.7, 5));

SELECT arraySort(geohashesInBox(-49.26, -25.38, -49.25, -25.37, 6));

SELECT arraySort(geohashesInBox(23.11, -82.37, 23.12, -82.36, 6));

SELECT
    lon / 5 - 180 AS lon1,
    lat / 5 - 90 AS lat1,
    lon1 AS lon2,
    lat1 AS lat2,
    geohashesInBox(lon1, lat1, lon2, lat2, 1) AS g
FROM (
        SELECT
            arrayJoin(range(360 * 5)) AS lon,
            arrayJoin(range(180 * 5)) AS lat
    )
WHERE length(g) != 1;

SELECT
    lon / 5 - 40 AS lon1,
    lat / 5 - 20 AS lat1,
    lon1 AS lon2,
    lat1 AS lat2,
    geohashesInBox(lon1, lat1, lon2, lat2, 12) AS g
FROM (
        SELECT
            arrayJoin(range(80 * 5)) AS lon,
            arrayJoin(range(10 * 5)) AS lat
    )
WHERE length(g) != 1;

SELECT
    lon / 5 - 40 AS lon1,
    lat / 5 - 20 AS lat1,
    lon1 + 1e-10 AS lon2,
    lat1 + 1e-10 AS lat2,
    geohashesInBox(lon1, lat1, lon2, lat2, 1) AS g
FROM (
        SELECT
            arrayJoin(range(80 * 5)) AS lon,
            arrayJoin(range(10 * 5)) AS lat
    )
WHERE length(g) != 1;

SELECT arraySort(geohashesInBox(20., 20., 21., 21., 2));

SELECT arraySort(geohashesInBox(20., 20., 21., 21., 3));

SELECT arraySort(geohashesInBox(20., 20., 21., 21., 4));

SELECT arraySort(geohashesInBox(20., 20., 20.25, 20.25, 5));

SELECT arraySort(geohashesInBox(20., 20., 20.0625, 20.0625, 6));

SELECT arraySort(geohashesInBox(20., 20., 20.01, 20.01, 7));

SELECT arraySort(geohashesInBox(20., 20., 20.001, 20.001, 8));

SELECT arraySort(geohashesInBox(20., 20., 20.0001, 20.0001, 9));

SELECT arraySort(geohashesInBox(20., 20., 20.00001, 20.00001, 10));

SELECT arraySort(geohashesInBox(20., 20., 20.000001, 20.000001, 11));

SELECT arraySort(geohashesInBox(20., 20., 20.000001, 20.000001, 12));

-- precision greater than 12 is truncated to 12, so these two calls would produce same result as above
SELECT arraySort(geohashesInBox(20., 20., 20.000001, 20.000001, 13));

SELECT arraySort(geohashesInBox(20., 20., 20.000001, 20.000001, 14));

SELECT length(geohashesInBox(-inf, -inf, inf, inf, 3));

SELECT geohashesInBox(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH } -- not enough arguments

SELECT geohashesInBox(1, 2, 3, 4, 5); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }  -- wrong types of arguments

SELECT geohashesInBox(toFloat32(1.), 2., 3., 4., 5); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT } -- all lats and longs should be of the same type

SELECT geohashesInBox(24.48, 40.56, 24.785, 40.81, 12); -- { serverError TOO_LARGE_ARRAY_SIZE } -- to many elements in array