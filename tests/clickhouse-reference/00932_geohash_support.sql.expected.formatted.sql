DROP TABLE IF EXISTS geohash_test_data;

CREATE TABLE geohash_test_data
(
    latitude Float64,
    longitude Float64,
    encoded String
)
ENGINE = MergeTree()
ORDER BY (latitude, longitude, encoded);

-- data obtained from geohash.com
INSERT INTO geohash_test_data;

SELECT geohashEncode(181., 91.);

SELECT geohashEncode(-181., -91.);

SELECT count(geohashDecode('abcdefghijklmnopqrstuvwxyz'));

SELECT geohashEncode(-5.60302734375, 42.593994140625, 0);

SELECT
    round(geohashDecode('ezs42').1, 5),
    round(geohashDecode('ezs42').2, 5);

SELECT geohashEncode(-5.60302734375, 42.593994140625);

SELECT geohashEncode(materialize(-5.60302734375), materialize(42.593994140625), 0);

SELECT geohashEncode(materialize(-5.60302734375), materialize(42.593994140625), materialize(0));

SELECT geohashEncode(-5.60302734375, materialize(42.593994140625), 0);

SELECT geohashEncode(materialize(-5.60302734375), 42.593994140625, 0);

-- here results are strings, so reference may contain values to match for equality.
SELECT
    1 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    2 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    3 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    4 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    5 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    6 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    7 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    8 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    9 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    10 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    11 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    12 AS p,
    geohashEncode(longitude, latitude, p) AS actual,
    if(actual = encoded, 'Ok', concat('expected: ', encoded))
FROM geohash_test_data
WHERE length(encoded) = p
ORDER BY `all` ASC;

SELECT
    geohashDecode(encoded) AS actual,
    'expected:',
    encoded,
    '=>',
    latitude,
    longitude,
    'length:',
    length(encoded),
    'max lat error:',
    180 / power(2, 2.5 * length(encoded)) AS latitude_max_error,
    'max lon error:',
    360 / power(2, 2.5 * length(encoded)) AS longitude_max_error,
    'err:',
    (actual).2 - latitude AS lat_error,
    (actual).1 - longitude AS lon_error,
    'derr:',
    abs(lat_error) - latitude_max_error,
    abs(lon_error) - longitude_max_error
FROM geohash_test_data
WHERE abs(lat_error) > latitude_max_error
    OR abs(lon_error) > longitude_max_error;