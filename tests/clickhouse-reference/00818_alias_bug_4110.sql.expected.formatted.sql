SET enable_analyzer = '1';

SELECT
    s.a AS a,
    s.a + 1 AS b
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 1 AS a,
    s.a AS b
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 1 AS a,
    s.a + 1 AS b
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 1 AS b,
    s.a + 2 AS a
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 2 AS b,
    s.a + 1 AS a
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    a,
    a AS a
FROM (
        SELECT 10 AS a
    );

SELECT
    s.a,
    a,
    a + 1 AS a
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 2 AS b,
    b - 1 AS a
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a AS a,
    s.a + 2 AS b
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    s.a + 1 AS a,
    s.a + 2 AS b
FROM (
        SELECT 10 AS a
    ) AS s;

SELECT
    a + 1 AS a,
    a + 1 AS b
FROM (
        SELECT 10 AS a
    );

SELECT
    a + 1 AS b,
    b + 1 AS a
FROM (
        SELECT 10 AS a
    ); -- { serverError CYCLIC_ALIASES, UNKNOWN_IDENTIFIER }

SELECT
    10 AS a,
    a + 1 AS a; -- { serverError UNKNOWN_IDENTIFIER }

WITH 10 AS a

SELECT a AS a; -- { serverError UNKNOWN_IDENTIFIER }

WITH 10 AS a

SELECT a + 1 AS a; -- { serverError UNKNOWN_IDENTIFIER }

SELECT 0 AS t
FROM (
        SELECT 1 AS t
    ) AS inn
WHERE inn.t = 1;

SELECT sum(value) AS value
FROM (
        SELECT 1 AS value
    ) AS data
WHERE data.value > 0;

DROP TABLE IF EXISTS test_00818;

CREATE TABLE test_00818
(
    field String,
    not_field String
)
ENGINE = Memory();

INSERT INTO test_00818 (field, not_field);

SELECT
    test_00818.field AS other_field,
    test_00818.not_field AS field
FROM test_00818;

DROP TABLE test_00818;