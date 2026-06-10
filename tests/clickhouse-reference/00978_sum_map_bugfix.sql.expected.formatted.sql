SELECT
    number,
    arrayReduce('sumMap', [a], [b])
FROM (
        SELECT
            [100, 100, 200] AS a,
            [10, 20, 30] AS b,
            number
        FROM numbers(1)
    );

SELECT
    number,
    arrayReduce('sumMap', [a], [b])
FROM (
        SELECT
            materialize([100, 100, 200]) AS a,
            materialize([10, 20, 30]) AS b,
            number
        FROM numbers(10)
    );

SELECT
    number,
    arrayReduce('sumMap', [a], [b])
FROM (
        SELECT
            [100, 100, 200] AS a,
            [10, 20, 30] AS b,
            number
        FROM numbers(10)
    );

SELECT
    number,
    arrayReduce('sum', a)
FROM (
        SELECT
            materialize([100, 100, 200]) AS a,
            number
        FROM numbers(10)
    );

SELECT
    number,
    arrayReduce('max', [a])
FROM (
        SELECT
            materialize([100, 100, 200]) AS a,
            number
        FROM numbers(10)
    );

SELECT
    dumpColumnStructure([a]),
    arrayReduce('sumMap', [a], [a])
FROM (
        SELECT [1, 2] AS a
        FROM numbers(2)
    );