SET enable_analyzer = '1';

SET joined_subquery_requires_alias = '0';

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
    USING (val)
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS val
        FROM `system`.one
    )
    ON val + 0 = val * 1
ORDER BY `all` ASC; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT dummy AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT dummy AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(dummy) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(dummy) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(dummy)) AS val
        FROM `system`.one
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(dummy)) AS rval
        FROM `system`.one
    )
    ON val + 0 = rval * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT number AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT number AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(number) AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT number AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT number AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(number) AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(number) AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(number) AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(number)) AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(number) AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(number) AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(number)) AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;

SELECT *
FROM
    (
        SELECT toLowCardinality(toNullable(number)) AS l
        FROM `system`.numbers
        LIMIT 3
    )
ANY LEFT JOIN (
        SELECT toLowCardinality(toNullable(number)) AS r
        FROM `system`.numbers
        LIMIT 3
    )
    ON l + 1 = r * 1
ORDER BY `all` ASC;