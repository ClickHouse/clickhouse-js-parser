SELECT (1, 2) IN (tuple((1, 2)));

SELECT (1, 2) IN ((1, 2), (3, 4));

SELECT ((1, 2), (3, 4)) IN ((1, 2), (3, 4));

SELECT ((1, 2), (3, 4)) IN (((1, 2), (3, 4)),);

SELECT ((1, 2), (3, 4)) IN (tuple(((1, 2), (3, 4))));

SELECT ((1, 2), (3, 4)) IN (((1, 2), (3, 4)), ((5, 6), (7, 8)));

SELECT 1 IN (1);

SELECT 1 IN (tuple(1));

SELECT tuple(1) IN (tuple(1));

SELECT tuple(1) IN (tuple(tuple(1)));

SELECT tuple(tuple(1)) IN (tuple(tuple(1)));

SELECT tuple(tuple(1)) IN (tuple(tuple(tuple(1))));

SELECT tuple(tuple(tuple(1))) IN (tuple(tuple(tuple(1))));

SELECT 1 IN (NULL);

SELECT 1 IN (tuple(NULL));

SELECT 1 IN (tuple(NULL, 1));

SELECT tuple(1) IN (tuple(tuple(NULL)));

SELECT tuple(1) IN (tuple(tuple(NULL), tuple(1)));

SELECT tuple(tuple(NULL), tuple(1)) IN (tuple(tuple(NULL), tuple(1)));

SELECT 1 IN (1 + 1, 1 - 1);

SELECT 1 IN (0 + 1, 1, toInt8(sin(5)));

SELECT (0 + 1, 1, toInt8(sin(5))) IN (0 + 1, 1, toInt8(sin(5)));

SELECT identity(tuple(1)) IN (tuple(1), tuple(2));

SELECT identity(tuple(1)) IN (tuple(0), tuple(2));

SELECT identity((1, 2)) IN (1, 2);

SELECT identity((1, 2)) IN ((1, 2), (3, 4));

SELECT
    (1, 2) AS x,
    ((1, 2), (3, 4)) AS y,
    1 IN (x),
    x IN (y);

SELECT 1 IN (
        SELECT 1
    );

SELECT tuple(1) IN (
        SELECT tuple(1)
    );

SELECT (1, 2) IN (
        SELECT
            1,
            2
    );

SELECT (1, 2) IN (
        SELECT (1, 2)
    );

SELECT identity(tuple(1)) IN (
        SELECT tuple(1)
    );

SELECT identity((1, 2)) IN (
        SELECT
            1,
            2
    );

SELECT identity((1, 2)) IN (
        SELECT (1, 2)
    );