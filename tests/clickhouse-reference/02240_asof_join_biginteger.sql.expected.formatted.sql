SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt128('18446744073709551617') AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt128('18446744073709551616') AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt256('340282366920938463463374607431768211457') AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt256('340282366920938463463374607431768211456') AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt128('18446744073709551617') AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt128('18446744073709551616') AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt256('340282366920938463463374607431768211457') AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt256('340282366920938463463374607431768211456') AS v
    ) AS t2
    USING (k, v);

SET join_algorithm = 'full_sorting_merge';