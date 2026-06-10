SELECT range(100) = range(0, 100)
    AND range(0, 100) = range(0, 100, 1);

SELECT range(100) = range(CAST('100' AS Int8))
    AND range(100) = range(CAST('100' AS Int16))
    AND range(100) = range(CAST('100' AS Int32))
    AND range(100) = range(CAST('100' AS Int64));

SELECT range(CAST('100' AS Int8)) = range(0, CAST('100' AS Int8))
    AND range(0, CAST('100' AS Int8)) = range(0, CAST('100' AS Int8), 1)
    AND range(0, CAST('100' AS Int8)) = range(0, CAST('100' AS Int8), CAST('1' AS Int8));

SELECT range(-1, 1);

SELECT range(-1, 1, 2);

SELECT range(1, 1);

SELECT range(5, 0, -1);

SELECT range(5, -1, -1);

SELECT range(1, 257, 65535);

SELECT range(CAST(number - 5 AS Int8), CAST(number + 5 AS Int8))
FROM `system`.numbers
LIMIT 10;