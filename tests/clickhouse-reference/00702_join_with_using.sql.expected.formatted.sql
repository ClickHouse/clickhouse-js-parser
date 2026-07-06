DROP TABLE IF EXISTS using1;

DROP TABLE IF EXISTS using2;

CREATE TABLE using1
(
    a UInt8,
    b UInt8
)
ENGINE = Memory();

CREATE TABLE using2
(
    a UInt8,
    b UInt8
)
ENGINE = Memory();

INSERT INTO using1;

INSERT INTO using2;

SELECT *
FROM
    using1
ALL LEFT JOIN (
        SELECT *
        FROM using2
    ) AS js2
    USING (a, b)
ORDER BY a ASC;

DROP TABLE using1;

DROP TABLE using2;

--
DROP TABLE IF EXISTS persons;

DROP TABLE IF EXISTS children;

CREATE TABLE persons
(
    id String,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE children
(
    id String,
    childName String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO persons (id, name);

INSERT INTO children (id, childName);

SELECT *
FROM
    persons
ALL INNER JOIN children
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

SELECT *
FROM
    persons
ALL INNER JOIN (
        SELECT *
        FROM children
    ) AS j
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

SELECT *
FROM
    (
        SELECT *
        FROM persons
    ) AS s
ALL INNER JOIN (
        SELECT *
        FROM children
    ) AS j
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

--
SET joined_subquery_requires_alias = '0';

SELECT *
FROM
    persons
ALL INNER JOIN (
        SELECT *
        FROM children
    )
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

SELECT *
FROM
    (
        SELECT *
        FROM persons
    )
ALL INNER JOIN (
        SELECT *
        FROM children
    )
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

SELECT *
FROM
    (
        SELECT *
        FROM persons
    ) AS s
ALL INNER JOIN (
        SELECT *
        FROM children
    )
    USING (id)
ORDER BY
    id ASC,
    name ASC,
    childName ASC;

DROP TABLE persons;

DROP TABLE children;