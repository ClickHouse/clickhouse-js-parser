-- { echo }
WITH rhs AS (
    SELECT *
    FROM remote('127.{1,2}', view(        SELECT
            dummy AS d1,
            dummy AS d2
        FROM `system`.one))
)

SELECT lhs.d2
FROM
    remote('127.{1,2}', view(    SELECT
        dummy AS d1,
        dummy AS d2
    FROM `system`.one)) AS lhs
GLOBAL INNER JOIN rhs
    USING (d1)
ORDER BY rhs.d2 ASC
SETTINGS enable_analyzer = '0'; -- { serverError ALIAS_REQUIRED }

WITH rhs AS (
    SELECT *
    FROM remote('127.{1,2}', view(        SELECT
            dummy AS d1,
            dummy AS d2
        FROM `system`.one))
)

SELECT lhs.d2
FROM
    remote('127.{1,2}', view(    SELECT
        dummy AS d1,
        dummy AS d2
    FROM `system`.one)) AS lhs
GLOBAL INNER JOIN rhs
    USING (d1)
ORDER BY rhs.d2 ASC
SETTINGS enable_analyzer = '1'; -- It works with analyzer; rhs is an alias itself.

WITH rhs AS (
    SELECT *
    FROM remote('127.{1,2}', view(        SELECT
            dummy AS d1,
            dummy AS d2
        FROM `system`.one))
)

SELECT lhs.d2
FROM
    remote('127.{1,2}', view(    SELECT
        dummy AS d1,
        dummy AS d2
    FROM `system`.one)) AS lhs
GLOBAL INNER JOIN rhs
    USING (d1)
ORDER BY rhs.d2 ASC
SETTINGS joined_subquery_requires_alias = '0';

WITH rhs_ AS (
    SELECT *
    FROM remote('127.{1,2}', view(        SELECT
            dummy AS d1,
            dummy AS d2
        FROM `system`.one))
)

SELECT lhs.d2
FROM
    remote('127.{1,2}', view(    SELECT
        dummy AS d1,
        dummy AS d2
    FROM `system`.one)) AS lhs
GLOBAL INNER JOIN rhs_ AS rhs
    USING (d1)
ORDER BY rhs.d2 ASC
SETTINGS joined_subquery_requires_alias = '0';