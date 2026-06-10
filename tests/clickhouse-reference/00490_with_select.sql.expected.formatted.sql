SET enable_analyzer = '1';

WITH pow(2, 2) AS four

SELECT
    pow(four, 2),
    2 AS two,
    pow(two, 2);

SELECT
    `pow(four, 2)`,
    `pow(two, 2)`
FROM (
        WITH pow(2, 2) AS four

        SELECT
            pow(four, 2),
            2 AS two,
            pow(two, 2)
    );

WITH (
        SELECT pow(two, 2)
    ) AS four

SELECT
    pow(four, 2),
    2 AS two,
    pow(two, 2);

SELECT
    `pow(four, 2)`,
    `pow(two, 2)`
FROM (
        WITH (
                SELECT pow(2, 2)
            ) AS four

        SELECT
            pow(four, 2),
            2 AS two,
            pow(two, 2)
    );

WITH 'string' AS str

SELECT str || '_abc';

SELECT `concat(str, '_abc')`
FROM (
        WITH 'string' AS str

        SELECT str || '_abc'
    );