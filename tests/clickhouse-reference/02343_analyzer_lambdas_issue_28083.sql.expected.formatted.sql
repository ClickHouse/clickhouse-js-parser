SET enable_analyzer = '1';

SELECT
    so,
    r
FROM (
        SELECT
            [('y', 0), ('n', 1)] AS cg,
            if(arrayMap((x -> (x).1), cg) != ['y', 'n'], 'y', 'n') AS so,
            arrayFilter((x -> (x).1 = so), cg) AS r
    );

SELECT r
FROM (
        SELECT
            [('y', 0), ('n', 1)] AS cg,
            if(arrayMap((x -> (x).1), cg) != ['y', 'n'], 'y', 'n') AS so,
            arrayFilter((x -> (x).1 = so), cg) AS r
    );