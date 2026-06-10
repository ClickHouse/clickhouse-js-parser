DROP TABLE IF EXISTS l;

DROP TABLE IF EXISTS r;

CREATE TABLE l
(
    luid Nullable(Int16),
    name String
)
ENGINE = MergeTree()
ORDER BY luid
SETTINGS allow_nullable_key = '1' AS
SELECT *
FROM VALUES((1231, 'John'), (6666, 'Ksenia'), (NULL, '---'));

CREATE TABLE r
(
    ruid Nullable(Int16),
    name String
)
ENGINE = MergeTree()
ORDER BY ruid
SETTINGS allow_nullable_key = '1' AS
SELECT *
FROM VALUES((1231, 'John'), (1232, 'Johny'));

SELECT *
FROM
    l
FULL JOIN r
    ON l.luid = r.ruid
WHERE luid IS NULL
    AND ruid IS NOT NULL;

SELECT *
FROM (
        SELECT *
        FROM
            l
        FULL JOIN r
            ON l.luid = r.ruid
    )
WHERE luid IS NULL
    AND ruid IS NOT NULL;

SELECT *
FROM (
        SELECT *
        FROM
            l
        FULL JOIN r
            ON l.luid = r.ruid
        LIMIT 100000000
    )
WHERE luid IS NULL
    AND ruid IS NOT NULL;

DROP TABLE l;

DROP TABLE r;

CREATE TABLE l
(
    luid Nullable(Int16),
    name String
)
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM VALUES((1231, 'John'), (6666, 'Ksenia'), (NULL, '---'));

CREATE TABLE r
(
    ruid Nullable(Int16),
    name String
)
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM VALUES((1231, 'John'), (1232, 'Johny'));