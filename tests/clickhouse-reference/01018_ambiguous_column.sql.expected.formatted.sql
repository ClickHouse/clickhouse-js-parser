SET output_format_pretty_color = '1';

SET enable_analyzer = '1';

SELECT *
FROM
    `system`.one
CROSS JOIN `system`.one;

SELECT *
FROM
    `system`.one
CROSS JOIN `system`.one AS r;

SELECT *
FROM
    `system`.one AS l
CROSS JOIN `system`.one;

SELECT *
FROM
    `system`.one
LEFT JOIN `system`.one
    USING (dummy);

SELECT dummy
FROM
    `system`.one
LEFT JOIN `system`.one
    USING (dummy);

USE `system`;

SELECT dummy
FROM
    one AS A
INNER JOIN one
    ON A.dummy = one.dummy;

SELECT dummy
FROM
    one
INNER JOIN one AS A
    ON A.dummy = one.dummy;

SELECT dummy
FROM
    one AS l
INNER JOIN one AS r
    ON dummy = r.dummy;

SELECT dummy
FROM
    one AS l
INNER JOIN one AS r
    ON one.dummy = r.dummy;

SELECT dummy
FROM
    one AS l
INNER JOIN one AS r
    ON l.dummy = dummy;

SELECT dummy
FROM
    one AS l
INNER JOIN one AS r
    ON l.dummy = one.dummy;

SELECT *
FROM
    one
INNER JOIN one AS A
    ON one.dummy = A.dummy
INNER JOIN one AS B
    ON one.dummy = B.dummy
FORMAT PrettyCompact;

SELECT *
FROM
    one AS A
INNER JOIN `system`.one AS one
    ON A.dummy = one.dummy
INNER JOIN `system`.one AS two
    ON A.dummy = two.dummy
FORMAT PrettyCompact;

SELECT one.dummy
FROM
    one AS A
INNER JOIN (
        SELECT 0 AS dummy
    ) AS B
    USING (dummy);