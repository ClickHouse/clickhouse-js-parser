DROP TABLE IF EXISTS X;

DROP TABLE IF EXISTS Y;

CREATE TABLE X
(
    id Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE Y
(
    id Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO X (id);

INSERT INTO Y (id);

SET join_use_nulls = '0';

SELECT
    X.id,
    Y.id
FROM
    X
RIGHT JOIN Y
    ON X.id = Y.id
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
FULL JOIN Y
    ON Y.id = X.id
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
RIGHT JOIN Y
    ON X.id = Y.id - 1
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
FULL JOIN Y
    ON Y.id - 1 = X.id
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
RIGHT JOIN Y
    ON X.id + 1 = Y.id
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
FULL JOIN Y
    ON Y.id = X.id + 1
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
RIGHT JOIN Y
    ON X.id + 1 = Y.id + 1
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT
    X.id,
    Y.id
FROM
    X
FULL JOIN Y
    ON Y.id + 1 = X.id + 1
ORDER BY
    X.id ASC,
    Y.id ASC;

SELECT '----';

SET join_use_nulls = '1';

DROP TABLE X;

DROP TABLE Y;