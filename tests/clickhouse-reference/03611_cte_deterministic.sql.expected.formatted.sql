SET enable_analyzer = '1';

WITH (
        SELECT randConstant()
    ) AS a

SELECT a = a;

WITH (
        SELECT now() + sleep(1)
    ) AS a

SELECT a = a;

WITH (
        SELECT randConstant()
    ) AS b

SELECT
    b = b,
    a = b,
    `a=a`
FROM (
        WITH (
                SELECT randConstant()
            ) AS a

        SELECT
            a,
            a = a AS `a=a`
    );