-- https://github.com/ClickHouse/ClickHouse/issues/4567
SET enable_analyzer = '1';

DROP TABLE IF EXISTS fact;

DROP TABLE IF EXISTS animals;

DROP TABLE IF EXISTS colors;

CREATE TABLE fact
(
    id Int64,
    animal_key Int64,
    color_key Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO fact;

CREATE TABLE animals
(
    animal_key UInt64,
    animal_name String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO animals;

CREATE TABLE colors
(
    color_key UInt64,
    color_name String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO colors;

SELECT
    id,
    animal_name,
    a.animal_key,
    color_name,
    color_key
FROM
    fact AS a
LEFT JOIN (
        SELECT
            toInt64(animal_key) AS animal_key,
            animal_name
        FROM animals
    ) AS b
    ON a.animal_key = b.animal_key
LEFT JOIN (
        SELECT
            toInt64(color_key) AS color_key,
            color_name
        FROM colors
    ) AS c
    ON a.color_key = c.color_key; -- { serverError AMBIGUOUS_IDENTIFIER }

SELECT
    id,
    animal_name,
    animal_key,
    color_name,
    color_key
FROM
    fact AS a
LEFT JOIN (
        SELECT
            toInt64(animal_key) AS animal_key,
            animal_name
        FROM animals
    ) AS b
    ON a.animal_key = b.animal_key
LEFT JOIN (
        SELECT
            toInt64(color_key) AS color_key,
            color_name
        FROM colors
    ) AS c
    ON a.color_key = c.color_key; -- { serverError AMBIGUOUS_IDENTIFIER }