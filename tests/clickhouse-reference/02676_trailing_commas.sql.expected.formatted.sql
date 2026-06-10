SELECT 1;

SELECT 1
FROM numbers(1);

WITH 1 AS a

SELECT a
FROM numbers(1);

WITH 1 AS `from`

SELECT
    `from`,
    `from` + `from`,
    `from` IN ([0])
FROM numbers(1);

SELECT n
FROM (
        SELECT 1 AS n
    );

SELECT CAST('(1, ''foo'')' AS Tuple(a Int, b String));

SELECT CAST('(1, ''foo'')' AS Tuple(Int, String));

SELECT CAST('(1, (2,''foo''))' AS Tuple(Int, Tuple(Int, String)));