SELECT hex(1.);

SELECT hex(101.);

SELECT hex(1000000000000000000.);

SELECT hex(1e-20);

SELECT hex(1e100);

SELECT hex(0.000578);

SELECT hex(-123.978);

SELECT hex(toFloat32(99.67));

SELECT hex(toFloat32(number))
FROM numbers(200, 2);

SELECT hex(toFloat64(number))
FROM numbers(202, 2);