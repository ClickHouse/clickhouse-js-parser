DROP TABLE IF EXISTS X;

DROP TABLE IF EXISTS Y;

CREATE TABLE X
(
    id Int32,
    x_a String,
    x_b Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE Y
(
    id Int32,
    y_a String,
    y_b Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO X (id, x_a, x_b);

INSERT INTO X (id, x_a);

INSERT INTO Y (id, y_a);

INSERT INTO Y (id, y_a, y_b);

SELECT
    X.*,
    Y.*
FROM
    X
INNER JOIN Y
    ON X.id = Y.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    s.*,
    j.*
FROM
    (
        SELECT *
        FROM X
    ) AS s
INNER JOIN (
        SELECT *
        FROM Y
    ) AS j
    ON s.id = j.id
ORDER BY
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC,
    j.id ASC,
    j.y_a ASC,
    j.y_b ASC;

SELECT
    X.*,
    Y.*
FROM
    X
INNER JOIN Y
    ON X.id + 1 = Y.id + 1
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    X.*,
    Y.*
FROM
    X
LEFT JOIN Y
    ON X.id = Y.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    s.*,
    j.*
FROM
    (
        SELECT *
        FROM X
    ) AS s
LEFT JOIN (
        SELECT *
        FROM Y
    ) AS j
    ON s.id = j.id
ORDER BY
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC,
    j.id ASC,
    j.y_a ASC,
    j.y_b ASC;

SELECT
    X.*,
    Y.*
FROM
    X
LEFT JOIN Y
    ON X.id + 1 = Y.id + 1
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    X.*,
    Y.*
FROM
    X
RIGHT JOIN Y
    ON X.id = Y.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    s.*,
    j.*
FROM
    (
        SELECT *
        FROM X
    ) AS s
RIGHT JOIN (
        SELECT *
        FROM Y
    ) AS j
    ON s.id = j.id
ORDER BY
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC,
    j.id ASC,
    j.y_a ASC,
    j.y_b ASC;

SELECT
    X.*,
    Y.*
FROM
    X
FULL JOIN Y
    ON X.id = Y.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC;

SELECT
    s.*,
    j.*
FROM
    (
        SELECT *
        FROM X
    ) AS s
FULL JOIN (
        SELECT *
        FROM Y
    ) AS j
    ON s.id = j.id
ORDER BY
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC,
    j.id ASC,
    j.y_a ASC,
    j.y_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
INNER JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
INNER JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.x_b = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
INNER JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    Y.*,
    s.*
FROM
    Y
INNER JOIN (
        SELECT *
        FROM Y
    ) AS s
    ON concat('n', Y.y_a) = s.y_b
ORDER BY
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC,
    s.id ASC,
    s.y_a ASC,
    s.y_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
LEFT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
LEFT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.x_b = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
LEFT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    Y.*,
    s.*
FROM
    Y
LEFT JOIN (
        SELECT *
        FROM Y
    ) AS s
    ON concat('n', Y.y_a) = s.y_b
ORDER BY
    Y.id ASC,
    Y.y_a ASC,
    Y.y_b ASC,
    s.id ASC,
    s.y_a ASC,
    s.y_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
RIGHT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
RIGHT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.x_b = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
RIGHT JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
FULL JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.id
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
FULL JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.x_b = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

SELECT
    X.*,
    s.*
FROM
    X
FULL JOIN (
        SELECT *
        FROM X
    ) AS s
    ON X.id = s.x_b
ORDER BY
    X.id ASC,
    X.x_a ASC,
    X.x_b ASC,
    s.id ASC,
    s.x_a ASC,
    s.x_b ASC;

--select 'self full nullable vs not nullable 2';
--select Y.*, s.* from Y full join (select * from Y) as s on concat('n', Y.y_a) = s.y_b order by id;
DROP TABLE X;

DROP TABLE Y;