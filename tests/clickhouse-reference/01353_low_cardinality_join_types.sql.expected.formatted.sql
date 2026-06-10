SET enable_analyzer = '0';

SET join_algorithm = 'hash';

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            toLowCardinality(number) AS k,
            toString(number) AS s
        FROM numbers(2)
    ) AS js1
INNER JOIN (
        SELECT
            number + 1 AS k,
            toLowCardinality(toString(number + 1)) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            number AS k,
            toLowCardinality(toString(number)) AS s
        FROM numbers(2)
    ) AS js1
INNER JOIN (
        SELECT
            toLowCardinality(number + 1) AS k,
            toString(number + 1) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            toLowCardinality(number) AS k,
            toLowCardinality(toString(number)) AS s
        FROM numbers(2)
    ) AS js1
INNER JOIN (
        SELECT
            toLowCardinality(number + 1) AS k,
            toLowCardinality(toString(number + 1)) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            toLowCardinality(number) AS k,
            toString(number) AS s
        FROM numbers(2)
    ) AS js1
FULL JOIN (
        SELECT
            number + 1 AS k,
            toLowCardinality(toString(number + 1)) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            number AS k,
            toLowCardinality(toString(number)) AS s
        FROM numbers(2)
    ) AS js1
FULL JOIN (
        SELECT
            toLowCardinality(number + 1) AS k,
            toString(number + 1) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SELECT
    toTypeName(materialize(js1.k)),
    toTypeName(materialize(js2.k)),
    toTypeName(materialize(js1.s)),
    toTypeName(materialize(js2.s))
FROM
    (
        SELECT
            toLowCardinality(number) AS k,
            toLowCardinality(toString(number)) AS s
        FROM numbers(2)
    ) AS js1
FULL JOIN (
        SELECT
            toLowCardinality(number + 1) AS k,
            toLowCardinality(toString(number + 1)) AS s
        FROM numbers(2)
    ) AS js2
    USING (k)
ORDER BY
    js1.k ASC,
    js2.k ASC;

SET join_algorithm = 'partial_merge';

SET enable_analyzer = '1';