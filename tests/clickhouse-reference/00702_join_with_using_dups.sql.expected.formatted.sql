DROP TABLE IF EXISTS X;

DROP TABLE IF EXISTS Y;

CREATE TABLE X
(
    id Int32,
    x_name String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE Y
(
    id Int32,
    y_name String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO X (id, x_name);

INSERT INTO Y (id, y_name);

SELECT
    X.*,
    Y.*
FROM
    X
INNER JOIN Y
    USING (id)
ORDER BY
    X.id ASC,
    Y.id ASC,
    X.x_name ASC,
    Y.y_name ASC;

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
    USING (id)
ORDER BY
    s.id ASC,
    s.id ASC,
    s.x_name ASC,
    j.y_name ASC;

SELECT
    X.*,
    Y.*
FROM
    X
LEFT JOIN Y
    USING (id)
ORDER BY
    X.id ASC,
    Y.id ASC,
    X.x_name ASC,
    Y.y_name ASC;

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
    USING (id)
ORDER BY
    s.id ASC,
    j.id ASC,
    s.x_name ASC,
    j.y_name ASC;

SELECT
    X.*,
    Y.*
FROM
    X
RIGHT JOIN Y
    USING (id)
ORDER BY
    X.id ASC,
    Y.id ASC,
    X.x_name ASC,
    Y.y_name ASC;

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
    USING (id)
ORDER BY
    s.id ASC,
    j.id ASC,
    s.x_name ASC,
    j.y_name ASC;

SELECT
    X.*,
    Y.*
FROM
    X
FULL JOIN Y
    USING (id)
ORDER BY
    X.id ASC,
    Y.id ASC,
    X.x_name ASC,
    Y.y_name ASC;

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
    USING (id)
ORDER BY
    s.id ASC,
    j.id ASC,
    s.x_name ASC,
    j.y_name ASC;

DROP TABLE X;

DROP TABLE Y;